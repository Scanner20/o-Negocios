**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\admnovis.vcx
**************************************************


**************************************************
*-- Class:        _custom (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   05/23/00 09:12:02 AM
*-- Foundation Custom class.
*
DEFINE CLASS _custom AS custom


	Height = 22
	Width = 24
	*-- Version property.
	cversion = ""
	*-- Bulder property.
	builder = ""
	*-- BuilderX property.
	builderx = (HOME()+"Wizards\BuilderD,BuilderDForm")
	*-- Returns the number of items in the object reference array property aObjectRefs.
	nobjectrefcount = 0
	*-- Object reference to host object (generally THISFORM), which is automatically set on Init if lSetHost is .T.
	ohost = .NULL.
	*-- Variant result property for internal usage when calling programs in PRGs and a return file is required.
	vresult = .T.
	*-- Program to be called when when setting an object references via the SetObjectRef method.
	csetobjrefprogram = (IIF(VERSION(2)=0,"",HOME()+"FFC\")+"SetObjRf.prg")
	ninstances = 0
	Name = "_custom"

	*-- Specifies if custom FFC builder is automatically launched when instance is added to a container in design mode, even if the control pallette Builder Lock button is off.
	lautobuilder = .F.

	*-- Specifiies if the SetObjectRefs method is automatically called from the Init method.
	lautosetobjectrefs = .F.

	*-- Indicates the object's Release method has been executed and the object is in the process of being released from memory.
	lrelease = .F.

	*-- Specifies if the default FFC error handler is executed when an error occurs.
	lignoreerrors = .F.

	*-- Specifies if the SetHost method is automatically called from the Init method to set the oHost property to THISFORM.
	lsethost = .F.

	*-- Array of object references properties.
	DIMENSION aobjectrefs[1,3]


	*-- Releases object from memory.
	PROCEDURE release
		LOCAL lcBaseClass

		IF this.lRelease
			NODEFAULT
			RETURN .F.
		ENDIF
		this.lRelease=.T.
		lcBaseClass=LOWER(this.BaseClass)
		this.oHost=.NULL.
		this.ReleaseObjRefs
		IF NOT INLIST(lcBaseClass+" ","form ","formset ","toolbar ")
			RELEASE this
		ENDIF
	ENDPROC


	*-- Set object reference to specific property.
	PROCEDURE setobjectref
		LPARAMETERS tcName,tvClass,tvClassLibrary
		LOCAL lvResult

		this.vResult=.T.
		DO (this.cSetObjRefProgram) WITH (this),(tcName),(tvClass),(tvClassLibrary)
		lvResult=this.vResult
		this.vResult=.T.
		RETURN lvResult
	ENDPROC


	*-- Place holder method for listing SetObjectRef method calls.
	PROCEDURE setobjectrefs
		LPARAMETERS toObject

		RETURN
	ENDPROC


	*-- Releases all object references of aObjectRefs array.
	PROCEDURE releaseobjrefs
		LOCAL lcName,oObject,lnCount

		IF this.nObjectRefCount=0
			RETURN
		ENDIF
		FOR lnCount = this.nObjectRefCount TO 1 STEP -1
			lcName=this.aObjectRefs[lnCount,1]
			IF EMPTY(lcName) OR NOT PEMSTATUS(this,lcName,5) OR TYPE("this."+lcName)#"O"
				LOOP
			ENDIF
			oObject=this.&lcName
			IF ISNULL(oObject)
				LOOP
			ENDIF
			IF TYPE("oObject")=="O" AND NOT ISNULL(oObject) AND PEMSTATUS(oObject,"Release",5)
				oObject.Release
			ENDIF
			IF NOT ISNULL(oObject) AND PEMSTATUS(oObject,"oHost",5)
				oObject.oHost=.NULL.
			ENDIF
			this.&lcName=.NULL.
			oObject=.NULL.
		ENDFOR
		DIMENSION this.aObjectRefs[1,3]
		this.aObjectRefs=""
	ENDPROC


	*-- Access method for nObjectRefCount property.
	PROCEDURE nobjectrefcount_access
		LOCAL lnObjectRefCount

		lnObjectRefCount=ALEN(this.aObjectRefs,1)
		IF lnObjectRefCount=1 AND EMPTY(this.aObjectRefs[1])
			lnObjectRefCount=0
		ENDIF
		RETURN lnObjectRefCount
	ENDPROC


	*-- Assign method for nObjectRefCount property.
	PROCEDURE nobjectrefcount_assign
		LPARAMETERS m.vNewVal

		ERROR 1743
	ENDPROC


	*-- Set oHost property to form reference object.
	PROCEDURE sethost
		this.oHost=IIF(TYPE("thisform")=="O",thisform,.NULL.)
	ENDPROC


	*-- Returns new instance of object.
	PROCEDURE newinstance
		LPARAMETERS tnDataSessionID
		LOCAL oNewObject,lnLastDataSessionID

		lnLastDataSessionID=SET("DATASESSION")
		IF TYPE("tnDataSessionID")=="N" AND tnDataSessionID>=1
			SET DATASESSION TO tnDataSessionID
		ENDIF
		oNewObject=NEWOBJECT(this.Class,this.ClassLibrary)
		SET DATASESSION TO (lnLastDataSessionID)
		RETURN oNewObject
	ENDPROC


	*-- Dummy code for adding files to project.
	PROTECTED PROCEDURE addtoproject
		*-- Dummy code for adding files to project.
		RETURN

		*-- DO SetObjRf.prg
	ENDPROC


	PROCEDURE ninstances_access
		LOCAL laInstances[1]

		RETURN AINSTANCE(laInstances,this.Class)
	ENDPROC


	PROCEDURE ninstances_assign
		LPARAMETERS vNewVal

		ERROR 1743
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		LOCAL lcOnError,lcErrorMsg,lcCodeLineMsg

		IF this.lIgnoreErrors
			RETURN .F.
		ENDIF
		lcOnError=UPPER(ALLTRIM(ON("ERROR")))
		IF NOT EMPTY(lcOnError)
			lcOnError=STRTRAN(STRTRAN(STRTRAN(lcOnError,"ERROR()","nError"), ;
					"PROGRAM()","cMethod"),"LINENO()","nLine")
			&lcOnError
			RETURN
		ENDIF
		lcErrorMsg=MESSAGE()+CHR(13)+CHR(13)+this.Name+CHR(13)+ ;
				"Error:           "+ALLTRIM(STR(nError))+CHR(13)+ ;
				"Method:       "+LOWER(ALLTRIM(cMethod))
		lcCodeLineMsg=MESSAGE(1)
		IF BETWEEN(nLine,1,100000) AND NOT lcCodeLineMsg="..."
			lcErrorMsg=lcErrorMsg+CHR(13)+"Line:            "+ALLTRIM(STR(nLine))
			IF NOT EMPTY(lcCodeLineMsg)
				lcErrorMsg=lcErrorMsg+CHR(13)+CHR(13)+lcCodeLineMsg
			ENDIF
		ENDIF
		WAIT CLEAR
		MESSAGEBOX(lcErrorMsg,16,_screen.Caption)
		ERROR nError
	ENDPROC


	PROCEDURE Init
		IF this.lSetHost
			this.SetHost
		ENDIF
		IF this.lAutoSetObjectRefs AND NOT this.SetObjectRefs(this)
			RETURN .F.
		ENDIF
	ENDPROC


	PROCEDURE Destroy
		IF this.lRelease
			RETURN .F.
		ENDIF
		this.lRelease=.T.
		this.ReleaseObjRefs
		this.oHost=.NULL.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: _custom
**************************************************


**************************************************
*-- Class:        _mouseoverfx (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  _custom (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- BaseClass:    custom
*-- Time Stamp:   01/01/03 02:45:01 PM
*-- Efectos de resaltar un objeto de VFP
*
DEFINE CLASS _mouseoverfx AS _custom


	*-- Whether mouse is over mousefx host.
	lmouseoverhost = .T.
	PROTECTED ocurrentcoolcontrol
	ocurrentcoolcontrol = (NULL)
	*-- Extra border between control and highlight.
	nmargin = 2
	*-- Width of highlight.
	nhighlightwidth = 2
	*-- Color code for highlight.
	ihighlightcolor = 0
	*-- Color code for shadow.
	ishadowcolor = 0
	Name = "_mouseoverfx"
	PROTECTED ohost


	*-- Cancels highlighting of object.
	PROCEDURE cancelhighlight
		IF NOT THIS.lMouseOverHost
		   THIS.lMouseOverHost = .T.
		   THIS.oCurrentCoolControl = .NULL.
		   IF TYPE("THIS.oHost.Name") = "C"
		      * the form could be in the process of releasing...   
		      THIS.oHost.Cls
		   ENDIF
		   RETURN .T.
		ELSE
		   RETURN .F.   
		ENDIF
	ENDPROC


	*-- Called in mousemove event of object desiring coolbar highlighting.
	PROCEDURE highlightme
		LPARAMETERS toObject

		ASSERT VARTYPE(toObject) = "O" AND UPPER(toObject.BaseClass) # "FORM"
		* it won't actually hurt anything if it's called from the form, 
		* I guess
		* but it doesn't make any sense either

		IF TYPE("toObject.Name") # "C"
		  RETURN .F.
		ENDIF  

		LOCAL llNewObject

		THIS.lMouseOverHost = .F.  

		llNewObject = ISNULL(THIS.oCurrentCoolControl) OR ;
		              ((NOT(ISNULL(THIS.oCurrentCoolControl))) AND ;
		               THIS.oCurrentCoolControl # toObject )
		              * we'd have to do this comparison differently in VFP5... 

		IF NOT llNewObject
		   RETURN .F.
		ENDIF              

		LOCAL liDrawWidth, liDrawStyle, liDrawMode, liForeColor, liScaleMode, ;
		      lnOTCTop, lnOTCLeft, lnOTCWidth, lnOTCHeight, ;
		      liHighlightColor, liShadowColor

		IF NOT ISNULL(THIS.oCurrentCoolControl)
		   THIS.oHost.Cls && get rid of old highlight
		ENDIF
		THIS.oCurrentCoolControl = toObject

		WITH THIS.oHost 
		      
		   * save host properties:
		   liDrawWidth = .DrawWidth
		   liDrawStyle = .DrawStyle
		   liDrawMode  = .DrawMode
		   liForeColor = .ForeColor
		   liScaleMode = .ScaleMode
		      
		   * set host properties:
		   .DrawWidth = THIS.nHighlightWidth
		   .DrawStyle = 0 && solid
		   .DrawMode = 13 && copy
		   .ScaleMode = 3 && pixels
		            
		   * get object positioning relative to host and
		   * leave some room for the highlight:
		   lnOTCTop = OBJTOCLIENT(toObject,1) - THIS.nMargin
		   lnOTCLeft = OBJTOCLIENT(toObject,2) - THIS.nMargin
		   lnOTCWidth = OBJTOCLIENT(toObject,3) + THIS.nMargin * 2
		   lnOTCHeight = OBJTOCLIENT(toObject,4) + THIS.nMargin * 2

		   * border the current control with four lines
		   * in the appropriate colors
		   .ForeColor = THIS.iHighlightColor
		   * left control border     
		   .Line(lnOTCLeft,lnOTCTop,lnOTCLeft,lnOTCTop+lnOTCHeight)     
		   * top control border
		   .Line(lnOTCLeft,lnOTCTop,lnOTCLeft+lnOTCWidth,lnOTCTop)     
		   
		   .ForeColor = THIS.iShadowColor
		   * bottom control border
		   .Line(lnOTCLeft,lnOTCTop+lnOTCHeight,lnOTCLeft+lnOTCWidth,lnOTCTop+lnOTCHeight)
		   * right control border
		   .Line(lnOTCLeft+lnOTCWidth,lnOTCTop,lnOTCLeft+lnOTCWidth,lnOTCTop+lnOTCHeight)     
		 
		   * restore host properties:      
		   .DrawWidth = liDrawWidth
		   .DrawStyle = liDrawStyle
		   .DrawMode  = liDrawMode
		   .ForeColor = liForeColor
		   .ScaleMode = liScaleMode
		   
		ENDWITH
	ENDPROC


	PROCEDURE Init
		IF NOT DODEFAULT()
		   RETURN .F.
		ENDIF   

		IF TYPE("THISFORM") = "O"
		   THIS.oHost = THISFORM
		ELSE
		   THIS.oHost = _SCREEN
		ENDIF      

		* get appropriate color information
		DECLARE INTEGER GetSysColor in win32api integer  
		THIS.iHighlightColor = GetSysColor(20) && button highlight   
		THIS.iShadowColor = GetSysColor(16) && button shadow
	ENDPROC


	PROCEDURE Destroy
		DODEFAULT()
		STORE .NULL. TO THIS.oCurrentCoolControl, THIS.oHost
	ENDPROC


ENDDEFINE
*
*-- EndDefine: _mouseoverfx
**************************************************


**************************************************
*-- Class:        base_grid (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   05/09/18 03:10:05 PM
*
DEFINE CLASS base_grid AS custom


	Height = 28
	Width = 33
	*-- Contiene la referencia de la Grid a la cual va ha configurar
	ogrid = ""
	*-- Contiene el Codigo de Entidad de la cual va a construir dinamicamente el oGrid
	ccodigoentidad = ""
	*-- Contiene el Nombre de la entidad de la cual se basa la Grid Dinamica
	cnombreentidad = ""
	*-- Nombre del cursor que retorna la sentencia SELECT
	caliascursor = ""
	*-- Contiene el nombre del cursor de las columnas a mostrar en la Grid
	caliascolumnas = ""
	*-- Guarda la sentencia SQL generada
	csql = ""
	*-- Contiene la Sentencia Where generada para criterios de busqueda
	HIDDEN cwhere
	cwhere = ""
	*-- Contiene el objeto cmdHelp que invoca una ayuda
	ohelp = ""
	*-- Contiene los valores de las claves de la plantilla desde donde se cargaran los atributos para el Grid (ATRIBUTO-VALOR)
	cclaveplantilla = ""
	*-- Indica la entidad de donde se extrae los valores de los atributos segun plantilla. (ATRIBUTO-VALOR)
	centidadorigenatributos = ""
	*-- Indica la entidad a la cual se enviaran los valore de los atributos ingresados. (ATRIBUTO-VALOR)
	centidaddestinoatributos = ""
	*-- Arreglo de Campos clave de la entidad Origen (ATRIBUTO-VALOR)
	ccamposclaveorigen = ""
	*-- Cadena de campos clave destino de la entidad destino (ATRIBUTO-VALOR)
	ccamposclavedestino = ""
	*-- Cadena de valores de los campos claves de la entidad Origen (ATRIBUTO-VALOR)
	cvaloresclaveorigen = ""
	*-- Cadena de valores de los campos claves de la entidad destino (ATRIBUTO-VALOR)
	cvaloresclavedestino = ""
	*-- Es el alias del cursor generado para mostrar los Atributos y sus valores (ATRIBUTO-VALOR)
	caliasatributos = ""
	*-- Nombres de los campos que contienen los valores en una tabla ATRIBUTO-VALOR
	ccamposedicionorigen = ""
	*-- Es una cadena de campos que los cuales contienen los valores para obtener
	ccamposediciondestino = ""
	*-- Indica que los metodos Assign no se ejecutarán en su totalidad
	HIDDEN lflag_assign
	lflag_assign = .T.
	*-- Se ingresa sentencia para la Clausua WHERE en lenguaje SQL (incluir operador AND,OR)
	cwheresql = ""
	*-- Configura para que la Grid de Ayuda de Codigos permita selección multiple de códigos
	lmultiselect = .F.
	*-- Retorna el Num. de los Atributos que contienen Valores (ATRIBUTO-VALOR)
	nregistros = 0
	*-- Retorna el Nro. de Criterios de Selección definidos
	ncriterios = 0
	*-- Contiene una cadena literal de los criterios de selección por ATRIBUTO-VALOR
	cliteralatributos = ""
	cliteralcriterios = ""
	*-- Indica los valores por defecto de cada campo de edición. (CRITERIOS SELECCION)
	cvaloresdefault = ""
	*-- Indica los nombres de los atributos que se llenaran con los valores por defecto. (CRITERIOS DE SELECCION)
	catributosdefault = ""
	*-- Son los tipos de datos de los campos de edicion, si se omite se asume CHAR
	ctipodatocamposedicion = ""
	corderby = ""
	*-- Contiene expresion para la clausula HAVING
	lhaving = .F.
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="lhaving" type="property" display="lHaving"/><memberdata name="chavingsql" type="property" display="cHavingSql"/><memberdata name="chavingsql_assign" type="property" display="cHavingSql_Assign"/></VFPData>]
	*-- Expresion a utilizar en la clausula HAVING
	chavingsql = ([])
	lservidor = .F.
	*-- Filtro inicial (Where , WhereSql , HavingSql)
	cwheresql_ini = ([])
	Name = "base_grid"

	*-- Indica que se debe de respetar la configuración de la Grilla hecha en tiempo de Diseño para la Grilla de Consulta
	ldinamicgrid = .F.

	*-- Indica que la Consulta debe tener la clausula DISTINCT
	ldistinct = .F.

	*-- Indica el numero del ultimo error ocurrido
	nerror = .F.

	*-- Indica el Tipo del Ultimo Error Ocurrido
	ntipoerror = .F.

	*-- Contiene el mensaje del ultimo error generado
	cmensajeerror = .F.

	*-- Es una matriz con los campos de Edicion para la tabla de Destno ATRIBUTO-VALOR
	HIDDEN acamposediciondestino[1]

	*-- Una matriz con los campo Clave de la tabla de Origen [ATRIBUTO-VALOR]
	HIDDEN acamposclaveorigen[1]

	*-- Una matriz que contiene los campos Clave de la tabla de Destino [ATRIBUTO-VALOR]
	HIDDEN acamposclavedestino[1]

	*-- Contiene los valores de los campos clave de la tabla de Destino para ATRIBUTO-VALOR
	HIDDEN avaloresclavedestino[1]

	*-- Es una matriz con los campos de Edicion para la tabla de Origen ATRIBUTO-VALOR
	HIDDEN acamposedicionorigen[1]

	*-- Contiene los valores de los campos clave de la tabla de Origen para ATRIBUTO-VALOR
	HIDDEN avaloresclaveorigen[1]

	*-- Es una matriz que genera a partir de cValoresDefault
	HIDDEN avaloresdefault[1]

	*-- Es una matriz que se genera a partir de la propiedad cAtributosFiltro
	HIDDEN aatributosdefault[1]

	*-- Es una matriz que contiene los tipos de datos de los campos de edicion segun la propiedad cTipoDatoCampoEdicion
	HIDDEN atipodatocamposedicion[1]


	*-- Recibe como parametro el objeto Grid que se va a trabajar en forma dinamica
	PROCEDURE vinculargrid
		LPARAMETER toGrid, toHelp
		*!*	El valor del parámetro es un objeto Grid, el cual se pasa por referencia para
		*!*	actualizar sus valores y contenido.

		IF !( VARTYPE(toGrid)=="O" AND toGrid.BASECLASS="Grid" )
			THIS.nError		= 1
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		THIS.oGrid = toGrid

		IF ( VARTYPE(toHelp)=="O" AND toHelp.BASECLASS=="Commandbutton" )
			THIS.oHelp			= toHelp
			THIS.cNombreEntidad = toHelp.cNombreEntidad
			THIS.cWhereSQL		= toHelp.cWhereSQL
			THISFORM.CAPTION	= toHelp.cTituloAyuda
			this.corderby 		= toHelp.cOrderby
		ELSE
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				FOR J=1 TO THIS.oGrid.COLUMNS(I).CONTROLCOUNT
					IF THIS.oGrid.COLUMNS(I).CONTROLS(J).BASECLASS = "Commandbutton"
						THIS.oHelp = THIS.oGrid.COLUMNS(I).CONTROLS(J)
						EXIT
					ENDIF
				ENDFOR
			ENDFOR
		ENDIF
		RETURN .T.
	ENDPROC


	*-- Construye la Grid dinamica basada en la Propiedad cCodigoEntidad o cNombreEntidad
	PROCEDURE configurargridconsulta
		LPARAMETERS tcWhere, tnAyuda

		EXTERNAL CLASS ADMVRS.VCX

		LOCAL lnParamtros , lnValores , lReturn

		lnParamtros	= PARAMETERS()

		*!*	Chequear Parámetros de Entrada
		DO CASE
			CASE lnParamtros = 0
				tcWhere	= ""
				tnAyuda	= 1
			CASE lnParamtros = 1
				tcWhere	= IIF(VARTYPE(tcWhere)=="C",ALLTRIM(tcWhere),"")
				tnAyuda	= 1
			CASE lnParamtros = 2
				tcWhere	= IIF(VARTYPE(tcWhere)=="C",ALLTRIM(tcWhere),"")
				tnAyuda	= IIF(VARTYPE(tnAyuda) == "L" , IIF(tnAyuda,1,2) , tnAyuda )
		ENDCASE

		THIS.cSQL = ""

		*!*	Chequear todas las propiedades que require el método
		*!*	-----------------------------------------------------
		IF NOT "ADMVRS" $ SET("CLASSLIB")
			*SET CLASSLIB TO _LIB_VARIOS_GEN ADDITIVE
			SET CLASSLIB TO ADMVRS ADDITIVE
		ENDIF

		IF !(VARTYPE(THIS.oGrid)=="O" AND THIS.oGrid.BASECLASS=="Grid")
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		*!*	-----------------------------------------------------

		lReturn	= THIS.GenerarColumnasConsulta( tnAyuda )

		IF  !lReturn	&& Ocurrio un Error en la ejecucion del método anterior
			THIS.oGrid.INIT()
			RETURN .F.
		ENDIF

		IF !USED(THIS.cAliasColumnas)		&& No esta en uso el cursor necesario
			THIS.nError		= 3
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		SELECT(THIS.cAliasColumnas)

		*!*	OJO	Contar cuantas columnas se deben de mostrar
		COUNT ALL TO lnColumnas FOR FlagMuestraGrid

		THIS.cSQL = THIS.GenerarSQL()

		*=MESSAGEBOX(THIS.cSQL)

		*!*	Configurar el Grid que mostrará los Datos
		SELECT(THIS.cAliasColumnas)


		WITH THIS.oGrid
			IF THIS.lDinamicGrid
				.COLUMNCOUNT = lnColumnas
			ENDIF
			.READONLY = .T.

			i=0
			GO TOP
			SCAN WHILE I < .COLUMNCOUNT

				*!*	OJO Verificar que la columna, es la que se debe de mostrar
				IF !FlagMuestraGrid AND !FlagAyuda
					LOOP
				ENDIF

				i = i + 1  && Número de Columnas

				IF THIS.lDinamicGrid	&& Me indica que debe de modificar el ancho de la columna
					.COLUMNS(i).WIDTH = LongitudCabecera
				ENDIF

				IF !EMPTY(MascaraDato) AND !ISNUL(MascaraDato) AND ;
						( ISNUL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
						( ISNUL(CodigoTabla) OR EMPTY(CodigoTabla) )
					IF NOT "@" $ MascaraDato
						.COLUMNS(i).INPUTMASK = ALLTRIM(MascaraDato)
					ENDIF
				ELSE
					IF ISNULL(LongitudCabeceraVisualizacion) OR ;
							EMPTY(LongitudCabeceraVisualizacion)
						IF THIS.lDinamicGrid	&& Me indica que debe de modificar el ancho de la columna
							.COLUMNS(i).WIDTH = 10
						ENDIF
					ELSE
						IF THIS.lDinamicGrid	&& Me indica que debe de modificar el ancho de la columna
							.COLUMNS(i).WIDTH = LongitudCabeceraVisualizacion
						ENDIF
					ENDIF
				ENDIF

				.COLUMNS(i).READONLY = .T.

				FOR j = 1 TO .COLUMNS(i).CONTROLCOUNT  && Numero de Controles contenidos en el Objeto Column
					IF	.COLUMNS(i).CONTROLS(j).BASECLASS == 'Header'
						IF THIS.lDinamicGrid	&& Me indica que debe de modificar el CAPTION de la columna
							.COLUMNS(i).CONTROLS(j).CAPTION = ALLTRIM(DescripcionCabecera)
							IF !ISNUL(CodigoEntidadCampo) OR !EMPTY(CodigoEntidadCampo)
								.COLUMNS(i).CONTROLS(j).CAPTION = ALLTRIM(DescCabeceraVisualizacion)
							ENDIF
							.COLUMNS(i).CONTROLS(j).Wordwrap = .T.
							.COLUMNS(i).CONTROLS(j).Alignment = 2
						ENDIF
					ENDIF
					IF	.COLUMNS(i).CONTROLS(j).BASECLASS == 'Textbox'
						.COLUMNS(i).CONTROLS(j).FONTBOLD	= .F.
						.COLUMNS(i).CONTROLS(j).FONTSIZE	= 8
					ENDIF
				ENDFOR
			ENDSCAN

			*!*	Columna de Múltiple Selección
			IF THIS.lMultiSelect
				IF .COLUMNS(.COLUMNCOUNT).CURRENTCONTROL <> "chkColumn"
					.COLUMNCOUNT = .COLUMNCOUNT + 1
					.COLUMNS(.COLUMNCOUNT).NEWOBJECT("chkColumn","base_Checkbox_Multiselect")
					.COLUMNS(.COLUMNCOUNT).CURRENTCONTROL = "chkColumn"
					.COLUMNS(.COLUMNCOUNT).CONTROLS(1).CAPTION = "a"
					.COLUMNS(.COLUMNCOUNT).CONTROLS(1).FONTSIZE = 12
					.COLUMNS(.COLUMNCOUNT).CONTROLS(1).FONTNAME = "Marlett"
					.COLUMNS(.COLUMNCOUNT).SPARSE = .F.
					.COLUMNS(.COLUMNCOUNT).WIDTH = 18
					*!*	Alterna registros blancos y verdes.
					.SETALL("DynamicBackColor","IIF(Multiselect=0, RGB(255,255,255), RGB(210,210,210))","Column")
				ENDIF
			ENDIF
			.VISIBLE = .T.
			.INIT()
		ENDWITH
		*** Actualizamos el ancho del formulario contenendor **
		LnTotAncho=0
		IF THIS.PARENT.Baseclass=="Form"
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				LnTotAncho = LnTotAncho +	THIS.oGrid.COLUMNS(I).WIDTH 
			ENDFOR
			IF LnTotAncho>0 AND LnTotAncho>This.Parent.Width 
				This.Parent.Width = LnTotAncho + 20
			ENDIF
		ENDIF

		***

		RETURN .T.
	ENDPROC


	*-- Valida la asignación de las propiedades cCodigoEntidad y cNombreEntidad
	HIDDEN PROCEDURE validarparametros
		*!*	Obtiene el codigo de la entidad o el nombre completo de la entidad
		LPARAMETERS tcCodigoEntidad , tcNombreEntidad
		LOCAL laEntidad

		IF  (EMPTY(tcCodigoEntidad) OR ISNULL(tcCodigoEntidad)) AND ;
			(EMPTY(tcNombreEntidad) OR ISNULL(tcNombreEntidad))
			THIS.nError		= 5
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		DIMENSION laEntidad[1]
		STORE SPACE(0) TO laEntidad
		IF !GOENTORNO.SQLENTORNO
			*** aQUI TE QUIERO VER PUES RECON ,,,,,,
			DO CASE

				CASE !EMPTY(tcNombreEntidad) AND !ISNULL(tcNombreEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath + "GEntidades" ;
						WHERE UPPER(ALLTRIM(NombreEntidad)) == UPPER(ALLTRIM(tcNombreEntidad)) ;
						INTO ARRAY laEntidad

				CASE !EMPTY(tcCodigoEntidad) AND !ISNULL(tcCodigoEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath+"GEntidades" ;
						WHERE CodigoEntidad==tcCodigoEntidad ;
						INTO ARRAY laEntidad
			ENDCASE
			IF _TALLY > 0 AND TYPE("laEntidad[1,3]")=="C"
				tcCodigoEntidad	= laEntidad[1,4]
				*!*	Retorna	: Tabla
				tcNombreEntidad = ALLTRIM(laEntidad[1,3])

			ELSE
				IF USED("GEntidades")
					USE IN GEntidades
				ENDIF
				THIS.nError		= 5
				THIS.nTipoError	= 2
				THIS.MostrarError()
				RETURN .F.
			ENDIF
		ELSE
			DO CASE

				CASE !EMPTY(tcNombreEntidad) AND !ISNULL(tcNombreEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath + "GEntidades" ;
						WHERE UPPER(ALLTRIM(NombreEntidad)) == UPPER(ALLTRIM(tcNombreEntidad)) ;
						INTO ARRAY laEntidad

				CASE !EMPTY(tcCodigoEntidad) AND !ISNULL(tcCodigoEntidad)
					SELECT NombreServidor,NombreBaseDatos,NombreEntidad,CodigoEntidad ;
						FROM goEntorno.LocPath+"GEntidades" ;
						WHERE CodigoEntidad==tcCodigoEntidad ;
						INTO ARRAY laEntidad
			ENDCASE

			IF _TALLY > 0 AND TYPE("laEntidad[1,3]")=="C"
				tcCodigoEntidad	= laEntidad[1,4]
				DO CASE
				*!*	El servidor por defecto es diferente al que se obtuvo
				CASE UPPER(ALLTRIM(goConexion.Servidor)) <> UPPER(ALLTRIM(laEntidad[1,1]))
					*!*	Retorna	: Servidor.BaseDatos.dbo.Tabla
					tcNombreEntidad = ALLTRIM(laEntidad[1,1])+"."+ALLTRIM(laEntidad[1,2])+".dbo."+ALLTRIM(laEntidad[1,3])
				*!*	El servidor por defecto es igual al que se obtuvo, pero la Base de Datos es Diferente
				CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(laEntidad[1,1])) AND ;
					 UPPER(ALLTRIM(goConexion.BaseDatos))<> UPPER(ALLTRIM(laEntidad[1,2]))
					*!*	Retorna	: BaseDatos.dbo.Tabla
					tcNombreEntidad = ALLTRIM(laEntidad[1,2])+".dbo."+ALLTRIM(laEntidad[1,3])
				*!*	El servidor por defecto es igual al que se obtuvo, y la Base de Datos tambien
				CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(laEntidad[1,1])) AND ;
					 UPPER(ALLTRIM(goConexion.BaseDatos))== UPPER(ALLTRIM(laEntidad[1,2]))
					*!*	Retorna	: Tabla
					tcNombreEntidad = ALLTRIM(laEntidad[1,3])
				ENDCASE
			ELSE
				IF USED("GEntidades")
					USE IN GEntidades
				ENDIF
				THIS.nError		= 5
				THIS.nTipoError	= 2
				THIS.MostrarError()
				RETURN .F.
			ENDIF

		ENDIF


		IF USED("GEntidades")
			USE IN GEntidades
		ENDIF
		RETURN .T.
	ENDPROC


	*-- Genera el Cursor para la Grid dinamica
	PROCEDURE generarcursor
		*!*	Consulta al Servidor, y crea el cursor en el Cliente
		LPARAMETERS tcWhere
		** VETT: 2018/05/09 15:05:32 ** 
		this.cwheresql_ini = []
		** VETT: 2018/05/09 15:05:32 **

		LOCAL lcControlSource , lcValorField, LcCadenaSql

		IF	(!(VARTYPE(THIS.oGrid)=="O" AND THIS.oGrid.BASECLASS=="Grid") ) OR ;
			(EMPTY( THIS.cSQL ) OR ISNULL(THIS.cSQL))
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		IF ISNULL(tcWhere) OR EMPTY(tcWhere) OR VARTYPE(tcWhere)<>"C"
			tcWhere = ""
		ELSE
			tcWhere =  " AND (" + ALLTRIM( STRTRAN(tcWhere,'"',"'") ) +")"
			** VETT: 2018/05/09 15:10:13 **
			this.cwheresql_ini = TcWhere
		ENDIF

		THIS.oGrid.RECORDSOURCE = ""
		THIS.oGrid.RECORDSOURCETYPE = 4
		IF GoEntorno.SqlEntorno AND  THIS.lServidor
			goConexion.cSQL = THIS.cSQL + tcWhere + " " + THIS.cWhereSQL + " " + THIS.cHavingSql +  ; 
			 " ORDER BY " + IIF(ISNULL(THIS.cOrderBy) OR EMPTY(THIS.cOrderBy),"2",THIS.cOrderBy)
		ELSE
			LcCadenaSql 	= THIS.cSQL + tcWhere + " " + THIS.cWhereSQL + " " + THIS.cHavingSql +  ;
			" ORDER BY " + IIF(ISNULL(THIS.cOrderBy) OR EMPTY(THIS.cOrderBy),"2",THIS.cOrderBy)
		ENDIF
		** VETT: 2018/05/09 15:09:47 **
		this.cwheresql_ini  = this.cwheresql_ini + " " + THIS.cWhereSQL 
		 
		*!*	=strtofile(goConexion.cSQL,"c:\windows\escritorio\sql.txt")

		IF EMPTY(THIS.cAliasCursor) OR ISNULL(THIS.cAliasCursor)
			THIS.cAliasCursor = SYS(2015)
		ENDIF

		IF USED(THIS.cAliasCursor)
			USE IN (THIS.cAliasCursor)
		ENDIF
		*=MESSAGEBOX(goConexion.cSQL)
		IF GoEntorno.SqlEntorno  AND this.lServidor
			goConexion.cCursor = THIS.cAliasCursor
			lReturn = ( goConexion.DoSQL(THISFORM.DATASESSIONID) > 0 )
		ELSE
			LcCadenaSql = LcCadenaSql + ' INTO CURSOR '+ THIS.cAliasCursor + ' READWRITE'
			&LcCadenaSql.
			lReturn = .T.
		ENDIF
		IF lReturn	AND USED(THIS.cAliasCursor)	&& Ejecutó correctamente la Sentencia
			THIS.oGrid.RECORDSOURCETYPE = 1  && Alias
			THIS.oGrid.RECORDSOURCE 		= THIS.cAliasCursor
			SELECT(THIS.cAliasCursor)
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				lcValorField	= EVAL(FIELD(I))
				DO CASE
					CASE VARTYPE(lcValorField) == "T"
						lcControlSource	= "TTOD(" + THIS.cAliasCursor + "." + FIELD(I) + ")"
					OTHERWISE
						lcControlSource	= THIS.cAliasCursor + "." + FIELD(I)
				ENDCASE
				THIS.oGrid.COLUMNS(I).CONTROLSOURCE	= lcControlSource
			ENDFOR
			THIS.oGrid.REFRESH()
		ENDIF

		RETURN lReturn
	ENDPROC


	*-- Genera el cursor de Columnas para Configurar la Grid
	HIDDEN PROCEDURE generarcolumnasconsulta
		*!*	Extrae las columnas que se mostrarán en el Grid de Consulta
		LPARAMETERS tnAyuda

		LOCAL lcCodigoEntidad , lcNombreEntidad , lcCursor

		lcCodigoEntidad = THIS.cCodigoEntidad
		lcNombreEntidad = THIS.cNombreEntidad

		IF !EMPTY(THIS.cAliasColumnas) AND !ISNULL(THIS.cAliasColumnas) AND USED(THIS.cAliasColumnas)
			USE IN (THIS.cAliasColumnas)
			*THIS.cAliasColumnas = ""
			lcCursor = THIS.cAliasColumnas
		ELSE
			lcCursor = SYS(2015)
		ENDIF

		*lcCursor = SYS(2015)
		*lcCursor = THIS.cAliasColumnas

		IF !THIS.ValidarParametros( @lcCodigoEntidad , @lcNombreEntidad )
			RETURN .F.
		ENDIF

		THIS.cCodigoEntidad = lcCodigoEntidad
		THIS.cNombreEntidad = lcNombreEntidad

		DO CASE 
		*!*	Para pantalla de Consulta, Solo los marcados para "Mostrar en Consulta"
		CASE tnAyuda = 1
			SELECT *,IIF(FlagMuestraGrid,'0','1') AS Orden  ;
				FROM goEntorno.LocPath+"GEntidades_Detalle"  ;
				WHERE CodigoEntidad == THIS.cCodigoEntidad AND ( FlagMuestraGrid OR FlagConsultado ) ;
				ORDER BY Orden,OrdenColumna ;
				INTO CURSOR (lcCursor)
		*!*	Para pantalla de Ayuda, Solo los marcados para "Mostrar en Ayuda"
		CASE tnAyuda = 2
			SELECT *,IIF(FlagAyuda,'0','1') AS Orden  ; 
				FROM goEntorno.LocPath+"GEntidades_Detalle"  ;
				WHERE CodigoEntidad == THIS.cCodigoEntidad AND ( FlagAyuda OR FlagConsultado ) ;
				ORDER BY Orden,OrdenColumna ;
				INTO CURSOR (lcCursor)
		*!*	Para pantalla de Ayuda, Solo los marcados como "Campo de Retorno" y "Campo de Descripcion"
		CASE tnAyuda = 3 
			SELECT *  ;
				FROM goEntorno.LocPath+"GEntidades_Detalle"  ;
				WHERE CodigoEntidad == THIS.cCodigoEntidad AND ( FlagRetorno OR FlagVisualizacion ) ;
				ORDER BY FlagVisualizacion,OrdenColumna ;
				INTO CURSOR (lcCursor)
		ENDCASE

		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF

		THIS.cAliasColumnas = lcCursor

		IF EMPTY(_TALLY)
			THIS.nError		= 4
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		RETURN .T.
	ENDPROC


	HIDDEN PROCEDURE generarsql
		IF !USED(THIS.cAliasColumnas)		&& No esta en uso el cursor necesario
			THIS.nError		= 3
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	""
		ENDIF

		IF EMPTY(THIS.cNombreEntidad) OR ISNULL(THIS.cNombreEntidad)
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	""
		ENDIF

		SELECT(THIS.cAliasColumnas)
		GO TOP

		cSQL = "SELECT " + IIF(THIS.lDistinct , "DISTINCT ","")
		cColumn = ""

		SCAN
			DO CASE
					*!*	------------------------------------------------------------------------
					*!*	El campo es una clave que se valida en otra entidad, por ende debemos de
					*!*	generar la sentencia SQL para la subconsulta del campo
					*!*	------------------------------------------------------------------------
				CASE 	(!ISNULL(NombreEntidadCampo) AND !EMPTY(NombreEntidadCampo)) AND ;
						((ISNULL(Codigotabla) OR EMPTY(CodigoTabla)) AND ;
						!ISNULL(CampoVisualizacion) AND !EMPTY(CampoVisualizacion)) AND ;
						FlagExtraeDescripcion

					IF ISNULL(SecuenciaCampos) OR EMPTY(SecuenciaCampos)

						Tn = " T" +ALLTRIM( OrdenColumna )
						tcCampo = "( SELECT "+Tn+"."+ALLTRIM(CampoVisualizacion)+ ;
							" FROM "+ALLTRIM(NombreEntidadCampo)+ Tn + ;
							" WHERE T000."+ALLTRIM(NombreCampo) + ;
							" = " + Tn + "." + ALLTRIM(CampoRetorno) + " )"

						** por requerimiento de ALFREDO
						*cSQL = cSQL + ALLTRIM(CampoVisualizacion) + ALLTRIM(Tn) + " = " + tcCampo + " , "
						cSQL = cSQL + ALLTRIM(CampoVisualizacion) + " = " + tcCampo + " , "
						cColumn = cColumn + "T000."+ALLTRIM(NombreCampo) + " , "

					ELSE

						Tn = " T" +ALLTRIM( OrdenColumna )
						lcSecuenciaCampos = THIS.GenerarSecuenciaCampos(Tn)
						tcCampo = "( SELECT "+Tn+"."+ALLTRIM(CampoVisualizacion)+ ;
							" FROM "+ALLTRIM(NombreEntidadCampo)+ Tn + ;
							" WHERE T000."+ALLTRIM(NombreCampo) + ;
							" = " + Tn + "." + ALLTRIM(CampoRetorno) + lcSecuenciaCampos + " )"

						** por requerimiento de ALFREDO
						*cSQL = cSQL + ALLTRIM(CampoVisualizacion) + ALLTRIM(Tn) + " = " + tcCampo + " , "
						cSQL = cSQL + ALLTRIM(CampoVisualizacion) + " = " + tcCampo + " , "
						cColumn = cColumn + "T000."+ALLTRIM(NombreCampo) + " , "

					ENDIF

					*!*	------------------------------------------------------------------------
					*!*	El campo se valida en Tabla de Tablas, por ende debemos de validarlo
					*!*	en Gtablas_Detalle
					*!*	------------------------------------------------------------------------
				CASE !ISNULL(Codigotabla) AND !EMPTY(CodigoTabla) AND FlagExtraeDescripcion

					Tn = " T" +ALLTRIM( OrdenColumna )

					tcCampo = "( SELECT " +Tn+".DescripcionCortaArgumento" + ;
						" FROM " + ALLTRIM(goEntorno.RemotePathEntidad("GTablas_Detalle")) + Tn + ;
						" WHERE " + Tn + ".CodigoTabla = " + "'" + CodigoTabla+ "'" + ;
						" AND " + Tn+".ElementoTabla = T000." +ALLTRIM(NombreCampo)+ " )"

					cSQL	= cSQL + "DescripcionCortaArgumento" + ALLTRIM(Tn) + " = " + tcCampo + " , "
					cColumn = cColumn + "T000."+ALLTRIM(NombreCampo) + " , "

					*!*	------------------------------------------------------------------------
					*!*	En cualquier otro caso devolver solo el nombre del campo
					*!*	------------------------------------------------------------------------
				CASE VARTYPE(FlagSegunExpresion)='L' AND  FlagSegunExpresion AND !EMPTY(Expresion)

					cSQL = cSQL + ALLTRIM(Expresion) + ' AS '+ALLTRIM(NombreCampo) + " , "
				OTHERWISE
					cSQL = cSQL + "T000."+ALLTRIM(NombreCampo) + " , "

			ENDCASE

		ENDSCAN


		IF THIS.lMultiSelect
			cSQL = cSQL + cColumn + " 0 AS Multiselect "
		ELSE
			cSQL = cSQL + cColumn
			cSQL = LEFT(cSQL,LEN(cSQL)-3)
		ENDIF
		IF GOENTORNO.SqlEntorno AND this.lServidor
			cSQL = cSQL + " FROM " + THIS.cNombreEntidad + " T000 " + ;
				" WHERE T000.FlagEliminado = 0 "
		else
			cSQL = cSQL + " FROM " + goEntorno.RemotePathEntidad(THIS.cNombreEntidad) + " T000 " + ;
				" WHERE !deleted() "
		endif

		RETURN cSQL
	ENDPROC


	*-- Genera Cursor para el criterio de Busqueda
	HIDDEN PROCEDURE generarcolumnascriterios
		LPARAMETERS tnColumnas

		LOCAL lcCodigoEntidad , lcNombreEntidad , lcCursor , lcCursorTmp

		lcCodigoEntidad = THIS.cCodigoEntidad
		lcNombreEntidad = THIS.cNombreEntidad

		IF !EMPTY(THIS.cAliasColumnas) AND !ISNULL(THIS.cAliasColumnas) AND USED(THIS.cAliasColumnas)
			USE IN (THIS.cAliasColumnas)
			THIS.cAliasColumnas = ""
		ENDIF

		lcCursorTmp = SYS(2015)

		IF EMPTY(THIS.cAliasColumnas) OR ISNULL(THIS.cAliasColumnas)
			lcCursor = SYS(2015)
		ELSE
			lcCursor = THIS.cAliasColumnas
		ENDIF


		IF !THIS.ValidarParametros( @lcCodigoEntidad , @lcNombreEntidad )
			RETURN .F.
		ENDIF

		THIS.cCodigoEntidad = lcCodigoEntidad
		THIS.cNombreEntidad = lcNombreEntidad


		IF tnColumnas = 1
			*!*	Seleccionar todas las columnas que estan marcadas para "Criterio de Seleccion"
			SELECT	;
				DescripcionCampo,;
				SPACE(60) AS _ValorAtributo, ;
				SPACE(1) AS cmdAyuda,;
				SPACE(60) AS ValorAtributo , ;
				NombreCampo, ;
				SecuenciaCampos, ;
				TipodatoCampo,;
				CodigoAtributo,;
				CodigoEntidadCampo,;
				CampoVisualizacion,;
				Camporetorno,;
				NombreEntidadCampo,;
				Codigotabla,;
				LongitudDato,;
				MascaraDato,;
				ModoObtenerDatos,;
				FlagBusqueda,;
				0 AS FlagOrigenRemoto , ;
				.F. AS FlagDefault ;
			FROM ;
				goEntorno.LocPath+"GEntidades_Detalle"  ;
			WHERE ;
				CodigoEntidad == THIS.cCodigoEntidad AND FlagCriterio ;
			ORDER BY OrdenColumna ;
			INTO CURSOR (lcCursorTmp)
		ELSE
			*!*	Seleccionar todas las columnas (Para mantenimiento de Entidades)
			SELECT	;
				DescripcionCampo,;
				SPACE(60) AS _ValorAtributo, ;
				SPACE(1) AS cmdAyuda,;
				SPACE(60) AS ValorAtributo , ;
				NombreCampo, ;
				SecuenciaCampos, ;
				TipodatoCampo,;
				CodigoAtributo,;
				CodigoEntidadCampo,;
				CampoVisualizacion,;
				Camporetorno,;
				NombreEntidadCampo,;
				Codigotabla,;
				LongitudDato,;
				MascaraDato,;
				ModoObtenerDatos,;
				FlagBusqueda,;
				0 AS FlagOrigenRemoto , ;
				.F. AS FlagDefault ;
			FROM ;
				goEntorno.LocPath+"GEntidades_Detalle"  ;
			WHERE ;
				CodigoEntidad == THIS.cCodigoEntidad ;
			ORDER BY OrdenColumna ;
			INTO CURSOR (lcCursorTmp)
		ENDIF

		USE (DBF(lcCursorTmp)) IN 0 ALIAS (lcCursor) AGAIN
		USE IN (lcCursorTmp)

		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF

		THIS.cAliasColumnas = lcCursor

		IF EMPTY(_TALLY)
			THIS.nError		= 4
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		RETURN .T.
	ENDPROC


	PROCEDURE configurargridcriterios
		LPARAMETERS tcWhere, tnColumnas

		LOCAL lnParamtros , lnValores , lReturn , laValorAtributo

		lnParamtros	= PARAMETERS()

		*!*	Chequear Parámetros de Entrada
		DO CASE
			CASE lnParamtros = 0
				tcWhere		= ""
				tnColumnas	= 1
			CASE lnParamtros = 1
				tcWhere		= IIF(VARTYPE(tcWhere)=="C",ALLTRIM(tcWhere),"")
				tnColumnas	= 1
			CASE lnParamtros = 2
				tcWhere		= IIF(VARTYPE(tcWhere)=="C"		, ALLTRIM(tcWhere),"")
				tnColumnas	= IIF(VARTYPE(tnColumnas)== "L" , IIF(tnColumnas,1,2) , tnColumnas )
		ENDCASE

		THIS.cSQL = ""

		*!*	Chequear todas las propiedades que require el método
		*!*	-----------------------------------------------------
		IF !(VARTYPE(THIS.oGrid)=="O" AND THIS.oGrid.BASECLASS=="Grid")
			THIS.nError		= 2
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		*!*	-----------------------------------------------------

		THIS.oGrid.RECORDSOURCE		= ""
		THIS.oGrid.RECORDSOURCETYPE = 4  && SQL

		lReturn	= THIS.GenerarColumnasCriterios( tnColumnas )

		IF  !lReturn	&& Ocurrio un Error en la ejecucion del método anterior
			THIS.oGrid.INIT()
			RETURN .F.
		ENDIF

		IF !USED(THIS.cAliasColumnas)		&& No esta en uso el cursor necesario
			THIS.nError		= 3
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN	.F.
		ENDIF

		SELECT(THIS.cAliasColumnas)

		*!*	Configurar los Valores por defecto
		THIS.CargarValoresDefault()
		SELECT(THIS.cAliasColumnas)
		GO TOP

		WITH THIS.oGrid
			.INIT()
			.RECORDSOURCETYPE = 1  && Alias
			.RECORDSOURCE = THIS.cAliasColumnas
			.REFRESH()
			.VISIBLE = .T.
		ENDWITH
		RETURN .T.
	ENDPROC


	*-- Extrae los atributos de la Plantilla (ATRIBUTO-VALOR)
	PROCEDURE generarplantilla
		LPARAMETER txParam

		LOCAL lnPlantilla
		LOCAL lcCodigoEntidad , lcNombreEntidad , lcCamposEdicionOrigen

		*!*	Validar el parámetro especificado
		DO CASE
			CASE VARTYPE(txParam) == "C"	&& Pasó como parámetro un Nombre de Tabla
				lcNombreEntidad	= ALLTRIM(SUBSTR(txParam,RAT('.',txParam)+1))
				lcCodigoEntidad	= SPACE(0)
				THIS.ValidarParametros(@lcCodigoEntidad,@lcNombreEntidad)
				lnTipoPlantilla = 2
				IF EMPTY(lcCodigoEntidad)	&& No se encontró la Tabla
					=MESSAGEBOX("¡ No se pudo hallar Plantilla para la Tabla !",64,"Error en Parámetro")
					RETURN .F.
				ENDIF
			CASE VARTYPE(txParam) == "N"	&& Pasó como parámetro un Número, indica tipo de plantilla
				lnTipoPlantilla = IIF(BETWEEN(txParam,0,6),txParam,1)
				lcNombreEntidad	= SPACE(0)
				lcCodigoEntidad	= SPACE(0)
			OTHERWISE
				lnTipoPlantilla = 0
				lcNombreEntidad	= SPACE(0)
				lcCodigoEntidad	= SPACE(0)
		ENDCASE


		*!*	Quitar el Enlaze de la Grilla con cualquier Alias de Tablas para que no se deforme la Grilla
		THIS.oGrid.RECORDSOURCE = ""
		THIS.oGrid.RECORDSOURCETYPE = 4
		THIS.oGrid.REFRESH()


		IF ISNULL(THIS.cClavePlantilla) OR EMPTY(THIS.cClavePlantilla)
			RETURN .F.
		ENDIF

		*!* En caso de que el Cursor ya se encuentre abierto
		IF !ISNULL(THIS.cAliasAtributos) AND !EMPTY(THIS.cAliasAtributos)
			IF USED(THIS.cAliasAtributos)
				USE IN (THIS.cAliasAtributos)
			ENDIF
		ELSE
			THIS.cAliasAtributos = SYS(2015)
		ENDIF

		lcCamposEdicionOrigen = ""
		FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
			IF EMPTY(THIS.cTipoDatoCamposEdicion)
				lcValorDefault = "SPACE(40)"
			ELSE
				DO CASE
					CASE THIS.aTipoDatoCamposEdicion[I] == 'N'
						lcValorDefault = "000000.0000"
					CASE THIS.aTipoDatoCamposEdicion[I] == 'C'
						lcValorDefault = "SPACE(40)"
					CASE THIS.aTipoDatoCamposEdicion[I] == 'L'
						lcValorDefault = "CAST('0' AS BIT)"
					CASE THIS.aTipoDatoCamposEdicion[I] == 'D'
						lcValorDefault = "GETDATE()"
					OTHERWISE
						lcValorDefault = "SPACE(40)"
				ENDCASE
			ENDIF
			lcCamposEdicionOrigen = lcCamposEdicionOrigen + lcValorDefault + " AS "+ALLTRIM(THIS.aCamposEdicionOrigen[I])+" , "
			lcCamposEdicionOrigen = lcCamposEdicionOrigen + lcValorDefault + " AS "+ALLTRIM("_"+THIS.aCamposEdicionOrigen[I])+" , "
		ENDFOR
		lcCamposEdicionOrigen = LEFT(lcCamposEdicionOrigen,LEN(lcCamposEdicionOrigen)-3)

		THIS.cWhereSQL	= IIF(TYPE("THIS.cWhereSQL")=="C",ALLTRIM(THIS.cWhereSQL),"")

		DO CASE
			CASE lnTipoPlantilla == 0		&& Cargar Atributos de Producto
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad("CLAGEN_GProductos_Familia_Atributos")+;
					" WHERE CodigoProducto+CodigoFamilia ='"+THIS.cClavePlantilla+"'" + ;
					" AND IndicaSiAtributoComponente=0 " + THIS.cWhereSQL + ;
					" ORDER BY OrdenAtributos"
			CASE lnTipoPlantilla == 1		&& Cargar Atributos de Componente de Producto
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad("CLAGEN_GProductos_Familia_Atributos")+;
					" WHERE CodigoProducto+CodigoFamilia ='"+THIS.cClavePlantilla+"'" + ;
					" AND IndicaSiAtributoComponente=1 " + THIS.cWhereSQL + ;
					" ORDER BY OrdenAtributos"
			CASE lnTipoPlantilla == 2		&& Cargar Atributos de Entidad
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad("CLAGEN_Plantilla_Atributos_Entidad")+;
					" WHERE CodigoEntidad ='" + lcCodigoEntidad + "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 3		&& Cargar Atributos de Ruta de Acabado (VSJ - 28/08/00)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoTipoAcabado+CodigoProcesoAcabado ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 4		&& Cargar Regulaciones de Máquina (VSJ - 11/09/00)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoMaquina ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 5		&& Atributos de Máquina Tipo (VSJ - 29/09/00)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoMaquinaTipo ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL
			CASE lnTipoPlantilla == 6		&& Atributos de Bloque (SYP - 12/10/2000)
				goConexion.cSQL = "SELECT *,"+lcCamposEdicionOrigen+" FROM "+;
					goEntorno.RemotePathEntidad(THIS.cNombreEntidad)+;
					" WHERE CodigoBloque ='" +THIS.cClavePlantilla+ "' " + THIS.cWhereSQL

		ENDCASE
		*goEntorno.conexion.cCursor = IIF(!ISNULL(THIS.cAliasAtributos) AND !EMPTY(THIS.cAliasAtributos),THIS.cAliasAtributos,'')
		goConexion.cCursor = THIS.cAliasAtributos

		lReturn = ( goConexion.DoSQL(THISFORM.DATASESSIONID) > 0 )

		IF lReturn
			*THIS.cAliasAtributos = goEntorno.conexion.cCursor
			THIS.oGrid.RECORDSOURCETYPE = 1  && Alias
			THIS.oGrid.RECORDSOURCE = THIS.cAliasAtributos
			FOR I=1 TO THIS.oGrid.COLUMNCOUNT
				IF !EMPTY(THIS.oGrid.COLUMNS(I).TAG) AND !ISNULL(THIS.oGrid.COLUMNS(I).TAG)
					THIS.oGrid.COLUMNS(I).CONTROLSOURCE = THIS.cAliasAtributos+"."+ALLTRIM(THIS.oGrid.COLUMNS(I).TAG)
				ENDIF
			ENDFOR
			THIS.oGrid.REFRESH()
			THIS.oGrid.SETALL("DYNAMICBACKCOLOR","IIF(TYPE('IndicaSiAtributoRelevante')=='L' AND IndicaSiAtributoRelevante,RGB(230,255,255),RGB(255,255,255))","COLUMN")
			=CURSORSETPROP("Buffering", 5, THIS.cAliasAtributos )
		ELSE
			THIS.oGrid.RECORDSOURCE = ""
			THIS.oGrid.RECORDSOURCETYPE = 4  && Alias
			THIS.oGrid.REFRESH()
		ENDIF
		RETURN lReturn
	ENDPROC


	*-- Obtiene los valores de los atributos desde la entidad origen (ATRIBUTO-VALOR)
	PROCEDURE cargarvaloresatributos
		LOCAL lcSQL_Update , lcCodigoAtributo , lcNombreEntidadCampo
		LOCAL lcCampoRetorno , lcCampoVisualizacion	, lcModoObtenerDatos
		LOCAL lcSecuenciaCampos	, lcAlias

		WITH THIS
			IF !EMPTY(.cValoresClaveOrigen) AND !ISNULL(.cValoresClaveOrigen)
				*!*	 -----------------------------------------------------------
				*!*	Reemplazar todos los Valores de los campos de edición por valores en blanco
				*!*	 -----------------------------------------------------------
				lcSQL_Update = "UPDATE " + .cAliasAtributos + " SET "
				FOR I=1 TO ALEN(.aCamposEdicionOrigen)

					IF EMPTY(THIS.cTipoDatoCamposEdicion)
						lcValorDefault = "SPACE(0)"
					ELSE
						DO CASE
							CASE THIS.aTipoDatoCamposEdicion[I] == 'N'
								lcValorDefault = "0"
							CASE THIS.aTipoDatoCamposEdicion[I] == 'C'
								lcValorDefault = "SPACE(0)"
							CASE THIS.aTipoDatoCamposEdicion[I] == 'L'
								lcValorDefault = ".F."
							CASE THIS.aTipoDatoCamposEdicion[I] == 'D'
								lcValorDefault = "{}"
							OTHERWISE
								lcValorDefault = "SPACE(0)"
						ENDCASE
					ENDIF

					lcSQL_Update = lcSQL_Update + ALLTRIM(THIS.aCamposEdicionOrigen[I]) + "=" + lcValorDefault + ", " + ;
						"_"+ALLTRIM(THIS.aCamposEdicionOrigen[I]) + "=" + lcValorDefault + " , "
				ENDFOR
				lcSQL_Update = lcSQL_Update + " FlagOrigenRemoto=0"
				&lcSQL_Update

				=TABLEUPDATE(.T.,.T.,.cAliasAtributos)

				*!*	Obtener los Valores de los Atributos desde el servidor
				goConexion.cSQL = ;
					"SELECT * FROM "+.cEntidadOrigenAtributos+;
					" WHERE " +	STRTRAN(.cCamposClaveOrigen,';','+')+"='"+;
					STRTRAN(ALLTRIM(.cValoresClaveOrigen),';','')+"'"
				goConexion.cCursor = ''
				goConexion.DoSQL(THISFORM.DATASESSIONID)
				SELECT(goConexion.cCursor)
				lcAlias = ALIAS()

				*!*	-----------------------------------------------------------
				*!*	Actualizar el cursor con los valores de los atributos que se obtuvieron
				*!*	-----------------------------------------------------------
				GO TOP
				lcSQL_Update = ""
				THIS.nRegistros = 0
				SCAN WHILE NOT EOF()
					THIS.nRegistros = THIS.nRegistros + 1
					THIS.Actualizar_Registro(.cAliasAtributos)
					SELECT(lcAlias)
				ENDSCAN
				SELECT (lcALias)
				USE
				SELECT (.cAliasAtributos)
				=TABLEUPDATE(.T.,.T.,.cAliasAtributos)
				GO TOP IN (.cAliasAtributos)
			ENDIF
			IF USED('GTablas_Detalle')
				USE IN GTablas_Detalle
			ENDIF
			SELECT(.cAliasAtributos)
		ENDWITH
	ENDPROC


	*-- Guarda los cambios de los atributos en las tablas de Destino (ATRIBUTO-VALOR)
	PROCEDURE grabaratributovalor
		LPARAMETER lActualizar
		IF PARAMETERS() = 0
			lActualizar = .T.
		ELSE
			lActualizar = .F.
		ENDIF

		LOCAL lcSQL_Update ,  lcSQL_Insert , lcWhere , lcVariable
		LOCAL lnControl

		IF ISNULL(THIS.cAliasAtributos) OR EMPTY(THIS.cAliasAtributos)
			RETURN .F.
		ENDIF

		SELECT(THIS.cAliasAtributos)

		*!*	Filtrar todos los atributos que viuenen del servidor ademas
		*!*	de los que contienen valores y son de origen local
		lcFiltro = "SET FILTER TO FlagOrigenRemoto==1 OR (FlagOrigenRemoto==2 AND ("
		FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)
			IF EMPTY(THIS.cTipoDatoCamposEdicion)
				lcFiltro = lcFiltro + "!EMPTY(_" + THIS.aCamposEdicionDestino[I] + ") AND "
			ELSE
				IF THIS.aTipoDatoCamposEdicion[I] <> 'L'
					lcFiltro = lcFiltro + "!EMPTY(_" + THIS.aCamposEdicionDestino[I] + ") AND "
				ENDIF
			ENDIF
		ENDFOR
		lcFiltro = LEFT(lcFiltro,LEN(lcFiltro)-5) + ") )"
		&lcFiltro
		GO TOP
		lcSQL_Update = ""
		lcSQL_Insert = ""
		lcWhere		 = ""
		lnControl	 = 1

		FOR I=1 TO ALEN(THIS.aCamposClaveDestino)
			lcWhere = lcWhere + ALLTRIM(THIS.aCamposClaveDestino[I]) + "='" + ;
				ALLTRIM(THIS.aValoresClaveDestino[I]) + "' AND "
		ENDFOR

		IF !EMPTY(lcWhere) AND !ISNULL(lcWhere)
			lcWhere = LEFT(lcWhere,LEN(lcWhere)-5)
		ENDIF

		SELECT(THIS.cAliasAtributos)
		*!*	Obtener el Número del Registro Modificado

		*lnRecno = GETNEXTMODIFIED(0)

		*!*	Para forzar la Grabacion si se trata de grabar en otra tabla
		m.lForzarGrabacion	= THIS.cValoresClaveOrigen <> THIS.cValoresClaveDestino OR THIS.cEntidadOrigenAtributos <> THIS.cEntidadDestinoAtributos

		*DO WHILE lnRecno <> 0		&& Mientras exista algun registro modificado

		SCAN WHILE NOT EOF()		&& OJO------ Cambio temporal
			*IF EMPTY(lnRecno)
			*	EXIT
			*ENDIF
			*!*	Situarse en el registro que ha sufrido algun cambio
			*GO lnRecno IN (THIS.cAliasAtributos)

			*!*	Verificar si los campos han sufrido algun cambio
			*llBack = .T.
			*FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)	&& Indica cuantos campos de edición se maneja
			*	FOR J=1 TO FCOUNT()						&& Comprobar todos los campos
			*		IF THIS.aCamposEdicionDestino[I]=FIELD(J)	&& Es el campo de edición
			*			*IF GETFLDSTATE(J)==2	&& El registro fué modificado
			*			IF OLDVAL(FIELD(J))<>EVAL(FIELD(J))	&& ¿Los valores actual e inicial sean diferentes?
			*				llBack = .F.
			*				EXIT
			*			ENDIF
			*		ENDIF
			*	ENDFOR
			*	IF llBack
			*		EXIT
			*	ENDIF
			*ENDFOR

			*IF llBack		&& No se modificó ese registro
			*	=TABLEUPDATE(.F.,.T.)
			*!*	Obtener el Número del Registro Modificado
			*	lnRecno = GETNEXTMODIFIED(lnRecno)
			*	LOOP
			*ENDIF

			IF FlagOrigenRemoto == 1 AND !m.lForzarGrabacion	&& Viene del Servidor
				*lcSQL_Update = "UPDATE "+THIS.cEntidadDestinoAtributos+" SET "
				lcSQL_Update = ""
				lnVacio = 0
				FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)
					lcCampoEdicionDestino	= ALLTRIM(THIS.aCamposEdicionDestino[I])
					lcVariable				= "m.xx_" + ALLTRIM(STR(I)) + "_" + lcCampoEdicionDestino
					PUBLIC &lcVariable
					&lcVariable				= EVAL(lcCampoEdicionDestino)
					lcSQL_Update = lcSQL_Update + ;
						lcCampoEdicionDestino + " = ?" + lcVariable + " , "
					*	lcCampoEdicionDestino + " = '" + ALLTRIM(&lcCampoEdicionDestino) + "' , "

					IF EMPTY(&lcCampoEdicionDestino)
						lnVacio = lnVacio + 1
					ENDIF
				ENDFOR

				lcSQL_Update = LEFT(lcSQL_Update,LEN(lcSQL_Update)-3)

				IF lnVacio = ALEN(THIS.aCamposEdicionDestino)
					lcSQL_Update = "DELETE " + THIS.cEntidadDestinoAtributos
				ELSE
					lcSQL_Update = "UPDATE " + THIS.cEntidadDestinoAtributos + " SET " + ;
						"FHModificacion = GETDATE() , " + ;
						"EstacionModificacion = '" + goEntorno.USER.Estacion + "' , " + ;
						"UsuarioModificacion = '" + goEntorno.USER.Login + "', " + lcSQL_Update
				ENDIF
				lcSQL_Update = lcSQL_Update + ;
					" WHERE " + lcWhere + " AND CodigoAtributo = '" + CodigoAtributo + "'"
				*=MESSAGEBOX(lcSQL_Update)
				goConexion.cSQL = lcSQL_Update
			ELSE						&& Es Local
				lcSQL_Insert = "INSERT  "+THIS.cEntidadDestinoAtributos+" ("+;
					ALLTRIM(STRTRAN(THIS.cCamposClaveDestino,";",",")) + ;
					",CodigoAtributo,UsuarioCreacion,FHCreacion,EstacionCreacion"+;
					",UsuarioModificacion,FHModificacion,EstacionModificacion," + ;
					ALLTRIM(STRTRAN(THIS.cCamposEdicionDestino,";",",")) + ;
					") VALUES ('"+;
					ALLTRIM(STRTRAN(THIS.cValoresClaveDestino,";","','")) + ;
					"','"+CodigoAtributo+ "','" + goEntorno.USER.Login + "',GETDATE()," + ;
					"'" + goEntorno.USER.Estacion + "','" + goEntorno.USER.Login + "',GETDATE()," + ;
					"'" + goEntorno.USER.Estacion + "' , "

				FOR I=1 TO ALEN(THIS.aCamposEdicionDestino)
					lcCampoEdicionDestino	= ALLTRIM(THIS.aCamposEdicionDestino[I])
					lcVariable				= "m.xx_" + ALLTRIM(STR(I)) + "_" + lcCampoEdicionDestino
					PUBLIC &lcVariable
					&lcVariable				= EVAL(lcCampoEdicionDestino)

					lcSQL_Insert = lcSQL_Insert + ;
						"?" + lcVariable + " , "
					*	"'" + ALLTRIM(&lcCampoEdicionDestino) + "' , "
				ENDFOR
				lcSQL_Insert = LEFT(lcSQL_Insert,LEN(lcSQL_Insert)-3) + ")"
				*=MESSAGEBOX(lcSQL_Insert)
				goConexion.cSQL = lcSQL_Insert
			ENDIF

			*=MESSAGEBOX(goConexion.cSQL)
			*DISP MEMO TO FILE C:\WINDOWS\ESCRITORIO\MEMORIA.TXT
			*MODIFY COMMAND C:\WINDOWS\ESCRITORIO\MEMORIA.TXT IN SCREEN

			lnControl = goConexion.DoSQL()
			IF lnControl>0
				IF lActualizar
					REPLACE FlagOrigenRemoto WITH 1
					=TABLEUPDATE(.F.,.T.)
				ENDIF
			ELSE
				=MESSAGEBOX("No se pudo guardar los datos del Atributo "+ALLTRIM(DesCripcionCampo),;
					64,"Error al grabar")
			ENDIF
			*!*	Obtener el Número del Registro Modificado
			*lnRecno = GETNEXTMODIFIED(lnRecno)
			*ENDDO
		ENDSCAN
		SET FILTER TO
		GO TOP
		THIS.oGrid.REFRESH()
		RELEASE ALL LIKE xx_
		RETURN lnControl>0
	ENDPROC


	*-- Convierte una cadena con delimitadores a una matriz
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


	HIDDEN PROCEDURE cvaloresclavedestino_assign
		LPARAMETERS tcValoresClaveDestino

		*!*	Inicializar Matriz temporal
		LOCAL laValoresClaveDestino
		DIMENSION laValoresClaveDestino[1]
		STORE SPACE(0) TO laValoresClaveDestino

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresClaveDestino)=="C"
			tcValoresClaveDestino	= ALLTRIM(tcValoresClaveDestino)
			tcValoresClaveDestino	= CHRTRAN(tcValoresClaveDestino,SPACE(1),SPACE(0))
			THIS.cValoresClaveDestino = tcValoresClaveDestino

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresClaveDestino , ";" , @laValoresClaveDestino )

		ENDIF
		nLen = ALEN(laValoresClaveDestino)
		DIMENSION THIS.aValoresClaveDestino(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresClaveDestino,THIS.aValoresClaveDestino)
	ENDPROC


	HIDDEN PROCEDURE ccamposedicionorigen_assign
		LPARAMETERS tcCamposEdicionOrigen

		*!*	Inicializar Matriz temporal
		LOCAL laCamposEdicionOrigen
		DIMENSION laCamposEdicionOrigen[1]
		STORE SPACE(0) TO laCamposEdicionOrigen

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposEdicionOrigen)=="C"
			tcCamposEdicionOrigen	= ALLTRIM(tcCamposEdicionOrigen)
			tcCamposEdicionOrigen	= CHRTRAN(tcCamposEdicionOrigen,SPACE(1),SPACE(0))
			THIS.cCamposEdicionOrigen = tcCamposEdicionOrigen

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposEdicionOrigen , ";" , @laCamposEdicionOrigen )

		ENDIF
		nLen = ALEN(laCamposEdicionOrigen)
		DIMENSION THIS.aCamposEdicionOrigen(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposEdicionOrigen,THIS.aCamposEdicionOrigen)
	ENDPROC


	HIDDEN PROCEDURE ccamposclaveorigen_assign
		LPARAMETERS tcCamposClaveOrigen

		*!*	Inicializar Matriz temporal
		LOCAL laCamposClaveOrigen
		DIMENSION laCamposClaveOrigen[1]
		STORE SPACE(0) TO laCamposClaveOrigen

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposClaveOrigen)=="C"
			tcCamposClaveOrigen	= ALLTRIM(tcCamposClaveOrigen)
			tcCamposClaveOrigen	= CHRTRAN(tcCamposClaveOrigen,SPACE(1),SPACE(0))
			THIS.cCamposClaveOrigen = tcCamposClaveOrigen

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposClaveOrigen , ";" , @laCamposClaveOrigen )

		ENDIF
		nLen = ALEN(laCamposClaveOrigen)
		DIMENSION THIS.aCamposClaveOrigen(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposClaveOrigen,THIS.aCamposClaveOrigen)
	ENDPROC


	HIDDEN PROCEDURE ccamposclavedestino_assign
		LPARAMETERS tcCamposClaveDestino

		*!*	Inicializar Matriz temporal
		LOCAL laCamposClaveDestino
		DIMENSION laCamposClaveDestino[1]
		STORE SPACE(0) TO laCamposClaveDestino

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposClaveDestino)=="C"
			tcCamposClaveDestino	= ALLTRIM(tcCamposClaveDestino)
			tcCamposClaveDestino	= CHRTRAN(tcCamposClaveDestino,SPACE(1),SPACE(0))
			THIS.cCamposClaveDestino = tcCamposClaveDestino

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposClaveDestino , ";" , @laCamposClaveDestino )
		ENDIF
		nLen = ALEN(laCamposClaveDestino)
		DIMENSION THIS.aCamposClaveDestino(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposClaveDestino,THIS.aCamposClaveDestino)
	ENDPROC


	HIDDEN PROCEDURE ccamposediciondestino_assign
		LPARAMETERS tcCamposEdicionDestino

		*!*	Inicializar Matriz temporal
		LOCAL laCamposEdicionDestino
		DIMENSION laCamposEdicionDestino[1]
		STORE SPACE(0) TO laCamposEdicionDestino

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposEdicionDestino)=="C"
			tcCamposEdicionDestino	= ALLTRIM(tcCamposEdicionDestino)
			tcCamposEdicionDestino	= CHRTRAN(tcCamposEdicionDestino,SPACE(1),SPACE(0))
			THIS.cCamposEdicionDestino = tcCamposEdicionDestino

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposEdicionDestino , ";" , @laCamposEdicionDestino )

		ENDIF
		nLen = ALEN(laCamposEdicionDestino)
		DIMENSION THIS.aCamposEdicionDestino(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposEdicionDestino,THIS.aCamposEdicionDestino)
	ENDPROC


	HIDDEN PROCEDURE generarsecuenciacampos
		LPARAMETER tcTn
		tcTn = tcTn + "."

		LOCAL cAtributo , cAlias , lcNombreCampo
		LOCAL laSecuencia
		DIMENSION laSecuencia[1]
		cAlias = ALIAS()
		lcNombreCampo = ""
		WITH THIS
			DIMENSION aAtributos[1]
			IF !EMPTY(SecuenciaCampos) AND !ISNULL(SecuenciaCampos)
				THIS.ChrToArray( SecuenciaCampos, ";" , @aAtributos)
				FOR I=1 TO ALEN(aAtributos)
					cAtributo = ALLTRIM(aAtributos[I])
					cCodigoEntidad = THIS.cCodigoEntidad
					SELECT NombreCampo,CampoRetorno ;
						FROM goEntorno.LocPath+"GEntidades_Detalle" ;
						WHERE CodigoAtributo == cAtributo AND ;
						CodigoEntidad  == cCodigoEntidad ;
						INTO ARRAY laSecuencia
					IF _TALLY>0
						lcValorCampo  = THIS.BuscarValorAtributo(UPPER(ALLTRIM(laSecuencia[1,1])))
						IF EMPTY(lcValorCampo)
							lcCampo = ALLTRIM(laSecuencia[1,2])
							lcCampo = IIF(ISNULL(lcCampo) OR EMPTY(lcCampo),laSecuencia[1,1],lcCampo)
							lcValorCampo = tcTn + ALLTRIM(lcCampo)
							lcNombreCampo = lcNombreCampo + "T000." + ALLTRIM(laSecuencia[1,1]) + "=" + ;
								lcValorCampo + " AND "
						ELSE
							lcNombreCampo = lcNombreCampo + tcTn + ALLTRIM(laSecuencia[1,1]) + "='" + ;
								lcValorCampo + "' AND "
						ENDIF
					ENDIF
				ENDFOR
			ENDIF
		ENDWITH
		IF !EMPTY(lcNombreCampo) AND !ISNULL(lcNombreCampo)
			lcNombreCampo = LEFT(lcNombreCampo,LEN(lcNombreCampo)-5)
		ENDIF
		IF USED("GAtributos")
			USE IN GAtributos
		ENDIF
		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF

		SELECT(cAlias)
		IF !EMPTY(lcNombreCampo) AND !ISNULL(lcNombreCampo)
			lcNombreCampo = " AND " + lcNombreCampo
		ENDIF
		RETURN lcNombreCampo
	ENDPROC


	*-- Busca en la matriz de aValoresFiltro del Objeto cmdHelp un valor segun el campo especificado
	HIDDEN PROCEDURE buscarvaloratributo
		LPARAMETER tcNombreCampo

		IF !(TYPE("THIS.oHelp")=="O" AND THIS.oHelp.BASECLASS=="Commandbutton")
			RETURN ""
		ENDIF
		lnPos = ASCAN(THIS.oHelp.aCamposFiltro,tcNombreCampo)
		IF lnPos > 0
			lcValor = THIS.oHelp.aValoresFiltro[lnPos]
		ELSE
			lcValor = ""
		ENDIF
		RETURN lcValor
	ENDPROC


	HIDDEN PROCEDURE cvaloresclaveorigen_assign
		LPARAMETERS tcValoresClaveOrigen

		*!*	Inicializar Matriz temporal
		LOCAL laValoresClaveOrigen
		DIMENSION laValoresClaveOrigen[1]
		STORE SPACE(0) TO laValoresClaveOrigen

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresClaveOrigen)=="C"
			tcValoresClaveOrigen	= ALLTRIM(tcValoresClaveOrigen)
			tcValoresClaveOrigen	= CHRTRAN(tcValoresClaveOrigen,SPACE(1),SPACE(0))
			THIS.cValoresClaveOrigen = tcValoresClaveOrigen

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresClaveOrigen , ";" , @laValoresClaveOrigen )

		ENDIF
		nLen = ALEN(laValoresClaveOrigen)
		DIMENSION THIS.aValoresClaveOrigen(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresClaveOrigen,THIS.aValoresClaveOrigen)
	ENDPROC


	HIDDEN PROCEDURE cwheresql_assign
		LPARAMETERS tcWhereSQL
		IF VARTYPE(tcWhereSQL)<>"C"
			tcWhereSQL = ""
		ELSE
			tcWhereSQL = ALLTRIM(tcWhereSQL)
		ENDIF
		THIS.cWhereSql = tcWhereSQL
	ENDPROC


	*-- Genera una clausula WHERE con los criterios seleccionados. (Entidades)
	PROCEDURE generarwheresqlcriterios
		SELECT(THIS.cAliasColumnas)
		GO TOP

		LOCAL m.lxInicio , m.lxFin
		LOCAL m.lnInicio , m.lnTamano
		LOCAL m.lcValorAtributo , m.lcDia , m.lcMes , m.lcAnio
		LOCAL m.lcWhereSQL, m.lcWhereSQL2

		lcWhereSQL = ""
		lcWhereSQL2= ""
		SCAN
			IF EMPTY(ValorAtributo)
				LOOP
			ENDIF
			lcValorAtributo	= ALLTRIM(ValorAtributo)
			lcNombreCampo	= ALLTRIM(NombreCampo)
			lcTipoDatoCampo	= ALLTRIM(TipoDatoCampo)
			lcValorAtributo2= ALLTRIM(_ValorAtributo)
			lcDescAtributo	= ALLTRIM(DescripcionCampo)
			lcWhereSQL		= lcWhereSQL + " AND ( "
			lcWhereSQL2	= lcWhereSQL2 + lcDescAtributo
			DO CASE
				CASE "<" $ lcValorAtributo AND ">" $ lcValorAtributo AND ";" $ lcValorAtributo
					*!*	Rango
					IF lcTipoDatoCampo == "D"
						lnInicio	= AT("<" , lcValorAtributo) + 1
						lnTamano	= AT(";" , lcValorAtributo) - lnInicio
						DO CASE
						CASE goEntorno.Conexion.cDateFormat == "DMY"
							lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
						CASE goEntorno.Conexion.cDateFormat == "MDY"
							lxInicio	= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))))+ " 00:00:00"
						OTHERWISE
							lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
						ENDCASE

						lnInicio	= AT(";" , lcValorAtributo) + 1
						lnTamano	= AT(">" , lcValorAtributo) - lnInicio

						DO CASE
						CASE goEntorno.Conexion.cDateFormat == "DMY"
							lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
						CASE goEntorno.Conexion.cDateFormat == "MDY"
							lxFin		= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)))) + " 23:59:59"
						OTHERWISE
							lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
						ENDCASE
					ELSE
						lnInicio	= AT("<" , lcValorAtributo)+1
						lnTamano	= AT(";" , lcValorAtributo)-m.lnInicio
						lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))

						lnInicio	= AT(";" , lcValorAtributo)+1
						lnTamano	= AT(">" , lcValorAtributo) - lnInicio
						lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))
					ENDIF
					DO CASE
						CASE lcTipoDatoCampo = "D"
							lcWhereSQL2	= lcWhereSQL2 + " ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " BETWEEN CAST('" + ;
								ALLTRIM(lxInicio) + "' AS DateTime) AND "+;
								"CAST('" + ALLTRIM(lxFin) + "' AS DateTime) "
						CASE lcTipoDatoCampo = "N"
							lcWhereSQL2	= lcWhereSQL2 + " QUE ESTE ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " BETWEEN " + ALLTRIM(lxInicio) + " AND " + ALLTRIM(lxFin) + " "
						CASE lcTipoDatoCampo = "C"
							lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] Ó [" + lxFin + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN('" + lxInicio + "','" + lxFin + "') "
							*!*	Igual que Caracter (por si aparaecen otros tipos de datos
						OTHERWISE
							lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] Ó [" + lxFin + "]"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN('"+ lxInicio + "','" + lxFin + "') "
					ENDCASE
				CASE ";"$lcValorAtributo AND NOT ("<"$lcValorAtributo AND ">"$lcValorAtributo)
					*!*	Lista
					lcWhereSQL2		= lcWhereSQL2 + " QUE SE ENCUENTRE EN [" + lcValorAtributo2 + "]"
					DO CASE
						CASE lcTipoDatoCampo = "D"
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS DateTime), CAST(")
							lcValorAtributo	= "CAST(" + lcValorAtributo + " AS DateTime)"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + lcValorAtributo + ") "
						CASE lcTipoDatoCampo = "N"
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS Decimal(11,4)), CAST(")
							lcValorAtributo	= "CAST(" + lcValorAtributo+ " AS Decimal(11,4))"
							lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + lcValorAtributo + ") "
						CASE lcTipoDatoCampo = "C"
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ,"','")
							lcWhereSQL		= lcWhereSQL + lcNombreCampo +" IN ('" + lcValorAtributo + "') "
							*!*	Igual que Caracter (por si aparaecen otros tipos de datos
						OTHERWISE
							lcValorAtributo	= STRTRAN(lcValorAtributo , ";" , "','")
							lcWhereSQL		= lcWhereSQL + "RTRIM(" + lcNombreCampo +") IN ('" + lcValorAtributo + "') "
					ENDCASE

				OTHERWISE
					*!*	Valor especifico
					IF lcTipoDatoCampo = "C" AND ;
							( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
							( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
						lcWhereSQL2	= lcWhereSQL2 + " PARECIDO A [" + ALLTRIM(lcValorAtributo2) + "]"
					ELSE
						lcWhereSQL2	= lcWhereSQL2 + " IGUAL A [" + ALLTRIM(lcValorAtributo2) + "]"
					ENDIF
					DO CASE
						CASE lcTipoDatoCampo = "C"
							IF ( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
									( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
							ELSE
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = '" + ALLTRIM(lcValorAtributo) + "' "
							ENDIF
						CASE lcTipoDatoCampo = "D"
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= CAST('" + ALLTRIM(lcValorAtributo) + "' AS DateTime) "
						CASE lcTipoDatoCampo = "N"
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = "+ ALLTRIM(lcValorAtributo)+ " "
						CASE lcTipoDatoCampo = "L"
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = "+ IIF(ALLTRIM(lcValorAtributo)=='SI','1','0')+ " "
							*!*	Igual que Caracter (por si aparaecen otros tipos de datos
						OTHERWISE
							lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
					ENDCASE
			ENDCASE
			lcWhereSQL	= lcWhereSQL + " ) "
			lcWhereSQL2	= lcWhereSQL2 + CHR(13)
		ENDSCAN
		IF !EMPTY(lcWhereSQL)
			THIS.cLiteralCriterios = lcWhereSQL2
		ELSE
			THIS.cLiteralCriterios = ""
		ENDIF
		*=messagebox(lcWhereSQL)
		RETURN lcWhereSQL
	ENDPROC


	*-- Genera una clausula WHERE con los atributos seleccionados (ATRIBUTO-VALOR)
	PROCEDURE generarwheresqlatributos
		SELECT(THIS.cAliasAtributos)
		GO TOP
		LOCAL m.lxInicio , m.lxFin
		LOCAL m.lnInicio , m.lnTamano
		LOCAL m.lcValorAtributo , m.lcDia , m.lcMes , m.lcAnio
		LOCAL m.lcWhereSQL , m.lcWhereSQL2
		LOCAL tn , I
		tn	= "T999."

		lcWhereSQL	= ""
		lcWhereSQL2	= ""

		THIS.nCriterios	= 0

		SCAN
			lReturn = .T.
			FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
				lcNombreCampoOrigen	= ALLTRIM(THIS.aCamposEdicionOrigen[I])
				IF !EMPTY(&lcNombreCampoOrigen)
					lReturn = .F.
				ENDIF
			ENDFOR
			IF lReturn	&& Indica que todos los campos de edición están vacíos
				LOOP
			ENDIF

			*!*	Recorrer cada campo de edición para generar el criterio (WHERE)
			THIS.nCriterios	= THIS.nCriterios + 1

			lcCodigoAtributo= CodigoAtributo
			lcDescAtributo	= ALLTRIM(DescripcionCampo)
			lcWhereSQL	= lcWhereSQL + tn + "CodigoAtributo = '" + lcCodigoAtributo + "' AND "
			lcWhereSQL2	= lcWhereSQL2 + lcDescAtributo
			lcTipoDatoCampo	= ALLTRIM(TipoDatoCampo)

			FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
				lcNombreCampo	= ALLTRIM(THIS.aCamposEdicionOrigen[I])
				lcNombreCampo2	= "_" + ALLTRIM(THIS.aCamposEdicionOrigen[I])

				*!*	Si es el primer campo de edicion, tomar el tipo de dato que trae la Configuracion
				IF I>1
					*!*	Si no, obtener el tipo de dato de la propiedad
					IF TYPE("THIS.aTipoDatoCamposEdicion[I]")=="C"
						lcTipoDatoCampo	= THIS.aTipoDatoCamposEdicion[I]
					ELSE
						*!*	En caso de no tener las propiedades, obtener del campo de la tabla
						lcTipoDatoCampo	= TYPE(&lcNombreCampo)
					ENDIF
				ENDIF
				DO CASE
				CASE lcTipoDatoCampo = "C" OR I=1
					lcValorAtributo	= ALLTRIM(&lcNombreCampo)
					lcValorAtributo2= ALLTRIM(&lcNombreCampo2)
				CASE lcTipoDatoCampo = "N" AND I>1
					lcValorAtributo	= ALLTRIM(STR(&lcNombreCampo,15,4))
					lcValorAtributo2= ALLTRIM(STR(&lcNombreCampo2,15,4))
				CASE lcTipoDatoCampo = "L" AND I>1
					lcValorAtributo	= IIF(&lcNombreCampo,"1","0")
					lcValorAtributo2= IIF(&lcNombreCampo2,"1","0")
				CASE lcTipoDatoCampo = "D" AND I>1
					lcValorAtributo	= DTOC(&lcNombreCampo)
					lcValorAtributo2= DTOC(&lcNombreCampo2)
				ENDCASE
				lcNombreCampo	= tn + ALLTRIM(THIS.aCamposEdicionOrigen[I])
				IF EMPTY(lcValorAtributo)
					LOOP
				ENDIF

				DO CASE
					CASE "<" $ lcValorAtributo AND ">" $ lcValorAtributo AND ";" $ lcValorAtributo
						*!*	Rango
						IF lcTipoDatoCampo == "D"
							lnInicio	= AT("<" , lcValorAtributo) + 1
							lnTamano	= AT(";" , lcValorAtributo) - lnInicio

							DO CASE
							CASE goEntorno.Conexion.cDateFormat == "DMY"
								lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
							CASE goEntorno.Conexion.cDateFormat == "MDY"
								lxInicio	= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))))+ " 00:00:00"
							OTHERWISE
								lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))+ " 00:00:00"
							ENDCASE

							lnInicio	= AT(";" , lcValorAtributo) + 1
							lnTamano	= AT(">" , lcValorAtributo) - lnInicio

							DO CASE
							CASE goEntorno.Conexion.cDateFormat == "DMY"
								lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
							CASE goEntorno.Conexion.cDateFormat == "MDY"
								lxFin		= MDY(CTOD(ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)))) + " 23:59:59"
							OTHERWISE
								lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano)) + " 23:59:59"
							ENDCASE

						ELSE
							lnInicio	= AT("<" , lcValorAtributo)+1
							lnTamano	= AT(";" , lcValorAtributo)-m.lnInicio
							lxInicio	= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))

							lnInicio	= AT(";" , lcValorAtributo)+1
							lnTamano	= AT(">" , lcValorAtributo) - lnInicio
							lxFin		= ALLTRIM(SUBSTR(lcValorAtributo,lnInicio,lnTamano))
						ENDIF
						DO CASE
							CASE lcTipoDatoCampo = "D"
								lcWhereSQL2	= lcWhereSQL2 + " ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS DateTime) " + ;
										" BETWEEN CAST('" + ALLTRIM(lxInicio) + "' AS DateTime) " + ;
										" AND CAST('" + ALLTRIM(lxFin) + "' AS DateTime) "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + ;
										" BETWEEN CAST('" + ALLTRIM(lxInicio) + "' AS DateTime) " + ;
										" AND CAST('" + ALLTRIM(lxFin) + "' AS DateTime) "
								ENDIF
							CASE lcTipoDatoCampo = "N"
								lcWhereSQL2	= lcWhereSQL2 + " QUE ESTE ENTRE [" + ALLTRIM(lxInicio) + "] Y [" + ALLTRIM(lxFin) + "]"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS Decimal(15,4) ) " + ;
										" BETWEEN " + ALLTRIM(lxInicio) + " AND " + ALLTRIM(lxFin) + " "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + ;
										" BETWEEN " + ALLTRIM(lxInicio) + " AND " + ALLTRIM(lxFin) + " "
								ENDIF
							CASE lcTipoDatoCampo = "C"
								lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] Ó [" + lxFin + "]"
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " IN('" + lxInicio + "','" + lxFin + "') "
								*!*	Igual que Caracter (por si aparaecen otros tipos de datos
							OTHERWISE
								lcWhereSQL2	= lcWhereSQL2 + " PUEDE SER [" + lxInicio + "] Ó [" + lxFin + "]"
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " IN('"+ lxInicio + "','" + lxFin + "') "
						ENDCASE
					CASE ";"$lcValorAtributo AND NOT ("<"$lcValorAtributo AND ">"$lcValorAtributo)
						*!*	Lista
						lcValorAtributo2= "[" + STRTRAN(lcValorAtributo2 , ";" , "],[") + "]"
						lcWhereSQL2		= lcWhereSQL2 + " QUE SE ENCUENTRE EN " + lcValorAtributo2
						DO CASE
							CASE lcTipoDatoCampo = "D"
								IF I=1
									lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS DateTime), CAST(")
									lcValorAtributo	= "CAST(" + lcValorAtributo + " AS DateTime)"
									lcWhereSQL		= lcWhereSQL + "CAST(" + lcNombreCampo + " AS DateTime) " + ;
										" IN (" + lcValorAtributo + ") "
								ELSE
									lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + STRTRAN(lcValorAtributo , ";" ,",") + ") "
								ENDIF
							CASE lcTipoDatoCampo = "N"
								IF I=1
									lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ," AS Decimal(15,4)), CAST(")
									lcValorAtributo	= "CAST(" + lcValorAtributo+ " AS Decimal(15,4))"
									lcWhereSQL		= lcWhereSQL + "CAST(" + lcNombreCampo + " AS Decimal(15,4) ) " + ;
										" IN (" + lcValorAtributo + ") "
								ELSE
									lcWhereSQL		= lcWhereSQL + lcNombreCampo + " IN (" + STRTRAN(lcValorAtributo , ";" ,",") + ") "
								ENDIF
							CASE lcTipoDatoCampo = "C"
								lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ,"','")
								lcWhereSQL		= lcWhereSQL + lcNombreCampo +" IN ('" + lcValorAtributo + "') "
								*!*	Igual que Caracter (por si aparaecen otros tipos de datos
							OTHERWISE
								lcValorAtributo	= STRTRAN(lcValorAtributo , ";" ,"','")
								lcWhereSQL		= lcWhereSQL + lcNombreCampo +" IN ('" + lcValorAtributo + "') "
						ENDCASE

					OTHERWISE
						*!*	Valor especifico
						IF lcTipoDatoCampo = "C" AND ;
								( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
								( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
							lcWhereSQL2	= lcWhereSQL2 + " PARECIDO A [" + ALLTRIM(lcValorAtributo2) + "]"
						ELSE
							lcWhereSQL2	= lcWhereSQL2 + " IGUAL A [" + ALLTRIM(lcValorAtributo2) + "]"
						ENDIF
						DO CASE
							CASE lcTipoDatoCampo = "C"
								IF ( ISNULL(CodigoEntidadCampo) OR EMPTY(CodigoEntidadCampo) ) AND ;
										( ISNULL(CodigoTabla) OR EMPTY(CodigoTabla) )
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + " = '" + ALLTRIM(lcValorAtributo) + "' "
								ENDIF
							CASE lcTipoDatoCampo = "D"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS DateTime) " + ;
										"= CAST('" + ALLTRIM(lcValorAtributo) + "' AS DateTime) "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= CAST('" + ALLTRIM(lcValorAtributo) + "' AS DateTime) "
								ENDIF
							CASE lcTipoDatoCampo = "N"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS Decimal(15,4) ) " + ;
										"= "+ ALLTRIM(lcValorAtributo)+ " "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= "+ ALLTRIM(lcValorAtributo)+ " "
								ENDIF
							CASE lcTipoDatoCampo = "L"
								IF I=1
									lcWhereSQL	= lcWhereSQL + "CAST(" + lcNombreCampo + " AS BIT) " + ;
										"= "+ IIF(ALLTRIM(lcValorAtributo)=='SI','1','0')+ " "
								ELSE
									lcWhereSQL	= lcWhereSQL + lcNombreCampo + "= "+ lcValorAtributo+ " "
								ENDIF
								*!*	Igual que Caracter (por si aparaecen otros tipos de datos
							OTHERWISE
								lcWhereSQL	= lcWhereSQL + lcNombreCampo + " LIKE '%" + ALLTRIM(lcValorAtributo) + "%' "
						ENDCASE
				ENDCASE
				lcWhereSQL	= lcWhereSQL + " AND "
				lcWhereSQL2	= lcWhereSQL2 + CHR(13)
			ENDFOR
				lcWhereSQL	= SUBSTR(lcWhereSQL,1,LEN(lcWhereSQL)-6) + " ) OR ( "
				lcWhereSQL2	= lcWhereSQL2 + CHR(13)
		ENDSCAN
		IF !EMPTY(lcWhereSQL)
			lcWhereSQL	= " ( ( " + LEFT(lcWhereSQL,LEN(lcWhereSQL)-6) + " ) "
			THIS.cLiteralAtributos = lcWhereSQL2
		ELSE
			THIS.cLiteralAtributos = ""
		ENDIF
		*!*	=messagebox(lcWhereSQL)
		*!*	=STRTOFILE(lcWhereSQL,"C:\WINDOWS\ESCRITORIO\SQL.TXT")
		RETURN lcWhereSQL
	ENDPROC


	*-- Genera la Senetencia SQL para la busqueda por ATRIBUTO-VALOR
	PROCEDURE generarsqlatributos
		LOCAL lcSQL
		LOCAL lcWhereSQL
		lcWhereSQL = THIS.GenerarWhereSQLAtributos()
		*!*	Obtener los Valores de los Atributos desde el servidor
		IF !EMPTY(lcWhereSQL)
			lcSQL = "AND EXISTS ( " + ;
				"SELECT " + "T999."+STRTRAN(THIS.cCamposClaveOrigen,';',' , T999.') + ;
				" FROM "  + THIS.cEntidadOrigenAtributos + " T999 " + ;
				" WHERE " + lcWhereSQL + " AND ( " + ;
				" T999." + STRTRAN(THIS.cCamposClaveOrigen,';',' + T999.') + "=" + ;
				" T000." + STRTRAN(THIS.cCamposClaveOrigen,';',' + T000.') + " ) " + ;
				" GROUP BY " + "T999."+STRTRAN(THIS.cCamposClaveOrigen,';',',T999.') + ;
				" HAVING count(*) >= " + ALLTRIM(STR(THIS.nCriterios)) + " ) "
		ELSE
			lcSQL = ""
		ENDIF
		RETURN lcSQL
	ENDPROC


	HIDDEN PROCEDURE cvaloresdefault_assign
		LPARAMETERS tcValoresDefault

		*!*	Inicializar Matriz temporal
		LOCAL laValoresDefault
		DIMENSION laValoresDefault[1]
		STORE SPACE(0) TO laValoresDefault

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresDefault)=="C"
			tcValoresDefault	= ALLTRIM(tcValoresDefault)
			tcValoresDefault	= CHRTRAN(tcValoresDefault,SPACE(1),SPACE(0))
			THIS.cValoresDefault = tcValoresDefault

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresDefault , ";" , @laValoresDefault )

		ENDIF
		nLen = ALEN(laValoresDefault)
		DIMENSION THIS.aValoresDefault(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresDefault,THIS.aValoresDefault)
	ENDPROC


	HIDDEN PROCEDURE catributosdefault_assign
		LPARAMETERS tcAtributosDefault

		*!*	Inicializar Matriz temporal
		LOCAL laAtributosDefault
		DIMENSION laAtributosDefault[1]
		STORE SPACE(0) TO laAtributosDefault

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcAtributosDefault)=="C"
			tcAtributosDefault	= ALLTRIM(tcAtributosDefault)
			tcAtributosDefault	= CHRTRAN(tcAtributosDefault,SPACE(1),SPACE(0))
			THIS.cAtributosDefault = tcAtributosDefault

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcAtributosDefault , ";" , @laAtributosDefault )

		ENDIF
		nLen = ALEN(laAtributosDefault)
		DIMENSION THIS.aAtributosDefault(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laAtributosDefault,THIS.aAtributosDefault)
	ENDPROC


	*-- Actualiza un registro segun el dato cargado (ATRIBUTO-VALOR)
	HIDDEN PROCEDURE actualizar_registro
		*!*	Actualiza el registro correspondiente al campo seleccionado (Criterios de Seleccion)
		LPARAMETERS tcAlias , lcCodigoAtributo , lcValores
		lnParameters = PARAMETERS()
		lcAlias = ALIAS()

		LOCAL lReadOnly , lcVariable , laValores

		DO CASE
		CASE lnParameters==0
			tcAlias = THIS.cAliasAtributos
		CASE lnParameters==1
			lcCodigoAtributo	= CodigoAtributo
			lcValores			= ""
		CASE lnParameters==2
			tcValores	= ""
		ENDCASE


		DIMENSION laValores[1]
		STORE "" TO laValores

		IF LEFT(lcCodigoAtributo,1)=="#"
			lReadOnly = .T.
			lcCodigoAtributo = SUBSTR(lcCodigoAtributo,2)
		ELSE
			lReadOnly = .F.
		ENDIF

		lcSQL_Update 	= "UPDATE " + tcAlias + " SET "

		SELECT(tcAlias)

		IF TYPE("FlagDefault")=="L" AND lReadOnly
			lcSQL_Update	= "UPDATE " + tcAlias + " SET FlagDefault=.T. , "
		ENDIF

		*!*	Buscar en la tabla, las propiedades del atributo
		LOCATE ALL FOR CodigoAtributo=lcCodigoAtributo
		lcNombreEntidadCampo	= NombreEntidadCampo
		lcCodigoTabla			= CodigoTabla
		lcCampoRetorno			= CampoRetorno
		lcCampoVisualizacion	= CampoVisualizacion
		lcModoObtenerDatos		= ModoObtenerDatos
		lcSecuenciaCampos		= SecuenciaCampos
		lcTipoDatoCampo			= TipoDatoCampo

		*!*	Si es un campo de edición, no extraer la descripción de la tabla de origen
		*!*	sólo mostrar el valor digitado (Ejm. NumeroOT, se valida en otra tabla pero
		*!*	sólo debe mostrarse el numero de Ot digitado, no una descripción de la misma)

		IF !ISNULL(lcModoObtenerDatos) AND lcModoObtenerDatos == "E"	&& Edicion
			lcNombreEntidadCampo	= ""
			lcCodigoTabla			= ""
			lcCampoRetorno			= ""
			lcCampoVisualizacion	= ""
			lcSecuenciaCampos		= ""
		ENDIF

		IF !EMPTY(lcValores)
			THIS.chrToArray(lcValores , ";" , @laValores)
		ENDIF

		SELECT(lcAlias)


		FOR I=1 TO ALEN(THIS.aCamposEdicionOrigen)
			lcNombreCampoOrigen1 = ALLTRIM(THIS.aCamposEdicionOrigen[I])
			lcNombreCampoOrigen2 = "_"+ALLTRIM(THIS.aCamposEdicionOrigen[I])

			*!*	 -----------------------------------------------------------
			*!*	Si el atributo se valida en otra tabla, traer la descripcion y el codigo
			*!*	 -----------------------------------------------------------
			lcVariable			= "m.xx_" + ALLTRIM( STR(I) ) + "_" + lcNombreCampoOrigen1
			lcVariable2			= "m.xx_" + ALLTRIM( STR(I) ) + "" + lcNombreCampoOrigen1
			PUBLIC &lcVariable , &lcVariable2

			IF EMPTY(lcValores)
				*lcValorCampoOrigen1 = IIF(ISNULL(&lcNombreCampoOrigen1),"",ALLTRIM(&lcNombreCampoOrigen1))
				&lcVariable			= EVAL(lcNombreCampoOrigen1)
				IF lcTipoDatoCampo == 'L'
					&lcVariable2		= IIF( ALLTRIM(EVAL(lcNombreCampoOrigen1)) == '1' , 'SI','NO')
				ELSE
					&lcVariable2		= EVAL(lcNombreCampoOrigen1)
				ENDIF
				lcValorCampoOrigen1 = &lcNombreCampoOrigen1
			ELSE
				lcValorCampoOrigen1 = IIF(TYPE("laValores[I]")<>"C","",ALLTRIM(laValores[I]))
				&lcVariable			= IIF(TYPE("laValores[I]")<>"C","",ALLTRIM(laValores[I]))
				&lcVariable2		= IIF(TYPE("laValores[I]")<>"C","",ALLTRIM(laValores[I]))
			ENDIF

			DO CASE
			*!*	El atributo se valida en otra entidad
			CASE !ISNULL(lcNombreEntidadCampo) AND !EMPTY(lcNombreEntidadCampo)	AND ;
				 (ISNULL(lcCodigoTabla) OR EMPTY(lcCodigoTabla)) AND VARTYPE(lcValorCampoOrigen1)=="C"

				THIS.oHelp.ConfigurarParametros(lcValorCampoOrigen1,;
								SUBSTR(lcNombreEntidadCampo,RAT('.',lcNombreEntidadCampo)+1),;
								lcCampoRetorno , lcCampoVisualizacion , .t. , "" , "" , ;
								lcModoObtenerDatos , lcSecuenciaCampos)

				SELECT(tcAlias)
				THIS.oHelp.GenerarSecuenciaCampos()

				IF THIS.oHelp.ValidarDato(lcValorCampoOrigen1)
					SELECT(lcAlias)
					IF TYPE("&lcVariable2")== TYPE("THIS.oHelp.cValorDescripcion")
						&lcVariable2 = THIS.oHelp.cValorDescripcion
					ENDIF

					lcSQL_Update = lcSQL_Update + ;
						lcNombreCampoOrigen2 + "= " + lcVariable2 + " ,"
						*lcNombreCampoOrigen2 + "='" + THIS.oHelp.cValorDescripcion + "',"

				ENDIF

			*!*	El atributo se valida en Tabla de Tablas (GTablas_Detalle)
			CASE !ISNULL(lcCodigoTabla) AND !EMPTY(lcCodigoTabla) AND VARTYPE(lcValorCampoOrigen1)=="C"
				*!*	Validar el Codigo De tabla de tablas
				DIMENSION laValorTabla[1]
				SELECT DescripcionLargaArgumento ;
					FROM goEntorno.LocPath+"GTablas_Detalle" ;
					WHERE CodigoTabla = lcCodigoTabla AND ;
						ElementoTabla = lcValorCampoOrigen1 ;
					INTO ARRAY laValorTabla

				IF !EMPTY(_TALLY)
					IF TYPE("&lcVariable2") = TYPE("laValorTabla[1]")
						&lcVariable2 = laValorTabla[1]
					ENDIF

					lcSQL_Update = lcSQL_Update + ;
						lcNombreCampoOrigen2 + "= " + lcVariable2 + " ,"
						*lcNombreCampoOrigen2 + "='" + laValorTabla[1] + "',"
				ELSE
					lcSQL_Update = lcSQL_Update + ;
						lcNombreCampoOrigen2 + "= " + lcVariable + " ,"
				ENDIF

			OTHERWISE
				lcSQL_Update = lcSQL_Update + ;
					lcNombreCampoOrigen2 + "= " + lcVariable2 + " ,"
			ENDCASE
			lcSQL_Update = lcSQL_Update + ;
				lcNombreCampoOrigen1 + "= " + lcVariable + " , "
		ENDFOR

		lcSQL_Update = lcSQL_Update + "FlagOrigenRemoto = 1 " + ;
					"WHERE CodigoAtributo = '" + lcCodigoAtributo + "'"

		&lcSQL_Update
		RELEASE ALL LIKE xx_*
		IF USED("GEntidades_Detalle")
			USE IN GEntidades_Detalle
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE ctipodatocamposedicion_assign
		LPARAMETERS tcTipoDatoCamposEdicion

		*!*	Inicializar Matriz temporal
		LOCAL laTipoDatoCamposEdicion
		DIMENSION laTipoDatoCamposEdicion[1]
		STORE SPACE(0) TO laTipoDatoCamposEdicion

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcTipoDatoCamposEdicion)=="C"
			tcTipoDatoCamposEdicion	= ALLTRIM(tcTipoDatoCamposEdicion)
			tcTipoDatoCamposEdicion	= CHRTRAN(tcTipoDatoCamposEdicion,SPACE(1),SPACE(0))
			THIS.cTipoDatoCamposEdicion = tcTipoDatoCamposEdicion

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcTipoDatoCamposEdicion , ";" , @laTipoDatoCamposEdicion )

		ENDIF
		nLen = ALEN(laTipoDatoCamposEdicion)
		DIMENSION THIS.aTipoDatoCamposEdicion(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laTipoDatoCamposEdicion,THIS.aTipoDatoCamposEdicion)
	ENDPROC


	*-- Permite Mostrar el Error ocurrido
	PROCEDURE mostrarerror
		DO CASE
		CASE THIS.nError = 1
			THIS.cMensajeError	= "Trató de asignar un valor no válido a una propiedad de la clase"
		CASE THIS.nError = 2
			THIS.cMensajeError	= "El Valor de la Propiedad no es el que se esperaba"
		CASE THIS.nError = 3
			THIS.cMensajeError	= "No se encuentra el cursor especificado"
		CASE THIS.nError = 4
			THIS.cMensajeError	= "No existen columnas configuradas para mostrar"
		CASE THIS.nError = 5
			THIS.cMensajeError	= "Los parámetros no son correctos"
		OTHERWISE
			THIS.cMensajeError	= "Error ..."
		ENDCASE

		THIS.cMensajeError	= 	THIS.cMensajeError	+ CHR(13) + ;
							  "Programa : " + PROGRAM(1) + CHR(13) + ;
							  "Linea : " + ALLTRIM(STR(LINENO(1)))

		DO CASE
		CASE THIS.nTipoError = 1
			lcTipoError	= "Warning"
			lnIcono		= 64
		CASE THIS.nTipoError = 2
			lcTipoError	= "Error Fatal"
			lnIcono		= 32
		ENDCASE

		=MESSAGEBOX(THIS.cMensajeError,lnIcono,lcTipoError)
	ENDPROC


	*-- Carga los Valores por defecto que se asignaron a las propiedades cAtributosDefault, cValoresDefault
	PROCEDURE cargarvaloresdefault
		*!*	Verificar si tiene Atributos por defecto
		DIMENSION laValorAtributo[1]
		STORE .F. TO laValorAtributo
		SELECT(THIS.cAliasColumnas)
		LOCAL I,J

		IF !EMPTY(THIS.cValoresDefault) OR !ISNULL(THIS.cValoresDefault)
			FOR I=1 TO ALEN(THIS.aAtributosDefault)
				IF TYPE("THIS.aValoresDefault[I]")<>"C" OR TYPE("THIS.aAtributosDefault[I]")<>"C"
					LOOP
				ENDIF
				FOR J=1 TO ALEN(THIS.aCamposEdicionOrigen)
					IF TYPE("THIS.aCamposEdicionOrigen[J]")=="C"
						lcValorAtributo		= THIS.aValoresDefault[I]
						lcNombreCampo1		= UPPER(ALLTRIM(THIS.aAtributosDefault[I]))
						lcNombreCampo2		= IIF(LEFT(lcNombreCampo1,1)=="#",SUBSTR(lcNombreCampo1,2),lcNombreCampo1)

						*!*	Buscar el Campo que corresponde para actualizar su valor
						SELECT(THIS.cAliasColumnas)
						LOCATE ALL FOR UPPER(ALLTRIM(NombreCampo)) == lcNombreCampo2
						IF FOUND()
							*!*	Capturar el codigo de atributo del campo
							lcCodigoAtributo = IIF(LEFT(lcNombreCampo1,1)=="#","#","")+CodigoAtributo
							*!*	Actualiza el Valor en el Cursor
							THIS.Actualizar_Registro(THIS.cAliasColumnas,lcCodigoAtributo,lcValorAtributo)

						ENDIF
					ENDIF
				ENDFOR
			ENDFOR
		ENDIF
	ENDPROC


	PROCEDURE chavingsql_assign
		lparameters tuNewValue
		IF VARTYPE(tuNewValue)<>"C"
			tuNewValue = ""
		ELSE
			tuNewValue = ALLTRIM(tuNewValue)
		ENDIF
		This.cHavingSql = tuNewValue
	ENDPROC


	PROCEDURE lservidor_assign
		lparameters tuNewValue
This.lservidor = tuNewValue
	ENDPROC


	PROCEDURE Init
		WITH THIS
			*!*	Forzar a los Metodos ASSIGN se ejecuten

			*!*	Campos del Origen
			.cEntidadOrigenAtributos	= IIF(VARTYPE(.cEntidadOrigenAtributos)<>"C" ,"",ALLTRIM(.cEntidadOrigenAtributos))

			.cCamposClaveOrigen			= IIF(VARTYPE(.cCamposClaveOrigen)<>"C","",.cCamposClaveOrigen)
			.cValoresClaveOrigen		= IIF(VARTYPE(.cValoresClaveOrigen)<>"C","",.cValoresClaveOrigen)

			.cCamposEdicionOrigen		= IIF(VARTYPE(.cCamposEdicionOrigen)<>"C" ,"ValorAtributo",.cCamposEdicionOrigen)
			.cCamposEdicionOrigen		= IIF(EMPTY(.cCamposEdicionOrigen) ,"ValorAtributo",.cCamposEdicionOrigen)

			*!*	Campos del Destino
			.cEntidadDestinoAtributos	= IIF(VARTYPE(.cEntidadDestinoAtributos)<>"C","",ALLTRIM(.cEntidadDestinoAtributos))

			.cCamposClaveDestino		= IIF(VARTYPE(.cCamposClaveDestino)<>"C","",.cCamposClaveDestino)
			.cValoresClaveDestino		= IIF(VARTYPE(.cValoresClaveDestino)<>"C","",.cValoresClaveDestino)

			.cCamposEdicionDestino		= IIF(VARTYPE(.cCamposEdicionDestino)<>"C","ValorAtributo",.cCamposEdicionDestino)
			.cCamposEdicionDestino		= IIF(EMPTY(.cCamposEdicionDestino),"ValorAtributo",.cCamposEdicionDestino)

			*!*	Si los campos del destino estan vacios asumir los del Origen
			.cEntidadDestinoAtributos	= IIF(EMPTY(.cEntidadDestinoAtributos),.cEntidadOrigenAtributos,.cEntidadDestinoAtributos)

			.cCamposClaveDestino		= IIF(EMPTY(.cCamposClaveDestino) ,.cCamposClaveOrigen ,.cCamposClaveDestino)
			.cValoresClaveDestino		= IIF(EMPTY(.cValoresClaveDestino),.cValoresClaveOrigen,.cValoresClaveDestino)


			.cAtributosDefault		= IIF(VARTYPE(.cAtributosDefault)<>"C","",.cAtributosDefault)
			.cValoresDefault			= IIF(VARTYPE(.cValoresDefault)<>"C","",.cValoresDefault)

			.cTipoDatoCamposEdicion		= IIF(VARTYPE(.cTipoDatoCamposEdicion)<>"C","",.cTipoDatoCamposEdicion)
			.cWhereSQL			= .cWhereSQL
			.cHavingSql 		= .cHavingSql 

			*!*	Inicializar propiedades con valores por defecto

			.cAliasAtributos		= IIF(VARTYPE(.cAliasAtributos)<>"C",SYS(2015),ALLTRIM(.cAliasAtributos))
			.cAliasColumnas	= IIF(VARTYPE(.cAliasColumnas)<>"C" ,SYS(2015),ALLTRIM(.cAliasColumnas))
			.cAliasCursor		= IIF(VARTYPE(.cAliasCursor)<>"C"   ,SYS(2015),ALLTRIM(.cAliasCursor))

			.cClavePlantilla		= IIF(VARTYPE(.cClavePlantilla)<>"C","",ALLTRIM(.cClavePlantilla))

			.cCodigoEntidad	= IIF(VARTYPE(.cCodigoEntidad)<>"C"			 ,"",ALLTRIM(.cCodigoEntidad))
			.cNombreEntidad	= IIF(VARTYPE(.cNombreEntidad)<>"C"			 ,"",ALLTRIM(.cNombreEntidad))

			.cSQL				= IIF(VARTYPE(.cSQL)<>"C"  ,"",ALLTRIM(.cSQL))
			.cWhere				= IIF(VARTYPE(.cWhere)<>"C","",ALLTRIM(.cWhere))

			.lMultiSelect			= IIF(VARTYPE(.lMultiSelect)<>"L",.F.,.lMultiSelect)
			.lDinamicGrid		= IIF(VARTYPE(.lDinamicGrid)<>"L",.F.,.lDinamicGrid)
			.lDistinct			= IIF(VARTYPE(.lDistinct)<>"L"    ,.F.,.lDistinct)
			.lHaving 			= IIF(VARTYPE(.lHaving)<>"L"    ,.F.,.lHaving)
			.lServidor 			= IIF(VARTYPE(.lServidor)<>"L"    ,.F.,.lServidor)

			.cLiteralAtributos	= IIF(VARTYPE(.cLiteralAtributos)<>"C","",ALLTRIM(.cLiteralAtributos))
			.cLiteralCriterios		= IIF(VARTYPE(.cLiteralCriterios)<>"C","",ALLTRIM(.cLiteralCriterios))

			.nRegistros	= 0
			.nCriterios	= 0

		ENDWITH
	ENDPROC


	PROCEDURE Destroy
		*!*	Cierra el cursor de las columnas de criterios de seleccion
		IF !EMPTY(THIS.cAliasColumnas) AND !ISNULL(THIS.cAliasColumnas)
			IF USED(THIS.cAliasColumnas)
				USE IN (THIS.cAliasColumnas)
			ENDIF
		ENDIF

		*!*	Cierra el cursor de Atributo-Valor
		IF !EMPTY(THIS.cAliasAtributos) AND !ISNULL(THIS.cAliasAtributos)
			IF USED(THIS.cAliasAtributos)
				USE IN (THIS.cAliasAtributos)
			ENDIF
		ENDIF

		*!*	Cierra el cursor de la Consulta dinamica
		IF !EMPTY(THIS.cAliasCursor) AND !ISNULL(THIS.cAliasCursor)
			IF USED(THIS.cAliasCursor)
				USE IN (THIS.cAliasCursor)
			ENDIF
		ENDIF
	ENDPROC


	*-- Genera cadena WHERE para cSQL
	HIDDEN PROCEDURE generarwhere
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_grid
**************************************************


**************************************************
*-- Class:        base_img (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   10/04/00 08:56:13 PM
*
DEFINE CLASS base_img AS custom


	Height = 17
	Width = 27
	*-- Almacena el nombre de entidad al cual se asociará un archivo imagen
	cnombreentidad = ""
	*-- Almacena el nombre de la columna en la cual se guardará el alias del archivo
	cnombrecolumna = ""
	*-- Almacena el correlativo unico para una ruta especifica
	ccodigoruta = ""
	*-- Contiene la referencia al objeto contenedor que administrara el archivo especificado.
	ocontrol = ""
	*-- Almacena los campos que forman la Clave Primaria del Registro actual de la tabla activa.
	ccamposfiltro = ""
	*-- Almacena los valores de los campos que forman la Clave Primaria del Registro actual de la tabla activa.
	cvaloresfiltro = ""
	*-- Almacena la ruta desde donde se extraera el archivo a mostrar.
	cruta = ""
	nerror = 0
	ntipoerror = 0
	cmensajeerror = ""
	cnombrearchivo = ""
	clistaextensionesimagenes = ("BMP;GIF;JPG;PNG;TIF;JPEG;RLE;DIB;PCD;ICB;ICO;WMF;TIFF;TGA;PCX;SCR;EMF;JIF;VDA;JFIF;RGB;AFI;VST;WIN;CEL;JPE;RGBA;PIC;PCC;CUT;PPM;PGM;PBM;SGI;RLA;RPF;PSD;PDD;BW")
	Name = "base_img"

	*-- Almacena la ruta del software que convierte graficos a JPG
	crutaconvert = .F.

	*-- Ancho del Control a Mostrar
	nwidthcontrol = .F.

	*-- Almacena el alto del control a Mostrar
	nheightcontrol = .F.
	nleftcontrol = .F.
	ntopcontrol = .F.
	cwhere = .F.
	DIMENSION avaloresfiltro[1]
	DIMENSION acamposfiltro[1]


	*-- Metodo que vincula la clase base_img con un control contenedor y adiministrador del tipo de archivo especificado.
	PROCEDURE vincularcontrol
		LPARAMETER toControl
		*!*	El valor del parámetro es un objeto del tipo Imagen, el cual se pasa por referencia para
		*!*	actualizar sus valores y contenido.

		IF !( VARTYPE(toControl)=="O" AND toControl.BASECLASS="Image" )
			THIS.nError		= 1
			THIS.nTipoError	= 1
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		THIS.oControl 		= toControl
		THIS.nWidthControl 	= toControl.WIDTH
		THIS.nHeightControl = toControl.HEIGHT
		THIS.nLeftControl 	= toControl.LEFT
		THIS.nTopControl	= toControl.TOP

		RETURN .T.
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


	*-- Metodo que controla el error de la clase.
	PROCEDURE mostrarerror
		DO CASE
		CASE THIS.nError = 1
			THIS.cMensajeError	= "Trató de asignar un valor no válido a una propiedad de la clase"
		CASE THIS.nError = 2
			THIS.cMensajeError	= "El Valor de la Propiedad no es el que se esperaba"
		CASE THIS.nError = 3
			THIS.cMensajeError	= "No se encuentra el cursor especificado"
		CASE THIS.nError = 4
			THIS.cMensajeError	= "No existen columnas configuradas para mostrar"
		CASE THIS.nError = 5
			THIS.cMensajeError	= "Los parámetros no son correctos"
		OTHERWISE
			THIS.cMensajeError	= "Error ..."
		ENDCASE

		THIS.cMensajeError	= 	THIS.cMensajeError	+ CHR(13) + ;
							  "Programa : " + PROGRAM(1) + CHR(13) + ;
							  "Linea : " + ALLTRIM(STR(LINENO(1)))

		DO CASE
		CASE THIS.nTipoError = 1
			lcTipoError	= "Warning"
			lnIcono		= 64
		CASE THIS.nTipoError = 2
			lcTipoError	= "Error Fatal"
			lnIcono		= 32
		ENDCASE

		=MESSAGEBOX(THIS.cMensajeError,lnIcono,lcTipoError)
	ENDPROC


	*-- Metodo que valida los parametros pasados a la clase.
	PROCEDURE validarparametros
		*!*	Valida si los parametros pasados retornan por lo menos un registro
		LPARAMETERS tcNombreColumna , tcNombreEntidad, tcCodigoRuta
		LOCAL laRuta

		IF  ( (EMPTY(tcNombreColumna) OR ISNULL(tcNombreColumna)) OR ;
			  (EMPTY(tcNombreEntidad) OR ISNULL(tcNombreEntidad)) )  AND ;
			( EMPTY(tcCodigoRuta) OR ISNULL(tcCodigoRuta) ) 
			THIS.nError		= 5
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN .F.
		ENDIF

		DIMENSION laRuta[1]
		STORE SPACE(0) TO laRuta

		DO CASE
			CASE !EMPTY(tcNombreColumna) AND !EMPTY(tcNombreEntidad)
				SELECT CodigoRuta, NombreColumna, NombreEntidad, Ruta ;
					FROM goEntorno.LocPath + "MRutasArchivos" ;
					WHERE	UPPER(ALLTRIM(NombreEntidad)) == UPPER(ALLTRIM(tcNombreEntidad)) AND ;
							UPPER(ALLTRIM(NombreColumna)) == UPPER(ALLTRIM(tcNombreColumna)) AND ;
							!FlagEliminado ;
					INTO ARRAY laRuta

			CASE !EMPTY(tcCodigoRuta) 
				SELECT CodigoRuta, NombreColumna, NombreEntidad, Ruta ;
					FROM goEntorno.LocPath + "MRutasArchivos" ;
					WHERE	CodigoRuta == tcCodigoRuta AND ;
							!FlagEliminado ;
					INTO ARRAY laRuta
		ENDCASE

		IF !( _TALLY = 1 )
			IF USED("MRutasArchivos")
				USE IN MRutasArchivos
			ENDIF
			THIS.nError		= 5
			THIS.nTipoError	= 2
			THIS.MostrarError()
			RETURN .F.
		ENDIF
		THIS.cCodigoRuta 	= ALLTRIM(laRuta[1,1])
		THIS.cNombreColumna = ALLTRIM(laRuta[1,2])
		THIS.cNombreEntidad = ALLTRIM(laRuta[1,3])
		THIS.cRuta			= ALLTRIM(laRuta[1,4])
		IF USED("MRutasArchivos")
			USE IN MRutasArchivos
		ENDIF

		SELECT Ruta ;
		FROM goEntorno.LocPath + "MRutasArchivos" ;
		WHERE	CodigoRuta == '099' ;
		INTO ARRAY laRuta
		THIS.cRutaConvert = ALLTRIM(laRuta[1,1])

		IF USED("MRutasArchivos")
			USE IN MRutasArchivos
		ENDIF
		RETURN .T.
	ENDPROC


	*-- Metodo que visualiza el tipo de archivo especificado con el control contenedor administrador de archivos.
	PROCEDURE mostrarcontrol
		LPARAMETERS tcNombreArchivo
		IF (ISNULL(tcNombreArchivo) OR EMPTY(tcNombreArchivo)) AND VARTYPE(THIS.cNombreArchivo)=="C"
			DO CASE
				CASE FILE(THIS.cRuta + THIS.cNombreArchivo)
					THIS.oControl.PICTURE = THIS.cRuta + THIS.cNombreArchivo
					THIS.oControl.VISIBLE = .T.
		*!*			CASE FILE(THIS.cRuta + THIS.cNombreArchivo + ".BMP")
		*!*				THIS.oControl.PICTURE = THIS.cRuta + THIS.cNombreArchivo + ".BMP"
		*!*				THIS.oControl.VISIBLE = .T.
		*!*			CASE FILE(THIS.cRuta + THIS.cNombreArchivo + ".GIF")
		*!*				THIS.oControl.PICTURE = THIS.cRuta + THIS.cNombreArchivo + ".GIF"
		*!*				THIS.oControl.VISIBLE = .T.
				OTHERWISE
		*			THIS.oControl.VISIBLE = .F.
					THIS.oControl.PICTURE = ""
			ENDCASE
		ELSE
			THIS.oControl.PICTURE = tcNombreArchivo
			THIS.oControl.VISIBLE = .T.
		ENDIF
	ENDPROC


	*-- Configura el control que administra  la visualización del archivo especifcado.
	PROCEDURE configurarcontrol
		tcNombreCampo = THIS.cNombreColumna
		tcNombreEntidad = THIS.cNombreEntidad
		tcCodigoRuta = THIS.cCodigoRuta
		IF !THIS.ValidarParametros(tcNombreCampo, tcNombreEntidad, tcCodigoRuta)
			RETURN .f.
		ENDIF
		THIS.GenerarWhere()
		IF EMPTY(THIS.GenerarNombreArchivo())
			RETURN .f.
		ELSE
			RETURN .t.
		ENDIF
	ENDPROC


	PROCEDURE ccamposfiltro_assign
		LPARAMETERS tcCamposFiltro

		*!*	Inicializar Matriz temporal
		LOCAL laCamposFiltro
		DIMENSION laCamposFiltro[1]
		STORE SPACE(0) TO laCamposFiltro

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcCamposFiltro)=="C"
			tcCamposFiltro	= ALLTRIM(tcCamposFiltro)
			tcCamposFiltro	= CHRTRAN(tcCamposFiltro,SPACE(1),SPACE(0))
			THIS.cCamposFiltro = tcCamposFiltro

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcCamposFiltro , ";" , @laCamposFiltro )

		ENDIF
		nLen = ALEN(laCamposFiltro)
		DIMENSION THIS.aCamposFiltro(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laCamposFiltro,THIS.aCamposFiltro)
	ENDPROC


	PROCEDURE cvaloresfiltro_assign
		LPARAMETERS tcValoresFiltro

		*!*	Inicializar Matriz temporal
		LOCAL laValoresFiltro
		DIMENSION laValoresFiltro[1]
		STORE SPACE(0) TO laValoresFiltro

		*!*	Verificacmos el Valor que se esta asignando
		IF VARTYPE(tcValoresFiltro)=="C"
			tcValoresFiltro	= ALLTRIM(tcValoresFiltro)
			tcValoresFiltro	= CHRTRAN(tcValoresFiltro,SPACE(1),SPACE(0))
			THIS.cValoresFiltro = tcValoresFiltro

			*!*	Convertir la cadena hacia la Matriz Temporal
			THIS.ChrToArray( tcValoresFiltro , ";" , @laValoresFiltro )

		ENDIF
		nLen = ALEN(laValoresFiltro)
		DIMENSION THIS.aValoresFiltro(nLen)
		*!*	Copiar la Matriz temporal hacia la Propiedad de la Clase
		=ACOPY(laValoresFiltro,THIS.aValoresFiltro)
	ENDPROC


	PROCEDURE generarnombrearchivo
		LOCAL lcCampo , lcValor , laFiles , lnFiles , lcCurDir

		IF !EMPTY( THIS.cValoresFiltro )
			cCadena = ""
			FOR i = 1 TO ALEN(THIS.aValoresFiltro)
				lcValor = IIF(TYPE("THIS.aValoresFiltro[I]")=="C",THIS.aValoresFiltro[I],"")
				IF !EMPTY(lcValor)
					cCadena = cCadena + lcValor 
				ENDIF
			ENDFOR
			THIS.cNombreArchivo = ""
			IF FILE(THIS.cCodigoRuta + cCadena + ".JPG")
				THIS.cNombreArchivo = THIS.cCodigoRuta + cCadena + ".JPG"
			ELSE
				lcCurDir	= FULLPATH(CURDIR())
				SET DEFA TO (THIS.cRuta)
				DECLARE laFiles(1,4)
				lnFiles	= ADIR(laFiles,THIS.cCodigoRuta + cCadena + ".*" )
				FOR I=1 TO lnFiles
					THIS.cNombreArchivo = laFiles(I,1)
					EXIT
				ENDFOR
				SET DEFAULT TO (lcCurDir)
			ENDIF
			IF EMPTY(THIS.cNombreArchivo)
				THIS.cNombreArchivo = THIS.cCodigoRuta + cCadena + ".JPG"
			ENDIF
		ELSE
			THIS.cNombreArchivo = ""
		ENDIF
		RETURN THIS.cNombreArchivo
	ENDPROC


	*-- No muestra imagen
	PROCEDURE nomostrarcontrol
		THIS.oControl.PICTURE = ""
	ENDPROC


	PROCEDURE generarwhere
		LOCAL lcCampo , lcValor

		IF !EMPTY( THIS.cCamposFiltro )
			cWhere = ""
			FOR i = 1 TO ALEN(THIS.aCamposFiltro)
				lcCampo = IIF(TYPE("THIS.aCamposFiltro[I]")=="C" ,THIS.aCamposFiltro[I] ,"")
				lcValor = IIF(TYPE("THIS.aValoresFiltro[I]")=="C",THIS.aValoresFiltro[I],"")
				IF !EMPTY(lcCampo) AND !EMPTY(lcValor)
					cWhere = cWhere + lcCampo + " = '" + lcValor + "' AND "
				ENDIF
			ENDFOR
			THIS.cWhere = LEFT(cWhere, LEN(cWhere) - 5 )
		ELSE
			THIS.cWhere = ""
		ENDIF
		RETURN THIS.cWhere
	ENDPROC


	PROCEDURE Init
		WITH THIS
			*!*	Forzar a los Metodos ASSIGN se ejecuten

			*!*	Inicializar propiedades con valores por defecto
			.cCamposFiltro		= IIF(VARTYPE(.cCamposFiltro)<>"C"	, "", ALLTRIM(.cCamposFiltro))
			.cValoresFiltro		= IIF(VARTYPE(.cValoresFiltro)<>"C"	, "", ALLTRIM(.cValoresFiltro))

			.cNombreColumna		= IIF(VARTYPE(.cNombreColumna)<>"C"	, "", ALLTRIM(.cNombreColumna))
			.cNombreEntidad		= IIF(VARTYPE(.cNombreEntidad)<>"C"	, "", ALLTRIM(.cNombreEntidad))

			.cCodigoRuta		= IIF(VARTYPE(.cCodigoRuta)<>"C"  	, "", ALLTRIM(.cCodigoRuta))
			.cRuta				= IIF(VARTYPE(.cRuta)<>"C"			, "", ALLTRIM(.cRuta))

		ENDWITH
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_img
**************************************************


**************************************************
*-- Class:        cnxgen_odbc (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   12/29/15 10:52:02 PM
*
DEFINE CLASS cnxgen_odbc AS custom


	Height = 27
	Width = 34
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="cbakcend" type="property" display="cBakcEnd"/><memberdata name="cport" type="property" display="cPort"/><memberdata name="gencadena2" type="method" display="GenCadena2"/><memberdata name="gencadena3" type="method" display="GenCadena3"/><memberdata name="cstringcnx2" type="property" display="cStringCnx2"/><memberdata name="cstringcnx3" type="property" display="cStringCnx3"/><memberdata name="cargaparmscadcnxarcini" type="method" display="CargaParmsCadCnxArcIni"/><memberdata name="csourceodbc2" type="property" display="cSourceODBC2"/><memberdata name="cserver2" type="property" display="cServer2"/><memberdata name="cdatabase2" type="property" display="cDataBase2"/><memberdata name="cuser2" type="property" display="cUser2"/><memberdata name="cestacion2" type="property" display="cEstacion2"/><memberdata name="cpassword2" type="property" display="cPassword2"/><memberdata name="cparams2" type="property" display="cParams2"/><memberdata name="nidconexion2" type="property" display="nIDConexion2"/><memberdata name="ldatos2" type="property" display="lDatos2"/><memberdata name="csql2" type="property" display="cSQL2"/><memberdata name="csp2" type="property" display="cSP2"/><memberdata name="ccursor2" type="property" display="cCursor2"/><memberdata name="lconectado2" type="property" display="lConectado2"/><memberdata name="csourceodbc3" type="property" display="cSourceODBC3"/><memberdata name="cserver3" type="property" display="cServer3"/><memberdata name="cdatabase3" type="property" display="cDataBase3"/><memberdata name="cuser3" type="property" display="cUser3"/><memberdata name="cestacion3" type="property" display="cEstacion3"/><memberdata name="cpassword3" type="property" display="cPassword3"/><memberdata name="cparams3" type="property" display="cParams3"/><memberdata name="nidconexion3" type="property" display="nIDConexion3"/><memberdata name="ldatos3" type="property" display="lDatos3"/><memberdata name="csql3" type="property" display="cSQL3"/><memberdata name="csp3" type="property" display="cSP3"/><memberdata name="ccursor3" type="property" display="cCursor3"/><memberdata name="lconectado3" type="property" display="lConectado3"/><memberdata name="cbackend2" type="property" display="cBackEnd2"/><memberdata name="cbackend3" type="property" display="cBackEnd3"/><memberdata name="nport2" type="property" display="nPort2"/><memberdata name="nport3" type="property" display="nPort3"/><memberdata name="cport" type="property" display="cPort"/><memberdata name="nport" type="property" display="nPort"/><memberdata name="cdriver2" type="property" display="cDriver2"/><memberdata name="cdriver3" type="property" display="cDriver3"/></VFPData>]
	*-- Origen de datos : VFPDBC ; Data Base Conteiner Visual Foxpro , ODBC ; Open Database Connectivity for relational database, Sql Server Oracle, DB2, MySql, Postgres,etc
	cbackend = ([])
	*-- Almacena la cadena de conexión ODBC 2
	cstringcnx2 = "=[]"
	*-- Almacena la cadena de conexión ODBC 3
	cstringcnx3 = ([])
	csourceodbc2 = "=[]"
	cserver2 = "=[]"
	cdatabase2 = "=[]"
	cuser2 = "=[]"
	cestacion2 = "=[]"
	cpassword2 = "=[]"
	cparams2 = "=[]"
	nidconexion2 = 0
	ldatos2 = .F.
	csql2 = "=[]"
	csp2 = "=[]"
	ccursor2 = "=[]"
	lconectado2 = .F.
	csourceodbc3 = "=[]"
	cserver3 = ([])
	cdatabase3 = ([])
	cuser3 = "=[]"
	cestacion3 = "=[]"
	cpassword3 = ([])
	cparams3 = "=[]"
	nidconexion3 = 0
	ldatos3 = .F.
	csql3 = "=[]"
	csp3 = "=[]"
	ccursor3 = "=[]"
	lconectado3 = .F.
	cbackend2 = "=[]"
	cbackend3 = ([])
	nport2 = 0
	nport3 = 0
	nport = 0
	cdriver2 = "=[]"
	cdriver3 = ([])
	*-- Parametro para tablas dentro de un esquema en la base de datos , sirve para asignar el valor a variable SCHEME en cadena de conexion.
	cscheme = ([])
	cstringcnxnew = ([])
	Name = "cnxgen_odbc"

	*-- Es el nombre del DSN configurado en el ODBC del Cliente
	csourceodbc = .F.

	*-- Es el Servidor al cual se conectará
	cserver = .F.

	*-- Es el nombre de la base de datos a la cual se está conectado.
	cdatabase = .F.

	*-- Nombre del Usuario que se conectará al Servidor
	cuser = .F.

	*-- Es la clave del usuario que se conecta al Servidor SQL
	cpassword = .F.

	*-- Contiene la cadena de conexión ODBC
	cstringcnx = .F.

	*-- Es la cadena que se genera al procesar la matriz de parámetros que se transmitirá al SP
	HIDDEN cparams

	*-- Usado con la propiedad Conexion
	HIDDEN nidconexion

	*-- Usado con la propiedad Found
	HIDDEN ldatos

	*-- Uasdo con la propiedad Conectado
	HIDDEN lconectado

	*-- Contiene la sentencia SQL que se ejecutará
	csql = .F.

	*-- Nombre del Store Procedure que se ejecutará
	csp = .F.

	*-- Es el nombre del cursor que devolverá la ejecución de una Sentencia SQL o un Store Procedure
	ccursor = .F.

	*-- Retorna el ID de la conexión ODBC
	conexion = .F.

	*-- Si se encuentra conectado al Servidor SQL retornará un Valor .T. en caso contrario .F.
	conectado = .F.

	*-- Retorna .T. si la ejecución del SP o Senetencia SQL encontró registros y .F. si no existe ningún registro en el cursor generado
	found = .F.

	*-- Indica la estacion de trabajo
	cestacion = .F.
	servidor = .F.
	basedatos = .F.

	*-- Indica el Formato de Fecha del Servidor , DMY , MDY , YMD
	cdateformat = .F.

	*-- Contiene los valores de los parámetros que se transmitirán a un Store Procedure
	HIDDEN aparams[1]


	*-- Ajusta las propiedades necesarias para la conexión
	PROCEDURE setparams
		*!*	**********************************************************************************
		*!*	Procedimiento para ajustar los valores de la conexión
		*!*	**********************************************************************************
		LPARAMETER m.lcSourceODBC ,	m.lcServer , m.lcDataBase , m.lcUser , m.lcPassword

		LOCAL m.lnParams
		m.lnParams	= PARAMETERS()

		*!*	Verificar que se hayan pasado todos los parámetros.
		IF m.lnParams # 5
			*=MESSAGEBOX( _MSG_ERROR_PARAMS , 16 , _TIT_ERROR_PARAMS )
			=MESSAGEBOX( "Error en Parametros" , 16 , "Parametros" )
			RETURN .F.
		ENDIF

		*!*	Asignar los valores a las propiedades de la clase

		THIS.cSourceODBC	= IIF( VarType(m.lcSourceODBC)	== "C" , m.lcSourceODBC	, THIS.cSourceODBC	)
		THIS.cServer		= IIF( VarType(m.lcServer	 )	== "C" , m.lcServer		, THIS.cServer		)
		THIS.cDataBase		= IIF( VarType(m.lcDataBase	 )	== "C" , m.lcDataBase	, THIS.cDataBase	)
		*!*	THIS.cUser			= IIF( VarType(m.lcUser		 )	== "C" , m.lcUser		, THIS.cUser		)
		*!*	THIS.cPassword		= IIF( VarType(m.lcPassword	 )	== "C" , m.lcPassword	, THIS.cPassword	)
		*!*	THIS.cUser			= THIS.cUser
		*!*	THIS.cPassword		= THIS.cPassword

		*!*	Verificar los tipos de datos de los parametros
		IF EMPTY(THIS.cSourceODBC) OR EMPTY(THIS.cServer) OR EMPTY(THIS.cDataBase) OR EMPTY(THIS.cUser)
		*!*		=MESSAGEBOX( _MSG_ERROR_PARAMS , 16 , _TIT_ERROR_PARAMS )
			=MESSAGEBOX( "Error en Parametros" , 16 , "Parametros" )
			RETURN .F.
		ENDIF
		*!*	Generar la cadena de conexión ODBC
		THIS.GenCadena()
	ENDPROC


	*-- Genera la cadena de conexión para conectarse al Servidor
	HIDDEN PROCEDURE gencadena
		*!*	**********************************************************************************
		*!*	Procedimiento para generar la cadena de conexión ODBC
		*!*	***********************************************************************************
		THIS.cStringCnx	= SPACE(0)
		*.cStringCnx	= .cStringCnx + "DSN="		+ .cSourceODBC	+ ";"
		THIS.cStringCnx	= THIS.cStringCnx + "DRIVER=SQL Server;"
		THIS.cStringCnx	= THIS.cStringCnx + "SERVER="	+ THIS.cServer		+ ";"
		THIS.cStringCnx	= THIS.cStringCnx + "DATABASE="	+ THIS.cDataBase	+ ";"
		THIS.cStringCnx	= THIS.cStringCnx + "UID="		+ THIS.cUser		+ ";"
		THIS.cStringCnx	= THIS.cStringCnx + "PWD="		+ THIS.cPassword	+ ";LANGUAGE=Español;TranslationName=Yes;"

		*!*	THIS.cStringCnx	= THIS.cStringCnx + "UID="		+ THIS.cUser		+ ";"
		*!*	THIS.cStringCnx	= THIS.cStringCnx + "PWD="		+ THIS.cPassword	+ ";"
		IF !ISNULL(THIS.cScheme) AND !EMPTY(THIS.cScheme)
			THIS.cStringCnx	= THIS.cStringCnx + "SCHEME=" + THIS.cScheme	+ ";"
		ENDIF

		IF !ISNULL(THIS.cEstacion) AND !EMPTY(THIS.cEstacion)
			THIS.cStringCnx	= THIS.cStringCnx + "WSID=" + THIS.cEstacion	+ ";"
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE conexion_access
		*!*	**********************************************************************************
		*!*	Devuelve el ID de la conexión ODBC
		*!*	**********************************************************************************
		RETURN THIS.nIDConexion
	ENDPROC


	HIDDEN PROCEDURE conexion_assign
		LPARAMETERS m.lxValor
		THIS.Conexion = m.lxValor
	ENDPROC


	*-- Inicia la conexión al Servidor SQL
	PROCEDURE conectar
		*!*	**********************************************************************************
		*!*	Procedimiento que inicia la conexión ODBC
		*!*	**********************************************************************************
		*!*	Iniciar la conexión ODBC
		LOCAL n
		THIS.GenCadena()
		THIS.nIDConexion	= SQLSTRINGCONNECT(THIS.cStringCnx)

		*!*	Verifica si se conecto correctamente
		IF THIS.nIDConexion <= 0
			THIS.ShowError()
			THIS.nIDConexion= 0
			THIS.lConectado	= .F.
		ELSE
		*!*		IF !EMPTY(THIS.cInitSP) AND !ISNULL(THIS.cInitSP)
		*!*			=SQLEXEC(THIS.nIDConexion , THIS.cInitSP , "")
		*!*		ENDIF
		    THIS.lConectado	= .T.

			*!*	Verificar si tiene Formato DMY
			n = SQLEXEC(THIS.nIDConexion,"PRINT CAST('29/09/2000' AS DATETIME)")
			IF n > 0
				THIS.cDateFormat	= "DMY"
			ELSE
				*!*	Verificar si tiene formato MDY
				n = SQLEXEC(THIS.nIDConexion,"PRINT CAST('09/29/2000' AS DATETIME)")
				IF n > 0
					THIS.cDateFormat	= "MDY"
				ELSE
					THIS.cDateFormat	= "YMD"
				ENDIF
			ENDIF
		ENDIF
		RETURN THIS.lConectado
	ENDPROC


	*-- Intenta desconectarse del Servidor SQL
	PROCEDURE desconectar
		*!*	**********************************************************************************
		*!*	Procedimiento que limpia la conexión ODBC
		*!*	**********************************************************************************
		LOCAL m.lnError
		m.lnError	= SQLDISCONNECT(THIS.nIDConexion)
		*!*	Verificar si se desconectó correctamente
		IF m.lnError # 1
			THIS.ShowError()
		ELSE
			THIS.nIDConexion	= 0
			THIS.lConectado	= .F.
		ENDIF
		RETURN THIS.lConectado
	ENDPROC


	*-- Muestra un cuadro de dialogo mostrando el error que sucede con la clase.
	HIDDEN PROCEDURE showerror
		*!*	**********************************************************************************
		*!*	Procedimiento para Mostrar los errores de conexión
		*!*	**********************************************************************************
		LOCAL m.laError , m.lcError

		DECLARE m.laError[1]
		=AERROR(m.laError)
		m.lcError	= ""
		*!*	m.lcError	= m.lcError + "NUMERO DE ERROR EN CLIENTE: " + STR(m.laError[1,1]) + CHR(13)
		m.lcError	= m.lcError + "Error Cliente : " + m.laError[1,2] + CHR(13)
		IF VARTYPE(m.laError[1,5])=="C"
			*!*		m.lcError	= m.lcError + "NUMERO DE ERROR DE ODBC: " + STR(m.laError[1,5]) + CHR(13)
			m.lcError	= m.lcError + "Error ODBC : " + m.laError[1,3]
		ENDIF

		*!*	m.lcError	= m.laError[1,2]
		*!*	m.lcError	= ALLTRIM( SUBSTR(m.lcError,RAT(']',m.lcError)+1) )

		*SET STEP ON

		*=MESSAGEBOX( m.lcError , 16 , _TIT_ERROR_ODBC )
		=MESSAGEBOX( m.lcError , 16 , "Error ODBC" )
		IF TYPE("goEntorno")=="O"
			goEntorno.GenerarLog("9000",NULL,m.lcError)
		ENDIF
	ENDPROC


	*-- Genera la cadena de parametros que se enviarán al SP. (ver cParams)
	HIDDEN PROCEDURE genstringprms
		*!*	**********************************************************************************
		*!*	Procedimiento para generar la cadena de parametros para el store procedure
		*!*	**********************************************************************************
		LOCAL m.lnCount , m.lcString
		THIS.cParams	= SPACE(0)
		IF Type("THIS.aParams[1]") <> "C"	&& No paso parámetros
			THIS.cParams	= ''
		ELSE
			FOR m.lnCount = 1 TO ALEN(THIS.aParams,1)
				THIS.cParams	= THIS.cParams + THIS.aParams[m.lnCount]
				IF m.lnCount < ALEN(THIS.aParams,1)
					THIS.cParams	= THIS.cParams + ' , '
				ENDIF
			ENDFOR
		ENDIF
	ENDPROC


	*-- Almacena la matriz de parámetros que se enviarán al SP
	PROCEDURE setprmsp
		*!*	**********************************************************************************
		*!*	Procedimiento para ajustar los valores de la matriz de parametros
		*!*	**********************************************************************************
		LPARAMETER aParametros
		DECLARE THIS.aParams[1]
		THIS.aParams[1]	= .F.
		IF TYPE("aParametros[1]") == "C"		&& si paso parámetros
			RETURN ACOPY(aParametros,THIS.aParams)>0
		ENDIF
		RETURN 0
	ENDPROC


	*-- Inicia la ejecución de la Sentencia la sentencia SQL en el Servidor
	PROCEDURE dosql
		*!*	**********************************************************************************
		*!*	Procedimiento que envia el comando SQL al servidor
		*!*	**********************************************************************************
		LPARAMETER m.lnSession
		LOCAL m.lnError , lnIDConexion , lcSQL , lcCursor
		*!*	------------------------------------------------------
		*!*	Verificar si se paso como parámetro la sesión de datos
		IF EMPTY(m.lnSession) OR VARTYPE(m.lnSession)<>'N'
			DO CASE
			CASE TYPE("THISFORM") == "O"
				m.lnSession = THISFORM.DataSessionId 
			CASE TYPE("_SCREEN.ACTIVEFORM") == "O"
				m.lnSession = _SCREEN.ACTIVEFORM.DataSessionId 
			OTHERWISE
				m.lnSession	= 1
			ENDCASE
		ENDIF
		SET DATASESSION TO (m.lnSession)

		*!*	------------------------------------------------------

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


		IF EMPTY(THIS.cCursor) OR ISNULL(THIS.cCursor)
			THIS.cCursor	= SYS(2015)
		ENDIF
		*=MESSAGEBOX(.cSQL)
		IF EMPTY(THIS.cSQL) OR ISNULL(THIS.cSQL)
			=MESSAGEBOX("Intenta ejecutar una sentencia SQL no válida",64,"Error SQL")
			RETURN -1
		ENDIF
		*m.lnError = SQLEXEC( THIS.nIDConexion , THIS.cSQL , THIS.cCursor )
		lnIDConexion	= THIS.nIDConexion
		lcSQL			= THIS.cSQL
		lcCursor		= THIS.cCursor
		m.lnError = SQLEXEC( lnIDConexion , lcSQL , lcCursor )
		THIS.GetRecords()
		*!*	Verificar si se desconectó correctamente
		IF m.lnError < 1
			THIS.ShowError()
			RETURN m.lnError
		ENDIF
		RETURN m.lnError 
	ENDPROC


	*-- Inicia la ejecución del Store Procedure
	PROCEDURE dosp
		*!*	**********************************************************************************
		*!*	Procedimiento que ejecuta el Store Procedure del Servidor
		*!*	**********************************************************************************
		LPARAMETER m.lnSession
		LOCAL m.lnError , m.lcComando
		*!*	------------------------------------------------------
		*!*	Verificar si se paso como parámetro la sesión de datos
		IF EMPTY(m.lnSession) OR VARTYPE(m.lnSession)<>'N'
			DO CASE
			CASE TYPE("THISFORM") == "O"
				m.lnSession = THISFORM.DataSessionId 
			CASE TYPE("_SCREEN.ACTIVEFORM") == "O"
				m.lnSession = _SCREEN.ACTIVEFORM.DataSessionId 
			OTHERWISE
				m.lnSession	= 1
			ENDCASE
		ENDIF
		*!*	------------------------------------------------------
		SET DATASESSION TO (m.lnSession)

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

		IF EMPTY(THIS.cCursor) OR ISNULL(THIS.cCursor)
			THIS.cCursor	= SYS(2015)
		ENDIF
		THIS.GenStringPrms()
		*m.lcComando	= ALLTRIM( "{CALL " + THIS.cSP + " (" + THIS.cParams + ")}" )
		m.lcComando	= ALLTRIM( "EXEC " + THIS.cSP + " " + THIS.cParams )
		*!*	=MESSAGEBOX(m.lcComando)
		m.lnError = SQLEXEC( THIS.nIDConexion , m.lcComando , THIS.cCursor )
		THIS.GetRecords()
		*!*	Verificar si se ejecutó correctamente
		THIS.LimpiarPrmSP()
		IF m.lnError < 1
			THIS.ShowError()
			RETURN m.lnError
		ENDIF
		RETURN  m.lnError
	ENDPROC


	*-- Actualiza la propiedad Found para indicar si se encontró o no registros.
	HIDDEN PROCEDURE getrecords
		*!*	**********************************************************************************
		*!*	Procedimiento que actualiza la variable que indica si se encontraron registros o no
		*!*	**********************************************************************************
		IF USED(THIS.cCursor)
			THIS.lDatos = RECCOUNT()>0
		ELSE
			THIS.lDatos = .F.
		ENDIF
	ENDPROC


	*-- Cierra el cursor que se generó al ejecutar una sentencia SQL o un SP
	PROCEDURE closecursor
		*!*	**********************************************************************************
		*!*	Procedimiento que cierra el cursor abierto por la clase
		*!*	**********************************************************************************
		IF USED(THIS.cCursor)
			USE IN (THIS.cCursor)
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE conectado_access
		*!*	**********************************************************************************
		*!*	Procedimiento que determina si se esta o no conectado
		*!*	**********************************************************************************
		RETURN THIS.lConectado
	ENDPROC


	HIDDEN PROCEDURE conectado_assign
		LPARAMETERS m.lxValor
		THIS.Conectado = m.lxValor
	ENDPROC


	HIDDEN PROCEDURE found_access
		*!*	**********************************************************************************
		*!*	Procedimiento que Devuelve si se encontraron registros o no
		*!*	**********************************************************************************
		RETURN THIS.lDatos
	ENDPROC


	HIDDEN PROCEDURE found_assign
		LPARAMETERS m.lxValor
		THIS.Found = m.lxValor
	ENDPROC


	*-- Extrae la configuración por defecto
	PROCEDURE getdefault
		*!*	******************************************************************************
		*!*	Rutina para obtener los valores por defecto de la conexión desde el registro
		*!*	******************************************************************************


		LOCAL lcFileINI , lcStringINI
		LOCAL lcServidor , lcBaseDatos , lcUsuario , lcPassword

		*!*	Archivo .Ini, ubicado en el Directorio de Windows, indica Servidor y Base de Datos Local.
		*lcFileINI	= ADDBS( GETENV("WINDIR") ) + "TDV.INI"
		*!*	Capturar el contenido del Archivo
		lcStringINI	= UPPER( FILETOSTR("TDV.INI") )

		*!*	Capturar el Servidor Local
		lcServidor	= SUBSTR( lcStringINI , AT( "SERVIDOR" , lcStringINI ) , AT( CHR(13) , lcStringINI ) )
		lcServidor	= ALLTRIM( SUBSTR( lcServidor , AT( "=" , lcServidor ) + 1 ) )
		*!*	Capturar la Base de Datos Local
		lcBaseDatos	= SUBSTR( lcStringINI , AT( "BASEDATOS" , lcStringINI ) )
		lcBaseDatos	= ALLTRIM( SUBSTR( lcBaseDatos , AT( "=" , lcBaseDatos ) + 1 ) )

		lcUsuario	= ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1) )

		THIS.cSourceODBC	= ""
		THIS.cServer		= lcServidor
		THIS.cDataBase		= lcBaseDatos
		THIS.cUser			= "TDV"
		THIS.cPassword		= "TDV"
	ENDPROC


	*-- Limpia los parametros que se enviaron al Store Procedure
	PROCEDURE limpiarprmsp
		*!*	**********************************************************************************
		*!*	Limpiar los valores de la matriz de parametros que se pasa al 
		*!*	**********************************************************************************
		DECLARE THIS.aParams[1]
		THIS.aParams[1]	= .F.
		RETURN .T.
	ENDPROC


	PROCEDURE servidor_access
		RETURN THIS.cServer
	ENDPROC


	PROCEDURE basedatos_access
		RETURN THIS.cDataBase
	ENDPROC


	PROCEDURE gencadena2
		PARAMETERS PcDRIVER,PcSERVER,PcDATABASE,PcPORT,PcUID,PcPWD,PcWSID
		*!*	**********************************************************************************
		*!*	Procedimiento para generar la cadena de conexión ODBC
		*!*	**********************************************************************************
		THIS.cStringCnx2	= SPACE(0)

		THIS.cStringCnx2	= THIS.cStringCnx2 + "DRIVER=" + PcDRIVER + ";"

		THIS.cStringCnx2	= THIS.cStringCnx2 + "SERVER="	+ PcSERVER		+ ";"


		THIS.cStringCnx2	= THIS.cStringCnx2 + "DATABASE="	+ PcDATABASE	+ ";"

		IF !ISNULL(PcPORT) AND !EMPTY(PcPORT)
			THIS.cStringCnx2	= THIS.cStringCnx2 + "PORT=" + PcPORT	+ ";"
		ENDIF

		THIS.cStringCnx2	= THIS.cStringCnx2 + "UID="		+ PcUID		+ ";"

		THIS.cStringCnx2	= THIS.cStringCnx2 + "PWD="		+ PCPWD	+ ";LANGUAGE=Español;TranslationName=Yes;"

		*!*	THIS.cStringCnx	= THIS.cStringCnx + "UID="		+ THIS.cUser		+ ";"
		*!*	THIS.cStringCnx	= THIS.cStringCnx + "PWD="		+ THIS.cPassword	+ ";"

		IF !ISNULL(PcWSID) AND !EMPTY(PcWSID)
			THIS.cStringCnx2	= THIS.cStringCnx2 + "WSID=" + PcWSID	+ ";"
		ENDIF
	ENDPROC


	PROCEDURE gencadena3
		PARAMETERS PcDRIVER,PcSERVER,PcDATABASE,PcPORT,PcUID,PcPWD,PcWSID
		*!*	**********************************************************************************
		*!*	Procedimiento para generar la cadena de conexión ODBC
		*!*	**********************************************************************************
		THIS.cStringCnx3	= SPACE(0)

		THIS.cStringCnx3	= THIS.cStringCnx3 + "DRIVER=" + PcDRIVER + ";"

		THIS.cStringCnx3	= THIS.cStringCnx3 + "SERVER="	+ PcSERVER		+ ";"


		THIS.cStringCnx3	= THIS.cStringCnx3 + "DATABASE="	+ PcDATABASE	+ ";"

		IF !ISNULL(PcPORT) AND !EMPTY(PcPORT)
			THIS.cStringCnx3	= THIS.cStringCnx3 + "PORT=" + PcPORT	+ ";"
		ENDIF

		THIS.cStringCnx3	= THIS.cStringCnx3 + "UID="		+ PcUID		+ ";"

		THIS.cStringCnx3	= THIS.cStringCnx3 + "PWD="		+ PCPWD	+ ";LANGUAGE=Español;TranslationName=Yes;"

		*!*	THIS.cStringCnx	= THIS.cStringCnx + "UID="		+ THIS.cUser		+ ";"
		*!*	THIS.cStringCnx	= THIS.cStringCnx + "PWD="		+ THIS.cPassword	+ ";"

		IF !ISNULL(PcWSID) AND !EMPTY(PcWSID)
			THIS.cStringCnx3	= THIS.cStringCnx3 + "WSID=" + PcWSID	+ ";"
		ENDIF
	ENDPROC


	*-- Carga parametros para armar cadena de conexion desde archivo INI
	PROCEDURE cargaparmscadcnxarcini
		LPARAMETER PcArchIni 
		IF VARTYPE(PcArchIni)	<>	'C'
			PcArchIni = 'CONFIG.INI'
		ENDIF
		IF EMPTY(PcArchIni)
			PcArchIni = 'CONFIG.INI'
		ENDIF
		LcFileIni = LOCFILE(PcArchIni) 
		*!*	Leer el Archivo .INI
		lcStringINI	= FILETOSTR(PcArchIni) && UPPER( FILETOSTR("CONFIG.INI") )
		oIniVal=NEWOBJECT("oldinireg","registry.vcx")
		lcvalue=''
		oIniVal.getinientry(@lcvalue,'Database Engine2','BackEnd2',LcFileINI) 
		This.cBackEnd2  = lcvalue
		IF EMPTY(this.cBackend2) OR UPPER(this.cBackend2)='VFPDBC'
			**RETURN 
		ENDIF

		*!* Valores iniciales de las propiedades
		WITH THIS
					.cSourceODBC2	= SPACE(0)
					.cServer2		= SPACE(0)
					.cDriver2 		= SPACE(0)
					.nPort2			= 0
					.cDataBase2		= SPACE(0)
					.cUser2			= SPACE(0)
					.cEstacion2		= ALLTRIM( LEFT(SYS(0),AT('#',SYS(0))-1) )
					.cPassword2		= SPACE(0)
					.cStringCnx2	= SPACE(0)
					.cParams2		= SPACE(0)
					.nIDConexion2	= 0
					.lDatos2		= .F.
					.cSQL2			= SPACE(0)
					.cSP2			= SPACE(0)
					.cCursor2		= SPACE(0)
					.lConectado2	= .F.
				*	.cInitSP	= ""
					** Servidor 2
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Server2','Servidor2',LcFileINI) 
					.cServer2 = lcvalue
					** Base datos 2
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Base de Datos2','BaseDatos2',LcFileINI) 
					.cDataBase2 = lcvalue
					** Driver 2
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Database Engine2','Driver2',LcFileINI) 
					.cDriver2	= lcvalue
					** Puerto 2
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Database Engine2','Port2',LcFileINI) 
					.nPort2	= lcvalue
					** Usuario 2
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Usuario2','Usuario2',LcFileINI) 
					.cUser2 = lcvalue
					** Password 2
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Clave2','Password2',LcFileINI) 
					.cPassword2 = lcvalue
					** Generamos cadena de conexion 2
					this.GenCadena2(.cDriver2 , .cServer2 , .cDataBase2 , .nPort2, .cUser2, .cPassword2 )

					*IF PARAMETERS() == 5
						*.SetParams(m.lcSourceODBC ,	m.lcServer , m.lcDataBase , m.lcUser , m.lcPassword)
					*ENDIF

					.cSourceODBC3	= SPACE(0)
					.cServer3		= SPACE(0)
					.cDriver3 		= SPACE(0)
					.nPort3			= 0
					.cDataBase3		= SPACE(0)
					.cUser3			= SPACE(0)
					.cEstacion3		= ALLTRIM( LEFT(SYS(0),AT('#',SYS(0))-1) )
					.cPassword3		= SPACE(0)
					.cStringCnx3	= SPACE(0)
					.cParams3		= SPACE(0)
					.nIDConexion3	= 0
					.lDatos3		= .F.
					.cSQL3			= SPACE(0)
					.cSP3			= SPACE(0)
					.cCursor3		= SPACE(0)
					.lConectado3	= .F.
				*	.cInitSP	= ""
					** Servidor 3
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Server3','Servidor3',LcFileINI) 
					.cServer3 = lcvalue
					** Base datos 3
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Base de Datos3','BaseDatos3',LcFileINI) 
					.cDataBase3 = lcvalue
					** Driver 3
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Database Engine3','Driver3',LcFileINI) 
					.cDriver3	= lcvalue
					** Puerto 3
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Database Engine3','Port3',LcFileINI) 
					.nPort3	= lcvalue
					** Usuario 3
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Usuario3','Usuario3',LcFileINI) 
					.cUser3 = lcvalue
					** Password 3
					lcvalue=''
					oIniVal.getinientry(@lcvalue,'Clave3','Password3',LcFileINI) 
					.cPassword3 = lcvalue
					** Generamos cadena de conexion 2
					this.GenCadena3(.cDriver3 , .cServer3 , .cDataBase3 , .nPort3, .cUser3, .cPassword3 )


		ENDWITH
	ENDPROC


	PROCEDURE Init
		LPARAMETER m.lcSourceODBC ,	m.lcServer , m.lcDataBase , m.lcUser , m.lcPassword
		LcFileIni = LOCFILE("CONFIG.INI") 
		*!*	Leer el Archivo .INI
		lcStringINI	= FILETOSTR("CONFIG.INI") && UPPER( FILETOSTR("CONFIG.INI") )
		oIniVal=NEWOBJECT("oldinireg","registry.vcx")
		lcvalue=''
		oIniVal.getinientry(@lcvalue,'Database Engine','BackEnd',LcFileINI) 
		This.cBackEnd  = lcvalue
		IF EMPTY(this.cBackend) OR UPPER(this.cBackend)='VFPDBC'
			**RETURN 
		ENDIF
		*!* Valores iniciales de las propiedades
		WITH THIS
			.cSourceODBC= SPACE(0)
			.cServer	= SPACE(0)
			.cDataBase	= SPACE(0)
			.cUser		= SPACE(0)
			.cEstacion	= ALLTRIM( LEFT(SYS(0),AT('#',SYS(0))-1) )
			.cPassword	= SPACE(0)
			.cStringCnx	= SPACE(0)
			.cParams	= SPACE(0)
			.nIDConexion= 0
			.lDatos		= .F.
			.cSQL		= SPACE(0)
			.cSP		= SPACE(0)
			.cCursor	= SPACE(0)
			.lConectado	= .F.
		*	.cInitSP	= ""

			*!*	Archivo .INI , para determinar SERVIDOR y BASEDATOS por defecto
			*lcFileINI	= ADDBS( GETENV("WINDIR") ) + "TDV.INI"
			LcFileIni = LOCFILE("CONFIG.INI") 
			*!*	Leer el Archivo .INI
			lcStringINI	= FILETOSTR("CONFIG.INI") && UPPER( FILETOSTR("CONFIG.INI") )
			oIniVal=NEWOBJECT("oldinireg","registry.vcx")
			*!*	Obtener el Servidor por Defecto
		*!*		lcServidor	= SUBSTR( lcStringINI , AT( "SERVIDOR" , lcStringINI ) )
		*!*		lcServidor	= ALLTRIM( SUBSTR( lcServidor , AT( "=" , lcServidor ) + 1 ) )
		*!*		IF CHR(13) $ lcServidor
		*!*			lcServidor	= ALLTRIM( LEFT (  lcServidor , AT( CHR(13) , lcServidor ) - 1 ) )
		*!*		ENDIF
		*!*		lcServidor	= STRTRAN( lcServidor , CHR(13) , "" )
		*!*		lcServidor	= STRTRAN( lcServidor , CHR(10) , "" )
			lcvalue=''
			oIniVal.getinientry(@lcvalue,'Server','Servidor',LcFileINI) 
			lcServidor = lcvalue

			*!*	Obtener la Base de Datos por Defecto
		*!*		lcBaseDatos	= SUBSTR( lcStringINI , AT( "BASEDATOS" , lcStringINI) )
		*!*		lcBaseDatos	= ALLTRIM( SUBSTR( lcBaseDatos , AT( "=" , lcBaseDatos ) + 1 ) )
		*!*		IF CHR(13) $ lcBaseDatos
		*!*			lcBaseDatos	= ALLTRIM( LEFT (  lcBaseDatos , AT( CHR(13) , lcBaseDatos	) - 1 ) )
		*!*		ENDIF
		*!*		lcBaseDatos	= STRTRAN( lcBaseDatos , CHR(13) , "" )
		*!*		lcBaseDatos	= STRTRAN( lcBaseDatos , CHR(10) , "" )
			lcvalue=''
			oIniVal.getinientry(@lcvalue,'Base de Datos','BaseDatos',LcFileINI) 
			lcBaseDatos = lcvalue

			*!*	Obtener el Usuario por Defecto
		*!*		lcUsuario	= SUBSTR( lcStringINI , AT( "USUARIO" , lcStringINI) )
		*!*		lcUsuario	= ALLTRIM( SUBSTR( lcUsuario , AT( "=" , lcUsuario ) + 1 ) )
		*!*		IF CHR(13) $ lcUsuario
		*!*			lcUsuario	= ALLTRIM( LEFT (  lcUsuario , AT( CHR(13) , lcUsuario	) - 1 ) )
		*!*		ENDIF
		*!*		lcUsuario	= STRTRAN( lcUsuario , CHR(13) , "" )
		*!*		lcUsuario	= STRTRAN( lcUsuario , CHR(10) , "" )
			lcvalue=''
			oIniVal.getinientry(@lcvalue,'Usuario','Usuario',LcFileINI) 
			lcUsuario = lcvalue

			*!*	Obtener la clave del usuario por defecto
		*!*		lcPassword	= SUBSTR( lcStringINI , AT( "PASSWORD" , lcStringINI) )
		*!*		lcPassword	= ALLTRIM( SUBSTR( lcPassword , AT( "=" , lcPassword ) + 1 ) )
		*!*		IF CHR(13) $ lcPassword
		*!*			lcPassword	= ALLTRIM( LEFT (  lcPassword , AT( CHR(13) , lcPassword	) - 1 ) )
		*!*		ENDIF
		*!*		lcPassword	= STRTRAN( lcPassword , CHR(13) , "" )
		*!*		lcPassword	= STRTRAN( lcPassword , CHR(10) , "" )
			lcvalue=''
			oIniVal.getinientry(@lcvalue,'Clave','Password',LcFileINI) 
			lcPassword = lcvalue

			*!*	Obtener el Store Procedure de Inicializacion
		*!*		lcInitSP	= SUBSTR( lcStringINI , AT( "INIT_SP" , lcStringINI) )
		*!*		lcInitSP	= ALLTRIM( SUBSTR( lcInitSP	, AT( "=" , lcInitSP ) + 1 ) )
		*!*		IF CHR(13) $ lcInitSP
		*!*			lcInitSP	= ALLTRIM( LEFT (  lcInitSP	 , AT( CHR(13) , lcInitSP ) - 1 ) )
		*!*		ENDIF
		*!*		lcInitSP	= STRTRAN( lcInitSP	, CHR(13) , "" )
		*!*		lcInitSP	= STRTRAN( lcInitSP	, CHR(10) , "" )

		*!*		.cInitSP	= lcInitSP

			.cUser		= lcUsuario       && UPPER(lcUsuario)
			.cPassword	= lcPassword    && UPPER(lcPassword)

			.cServer	= lcServidor
			.cDataBase	= lcBaseDatos

			*IF PARAMETERS() == 5
				*.SetParams(m.lcSourceODBC ,	m.lcServer , m.lcDataBase , m.lcUser , m.lcPassword)
			*ENDIF
		ENDWITH
	ENDPROC


	*-- Genera una cadena de conexion en base parametros en tiempo de ejecucion no depende de archivo ini
	PROCEDURE gennewstringconn
		PARAMETERS PcDRIVER,PcSERVER,PcDATABASE,PcPORT,PcUID,PcPWD,PcWSID
		*!*	**********************************************************************************
		*!*	Procedimiento para generar la cadena de conexión ODBC
		*!*	**********************************************************************************
		THIS.cStringCnxNew 	= SPACE(0)

		THIS.cStringCnxNew	= THIS.cStringCnxNew + "DRIVER=" + PcDRIVER + ";"

		THIS.cStringCnxNew	= THIS.cStringCnxNew + "SERVER="	+ PcSERVER		+ ";"


		THIS.cStringCnxNew	= THIS.cStringCnxNew + "DATABASE="	+ PcDATABASE	+ ";"

		IF !ISNULL(PcPORT) AND !EMPTY(PcPORT)
			THIS.cStringCnxNew	= THIS.cStringCnxNew + "PORT=" + PcPORT	+ ";"
		ENDIF

		THIS.cStringCnxNew	= THIS.cStringCnxNew + "UID="		+ PcUID		+ ";"

		THIS.cStringCnxNew	= THIS.cStringCnxNew + "PWD="		+ PCPWD	+ ";LANGUAGE=Español;TranslationName=Yes;"

		*!*	THIS.cStringCnx	= THIS.cStringCnx + "UID="		+ THIS.cUser		+ ";"
		*!*	THIS.cStringCnx	= THIS.cStringCnx + "PWD="		+ THIS.cPassword	+ ";"

		IF !ISNULL(PcWSID) AND !EMPTY(PcWSID)
			THIS.cStringCnxNew	= THIS.cStringCnxNew + "WSID=" + PcWSID	+ ";"
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cnxgen_odbc
**************************************************


**************************************************
*-- Class:        entorno (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   04/26/17 06:02:07 PM
*
#INCLUDE "k:\aplvfp\bsinfo\progs\const.h"
*
DEFINE CLASS entorno AS custom


	Height = 76
	Width = 100
	*-- Es un objeto que contiene informacion del usuario atachado a la red
	user = ""
	*-- Es un objeto que contiene información de la conexión ODBC por defecto
	conexion = ""
	*-- Ruta de los archivos temporales
	tmppath = ""
	*-- Ruta de los archivos locales
	locpath = ""
	*-- Nombre de la base de datos de seguridad del sistema
	basedatos = ""
	*-- Nombre del Servidor donde se encuentra la base de datos de seguridad del Sistema
	servidor = ""
	*-- Ruta de la compañia
	tspathcia = ""
	*-- path administrativo del sistema debe contener la ruta de donde esta localizada la base de datos ADMIN.DBC
	tspathadm = ([])
	*-- path  que debe contener la ruta de donde esta localizadas otras fuentes de datos  (.DBF , .DBC, .MDF, .LDF , etc)
	tspathdata = ([])
	Name = "entorno"
	sistema = .F.
	modulo = .F.

	*-- Es el codigo del perfil del usuario
	perfil = .F.
	descripcionsistema = .F.

	*-- Es .t. si se esta comunicando con un servidor de datos Sql
	sqlentorno = .F.
	conexion_db_vfp = .F.

	*-- Compañia actual de trabajo
	gscodcia = .F.

	*-- Periodo actual de trabajo
	gsperiodo = .F.

	*-- Es .t. si se esta comunicado con un servidor de datos a traves de ADO
	adoentorno = .F.

	*-- Es .t. si se esta comunicando con un servidor de datos VFP DBC
	vfpdbcentorno = .F.

	*-- Servidor de datos por defecto
	cdefaultbackendconecct = .F.

	*-- Pide compañia
	lpidcia = .F.
	DIMENSION atoolbars[1,1]


	*-- Muestra las barras de herramientas luego de terminar una sesión
	PROCEDURE showtoolbars
		LOCAL i
		FOR i = 1 TO ALEN(THIS.aToolBars, 1)
			IF THIS.aToolBars[i,2]
				SHOW WINDOW (THIS.aToolBars[i,1])
			ENDIF
		ENDFOR
	ENDPROC


	*-- Esconde las barras de herramientas activas antes de iniciar una sesión.
	PROCEDURE releasetoolbars
		LOCAL i
		**

		#IF VERSION(3) == "00"
			#DEFINE TB_FORMDESIGNER_LOC  "Form Designer"
			#DEFINE TB_STANDARD_LOC      "Standard"
			#DEFINE TB_LAYOUT_LOC        "Layout"
			#DEFINE TB_QUERY_LOC		 "Query Designer"
			#DEFINE TB_VIEWDESIGNER_LOC  "View Designer"
			#DEFINE TB_COLORPALETTE_LOC  "Color Palette"
			#DEFINE TB_FORMCONTROLS_LOC  "Form Controls"
			#DEFINE TB_DATADESIGNER_LOC  "Database Designer"
			#DEFINE TB_REPODESIGNER_LOC  "Report Designer"
			#DEFINE TB_REPOCONTROLS_LOC  "Report Controls"
			#DEFINE TB_PRINTPREVIEW_LOC  "Print Preview"
			#DEFINE WIN_COMMAND_LOC		 "Command"
		#ELSE
			#DEFINE TB_FORMDESIGNER_LOC  "Diseñador de formularios"
			#DEFINE TB_STANDARD_LOC      "Estándar"
			#DEFINE TB_LAYOUT_LOC        "Diseño"
			#DEFINE TB_QUERY_LOC		 "Diseñador de consultas"
			#DEFINE TB_VIEWDESIGNER_LOC  "Diseñador de vistas"
			#DEFINE TB_COLORPALETTE_LOC  "Paleta de colores"
			#DEFINE TB_FORMCONTROLS_LOC  "Controles de formularios"
			#DEFINE TB_DATADESIGNER_LOC  "Diseñador de bases de datos"
			#DEFINE TB_REPODESIGNER_LOC  "Diseñador de informes"
			#DEFINE TB_REPOCONTROLS_LOC  "Controles de informes"
			#DEFINE TB_PRINTPREVIEW_LOC  "Vista preliminar"
			#DEFINE WIN_COMMAND_LOC		 "Comandos"
		#ENDIF

		DIMENSION THIS.aToolBars[12,2]
		THIS.aToolBars[1,1] = TB_FORMDESIGNER_LOC
		THIS.aToolBars[2,1] = TB_STANDARD_LOC
		THIS.aToolBars[3,1] = TB_LAYOUT_LOC
		THIS.aToolBars[4,1] = TB_QUERY_LOC
		THIS.aToolBars[5,1] = TB_VIEWDESIGNER_LOC
		THIS.aToolBars[6,1] = TB_COLORPALETTE_LOC
		THIS.aToolBars[7,1] = TB_FORMCONTROLS_LOC
		THIS.aToolBars[8,1] = TB_DATADESIGNER_LOC
		THIS.aToolBars[9,1] = TB_REPODESIGNER_LOC
		THIS.aToolBars[10,1] = TB_REPOCONTROLS_LOC
		THIS.aToolBars[11,1] = TB_PRINTPREVIEW_LOC
		THIS.aToolBars[12,1] = WIN_COMMAND_LOC

		FOR i = 1 TO ALEN(THIS.aToolBars, 1)
			THIS.aToolBars[i,2] = WVISIBLE(THIS.aToolBars[i,1])
			IF THIS.aToolBars[i,2]
				HIDE WINDOW (THIS.aToolBars[i,1])
			ENDIF
		ENDFOR
	ENDPROC


	*-- Trae tabla remota a una PC de ambiente Local
	PROCEDURE gettableremotetolocal
		*
		* tcTable	: Nombre de la Tabla a extraer Ruta desde el Servidor
		* Return	: Verdadero si Terminó con éxito
		*			  Falso lo contrario

		LPARAMETERS tcTable, tcWhere, tcTableLocal,tnRemoteLocal

		LOCAL loTools,lcTable,lcBaseDatos, lcAreaAnterior , lnParametros , lcDBC , lcObjectID

		lnParametros = PARAMETERS()
		DO CASE
		CASE lnParametros = 0
			RETURN .F.
		CASE lnParametros = 1
			tcWhere = ""
		CASE lnParametros = 2
			tcTableLocal = tcTable
		CASE lnParametros = 3
			tnRemoteLocal = 0
		ENDCASE

		lcAreaAnterior = ALIAS()
		*!* Verifica si existe la BD en VFP
		lcBaseDatos = ALLTRIM(THIS.BaseDatos)
		lcDBC		= ALLTRIM(THIS.LocPath) + lcBaseDatos + ".DBC"

		IF !FILE( lcDBC )
			CREATE DATABASE (ALLTRIM(THIS.LocPath) + lcBaseDatos)
			SET DATABASE TO (lcBaseDatos)
		ELSE
			OPEN DATABASE (ALLTRIM(THIS.LocPath) + lcBaseDatos)
			SET DATABASE TO (lcBaseDatos)
		ENDIF

		*!* Si existe la tabla a crear, primero la remueve de la BD de VFP
		lcTableLocal = UPPER( ALLTRIM(THIS.LocPath) + tcTableLocal )
		IF FILE(lcTableLocal + ".DBF")
			IF USED(tcTableLocal)
				SELECT (tcTableLocal)
				USE
			ENDIF
			USE (lcDBC) AGAIN ALIAS Base_De_Datos IN 0 SHARED NOUPDATE
			DECLARE xxx[1]

			SELECT ObjectID ;
				FROM	;
				Base_De_Datos ;
				WHERE	;
				ALLTRIM(ObjectType)=="Table" AND ;
				ALLTRIM(UPPER(ObjectName))==UPPER(tcTableLocal) ;
				INTO ARRAY xxx

			USE IN Base_De_Datos
			IF !EMPTY(_TALLY)
				REMOVE TABLE (tcTableLocal) DELETE
			ELSE
				ERASE (lcTableLocal + ".DBF")
			ENDIF
		ELSE
			USE (lcDBC) AGAIN ALIAS Base_De_Datos IN 0 SHARED
			DECLARE xxx[1]

			SELECT ObjectID ;
				FROM	;
				Base_De_Datos ;
				WHERE	;
				ALLTRIM(ObjectType)=="Table" AND ;
				ALLTRIM(UPPER(ObjectName))==UPPER(tcTableLocal) ;
				INTO ARRAY xxx

			IF _TALLY > 0
				lcObjectID = xxx(1)

				DELETE FROM Base_De_Datos WHERE ObjectID = lcObjectID OR ParentID = lcObjectID
				CLOSE DATABASE
				OPEN DATABASE (ALLTRIM(THIS.LocPath) + lcBaseDatos)
			ENDIF
			IF USED("Base_De_Datos")
				USE IN Base_De_Datos
			ENDIF
		ENDIF

		lcTablePath = THIS.RemotePathEntidad(tcTable,tnRemoteLocal)

		IF ISNULL(lcTablePath) OR EMPTY(lcTablePath)
			RETURN .F.
		ENDIF

		WAIT WINDOW "Obteniendo la Tabla : " + tcTable + " .... Espere" NOWAIT

		goConexion.cSQL		= "SELECT * FROM " + lcTablePath + " " + tcWhere
		goConexion.cCursor	= tcTable
		goConexion.DoSQL()

		*IF THIS.Conexion.FOUND
			SELECT (tcTable)
			COPY TO (lctableLocal) DATABASE ( lcBaseDatos )
		*ENDIF

		*goConexion.CloseCursor()
		*CLOSE DATABASE

		IF !EMPTY( lcAreaAnterior )
			SELECT ( lcAreaAnterior )
		ENDIF
		WAIT CLEAR

		RETURN .T.
	ENDPROC


	*-- Genera tabla Locales a Partir de la Tabla GEntidades utilizando la columna FlagLocal
	PROCEDURE generartablaslocales
		LOCAL loTools
		WITH THIS
			lcTablePath = .RemotePathEntidad("CLAGEN_GEntidades",1)
			goConexion.cSQL	= "SELECT "+;
				" NombreEntidad, "+;
				" DescripcionEntidad, "+;
				" NombreTablaLocal "+;
				" FROM "+lcTablePath +;
				" WHERE FlagTablaLocal = 1 "

			goConexion.cCursor	= '__GEntidades'
			goConexion.DoSQL()

			IF goConexion.FOUND
				SELECT ( goConexion.cCursor )
				GO TOP
				SCAN
					lcTable = ALLTRIM( NombreEntidad )
					IF	EMPTY(NombreTablaLocal) OR ISNULL(NombreTablaLocal)
						lcTableLocal = ALLTRIM( NombreEntidad )
					ELSE
						lcTableLocal = ALLTRIM( NombreTablaLocal )
					ENDIF
					.GetTableRemoteToLocal(lcTable, '', lcTableLocal,1 )
				ENDSCAN
			ENDIF
		ENDWITH
		USE IN __GEntidades
		CLOSE DATABASES ALL
	ENDPROC


	*-- Obtiene la ruta exacta donde se encuenra la entidad enviada como parametro. Servidor.BaseDato.dbo.Entidad
	PROCEDURE remotepathentidad
		*!*	Retorna el nombre de la Entidad con la ruta completa del servidor
		LPARAMETERS tcNombreEntidad , tnRemoteLocal , tlFlagBusqueda
		LOCAL lcRemotePathEntidad, lcSrvDB , lcArea

		tnRemoteLocal	= IIF( VARTYPE(tnRemoteLocal) = "N" , tnRemoteLocal , 0 )
		tcNombreEntidad = ALLTRIM(tcNombreEntidad)
		lcArea 			= ALIAS()

		lcRemotePathEntidad = ''

		m.NombreEntidad	= tcNombreEntidad
		*lcSrvDB = ALLTRIM(.Servidor) + "." + ALLTRIM(.BaseDatos) + ".dbo."
		*lcSrvDB	= ""

		IF tnRemoteLocal = 1   && Remoto acceso a servidor de base de datos
			goConexion.cSQL = "SELECT  CodigoEntidad ,  " + ;
				" NombreEntidad ,  " + ;
				" NombreServidor , " + ;
				" NombreBasedatos, " + ;
				" FlagBusqueda     " + ;
				" FROM CLAGEN_GEntidades " + ;
				" WHERE NombreEntidad = ?m.NombreEntidad "
			goConexion.cCursor = "Cursor_SQL"
			goConexion.DoSQL()

			_TALLY = IIF(goConexion.FOUND,1,0)

		ELSE

			SELECT	CodigoEntidad ,  ;
				NombreEntidad ,  ;
				NombreServidor,  ;
				NombreBasedatos, ;
				FlagBusqueda ;
				FROM goEntorno.LocPath+"GEntidades" ;
				WHERE UPPER(ALLTRIM(NombreEntidad)) == UPPER(tcNombreEntidad) ;
				INTO CURSOR Cursor_SQL

		ENDIF

		IF EMPTY(_TALLY)
			** VETT  12/02/2013 08:42 AM : SqlEntorno debe homologarse al valor de TnLocalRemoto si TnLocalRemoto=0 
			IF NOT GoEntorno.SqlEntorno OR  tnRemoteLocal = 0	&& NO estoy accediendo a un servidor de base de datos
				LcRemotePathEntidad = goentorno.open_dbf1('RUTA',tcNombreEntidad,'','','')
			ELSE
				lcRemotePathEntidad = tcNombreEntidad
			endif
			tlFlagBusqueda		= .F.
		ELSE
			IF NOT GoEntorno.SqlEntorno OR  tnRemoteLocal = 0	&& NO estoy accediendo a un servidor de base de datos
		*!*			LcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreEntidad)
				LcRemotePathEntidad = goentorno.open_dbf1('RUTA',Cursor_SQL.NombreEntidad,'','','')
			ELSE
				DO CASE
						*!*	El servidor por defecto es diferente al que se obtuvo
					CASE UPPER(ALLTRIM(goConexion.Servidor)) <> UPPER(ALLTRIM(Cursor_SQL.NombreServidor))
						*!*	Retorna	: Servidor.BaseDatos.dbo.Tabla
						lcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreServidor)+"."+ALLTRIM(Cursor_SQL.NombreBaseDatos)+".dbo."+ALLTRIM(Cursor_SQL.NombreEntidad)
						*!*	El servidor por defecto es igual al que se obtuvo, pero la Base de Datos es Diferente
					CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(Cursor_SQL.NombreServidor)) AND ;
							UPPER(ALLTRIM(goConexion.BaseDatos))<> UPPER(ALLTRIM(Cursor_SQL.NombreBaseDatos))
						*!*	Retorna	: BaseDatos.dbo.Tabla
						lcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreBaseDatos)+".dbo."+ALLTRIM(Cursor_SQL.NombreEntidad)
						*!*	El servidor por defecto es igual al que se obtuvo, y la Base de Datos tambien
					CASE UPPER(ALLTRIM(goConexion.Servidor)) == UPPER(ALLTRIM(Cursor_SQL.NombreServidor)) AND ;
							UPPER(ALLTRIM(goConexion.BaseDatos))== UPPER(ALLTRIM(Cursor_SQL.NombreBaseDatos))
						*!*	Retorna	: Tabla
						lcRemotePathEntidad = ALLTRIM(Cursor_SQL.NombreEntidad)
				ENDCASE
			ENDIF
			tlFlagBusqueda		= Cursor_SQL.FlagBusqueda
		ENDIF

		USE IN Cursor_SQL

		IF USED("GEntidades")
			USE IN GEntidades
		ENDIF

		IF !EMPTY(lcArea)
			SELECT (lcArea)
		ENDIF

		RETURN lcRemotePathEntidad
	ENDPROC


	*-- Obtiene la tabla del perfil de usuario para la seguridad del sistema
	PROCEDURE generarperfilusuario
		LOCAL lcWhere
		m.LoginUsuario	= UPPER(ALLTRIM(goEntorno.User.Login))
		lcWhere = " WHERE LoginUsuario = ?m.LoginUsuario"

		THIS.GetTableRemoteToLocal("ADMSEG_Perfil_Usuario",lcWhere,"Perfil_Usuario",1)

		IF !USED("Perfil_Usuario")
			USE (THIS.LocPath + "Perfil_Usuario") IN 0 SHARED NOUPDATE
		ENDIF

		THIS.Perfil = Perfil_Usuario.CodigoPerfil

		USE IN Perfil_Usuario

		THIS.GetTableRemoteToLocal("ADMSEG_Perfil_Botones",lcWhere,"Perfil_Botones",1)

		CLOSE DATABASES ALL
	ENDPROC


	PROCEDURE generarlog
		LPARAMETERS xCodTransacc,xcodboton, xdeserror , xCodigoFormulario
		lnParameter = PARAMETERS()
		IF NOT GoEntorno.SqlEntorno  OR  .T.  && Desactivado por ahora VETT 2013/02/09
			RETURN
		ENDIF
		IF VARTYPE(xdeserror)=="C"
			m.lcError = xdeserror
		ELSE
			m.lcError 	=	''
		ENDIF


		IF VARTYPE(xCodBoton)<>"C" OR EMPTY(xCodBoton)
			xCodBoton = NULL
		ENDIF

		*local m.lcUser, m.lcSistema, m.lcModulo, m.lcForm, m.lcSisModFor, m.lcError

		m.lcTransac	= 	xCodTransacc
		m.lcUser 	=	goEntorno.USER.login
		m.lcSistema	= 	goEntorno.Sistema
		m.lcModulo	= 	goEntorno.Modulo
		m.lcBoton	= 	xcodboton

		DO CASE
			CASE TYPE("THISFORM.CodigoFormulario")=="C"
				m.lcFormulario	=	THISFORM.CodigoFormulario
			CASE TYPE("_SCREEN.ACTIVEFORM.CodigoFormulario")=="C"
				m.lcFormulario	=	_SCREEN.ACTIVEFORM.CodigoFormulario
			OTHERWISE
				IF lnParameter	= 4
					m.lcFormulario	=	xCodigoFormulario
				ELSE
					m.lcFormulario	=	NULL
				ENDIF
		ENDCASE

		*m.lcSisModFor	= 	m.lcSistema	+	m.lcModulo	+	m.lcForm


		goConexion.cSQL = "exec " + goEntorno.RemotePathEntidad("ADMAUD1_Log_Transacciones_Edt")+"  "+;
			"@pCodigoTransaccion	= ?m.lcTransac	, " + ;
			"@pLoginUsuario 		= ?m.lcUser		, " + ;
			"@pCodigoBoton 			= ?m.lcBoton	, " + ;
			"@pCodigoSistema	 	= ?m.lcSistema	, " + ;
			"@pCodigoModulo	 		= ?m.lcModulo	, " + ;
			"@pCodigoFormulario	 	= ?m.lcFormulario, " + ;
			"@pDescripcionError 	= ?m.lcError"
		goConexion.DoSQL()
	ENDPROC


	*-- 'RUTA' -> devuelve path ,'ABRIR' -> abre tabla, TEMP_STR -> Crea una estructura vacia , TEMP_SQL -> Crea cursor actualizable
	PROCEDURE open_dbf1
		PARAMETER cAccion,cArchivo,cAlias,cTag,cExclu
		LOCAL LsRutaTabla,LsArea_Act,LcArcTmp
		IF PARAMETERS()<2
			RETURN -1
		ENDIF
		LsArea_Act=SELECT()

		IF UPPER(cAccion) ='TEMP'
			DO CASE 
				CASE UPPER(cAccion) ='TEMP_STR'
					IF EMPTY(cArchivo) or ISNULL(cArchivo)
						RETURN .f.
					ENDIF
					IF !USED(cArchivo)
						RETURN .f.
					ENDIF

					LcArcTmp = this.tmppath +SYS(3)
					SELECT (cArchivo)
					COPY STRUCTURE TO (LcArcTmp) with cdx
					SELECT 0
					use (LcArcTmp) ALIAS (cAlias) EXCLU  
				CASE UPPER(cAccion) ='TEMP_SQL'
					IF EMPTY(cArchivo) or ISNULL(cArchivo)
						RETURN .f.
					ENDIF
					IF !USED(cArchivo)
						RETURN .f.
					ENDIF
					LcArcTmp = this.tmppath +SYS(3)
					IF VERSION(5) < 700    
						select * from (cArchivo) where 0>1 into Cursor temporal
						SELE Temporal
						COPY TO (LcArcTmp)
						USE IN TEMPORAL
						SELE 0
						USE (LcArcTmp) ALIAS (cAlias) EXCLUSIVE
					ELSE
						SELECT * from (cArchivo) where 0>1 into cursor (cAlias) readwrite 
					ENDIF

			ENDCASE
			IF !EMPTY(LsArea_act)
				SELE (LsArea_Act)
			ENDIF
			RETURN .t.
		ENDIF


			IF USED('DBFS')
				SELECT DBFS
			ELSE
				SELECT 0
				use ADMIN!sistdbfs ORDER archivo ALIAS dbfs AGAIN 
			ENDIF
			**SEEK PADR(UPPER(cSistema),LEN(DBFS.SISTEMA))+UPPER(cArchivo)

			IF !SEEK(TRIM(UPPER(cArchivo)),'DBFS','ARCHIVO')
				=MESSAGEBOX('No esta definida la tabla '+cArchivo+ ' en el registro de entidades',0+16,'Error Crítico')
				RETURN .f.
			ENDIF
			*** Ubico la base de datos a la que pertenece la tabla ***
			LsDBC=''
			DO CASE
				CASE dbfs.connect = 'FOXPRO.DBC'
					DO CASE
						CASE 	!(EMPTY(DBFS.Basedatos) OR ISNULL(DBFS.Basedatos))	 
							LsDBC=TRIM(Basedatos)
							LsRutaTabla=TRIM(Basedatos)+'!'+cArchivo 
						CASE	EMPTY(DBFS.Basedatos) OR ISNULL(DBFS.Basedatos)
							DO CASE
								CASE DBFS.Ubicacion='INI'
									LsDBC='ADMIN'
									LsRutaTabla='ADMIN!'+cArchivo 
								CASE DBFS.Ubicacion='CIA'
									LsDBC=TRIM(DBFS.Ubicacion)+GOENTORNO.GsCodCia
									LsRutaTabla=TRIM(DBFS.Ubicacion)+GOENTORNO.GsCodCia+'!'+cArchivo
								CASE DBFS.Ubicacion='PER'
									LsDBC=LEFT(TRIM(DBFS.Ubicacion),1)+GOENTORNO.GsCodCia+LEFT(GOENTORNO.GsPeriodo,4)
									LsRutaTabla=LEFT(TRIM(DBFS.Ubicacion),1)+GOENTORNO.GsCodCia+LEFT(GOENTORNO.GsPeriodo,4)+'!'+cArchivo
							ENDCASE
					ENDCASE
				CASE dbfs.CONNECT = 'FOXPRO'
							LsRutaTabla=TRIM(PATH_001+cArchivo)
				OTHERWISE
						LsRutaTabla =  cArchivo
			ENDCASE
			***
			IF UPPER(cAccion)='RUTA' 
				IF !EMPTY(LsArea_act)
					SELE (LsArea_Act)
				ENDIF
				RETURN LsRutaTabla	 
			ENDIF
			IF !EMPTY(LsDBC)
				IF !DBUSED(LsDBC)
					OPEN DATABASE (LsDBC)
				ENDIF
				SET DATABASE TO (LsDBC)
				IF !INDBC(cArchivo,'TABLE')
					RETURN .F.
				ENDIF
			ENDIF
			SELE 0
			DO CASE
				CASE !EMPTY(cArchivo) AND !EMPTY(cAlias) AND !EMPTY(cExclu)
					USE (LsRutaTabla) ALIAS (cAlias) EXCLU
				CASE !EMPTY(cArchivo) AND !EMPTY(cAlias) AND EMPTY(cExclu)
					IF !USED(cAlias)
						USE (LsRutaTabla) ALIAS (cAlias) SHARED AGAIN
					ELSE
						SELECT  (cAlias)
					ENDIF

				CASE !EMPTY(cArchivo) AND EMPTY(cAlias) AND !EMPTY(cExclu)
					USE (LsRutaTabla) EXCLU
				CASE !EMPTY(cArchivo) AND EMPTY(cAlias) AND EMPTY(cExclu)
					USE (LsRutaTabla) SHARED AGAIN

				OTHER 
					IF !EMPTY(LsArea_act)
						SELE (LsArea_Act)
					ENDIF
					RETURN .F.
			ENDCASE
			IF !USED()
				IF !EMPTY(LsArea_act)
					SELE (LsArea_Act)
				ENDIF
				RETURN .F.
			ENDIF
			IF !EMPTY(cTag)
				SET ORDER TO (cTag)
			ENDIF

		RETURN .t.
	ENDPROC


	PROCEDURE ingresartablaadbc
		PARAMETERS _Sistema,_Archivo,_alias,_Ubicacion,_BaseDatos,_Servidor,_Connect
		IF PARAMETERS < 2
			RETURN
		ENDIF

		INSERT into Sistdbfs ( Sistema,Archivo,alias,Ubicacion,_BaseDatos,Servidor,_Connect ) ;
				VAlUES (_Sistema,_Archivo,_alias,_Ubicacion,_BaseDatos,_Servidor,_Connect) 
	ENDPROC


	*-- Captura la ruta de los datos segun la compañia actual
	PROCEDURE pathdatacia
		LPARAMETERS _CodCia
		IF !VARTYPE(_CodCia)='C'
			_CodCia ='001'  && Siempre la primera por defecto
		ENDIF
		*RETURN SYS(2003)+'\DATA\CIA'+_CODCIA+'\'
		RETURN JUSTPATH(ADDBS(THIS.TsPathadm))+'\CIA'+_CODCIA+'\'
	ENDPROC


	PROCEDURE Error
		LPARAMETERS nError, cMethod, nLine
		IF SET("Development")='ON' 
			MESSAGEBOX(cMethod+" "+TTOC(DATETIME())+CRLF+;
					"Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF+ ;
					"  "+MESSAGE()+CRLF,2+16+256,'Ha ocurrido un error en el sistema')

			RETURN CONTEXT_E_ABORTED
		ELSE


			STRTOFILE(cMethod+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("Error : "+TRANS(nError)+", Linea:"+TRANS(nLine)+CRLF,ERRLOGFILE,.T.)
			STRTOFILE("  "+MESSAGE()+CRLF,ERRLOGFILE,.T.)
			RETURN CONTEXT_E_ABORTED
		ENDIF
	ENDPROC


	PROCEDURE Init
		LOCAL lcServidor , lcBaseDatos , lcTmpPath , lcLocPath , lcFileINI , lcStringINI ,lcDefaBackEnd

		THIS.USER			= CREATEOBJECT('User' )
		THIS.Perfil			= SPACE(0)
		THIS.USER.Login		= ALLTRIM( SUBSTR(SYS(0) , AT( '#' , SYS(0) ) + 1 ) )
		THIS.USER.Estacion	= ALLTRIM( LEFT(  SYS(0) , AT( '#' , SYS(0) ) - 1 ) )

		*!*	Extraer de GPersonal
		*!*	(ApellidoPaterno,ApellidoMaterno,PrimerNombre,SegundoNombre,TercerNombre)
		*!*	(CodigoTrabajador)
		THIS.USER.Nombre			= SPACE(0)
		THIS.USER.CodigoTrabajador	= SPACE(0)
		THIS.USER.PASSWORD			= SPACE(0)
		THIS.USER.Categoria			= SPACE(0)

		*!*	Archivo .INI , para determinar SERVIDOR y BASEDATOS por defecto
		*!*	lcFileINI	= ADDBS( GETENV("WINDIR") ) + "TDV.INI"

		LcFileIni = LOCFILE("CONFIG.INI") 
		*!*	Leer el Archivo .INI
		lcStringINI	= FILETOSTR("CONFIG.INI") 		&& UPPER( FILETOSTR("CONFIG.INI") )
		oIniVal=NEWOBJECT("oldinireg","registry.vcx")

		*!*	Obtener el Path Local
		*!*	lcLocPath	= SUBSTR( lcStringINI , AT( "PATH LOCAL" , lcStringINI) )
		*!*	lcLocPath	= ALLTRIM( SUBSTR( lcLocPath , AT( "=" , lcLocPath ) + 1 ) )
		*!*	IF CHR(13) $ lcLocPath
		*!*		lcLocPath	= ALLTRIM( LEFT (  lcLocPath , AT( CHR(13) , lcLocPath	) - 1 ) )
		*!*	ENDIF
		*!*	lcLocPath	= STRTRAN( lcLocPath , CHR(13) , "" )
		*!*	lcLocPath	= STRTRAN( lcLocPath , CHR(10) , "" )
		lcvalue=''
		oIniVal.getinientry(@lcvalue,'Ruta locales','Path Local',LcFileINI) 
		lcLocPath = lcvalue

		*!*	Obtener el Path Temporal
		*!*	lcTmpPath	= SUBSTR( lcStringINI , AT( "PATH TMP" , lcStringINI) )
		*!*	lcTmpPath	= ALLTRIM( SUBSTR( lcTmpPath , AT( "=" , lcTmpPath ) + 1 ) )
		*!*	IF CHR(13) $ lcTmpPath
		*!*		lcTmpPath	= ALLTRIM( LEFT (  lcTmpPath , AT( CHR(13) , lcTmpPath ) - 1 ) )
		*!*	ENDIF
		*!*	lcTmpPath	= STRTRAN( lcTmpPath, CHR(13) , "" )
		*!*	lcTmpPath	= STRTRAN( lcTmpPath, CHR(10) , "" )
		lcvalue=''
		oIniVal.getinientry(@lcvalue,'Ruta temporales','Path Tmp',LcFileINI) 
		lcTmpPath = lcvalue


		THIS.TmpPath	= IIF( EMPTY( lcTmpPath ) , ADDBS( GETENV( "TEMP" ) ) , lcTmpPath )
		THIS.LocPath	= IIF( EMPTY( lcLocPath ) , "C:\APLVFP\Tmp" , lcLocPath )

		* Obtener tipo de servidor de datos por defecto
		*!*	lcDefaBackEnd	= SUBSTR( lcStringINI , AT( "BACKEND" , lcStringINI) )
		*!*	lcDefaBackEnd	= ALLTRIM( SUBSTR( lcDefaBackEnd , AT( "=" , lcDefaBackEnd ) + 1 ) )
		*!*	IF CHR(13) $ lcDefaBackEnd
		*!*		lcDefaBackEnd	= ALLTRIM( LEFT (  lcDefaBackEnd , AT( CHR(13) , lcDefaBackEnd ) - 1 ) )
		*!*	ENDIF
		*!*	lcDefaBackEnd	= STRTRAN( lcDefaBackEnd, CHR(13) , "" )
		*!*	lcDefaBackEnd	= STRTRAN( lcDefaBackEnd, CHR(10) , "" )
		lcvalue=''
		oIniVal.getinientry(@lcvalue,'Database Engine','BackEnd',LcFileINI) 
		lcDefaBackEnd = lcvalue

		LcValue =''
		oIniVal.getinientry(@lcvalue,'Path Database','Data Admin',LcFileIni) 
		this.TsPathAdm	= LcValue

		LcValue =''
		oIniVal.getinientry(@lcvalue,'Path Database','Data Source',LcFileIni)
		This.tspathData	= LcValue

		THIS.TmpPath	= IIF( EMPTY( lcTmpPath ) , ADDBS( GETENV( "TEMP" ) ) , lcTmpPath )
		THIS.LocPath	= IIF( EMPTY( lcLocPath ) , "C:\Temp" , lcLocPath )
		this.cdefaultbackendconecct = IIF( EMPTY( lcDefaBackEnd ) , "VFPDBC" , lcDefaBackEnd )
		this.SqlEntorno = (this.cdefaultbackendconecct = 'ODBC')
		THIS.Vfpdbcentorno = (this.cdefaultbackendconecct = 'VFPDBC')
		THIS.Adoentorno = (this.cdefaultbackendconecct = 'ADO')

		IF THIS.SqlEntorno
			THIS.Conexion	= goConexion
			THIS.Servidor	= goConexion.cServer
			THIS.BaseDatos	= goConexion.cDataBase
		ENDIF
		IF THIS.Vfpdbcentorno 
			THIS.Servidor	= goConexion.cServer
			THIS.BaseDatos	= goConexion.cDataBase
		ENDIF
		IF THIS.Adoentorno 
			THIS.Servidor	= goConexion.cServer
			THIS.BaseDatos	= goConexion.cDataBase

		ENDIF


		IF !this.lpidcia 
			this.gscodcia =  GsCodCia && '001'
		    this.tspathcia = this.pathdatacia(this.gscodcia) 
		ENDIF
		IF VARTYPE(_ANO)<>'N'  OR VARTYPE(_MES)<>'N'
			this.gsperiodo=DTOS(DATE()) 
		ELSE
			this.GsPeriodo = STR(_ANO,4,0)+TRAN(_MES,'@L ##')
		ENDIF

	ENDPROC


ENDDEFINE
*
*-- EndDefine: entorno
**************************************************


**************************************************
*-- Class:        ftp (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   06/05/03 12:24:14 AM
*
DEFINE CLASS ftp AS custom


	Height = 66
	Width = 100
	servidorremoto = "SAPP_CHINCHA"
	servidorlocal = "SAPP_LIMA"
	usuario = "ADMINISTRATOR"
	password = ("")
	idconexionlocal = 0
	idsessionlocal = 0
	idsessionremota = 0
	idconexionremota = 0
	Name = "ftp"


	PROCEDURE copiararchivo
		LPARAMETER tcArchivoLocal , tcArchivoFtp
		*!*	subir un archivo al servidor ftp

		IF !(THIS.IDSessionLocal<>0 AND THIS.IDSessionRemota<>0 AND THIS.IDConexionLocal<>0 AND THIS.IDConexionRemota<>0)
			=MESSAGEBOX("No puede efectuarse la copia al Servidor FTP. Conexión no establecida",64,"Sin Conexión a FTP")
			RETURN .F.
		ENDIF
		IF FILE(tcArchivoLocal)
			DECLARE FtpPutFile IN wininet.DLL AS FtpPutFileA ;
				LONG hFtpSession , ;
				STRING lpszLocalFile , ;
				STRING lpszRemoteFile , ;
				LONG dwFlags , ;
				LONG dwContext

			WAIT WINDOW "Copiando Archivo : " + tcArchivoLocal + " hacia " + tcArchivoFtp + "  [ftp://" + THIS.ServidorLocal + "]" NOWAIT
			=FtpPutFileA(	THIS.IDConexionLocal , tcArchivoLocal , tcArchivoFtp , 0 , 0 )

			WAIT WINDOW "Copiando Archivo : " + tcArchivoLocal + " hacia " + tcArchivoFtp + "  [ftp://" + THIS.ServidorRemoto + "]" NOWAIT
			=FtpPutFileA(	THIS.IDConexionRemota , tcArchivoLocal , tcArchivoFtp , 0 , 0 )

			WAIT WINDOW "Se termino la copia de archivos..." NOWAIT

		ELSE
			=MESSAGEBOX("No se encontró el archivo a copiar....",64,"Archivo no encontrado")
		ENDIF

		WAIT CLEAR

		CLEAR DLLS
	ENDPROC


	PROCEDURE borrararchivo
		LPARAMETER tcArchivoFTP
		*!*	Borrar archivos del Servidor FTP

		IF !(THIS.IDSessionLocal<>0 AND THIS.IDSessionRemota<>0 AND THIS.IDConexionLocal<>0 AND THIS.IDConexionRemota<>0)
			=MESSAGEBOX("No puede borrarse archivos del Servidor FTP. Conexión no establecida",64,"Sin Conexión a FTP")
			RETURN .F.
		ENDIF

		DECLARE FtpDeleteFile IN wininet.DLL AS FtpDeleteFileA ;
			LONG hFtpSession , ;
			STRING lpszFileName

		WAIT WINDOW "Eliminado el Archivo del Servidor FTP....... espere" NOWAIT

		*!*	borrar un archivo del servidor ftp
		=FtpDeleteFileA ( THIS.IDConexionLocal , tcArchivoFTP )
		=FtpDeleteFileA ( THIS.IDConexionRemota , tcArchivoFTP )

		CLEAR DLLS
	ENDPROC


	PROCEDURE conectarse
		#DEFINE INTERNET_OPEN_TYPE_PRECONFIG	0
		#DEFINE INTERNET_DEFAULT_FTP_PORT		21
		#DEFINE INTERNET_SERVICE_FTP			1

		*!*	Permite crear una sesion para internet
		DECLARE LONG InternetOpen IN wininet.DLL AS InternetOpenA ;
			STRING sAgent ,;
			LONG lAccessType , ;
			STRING sProxyName , ;
			STRING sProxyBypass , ;
			LONG lFlags

		*!*	Crea la conexion con el servidor FTP usando la sesion de Internet
		DECLARE LONG InternetConnect IN wininet.DLL AS InternetConnectA ;
			LONG hInternetSession , ;
			STRING sServerName , ;
			INTEGER nServerPort , ;
			STRING sUsername , ;
			STRING sPassword , ;
			LONG lService , ;
			LONG lFlags , ;
			LONG lContext

		WAIT WINDOW "Conectándose al Servidor FTP....... espere" NOWAIT

		*!*	Crear la sesion Local y Remota
		THIS.IDSessionLocal = InternetOpenA("Software In House, TDV", ;
			INTERNET_OPEN_TYPE_PRECONFIG, ;
			NULL, ;
			NULL, ;
			0 )

		THIS.IDSessionRemota = InternetOpenA("Software In House, TDV", ;
			INTERNET_OPEN_TYPE_PRECONFIG, ;
			NULL, ;
			NULL, ;
			0 )

		*!*	Conectarse al servidor FTP Local y Remota
		THIS.IDConexionLocal = InternetConnectA(THIS.IDSessionLocal, ;
			THIS.ServidorLocal, ;
			INTERNET_DEFAULT_FTP_PORT, ;
			THIS.Usuario, ;
			THIS.Password, ;
			INTERNET_SERVICE_FTP,;
			0,;
			0)

		THIS.IDConexionRemota = InternetConnectA(THIS.IDSessionRemota, ;
			THIS.ServidorRemoto, ;
			INTERNET_DEFAULT_FTP_PORT, ;
			THIS.Usuario, ;
			THIS.Password, ;
			INTERNET_SERVICE_FTP,;
			0,;
			0)


		IF THIS.IDConexionLocal < THIS.IDSessionLocal OR THIS.IDConexionRemota < THIS.IDSessionRemota
			=MESSAGEBOX("No se pudo conectar al servidor FTP " + THIS.ServidorLocal + " ó " + THIS.ServidorRemoto )
			RETURN .F.
		ENDIF

		CLEAR DLLS
		WAIT CLEAR
	ENDPROC


	PROCEDURE desconectarse
		*!*	Desconectarse del Servidor FTP
		DECLARE InternetCloseHandle IN wininet.DLL ;
			LONG hInet

		WAIT WINDOW "Desconectándose del Servidor FTP....... espere" NOWAIT

		=InternetCloseHandle(THIS.IDConexionLocal)
		=InternetCloseHandle(THIS.IDConexionRemota)


		THIS.IDSessionLocal		= 0
		THIS.IDSessionRemota	= 0
		THIS.IDConexionLocal	= 0
		THIS.IDConexionRemota	= 0

		CLEAR DLLS
		WAIT CLEAR

		RETURN .T.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ftp
**************************************************


**************************************************
*-- Class:        graph (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/02/07 07:37:08 AM
*-- Se utiliza para generar gráficos estadísticos
*
#INCLUDE "k:\aplvfp\bsinfo\progs\graph9.h"
*
DEFINE CLASS graph AS custom


	Height = 32
	Width = 47
	*-- Contiene el nombre del cursor que contiene los datos para el grafico
	PROTECTED ccursor
	ccursor = ""
	*-- Referencia al objeto que contendra el grafico
	PROTECTED ocontrol
	ocontrol = ""
	*-- Indica si se mostrará o no una leyenda en el gráfico
	leyenda = .T.
	*-- Indica que tipo de grafico se generará
	tipograph = 1
	*-- Es el titulo del grafico
	titulo = ("")
	*-- Indica si se presenta en efecto 3D
	efecto = .T.
	*-- Indica si el grafico es apilado o agrupado
	pila = .F.
	*-- Indica si se plotea por filas o columnas
	plotby = 2
	*-- Indica si se muestra o no el titlo del gráfico
	showtitulo = .T.
	fontsizetitle = 14
	fontsizeleyenda = 10
	fontsizeejex = 10
	fontsizeejey = 10
	*-- Contiene el nombre del campo de tipo General, donde se guardará el gráfico generado
	ccampo = ""
	*-- Contiene el nombre del cursor que contiene gráfico generado.
	ctabla = ""
	*-- Muestra los valores
	mostrarvalores = .F.
	Name = "graph"


	*-- Genera el grafico
	PROCEDURE gengraph
		PARAMETERS tcCursor, toControl

		LOCAL m.lcDataGen 		, m.lcCursor 			, m.lnTipoGraph , m.lxValue
		LOCAL m.lnTipoGraph		, m.lnPlotBy 			, m.llLeyenda 	, m.llTitulo , m.llShowTitulo
		LOCAL m.lnFontSizeTitle , m.lnFontSizeLeyenda 	, m.lnFontSizeEjeX

		THIS.cCursor	= tcCursor
		IF ISNULL(THIS.cCursor) OR EMPTY(THIS.cCursor) or !used(THIS.cCursor)
			MESSAGEBOX(_MSG_TABLACURSOR,16,_TIT_ERROR_PARAMS)
			RETURN
		ENDIF

		THIS.oControl	= toControl
		IF VARTYPE(toControl) <> 'O'
			MESSAGEBOX(_MSG_TIPODEDATO,16,_TIT_ERROR_PARAMS)
			RETURN
		ENDIF


		#DEFINE CRLF		CHR(13)+CHR(10)
		#DEFINE TAB 		CHR(9)


		m.lnTipoGraph		= THIS.TipoGraph
		m.lnPlotBy			= THIS.PlotBy
		m.llLeyenda			= THIS.Leyenda
		m.lcTitulo			= THIS.Titulo
		m.llShowTitulo		= THIS.ShowTitulo
		m.lnFontSizeTitle 	= THIS.FontSizeTitle
		m.lnFontSizeLeyenda	= THIS.FontSizeLeyenda
		m.lnFontSizeEjeX 	= THIS.FontSizeEjeX
		m.lcCursor			= SYS(2015)
		this.cTabla 		= m.lcCursor
		this.cCampo 		= 'GEN1'

		CREATE CURSOR (m.lcCursor) (gen1 g)
		APPEND BLANK

		m.lcDataGen = ""+TAB

		SELECT (THIS.cCursor)
		GO TOP
		*!*	Determinar el # de series
		m.lnSeries	= FCOUNT()-1

		FOR I=1 TO m.lnSeries
			m.lcDataGen = m.lcDataGen + FIELD(I+1) + IIF(I==m.lnSeries,CRLF,TAB)
		ENDFOR
		SCAN &&WHILE NOT EOF()
			m.lcField	= FIELD(1)
			m.lcDataGen = m.lcDataGen + &lcField + TAB
			FOR I=1 TO m.lnSeries
				m.lcField	= FIELD(I+1)
				m.lcDataGen = m.lcDataGen + ALLTRIM(STR(&lcField)) + IIF(I==m.lnSeries,CRLF,TAB)
			ENDFOR
		ENDSCAN

		SELECT (m.lcCursor)
		APPEND GENERAL gen1 CLASS "MSGraph.Chart.8" DATA m.lcDataGen
		THIS.oControl.ControlSource = "Gen1"
		*!*	Forzar los metodos assign
		THIS.TipoGraph	= m.lnTipoGraph
		THIS.PlotBy		= m.lnPlotBy
		THIS.ShowTitulo	= m.llShowTitulo
		THIS.Leyenda	= m.llLeyenda
		THIS.Titulo		= m.lcTitulo
		THIS.FontSizeTitle= m.lnFontSizeTitle
		THIS.FontSizeLeyenda= m.lnFontSizeLeyenda
		THIS.FontSizeEjeX = m.lnFontSizeEjeX

		*** Mostrar valores ***
		IF this.MostrarValores
			THIS.oControl.Object.ApplyDataLabels()
			THIS.oControl.Object.SeriesCollection( 1 ).Datalabels.font.size = 8
		ELSE
			THIS.oControl.Object.ApplyDataLabels(xlDataLabelsShowNone)
		ENDIF
		*!*	THIS.oControl.Object.Axes(1).HasTitle = .T.	&& Titulo del eje X
		*!*	THIS.oControl.Object.Axes(2).HasTitle = .T.	&& Titulo del eje Y
	ENDPROC


	HIDDEN PROCEDURE tipograph_assign
		LPARAMETERS m.lnTipoGraph
		IF VarType(m.lnTipoGraph)#'N'
			RETURN
		ENDIF
		IF TYPE("THIS.oControl.ChartType")=='N' 
			IF THIS.Efecto	&& 3D
				DO CASE
				CASE m.lnTipoGraph	== 1	&& Columnas
					THIS.oControl.ChartType	= IIF(THIS.Pila,55,54)
				CASE m.lnTipoGraph	== 2	&& Barras
					THIS.oControl.ChartType	= IIF(THIS.Pila,61,60)
				CASE m.lnTipoGraph	== 3	&& Pie
					THIS.oControl.ChartType	= IIF(THIS.Pila,70,-4102)
				CASE m.lnTipoGraph	== 4	&& Lineas
					THIS.oControl.ChartType	= 65
				CASE m.lnTipoGraph	== 5	&& Area
					THIS.oControl.ChartType	= 78
				CASE m.lnTipoGraph	== 6	&& Puntos de Dispersion
					THIS.oControl.ChartType	= -4169
				CASE m.lnTipoGraph	== 7	&& Radar
					THIS.oControl.ChartType	= -4151
				CASE m.lnTipoGraph	== 13	&& Pie 
					THIS.oControl.ChartType	= -4102

				OTHERWISE	&& Columna 3D / Cluster
					THIS.oControl.ChartType	= 54
				ENDCASE
			ELSE
				DO CASE
				CASE m.lnTipoGraph	== 1	&& Columnas
					THIS.oControl.ChartType	= IIF(THIS.Pila,52,51)
				CASE m.lnTipoGraph	== 2	&& Barras
					THIS.oControl.ChartType	= IIF(THIS.Pila,58,57)
				CASE m.lnTipoGraph	== 3	&& Pie
					THIS.oControl.ChartType	= IIF(THIS.Pila,69,5)
				CASE m.lnTipoGraph	== 4	&& Lineas
					THIS.oControl.ChartType	= 4
				CASE m.lnTipoGraph	== 5	&& Area
					THIS.oControl.ChartType	= 76
				CASE m.lnTipoGraph	== 6	&& Puntos de dispersion
					THIS.oControl.ChartType	= -4169
				CASE m.lnTipoGraph	== 7	&& Radar
					THIS.oControl.ChartType	= -4151
				CASE m.lnTipoGraph	== 13	&& Pie
					THIS.oControl.ChartType	= -4151

				OTHERWISE	&& Columna Normal / Cluster
					THIS.oControl.ChartType	= 51
				ENDCASE
			ENDIF
		ENDIF
		THIS.TipoGraph	= m.lnTipoGraph


		*!*	1 = Áreas
		*!*	2 = Barras
		*!*	3 = Columnas
		*!*	4 = Líneas
		*!*	5 = Sectores
		*!*	6 = Circular
		*!*	7 = Radar
		*!*	8 = Puntos
		*!*	9 = Áreas 3D
		*!*	10 = Barras 3D
		*!*	11 = Columnas 3D
		*!*	12 = Líneas 3D
		*!*	13 = Sectores 3D 
		*!*	-4102 = Sectores 3D
	ENDPROC


	HIDDEN PROCEDURE plotby_access
		IF Type("THIS.oControl.Object.Application")=='O' AND NOT ISNULL(THIS.oControl.Object.Application)
			RETURN THIS.oControl.Object.Application.PlotBy
		ELSE
			RETURN THIS.PlotBy
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE plotby_assign
		LPARAMETERS m.lnPlotBy
		IF Type("THIS.oControl.Object.Application")=='O' AND NOT ISNULL(THIS.oControl.Object.Application)
			IF !inlist(m.lnPlotBy,1,2)
				m.lnPlotBy	= 2
			ENDIF
			THIS.oControl.Object.Application.PlotBy	= m.lnPlotBy
		ENDIF
		THIS.PlotBy	= m.lnPlotBy
	ENDPROC


	HIDDEN PROCEDURE leyenda_access
		IF TYPE("THIS.oControl.HasLegend")=='L'
			RETURN THIS.oControl.HasLegend
		ELSE
			RETURN THIS.Leyenda
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE leyenda_assign
		LPARAMETER m.llLeyenda
		IF TYPE("THIS.oControl.HasLegend")=='L'
			THIS.oControl.HasLegend	= m.llLeyenda
		ENDIF
		THIS.Leyenda	= m.llLeyenda
	ENDPROC


	HIDDEN PROCEDURE titulo_access
		IF TYPE("THIS.oControl.Object.ChartTitle.Text")=='C'
			RETURN THIS.oControl.Object.ChartTitle.Text
		ELSE
			RETURN THIS.Titulo
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE titulo_assign
		LPARAMETERS m.lcTitulo
		IF TYPE("THIS.oControl.Object.ChartTitle.Text")=='C'
			THIS.oControl.Object.ChartTitle.Text	= m.lcTitulo
		ENDIF
		THIS.Titulo	= m.lcTitulo
	ENDPROC


	HIDDEN PROCEDURE showtitulo_access
		IF TYPE("THIS.oControl.HasTitle")=='L'
			RETURN THIS.oControl.HasTitle
		ENDIF
		RETURN THIS.ShowTitulo
	ENDPROC


	HIDDEN PROCEDURE showtitulo_assign
		LPARAMETERS m.llShowTitulo
		IF TYPE("THIS.oControl.HasTitle")=='L'
			THIS.oControl.HasTitle	= m.llShowTitulo
		ELSE
			THIS.ShowTitulo	= m.llShowTitulo
		ENDIF
	ENDPROC


	HIDDEN PROCEDURE fontsizetitle_assign
		LPARAMETERS m.lnFontSize
		IF TYPE("THIS.oControl.Object.ChartTitle.Font.Size")=='N'
			THIS.oControl.Object.ChartTitle.Font.Size	= m.lnFontSize
		ENDIF
		THIS.FontSizeTitle	= m.lnFontSize
	ENDPROC


	HIDDEN PROCEDURE fontsizeleyenda_assign
		LPARAMETERS m.lnFontSize
		IF TYPE("THIS.oControl.Object.Legend.Font.Size")=='N'
			THIS.oControl.Object.Legend.Font.Size	= m.lnFontSize
		ENDIF
		THIS.FontSizeLeyenda	= m.lnFontSize
	ENDPROC


	HIDDEN PROCEDURE fontsizeejex_assign
		LPARAMETERS m.lnFontSize
		IF TYPE("THIS.oControl.Object.SeriesCollection.Count")=='N'
			for i=1 to THIS.oControl.Object.SeriesCollection.Count
				*THIS.oControl.Object.SeriesCollection(i).DataLabels.Font = 6
			endfor
		ENDIF
		THIS.FontSizeEjeX	= m.lnFontSize
	ENDPROC


	HIDDEN PROCEDURE fontsizeejey_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		THIS.FontSizeEjeY = m.vNewVal
	ENDPROC


	PROCEDURE ccursor_assign
		LPARAMETERS m.ccursor
		IF VARTYPE(m.ccursor) = 'C'
			THIS.ccursor = m.ccursor
		ELSE
			THIS.ccursor = ''
		ENDIF
	ENDPROC


	PROCEDURE Init
		*!*	-------------------------------------------------------------------------------
		*!*	Titulo			:	Graph
		*!*	Propósito		:	Genera un gráfico estadístico con el cursor que recibe 
		*!*						como parámetro 
		*!*	PARÁMETROS		:	2
		*!*				1	:   tcCursor 		Cursor donde se almacenan los valores para generar el
		*!*										Gráfico
		*!*				2	:	toControl 		Nombre del Objeto donde se mostrará el gráfico
		*!*
		*!*	Valor de retorno:	<Ninguno>
		*!*
		*!*	LLAMADAS		:	<Ninguno>
		*!*
		*!*
		*!*	CLASES HEREDADAS
		*!*
		*!*
		*!*	Comentarios 	:	genera un gráfico a partir de una tabla de dos campos como mínimo
		*!*						en el primer campo se ingresan los datos del eje 'Y', y los demas campos 
		*!*						son los datos del eje 'X', también tiene la opción de invertir es
		*!*						la serie de datos.
		*!*	CREACIÓN
		*!*		Comentario	:
		*!*
		*!*	ULTIMA MODIFICACIÓN
		*!*		Fecha		:
		*!*		Autor		:
		*!*		Comentario	:
		*!*	-------------------------------------------------------------------------------

		*!*	LPARAMETER m.lxValores , m.loControl

		*!*	IF VarType(m.lxValores)=='C'	&& Cursor
		*!*		THIS.cCursor = m.lxValores
		*!*	ENDIF

		*!*	IF VarType(m.loControl) == 'O'	&& Debe ser un objeto OLEControl
		*!*		THIS.oControl	= m.loControl
		*!*	ENDIF
	ENDPROC


	PROCEDURE Destroy
		IF USED(THIS.cTabla)
			SELE (THIS.cTabla)
			USE
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: graph
**************************************************


**************************************************
*-- Class:        interfaces (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   02/19/15 09:53:06 PM
*
DEFINE CLASS interfaces AS custom


	Height = 16
	Width = 98
	Picture = "..\..\..\tdv\graficosgenerales\iconos\interfaces.ico"
	*-- Locación física donde se encuentra la unidad de negocio
	csedenegocio = "''"
	*-- Unidad de negocio ;  nombre del servidor NT donde esta la base de Datos SQL - Server
	cunidadnegocio = "''"
	*-- Ruta principal a la red novell en Chincha
	cpathredchincha = "''"
	*-- Ruta principal a la red novell en Lima
	cpathredlima = "''"
	*-- Base de datos SQL Server a la que se conecta en el Sql, este valor se captura de archivo .ini
	cbasedatos = "''"
	*-- Ruta principal de acceso a la red novell
	cpathred = "''"
	*-- Tipo de interface:                           1. Sistemas Nuevos => Sistemas Actuales DOS                                2. Cargas Iniciales a SPRING         3. Sistemas Actuales DOS => Sistemas Nuevos                            4. Cargas Iniciales a DD
	ntipointerface = 1
	*-- Modulo del dos en el que se actualizan  los datos provenientes de la base de datos SQL - Server
	cmodulo_dos = ""
	*-- Tabla del dos en el que se actualizan  los datos provenientes de la base de datos SQL - Server
	ctabla_dos = ""
	*-- Solo genera un log de consistencias sin grabar en las tablas de destino DOS
	lsolochequear = .F.
	dfhtransac_desde = ""
	dfhtransac_hasta = ""
	cprocesando_almacen = "''"
	caviso1 = ""
	caviso2 = ""
	caviso3 = ""
	*-- Aqui se guarda el path vigente antes de que la clase configure los paths para las interfaces.
	cpathold = ""
	cprograma_carga = ""
	*-- Especifica los niveles de chequeo para la consistencia de datos previos a la ejecución de la interface
	nnivelchequeo = 0
	*-- Numero de areas abiertas a cerrar
	g_areacount = 0
	*-- Base de datos alternativa
	cbasedatos2 = ""
	*-- Producto, familia , codigo de desarrollo y version de codigo de desarrollo de prenda
	pfdv = .NULL.
	*-- Indica si hay acceso a las aplicaciones DOS
	lacceso_apps_dos = .T.
	*-- Indica si hay acceso a la tabla de consistencias
	lacceso_consistencia = .T.
	*-- Indica si hay acceso a la tabla de errores
	lacceso_errores = .T.
	*-- Indica si hay acceso a tabla de datos migrados
	lacceso_migrados = .T.
	*-- Solo muestra incosistencias  del pedido cargado en cNumeroPedidoTdv actual.
	lreporte_parcial = .T.
	*-- Borrar los registros de la tabla de consistencia cuando se inicia una nueva migración
	lborrarconsistencia = .T.
	pcseccion = "''"
	*-- Tabla del dos que se esta procesando
	ctabla_en_proceso = ""
	*-- Archivo temporal que almacena los errores
	tmpfileerr = "''"
	*-- Numero de filas de la matriz de errores
	numele_aerr_sql_dos = 0
	*-- Almacena las familias de almacen a procesar
	familias_almacen = "''"
	*-- Almacenas las subfamilias de almacen a procesar
	subfamilias_almacen = "''"
	*-- Indica si se muestra el mensaje de "NO HAY INCONSISTENCIA"
	showmessage = .T.
	cexceptionfile = ""
	cestadomigracion = ""
	*-- Tipo archivo origen (DBF, XLS, CSV)
	tipo_arch = ([])
	*-- Ruta donde se encuentra el archivo a migrar
	ruta_arch = ([])
	*-- Directorio de interfaces
	cdirintf = "=[]"
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="cdirintf" type="property" display="cDirIntf"/><memberdata name="cdirintcia" type="property" display="cDirIntCia"/><memberdata name="model_arch" type="property" display="Model_Arch"/><memberdata name="hoja_xls" type="property" display="Hoja_xls"/><memberdata name="arch_xls" type="property" display="Arch_Xls"/><memberdata name="cnromes" type="property" display="cNroMes"/><memberdata name="cano" type="property" display="cAno"/><memberdata name="conexion2y3" type="property" display="Conexion2y3"/><memberdata name="cano2" type="property" display="cAno2"/><memberdata name="cnromes2" type="property" display="cNroMes2"/><memberdata name="int_inicializabd" type="method" display="Int_InicializaBD"/><memberdata name="des_mod" type="property" display="Des_Mod"/><memberdata name="des_mod_d" type="property" display="Des_Mod_d"/><memberdata name="do_sqlexec" type="property" display="Do_SqlExec"/><memberdata name="cadenasql" type="property" display="CadenaSql"/><memberdata name="cadenasql2" type="property" display="CadenaSql2"/></VFPData>]
	*-- Ruta (directorio) del repositorio de estructiuras modelo de tablas usadas en la interfase de migracion de datos
	cdirintcia = ([])
	*-- Model de estructura o plantilla en formato dbf
	model_arch = "=[]"
	*-- Hoja (sheet) contenida en archivo excel (xls,xlsx)
	hoja_xls = "=[]"
	*-- Archivo excel (XLS,XLSX) incluye ruta.
	arch_xls = ([])
	*-- Numero de mes de proceso
	cnromes = "=[]"
	*-- Año de proceso , segun fecha de transaccion inicial
	cano = ([])
	*-- Objeto controla conexion  ODBC
	ocnx_odbc = (.F.)
	*-- Controla si hay mas de una conexion ODBC disponible
	conexion2y3 = .F.
	*-- Año hasta
	cano2 = "=[]"
	*-- Mes hasta
	cnromes2 = ([])
	*-- Descripcion del modulo
	des_mod = "=[]"
	*-- Nombre del modulo para procesos
	des_mod_d = ([])
	*-- CLI ->  SQL pass-through en el cliente ; SRV -  SQL pass-through llama SP en el servidor
	do_sqlexec = "=[]"
	cadenasql = "=[]"
	cadenasql2 = "=[]"
	ccodope = ([])
	ccodope2 = ([])
	Name = "interfaces"

	*-- Cambiar la unidad de negocio en la configuración con la de la sede actual.
	lcambiarunidadnegocio = .F.

	*-- Habilita los controles en el formulario de proceso en bloque por rango de fecha, de codigos de desarrollo o pedidos.
	lprocesoenbloque = .F.

	*-- Actualiza solo las tablas de el SPRNG cuando se hace la migración inicial
	lsolospring = .F.

	*-- Actualiza solo las tablas de DDP cuando se hace la migración inicial
	lsoloddp = .F.

	*-- Actualiza saldos en base a transacciones. se aplica a almacenes CIV,CIQ,CIN,CIP
	lchequeatrans = .F.

	*-- Actualizar tablas principales
	ltablasprincipales = .F.
	linicializapath = .F.

	*-- Activa o desactiva la verificación la version que se esta ejecutando.
	lverificatipoejecucion = .F.
	lsolotablasprincipales = .F.

	*-- Guarda el pedido que se esta revisando en la consistencia de GPP no necesariamente es el mismo que se guarda en cNumeroPedidoTdv
	lcpedido = .F.

	*-- Graba obligadamente asi tenga  inconsistencia si esta en .T.
	lgrabar_con_incosistencia = .F.

	*-- Activa el envio de correo de aviso
	lenviarmail = .F.
	lenviarmailsiempre = .F.
	lenviarmailnotifica = .F.
	lenviarmailotros = .F.
	ctagmail = .F.
	evalua_condicion = .F.

	*-- Verifica que solo se carguen los modulos asignados al usuario responsable de hacer la interface
	lchkresponsable = .F.
	tablas = .F.
	DIMENSION aenvios[1,5]
	DIMENSION aerr_sql_dos[1,7]


	*-- Ejecuta el proceso de interfaces
	PROCEDURE procesar

		IF !THIS.LACCESO_APPS_DOS
			IF THIS.SHOWMESSAGE
				MESSAGEBOX('El acceso a las aplicaciones DOS esta restringido, consulte al centro de computo')
			ENDIF
			RETURN
		ENDIF

		LOCAL LDFHTRANSAC,   NENVIOS

		IF THIS.LPROCESOENBLOQUE
			THIS.PARENT.TXTAVISO1.VALUE = ""
			THIS.LSOLOCHEQUEAR = THIS.PARENT.CHKSOLOCONSISTENCIA.VALUE
			THIS.LSOLOSPRING   = THIS.PARENT.CHKSOLOSPRING.VALUE
			THIS.LSOLODDP 	   = THIS.PARENT.CHKSOLODDP.VALUE
			THIS.LCHEQUEATRANS = THIS.PARENT.CHKTRANSACCIONES.VALUE
			THIS.DFHTRANSAC_DESDE = THIS.PARENT.TXTFHTRANSAC.VALUE
			THIS.DFHTRANSAC_HASTA = THIS.PARENT.TXTFHTRANSACH.VALUE
			THIS.CPROCESANDO_ALMACEN = TRIM(LEFT(THIS.PARENT.CBO_ALMACENES.DISPLAYVALUE,10))
			THIS.LTABLASPRINCIPALES	= THIS.PARENT.CHKTABLASPRINCIPALES.VALUE

			IF NOT THIS.PARENT.TXTAVISO2.VALUE = "Fecha global aplicada"
				IF MESSAGEBOX("No hay fecha de Actualización global aplicada. ¿ Desea iniciar el proceso de todas maneras ? ",4+48+256,"Aviso") = 7
					** Somos Fuga
					THIS.PARENT.TXTFHTRANSAC.SETFOCUS()
					RETURN
				ENDIF
			ELSE
				IF MESSAGEBOX("La fecha de Actualización global es al "+DTOC(TTOD(THIS.DFHTRANSAC_DESDE))+".  ¿ Desea Continuar ? ",4+48+256,"Aviso") = 7
					** Somos Fuga
					THIS.PARENT.TXTFHTRANSAC.SETFOCUS()
					RETURN
				ENDIF
			ENDIF
		ENDIF

		** Tabla Maestra de Items Migrados - 23/03/2001 VETT ***
		** OJO Solo se migraran transacciones de los items registrados en esta Tabla
		IF THIS.NTIPOINTERFACE # 1
			IF !USED('M_ITEMS')
				SELECT 0
				USE INT_MAESTRO_ITEMS ALIAS M_ITEMS ORDER LLAVESPRIN
			ELSE

			ENDIF
		ENDIF

		IF INLIST(THIS.CMODULO_DOS,'COM','IGP') OR INLIST(THIS.CTABLA_DOS,'COM','IGP')
			IF THIS.LACCESO_CONSISTENCIA
				THIS.INT_BORRA_CONSISTENCIA
			ENDIF
		ENDIF
		*** Controlamos si se procesa un modulo y/o una tabla , o todo
		LOCAL LSFORMODULO,LSFORTABLA
		DO CASE
		CASE EMPTY(THIS.CMODULO_DOS) AND EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = '.T.'
			LSFORTABLA  = '.T.'
		CASE !EMPTY(THIS.CMODULO_DOS) AND EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = 'UPPER(Modulos.Codigo) = TRIM(UPPER(THIS.cmodulo_dos))'
			LSFORTABLA  = '.T.'
		CASE EMPTY(THIS.CMODULO_DOS) AND !EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = '.T.'
			LSFORTABLA  = 'UPPER(TablasModulo.DESC_TABLA) = TRIM(UPPER(THIS.ctabla_dos))'
		CASE !EMPTY(THIS.CMODULO_DOS) AND !EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = 'UPPER(Modulos.Codigo) = TRIM(UPPER(THIS.cmodulo_dos))'
			LSFORTABLA  = 'UPPER(TablasModulo.DESC_TABLA) = TRIM(UPPER(THIS.ctabla_dos))'

		ENDCASE

		THIS.VERIFICAR_DESARROLLO()
		*** Actualizamos tablas maestras ***
		SELECT TABLASMODULO
		SCAN FOR PRIORIDAD AND  THIS.LTABLASPRINCIPALES	AND EVALUATE(LSFORMODULO)
			PROG1=PREFIJO+ALLTRIM(DESC_TABLA)+".prg"
			PROG2=PREFIJO+ALLTRIM(DESC_TABLA)+'()'
			THIS.CPROGRAMA_CARGA= UPPER(PREFIJO+ALLTRIM(DESC_TABLA))
			THIS.CTABLA_EN_PROCESO = UPPER(ALLTRIM(DESC_TABLA))
			IF !EMPTY(DESC_TABLA)
				THIS.CAVISO2 = "Ejecutando:"+PROG1
				IF INLIST(THIS.CMODULO_DOS,'DTE') OR INLIST(THIS.CTABLA_DOS,'DTE')
					IF THIS.LACCESO_CONSISTENCIA
						THIS.INT_BORRA_CONSISTENCIA
					ENDIF
				ENDIF
				*!*	-------------------------------------------------------------
				*!*	Giuliano Gonzales Zeballos (Roche de Scanner) 14/02/2002
				*!*	-------------------------------------------------------------
				IF THIS.VALIDARTABLA(PROG2)	&& Valida que la Tabla no este exceptuada
					SELECT TABLASMODULO
					LOOP
				ENDIF
				IF THIS.LPROCESOENBLOQUE
					**			this.dfhtransac_desde=tablasmodulo.fh_transac
					THIS.G_AREACOUNT = 20
					THIS.CLEARAREAS
					**			DO (PROG1)
					THIS.&PROG2
				ELSE
					THIS.&PROG2
				ENDIF
				THIS.CAVISO1 = "Programa anterior:"+PROG1
				THIS.CAVISO2 = ""
			ENDIF
			SELECT TABLASMODULO
			REPLACE FH_TRANSAC WITH DATETIME()
		ENDSCAN
		IF THIS.LSOLOTABLASPRINCIPALES
			RETURN
		ENDIF

		*** Actualizamos Tablas Seleccionadas
		NENVIOS = 0
		SELE MODULOS
		SCAN FOR PROCESAR AND UPPER(TRIM(U_NEGOCIO))=UPPER(TRIM(THIS.CUNIDADNEGOCIO)) AND EVALUATE(LSFORMODULO)
			SELECT TABLASMODULO
			SCAN FOR COD_MOD_D=MODULOS.CODIGO AND SELEC AND NOT PRIORIDAD  AND EVALUATE(LSFORTABLA)
				PROG1=PREFIJO+ALLTRIM(DESC_TABLA)+".prg"
				PROG2=PREFIJO+ALLTRIM(DESC_TABLA)+'()'
				THIS.CPROGRAMA_CARGA= UPPER(PREFIJO+ALLTRIM(DESC_TABLA))
				THIS.CTABLA_EN_PROCESO = UPPER(ALLTRIM(DESC_TABLA))
				IF VARTYPE(ENVIAMAIL1)='L'
					IF ENVIAMAIL1 OR ENVIAMAIL2 OR ENVIAMAIL3 OR ENVIAMAIL4
						NENVIOS = NENVIOS + 1
						IF ALEN(THIS.AENVIOS,1)<NENVIOS
							DIMENSION THIS.AENVIOS(NENVIOS+1,5)
						ENDIF
						THIS.AENVIOS(NENVIOS,1) = ENVIAMAIL1
						THIS.AENVIOS(NENVIOS,2) = ENVIAMAIL2
						THIS.AENVIOS(NENVIOS,3) = ENVIAMAIL3
						THIS.AENVIOS(NENVIOS,4) = ENVIAMAIL4
						THIS.AENVIOS(NENVIOS,5) = THIS.CTABLA_EN_PROCESO

					ENDIF
				ENDIF

				IF !EMPTY(DESC_TABLA)
					IF INLIST(THIS.CMODULO_DOS,'DTE') OR INLIST(THIS.CTABLA_DOS,'DTE')
						IF THIS.LACCESO_CONSISTENCIA
							THIS.INT_BORRA_CONSISTENCIA
						ENDIF
					ENDIF
					THIS.CAVISO2 = "Ejecutando:"+PROG1
					*!*	-------------------------------------------------------------
					*!*	Giuliano Gonzales Zeballos (Roche de Scanner) 14/02/2002
					*!*	-------------------------------------------------------------
					IF THIS.VALIDARTABLA(PROG2)	&& Valida que la Tabla no este exceptuada
						LSTABLAS=IIF(ISNULL(THIS.TABLAS), "" , ALLTRIM(UPPER(THIS.TABLAS)))
						IF LSTABLAS='COMDCLI' AND LEN(LSTABLAS)<=8
							** No graba registro de inconsistencia cuando solo es COMDCLI
						ELSE
							THIS.INT_CONSISTENCIA(THIS.CNUMEROPEDIDOTDV,THIS.PFDV,'I99','',IIF(ISNULL(THIS.TABLAS), "" , ALLTRIM(UPPER(THIS.TABLAS))) )
						ENDIF
						SELECT TABLASMODULO
						LOOP
					ENDIF
					IF THIS.LPROCESOENBLOQUE
						**				this.dfhtransac_desde=tablasmodulo.fh_transac
						THIS.G_AREACOUNT = 20
						THIS.CLEARAREAS
						**				DO (PROG1)
						THIS.&PROG2
					ELSE
						THIS.&PROG2
					ENDIF
					THIS.CAVISO1 = "Programa anterior:"+PROG1
					THIS.CAVISO2 = ""
				ENDIF
				SELECT TABLASMODULO
				REPLACE FH_TRANSAC WITH DATETIME()
			ENDSCAN
			SELE MODULOS
		ENDSCAN
		THIS.CAVISO1 = "Proceso Terminado "
		IF !THIS.LPROCESOENBLOQUE
			WAIT WINDOW THIS.CAVISO1 NOWAIT
		ENDIF
		**WAIT WIND 'Los datos fueron procesados' TIMEOUT 0.6
		IF NENVIOS>0
			FOR K = 1 TO ALEN(THIS.AENVIOS,1)
				THIS.LENVIARMAIL 		= THIS.AENVIOS(NENVIOS,1)
				THIS.LENVIARMAILSIEMPRE = THIS.AENVIOS(NENVIOS,2)
				THIS.LENVIARMAILNOTIFICA= THIS.AENVIOS(NENVIOS,3)
				THIS.LENVIARMAILOTROS 	= THIS.AENVIOS(NENVIOS,4)
				THIS.CTAGMAIL 			= THIS.AENVIOS(NENVIOS,5)
				IF THIS.LENVIARMAIL
					THIS.ENVIAR_MAIL('1')
				ENDIF
				IF THIS.LENVIARMAILNOTIFICA
					THIS.ENVIAR_MAIL('2')
				ENDIF
				IF THIS.LENVIARMAILOTROS
					THIS.ENVIAR_MAIL('3')
				ENDIF

			ENDFOR
			RELEASE K
		ENDIF
	ENDPROC


	*-- Establece la ruta de acceso en la red Novell por modulo DOS.  COM,DTE,IGP,CIV,CIQ,TIN,DCO,etc.
	PROCEDURE setpathall
		PARAMETERS tcPrefijo
		IF PARAMETERS()=0
			tcPrefijo = []
		ENDIF

		** Por ahora no ** 

		RETURN .T.

		tcPrefijo = UPPER(tcPrefijo)
		PRIVATE llOpen,lcPath
		LOCAL LcCadenaLog
		PathActual=SYS( 2001, "PATH" )
		IF !EMPTY(PathActual)
			PathActual=PathActual+";"
		ENDIF
		IF FILE("C:\GISX00.DBF")
			USE C:\GISX00.DBF
			IF !EOF()
				m.cRutaGis = gisrut00
				LsNewPath = PathActual+m.cRutaGis
				SET PATH TO  (LsNewPath)
			ELSE
				IF FILE("GISX01.DBF")
				ELSE
					LsNewPath = PathActual+JUSTPATH(This.cpathred)       &&"M:\GIS\DBF"
			        SET PATH TO (LsNewPath) 
		        ENDIF
			ENDIF
			USE
		ELSE
			IF FILE("GISX01.DBF")
			ELSE
				LsNewPath = PathActual+JUSTPATH(This.cpathred)
		        SET PATH TO (LsNewPath) 
		    ENDIF
		ENDIF
		IF EMPTY(TcPrefijo)
			return
		ENDIF
		PathActual=SYS( 2001, "PATH" )
		IF !EMPTY(PathActual)
		  	PathActual=PathActual+";"
		ENDIF
		llOpen = .f.
		IF THIS.NetUseArea("GISX01",.t.,0)
			SET ORDER TO 1
			llOpen = .t.
		ENDIF
		IF !llOpen
			RETURN llOpen
		ENDIF

		SELECT GISX01
		SEEK tcPrefijo
		gcDirApp = ALLTRIM(GISX01.APPDIR01)
		IF !MANTEN01
			gcNomSis = GISX01.APPDES01
			gcDirTmp = ALLTRIM(GISX01.DIRTMP01)
			gcDirTxt = ALLTRIM(GISX01.DIRTXT01)
			gcNoLock = GISX01.NOBLOQ01

			SELECT GISX01
			SEEK tcPrefijo
			lcPath = ""
			lcError = ""
			IF !FOUND()
				lcError = tcPrefijo
			ENDIF
			if  GISX01.APPPRF01= tcPrefijo
				IF EMPTY(APPDIR01)
					lcError = lcError + GISX01.APPPRF01 + ";"
				ELSE
					lcPath = lcPath + ALLTRIM(GISX01.APPDIR01)+","
				ENDIF
			ENDif
			IF !EMPTY(lcError)
				lcCadenaLog = "ACCESO:No existen las rutas para "+lcError 
				this.generalog(LcCadenaLog) 
				llOpen = .f.
			ELSE
				lcPath = LEFT(lcPath,LEN(lcPath)-1)
				IF atc(lcpath,pathactual)=0
			    	LsNewPath = PathActual + lcPath
					SET PATH TO (LsNewPath)
				endif
			ENDIF
		ELSE
			lcCadenaLog ="ACCESO:Aplicación "+tcPrefijo+" en Mantenimiento, comunicarse con Sistemas" 
			this.generalog(LcCadenaLog) 
			llOpen = .f.
		ENDIF
		**SELECT GISX01
		**USE
		RETURN llOpen
	ENDPROC


	*-- Carga configuracion inicial de las rutas en novell, modulos y tablas DOS a actualizar
	PROCEDURE carga_configuracion

		*!*	*!*	thisformset.form2.hide
		*!*	*!*	thisformset.form3.hide
		*!*	*!*	SET PROCEDURE TO Fun_proc
		IF THIS.LVERIFICATIPOEJECUCION
			IF EMPTY(VERSION(2))  && Si estamos en Tiempo de Ejecución
				THIS.LINICIALIZAPATH = .T.
			ENDIF
		ENDIF
		THIS.RESTAURA_RUTAS()
		THIS.CPATHOLD = SYS(2001,'PATH')
		IF THIS.LINICIALIZAPATH
			THIS.INICIALIZAPATH()
		ENDIF

		THIS.CAPPATHREDGIS()

		M.USUARIO=GOENTORNO.USER.LOGIN
		IF UPPER(m.USUARIO)=[VTORRES]
			*!*	*!*		thisformset.form1.cmdProcesar5.Enabled = .T.
			*!*	*!*		thisformset.form1.cmdProcesar5.Visible = .T.
		ENDIF

		*!*	*!*	GcSedenegocio = This.cSedeNegocio
		*!*	*!*	GcPathRed=IIF(GcSedeNegocio#'LIMA',This.cpathRedChincha,This.cpathRedLima)
		**ThisFormSet.Form1.TxtAviso1.value=GcPathred
		**ThisFormSet.Form1.TxtAviso2.value=GcSedenegocio

		*!*	*!*	thisformset.form1.CboInterface.ListIndex=1		&& Valor por defecto
		*!*	*!*	thisformset.form1.Cbo_Mes.ListIndex=MONTH(DATE())		&& Valor por defecto
		*!*	*!*	thisformset.form1.cbo_mes.InteractiveChange()

		*!*	*!*	SET PROCEDURE TO Fun_proc ADDITIVE
		*!*	*!*	SET PROCEDURE TO Udflib additive
		*!*	*!*	thisformset.form1.TxtUnidadNegocio.VALUE=THIS.FORM1.Ocnx_Odbc.cServer
		*!*	*!*	thisformset.form1.TxtBaseDatos.VALUE=GoEntorno.BaseDatos

		THIS.NTIPOINTERFACE=1						&& Valor por defecto
		THIS.CUNIDADNEGOCIO=GOENTORNO.SERVIDOR
		THIS.CBASEDATOS=GOENTORNO.BASEDATOS
		THIS.DFHTRANSAC_DESDE = DATE()
		THIS.DFHTRANSAC_HASTA = DATE()
		*!*	*!*	thisformset.form1.CntRespuesta.CboServidores.VALUE=TRIM(THIS.FORM1.Ocnx_Odbc.cServer)
		*!*	*!*	thisformset.form1.TxtFhTransac.VALUE=DATETIME()
		** Establecemos los paths necesarios para aaceder a las Tablas de DOS
		*!*	*!*	THISFORMset.SETPATHALL()
		IF !THIS.SETPATHALL()
			IF THIS.SHOWMESSAGE
				=MESSAGEBOX('No hay acceso a las aplicaciones DOS, Las interfaces no se podran ejecutar correctamente')
			ENDIF
			THIS.LACCESO_APPS_DOS=.F.
			RETURN
		ENDIF
		*
		SELE 0
		USE INT_CONSISTENCIA ORDER PK01 ALIAS CONSISTENCIA
		IF !USED()
			IF THIS.SHOWMESSAGE
				=MESSAGEBOX('No se puede accesar la tabla INT_CONSISTENCIA.DBF')
			ENDIF
			THIS.LACCESO_CONSISTENCIA = .F.
		ENDIF
		*
		SELE 0
		USE INT_TABLA_ERRORES ORDER PK01 ALIAS ERRORES
		IF !USED()
			IF THIS.SHOWMESSAGE
				=MESSAGEBOX('No se puede accesar la tabla INT_TABLA_ERRORES.DBF')
			ENDIF
			THIS.LACCESO_ERRORES = .F.
		ENDIF
		*
		SELE 0
		USE INT_MIGRADOS ORDER PK02 ALIAS MIGRADOS
		IF !USED()
			IF THIS.SHOWMESSAGE
				=MESSAGEBOX('No se puede accesar la tabla GIST04.DBF')
			ENDIF
			THIS.LACCESO_MIGRADOS = .F.
		ENDIF

		*** Configuramos interface segun tipo - Preparamos Grid de Modulos
		*!*	*!*	THISFORMSET.ProgramasXmodulos()
		THIS.PROGRAMASXMODULOS()


		PUBLIC DATO,HNALMACEN,PFECHA

		*!*	*!*	LcSql= "select LEFT(ALMACENCODIGO+' '+Descripcionlocal,41) as Almacenes, CAST(space(1) AS BIT) as flagProc  from SPRING.DBO.wh_almacenMast WHERE UnidadNegocio='CHIN'"
		*!*	*!*	goEntorno.conexion.cSQL = LcSql
		*!*	*!*	goEntorno.conexion.cCursor = "C_ALM_DOS"
		*!*	*!*	HnAlmacen = goEntorno.conexion.doSQL()

		*!*	*!*	If HnAlmacen < 0
		*!*	*!*		=MESSAGEBOX("Fallo conexión con el servidor,Imposible migrar transacciones de almacenes DOS",48)
		*!*	*!*		return
		*!*	*!*	endif


		DATO=SPACE(3)

		*!*	*!*	thisformset.form1.Visible = .t.
		*!*	*!*	thisformset.form1.show()
	ENDPROC


	*-- Asocia los programas o metodos de actualización con las correspondientes tablas en DOS según el módulo al que pertenece COM,IGP,DTE,DCO,TIN,CIV,CIQ,CIT,etc.
	PROCEDURE programasxmodulos


		IF !USED('GISX01')
			SELE 0
			USE INT_Entidades_Od ORDER PK01 ALIAS GISX01 
			*!*	USE GISX01 ORDER GISO0101 ALIAS GISX01 
		ENDIF
		** Generamos resumen por modulo **
		LcTablaTmp=goentorno.tmppath+SYS(3)
		IF !USED([MODULOS])
			SELE 0 
			CREATE TABLE (LcTablaTmp)  FREE (Codigo C(3) ,;
										Des_Mod C(45),;
										Procesar L(1),;
										Path_Dir C(30),;
										U_Negocio C(20),;
										Cod_Mod_D C(3),;
										Cod_Tabla C(2), ; 
		                                				Ord_Carga c(2), ;
		                                				pk_nro_tag n(1),;
		                                				pk_Cadena M, ;
		                                				Alm_Dos C(3),;
		                                				Tipo_arch C(3),;
		                                				Ruta_arch C(60),;
		                                				Model_Arch C(30),;
		                                				Arch_Xls C(40),;
		                                				Hoja_Xls  C(30),;
		                                				Do_SqlExec C(3), ;
		                                				Des_Mod_d C(8) )
		                                
		**	LOkey=CURSORSETPROP("Buffering", 5, "MODULOS")
			USE (LcTablaTmp) EXCLU ALIAS MODULOS
			INDEX ON Codigo+Ord_Carga TAG PK1
			INDEX ON Ord_Carga+Codigo TAG PK2
			SET ORDER TO PK2
		ELSE
			SELE MODULOS
			ZAP
			SET ORDER TO PK2
		ENDIF 

		IF USED('TABLASMODULO')
			SELE TABLASMODULO
			SET FILTER TO 
		ELSE
			SELE 0
			USE TABLASMODULO SHARE ORDER PK3
		ENDIF

		*!*	IF thisformset.form1.CboInterface.ListIndex = 3
		*!*		SET ORDER TO PK3
		*!*	ELSE
		*!*		SET ORDER TO PK1
		*!*	ENDIF

		m.Unidad_de_Negocio=UPPER(TRIM(this.cunidadnegocio)) 
		m.Usr_Res = UPPER(TRIM(goentorno.user.login))
		SCAN FOR TIPO=this.ntipointerface 
			=SEEK(TABLASMODULO.COD_MOD_D,"GISX01")
			IF 	THIS.lcambiarUnidadNegocio
				REPLACE TABLASMODULO.U_negocio	WITH m.Unidad_de_Negocio
			ENDIF
			IF !U_Negocio=m.Unidad_de_Negocio
				LOOP
			ENDIF
		*!*		IF (THIS.lChkResponsable and ATC(m.Usr_Res,UPPER(USR_GRUPOS))=0) &&AND !EMPTY(USR_GRUPOS)
		*!*			LOOP
		*!*		ENDIF
			IF TABLASMODULO.No_Chk_Gis
				SELE MODULOS
				APPEND BLANK 
				REPLACE CODIGO 		WITH TABLASMODULO.COD_MOD_D
				REPLACE DES_MOD 	WITH TABLASMODULO.Desc_tabla
				REPLACE PROCESAR     WITH IIF(THIS.lChkResponsable,.F.,.T.)
				REPLACE PATH_Dir    	WITH []
				REPLACE U_negocio   	WITH TABLASMODULO.U_Negocio
				IF EMPTY(DES_MOD)
					REPLACE PROCESAR    WITH .F.
				ENDIF
				REPLACE COD_MOD_D 	WITH TABLASMODULO.COD_MOD_D
				REPLACE COD_Tabla 	WITH TABLASMODULO.COD_Tabla
				REPLACE Ord_Carga   	WITH TABLASMODULO.oRD_cARGA
				REPLACE alm_dos		WITH tablasmodulo.Alm_dos
				REPLACE Pk_cadena	WITH tablasmodulo.Pk_Cadena
				REPLACE pk_nro_tag  	WITH tablasmodulo.pk_nro_tag 
				REPLACE Des_Mod_d	WITH TABLASMODULO.DES_MOD_D 
			ELSE
				SELE MODULOS 
		*		SEEK TABLASMODULO.COD_MOD_D
				locate for Codigo=TABLASMODULO.COD_MOD_D
				IF !FOUND()
					IF THIS.SETPATHALL(TABLASMODULO.COD_MOD_D)
						SELE MODULOS
						APPEND BLANK 
						REPLACE CODIGO 		WITH TABLASMODULO.COD_MOD_D
						REPLACE DES_MOD 	WITH GISX01.APPDES01
						REPLACE PROCESAR    WITH IIF(THIS.lChkResponsable,.F.,.T.)
						REPLACE PATH_Dir    	WITH GISX01.APPDIR01
						REPLACE U_negocio   	WITH TABLASMODULO.U_Negocio
						IF EMPTY(DES_MOD)
							REPLACE PROCESAR    WITH .F.
						ENDIF
						REPLACE COD_MOD_D 	WITH 	TABLASMODULO.COD_MOD_D
						REPLACE COD_Tabla 	WITH 	TABLASMODULO.COD_Tabla
						REPLACE Ord_Carga	WITH 	TABLASMODULO.oRD_cARGA
						REPLACE Tipo_arch 	WITH	TABLASMODULO.Tipo_arch
						REPLACE Model_Arch	WITH	TABLASMODULO.Model_Arch
						REPLACE Arch_Xls		WITH	TABLASMODULO.Arch_Xls
						REPLACE Hoja_Xls		WITH	TABLASMODULO.Hoja_Xls
						REPLACE Des_Mod_d	WITH	TABLASMODULO.DES_MOD_D 
						REPLACE Do_SqlExec	WITH 	TABLASMODULO.Do_SqlExec
					ENDIF
				ENDIF
			ENDIF
			SELE TABLASMODULO
			REPLACE SELEC WITH .T.
		ENDSCAN
		***
		SELE GISX01
		USE
		SELE TABLASMODULO
		GO TOP
		SELE MODULOS
		**=tableupdate()
		*!*	LcFiltro = 'UPPER(TRIM(U_Negocio))="'+UPPER(TRIM(this.cUnidadNegocio))+'"'
		*!*	SET FILTER TO  EVAL(LcFiltro)
		**SET ORDER TO PK2
		GO TOP
		**reindex
		***
		THIS.lCambiarUnidadNegocio = .F.
	ENDPROC


	*-- Captura la ruta principal de los archivos de configuracion y equivalencias en la red Novell
	PROCEDURE cappathredgis
		*!*	Leer el Archivo .INI
		** Verficamos existencia de ruta inicial para alojar y leer archivos y configuraciones de interfases
		LsDirIntf = ADDBS(SYS(5)+JUSTPATH(goentorno.tspathadm))+'Interface'
		LsDirIntf = SYS(5)+'\o-Negocios\Interface'
		IF !DIRECTORY(LsDirIntf)
			MD(LsDirIntf)
			=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' + LsDirIntf+ ;
			'  Este directorio se usara para buscar los archivos de .txt o .csv necesarios para realizar la interface de datos',64,'ATENCION !!' )
		ENDIF
		LsFileInterface=ADDBS(LsDirIntf)+'INTERFACE.INI'
		IF !FILE(LsFileInterface)
			=MESSAGEBOX('No se encuentra el archivo de configuración de interfases',16,'Atención ! / Warning!') 
			RETURN 
		ENDIF
		this.cDirIntf = LsDirIntf
		**
		LsDirIntCia= ADDBS(this.cDirIntf )+'Cia_'+RIGHT(GsCodcia,2)  && Verificación pendiente si es el formato a usar ??
		IF !DIRECTORY(LsDirIntCia)
			MD(LsDirIntCia)
			=MESSAGEBOX('Se ha creado el Directorio o Carpeta --> ' +LsDirIntCia+ ;
			'  Este directorio se usará como repositorio de las estructuras modelo de las tablas o entidades a utilizar en la interface de migración de datos',64,'ATENCION !!' )
		ENDIF
		this.cDirIntCia =  LsDirIntCia


		lcStringINI	= UPPER( FILETOSTR(LsFileInterface) )
		*!*	Obtener el Path de la Red ** Chincha
		lcPathRed	= SUBSTR( lcStringINI , AT( "PATH REDCHINCHA" , lcStringINI) )
		lcPathRed	= ALLTRIM( SUBSTR( lcPathRed , AT( "=" , lcPathRed ) + 1 ) )
		IF CHR(13) $ lcPathRed
			lcPathRed	= ALLTRIM( LEFT (  lcPathRed , AT( CHR(13) , lcPathRed ) - 1 ) )
		ENDIF
		lcPathRed	= STRTRAN( lcPathRed, CHR(13) , "" )
		lcPathRed	= STRTRAN( lcPathRed, CHR(10) , "" )

		THIS.cPathRedChincha	= IIF( EMPTY( lcPathRed ) , ADDBS( GETENV( "TEMP" ) ) , lcPathRed )

		*!*	Obtener el Path de la Red ** LIMA
		lcPathRed	= SUBSTR( lcStringINI , AT( "PATH REDLIMA" , lcStringINI) )
		lcPathRed	= ALLTRIM( SUBSTR( lcPathRed , AT( "=" , lcPathRed ) + 1 ) )
		IF CHR(13) $ lcPathRed
			lcPathRed	= ALLTRIM( LEFT (  lcPathRed , AT( CHR(13) , lcPathRed ) - 1 ) )
		ENDIF
		lcPathRed	= STRTRAN( lcPathRed, CHR(13) , "" )
		lcPathRed	= STRTRAN( lcPathRed, CHR(10) , "" )

		THIS.cPathRedLima	= IIF( EMPTY( lcPathRed ) , ADDBS( GETENV( "TEMP" ) ) , lcPathRed )

		*!*	Obtener La sede de Negocio ** LIMA o CHINCHA
		lcSedeNeg	= SUBSTR( lcStringINI , AT( "SEDE" , lcStringINI) )
		lcSedeNeg	= ALLTRIM( SUBSTR( LcSedeNeg , AT( "=" , lcSedeNeg ) + 1 ) )
		IF CHR(13) $ lcSedeNeg
			lcSedeNeg	= ALLTRIM( LEFT (  lcSedeNeg , AT( CHR(13) , lcSedeNeg ) - 1 ) )
		ENDIF
		lcSedeNeg	= STRTRAN( lcSedeNeg, CHR(13) , "" )
		lcSedeNeg	= STRTRAN( lcSedeNeg, CHR(10) , "" )

		THIS.cSedeNegocio = IIF( EMPTY( lcSedeNeg ) , "CHINCHA..." , lcSedeNeg )

		THIS.cPathRed=IIF(UPPER(THIS.cSedeNegocio)#'LIMA',This.cpathRedChincha,This.cpathRedLima)

		** Obtener base de datos alternativa **
		LcBaseDatos2	= SUBSTR( lcStringINI , AT( "BASEDATOS2" , lcStringINI) )
		LcBaseDatos2	= ALLTRIM( SUBSTR( LcBaseDatos2 , AT( "=" , LcBaseDatos2 ) + 1 ) )
		IF CHR(13) $ LcBaseDatos2
			LcBaseDatos2	= ALLTRIM( LEFT (  LcBaseDatos2 , AT( CHR(13) , LcBaseDatos2 ) - 1 ) )
		ENDIF
		LcBaseDatos2	= STRTRAN( LcBaseDatos2, CHR(13) , "" )
		LcBaseDatos2	= STRTRAN( LcBaseDatos2, CHR(10) , "" )

		THIS.cBaseDatos2  = IIF( EMPTY( LcBaseDatos2 ) , '' ,LcBaseDatos2 )

		** Archivo de desarrollo a exceptuar en la migracion **
		LcExceptionFile	= SUBSTR( lcStringINI , AT( "EXCEPTIONFILE" , lcStringINI) )
		LcExceptionFile	= ALLTRIM( SUBSTR( LcExceptionFile , AT( "=" , LcExceptionFile ) + 1 ) )
		IF CHR(13) $ LcExceptionFile
			LcExceptionFile	= ALLTRIM( LEFT (  LcExceptionFile , AT( CHR(13) , LcExceptionFile ) - 1 ) )
		ENDIF
		LcExceptionFile	= STRTRAN( LcExceptionFile, CHR(13) , "" )
		LcExceptionFile	= STRTRAN( LcExceptionFile, CHR(10) , "" )

		THIS.cExceptionFile  = IIF( EMPTY( LcExceptionFile ) , '' ,LcExceptionFile )
	ENDPROC


	*-- Abre una tabla DOS en la red Novell.
	PROCEDURE netusearea
		PARAMETERS tcName, tlShared, tnTime, tcAlias, tnOrder
		PRIVATE llNoError, lnParameters
		lnParameters = PARAMETERS()
		IF lnParameters < 5
		   tnOrder = 0
		ENDIF
		IF lnParameters < 4
		   tcAlias = tcName
		ENDIF
		IF lnParameters < 3
		   tnTime = 0
		ENDIF
		IF lnParameters < 2
		   tlShared = .t.
		ENDIF
		llNoError = .t.
		*!*	ON ERROR DO this.NetUseError WITH UPPER(ALLTRIM(tcName))+".DBF  "

		IF !USED(tcName)
		   SELECT 0
		   IF tlShared
		      USE (tcName) ALIAS (tcAlias) AGAIN SHARED
		   ELSE
		      USE (tcName) ALIAS (tcAlias) AGAIN EXCLUSIVE
		   ENDIF
		ELSE
		   SELECT (tcAlias)
		ENDIF
		IF llNoError
		   SET ORDER TO tnOrder
		ENDIF
		ON ERROR
		RETURN llNoError
	ENDPROC


	*-- Administra el error de acceso a una tabla DOS en la red Novell
	PROCEDURE netuseerror
		PARAMETERS tcMsgError
		WAIT WINDOW "ERROR : " + tcMsgError + " " + MESSAGE() TIMEOUT 7
		llNoError = .F.
		RETURN
	ENDPROC


	PROCEDURE restaura_rutas
		IF !EMPTY(this.cpathOLD)
			SET PATH TO (this.cpathOLD) 
		ENDIF
	ENDPROC


	PROCEDURE creartablarutas
		LcArcTmp1 = GoEntorno.TmpPath+SYS(3)
		sele 0
		CREATE TABLE (LcArcTmp1) (NombTDOS C(8), pathTDOS C(60),NombTSql C(40),Servidor C(20), ;
							   BaseDatos C(20),Owner C(10))

		use (LcArcTmp1)
		COPY TO .\Tablas\RutaDos.dbf TYPE FOX2X
		LcArcTmp2 = GoEntorno.TmpPath+SYS(3)
		use

		sele 0
		CREATE TABLE (LcArcTmp2) (NombTDOS C(8),CampTDOS C(10),Tipo C(1),Ancho n(3), Dec N(2),CampoSql C(30))
		use (LcArcTmp2)
		COPY TO .\Tablas\CampoDos.dbf TYPE FOX2X
		use
		return
	ENDPROC


	PROCEDURE buscarentabla
		Parameter PcCampo,LcTabla
		LcAreaAct=ALIAS()
		LlFound = .F.
		DO CASE
			CASE UPPER(LcTabla)='FAM'
				SELE (LcTabla)
				LOCATE FOR ProdSql+FamSql = PcCampo
				cmpRetorno = "codfam"
				LlFound=FOUND()
			CASE UPPER(LcTabla)='ALM'
				SELE (LcTabla)
				LOCATE FOR AlmCod = PcCampo
				cmpRetorno = LcTabla+".codfam"
				LlFound=FOUND()
			CASE UPPER(LcTabla)='RAZ_2'
				SELE (LcTabla)
				LOCATE FOR CodRazon = PcCampo
				cmpRetorno = LcTabla+".CodTransac"
				LlFound=FOUND()
			CASE UPPER(LcTabla)='RAZ'
				SELE (LcTabla)
				LOCATE FOR CodTransac = PcCampo
				cmpRetorno = LcTabla+".CodRazon"
				LlFound=FOUND()

		ENDCASE
		SELE (LcAreaAct)
		IF LlFOUND
			RETURN EVAL(cmpRetorno)
		ELSE
			RETURN ''
		ENDIF
	ENDPROC


	PROCEDURE buscarentabla2
		Parameter PcCampo1,PcCampo2,LcTabla
		LcAreaAct=ALIAS()
		LlFound = .F.
		DO CASE
			CASE UPPER(LcTabla)='RAZ'
				SELE (LcTabla)
				LOCATE FOR CodRazon = PcCampo1 AND TipMov=PcCampo2
				cmpRetorno = LcTabla+".CodTransac"
				LlFound=FOUND()

		ENDCASE
		SELE (LcAreaAct)
		IF LlFOUND
			RETURN EVAL(cmpRetorno)
		ELSE
			RETURN ''
		ENDIF
	ENDPROC


	PROCEDURE f_substr
		PARAMETERS LcCadena,LnPosIni,LnPosFin
		LnAncho = LnPosFin - LnPosIni + 1
		RETURN SUBSTR(LcCadena,LnPosIni,LnAncho)
	ENDPROC


	PROCEDURE clearareas
		FOR i = 1 TO this.g_areacount
		   SELECT (m.i)
		   IF !INLIST(ALIAS(),"ACCESS","DBFS","TABLASMODULO","MODULOS",'C_SERVIDORES','C_ALM_DOS','CONSISTENCIA','CMODDETALLE')
		   
			   USE
			ENDIF	   
		ENDFOR
		RETURN
	ENDPROC


	PROCEDURE cheq_o_execsql
		IF this.lSolochequear	&& No actualiza el servidor 
			LnResult = this.Int_Chequea_Error_Carga(this.cPrograma_carga)
		ELSE
			LnResult =this.Int_Chequea_Error_Carga(this.cPrograma_carga)
			IF LnResult >=0
				lnResult = goEntorno.conexion.DoSQL()
			ENDIF
		ENDIF
		RETURN LnResult
	ENDPROC


	PROCEDURE grb_maestro_items
		LOCAL LcArea_actual

		IF TYPE('PlError_Sql') <> 'L'
			PlError_Sql = .F.
		ENDIF
		IF !((THIS.cPrograma_Carga<>"IMP_QUIMICOS_Y_COLORANTES" AND THIS.Operacion='2') OR (THIS.cPrograma_Carga="IMP_QUIMICOS_Y_COLORANTES" AND THIS.Operacion = '3') ) &&OR !PlERROR_SQL
			RETURN
		ENDIF
		LcArea_actual = ALIAS()
		INSERT INTO INT_MAESTRO_ITEMS  (Almacencod,;
									Familia,;
									Subfamilia,;
									Item,;
									Lote,;
									Condicion,;
									UnidadCodi,;
									Llavedos,;
									Usuario,;
									FechaHoraC,;
									FechaHoraM,;
									Estado_reg,;
									Cod_Mod_D) ;
							VALUES ;
									(m.AlmacenCodigo,;
									m.Familia,;
									m.SubFamilia,;
									m.Item,;
		 							m.Lote,;
		 							m.Condicion,;
		 							UnidadCodigo,;
		 							m.LLaveDos,;
		 							m.Usuario,;
		 							DATETIME(),;
		 							DATETIME(),;
		 							LnResult,;
		 							TablasModulo.Cod_Mod_D )
		 
		SELECT (LcArea_Actual) 
		RELEASE PlError_Sql
	ENDPROC


	PROCEDURE chk_condicion
		IF !(EMPTY(ATRCUSOO) OR ISNULL(ATRCUSOO))
			RETURN
		ENDIF
		LOCAL LcAlias_Act,LnNumReg,LsLlave
		LcAlias_Act = ALIAS()
		LsCamposLlave=Tablasmodulo.Pk_Cadena
		DO CASE 
			CASE AlmacenCodigo='CIV'
				LsLLave=ATRCFAMI + ATRCARTI
				REPLACE ATRCUSOO WITH m.Condicion
				LnNumReg=VAL(NumReg)
				SELECT detal
				GO LnNumReg
				REPLACE ATRCUSOO WITH m.Condicion
				LsKey_ATR=atrcfami+atrcarti+atrnlote+atrcmaqu+atrcctel+atrccald+atrccolo+atrcrapp+STR(atrqanch,4,1)+atrserie+atrnpart+atrcusoo
				LsKey_DetaANT=atrcfami+atrcarti+atrnlote+atrcmaqu+atrcctel+atrccald+atrccolo+atrcrapp+STR(atrqanch,4,1)+atrserie+atrnpart+SPACE(LEN(atrcusoo))
				SELECT DETAMOV
				SEEK LsKey_DetaANT
				DO WHILE EVALUATE(LsCamposLlave)=LsKey_DetaANT
					LsKey_Deta=dhtcfami+dhtcarti+dhtnlote+dhtcmaqu+dhtcctel+dhtccald+dhtccolo+dhtcrapp+STR(dhtqanch,4,1)+dhtserie+dhtnpart+m.Condicion
					IF LsKey_Deta=LsKey_ATR
						REPLACE DHTCUSOO WITH m.Condicion
					ENDIF
					SEEK LsKey_DetaANT
				ENDDO
			CASE AlmacenCodigo='CIQ'
			CASE AlmacenCodigo='CIN'
		ENDCASE

		SELECT (LcAlias_Act)
		return
	ENDPROC


	PROCEDURE int_chequea_error_carga
		parameter pTipo_interface
		IF EMPTY(pTipo_interface) 			&& No chequeo nada
			**wait window "No estoy chequeando nada..." nowait
			RETURN 0
		ENDIF
		IF this.nnivelchequeo  = 0			&& No chequeo nada
			**wait window "No estoy chequeando nada..." nowait
			RETURN 0
		ENDIF

		LcLetra = ''
		m.GeneroError=0
		DO CASE 
			CASE pTipo_interface==UPPER("imp_Quimicos_y_colorantes")
					LcLetra = 'A'
					IF INLIST(this.nnivelchequeo,1)
						IF EMPTY(Item) OR  ISNULL(Item)
							this.Graba_id_error( 1,"WH_ItemMast","item","CIQDQHD","QHDCARTI",numreg)
						ENDIF
						IF EMPTY(Linea) OR  ISNULL(Linea)
							this.Graba_id_error( 1,"Linea","WH_ItemMast","PROGRAMA",Linea,numreg)
						ENDIF
						IF EMPTY(Familia) OR  ISNULL(Familia)
							this.Graba_id_error( 1,"WH_ItemMast","Familia","CIQDQHD","QHDCFAMI",numreg)
						ENDIF
						IF EMPTY(SubFamilia) OR  ISNULL(SubFamilia)
							this.Graba_id_error( 1,"WH_ItemMast","SubFamilia","PROGRAMA",SubFamilia,numreg)
						ENDIF
						IF EMPTY(DescripcionLocal) OR  ISNULL(DescripcionLocal)
							IF Familia= '35'
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","CIQDAUX","AUXTAUXI",numreg)
							ELSE
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","CIQDCLO","CLOTCOLO",numreg)
							ENDIF
						ENDIF
						IF EMPTY(CodigoInterno) OR  ISNULL(CodigoInterno)
							this.Graba_id_error( 1,"WH_ItemMast","CodigoInterno","CIQDQHD","QHDCFAMI,QHDCARTI",numreg)
						ENDIF
						IF EMPTY(UnidadCodigo) OR  ISNULL(UnidadCodigo)
							this.Graba_id_error( 1,"WH_ItemMast","UnidadCodigo","CIQDQHD","QHDCUNME",numreg)
						ENDIF
					ENDIF
					***
					IF INLIST(this.nnivelchequeo,3)
						IF EMPTY(Condicion) OR  ISNULL(Condicion)
							this.Graba_id_error( 1,"WH_ItemAlmacen","Condicion","CIQDQDT","QDTCAT03",numreg)
						ENDIF
						IF 	StockActual<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CIQDQDT","QDTQACTU",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CIQDQDT","QDTQINIC",numreg,"Valor negativo Stock inicial")
						ENDIF
					ENDIF
					***
					IF INLIST(this.nnivelchequeo,2,3)
						IF Familia= '35' 
							IF EMPTY(QDTCAT01)
								this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIQDQDT","QDTCAT01",numreg)
							ENDIF
						ELSE
							IF EMPTY(QDTCAT02) OR EMPTY(QDTCAT01)
								this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIQDQDT","QDTCAT02,QDTCAT01",numreg)
							ENDIF
						ENDIF
					ENDIF
					***
			CASE pTipo_interface=UPPER("imp_Almacen_exportacion")
					LcLetra = 'B'
					IF INLIST(this.nnivelchequeo,1,2)
						IF EMPTY(CodigoArtcSet) OR  ISNULL(CodigoArtcSet)
							this.Graba_id_error( 1,"WH_ItemMast","Var:CodigoArtcSet","IGPDART","ARTCSECT",numreg)
						ENDIF
					ENDIF
					IF INLIST(this.nnivelchequeo,2.5)
						IF 	StockActual<0 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CIPDPDT","PDTQACTU",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<0
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CIPDPDT","PDTQINIC",numreg,"Valor negativo Stock inicial")
						ENDIF
					ENDIF

					IF INLIST(this.nnivelchequeo,2)
						IF EMPTY(Item) OR  ISNULL(Item)
							this.Graba_id_error( 1,"WH_ItemMast","item","CIPDPDT","PDTCARTI",numreg)
						ENDIF
						IF EMPTY(FAMILIA) OR  ISNULL(FAMILIA)
							this.Graba_id_error( 1,"WH_ItemMast","FAMILIA","CIPDPDT","PDTCFAMI",numreg)
						ENDIF
						IF EMPTY(DescripcionLocal) OR  ISNULL(DescripcionLocal)
							this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","IGPDART","BDSCABRART",numreg)
						ENDIF
						IF EMPTY(UnidadCodigo) OR  ISNULL(UnidadCodigo)
							this.Graba_id_error( 1,"WH_ItemMast","UnidadCodigo","CIPDPDT","PHDCUNME",numreg)
						ENDIF
					ENDIF

					IF INLIST(this.nnivelchequeo,3)
						IF EMPTY(Condicion) OR  ISNULL(Condicion)
							this.Graba_id_error( 1,"WH_ItemAlmacen","Condicion","CIPDPDT","PDTCAT04",numreg)
						ENDIF
			*!*				IF TYPE("LOTE")='C'
			*!*					IF EMPTY(Lote) OR  ISNULL(Lote) 
			*!*						this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIPDPDT","PDTCAT05, PDTCAT03")
			*!*					ENDIF
			*!*				ENDIF
						IF EMPTY(PDTCAT05) OR EMPTY(PDTCAT03)
							this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIPDPDT","PDTCAT05, PDTCAT03",numreg)
						ENDIF
						IF 	StockActual<0 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CIPDPDT","PDTQACTU",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<0
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CIPDPDT","PDTQINIC",numreg,"Valor negativo Stock inicial")
						ENDIF
					ENDIF

					IF INLIST(this.nnivelchequeo,4)
						IF EMPTY(PDTCAT01) AND EMPTY(PDTCAT02)
							this.Graba_id_error( 1,"GprendasDetalle_Atributos","CodigoAtributo","CIPDPDT","PDTCAT01, PDTCAT02",numreg)
						ENDIF
						IF EMPTY(ValorEspecificoTalla)  && Fallo la equivalencia
							this.Graba_id_error( 1,"GprendasDetalle_Atributos","CodigoAtributo","CIPDPDT","EQUIV:PDTCAT02",numreg)
						ENDIF
					ENDIF
			CASE pTipo_interface=UPPER("imp_Hilado_y_tela_cruda")
			CASE pTipo_interface=UPPER("imp_tela_cruda")

					LcLetra = 'C'
					IF INLIST(this.nnivelchequeo,1)
						IF EMPTY(WFP) OR  ISNULL(WFP)
							this.Graba_id_error( 2,"WH_ItemMast","item","CIVDATR","ATRCFAMI",numreg,"Familia no identificada "+ATRCFAMI)
						ENDIF
						IF EMPTY(Item) OR  ISNULL(Item)
							this.Graba_id_error( 1,"WH_ItemMast","item","CIVDATR","ATRCARTI",numreg)
						ENDIF
						IF EMPTY(FAMILIA) OR  ISNULL(FAMILIA)
							this.Graba_id_error( 1,"WH_ItemMast","FAMILIA","CIVDATR","ATRCFAMI",numreg)
						ENDIF
						IF EMPTY(DescripcionLocal) OR  ISNULL(DescripcionLocal)
							DO CASE
								CASE INLIST(Familia , '04','10','61' )
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","DTEDTEL","TELTTELA",numreg)
								CASE INLIST(Familia , '03','09' )
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","DTEDTCR","TCRTTCRU",numreg)
								CASE INLIST(Familia , '40','33' )
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","DTEDTEP","TEPTTEPL",numreg)
								CASE INLIST(Familia , '05','06','11','12','62')
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","DTEDREC","RECTRECR",numreg)
								CASE INLIST(Familia , '41','42','43','45','59','55','46' )
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","CIVDDES","DESTDESP",numreg)
							ENDCASE 
						ENDIF
						IF EMPTY(UnidadCodigo) OR  ISNULL(UnidadCodigo)
							this.Graba_id_error( 1,"WH_ItemMast","UnidadCodigo","CIVDART","ARTCUNME",numreg)
						ENDIF
						IF EMPTY(Condicion) OR  ISNULL(Condicion) OR EMPTY(Atrcusoo)
							this.Graba_id_error( 1,"WH_ItemMast","Condicion","CIVDATR","ATRcusoo",numreg)
						ENDIF
					ENDIF


					** El Lote
					IF INLIST(this.nnivelchequeo,2)
						DO CASE 
							CASE  INLIST(ATRCFAMI,'03','05','09','11')
								DO CASE
									CASE INLIST(ATRCFAMI,'05') AND EMPTY(ATRFUSAL)
										IF EMPTY(Atrnlote) OR EMPTY(Subs(Atrccald,1,1) ) 
											LsCampo =	IIF(EMPTY(Atrnlote),"Atrnlote",IIF(EMPTY(Atrcmaqu),"Atrcmaqu",IIF(EMPTY(atrcctel),"atrcctel",IIF(EMPTY(Subs(Atrccald,1,1) ),"Atrccald","AtrSerie"))))
											this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR",LsCampo,numreg)
										ENDIF
									OTHER
										IF EMPTY(Atrnlote) OR EMPTY(Atrcmaqu) OR EMPTY(atrcctel) OR EMPTY(Subs(Atrccald,1,1) ) OR EMPTY(AtrSerie)
											LsCampo =	IIF(EMPTY(Atrnlote),"Atrnlote",IIF(EMPTY(Atrcmaqu),"Atrcmaqu",IIF(EMPTY(atrcctel),"atrcctel",IIF(EMPTY(Subs(Atrccald,1,1) ),"Atrccald","AtrSerie"))))
											this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR",LsCampo,numreg)
										ENDIF
								ENDCASE

							CASE ATRCFAMI='33'
								IF EMPTY(Atrnlote) OR EMPTY(Atrcmaqu) OR EMPTY(AtrSerie)
									LsCampo =	IIF(EMPTY(Atrnlote),"Atrnlote",IIF(EMPTY(Atrcmaqu),"Atrcmaqu","AtrSerie"))
									this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR",LsCampo,numreg)
								ENDIF
							CASE ATRCFAMI='55'
								IF EMPTY(Atrcmaqu) 
									this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR","Atrcmaqu",numreg)
								ENDIF
							CASE ATRCFAMI$'04 06 10 12 61 62 69'
								IF EMPTY(Subs(Atrccald,1,1) ) OR EMPTY(AtrSerie) or empty(AtrnPart)
									if empty(AtrnPart) and  !empty(Atrccald) AND !EMPTY(AtrSerie)
									else
										LsCampo =	IIF(EMPTY(Subs(Atrccald,1,1) ),"Atrccald",IIF(EMPTY(AtrSerie),"AtrSerie","AtrnPart"))
										this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR",LsCampo,numreg)
									endif
								ENDIF
							CASE ATRCFAMI$'41 42 43 45 59 46 40'
								IF EMPTY(AtrSerie) 
									this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR","AtrSerie",numreg)
								ENDIF
						ENDCASE 
						IF 	StockActual<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CIVDATR","ATRQACTU",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CIVDATR","ATRQINIC",numreg,"Valor negativo Stock inicial")
						ENDIF

					ENDIF

			CASE pTipo_interface=UPPER("imp_hilados")
					LcLetra = 'D'
					IF INLIST(this.nnivelchequeo,1)
						IF EMPTY(WFP) OR  ISNULL(WFP)
							this.Graba_id_error( 2,"WH_ItemMast","item","CIVDATR","ATRCFAMI",numreg,"Familia no identificada "+ATRCFAMI)
						ENDIF
						IF TYPE("FibFamilia")='C'
							IF EMPTY(FibFamilia) 
								this.Graba_id_error( 2,"WH_ItemMast","item","DTEDFIB","FIBFAMILIA",;
										 numreg,"Vacio - No permite determinar Producto/Familia")
							ENDIF
						ENDIF
						IF EMPTY(DescripcionLocal) OR  ISNULL(DescripcionLocal)
							DO CASE
								CASE INLIST(Familia , '01','02' )
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","DTEDHIL","HILTHILA",numreg)
								CASE Familia$'42 52 58'
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","CIVDDES","DESTDESP",numreg)
							ENDCASE 
						ENDIF
						IF EMPTY(UnidadCodigo) OR  ISNULL(UnidadCodigo)
							this.Graba_id_error( 1,"WH_ItemMast","UnidadCodigo","CIVDART","ARTCUNME",numreg)
						ENDIF
						IF EMPTY(Condicion) OR  ISNULL(Condicion) OR EMPTY(Atrcusoo)
							this.Graba_id_error( 1,"WH_ItemMast","Condicion","CIVDATR","ATRcusoo",numreg)
						ENDIF
					ENDIF
					***********
					*** LOTE ***
					***********
					IF INLIST(this.nnivelchequeo,2)
						DO CASE
							CASE INLIST(Familia , '01','02' )
								IF EMPTY(Atrnlote) OR  EMPTY(ATRNPART)
									IF EMPTY(ATRNPART) AND !EMPTY(Atrnlote)
									ELSE
										this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR",;
																			"Atrnlote",numreg)
									ENDIF
								ENDIF
							CASE Familia$'42 52 58'
								IF EMPTY(AtrSerie) 
									this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIVDATR","AtrSerie",numreg)
								ENDIF
						ENDCASE
						IF 	StockActual<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CIVDATR","ATRQACTU",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<-100000
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CIVDATR","ATRQINIC",numreg,"Valor negativo Stock inicial")
						ENDIF
					ENDIF
			CASE pTipo_interface=UPPER("imp_insumos")
					LcLetra = 'E'
					IF INLIST(this.nnivelchequeo,1)
						IF EMPTY(WFP) OR  ISNULL(WFP)
							this.Graba_id_error( 2,"WH_ItemMast","item","CINDIDT","ATRCFAMI",;
														numreg,"Familia no identificada IDTCFAMI")
						ENDIF
						IF EMPTY(Item) OR  ISNULL(Item)
							this.Graba_id_error( 1,"WH_ItemMast","item","CINDIDT","IDTCARTI",numreg)
						ENDIF
						IF EMPTY(Familia) OR  ISNULL(Familia)
							this.Graba_id_error( 1,"WH_ItemMast","Familia","CINDIDT","IDTCFAMI",numreg)
						ENDIF
						IF EMPTY(SubFamilia) OR  ISNULL(SubFamilia)
							this.Graba_id_error( 1,"WH_ItemMast","SubFamilia","CINDIDT","IDTCFAMI,IDTCAT03",numreg)
						ENDIF
						IF EMPTY(Lote) OR  ISNULL(Lote) 
							IF INLIST(Familia, '15','17' ,'19')
								this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CINDIDT","IDTCAT01",numreg)
							ENDIF
							IF INLIST(Familia, '23','24' ,'28','29')
								this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CINDIDT","IDTCAT02",numreg)
							ENDIF
						ENDIF
					ENDIF
					IF INLIST(this.nnivelchequeo,4)
						IF 	StockActual<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CINDIDT","idtqactu",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<-100000 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CINDIDT","idtqinic",numreg,"Valor negativo Stock inicial")
						ENDIF
					ENDIF
			CASE pTipo_interface=UPPER("imp_pedidos")
					LcLetra = 'F'
			CASE pTipo_interface=UPPER("imp_proveedores")
					LcLetra = 'G'
			CASE pTipo_interface=UPPER("imp_Saldos_Prendas")
					LcLetra = 'H'
					IF INLIST(this.nnivelchequeo,1)
						IF EMPTY(CodigoArtcSet) OR  ISNULL(CodigoArtcSet)
							this.Graba_id_error( 1,"WH_ItemMast","Var:CodigoArtcSet","IGPDART","ARTCSECT",numreg)
						ENDIF
					ENDIF
					IF INLIST(this.nnivelchequeo,2)
						IF EMPTY(Item) OR  ISNULL(Item)
							this.Graba_id_error( 1,"WH_ItemMast","item","CIPDPHD","PDTCARTI",numreg)
						ENDIF
						IF EMPTY(FAMILIA) OR  ISNULL(FAMILIA)
							this.Graba_id_error( 1,"WH_ItemMast","FAMILIA","CIPDPHD","PDTCFAMI",numreg)
						ENDIF
						IF EMPTY(DescripcionLocal) OR  ISNULL(DescripcionLocal)
							IF !INLIST(Familia,'49','50')
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","IGPDART","BDSCABRART",numreg)
							ELSE
								this.Graba_id_error( 1,"WH_ItemMast","DescripcionLocal","CIVDDES","DESTDESP",numreg)
							ENDIF
						ENDIF
						IF EMPTY(UnidadCodigo) OR  ISNULL(UnidadCodigo)
							this.Graba_id_error( 1,"WH_ItemMast","UnidadCodigo","CIPDPHD","PHDCUNME",numreg)
						ENDIF
					ENDIF
					IF INLIST(this.nnivelchequeo,3)
						IF EMPTY(PDTCAT04) OR  ISNULL(PDTCAT04)
							this.Graba_id_error( 1,"WH_ItemAlmacen","Condicion","CIPDPDT","PDTCAT04",numreg)
						ENDIF
						IF EMPTY(PDTCAT05) OR EMPTY(PDTCAT03)
							this.Graba_id_error( 1,"WH_ItemAlmacenLote","Lote","CIPDPDT",IIF(EMPTY(PDTCAT05),"PDTCAT05"," PDTCAT03"),numreg)
						ENDIF
					ENDIF
					IF INLIST(this.nnivelchequeo,2.5)
						IF 	StockActual<0 
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockActual","CIPDPDT","PDTQACTU",numreg,"Valor negativo Stock actual")
						ENDIF
						IF 	StockIngreso<0
							this.Graba_id_error( 2,"WH_ItemAlmacenLote","StockIngreso","CIPDPDT","PDTQINIC",numreg,"Valor negativo Stock inicial")
						ENDIF
					ENDIF

		*!*				IF EMPTY(PDTCAT01) OR EMPTY(PDTCAT02)
		*!*					this.Graba_id_error( 1,"GprendasDetalle_Atributos","CodigoAtributo","CIPDPDT","PDTCAT01, PDTCAT02"
		*!*				ENDIF
		*!*				IF EMPTY(ValorEspecificoTalla)  && Fallo la equivalencia
		*!*					this.Graba_id_error( 1,"GprendasDetalle_Atributos","CodigoAtributo","CIPDPDT","EQUIV:PDTCAT02"
		*!*				ENDIF

				********************************************************
				***			C O M E R C I A L 						 ***
				********************************************************


				CASE pTipo_interface=UPPER("int_ComDCli")

				CASE pTipo_interface=UPPER("int_ComDEmb")

				CASE pTipo_interface=UPPER("int_ComDFah")

				CASE pTipo_interface=UPPER("int_ComDnta")
					DO CASE 
						CASE this.nnivelchequeo=1.1
							LsRegistro=m.CodigoProductoP+m.CodigoFamiliaP+m.CodigoDesarrolloP+m.VersionCodigoDesarrolloP
							IF 	EMPTY(m.NumeroCuadroCmbP) OR ISNULL(m.NumeroCuadroCmbP) 
								LsDesVacio=IIF(ISNULL(m.NumeroCuadroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDISTRIBUCIONTALLACOLOR_DETALLE","NumeroCuadroCmb",LsRegistro,"Numero de cuadro"+LsDesVacio)
							ENDIF
							IF  EMPTY(m.NumeroCmbP) OR ISNULL(m.NumeroCmbP)
								LsDesVacio=IIF(ISNULL(m.NumeroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDISTRIBUCIONTALLACOLOR_DETALLE","NumeroCmb",LsRegistro,"Numero Combinacion"+LsDesVacio)
							ENDIF
						CASE this.nnivelchequeo=1.2
							LsRegistro=LsPFDV
							IF  ISNULL(w_Principal.CodigoDesarrolloSub) OR EMPTY(w_Principal.CodigoDesarrolloSub)
								LsDesVacio=IIF(ISNULL(w_Principal.CodigoDesarrolloSub)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","FLAGREPRES",LsRegistro,"Flag Representativo no se pudo determinar")
							ENDIF
							IF ISNULL(m.CodCol) OR EMPTY(m.CodCol)
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDISTRIBUCIONTALLACOLOR_DETALLE","NumeroCuadroCmb,NumeroCmb",LsRegistro,"Valor vacio o nulo")

							ENDIF
						CASE this.nnivelchequeo=1.3
							LsRegistro=LsPFDV
							IF  ISNULL(m.NumeroCmbP) OR EMPTY(m.NumeroCmbP)
								LsDesVacio=IIF(ISNULL(m.NumeroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","NumeroCmbSub",LsRegistro,"Combinación Sub-Producto"+LsDesVacio)
							ENDIF
							IF  ISNULL(m.NumeroCuadroCmbP) OR EMPTY(m.NumeroCuadroCmbP)
								LsDesVacio=IIF(ISNULL(m.NumeroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","CodigoLayoutSub",LsRegistro,"Layout de Sub-Producto"+LsDesVacio)
							ENDIF
						CASE this.nnivelchequeo=1.4
							LsRegistro=LsPFDV
							IF ISNULL(m.CodCol) OR EMPTY(m.CodCol)
								LsDesVacio=IIF(ISNULL(m.CodCol)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","CodigoProductoSub",LsRegistro,"no se pudo determinar COLOR")
							ENDIF
						CASE this.nnivelchequeo=1.6
							LsRegistro=LsPFDV
							IF ISNULL(m.ANHP) OR EMPTY(m.ANHP)
								LsDesVacio=IIF(ISNULL(m.ANHP)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","ANHP","MPEDIDOTDV","FhPedido",LsRegistro,"no se pudo determinar AÑO DE PEDIDO")
							ENDIF
							IF ISNULL(m.NOHP) OR EMPTY(m.NOHP)
								LsDesVacio=IIF(ISNULL(m.NOHP)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","NOHP","MPEDIDOTDV","NumeroPedidoTdv",LsRegistro,"no se pudo determinar NUMERO DE PEDIDO")
							ENDIF
							IF ISNULL(m.SUB) OR EMPTY(m.SUB)
								LsDesVacio=IIF(ISNULL(m.SUB)," nulo"," en blanco")
								this.Graba_id_error( 2,"ComDnta","SUB","MPEDIDOTDV","NumeroPedidoTdv_SUB",LsRegistro,"no se pudo determinar Pedido Sub")
							ENDIF
					ENDCASE

				CASE pTipo_interface=UPPER("int_ComdPec")
					DO CASE 
						CASE this.nnivelchequeo=1.1
							LsRegistro=m.CodigoProductoP+m.CodigoFamiliaP+m.CodigoDesarrolloP+m.VersionCodigoDesarrolloP
							IF 	EMPTY(m.NumeroCuadroCmbP) OR ISNULL(m.NumeroCuadroCmbP) 
								LsDesVacio=IIF(ISNULL(m.NumeroCuadroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDISTRIBUCIONTALLACOLOR_DETALLE","NumeroCuadroCmb",LsRegistro,"Numero de cuadro"+LsDesVacio)
							ENDIF
							IF  EMPTY(m.NumeroCmbP) OR ISNULL(m.NumeroCmbP)
								LsDesVacio=IIF(ISNULL(m.NumeroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDISTRIBUCIONTALLACOLOR_DETALLE","NumeroCmb",LsRegistro,"Numero Combinacion"+LsDesVacio)
							ENDIF
						CASE this.nnivelchequeo=1.2
							LsRegistro=LsPFDV
							IF  ISNULL(w_Principal.CodigoDesarrolloSub) OR EMPTY(w_Principal.CodigoDesarrolloSub)
								LsDesVacio=IIF(ISNULL(w_Principal.CodigoDesarrolloSub)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","FLAGREPRES",LsRegistro,"Flag Representativo no se pudo determinar")
							ENDIF
							IF ISNULL(m.CodCol) OR EMPTY(m.CodCol)
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDISTRIBUCIONTALLACOLOR_DETALLE","NumeroCuadroCmb,NumeroCmb",LsRegistro,"Valor vacio o nulo")

							ENDIF
						CASE this.nnivelchequeo=1.3
							LsRegistro=LsPFDV
							IF  ISNULL(m.NumeroCmbP) OR EMPTY(m.NumeroCmbP)
								LsDesVacio=IIF(ISNULL(m.NumeroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","NumeroCmbSub",LsRegistro,"Combinación Sub-Producto"+LsDesVacio)
							ENDIF
							IF  ISNULL(m.NumeroCuadroCmbP) OR EMPTY(m.NumeroCuadroCmbP)
								LsDesVacio=IIF(ISNULL(m.NumeroCmbP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","CodigoLayoutSub",LsRegistro,"Layout de Sub-Producto"+LsDesVacio)
							ENDIF
						CASE this.nnivelchequeo=1.4
							LsRegistro=LsPFDV
							IF ISNULL(m.CodCol) OR EMPTY(m.CodCol)
								LsDesVacio=IIF(ISNULL(m.CodCol)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODCOL","MDGP_CMB_DETALLE_CMB_DETALLE","CodigoProductoSub",LsRegistro,"no se pudo determinar COLOR")
							ENDIF
						CASE this.nnivelchequeo=1.5
							LsRegistro=LsPFDV
							IF ISNULL(m.CodTal) OR EMPTY(m.CodTal)
								LsDesVacio=IIF(ISNULL(m.CodTal)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","CODTAL","MDGP_CMB_DETALLE_CMB_DETALLE","CodigoTalla",LsRegistro,"no se pudo determinar TALLA")
							ENDIF
						CASE this.nnivelchequeo=1.6
							LsRegistro=LsPFDV
							IF ISNULL(m.anemb) OR EMPTY(m.anemb)
								LsDesVacio=IIF(ISNULL(m.anemb)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","anemb","MEMBARQUE","FHEmbarque",LsRegistro,"no se pudo determinar AÑO EMBARQUE")
							ENDIF
							IF ISNULL(m.noemb) OR EMPTY(m.noemb)
								LsDesVacio=IIF(ISNULL(m.noemb)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","noemb","MEMBARQUE_DETALLE","NumeroEmbarque",LsRegistro,"no se pudo determinar NUMERO EMBARQUE")
							ENDIF
							IF ISNULL(m.ANHP) OR EMPTY(m.ANHP)
								LsDesVacio=IIF(ISNULL(m.ANHP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","ANHP","MPEDIDOTDV","FhPedido",LsRegistro,"no se pudo determinar AÑO DE PEDIDO")
							ENDIF
							IF ISNULL(m.NOHP) OR EMPTY(m.NOHP)
								LsDesVacio=IIF(ISNULL(m.NOHP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","NOHP","MPEDIDOTDV","NumeroPedidoTdv",LsRegistro,"no se pudo determinar NUMERO DE PEDIDO")
							ENDIF
							IF ISNULL(m.SUB) OR EMPTY(m.SUB)
								LsDesVacio=IIF(ISNULL(m.SUB)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","SUB","MPEDIDOTDV","NumeroPedidoTdv_SUB",LsRegistro,"no se pudo determinar Pedido Sub")
							ENDIF
							IF ISNULL(m.SUP) OR EMPTY(m.SUP)
								LsDesVacio=IIF(ISNULL(m.SUP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEC","SUP","MPEDIDOTDV","NumeroPedidoTdv_SUB",LsRegistro,"no se pudo determinar Pedido Sup")
							ENDIF
					ENDCASE

				CASE pTipo_interface=UPPER("int_ComDPem")
					DO CASE 
						CASE this.nnivelchequeo=1.6
							LsRegistro=""
							IF ISNULL(m.anemb) OR EMPTY(m.anemb)
								LsDesVacio=IIF(ISNULL(m.anemb)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEM","anemb","MEMBARQUE","FHEmbarque",LsRegistro,"no se pudo determinar AÑO EMBARQUE")
							ENDIF
							IF ISNULL(m.noemb) OR EMPTY(m.noemb)
								LsDesVacio=IIF(ISNULL(m.noemb)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEM","noemb","MEMBARQUE_DETALLE","NumeroEmbarque",LsRegistro,"no se pudo determinar NUMERO EMBARQUE")
							ENDIF
							IF ISNULL(m.ANHP) OR EMPTY(m.ANHP)
								LsDesVacio=IIF(ISNULL(m.ANHP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEM","ANHP","MPEDIDOTDV","FhPedido",LsRegistro,"no se pudo determinar AÑO DE PEDIDO")
							ENDIF
							IF ISNULL(m.NOHP) OR EMPTY(m.NOHP)
								LsDesVacio=IIF(ISNULL(m.NOHP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEM","NOHP","MPEDIDOTDV","NumeroPedidoTdv",LsRegistro,"no se pudo determinar NUMERO DE PEDIDO")
							ENDIF
							IF ISNULL(m.SUB) OR EMPTY(m.SUB)
								LsDesVacio=IIF(ISNULL(m.SUB)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEM","SUB","MPEDIDOTDV","NumeroPedidoTdv_SUB",LsRegistro,"no se pudo determinar Pedido Sub")
							ENDIF
							IF ISNULL(m.SUP) OR EMPTY(m.SUP)
								LsDesVacio=IIF(ISNULL(m.SUP)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMDPEM","SUP","MPEDIDOTDV","NumeroPedidoTdv_SUB",LsRegistro,"no se pudo determinar Pedido Sup")
							ENDIF
					ENDCASE

				CASE pTipo_interface=UPPER("int_ComDpoc")

				CASE pTipo_interface=UPPER("int_ComDpoh")

				CASE pTipo_interface=UPPER("int_ComDpop")

				CASE pTipo_interface=UPPER("int_Comm01")
					DO CASE 
						CASE this.nnivelchequeo=1
							**m.anoped01+m.numped01+m.codcol01+m.procol01+m.codfam01
							LsRegistro=LsPFDV
							IF ISNULL(m.anoped01) OR EMPTY(m.anoped01)
								LsDesVacio=IIF(ISNULL(m.anoped01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","anoped01","MPEDIDOTDV","FhPedido",LsRegistro,"no se pudo determinar AÑO DE PEDIDO")
							ENDIF
							IF ISNULL(m.numped01) OR EMPTY(m.numped01)
								LsDesVacio=IIF(ISNULL(m.numped01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","numped01","MPEDIDOTDV","NumeroPedidoTdv",LsRegistro,"no se pudo determinar NUMERO DE PEDIDO")
							ENDIF
							IF ISNULL(m.CODCOL01) OR EMPTY(m.CODCOL01)
								LsDesVacio=IIF(ISNULL(m.CODCOL01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","CODCOL01","MDGP_CMB_DETALLE_CMB_DETALLE","FlagRepres",LsRegistro,"COLOR PRINCIPAL"+LsDesVacio)
							ENDIF
							IF ISNULL(m.PROCOL01) OR EMPTY(m.PROCOL01)
								LsDesVacio=IIF(ISNULL(m.PROCOL01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","PROCOL01","MDGP_BLOQUES","FlagRepres",LsRegistro,"RRC"+LsDesVacio)
							ENDIF
							IF ISNULL(m.FAMCON01) OR EMPTY(m.FAMCON01)
								LsDesVacio=IIF(ISNULL(m.FAMCON01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","FAMCON01","SOLO SE VALIDA","EN DOS",LsRegistro,"RRC"+LsDesVacio)
							ENDIF
							IF ISNULL(m.codfam01) OR EMPTY(m.codfam01) OR m.codfam01='XX'
								LsDesVacio=IIF(ISNULL(m.codfam01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","codfam01","MDGP_CMB_DETALLE_CMB_DETALLE","CodigoFamiliaSub,CodigoProductoSub",LsRegistro,"Familia"+LsDesVacio)
							ENDIF
							IF (ISNULL(m.codrap01) OR EMPTY(m.codrap01)) AND m.TipoRapp='02'
								LsDesVacio=IIF(ISNULL(m.codrap01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","codrap01","MLAYOUTTELAS","CodigoLayout",LsRegistro,"RAPORT"+LsDesVacio)
							ENDIF
							IF (ISNULL(m.collis01) OR EMPTY(m.collis01)) AND m.TipoRapp='02'
								LsDesVacio=IIF(ISNULL(m.collis01)," nulo"," en blanco")
								this.Graba_id_error( 2,"COMM01","collis01","MLAYOUTTELAS_cmb","CodigoLayout",LsRegistro,"COLOR DE LA RAYA"+LsDesVacio)
							ENDIF


					ENDCASE
				******************************************************** 
				***			T E L A S								 ***
				********************************************************
				CASE pTipo_interface=UPPER("int_DtedFIB")
				CASE pTipo_interface=UPPER("int_DtedHIL")
				CASE pTipo_interface=UPPER("int_DtedRAL")
				CASE pTipo_interface=UPPER("int_DtedRAP")
				CASE pTipo_interface=UPPER("int_DtedREC")
				CASE pTipo_interface=UPPER("int_DtedRPR")
				CASE pTipo_interface=UPPER("int_DtedRRA")
				CASE pTipo_interface=UPPER("int_DtedTCC")
				CASE pTipo_interface=UPPER("int_DtedTCR")
				CASE pTipo_interface=UPPER("int_DtedTEJ")
				CASE pTipo_interface=UPPER("int_DtedTEL")
				CASE pTipo_interface=UPPER("int_DtedTEP")
				CASE pTipo_interface=UPPER("int_DtedTRC")
				CASE pTipo_interface=UPPER("int_DtedTTJ")
				CASE pTipo_interface=UPPER("int_DteM03")
				CASE pTipo_interface=UPPER("int_DteM05")


				********************************************************
				***			F I C H A  T E C N I C A				 ***
				********************************************************
				CASE pTipo_interface=UPPER("int_IGPDART")
				CASE pTipo_interface=UPPER("int_IGPDCOL")
				CASE pTipo_interface=UPPER("int_IGPDCON")
				CASE pTipo_interface=UPPER("int_IGPDHRE")
				CASE pTipo_interface=UPPER("int_IGPDMED")
				CASE pTipo_interface=UPPER("int_IGPDMXA")
				CASE pTipo_interface=UPPER("int_IGPDPAA")
				CASE pTipo_interface=UPPER("int_IGPDPXA")
				CASE pTipo_interface=UPPER("int_IGPDTAL")
				CASE pTipo_interface=UPPER("int_IGPDTCB")
				CASE pTipo_interface=UPPER("int_IGPDTXA")
				CASE pTipo_interface=UPPER("int_IGPM02")
				CASE pTipo_interface=UPPER("int_IGPM03")
				CASE pTipo_interface=UPPER("int_IGPM10")
				CASE pTipo_interface=UPPER("int_IGPM11")
				CASE pTipo_interface=UPPER("int_IGPM12")

				********************************************************
				***		C O N T R O L    D E   T I N T O R E R I A	 ***
				********************************************************
				CASE pTipo_interface=UPPER("int_TINDCOL")

				************************************************************************
				***		C O N T R O L    D E   A L M A N C E N 		I N S U M O S	 ***
				************************************************************************
				CASE pTipo_interface=UPPER("int_CINDAFA")
				CASE pTipo_interface=UPPER("int_CINDHIF")
				CASE pTipo_interface=UPPER("int_CINTDIN")
				CASE pTipo_interface=UPPER("int_CINTHIN")


				*******************************************************************************************
				***		C O N T R O L    D E   I N V E N T A R I O	DE  	P R E N D A S			    ***
				*******************************************************************************************
				CASE pTipo_interface=UPPER("int_CIPDPDT")
				CASE pTipo_interface=UPPER("int_CIPH06")
				CASE pTipo_interface=UPPER("int_CIPTDPR")
				CASE pTipo_interface=UPPER("int_CIPTHPR")

				*******************************************************************************************
				***		C O N T R O L    D E   I N V E N T A R I O	DE  	Q U I M I C O S			    ***
				*******************************************************************************************
				CASE pTipo_interface=UPPER("int_CIQDCLO")
				CASE pTipo_interface=UPPER("int_CIQTHQU")
				CASE pTipo_interface=UPPER("int_CIQTDQU")

				*******************************************************************************************
				***		C O N T R O L    D E   I N V E N T A R I O	DE  T E L A   P R O C E S A D  A    ***
				*******************************************************************************************
				CASE pTipo_interface=UPPER("int_CITDATR")
				CASE pTipo_interface=UPPER("int_CITH05")
				CASE pTipo_interface=UPPER("int_CITH06")
				CASE pTipo_interface=UPPER("int_CITTHHT")
				CASE pTipo_interface=UPPER("int_CITTDHT")

				*******************************************************************************************
				***		C O N T R O L    D E   I N V E N T A R I O	DE  HILADO Y TELA CRUDA			    ***
				*******************************************************************************************
				CASE pTipo_interface=UPPER("int_CIVDATR")
				CASE pTipo_interface=UPPER("int_CIVDCIN")
				CASE pTipo_interface=UPPER("int_CIVDOLT")
				CASE pTipo_interface=UPPER("int_CIVH05")
				CASE pTipo_interface=UPPER("int_CIVH06")
				CASE pTipo_interface=UPPER("int_CIVTHHT")
				CASE pTipo_interface=UPPER("int_CIVTDHT")
				CASE pTipo_interface=UPPER("int_CIVDUSO")
				CASE pTipo_interface=UPPER("int_CIVDFAM")


		ENDCASE
		RETURN m.GeneroError
		************************
	ENDPROC


	PROCEDURE graba_id_error
		parameter _TipoErr,_Tablasql,_CampoSql,_TablaDos,_CampoDos,_NumReg,_DesError
		IF PARAMETERS()=0
			RETURN
		ENDIF
		PRIVATE Area_Actual,LnNumReg
		Area_Actual = ALIAS()
		IF !USED("ERROR_CARGA") 
			LcarcError= GoEntorno.LocPath+"int_err1.dbf"
			LcArcTmp1 = GoEntorno.LocPath+"err"+TablasModulo.Cod_Mod_D+TablasModulo.Cod_Tabla
			SELE 0
			USE (LcArcError) SHARED
			COPY STRU TO (LcArcTmp1)
			USE (LcArcTmp1) EXCLU ALIAS ERROR_CARGA
		ELSE
			SELE ERROR_CARGA
		ENDIf
		DO CASE 
			CASE _TipoErr=1
				M.Des_Error = "Valor en blanco o nulo"
			CASE _TipoErr=2
				M.Des_Error =_DesError
		ENDCASE 

		m.Campo01 = _Tablasql
		m.Campo02 = _CampoSql
		m.Campo03 = _TablaDos
		m.Campo04 = _CampoDos
		m.Campo05 = 	pTablaOrigen +":"+_Numreg
		DO CASE 
			CASE pTipo_interface='INT'
			CASE pTipo_interface='IMP'
				m.Campo06 = 	Familia+" "+SUBSTR(ITEM,3,5)
		ENDCASE
		m.Usuario    = Goentorno.USer.login
		m.FhProceso = datetime() 
		IF TYPE('StockIngreso')='N'
			m.Stkini          = StockIngreso
		ELSE
			m.Stkini = 0
		ENDIF
		IF TYPE('StockIngreso')='N'
			m.StkAct        = StockActual
		ELSE
			m.StkAct = 0
		ENDIF
		LnNumReg=RECCOUNT()
		m.id_Error = TRAN(LnNumreg+1,"@L 999,999")
		if lnnumreg=1
		endif 

		IF !EOF()  && Verificamos si no es un criterio de error repedtido 
			IF m.Campo01==TRIM(Campo01) AND m.Campo02==TRIM(Campo02) AND m.Campo03==TRIM(Campo03) AND ;
				m.Campo04==TRIM(Campo04) AND m.Campo05==TRIM(Campo05) AND M.Des_Error=TRIM(Des_Error)
				SELE (Area_Actual)
				return
			ENDIF
		ENDIF
		APPEND BLANK 
		GATHER MEMVAR
		IF !EMPTY(Area_Actual)
			SELE (Area_Actual)
		ENDIF
		m.GeneroError=-99
		RETURN
	ENDPROC


	*-- Establece paths por modulos segun el tipo de interface
	PROCEDURE carga_configuracion_tipo
		PARAMETERS _TipoInterface
		this.ntipointerface = _TipoInterface
		this.programasxmodulos()
	ENDPROC


	*-- Establece unidad de negocio segun sede actual.
	PROCEDURE cambiar_unidad_negocio
		PARAMETERS _UnidadNegocio
		THIS.cunidadnegocio = _UnidadNegocio
		THIS.lCambiarUnidadNegocio=.T.
		THIS.ProgramasXModulos()
	ENDPROC


	PROCEDURE cierra_tablas
		PARAMETERS cTipo
		cTipo=UPPER(cTipo)
		DO CASE
			CASE ctipo = 'COLORES'
				IF used("Gamas_INT")
					USE in "Gamas_INT"
				ENDIF
				IF used("GTablas_Detalle_INT")
					USE in "GTablas_Detalle_INT"
				ENDIF
				IF used("MdesarrolloColores_detalle_INT")
					USE in "MdesarrolloColores_Detalle_INT"
				ENDIF
				IF used("Colores_INT")
					USE in "Colores_INT"
				ENDIF
				IF used("ATRIBUTOS_INT")
					USE in "Atributos_INT"
				ENDIF
				IF used("Busca_Recetas")
					USE in "Busca_Recetas"
				ENDIF
				IF used("TindCol")
					USE in "TindCol"
				ENDIF
				IF used("Tnf11")
					USE in "Tnf11"
				ENDIF
				IF used("Tnf12")
					USE in "Tnf12"
				ENDIF
				IF used("Equivale")
					USE in "Equivale"
				ENDIF
				IF used("Fibras")
					USE IN "FIBRAS"
				ENDIF
				IF USED("GRecetas_atributos")
					USE IN "GRecetas_atributos"
				ENDIF
			CASE ctipo = 'GPP'
			CASE ctipo = 'COM'
				IF USED('COMDPOH')
					USE IN COMDPOH
				ENDIF
				IF USED('COMDCTA')
					USE IN COMDCTA
				ENDIF
				IF USED('COMDNTA')
					USE IN COMDNTA
				ENDIF
				IF USED('COMM01')
					USE IN COMM01
				ENDIF
				IF USED('COMM02')
					USE IN COMM02
				ENDIF
				IF USED('COMDPOC')
					USE IN COMDPOC
				ENDIF
				IF USED('COMDPOP')
					USE IN COMDPOP
				ENDIF
				IF USED('COMDPEC')
					USE IN COMDPEC
				ENDIF
				IF USED('COMDEMB')
					USE IN COMDEMB
				ENDIF
				IF USED('COMDTAA')
					USE IN COMDTAA
				ENDIF
				IF USED('COMDFAH')
					USE IN COMDFAH
				ENDIF
			CASE ctipo = 'IGP'
				IF USED('IGPDPAA')
					USE IN IGPDPAA
				ENDIF
				IF USED('IGPDTXA')
					USE IN IGPDTXA
				ENDIF
				IF USED('IGPDPXA')
					USE IN IGPDPXA
				ENDIF
				IF USED('IGPDMXA')
					USE IN IGPDMXA
				ENDIF
				IF USED('IGPDPIE')
					USE IN IGPDPIE
				ENDIF
				IF USED('IGPDTAL')
					USE IN IGPDTAL
				ENDIF
				IF USED('IGPM02')
					USE IN IGPM02
				ENDIF
				IF USED('IGPM03')
					USE IN IGPM03
				ENDIF
				IF USED('IGPDCOL')
					USE IN IGPDCOL
				ENDIF
				IF USED('IGPDCON')
					USE IN IGPDCON
				ENDIF
				IF USED('IGPEPIE')
					USE IN IGPEPIE
				ENDIF
				IF USED('IGPDCODE')
					USE IN IGPDCODE
				ENDIF
				IF USED('IGPDART')
					USE IN IGPDART
				ENDIF

		ENDCASE 
	ENDPROC


	PROCEDURE actualiza_detalle
		PARAMETERS LCCODIGO, LCOPCION
		LNITEM = '000'
		SELECT TNF12
		SEEK LCCODIGO
		DO WHILE !EOF() AND TNF12.CSRID = LCCODIGO
			M.CODLAB = TNF12.CSRIT
			SELECT EQUIVALE
			SEEK ALLTRIM(m.CODLAB)
			IF FOUND()
				PCCODPROINSUMO 	   = EQUIVALE.CODPROD
				PCCODFAMINSUMO 	   = EQUIVALE.CODFAM
				PCCODESTILOINSUMO  = EQUIVALE.CODINS
				PCVERCODESTILOINSUMO = '001'

				PNKGS 				= STR(0)
				PNGMS 				= STR(0)
				PNMGRS 				= STR(0)
				PCETAPA 			= TNF12.CSRET
				PCIDEREACCION 		= '00067'
				PCELEREACCION 		= IIF(ALLTRIM(TNF12.TSRCN)='%','00001','00002') &&ElementoReaccion

				PCCODTIPPROCESO    	= IIF(LCOPCION=1,'01',IIF(LCOPCION = 2,'02','03'))
				PCCODTIPSUBPROCESO 	= '01'
				PCCLASIFICAPROCESO 	= IIF(LCOPCION=1,'02',IIF(LCOPCION = 2,'17','22'))

				PCTIPOOPE			= 'I'
				PCITEM 				= PADL(ALLTRIM(STR(VAL(LNITEM)+1)),3,'0')
				PNCONCENTRACION 	= STR(TNF12.QSRIT,7,4)

				LCSQL =  "EXEC DDPCOL1_ElaboracionReceta_Gen_MantReceta_Detalle  '"+;
					M.CODIGODESARROLLO+ "','" +m.CODIGOPRODUCTO+ "','" +m.CODIGOFAMILIA+ "','" +m.CODIGODESARROLLO+ "','" +m.VERSIONCODIGODESARROLLO + "','" +;
					M.VERCODRECETA + "','" +PCCODTIPPROCESO+ "','" +PCCODTIPSUBPROCESO+ "','" +PCCLASIFICAPROCESO+ "','" +PCITEM + "','" +;
					PCCODPROINSUMO+ "','" +PCCODFAMINSUMO+ "','" +PCCODESTILOINSUMO+ "','" +PCVERCODESTILOINSUMO + "','" +;
					PNKGS+ "','" +PNGMS+ "','" +PNMGRS+ "','" +PNCONCENTRACION+ "','" +PCETAPA+ "','" +PCIDEREACCION + "','" +;
					PCELEREACCION+ "','" +m.USUARIO+ "','" + PCTIPOOPE + "'"
				GOENTORNO.CONEXION.CSQL = LCSQL
				GOENTORNO.CONEXION.CCURSOR = "GRecetas_Detalle"
				LNRESULT = THIS.CHEQ_O_EXECSQL()
				IF LNRESULT <= 0
					THIS.CIERRA_TABLAS('COLORES')
					IF LNRESULT = -99
						=MESSAGEBOX("Error en el servidor.Proceso Interrumpido","ERROR ODBC")
						RETURN
					ELSE
						=MESSAGEBOX("La información del insumo "+ PCCODESTILOINSUMO +"-"+ PCVERCODESTILOINSUMO  + " no se registró. Consulte al Dpto. de Sistemas", 0+48, "Mensaje del Sistema")
						RETURN
					ENDIF
				ENDIF
				LNITEM = PADL(ALLTRIM(STR(VAL(LNITEM)+1)),3,'0')
			ENDIF
			SELECT TNF12
			SKIP
		ENDDO
		RETURN
	ENDPROC


	PROCEDURE busca_atributo
		PARAMETERS lcCodAtributo, lcValorAtributo
		lcSql = "SELECT * FROM GRecetas_atributos " +;
			" WHERE CodigoProducto = '" + m.CodigoProducto + "' AND " +;
			" CodigoFamilia = '" + m.CodigoFamilia + "' AND " +;
			" CodigoDesarrollo = '" + m.CodigoDesarrollo + "' AND "+;
			" CodigoReceta  = '" + m.CodigoDesarrollo + "' AND " +;
			" VersionCodigoReceta = '" + m.VerCodReceta + "' AND " + ;
			" VersionCodigoDesarrollo = '"+ m.VersionCodigoDesarrollo + "' AND "+;
			" CodigoAtributo = '" + lcCodAtributo + "' "
		goEntorno.conexion.cSql = lcSql
		goEntorno.conexion.cCursor = "GRecetas_atributos"
		lnResult = THIS.Cheq_o_ExecSql()
		IF lnResult <= 0
		ELSE
			SELECT GRecetas_atributos
			GO TOP
			IF !EOF() AND !BOF()
				lcSql = "UPDATE GRecetas_atributos " +;
					" SET ValorEspecifico = '" + lcValorAtributo +"', " + ;
					" FlagEliminado = 1 "+;
					" WHERE CodigoProducto = '" + m.CodigoProducto + "' AND " +;
					" CodigoFamilia = '" + m.CodigoFamilia + "' AND " +;
					" CodigoDesarrollo = '" + m.CodigoDesarrollo + "' AND "+;
					" CodigoReceta  = '" + m.CodigoDesarrollo + "' AND " +;
					" VersionCodigoReceta = '" + m.VerCodReceta + "' AND " + ;
					" VersionCodigoDesarrollo = '"+ m.VersionCodigoDesarrollo + "' AND "+;
					" CodigoAtributo = '" + lcCodAtributo + "' "
			ELSE
				lcSql = "INSERT INTO GRecetas_atributos (CodigoProducto,CodigoFamilia,CodigoDesarrollo,"+;
					" CodigoReceta, VersionCodigoReceta, VersionCodigoDesarrollo, CodigoAtributo, ValorEspecifico,"+;
					" SecuenciaValor, FHCreacion, UsuarioCreacion, EstacionCreacion) " +;
					" VALUES ('"+ m.CodigoProducto + "','" +  m.CodigoFamilia + "','" + m.CodigoDesarrollo + "','"+;
					m.CodigoDesarrollo + "','"+ m.VerCodReceta + "','" + m.VersionCodigoDesarrollo+"','"+lcCodAtributo+"','"+lcValorAtributo+"',NUll,'"+;
					ttoc(datetime()) + "','" + m.Usuario + "','" + m.Estacion + "')" 
			ENDIF
			goEntorno.conexion.cSql = lcSql
			goEntorno.conexion.cCursor = "MaestroColores"
			lnResult = THIS.Cheq_o_ExecSql()
			IF lnResult <= 0
				THIS.CIERRA_TABLAS('COLORES')
				IF lnResult = -99
					=MessageBox("Error en el servidor.Proceso Interrumpido","ERROR ODBC")
					RETURN
				ELSE
					=MESSAGEBOX("Error: No se actualizo Informacion de atributos " + lcCodAtributo+ " S.D.C. " +m.CodigoDesarrollo , 48 ,"Migracion de Colores")		RETURN
				ENDIF
			ENDIF
		ENDIF
		IF USED("GRecetas_atributos")
			USE IN "GRecetas_atributos"
		ENDIF
		RETURN
	ENDPROC


	*-- Restablece los paths y cierra tablas de configuración para la interface
	PROCEDURE restaurar
		this.cierra_tabla('TABLASMODULO')
		this.cierra_tabla('MODULOS')
		this.cierra_tabla('M_ITEMS')
		this.cierra_tabla('CONSISTENCIA')
		this.cierra_tabla('ERRORES')
		this.cierra_tabla('MIGRADOS')
		this.cierra_tabla('CONSISTENCIA_RPT')
		this.cierra_tabla('INT_CONSISTENCIA_H')
		this.cierra_tabla('PedidosSql')
		this.cierra_tabla('Comecli')
		this.cierra_tabla('Tallas')
		this.cierra_tabla('Comdtaa')
		this.cierra_tabla('Comdpoh')
		this.cierra_tabla('Comdnta')
		this.cierra_tabla('Comdcta')
		this.cierra_tabla('Igpdpaa')
		this.cierra_tabla('Comm01')
		this.cierra_tabla('Comm02')
		this.cierra_tabla('DIFERENCIAS')

		THIS.restaura_rutas()
	ENDPROC


	*-- Inicializa las rutas de acceso a las Tablas de la red
	PROCEDURE inicializapath
		SET PATH TO
	ENDPROC


	*-- Actualiza en archivo de log
	PROCEDURE generalog
		PARAMETERS _CadenaLog
	ENDPROC


	PROCEDURE cierra_tabla
		PARAMETERS _ALIAS
		IF EMPTY(_ALIAS)
			RETURN
		ENDIF
		IF USED(_ALIAS)
			SELECT (_ALIAS)
			USE
		ENDIF
	ENDPROC


	*-- Chequea integridad de la información a ser migrada al DOS
	PROCEDURE int_consistencia
		PARAMETERS _Pedido,_PFDV,_id_error,_DES_ERROR,_des_opcion
		IF PARAMETERS() = 3 
			_DES_ERROR = ''
			_DES_OPCION = ''
		ENDIF
		IF ISNULL(_des_opcion)
			_DES_OPCION = ''
		ENDIF
		IF ISNULL(_DES_ERROR)
			_DES_ERROR = ''
		ENDIF
		IF isnull(_pedido)
			_Pedido=SPACE(6)
		ENDIF
		**
		IF 	!this.lacceso_consistencia 
			RETURN
		ENDIF
		**
		IF !this.lacceso_errores 
			RETURN
		ENDIF
		**
		IF !this.lacceso_migrados
			RETURN
		ENDIF
		**
		IF  !SEEK(_id_error,'ERRORES')
			RETURN
		ENDIF
		**
		LOCAL LsArea_act,LsLLaveCon
		LsArea_Act = ALIAS()
		SELECT consistencia
		DO CASE
			CASE this.ctabla_dos ='IGP' or this.cmodulo_dos ='IGP'
				SET ORDER TO PK02
				LsLLaveCon = _PFDV+_Id_Error
			CASE this.ctabla_dos ='COM' or this.cmodulo_dos ='COM'
				SET ORDER TO PK01
				LsLLaveCon = PADR(_Pedido,8)+_Id_Error
		ENDCASE
		*
		SEEK LsLLaveCon
		IF !FOUND()
			APPEND BLANK
			REPLACE NumPed		WITH LEFT(PADR(_Pedido,8),6)
			IF FIELD(2)='SUB'
				REPLACE Sub			WITH RIGHT(PADR(_Pedido,8),2)
			ENDIF
			REPLACE PFDV		WITH _PFDV 
			REPLACE ID_ERROR 	WITH _id_error
		ENDIF

		IF EMPTY(_DES_ERROR)
			REPLACE DETALLE		WITH IIF(SEEK(_id_error,'ERRORES'),ERRORES.NOMBRE,'NO DEFINIDO')
		ELSE
			REPLACE DETALLE		WITH _DES_ERROR 
		ENDIF
		IF !EMPTY(_DES_OPCION)
			REPLACE VERIFICAR   WITH TRIM(ERRORES.OPCION)+' '+TRIM(_DES_OPCION)
		ELSE
			REPLACE VERIFICAR   WITH TRIM(ERRORES.OPCION)
		ENDIF
		REPLACE usuario WITH goentorno.USER.login
		REPLACE fhproceso WITH DATETIME()
		IF VARTYPE(TIPO)='C'
			REPLACE TIPO WITH '1'	&& Errores
		ENDIF
		** Actualiza tabla de datos migrados **
		IF this.ctabla_dos ='COM' or this.cmodulo_dos ='COM'
			SELECT migrados
			SEEK consistencia.Numped
			IF FOUND()
				REPLACE FlgErr04 WITH 'X'
				REPLACE FECMOD04 WITH DATE()
				REPLACE HORMOD04 WITH TIME()
				REPLACE USUMOD04 WITH GOENTORNO.USER.LOGIN
			ENDIF
		ENDIF

		IF !EMPTY(LsArea_Act)
			SELECT (LsArea_act)
		ENDIF
	ENDPROC


	*-- Actualiza tabla de datos migrados
	PROCEDURE int_migrados
		PARAMETERS _Pedido,_PFDV
		IF PARAMETERS() = 1 
			_PFDV = ''
		ENDIF
		IF 	!this.lacceso_consistencia 
			RETURN
		ENDIF
		IF !this.lacceso_errores 
			RETURN
		ENDIF
		IF !this.lacceso_migrados
			RETURN
		ENDIF


		LOCAL LsArea_act
		LsArea_Act = ALIAS()
		SELECT MIGRADOS
		SEEK _Pedido
		IF !FOUND()
			APPEND BLANK
			REPLACE ANPEDI04 WITH LEFT(_PEDIDO,2)
			REPLACE NOPEDI04 WITH SUBSTR(_PEDIDO,3)
			REPLACE FLGERR04 WITH 'N'
			REPLACE FECCRE04 WITH DATE()
			REPLACE HORCRE04 WITH TIME()
			REPLACE USUCRE04 WITH GOENTORNO.USER.LOGIN
			REPLACE FECMOD04 WITH DATE()
			REPLACE HORMOD04 WITH TIME()
			REPLACE USUMOD04 WITH GOENTORNO.USER.LOGIN
		ENDIF
		** Verificamos si tiene Incosistencias **
		LcFlgERR = ''
		SELECT consistencia
		SEEK migrados.ANPEDI04+migrados.NOPEDI04
		IF !FOUND()
			LcFlgERR = 'N'
		ELSE
			LcFlgERR = 'X'
		ENDIF
		SELECT migrados
		REPLACE FECMOD04 WITH DATE()
		REPLACE HORMOD04 WITH TIME()
		REPLACE USUMOD04 WITH GOENTORNO.USER.LOGIN
		REPLACE FLGERR04 WITH LcFlgERR
	ENDPROC


	*-- Reporte de consistencia de datos migrados al DOS.
	PROCEDURE int_consistencia_rpt
		PARAMETERS Pc_tipo
		IF PARAMETERS()=0
			pc_tipo = 'I'
		ENDIF
		LOCAL LsArea_Act,LsTabla
		DO CASE
			CASE pc_tipo = 'I'
				LsTabla = 'CONSISTENCIA'
			CASE pc_tipo = 'H'
				LsTabla = 'INT_CONSISTENCIA_H'
		ENDCASE
		LsArea_act =ALIAS()
		IF THIS.lacceso_consistencia
			IF THIS.lreporte_parcial
				IF THIS.cmodulo_dos ='DTE' OR THIS.ctabla_dos ='DTE'
					DO CASE
						CASE pc_tipo = 'I'
							IF EMPTY(THIS.PFDV) OR ISNULL(THIS.PFDV)
								*** SELECT * FROM (LsTabla) WHERE ;
									PFDV = THIS.ccodigoproducto + THIS.ccodigoFamilia + THIS.ccodigodesarrollo + THIS.cversioncodigodesarrollo ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,ID_ERROR
								SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
									FROM (LsTabla) a, errores b WHERE ;
									a.id_error = b.id_error and ;
									PFDV = THIS.ccodigoproducto + THIS.ccodigoFamilia + THIS.ccodigodesarrollo + THIS.cversioncodigodesarrollo ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,a.ID_ERROR
							ELSE
								*** SELECT * FROM (LsTabla) WHERE ;
									TAG2=THIS.PFDV ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,ID_ERROR

								SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
									FROM (LsTabla) a, errores b WHERE ;
									a.id_error = b.id_error and TAG2=THIS.PFDV ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,a.ID_ERROR
							ENDIF

						CASE pc_tipo = 'H'
							IF EMPTY(THIS.PFDV) OR ISNULL(THIS.PFDV)
								*** SELECT * FROM (LsTabla) WHERE ;
									PFDV = THIS.ccodigoproducto + THIS.ccodigoFamilia + THIS.ccodigodesarrollo + THIS.cversioncodigodesarrollo ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,ID_ERROR
								SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
									FROM (LsTabla) a, errores b WHERE ;
									a.id_error = b.id_error and ;
									PFDV = THIS.ccodigoproducto + THIS.ccodigoFamilia + THIS.ccodigodesarrollo + THIS.cversioncodigodesarrollo ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,a.ID_ERROR
							ELSE
								*** SELECT * FROM (LsTabla) WHERE ;
									TAG2=THIS.PFDV ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,ID_ERROR
								SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
									FROM (LsTabla) a, errores b WHERE ;
									a.id_error = b.id_error and TAG2=THIS.PFDV ;
									INTO CURSOR consistencia_rpt ;
									ORDER BY pfdv,a.ID_ERROR
							ENDIF
					ENDCASE
				ELSE
					IF EMPTY(THIS.cnumeropedidotdv) OR ISNULL(THIS.cnumeropedidotdv)
						IF !(EMPTY(THIS.pfdv) OR ISNULL(THIS.pfdv))
							*** SELECT * FROM (LsTabla) WHERE pfdv=THIS.pfdv INTO CURSOR consistencia_rpt ;
								ORDER BY pfdv,SUB,ID_ERROR
							SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
								FROM (LsTabla) a, errores b;
								WHERE a.id_error = b.id_error and;
									apfdv=THIS.pfdv INTO CURSOR consistencia_rpt ;
								ORDER BY pfdv,SUB,a.ID_ERROR
						ELSE
							*** SELECT * FROM (LsTabla) INTO CURSOR consistencia_rpt ;
								ORDER BY NUMPED,SUB,ID_ERROR
							SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
								FROM (LsTabla) a, errores b;
								where a.id_error = b.id_error;
								INTO CURSOR consistencia_rpt ;
								ORDER BY NUMPED,SUB,a.ID_ERROR
						ENDIF
					ELSE
						*** SELECT * FROM (LsTabla) WHERE Numped=THIS.cnumeropedidotdv INTO CURSOR consistencia_rpt ;
							ORDER BY NUMPED,SUB,ID_ERROR
						SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
							FROM (LsTabla) a, errores b;
							WHERE a.id_error = b.id_error and;
							Numped=THIS.cnumeropedidotdv INTO CURSOR consistencia_rpt ;
							ORDER BY NUMPED,SUB,a.ID_ERROR
					ENDIF
				ENDIF
			ELSE
				SELECT IIF(b.principal, 'Terminal', 'Advertencia') as Flag, a.*;
					FROM (LsTabla) a, errores b;
					where a.id_error = b.id_error;
					INTO CURSOR consistencia_rpt ;
					ORDER BY NUMPED,SUB,a.ID_ERROR
			ENDIF
			SELECT consistencia_rpt
			GO TOP
			IF EOF()
				DO CASE
					CASE pc_tipo = 'I'
						IF THIS.ShowMessage
							=MESSAGEBOX('NO SE HAN ENCONTRADO INCONSISTENCIAS','Interfaces sistemas nuevos => DOS')
						ENDIF
						RETURN .F.
					CASE Pc_tipo = 'H'
						IF THIS.ShowMessage
							=MESSAGEBOX('NO SE HA GENERADO HISTORIA DE INCONSISTENCIAS AUN','Interfaces sistemas nuevos => DOS')
						ENDIF
						RETURN .F.
				ENDCASE
			ENDIF

			IF .F.
				MODIFY REPORT clagen_int_consistencia.frx
			ENDIF

			IF !EMPTY(LsArea_Act)
				SELECT (LsArea_act)
			ENDIF
			RETURN .T.
		ENDIF
	ENDPROC


	*-- Abre las tablas de GPP
	PROCEDURE openfiles_gpp
		*/----------------
		**>>FUNCTION OpenFiles
		*/----------------
		PRIVATE xof

		xof = .T.
		xof = xof AND udfpuse("GisT04","GisT04","GisO0401")  && Pedidos transf.
		xof = xof AND udfpuse("GisT05","GisT05","GisO0501")  && Errores ¢ datos falt. por pedido
		xof = xof AND udfpuse("GPPM11","GPPM11","GPPO1101")
		xof = xof AND udfpuse("GPPM12","GPPM12","GPPO1201")
		xof = xof AND udfpuse("GPPM13","GPPM13","GPPO1301")
		xof = xof AND udfpuse("GPPM14","GPPM14","GPPO1401")
		xof = xof AND udfpuse("GPPM16","GPPM16","GPPO1601")
		xof = xof AND udfpuse("GPAT01","GPAT01","GPAO0101")  && Cabecera de Repos
		xof = xof AND udfpuse("GPAT02","GPAT02","GPAO0201")  && Detalle de Repos
		xof = xof AND udfpuse("GPPT01","GPPT01","GPPO0101")  && Tabla de Programadores
		xof = xof AND udfpuse("GPPT02","GPPT02","GPPO0201")  && Tabla de Estados de Programacion
		xof = xof AND udfpuse("GPPT09","GPPT09","GPPO0901")  && Tabla de Mensajes al usuario
		xof = xof AND udfpuse("Comdpoh","Comdpoh","POHA")
		xof = xof AND udfpuse("Comdcta","Comdcta","POHC")
		xof = xof AND udfpuse("Comdpem","Comdpem","Comdpemb")  && Fechas de embarque
		xof = xof AND udfpuse("Comdpoc","Comdpoc","Comdpoca")  && Etiquetas
		xof = xof AND udfpuse("Comdcli","Comdcli","Comdclia")  && Clientes
		xof = xof AND udfpuse("DtedTej","DtedTej","DtedTeja")  && Tipo de Tejidos
		xof = xof AND udfpuse("DtedTit","DtedTit","DtedTita")  && Titulos
		xof = xof AND udfpuse("DtedHil","DtedHil","DtedHila")  && Hilados
		xof = xof AND udfpuse("Tindcol","Tindcol","Tindcola")
		xof = xof AND udfpuse("Igpdpaa","Igpdpaa","PAAA")
		xof = xof AND udfpuse("Igpdart","Igpdart","Igpdarta")
		xof = xof AND udfpuse("Igpdpie","Igpdpie","Igpdpiea")
		xof = xof AND udfpuse("Igpdpcb","Igpdpcb","Igpdpcba")
		xof = xof AND udfpuse("Igpdtal","Igpdtal","Igpdtala")
		xof = xof AND udfpuse("Igpdtcb","Igpdtcb","Igpdtcba")
		xof = xof AND udfpuse("Igpdtaa","Igpdtaa","TAAA")
		xof = xof AND udfpuse("Cita02","Cita02","CITO0201")
		xof = xof AND udfpuse("Comm01","Comm01","COMO0101")
		xof = xof AND udfpuse("Comm02","Comm02","COMO0201")
		xof = xof AND udfpuse("Crf36","Crf36","Crl36A")
		xof = xof AND udfpuse("Crf35","Crf35","Crl35A")
		xof = xof AND udfpuse("Cindhif","Cindhif","Cindhifa")    
		xof = xof AND udfpuse("GpadSad","Gpadsad","SADB")
		xof = xof AND udfpuse("Gppw22","Gppw22")
		xof = xof AND udfpuse("Gppw23","Gppw23")
		xof = xof AND udfpuse("Gppw24","Gppw24")
		IF xof
		    SELECT Gpat02
		    SET RELATION TO CodPie02 INTO Igpdpie, CodTal02 INTO Igpdtal ADDITIVE
		ENDIF
		RETURN xof 
	ENDPROC


	*-- Rutina para abrir tablas ; utilizada para guardar compatibilidad con programas antiguos del DOS
	PROCEDURE udfpuse
		* UDFPUSE.PRG
		* Abre dbf (compartido) y captura mensajes de error
		* KS 28/11/94
		* ks 11/05/96
		parameters fnombre,falias,findices
		* abre archivos en forma compartida, en area 0
		* los alias deben ser £nicos por dbf --------------ojo
		* puede abrir el mismo archivo otra vez con otro alias
		* retorna .t. si  se abre satisfactoriamente, selecciona el alias indicado
		* Imprime mensaje de error
		private fuserr,xnpar    && ks 11/05/96
		* ks 11/05/96
		xnpar=parameters()
		if xnpar<3
		   findices=''
		endif
		if xnpar<2
		   falias=fnombre
		endif
		*******
		fuserr=.f.
		*!*	on error do puserr with upper(alltrim(fnombre))+".DBF  "
		if !used(falias)
		   select 0
		   use (fnombre) alias (falias) again shared
		else
		   select (falias)
		   *if alltrim(upper(fnombre))#alltrim(upper(dbf()))
		   *   do puserr with 'Alias: '+trim(falias)+' usado por '+dbf()+' '+fnombre
		   *endif
		   * no funciona porque dbf() retorna nombre y path completo
		   * se condiciona al programador que verifique alias £nico para cada dbf
		endif
		if !fuserr
		   if empty(findices)
		    * set index to      && ks 15/02/95
		      set order to      && ks 11/05/96
		   else
		     set index to (fnombre)
		     set order to tag &findices
		   endif
		endif
		*!*	on error
		return !fuserr
	ENDPROC


	PROCEDURE int_borra_consistencia
		LOCAL LsAreaAct
		LsAreaAct = ALIAS()

		SELECT consistencia
		IF this.lborrarconsistencia 
			IF this.lprocesoenbloque
				DELETE all for FHProceso <= this.dfhtransac_desde 
				this.lborrarconsistencia = .f.
			ELSE
				IF THIS.cmodulo_dos ='DTE' OR THIS.ctabla_dos ='DTE'
					** Guardamos inconsistencias en arreglo local
					SELECT * FROM CONSISTENCIA WHERE ;
					PFDV=THIS.CCODIGOPRODUCTO+THIS.CCODIGOFAMILIA+THIS.CCODIGODESARROLLO+THIS.cversioncodigodesarrollo ;
					AND TAG1=this.ctabla_en_proceso INTO ARRAY LaRegistro
					** Si existen inconsistencias las guardamos en archivo histórico para los sapos
					IF _TALLY>0
						INSERT INTO INT_CONSISTENCIA_H FROM ARRAY LaRegistro
					ENDIF
					** Borramos la porqueria
					DELETE FROM CONSISTENCIA WHERE ;
					PFDV=THIS.CCODIGOPRODUCTO+THIS.CCODIGOFAMILIA+THIS.CCODIGODESARROLLO+THIS.cversioncodigodesarrollo ;
					AND TAG1=this.ctabla_en_proceso 


				ELSE
					IF EMPTY(THIS.cnumeropedidotdv) or ISNULL(THIS.cnumeropedidotdv)  
						** Guardamos inconsistencias en arreglo local
						IF isnull(this.PFDV) or empty(this.PFDV)
							THIS.PFDV=THIS.CCODIGOPRODUCTO+THIS.CCODIGOFAMILIA+THIS.CCODIGODESARROLLO+THIS.cversioncodigodesarrollo 
						ENDIF
						SELECT * FROM CONSISTENCIA WHERE ;
						PFDV==THIS.PFDV INTO ARRAY LaRegistro
						** Si existen inconsistencias las guardamos en archivo histórico para los sapos
						IF _TALLY>0
							INSERT INTO INT_CONSISTENCIA_H FROM ARRAY LaRegistro
						ENDIF
						** Si no se ha especificado numero pedido se busca los registros que corresponden al
						** Producto , Familia , Desarrollo , Version de prenda
						IF !(EMPTY(this.pfdv) OR ISNULL(this.pfdv))
							DELETE FROM CONSISTENCIA WHERE PFDV==THIS.PFDV
						ENDIF
					ELSE
						** Guardamos inconsistencias en arreglo local
						SELECT * FROM CONSISTENCIA WHERE ;
						Numped = PADR(THIS.cnumeropedidotdv,6) INTO ARRAY LaRegistro 
						** Si existen inconsistencias las guardamos en archivo histórico para los sapos
						IF _TALLY>0
							INSERT INTO INT_CONSISTENCIA_H FROM ARRAY LaRegistro
						ENDIF
						** Borramos los roches anteriores
						SEEK PADR(THIS.cnumeropedidotdv,6)
						DELETE REST while Numped = PADR(THIS.cnumeropedidotdv,6)
					ENDIF
					this.lborrarconsistencia = .f.
				ENDIF
			ENDIF

		ENDIF
		IF !EMPTY(LsAreaAct)
			SELECT (LsAreaAct)
		ENDIF
	ENDPROC


	PROCEDURE chrtoarray
		*!*	FUNCTION ChrToArray
		PARAMETERS  cString, cDelim, aPut
		PRIVATE n
		DIMENSION aArray[1]
		cDelim  = IIF( TYPE("cDelim")="L", "," ,cDelim )
		cString = IIF( TYPE("cString")="L", "", cString )
		cString = cString + cDelim
		DO WHILE .T.
		  IF EMPTY( cString )
		     EXIT
		  ENDIF
		  n = AT( cDelim, cString )
		  IF n=1
		     nLen = ALEN( aArray )
		     DIMENSION aArray[nLen+1]
		     aArray[nLen+1] = ""
		  ELSE
		     nLen = ALEN( aArray )
		     DIMENSION aArray[nLen+1]
		     aArray[nLen+1] = LEFT( cString, n - 1 )
		  ENDIF
		  cString = RIGHT( cString, LEN(cString) - n )
		ENDDO
		IF ALEN(aArray)>1
		   =ADEL(aArray,1)
		   DIMENSION aArray[ ALEN(aArray)-1 ]
		   =ACOPY( aArray, aPut )
		ENDIF
		RETURN
	ENDPROC


	PROCEDURE netrlock
		*!*	FUNCTION NetRLock
		   PARAMETERS tnTime, cAlias
		   PRIVATE llNoError
		   WAIT WINDOW NOWAIT 'Intentando Bloquear Registro.....'
		   llNoError = .T.
		   IF PARAMETERS() = 2
		      lCondition = "!RLOCK(cAlias)"
		   ELSE
		      lCondition = "!RLOCK()"
		   ENDIF
		   IF PARAMETERS() < 1
		      tnTime = 0
		   ENDIF
		   SET REPROCESS TO tnTime
		   IF &lCondition
		      WAIT WINDOW 'No se puede bloquear el registro !' TIMEOUT 1
		      llNoError = .F.
		   ENDIF
		   WAIT CLEAR
		RETURN llNoError
	ENDPROC


	*-- Utilidad para ver un pedido en las tablas del com - dos
	PROCEDURE ver_pedido_com_dos


		SELECT 0
		USE comm01
		SET ORDER TO 1   && ANOPED01+NUMPED01+CODCOL01+PROCOL01+CODFAM01
		SELECT 0
		USE comm02
		SET ORDER TO 1   && FAMCON02+CODRAP02+COLLIS02+NOCOLR02+NOCOLH02
		SELECT comm01
		SET RELATION TO famcon01+codrap01+collis01 into comm02
		SELECT 0
		USE igpdpaa
		SET ORDER TO 1   && PAACARTI+PAACPIEZ
		SELECT 0

		USE comdcta
		SET ORDER TO 1   && ANHP+NOHP+SUB+CODCOL+CODTAL
		SELECT 0
		USE comdnta
		SET ORDER TO 1   && ANHP+NOHP+SUB+CODCOL
		SELECT 0
		USE comdpoh
		SET ORDER TO 1   && ANHP+NOHP
		SET RELATION TO anhp+nohp into comm01 additive
		SET RELATION TO Comdpoh.codart INTO Igpdpaa ADDITIVE
		SET RELATION TO Comdpoh.anhp + Comdpoh.nohp  INTO Comdnta ADDITIVE
		**SET RELATION TO Comdpoh.anhp+Comdpoh.nohp INTO Comdcta ADDITIVE
		SELECT comdnta
		SET RELATION TO ANHP+NOHP+SUB+CODCOL into comdcta additive
		SELECT comdpoh
		IF EMPTY(This.cnumeropedidotdv) or ISNULL(this.cnumeropedidotdv) 
		ELSE
			SEEK TRIM(This.cnumeropedidotdv)
		ENDIF

		BROWSE fields Anhp,NoHp,codart,clifa,temb,tempo,tidoc,parta,categ,cliart,userid,fecrea,fumod,feenv,hoenv,ferec,horec save nowait
		SELECT comdnta
		BROWSE last save nowait
		SELECT comdcta
		BROWSE last save nowait
		SELECT comm01
		BROWSE last save nowait
		SELECT comm02
		BROWSE last save nowait
		SELECT igpdpaa
		BROWSE last save nowait
	ENDPROC


	*-- Verifica si hay inconsistecia de tela , prenda , pedido o color parametros :                            _Tipo ->'TELAS' ,'PRENDA','PEDIDO','COLOR'                       _Tabla - > Nombre de tabla que se esta migrando.
	PROCEDURE si_hay_inconsistencia
		PARAMETERS _tipo
		IF PARAMETERS()=0
			RETURN .f.
		ENDIF
		IF PARAMETERS()=1
			_tabla = ''
		ENDIF
		LOCAL LnResult 
		LnResult = 0

		Local LcArea_Actual
		LcArea_actual = ALIAS()
		DO CASE 
			CASE UPPER(_Tipo) = 'TELA'
				SELECT * from CONSISTENCIA INNER JOIN ;
					ERRORES ON ERRORES.ID_ERROR = CONSISTENCIA.ID_ERROR ;
				WHERE TAG1=THIS.ctabla_en_proceso   ;
				AND PFDV = this.cCodigoProducto+this.cCodigoFamilia+THIS.cCodigoDesarrollo +THIS.cversioncodigodesarrollo ;
				AND ERRORES.PRINCIPAL ;
				INTO CURSOR XYZ_TMP
				LnResult = _TALLY

			CASE UPPER(_Tipo) = 'PRENDA'
				SELECT * from CONSISTENCIA INNER JOIN ;
				ERRORES ON ERRORES.ID_ERROR = CONSISTENCIA.ID_ERROR ;
				WHERE PFDV = this.cCodigoProducto+this.cCodigoFamilia+THIS.cCodigoDesarrollo +THIS.cversioncodigodesarrollo ;
				AND ERRORES.PRINCIPAL ;
				INTO CURSOR XYZ_TMP
				LnResult = _TALLY

			CASE UPPER(_Tipo) = 'PEDIDO'
				SELECT * from CONSISTENCIA INNER JOIN ;
				ERRORES ON ERRORES.ID_ERROR = CONSISTENCIA.ID_ERROR ;
				WHERE numped=this.cnumeropedidotdv ;
				AND ERRORES.PRINCIPAL ;
				INTO CURSOR  XYZ_TMP
				LnResult = _TALLY
		ENDCASE
		**
		IF USED('XYZ_TMP')
			USE IN XYZ_TMP
		ENDIF
		**
		IF !EMPTY(LcArea_actual)
			SELECT (LcArea_Actual)
		ENDIF

		RETURN LnResult >0 

	ENDPROC


	*-- Revisa si hay protos con el formato antiguo y avisa del cambio a nuevo formato en IGP
	PROCEDURE enviar_mail
		PARAMETERS _Tipo
		LOCAL LcSubJect,LcCuerpo
		STORE '' to LcSubJect,LcCuerpo,LcCodigoTransaccion
		IF ISNULL(this.cnumeropedidotdv )
			this.cnumeropedidotdv = ''
		ENDIF
		DO CASE
			CASE _Tipo = '1'		&& Mail por el cambio de formato
				LcCodigoTransaccion='0700'
				IF !THIS.ABRIR_tablas_mail()
					THIS.cierra_tablas_mail()
					RETURN
				ENDIF
				IF EMPTY(THIS.PFDV) OR ISNULL(THIS.PFDV)
					THIS.PFDV = THIS.ccodigoproducto+THIS.ccodigofamilia+THIS.CCODIGODESARROLLO+THIS.cversioncodigodesarrollo
				ENDIF
				SELECT TOP 1 PFDV FROM INT_CONSISTENCIA_H WHERE PFDV=THIS.PFDV AND ENVIO_MAIL AND TIPO='2'	ORDER BY PFDV into cursor zzz_tmp
				lYa_envio_mail = (_tally>0) 
				use in zzz_tmp
				IF !((this.lenviarmailsiempre and lYa_envio_Mail) or !lYa_envio_mail)
					THIS.cierra_tablas_mail()
					return
				ENDIF
				**IF (ASC(RIGHT(TRIM(_codart),1)) >=65 and ASC(RIGHT(TRIM(_codart),1)) <= 90) or (ASC(RIGHT(TRIM(_codart),1)) >=97 and ASC(RIGHT(TRIM(_codart),1)) <= 122)
				 
				IF this.chk_version_anterior() 

					IF EMPTY(this.cnumeropedidoTdv) or ISNULL(this.cnumeropedidoTdv)
						LcSubJect=THIS.ccodigoproducto+THIS.ccodigofamilia+THIS.CCODIGODESARROLLO+'-'+THIS.cversioncodigodesarrollo 
					ELSE
						LcSubJect=THIS.ccodigoproducto+THIS.ccodigofamilia+THIS.CCODIGODESARROLLO+'-'+THIS.cversioncodigodesarrollo+' '+this.cNumeropedidoTdv
					ENDIF

					goEntorno.conexion.cSQL	=	"select * from MtransaccionesxUsuario WHERE CodigoTransaccion = ?LcCodigoTransaccion and FlagEliminado = 0"
					goEntorno.conexion.Ccursor = 'C_Cuerpo_Mail'
					x = goEntorno.conexion.doSQL()
					if x < 0
						THIS.cierra_tablas_mail()
						RETURN 
					ENDIF
					LcCuerpo = C_Cuerpo_Mail.CCopia
					use in C_Cuerpo_Mail
					IF ISNULL(LcSubJect)
						LcSubJect= ''
					ENDIF
					this.Envia('0700',LcSubJect,LcCuerpo)

					INSERT INTO INT_CONSISTENCIA_H (Numped,sub,PFDV,detalle,verificar,tipo,envio_mail) values ;
													(This.cnumeropedidotdv, ;
													'', ;
													this.pfdv , ;
													LcSubJect, ;
													'', ;
													'2', ;
													.T. )
				ENDIF
				**ENDIF
				THIS.cierra_tablas_mail()
			CASE _Tipo = '2'
				LcCodigoTransaccion='0701'
		ENDCASE
	ENDPROC


	PROCEDURE envia

		LPARAMETER tcCodigoTransaccion , tcSubject , tcCuerpo , tcCodigoCliente 

		IF VARTYPE(tcCodigoCliente) <> 'C'
			tcCodigoCliente = ''
		ENDIF

		IF EMPTY(tcSubject) OR ISNULL(tcSubject)
			tcSubject	= ""
		ENDIF

		IF EMPTY(tcCuerpo) OR ISNULL(tcCuerpo)
			tcCuerpo	= ""
		ENDIF

		LOCAL lnControl , lcAlias , lcDescripcionTransaccion , lcLineaComando , lcUsuario
		LOCAL lcFileLista1 , lcFileLista2 , lcLista1 , lcLista2
		m.CodigoTransaccion	= tcCodigoTransaccion
		m.CodigoCliente		= tcCodigoCliente

		lcUsuario	= UPPER(ALLTRIM(goEntorno.User.Login))

		**WITH THIS
			lcAlias	= ALIAS()

			goEntorno.conexion.cSQL		= "EXEC ADMGEN1_Transacciones " + ;
				"@CodigoTransaccion = ?m.CodigoTransaccion ," +;
				"@CodigoCliente = ?m.CodigoCliente , " + ;
				"@TipoAccion = 'C8'"

			goEntorno.conexion.cCursor	= "MailAviso"
			lnControl = goEntorno.conexion.doSQL()
			IF lnControl < 0
				IF !EMPTY(lcAlias)
					SELECT(lcAlias)
				ENDIF
				RETURN
			ENDIF
			SELECT MailAviso
			REPLACE ALL EMailTo WITH STRTRAN(EMailTo,CHR(13)+CHR(10),",") , EMailCC WITH STRTRAN(EMailCC,CHR(13)+CHR(10),",")
			REPLACE ALL EMailTo WITH STRTRAN(EMailTo,CHR(13),",") , EMailCC WITH STRTRAN(EMailCC,CHR(13),",")
			GO TOP
			m.EMailTo = ""
			m.EMailCC = ""
			SCAN
				lcDescripcionTransaccion	= ALLTRIM(DescripcionTransaccion)
				m.EMailTo	=	m.EMailTo + IIF(EMPTY(EMailTo) , "" , ALLTRIM(EMailTo) + "," )
				m.EMailCC	=	m.EMailCC + IIF(EMPTY(EMailCC) , "" , ALLTRIM(EMailCC) + "," )
			ENDSCAN
			IF RIGHT(m.EMailTo,1)==","
				m.EMailTo	=	LEFT(m.EMailTo,LEN(m.EMailTo)-1)
			ENDIF
			IF RIGHT(m.EMailCC,1)==","
				m.EMailCC	=	LEFT(m.EMailCC,LEN(m.EMailCC)-1)
			ENDIF

			lcDescripcionTransaccion	= '"' + lcDescripcionTransaccion + tcSubject +'"'
			lcArchivoTmp	= ADDBS(GETENV("TEMP")) + SYS(2015) + ".TMP"
			lcFileLista1	=  ADDBS(GETENV("TEMP")) + "LST" + SYS(2015) + ".LST"
			lcFileLista2	= ADDBS(GETENV("TEMP")) + "LST" + SYS(2015) + ".LST"

			#DEFINE _ENTER	CHR(13) + CHR(10)

			lcLista1		= "\TITLE TmpPedido" + _ENTER + "\READING N"  + _ENTER + "\URGENT Y" + _ENTER + "\NOSIG Y" + _ENTER + STRTRAN(m.EMailTo,",",_ENTER)
			lcLista2		= "\TITLE TmpPedido" + _ENTER + "\READING N"  + _ENTER + "\URGENT Y" + _ENTER + "\NOSIG Y" + _ENTER + STRTRAN(m.EMailCC,",",_ENTER)

			*!*	Crea los archivos que procesara el Pegasus para enviar los mail.
			*!*	Ojo, no se borran porque como la ejecucion es Asíncrona, si borras despues de la ejecución
			*!*	lo mas seguro es que el pegasus no ejecute correctamente.
			=STRTOFILE(tcCuerpo,lcArchivoTmp)
			=STRTOFILE(m.lcLista1,lcFileLista1)
			=STRTOFILE(m.lcLista2,lcFileLista2)

			lcLineaComando	= ""
			DO CASE
			CASE !EMPTY(m.EMailTo) and empty(m.EMailCC)
				lcLineaComando	= "RUN /n P:\winpm-32.exe -T @" + m.lcFileLista1 + " -S " + lcDescripcionTransaccion + " -F " + lcArchivoTmp + " -I " + lcUsuario
			CASE !EMPTY(m.EMailTo) and !empty(m.EMailCC)
				lcLineaComando	= "RUN /n P:\winpm-32.exe -T @" + m.lcFileLista1 + " -c @" + m.lcFileLista2 + " -S " + lcDescripcionTransaccion + " -F " + lcArchivoTmp + " -I " + lcUsuario
			CASE EMPTY(m.EMailTo) and !empty(m.EMailCC)
				lcLineaComando	= "RUN /n P:\winpm-32.exe -c @" + m.lcFileLista2 + " -S " + lcDescripcionTransaccion + " -F " + lcArchivoTmp + " -I " + lcUsuario
			ENDCASE
			IF !EMPTY(lcLineaComando)
				&lcLineaComando
			ENDIF
		**ENDWITH
	ENDPROC


	PROCEDURE cierra_tablas_mail
		THIS.cierra_tabla('T_MAIL1')
		THIS.cierra_tabla('T_MAIL2')
		THIS.cierra_tabla('T_MAIL3')
		THIS.cierra_tabla('T_MAIL4')
		THIS.cierra_tabla('T_MAIL5')
		THIS.cierra_tabla('T_MAIL6')
		THIS.cierra_tabla('T_MAIL7')
		THIS.cierra_tabla('T_MAIL8')
		THIS.cierra_tabla('T_MAIL9')
		THIS.cierra_tabla('T_MAIL10')
		THIS.cierra_tabla('T_MAIL11')
		THIS.cierra_tabla('T_MAIL12')
		THIS.cierra_tabla('T_MAIL13')
	ENDPROC


	PROCEDURE abrir_tablas_mail
			SELECT 0 
			USE IGPDART ORDER IGPA AGAIN ALIAS T_MAIL1
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla IGPDART','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE IGPDPAA ORDER PAAA AGAIN ALIAS T_MAIL2
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla IGPDPAA','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE igpdTXA ORDER IGPDTXAA AGAIN ALIAS T_MAIL3
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla igpdTXA','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE igpdMXA ORDER IGPDMXAA AGAIN ALIAS T_MAIL4
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla igpdMXA','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE igpdPXA ORDER IGPDPXAA AGAIN ALIAS T_MAIL5
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla igpdPXA','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE igpM02 ORDER IGPO0201 AGAIN ALIAS T_MAIL6
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla igpM02','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE igpM03 ORDER IGPO0301 AGAIN ALIAS T_MAIL7
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla igpM03','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
			SELECT 0 
			USE COMDPOH ORDER COMDPOHC AGAIN ALIAS T_MAIL8
			IF !USED()
				IF THIS.ShowMessage
					=MESSAGEBOX('No hay acceso a tabla COMDPOH','Notificacion por mail de F.A.')
				ENDIF
				RETURN .F.
			ENDIF
		RETURN .T.
	ENDPROC


	PROCEDURE chk_version_anterior
		IF EMPTY(THIS.PFDV) or isnull(THIS.PFDV)
			RETURN .F.
		ENDIF
		LsCodArt_Ant = 'P'+SUBSTR(THIS.PFDV,4,5)
		LOCAL L1,L2,L3,L4,L5,L6,L7,L8,K1,K2,K3,K4,K5,K6,K7,K8
		L1=SEEK(LsCodArt_Ant,'T_MAIL1') AND T_MAIL1.BCODIGOART==LsCodArt_Ant
		L2=SEEK(LsCodArt_Ant,'T_MAIL2')	AND T_MAIL2.PAACARTI==LsCodArt_Ant
		L3=SEEK(LsCodArt_Ant,'T_MAIL3') AND T_MAIL3.BCODIGOART==LsCodArt_Ant
		L4=SEEK(LsCodArt_Ant,'T_MAIL4') AND T_MAIL4.BCODIGOART==LsCodArt_Ant
		L5=SEEK(LsCodArt_Ant,'T_MAIL5') AND T_MAIL5.PXACARTI==LsCodArt_Ant
		L6=SEEK(LsCodArt_Ant,'T_MAIL6') AND T_MAIL6.CODART02==LsCodArt_Ant
		L7=SEEK(LsCodArt_Ant,'T_MAIL7') AND T_MAIL7.CODART03==LsCodArt_Ant
		L8=SEEK(LsCodArt_Ant,'T_MAIL8') AND T_MAIL8.CODART==LsCodArt_Ant
		IF !(L1 OR L2 OR L3 OR L4 OR L5 OR L6 OR L7 OR L8)
			RETURN .F.
		ENDIF

		LsCodArt_ACT = SUBSTR(THIS.PFDV,4,5)+THIS.version_a_letra(SUBSTR(THIS.PFDV,9)) 
		K1=SEEK(LsCodArt_ACT,'T_MAIL1') AND T_MAIL1.BCODIGOART==LsCodArt_ACT
		K2=SEEK(LsCodArt_ACT,'T_MAIL2')	AND T_MAIL2.PAACARTI==LsCodArt_ACT
		K3=SEEK(LsCodArt_ACT,'T_MAIL3')	AND T_MAIL3.BCODIGOART==LsCodArt_ACT
		K4=SEEK(LsCodArt_ACT,'T_MAIL4') AND T_MAIL4.BCODIGOART==LsCodArt_ACT
		K5=SEEK(LsCodArt_ACT,'T_MAIL5') AND T_MAIL5.PXACARTI==LsCodArt_ACT
		K6=SEEK(LsCodArt_ACT,'T_MAIL6') AND T_MAIL6.CODART02==LsCodArt_ACT
		K7=SEEK(LsCodArt_ACT,'T_MAIL7') AND T_MAIL7.CODART03==LsCodArt_ACT
		K8=SEEK(LsCodArt_ACT,'T_MAIL8') AND T_MAIL8.CODART==LsCodArt_ACT
		RETURN !(K1 AND K2 AND K3 AND K4 AND K5 AND K6 AND K7 AND K8)
		**RETURN (L1 AND K1 AND L2 AND K2 AND L3 AND K3 AND L4 AND K4 AND L5 AND K5 AND L6 AND K6 AND L7 AND K7 AND L8 AND K8)
	ENDPROC


	PROCEDURE grb_item_error
		*!*	PARAMETERS m.Pedido,m.Des_Err,m.Campo_Dos,m.Campo_DDP
		*!*	SELECT MAX(item) as Item from (this.TmpFileErr) into cursor xy_tmp
		*!*	m.Item = xy_tmp.Item + 1
		*!*	use in xy_tmp
		IF this.numele_aerr_sql_dos >0
			DIMENSION this.aerr_sql_dos[this.numele_aerr_sql_dos,7]
			INSERT into (this.TmpFileErr) from array   this.aerr_sql_dos  
			this.numele_aerr_sql_dos = 0
		ENDIF

		return
	ENDPROC


	PROCEDURE int_sql_vs_dos
		LOCAL LsArea_Act,LOK

		IF !USED('COMM01')
			SELECT 0
			USE comm01
			SET ORDER TO 1   && ANOPED01+NUMPED01+CODCOL01+PROCOL01+CODFAM01
		ENDIF
		*
		IF !USED('COMM02')
			SELECT 0
			USE comm02
			SET ORDER TO 1   && FAMCON02+CODRAP02+COLLIS02+NOCOLR02+NOCOLH02
			SELECT comm01
			SET RELATION TO famcon01+codrap01+collis01 into comm02
		ENDIF
		*
		IF !USED('IGPDPAA')
			SELECT 0
			USE igpdpaa
			SET ORDER TO 1   && PAACARTI+PAACPIEZ
		ENDIF
		*
		IF !USED('COMDCTA')
			SELECT 0
			USE COMDCTA
			SET ORDER TO 1   && ANHP+NOHP+SUB+CODCOL+CODTAL
		ENDIF
		*
		IF !USED('COMDNTA')
			SELECT 0
			USE comdnta
			SET ORDER TO 1   && ANHP+NOHP+SUB+CODCOL
			SET RELATION TO ANHP+NOHP+SUB+CODCOL into comdcta additive
		ENDIF
		*
		IF !USED('COMDPOH')
			SELECT 0
			USE COMDPOH
			SET ORDER TO 1   && ANHP+NOHP
			SET RELATION TO anhp+nohp into comm01 additive
			SET RELATION TO Comdpoh.codart INTO Igpdpaa ADDITIVE
			SET RELATION TO Comdpoh.anhp + Comdpoh.nohp  INTO Comdnta ADDITIVE
		ENDIF
		*
		IF !USED('COMDTAA')
			SELECT 0
			USE COMDTAA ORDER COMDTAAA ALIAS COMDTAA
			IF !USED()
				WAIT WINDOW 'NO SE PUEDE ABRIR TABLA COMDTAA'
				RETURN
			ENDIF
		ENDIF
		*
		IF !USED('TALLAS')
			SELE 0
			USE IGPDCODE ORDER igpocode02 ALIAS TALLAS
			IF !USED()
				WAIT WINDOW 'NO SE PUEDE ABRIR TABLA IGPDCODE'
				RETURN
			ENDIF
		ENDIF

		*
		IF USED('COMECLI')
		ELSE
			SELECT 0
			USE COMECLI ORDER COMCLIIH ALIAS comecli 
			IF !USED()
				WAIT WINDOW 'NO SE PUEDE ABRIR TABLA DE EQUIVALENCIAS COMECLI'
				RETURN
			ENDIF
		ENDIF
		*

		WAIT window 'Evaluando en rango de busqueda...' nowait
		pfecha  = this.dfhtransac_desde 
		pFecha2 = this.dfhtransac_hasta 
		pNumped = this.cNumeroPedidoTdv 
		pNumPedH= this.cnumeropedidotdvh
		IF !((EMPTY(pNumPed) or ISNULL(pNumPed)) OR (EMPTY(pNumPedH) or ISNULL(pNumPedH)))
			** Obtenemos pedidos de un rango de fechas **
			LcSql = "Exec IntCOM_COMDPOH @pNumeroPedidoTdv=?pNumped,@pNumeroPedidoTdvH=?pNumpedH"
		ELSE
			** Obtenemos pedidos de un rango de fechas **
			LcSql = "Exec IntCOM_COMDPOH @pFHModificacion=?pFecha,@pFHMOdificacionH=?pFecha2"
		ENDIF

		goEntorno.conexion.cSQL = LcSql
		goEntorno.conexion.Ccursor = "PedidosSql"
		LnResult = goEntorno.conexion.doSQL()

		IF LnResult <=0
			IF THIS.ShowMessage
				=MESSAGEBOX('No hay pedidos modificados en el rango de fechas','Aviso')
			ENDIF
			RETURN 
		ENDIF
		WAIT window '.' nowait

		this.TmpFileErr = goentorno.tmppath+SYS(3) 
		SELECT 0
		CREATE TABLE (this.TmpFileErr) free (item n(4),pedido c(6),campo_DOS C(20),campo_DDP c(20),des_ERR C(30),sub c(2),pfdv c(10) )
		USE
		use (this.TmpFileErr) ALIAS diferencias
		INDEX ON pedido+STR(item,4,0) tag pk1
		SET ORDER TO PK1


		LsWhile = '.T.'
		LsFor 	= '.T.'
		IF !EMPTY(THIS.cTipoPedido)
			LsFor = LsFor + ' AND ' + 'ELEMENTOTIPOPEDIDO =This.cTipoPedido'
		ENDIF
		IF !EMPTY(THIS.cEstadoPedido)
			LsFor = LsFor + ' AND ' + 'ELEMENTOESTADO =This.cEstadoPedido'
		ENDIF

		SELECT PedidosSql
		SCAN for eval(LsFor)
			LsNumeroPedido=PedidosSql.anhp+PedidosSql.nohp
			this.pfdv = PedidosSql.Pfdv
			WAIT window "Procesando pedido:"+LsNumeroPedido nowait
			m.Clifa = PedidosSql.Clifa
			IF SEEK(m.CliFa,"ComeCli")
				m.CliFa	= ComeCli.ComCliNV
			ENDIF

			SELECT comdpoh
			IF SEEK(LsNumeroPedido,'COMDPOH') AND PedidosSql.anhp+PedidosSql.nohp==LsNumeroPedido
				THIS.evalua_condicion= (COMDPOH.CodArt == PedidosSql.CodArt)
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) = LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) = COMDPOH.CodArt	  
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) = PedidosSql.CodArt
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5) = 'Codigo de articulo' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				THIS.evalua_condicion= (COMDPOH.clifa == m.Clifa)
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) = LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) = COMDPOH.Clifa
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) = m.Clifa
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5) = 'Codigo de Cliente' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				THIS.evalua_condicion= (TRIM(COMDPOH.PARTA) == TRIM(PedidosSql.PARTA))
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) = LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) = COMDPOH.PARTA
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) = PedidosSql.PARTA
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5) = 'Partida arancelaria' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				THIS.evalua_condicion= (TRIM(COMDPOH.CATEG) == TRIM(PedidosSql.CATEG))
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) = LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) = COMDPOH.CATEG
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) = PedidosSql.CATEG
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5) = 'Categoria' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				THIS.evalua_condicion= (TRIM(COMDPOH.TEMB) == TRIM(PedidosSql.TEMB))
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) = LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) = COMDPOH.TEMB
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) = PedidosSql.TEMB
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5) = 'Tipo de embarque' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				THIS.evalua_condicion= (TRIM(COMDPOH.TEMPO) == TRIM(PedidosSql.TEMPO))
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) 	= LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) 	= COMDPOH.TEMPO
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) 	= PedidosSql.TEMPO
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5)	= 'Temporada' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				=SEEK(PedidosSql.CodArt,'COMDTAA')
				THIS.evalua_condicion= (TRIM(COMDTAA.DINGLES) == TRIM(PedidosSql.DINGLES))
				IF .NOT. THIS.evalua_condicion
					this.aerr_sql_dos(this.numele_aerr_sql_dos,2) = LsNumeroPedido
					this.aerr_sql_dos(this.numele_aerr_sql_dos,3) = COMDTAA.DINGLES
					this.aerr_sql_dos(this.numele_aerr_sql_dos,4) = PedidosSql.DINGLES
					this.aerr_sql_dos(this.numele_aerr_sql_dos,5) = 'Descripción Ingles' 
					this.aerr_sql_dos(this.numele_aerr_sql_dos,6) = ''
				ENDIF

				** Tallas y Colores ** 	Hay que hacer cada cojudez
				this.cNumeropedidoTdv = LsNumeroPedido
				this.int_chk_comdcta()
				 
				** ---------------- **

				this.grb_item_error 

			ENDIF
			SELECT PedidosSql
		ENDSCAN
		*
		IF USED('DIFERENCIAS')
			SELECT DIFERENCIAS
			GO TOP
			IF !EOF()
				LsNumPedxxx=pedido
				REPLACE pedido WITH LsNumPedxxx
				lOK = .T.
			ELSE
				lOK = .F.
				this.TmpFileErr = ''
				IF USED('DIFERENCIAS')
					USE IN DIFERENCIAS
				ENDIF
				IF THIS.ShowMessage
					=MESSAGEBOX('No existen diferencias entre DDP y FT - COM')
				ENDIF
			ENDIF
		ENDIF
		SELECT PedidosSql
		RETURN LOK
	ENDPROC


	PROCEDURE evalua_condicion_access
		*To do: Modify this routine for the Access method
		IF NOT THIS.evalua_condicion
			THIS.numele_aerr_sql_dos = THIS.numele_aerr_sql_dos + 1
			this.aerr_sql_dos(this.numele_aerr_sql_dos,1) = THIS.numele_aerr_sql_dos
			this.aerr_sql_dos(this.numele_aerr_sql_dos,7) = THIS.PFDV
		ENDIF
		RETURN THIS.evalua_condicion
	ENDPROC


	PROCEDURE aerr_sql_dos_assign
		LPARAMETERS vNewVal, m.nIndex1, m.nIndex2
		*To do: Modify this routine for the Assign method
		IF ALEN(THIS.aerr_sql_dos,1)< THIS.numele_aerr_sql_dos
			DIMENSION THIS.aerr_sql_dos[THIS.numele_aerr_sql_dos+5,7] 
		ENDIF
		IF ISNULL(m.nIndex1)  && user didn't pass in a subscript
			THIS.aerr_sql_dos = m.vNewVal
		ELSE
			THIS.aerr_sql_dos[m.nIndex1, m.nIndex2] = m.vNewVal
		ENDIF
	ENDPROC


	PROCEDURE dfhtransac_desde_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		LsFecha = IIF(VARTYPE(vNewVal)='D',DTOS(vNewVal),IIF(VARTYPE(vNewVal)='T',TTOC(vNewVal,1),''))
		THIS.cAno		= SUBSTR(LsFecha,1,4)
		THIS.cNroMes	= SUBSTR(LsFecha,5,2)
		DO CASE
			CASE goEntorno.Conexion.cDateFormat == "DMY"
				vNewVal	= DTOC(vNewVal)+ " 00:00:00"
			CASE goEntorno.Conexion.cDateFormat == "MDY"
				vNewVal	= MDY(vNewVal)+ " 00:00:00"
			OTHERWISE
				vNewVal	= DTOC(vNewVal)+ " 00:00:00"
				*lxInicio	= STR(YEAR(fecha1),4)+"/"+TRANSFORM(MONTH(fecha1),"@jl 99")+"/"+TRANSFORM(DAY(fecha1),"@JL 99") + " 00:00:00"
		ENDCASE

		THIS.dfhtransac_desde = m.vNewVal
	ENDPROC


	PROCEDURE dfhtransac_hasta_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		LsFecha = IIF(VARTYPE(vNewVal)='D',DTOS(vNewVal),IIF(VARTYPE(vNewVal)='T',TTOC(vNewVal,1),''))
		THIS.cAno2 		= SUBSTR(LsFecha,1,4)
		THIS.cNroMes2 	= SUBSTR(LsFecha,5,2)

		DO CASE
			CASE goEntorno.Conexion.cDateFormat == "DMY"
				vNewVal		= DTOC(vNewVal) + " 23:59:59"
			CASE goEntorno.Conexion.cDateFormat == "MDY"
				vNewVal		= MDY(vNewVal) + " 23:59:59"
			OTHERWISE
				vNewVal		= DTOC(vNewVal) + " 23:59:59"
				*lxFin		= STR(YEAR(fecha2),4)+"/"+TRANSFORM(MONTH(fecha2),"@jl 99")+"/"+TRANSFORM(DAY(fecha2),"@JL 99") + " 00:00:00"
		ENDCASE

		THIS.dfhtransac_hasta = m.vNewVal
	ENDPROC


	PROCEDURE validartabla
		LPARAMETER tcMetodo

		*!*	-------------------------------------------------------------
		*!*	Giuliano Gonzales Zeballos (Roche de Scanner) 14/02/2002
		*!*	Día de los Enamorados y me tiene chambeando como cojudo hasta las 00:00 Horas
		*!*	que ch.... hay que arreglar los roches que Alfredito se pajeo y que increiblemente
		*!*	se imagino que funcionaría.
		*!*	-------------------------------------------------------------
		xTabla	= UPPER(ALLTRIM(STRTRAN(SUBSTR(tcMetodo,AT("_",tcMetodo)+1),"()","")))
		xTablas	= IIF(ISNULL(THIS.Tablas) OR EMPTY(THIS.Tablas) , "" , ALLTRIM(UPPER(THIS.Tablas)) )

		IF EMPTY(xTablas)	&& No hay Nada que Validar
			RETURN .f.
		ENDIF

		RETURN xTabla $ xTablas
	ENDPROC


	*-- Verifica si el pedido/desarrollo se ha migrado correctamente
	PROCEDURE int_se_migro_ok
		PARAMETERS _Pedido
		LOCAL LsArea_actual,LsMensaje
		IF !this.lacceso_migrados
			RETURN
		ENDIF
		IF ISNULL(_Pedido) OR EMPTY(_Pedido)
			RETURN
		ENDIF
		LsArea_Actual = ALIAS()
		LsMensaje =  ''
		SELECT migrados
		SEEK _Pedido
		IF !FOUND()
			LsMensaje='No se ha realizado interface al COM todavia'
			This.cEstadoMigracion = SPACE(1)
		ELSE
			DO CASE 
				CASE FLGERR04='N'
					LsMensaje='Interface a COM - FT OK, '+'Usuario:'+UsuMod04+' Fecha:'+DTOC(FecMod04)+' '+HorMod04
				CASE FLGERR04='X'
					LsMensaje='Interface a COM - FT con inconsintencias'
				CASE FLGERR04='S' 
					LsMensaje='Pedido presenta errores en GPP'
			ENDCASE
			This.cEstadoMigracion = FLGERR04
		ENDIF


		IF !EMPTY(LsArea_Actual)
			SELECT (LsArea_Actual)
		ENDIF
		RETURN LsMensaje
	ENDPROC


	*-- Ejecuta la migracion de las entidades correspondientes a los modulos seleccionados
	PROCEDURE procesar2


		LOCAL LDFHTRANSAC,   NENVIOS


		** Tabla Maestra de Items Migrados - 23/03/2001 VETT ***
		** OJO Solo se migraran transacciones de los items registrados en esta Tabla

		IF THIS.LACCESO_CONSISTENCIA
			THIS.INT_BORRA_CONSISTENCIA
		ENDIF
		*** Controlamos si se procesa un modulo y/o una tabla , o todo
		LOCAL LSFORMODULO,LSFORTABLA
		DO CASE
		CASE EMPTY(THIS.CMODULO_DOS) AND EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = '.T.'
			LSFORTABLA  = '.T.'
		CASE !EMPTY(THIS.CMODULO_DOS) AND EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = 'UPPER(Modulos.Codigo) = TRIM(UPPER(THIS.cmodulo_dos))'
			LSFORTABLA  = '.T.'
		CASE EMPTY(THIS.CMODULO_DOS) AND !EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = '.T.'
			LSFORTABLA  = 'UPPER(TablasModulo.DESC_TABLA) = TRIM(UPPER(THIS.ctabla_dos))'
		CASE !EMPTY(THIS.CMODULO_DOS) AND !EMPTY(THIS.CTABLA_DOS)
			LSFORMODULO = 'UPPER(Modulos.Codigo) = TRIM(UPPER(THIS.cmodulo_dos))'
			LSFORTABLA  = 'UPPER(TablasModulo.DESC_TABLA) = TRIM(UPPER(THIS.ctabla_dos))'

		ENDCASE

		*!*	SET STEP ON 
		*** Actualizamos tablas maestras ***
		SELECT TABLASMODULO
		SCAN FOR PRIORIDAD AND  THIS.LTABLASPRINCIPALES	AND EVALUATE(LSFORMODULO)
			PROG1=PREFIJO+ALLTRIM(DESC_TABLA)+".prg"
			PROG2=PREFIJO+ALLTRIM(DESC_TABLA)+'()'
			THIS.CPROGRAMA_CARGA= UPPER(PREFIJO+ALLTRIM(DESC_TABLA))
			THIS.CTABLA_EN_PROCESO = UPPER(ALLTRIM(DESC_TABLA))
			THIS.Tipo_Arch		= TABLASMODULO.Tipo_Arch
			THIS.Ruta_Arch		= TABLASMODULO.Ruta_Arch
			THIS.Model_Arch	= Tablasmodulo.Model_Arch
			THIS.Hoja_Xls 		= Tablasmodulo.Hoja_Xls
			THIS.Arch_Xls 		= Tablasmodulo.Arch_Xls
			IF !EMPTY(DESC_TABLA)
				THIS.CAVISO2 = "Ejecutando:"+PROG1
				IF THIS.LACCESO_CONSISTENCIA
					THIS.INT_BORRA_CONSISTENCIA
				ENDIF
				IF 	Tiene_det

				ELSE
					IF THIS.LPROCESOENBLOQUE
						**			this.dfhtransac_desde=tablasmodulo.fh_transac
						THIS.G_AREACOUNT = 20
						THIS.CLEARAREAS
						**			DO (PROG1)
						THIS.&PROG2
					ELSE
						THIS.&PROG2
					ENDIF
				ENDIF
				THIS.CAVISO1 = "Programa anterior:"+PROG1
				THIS.CAVISO2 = ""
			ENDIF
			SELECT TABLASMODULO
			REPLACE FH_TRANSAC WITH DATETIME()
		ENDSCAN
		IF THIS.LSOLOTABLASPRINCIPALES
			RETURN
		ENDIF

		*** Actualizamos Tablas Seleccionadas
		NENVIOS = 0
		SELE MODULOS
		SCAN FOR PROCESAR AND UPPER(TRIM(U_NEGOCIO))=UPPER(TRIM(THIS.CUNIDADNEGOCIO)) AND EVALUATE(LSFORMODULO)
			SELECT TABLASMODULO
			SCAN FOR COD_MOD_D=MODULOS.CODIGO AND SELEC AND NOT PRIORIDAD  AND EVALUATE(LSFORTABLA) AND EMPTY(Detalle)

				PROG1=PREFIJO+ALLTRIM(DESC_TABLA)+".prg"
				PROG2=PREFIJO+ALLTRIM(DESC_TABLA)+'()'
				THIS.CPROGRAMA_CARGA= UPPER(PREFIJO+ALLTRIM(DESC_TABLA))
				THIS.CTABLA_EN_PROCESO = UPPER(ALLTRIM(DESC_TABLA))
				THIS.Tipo_arch =	TABLASMODULO.Tipo_Arch
				THIS.Ruta_arch =	TABLASMODULO.Ruta_Arch
				THIS.Model_Arch	= Tablasmodulo.Model_Arch
				THIS.Hoja_Xls 		= Tablasmodulo.Hoja_Xls
				THIS.Arch_Xls 		= Tablasmodulo.Arch_Xls
				THIS.Do_SqlExec 	= Tablasmodulo.Do_SqlExec
				THIS.CadenaSql 	=  Tablasmodulo.CadenaSql
				THIS.CadenaSql2 	=  Tablasmodulo.CadenaSql2
				IF 	!Tiene_det
					** Limpiamos tabla modelo ** 
					IF USED(THIS.CTABLA_EN_PROCESO)
						USE IN (THIS.CTABLA_EN_PROCESO)
					ENDIF
					LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
					SELECT 0
					USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO) EXCL
					thisformset.procesoInterfaces.TxtAviso1.Value    = "Borrando datos anterior proceso en : "+DBF()
					ZAP
					thisformset.procesoInterfaces.TxtAviso1.Value    = ""
					SELECT TABLASMODULO
				ENDIF

				IF VARTYPE(ENVIAMAIL1)='L'
					IF ENVIAMAIL1 OR ENVIAMAIL2 OR ENVIAMAIL3 OR ENVIAMAIL4
						NENVIOS = NENVIOS + 1
						IF ALEN(THIS.AENVIOS,1)<NENVIOS
							DIMENSION THIS.AENVIOS(NENVIOS+1,5)
						ENDIF
						THIS.AENVIOS(NENVIOS,1) = ENVIAMAIL1
						THIS.AENVIOS(NENVIOS,2) = ENVIAMAIL2
						THIS.AENVIOS(NENVIOS,3) = ENVIAMAIL3
						THIS.AENVIOS(NENVIOS,4) = ENVIAMAIL4
						THIS.AENVIOS(NENVIOS,5) = THIS.CTABLA_EN_PROCESO

					ENDIF
				ENDIF

				IF !EMPTY(DESC_TABLA)
					IF THIS.LACCESO_CONSISTENCIA
						THIS.INT_BORRA_CONSISTENCIA
					ENDIF
					THIS.CAVISO2 = "Ejecutando:"+PROG1
					** Vericamos si tiene detalle de archivos a procesar, utilizado para procesar movimientos por periodos
					**  meses , semanas  como en planillas o contabilidad

					IF 	Tiene_det

						LsLlave				=	Cod_Mod+Cod_Tabla
						LsDetalle			=	Desc_Tabla
						LsModel_Arch		=	Model_Arch
						LsNomb_tabla		=	Nomb_tabla
						THIS.CadenaSql 	=	Tablasmodulo.CadenaSql
						THIS.CadenaSql2 	=	Tablasmodulo.CadenaSql2
						SELECT * FROM Tablasmodulo WHERE Cod_Mod+Cod_Tabla=LsLlave AND Detalle=LsDetalle INTO CURSOR cModDetalle
						SELECT cModDetalle
						SCAN FOR Selec = .T.
							** Limpiamos tabla modelo ** 
							IF USED(THIS.CTABLA_EN_PROCESO)
								USE IN (THIS.CTABLA_EN_PROCESO)
							ENDIF
							LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
							SELECT 0
							USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO) EXCL
							thisformset.procesoInterfaces.TxtAviso1.Value    = "Borrando datos anterior proceso en : "+DBF()
							ZAP
							thisformset.procesoInterfaces.TxtAviso1.Value    = ""
							SELECT cModDetalle

							THIS.Tipo_arch		=	Tipo_Arch
							THIS.Ruta_arch 		=	Ruta_Arch
							THIS.Model_Arch	= 	IIF(EMPTY(Model_Arch),LsModel_Arch,Model_Arch)
							THIS.Hoja_Xls 		= 	Hoja_Xls
							THIS.Arch_Xls 		= 	Arch_Xls
							LsNomb_tabla		=	Nomb_tabla
		*!*						SET STEP ON 
							IF THIS.LPROCESOENBLOQUE
								**				this.dfhtransac_desde=tablasmodulo.fh_transac
								THIS.G_AREACOUNT = 20
								THIS.CLEARAREAS
								**				DO (PROG1)
								THIS.&PROG2
								** Copiamos registros procesados antes de borrar el contenido de la tabla modelo
		*!*							WAIT WINDOW "Haciendo Backup de registros procesados en : "+ADDBS(this.cDirIntCia)+LEFT(LsDetalle,4)+'-'+LEFT(LsNomb_tabla,3)+'.dbf' NOWAIT
								THISFORMSET.procesoInterfaces.TxtAviso1.Value = "Haciendo Backup de registros procesados en : "+ADDBS(this.cDirIntCia)+LEFT(LsDetalle,4)+'-'+LEFT(LsNomb_tabla,3)+'.dbf'

								COPY   TO ADDBS(this.cDirIntCia)+LEFT(LsDetalle,4)+'-'+LEFT(LsNomb_tabla,3)+'.dbf' WITH CDX TYPE FOX2X 
								THISFORMSET.procesoInterfaces.TxtAviso1.Value = 'Listo'
							ELSE
								THIS.&PROG2
							ENDIF
							SELECT cModDetalle
						ENDSCAN
						SELECT TABLASMODULO
					ELSE
						IF THIS.LPROCESOENBLOQUE
							**				this.dfhtransac_desde=tablasmodulo.fh_transac
							THIS.G_AREACOUNT = 20
							THIS.CLEARAREAS
							**				DO (PROG1)
							THIS.&PROG2
						ELSE
							THIS.&PROG2
						ENDIF
					ENDIF
					THIS.CAVISO1 = "Programa anterior:"+PROG1
					THIS.CAVISO2 = ""
				ENDIF
				THISFORMSET.procesoInterfaces.TxtAviso1.Value = []
				THISFORMSET.procesoInterfaces.TxtAviso2.Value = []
				SELECT TABLASMODULO
				REPLACE FH_TRANSAC WITH DATETIME()
			ENDSCAN
			SELE MODULOS
		ENDSCAN
		THIS.CAVISO1 = "PROCESO TERMINADO "
		THISFORMSET.procesoInterfaces.TxtAviso1.Value = THIS.CAVISO1
		THISFORMSET.procesoInterfaces.TxtAviso2.Value = []
		IF !THIS.LPROCESOENBLOQUE
			WAIT WINDOW THIS.CAVISO1 NOWAIT
		ENDIF
		**WAIT WIND 'Los datos fueron procesados' TIMEOUT 0.6
		IF NENVIOS>0
			FOR K = 1 TO ALEN(THIS.AENVIOS,1)
				THIS.LENVIARMAIL 		= THIS.AENVIOS(NENVIOS,1)
				THIS.LENVIARMAILSIEMPRE = THIS.AENVIOS(NENVIOS,2)
				THIS.LENVIARMAILNOTIFICA= THIS.AENVIOS(NENVIOS,3)
				THIS.LENVIARMAILOTROS 	= THIS.AENVIOS(NENVIOS,4)
				THIS.CTAGMAIL 			= THIS.AENVIOS(NENVIOS,5)
				IF THIS.LENVIARMAIL
					THIS.ENVIAR_MAIL('1')
				ENDIF
				IF THIS.LENVIARMAILNOTIFICA
					THIS.ENVIAR_MAIL('2')
				ENDIF
				IF THIS.LENVIARMAILOTROS
					THIS.ENVIAR_MAIL('3')
				ENDIF

			ENDFOR
			RELEASE K
		ENDIF
	ENDPROC


	*-- Interface de trabajadores
	PROCEDURE int_trab
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsAno=This.cAno
				LsMes=This.cNroMes
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(Codigo)
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.Nombre 	 =	ALLTRIM(pri_nom) + IIF(!EMPTY(seg_nom), ' '+ALLTRIM(seg_nom), '') 
						m.Nomcom   =	Ape_Pat + ' ' + Ape_mat + ', ' + m.Nombre
						m.Nomcom   =	LEFT(m.Nomcom,60)
						m.Sexo     	 =	UPPER(ALLTRIM(sexo))
						m.Codigo	=	PADL(ALLTRIM(codigo),7,'0')
						m.Codigo1	=	PADR(m.Codigo,11)
						m.CodRLJ	=	ALLTRIM(m.codigo)
						m.Cen_Cos	=   	IIF(EMPTY(m.Cen_Cos),'999999',m.Cen_Cos)   && N/A
						m.Cod_Car 	=	TRANSFORM(VAL(m.cod_Car),'@L ##')
						m.Doc_ide	=	 '000' && TRANSFORM(VAL(m.Doc_ide),'@L ###')


						IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
							SELECT  (THIS.CTABLA_EN_PROCESO)
							** Generar Log de inconsistencia
							REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
							LOOP
						ENDIF
						m.CodTpl	=  	TRANSFORM(VAL(m.nomina),"@L ##")
						m.CodSuc	='01'

						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_TRABAJADORES_TRA " + ;

							DO CASE 

								CASE	THIS.Do_SqlExec = 'CLI'

									LsCadSql	= This.CadenaSql

								CASE	THIS.Do_SqlExec = 'SVR' 
									LsCadSQL	= This.CadenaSql2 

							ENDCASE

		*!*					IF m.Codigo='1200041'
		*!*						SET STEP ON 
		*!*					ENDIF
							LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes

							IF LnControl<0
		*!*							SET STEP ON 
								REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
							ENDIF

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_cias
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					SCATTER MEMVAR

						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	=  = "EXEC INT_COMPANIA_CIA " + ;  && Si activan esta linea comentar las 2 anteriores

						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)   && Comentar doble esta linea si activan las  2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores
							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_banc
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					SCATTER MEMVAR
						STORE '' TO m.CtaNac,m.CtaDol
						IF INLIST(m.Mon_Cta ,1,2)
							IF m.Mon_Cta=1
								m.CtaNac = m.Nro_Cta
							ELSE
								m.CtaDol = m.Nro_Cta
							ENDIF
						ENDIF
						m.Des_Ban2=LEFT(m.Des_Ban,20)
						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_BANCOS_BCO " + ;       && Si activan esta linea comentar las 2 anteriores


						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las  2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_cost
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(Cen_Cos) 
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.IndDis  = 0
						m.IndCos = 0
						m.IndPro = 0
						m.CODGCO = '01'
						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_CENTRO_COSTO_CCO " + ;    


						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes

						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_carg
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(Cod_Car) 
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_CARGOS_TRABAJADORES_CDT " + ;

						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_pcue
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(Cue_con) 
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.Cod_Cia = TRANSFORM(VAL(Cod_Cia),"@L ##")

						m.TipCta	=	'0'
						m.CodTmo	=	'SO'

						m.Indest 	= 1
						m.FecAct 	= DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_CUENTA_CONTABLE_CCT " + ;    

		*!*					LsCadSql	= "EXEC INT_CUENTA_CONTABLE_CCT " + ;
		*!*							"@CIA_CODCIA		= ?m.cod_cia , " + ;
		*!*							"@CCT_CODCCT	= ?m.Cue_Con , " + ;
		*!*							"@CCT_NOMCTA	= ?m.Des_Con , " + ;
		*!*							"@CCT_OTRDES	= ?m.Des_Con , " + ;
		*!*							"@CCT_TIPCTA		= ?m.TipCta		, " + ;
		*!*							"@TMO_CODTMO	= ?m.CodTmo , " + ;
		*!*							"@CCT_INDEST		= ?m.Indest  , " + ;
		*!*							"@CCT_FECACT	= ?m.FecAct  , " + ;
		*!*							"@Usuario 			= ?m.Usuario , " + ;
		*!*							"@Estacion 			= ?m.Estacion , " + ;
		*!*							"@TipoOperacion 	= ?m.TipoOperacion "

						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF
		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_plan
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN  
					IF EMPTY(ALLTRIM(Empresa+Ano+Mes+Codigo+Cod_Con)) 
						LOOP
					ENDIF
					SCATTER MEMVAR

						m.CodSuc='01'
						m.Mes 		= TRANSFORM(VAL(m.Mes)		,"@L ##")
						m.Semana	= TRANSFORM(VAL(m.Semana)	,"@L ##")
						LsCodigo	= Codigo
						m.Codigo	=	PADL(ALLTRIM(codigo),7,'0')

						IF !USED('TRAB')
							SELECT  0
							USE ADDBS(this.cDirIntCia)+'TRAB' ALIAS TRAB
							SET ORDER TO Codigo
						ELSE
							SELECT TRAB
							SET ORDER TO Codigo
						ENDIF
						SELECT  TRAB
						SEEK 	PADR(LsCodigo,LEN(TRAB.Codigo))
						IF !FOUND()
							SELECT  (THIS.CTABLA_EN_PROCESO)
							REPLACE Error WITH '#' , MsgErr WITH 'No se encuentra codigo de trabajador en TRAB.DBF'  IN  (THIS.CTABLA_EN_PROCESO)
							LOOP
						ELSE
							IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
								SELECT  (THIS.CTABLA_EN_PROCESO)
								** Generar Log de inconsistencia
								REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
						ENDIF	 
						** Obtenemos el codigo de nomina TPL_CODTPL --> Valor deber existir en  dbo.TIPO_PLANILLA_TPL
						m.CodTpl	=  TRANSFORM(VAL(nomina),"@L ##")
						SELECT  (THIS.CTABLA_EN_PROCESO)
						DO CASE
							CASE m.Tip_Pla = 'M'		&& Mensual
								m.Tip_Pla	=	'01'
							CASE m.Tip_Pla = 'S'		&& Semanal
								m.Tip_Pla	=	'02'
							CASE m.Tip_Pla = 'G'		&& Gratificacion
								m.Tip_Pla	=	'03'
							CASE m.Tip_Pla = 'V'		&& Vacaciones
								m.Tip_Pla	=	'04'
							CASE m.Tip_Pla = 'U'		&& Utilidades
								m.Tip_Pla	=	'05'
							CASE m.Tip_Pla = 'Q'		&& Quincena
								m.Tip_Pla	=	'06'
							CASE m.Tip_Pla = 'P'		&& Planilla LBS
								m.Tip_Pla	=	'07'
							CASE m.Tip_Pla = 'E'		&& Extraordinaria
								m.Tip_Pla	=	'09'

							OTHERWISE 
								** Generar Log de inconsistencia **
						ENDCASE
						m.CorPPE	= '001'   && Secuencia
						** Variable para el correlativo de la llave 
						m.CorPCA    = '000'   && CIA_CODCIA+SUC_CODSUC+ANO_CODANO+MES_CODMES+TPL_CODTPL+PPE_CORPPE+AUX_CODAUX
						m.CodCTE	= '00000000000000'
						m.NumDoc	= ''
						** -- **
						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_PLANILLA_CALCULO_PCA " + ;       && Si activan esta linea comentar las 2 anteriores

						LsCadSql = 	"EXEC INT_PLANILLA_CALCULO_PCA " + ;
								"@CIA_CODCIA     	= ?m.Empresa , " + ;
								"@SUC_CODSUC	= ?m.CodSuc , " + ;
								"@ANO_CODANO	= ?m.Ano , " + ;
								"@MES_CODMES	= ?m.Mes , " + ;
								"@TPL_CODTPL	= ?m.CodTpl , " + ;
								"@PPE_CORPPE	= ?m.CorPPE , " + ;
								"@AUX_CODAUX	= ?m.Codigo , " + ;
								"@CON_CODCON	= ?m.Cod_Con , " + ;
								"@PCA_CORPCA	= ?m.CorPCA , " + ;
								"@CTE_CODCTE	= ?m.CodCTE , " + ;
								"@PCA_NUMDOC	= ?m.NumDoc , " + ;
								"@PCA_MDATO3	= ?m.Importe , " + ;
								"@PCA_FECACT	= ?m.FecAct  , " + ;
								"@Usuario 			= ?m.Usuario , " + ;
								"@Estacion 			= ?m.Estacion , " + ;
								"@TipoOperacion 	= ?m.TipoOperacion "

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las  2 siguientes

						IF lnControl < 0
							SET STEP ON 
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_hora
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(Cod_Hor)
						LOOP
					ENDIF
					SCATTER MEMVAR

						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_HORA_HOR " + ;       && Si activan esta linea comentar las 2 anteriores

						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las  2 siguientes

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_remu
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsAno=This.cAno2 
				LsMes=This.cNroMes2 
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(ALLTRIM(Cod_Cia+ Codigo + Cod_Con + Mon_Pag))
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.CodSuc		= '01'
						m.nomina		= '01' 
						m.Secuencia 	= '001'

						m.Mon_Pag		= UPPER(LEFT(m.Mon_Pag,2))
						IF m.Mon_Pag='S'
							m.Mon_Pag='SO'
						ENDIF
						IF m.Mon_Pag='D'
							m.Mon_Pag='DO'
						ENDIF

						LsCodigo	= Codigo
						m.Codigo	=	PADL(ALLTRIM(codigo),7,'0')
						IF !USED('TRAB')
							SELECT  0
							USE ADDBS(this.cDirIntCia)+'TRAB' ALIAS TRAB
							SET ORDER TO Codigo
						ELSE
							SELECT TRAB
							SET ORDER TO Codigo
						ENDIF
						SELECT  TRAB
						SEEK 	PADR(LsCodigo,LEN(TRAB.Codigo))
						IF !FOUND()
							SELECT  (THIS.CTABLA_EN_PROCESO)

		*!*						SET STEP ON 
							** Generar Log de inconsistencia
							REPLACE Error WITH '#' , MsgErr WITH 'No se encuentra codigo de trabajador en TRAB.DBF'  IN  (THIS.CTABLA_EN_PROCESO)
							LOOP
						ELSE
							IF ERROR='@'
		*!*							SET STEP ON
								 SELECT  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
							IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
								SELECT  (THIS.CTABLA_EN_PROCESO)
								** Generar Log de inconsistencia
								REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
						ENDIF	 
						** Obtenemos el codigo de nomina TPL_CODTPL --> Valor deber existir en  dbo.TIPO_PLANILLA_TPL
						m.CodTpl	=  TRANSFORM(VAL(nomina),"@L ##")


						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_REMUNERACIONES_TRABAJADORES_RTR " + ;


						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF
		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF

				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_sald
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsAno=This.cAno2 
				LsMes=This.cNroMes2 
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				LnCodCte    = 0
				SCAN 
					IF EMPTY(ALLTRIM(Cod_Cia+ Codigo + Cod_Con + Mon_Pag))
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.Libro_Pla		= '020'  
						m.Asiento		= '00001'
						m.TipCam		= 2.83
						LnCodCte    		= LnCodCte + 1
						m.Cod_Cia		= TRANSFORM(VAL(m.Cod_Cia),"@L ##")
						m.CodSuc		= '01'
						m.nomina		= '01' 
						m.Secuencia 	= '001'
						LsPict			= "@L "+REPLICATE('9',10)
						m.Mes			= TRANSFORM( VAL(m.Mes),'@L ##')
						m.CodCte		= m.Cod_Cia+m.Ano +m.Mes+ RIGHT(TRANSFORM(LnCodCte, LsPict	),6)
						m.Mon_Pag		= UPPER(LEFT(m.Mon_Pag,2))
						IF m.Mon_Pag='S'
							m.Mon_Pag='SO'
						ENDIF
						IF m.Mon_Pag='D'
							m.Mon_Pag='DO'
						ENDIF
						m.CodTdo		= 'PRP'   && Prestamos al personal
						LnMes			= VAL(m.Mes)
						LnAno			= VAL(m.Ano)

						IF  LnMes	< 12
						        m.FecReg		= CTOD("01/"+STR(LnMes+1,2,0)+"/"+STR(LnAno,4,0))-1
						ELSE
						        m.FecReg		= CTOD("31/12/"+STR(LnAno,4,0))
						ENDIF
						m.CodDoc		=	PADR(m.Doc_Ref,12)
						m.Doc_Ref		=      PADR(m.Doc_Ref,14)
						m.FecEmi		= 	m.FecReg

						LsCodigo		= Codigo
						m.Codigo		= PADL(ALLTRIM(codigo),7,'0')
						IF !USED('TRAB')
							SELECT  0
							USE ADDBS(this.cDirIntCia)+'TRAB' ALIAS TRAB
							SET ORDER TO Codigo
						ELSE
							SELECT TRAB
							SET ORDER TO Codigo
						ENDIF
						SELECT  TRAB
						SEEK 	PADR(LsCodigo,LEN(TRAB.Codigo))
						IF !FOUND()
							SELECT  (THIS.CTABLA_EN_PROCESO)
							** Generar Log de inconsistencia
							REPLACE Error WITH '#' , MsgErr WITH 'No se encuentra codigo de trabajador en TRAB.DBF'  IN  (THIS.CTABLA_EN_PROCESO)
							LOOP
						ELSE
							IF ERROR='@'
								SET STEP ON
								 SELECT  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
							IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
								SELECT  (THIS.CTABLA_EN_PROCESO)
								** Generar Log de inconsistencia
								REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
						ENDIF	 
						** Obtenemos el codigo de nomina TPL_CODTPL --> Valor deber existir en  dbo.TIPO_PLANILLA_TPL
						m.CodTpl	=  TRANSFORM(VAL(nomina),"@L ##")

						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_CUENTA_CORRIENTE_PLANILLA_CCP " + ;


						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)

						ENDIF
		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF

				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE int_prov_vac
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsAno=This.cAno2 
				LsMes=This.cNroMes2 
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				LnCodCte    = 0
				SCAN 
					IF EMPTY(ALLTRIM(Cod_Cia+ Codigo + Cod_Con + Mon_Pag))
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.Cod_Cia		= TRANSFORM(VAL(m.Cod_Cia),"@L ##")
						m.CodSuc		= '01'
						m.nomina		= '01' 
						m.Mes			= TRANSFORM( VAL(m.Mes),'@L ##')
						LnMes			= VAL(m.Mes)
						LnAno			= VAL(m.Ano)
						LsCodigo		= Codigo
						m.Codigo		= PADL(ALLTRIM(codigo),7,'0')
						IF !USED('TRAB')
							SELECT  0
							USE ADDBS(this.cDirIntCia)+'TRAB' ALIAS TRAB
							SET ORDER TO Codigo
						ELSE
							SELECT TRAB
							SET ORDER TO Codigo
						ENDIF
						SELECT  TRAB
						SEEK 	PADR(LsCodigo,LEN(TRAB.Codigo))
						IF !FOUND()
							SELECT  (THIS.CTABLA_EN_PROCESO)
							** Generar Log de inconsistencia
							REPLACE Error WITH '#' , MsgErr WITH 'No se encuentra codigo de trabajador en TRAB.DBF'  IN  (THIS.CTABLA_EN_PROCESO)
							LOOP
						ELSE
							IF ERROR='@'
								SET STEP ON
								 SELECT  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
							IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
								SELECT  (THIS.CTABLA_EN_PROCESO)
								** Generar Log de inconsistencia
								REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
						ENDIF	 
						** Obtenemos el codigo de nomina TPL_CODTPL --> Valor deber existir en  dbo.TIPO_PLANILLA_TPL
						m.CodTpl	=  TRANSFORM(VAL(nomina),"@L ##")

						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_CUENTA_CORRIENTE_PLANILLA_CCP " + ;

						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)

						ENDIF
		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF

				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	*-- Interfase: Migración de conceptos de planilla
	PROCEDURE int_conc
		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(Cod_Con) 
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.Des_Con2 = PADR(m.Des_Con,20)
						m.Indest	= 1
						m.FecAct	= DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_CONCEPTOS_PLANILLA_CON " + ;

						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes

						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF

		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF
				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	*-- Borra completamente los datos de las entidades destino en la base de datos Sql Server
	PROCEDURE int_inicializabd
		m.Indest 	= 1
		m.FecAct 	= DATETIME()
		m.Usuario	= goentorno.user.login
		m.Estacion	= goentorno.user.estacion
		m.Cod_Mod = THIS.Des_Mod_d
		m.TipoOperacion = 'I1'


		LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
		CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_HORA_HOR " + ;       && Si activan esta linea comentar las 2 anteriores

		LsCadSql = 	"EXEC INT_INICIALIZA_TABLAS_MODULO " + ;
				"@COD_MODULO     = ?m.Cod_Mod , " + ;
				"@Usuario 			= ?m.Usuario , " + ;
				"@Estacion 			= ?m.Estacion , " + ;
				"@TipoOperacion 	= ?m.TipoOperacion "

		LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las  2 siguientes

		IF LnControl <0
			=MESSAGEBOX(MESSAGE(),16,'ATENCION / WARNING ')
		ENDIF
		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
		=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

		IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
		ENDIF
	ENDPROC


	PROCEDURE Init
		IF goEntorno.SqlEntorno
			THIS.oCnx_ODBC = goConexion
		ENDIF
		IF 	!This.Ocnx_Odbc.CargaParmsCadCnxArcIni('config.ini')
			MESSAGEBOX('Error en captura de parametros de conexión desde archivo '+LOCFILE('CONFIG.INI'),16)
			This.Conexion2y3	= .F.
		ELSE
			This.Conexion2y3	= .T.
		ENDIF
	ENDPROC


	*-- Carga registros provenientes de un archivo excel o txt hacia una operacion o libro contable para un determinado rango de periodos o meses contables del _ANO contable
	PROCEDURE int_libro_contable

		PARAMETERS PcAno,PcMes,PcCodOpe, PcArch_Xls,PcHoja_Xls,PcRuta_Arch_Xls,PcModel_Arch,Pc_Ruta_Model,Pc_Tabla_en_Proceso
		This.cAno	=	PcAno
		This.cAno2	=	PcAno
		This.cCodope =	PcCodOpe
		This.Arch_Xls =	PcArch_Xls
		This.Ruta_arch = PcRuta_Arch_Xls
		This.Model_Arch = PcModel_Arch
		This.cTabla_en_proceso = Pc_Tabla_en_Proceso

		DO CASE

			CASE	This.Tipo_Arch	=	'XLS'
				LsAno=This.cAno2 
				LsMes=This.cNroMes2 
				LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
				SELECT 0
				USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
				IF EMPTY(This.Arch_Xls)
					This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
				ENDIF
				LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
				AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
				**
				LnTotReg		= RECCOUNT()
				LnTRegProc	= 0
				thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
				**
				SELECT  (THIS.CTABLA_EN_PROCESO)
				LOCATE
				SCAN 
					IF EMPTY(ALLTRIM(NroMes+ FchDoc + NroDoc))
						LOOP
					ENDIF
					SCATTER MEMVAR
						m.CodSuc		= '01'
						m.nomina		= '01' 
						m.Secuencia 	= '001'

						m.Mon_Pag		= UPPER(LEFT(m.Mon_Pag,2))
						IF m.Mon_Pag='S'
							m.Mon_Pag='SO'
						ENDIF
						IF m.Mon_Pag='D'
							m.Mon_Pag='DO'
						ENDIF

						LsCodigo	= Codigo
						m.Codigo	=	PADL(ALLTRIM(codigo),7,'0')
						IF !USED('TRAB')
							SELECT  0
							USE ADDBS(this.cDirIntCia)+'TRAB' ALIAS TRAB
							SET ORDER TO Codigo
						ELSE
							SELECT TRAB
							SET ORDER TO Codigo
						ENDIF
						SELECT  TRAB
						SEEK 	PADR(LsCodigo,LEN(TRAB.Codigo))
						IF !FOUND()
							SELECT  (THIS.CTABLA_EN_PROCESO)

		*!*						SET STEP ON 
							** Generar Log de inconsistencia
							REPLACE Error WITH '#' , MsgErr WITH 'No se encuentra codigo de trabajador en TRAB.DBF'  IN  (THIS.CTABLA_EN_PROCESO)
							LOOP
						ELSE
							IF ERROR='@'
		*!*							SET STEP ON
								 SELECT  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
							IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
								SELECT  (THIS.CTABLA_EN_PROCESO)
								** Generar Log de inconsistencia
								REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
								LOOP
							ENDIF
						ENDIF	 
						** Obtenemos el codigo de nomina TPL_CODTPL --> Valor deber existir en  dbo.TIPO_PLANILLA_TPL
						m.CodTpl	=  TRANSFORM(VAL(nomina),"@L ##")


						m.Indest = 1
						m.FecAct = DATETIME()
						m.Usuario	= goentorno.user.login
						m.Estacion	= goentorno.user.estacion
						m.TipoOperacion = 'I1'

						LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
						CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

		*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_REMUNERACIONES_TRABAJADORES_RTR " + ;


						DO CASE 

							CASE	THIS.Do_SqlExec = 'CLI'

								LsCadSql	= This.CadenaSql

							CASE	THIS.Do_SqlExec = 'SVR' 
								LsCadSQL	= This.CadenaSql2 

						ENDCASE

						LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las 2 siguientes
						IF lnControl < 0
							REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
						ENDIF
		*!*	*!*						.ocnx_ODBC.cCursor = ""
		*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
							=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

							IF lnControl < 0
		*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
		*!*							RETURN
							ENDIF
							IF LnTotReg>0
								LnTRegProc = LnTRegProc + 1
								this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
								thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
							ENDIF

				ENDSCAN

			CASE	This.Tipo_Arch	=	'DBF'
			CASE	This.Tipo_Arch	=	'CSV'
		ENDCASE
	ENDPROC


	PROCEDURE netflock
	ENDPROC


	PROCEDURE int_prov_cts
	ENDPROC


	PROCEDURE int_prov_gra
	ENDPROC


	PROCEDURE int_depe
	ENDPROC


ENDDEFINE
*
*-- EndDefine: interfaces
**************************************************


**************************************************
*-- Class:        user (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   05/03/07 12:13:04 AM
*
DEFINE CLASS user AS custom


	Height = 78
	Width = 100
	*-- Proporciona el nombre del usuario que se atachó a la red
	login = ""
	*-- Proporciona el nombre completo del usuario que se atacho a la red
	nombre = ""
	*-- Indica el nombre del equipo que se conectó a la red
	estacion = ""
	*-- Clave de acceso del Usuario
	password = ""
	*-- Código del perfil de usuario
	perfil = ""
	*-- Código de empleado correspondiente al usuario.
	codigotrabajador = ""
	*-- Código de la categoría del trabajador
	categoria = ""
	*-- Categoria de cada usuario para asignar derechos sobre tablas
	categoriausuario = "'0'"
	*-- Grupo / Group
	groupname = ([])
	userid = ([])
	*-- Acceso a formulas por  codigo Division / Familia
	formdivf = ([])
	*-- Acceso formulas por codigo de sub familias
	formsubf = ([])
	*-- Acceso formulas por codigo de familias
	formfami = ([])
	*-- Acceso formulas por codigo catalogo general
	formcatg = ([])
	Name = "user"

	*-- Fecha hora de Login
	fhlogin = .F.

	*-- Es el servidor al cual el usuario debe de loguearse
	servidor = .F.
	descripcionperfil = .F.
	flagjefatura = .F.
	flagmultilogin = .F.


ENDDEFINE
*
*-- EndDefine: user
**************************************************


**************************************************
*-- Class:        util (k:\aplvfp\classgen\vcxs\admnovis.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/25/14 12:59:14 PM
*-- Utilidades para el Sistema
*
DEFINE CLASS util AS custom


	Height = 26
	Width = 23
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="openfileext" type="method" display="OpenFileExt"/></VFPData>]
	Name = "util"

	*-- Es un array que contiene los nombres de las tablas locales contenidos en la PC Local
	PROTECTED tatablelocal


	*-- Retorna un digito de control de modulo 11
	PROCEDURE modulo11
		LPARAMETER m.cNumero
		LOCAL m.nCount , m.nSuma , m.nPos , m.nMod
		m.cNumero = IIF(VarType(m.cNumero)=="C",ALLTRIM(m.cNumero),'')
		IF EMPTY(m.cNumero)
			RETURN m.cMod
		ENDIF
		m.nSuma	= 0
		m.nPos	= 2
		FOR m.nCount = LEN(m.cNumero) TO 1 STEP -1
			m.nSuma	= m.nSuma + (VAL(SUBSTR(m.cNumero,m.nCount,1))*m.nPos)
			m.nPos	= IIF(m.nPos=9,2,m.nPos+1)
		ENDFOR
		m.nMod	= 11-MOD(m.nSuma,11)
		m.nMod	= IIF(m.nMod>9,0,m.nMod)
		RETURN STR(m.nMod,1)
	ENDPROC


	*-- Determina si el numero contiene un digito de control de modulo 11
	PROCEDURE ismodulo11
		LPARAMETER m.cNumero
		LOCAL m.cMod , m.nLen
		m.cNumero = IIF(VarType(m.cNumero)=="C",ALLTRIM(m.cNumero),'')
		IF EMPTY(m.cNumero) OR Len(m.cNumero)<2
			RETURN .F.
		ENDIF
		m.nLen	= LEN(m.cNumero)-1
		m.cMod	= THIS.Modulo11(LEFT(m.cNumero,m.nLen))
		RETURN RIGHT(m.cNumero,1)==m.cMod
	ENDPROC


	*-- Rutina para abrir una tabla de VFP
	PROCEDURE opentable
		LPARAMETER m.cPathDBC , m.cNameTable , m.nType
		LOCAL m.cFile , m.cOnError , m.lOk

		*m.lOk = .T.
		m.cOnError	= ON('ERROR')
		ON ERROR
		*ON ERROR ShowError( ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO() , PROGRAM(1) , @lOk )
		m.nReturn	= 0
		m.cPathDBC	= IIF(VarType(m.cPathDBC)=="C"	,UPPER(ALLTRIM(m.cPathDBC)),'\')
		m.cNameTable= IIF(VarType(m.cNameTable)=="C"	,UPPER(ALLTRIM(m.cNameTable)),'')
		m.nType		= IIF(VarType(m.nType)=="N"	,m.nType,0)
		m.nType		= IIF(BETWEEN(m.nType,0,3)	,m.nType,0)
		m.cPathDBC	= AddBs(m.cPathDBC)
		m.cFile		= DefaultExt(m.cPathDBC+m.cNameTable,'DBF')

		IF USED(m.cNameTable)
			SELECT(m.cNameTable)
			m.nReturn	= 2
			IF m.nType==2	&& Exclusivo
				IF NOT ISEXCLUSIVE(m.cNameTable,1)	&& No esta abierto exclusivo
					m.lOk		= .T.
					USE (LOCFILE(m.cFile,'DBF','Buscar '+m.cNameTable)) EXCLUSIVE ORDER 0
					m.nReturn = IIF(m.lOk,2,0)
				ENDIF
			ENDIF
		ELSE
			DO CASE
			CASE m.nType==0	&& Compartido Lecto/Escritura
				m.lOk		= .T.
				USE (LOCFILE(m.cFile,'DBF','Buscar '+m.cNameTable)) SHARED ORDER 0 IN 0
				m.nReturn = IIF(m.lOk,1,0)
			CASE m.nType==1	&& Compartido Solo Lectura
				m.lOk		= .T.
				USE (LOCFILE(m.cFile,'DBF','Buscar '+m.cNameTable)) SHARED NOUPDATE ORDER 0 IN 0
				m.nReturn = IIF(m.lOk,1,0)
			CASE m.nType==2	&& Exclusivo
				m.lOk		= .T.
				USE (LOCFILE(m.cFile,'DBF','Buscar '+m.cNameTable)) EXCLUSIVE ORDER 0 IN 0
				m.nReturn = IIF(m.lOk,1,0)
			ENDCASE
		ENDIF
		ON ERROR &cOnError
		RETURN m.nReturn
	ENDPROC


	*-- Muestra el error ocurrido en tiempo de ejecuci¢n
	PROCEDURE showerror
		LPARAMETER m.nError , m.cMess , m.cSource , m.cProg , m.nLineno , m.cProg1 , m.lFlag
		LOCAL m.cMessage , m.nRspta
		m.cMessage	= 'HA OCURRIDO UN ERROR EN EL PROGRAMA' + CHR(13)+CHR(13)
		m.cMessage	= ''
		m.cMessage	= m.cMessage + 'Número de error  ---> ' + ALLTRIM(STR(m.nError)) + CHR(13)
		m.cMessage	= m.cMessage + 'Mensaje de error  ---> ' + m.cMess + CHR(13)+CHR(13)
		m.cMessage	= m.cMessage + 'Origen del error  ---> ' + m.cSource + CHR(13)+CHR(13)
		m.cMessage	= m.cMessage + 'Línea del error  ---> ' + ALLTRIM(STR(m.nLineno))+ CHR(13)
		m.cMessage	= m.cMessage + 'Programa con error  ---> ' + ALLTRIM(UPPER(m.cProg)) + CHR(13)
		m.cMessage	= m.cMessage + 'Programa Superior  ---> ' + ALLTRIM(UPPER(m.cProg1)) + CHR(13) + CHR(13)
		m.cMessage	= m.cMessage + 'Elija ANULAR para Salir, REINTENTAR para volver a ejecutar e IGNORAR para Proseguir'

		m.nRspta	= MESSAGEBOX(m.cMessage,2+16+256,'Control de Errores')

		DO CASE
		CASE m.nRspta == 3	&& Anular
			m.lFlag	= .F.
			QUIT
		CASE m.nRspta == 4	&& Reintentar
			RETRY
		CASE m.nRspta == 5	&& Ignorar
			m.lFlag	= .F.
		ENDCASE
		RETURN m.lFlag
	ENDPROC


	*-- Funcion para encriptar, desencriptar cadenas
	PROCEDURE encripta
		LPARAMETER m.lcCadena , m.lEncrip
		LOCAL m.lcString , m.lnLen , m.lcEncrip , m.lnCount , m.lcChar , m.lnSigno , m.lnAscii
		m.lcString	= IIF( m.lEncrip , STRTRAN( m.lcCadena , SPACE(1) , CHR(200) ) , m.lcCadena )
		m.lcString	= m.lcCadena
		m.lnLen		= LEN( m.lcString )
		m.lcEncrip	= ''
		m.lnSigno	= IIF( m.lEncrip AND !EMPTY(INT(m.lnLen/2)-(m.lnLen/2)) , -1 , 1 )
		FOR m.lnCount = m.lnLen TO 1 STEP -1
			m.lnAscii	= ASC(SUBSTR(m.lcString,m.lnCount,1)) + ( m.lnSigno * m.lnLen )
			DO WHILE m.lnAscii > 255
				m.lnAscii	= m.lnAscii - 255
			ENDDO
			DO WHILE m.lnAscii < 0
				m.lnAscii	= m.lnAscii + 255
			ENDDO
			m.lcChar	= CHR( m.lnAscii )
			m.lcEncrip	= m.lcEncrip + m.lcChar
			m.lnSigno	= m.lnSigno * (-1)
		ENDFOR
		RETURN STRTRAN(m.lcEncrip,CHR(200),SPACE(1))
	ENDPROC


	*-- Procedimiento que setea un cursor para hacerlo una vista actualizable.
	PROCEDURE crearvista
		LPARAMETER m.tcKeyFields , m.tcListField , m.tnBuffer, m.tcLocalCursor , m.tcRemoteTable

		LOCAL m.lcFields1 , m.lcFields2 , m.lcAlias
		LOCAL m.lnCount

		m.tcRemoteTable	= ALLTRIM(m.tcRemoteTable)
		m.tcLocalCursor	= ALLTRIM(m.tcLocalCursor)

		m.lcFields1	= SPACE(0)
		m.lcFields2	= SPACE(0)

		m.lcAlias	= SELECT()

		SELECT(m.tcLocalCursor)

		FOR m.lnCount=1 TO FCOUNT()
			IF TRANSFORM(m.lnCount,'@JL 99') $ m.tcListField
				m.lcFields1	= m.lcFields1 + FIELD(m.lnCount) + ' ' + m.tcRemoteTable+'.'+FIELD(m.lnCount)
				m.lcFields2	= m.lcFields2 + FIELD(m.lnCount)
				m.lcFields1	= m.lcFields1 + ' , '
				m.lcFields2	= m.lcFields2 + ' , '
			ENDIF
		ENDFOR
		m.lcFields1	= LEFT(m.lcFields1,LEN(m.lcFields1)-3)
		m.lcFields2	= LEFT(m.lcFields2,LEN(m.lcFields2)-3)

		IF SET('MULTILOCKS')<>'ON'
			SET MULTILOCKS ON
		ENDIF

		=CURSORSETPROP('Buffering',m.tnBuffer,m.tcLocalCursor)			&& Modo del buffer
		=CURSORSETPROP('UpdateType',1,m.tcLocalCursor)					&& Modo de actualizacion, 2= Eliminar+Añadir
		=CURSORSETPROP('WhereType',3,m.tcLocalCursor)					&& Actualizar campos clave y cualquier otro modificado
		=CURSORSETPROP('SendUpdates',.T.,m.tcLocalCursor)				&& especifica si se actualiza el servidor
		=CURSORSETPROP('KeyFieldList',m.tcKeyFields,m.tcLocalCursor)	&& Campos clave
		=CURSORSETPROP('Tables',m.tcRemoteTable,m.tcLocalCursor)		&& Las tablas del servidor que se actualizaran
		=CURSORSETPROP('UpdateNameList',m.lcFields1,m.tcLocalCursor)	&& Los campos locales vs los campos remotos (guia)
		=CURSORSETPROP('UpdatableFieldList',m.lcFields2,m.tcLocalCursor)&& Los campos que se actualizaran
		=CURSORSETPROP('FetchMemo', .T.)
		=CURSORSETPROP('UseMemoSize', 255)
		=CURSORSETPROP('FetchSize', 100)
		=CURSORSETPROP('MaxRecords', -1)
		=CURSORSETPROP('Prepared', .F.)
		=CURSORSETPROP('CompareMemo', .T.)
		=CURSORSETPROP('FetchAsNeeded', .F.)
		=CURSORSETPROP('BatchUpdateCount', 10)


		SELECT(m.lcAlias)

		RETURN
	ENDPROC


	*-- Devolver la ruta completa de las tablas y/o store procedures del sistema
	PROCEDURE ruta_tabla
		LPARAMETER m.loCnx_ODBC , m.tcEntidades , m.tlCodigo , m.tcTipoEntidad , aRetorno , nDataSession

		LOCAL m.lcRutaDefault , m.lcVar
		LOCAL m.lcServer , m.lcDataBase , m.lcTabla , m.lcCodigo , m.llFlagTablaLocal
		LOCAL m.lnCount , m.lnEntidades
		LOCAL m.laEntidades

		nDataSession	= IIF(VARTYPE(nDataSession)=='N',nDataSession,1)
		nDataSession	= IIF(nDataSession>0,nDataSession,1)
		m.tcEntidades	= UPPER(ALLTRIM(m.tcEntidades))

		DO WHILE LEFT(m.tcEntidades,1)==';' OR RIGHT(m.tcEntidades,1)==';'
			IF LEFT(m.tcEntidades,1)==';'
				m.tcEntidades	= SUBSTR(m.tcEntidades,2)
			ENDIF
			IF RIGHT(m.tcEntidades,1)==';'
				m.tcEntidades	= LEFT(m.tcEntidades,LEN(m.tcEntidades)-1)
			ENDIF
		ENDDO

		*!*	Obtener el número de entidades que desea consultar
		m.lnEntidades	= OCCURS(';',m.tcEntidades)+1
		DECLARE m.laEntidades[62]
		STORE 'X' TO m.laEntidades

		*!*	------------------------------------------------------
		*!*	Activarlo cuando se empieze a trabajar con la variable del sistema goEntorno
		*!*	m.lcRutaDefault	= goEntorno.Servidor+'.'+goEntorno.BaseDatos+'.GenC_RutaEntidad'
		*!*	------------------------------------------------------

		m.lcRutaDefault	= 'GenC_RutaEntidad'

		IF m.lnEntidades = 1
			m.laEntidades[1]	= "'"+m.tcEntidades+"'"
		ELSE
			m.lnCount	= 0
			DO WHILE OCCURS(';',m.tcEntidades)>0
				m.lnCount		= m.lnCount + 1
				m.laEntidades[m.lnCount]	= "'"+SUBSTR(m.tcEntidades,1,AT(';',m.tcEntidades)-1)+"'"
				m.tcEntidades	= SUBSTR(m.tcEntidades,AT(';',m.tcEntidades)+1)
			ENDDO
			m.lnCount	= m.lnCount + 1
			m.laEntidades[m.lnCount]	= "'"+m.tcEntidades+"'"
		ENDIF

		m.laEntidades[61]	= IIF(m.tlCodigo,'1','0')
		m.laEntidades[62]	= "'"+m.tcTipoEntidad+"'"

		m.loCnx_ODBC.cSP		= m.lcRutaDefault
		m.loCnx_ODBC.cCursor	= ''
		m.loCnx_ODBC.SetPrmSP(@m.laEntidades)
		m.loCnx_ODBC.DoSP(nDataSession)

		IF NOT m.loCnx_ODBC.Found
			DECLARE m.laEntidades[1]
			m.laEntidades[1]=''
			m.loCnx_ODBC.CloseCursor()
			m.loCnx_ODBC.cCursor = ''
			m.loCnx_ODBC.SetPrmSP(@m.laEntidades)
			m.loCnx_ODBC.cSP = ''
			aRetorno = NULL
			RETURN .F.
		ENDIF

		SELECT(m.loCnx_ODBC.cCursor)
		DECLARE aRetorno[m.lnEntidades,3]
		STORE SPACE(0) TO aRetorno
		m.lnCount	= 0
		GO TOP
		SCAN WHILE NOT EOF()
			m.lnCount			= m.lnCount	+ 1
			m.lcServer			= FIELD(1)
			m.lcDataBase		= FIELD(2)
			m.lcTabla			= FIELD(3)
			m.llFlagTablaLocal	= FIELD(4)
			m.lcCodigo			= FIELD(5)

			m.lcServer			= ALLTRIM(UPPER(&lcServer))
			m.lcDataBase		= ALLTRIM(UPPER(&lcDataBase))
			m.lcTabla			= ALLTRIM(UPPER(&lcTabla))
			m.llFlagTablaLocal	= &llFlagTablaLocal
			m.lcCodigo			= ALLTRIM(UPPER(&lcCodigo))

			FOR I=1 TO m.lnEntidades
				IF m.tlCodigo		&& Envio código
					IF m.laEntidades[I] == "'"+m.lcCodigo+"'"
						aRetorno[I,1] = m.lcServer+'.'+m.lcDataBase+'.dbo.'+m.lcTabla
						aRetorno[I,2] = m.llFlagTablaLocal
						aRetorno[I,3] = m.lcCodigo
					ENDIF
				ELSE				&& Envio Nombres
					IF m.laEntidades[I] == "'"+m.lcTabla+"'"
						aRetorno[I,1] = m.lcServer+'.'+m.lcDataBase+'.dbo.'+m.lcTabla
						aRetorno[I,2] = m.llFlagTablaLocal
						aRetorno[I,3] = m.lcCodigo
					ENDIF
				ENDIF
			ENDFOR

		ENDSCAN
		DECLARE m.laEntidades[1]
		m.laEntidades[1]=''
		USE IN (m.loCnx_ODBC.cCursor)
		m.loCnx_ODBC.CloseCursor()
		m.loCnx_ODBC.cCursor = ''
		m.loCnx_ODBC.SetPrmSP(@m.laEntidades)
		m.loCnx_ODBC.cSP = ''
		RETURN .T.
	ENDPROC


	*-- Devuelve el Nombre del dia de la semana a partir de una fecha
	PROCEDURE nombre_dia
		LPARAMETER tdFecha

		LOCAL lnDia
		IF NOT VARTYPE(tdFecha) $ 'D,T'
			RETURN ''
		ENDIF

		lnDia	= DOW(tdFecha)
		DO CASE
		CASE lnDia = 1
			RETURN 'Domingo'
		CASE lnDia = 2
			RETURN 'Lunes'
		CASE lnDia = 3
			RETURN 'Martes'
		CASE lnDia = 4
			RETURN 'Miércoles'
		CASE lnDia = 5
			RETURN 'Jueves'
		CASE lnDia = 6
			RETURN 'Viernes'
		CASE lnDia = 7
			RETURN 'Sábado'
		ENDCASE
	ENDPROC


	*-- Devuelve el Nombre del Mes a partir de una fecha
	PROCEDURE nombre_mes
		LPARAMETER tdFecha

		LOCAL lnMes
		IF NOT VARTYPE(tdFecha) $ 'D,T'
			RETURN ''
		ENDIF
		lnMes	= MONTH(tdFecha)

		DO CASE
		CASE lnMes = 1
			RETURN 'Enero'
		CASE lnMes = 2
			RETURN 'Febrero'
		CASE lnMes = 3
			RETURN 'Marzo'
		CASE lnMes = 4
			RETURN 'Abril'
		CASE lnMes = 5
			RETURN 'Mayo'
		CASE lnMes = 6
			RETURN 'Junio'
		CASE lnMes = 7
			RETURN 'Julio'
		CASE lnMes = 8
			RETURN 'Agosto'
		CASE lnMes = 9
			RETURN 'Setiembre'
		CASE lnMes = 10
			RETURN 'Octubre'
		CASE lnMes = 11
			RETURN 'Noviembre'
		CASE lnMes = 12
			RETURN 'Diciembre'
		ENDCASE
	ENDPROC


	*-- Devuelve el formato de fecha: <Nombre Dia>, <dia> de <Mes> de <A¤o> ¢ <dia> - <Mes> - <A¤o>
	PROCEDURE formato_fecha
		LPARAMETER tdFecha , tlTipo

		IF NOT VARTYPE(tdFecha)$ 'D,T'
			RETURN ''
		ENDIF

		IF tlTipo		&& Formato Largo
			RETURN THIS.Nombre_Dia(tdFecha) + ', '+TRANSFORM(DAY(tdFecha),'@JL 99')+' de '+THIS.Nombre_Mes(tdFecha)+' de '+TRANSFORM(YEAR(tdFecha),'@JL 9,999')
		ELSE			&& Formato Corto
			RETURN TRANSFORM(DAY(tdFecha),'@JL 99')+' - '+LEFT(THIS.Nombre_Mes(tdFecha),3)+' - '+TRANSFORM(YEAR(tdFecha),'@JL 9,999')
		ENDIF
	ENDPROC


	PROCEDURE closetable
		*!*	LPARAMETERS lcTable
		*!*	IF USED(lcTable)
		*!*		USE IN (lcTable)
		*!*	ENDIF

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


	PROCEDURE correlativo
		LPARAMETERS tcTabla , tcTipo , tcRutaSP
		tcRutaSP =	IIF(VARTYPE(tcRutaSP)=='C' AND NOT EMPTY(tcRutaSP),tcRutaSP,SPACE(0))
		*!*	STORE SPACE(20) TO lcCodigo
		*!*	DECLARE aParams[3]
		*!*	aParams[1]	= "'"+tcTabla+"'"
		*!*	aParams[2]	= '?@lcCodigo'
		*!*	aParams[3]	= tcTipo
		*!*	IF EMPTY(tcRutaSP)
		*!*		goConexion.cSP = goEntorno.RemotePathEntidad("ADMGEN4_Contador_Entidad")
		*!*	ELSE
		*!*		goConexion.cSP = tcRutaSP
		*!*	ENDIF
		*!*	goConexion.SetPrmSP(@aParams)
		*!*	goConexion.cCursor = SYS(2015)
		*!*	goConexion.DoSP()
		*!*	goConexion.CloseCursor()

		IF EMPTY(tcRutaSP)
			tcRutaSP = goEntorno.RemotePathEntidad("ADMGEN4_Contador_Entidad")
		ENDIF

		m.Entidad		= tcTabla
		m.Contador		= SPACE(20)
		m.Actualizar	= tcTipo

		*goConexion.cSQL	= "EXEC " + tcRutaSP + " @Entidad = ?m.Entidad , @Contador = ?@m.Contador , @Actualizar = ?m.Actualizar"
		goConexion.cSQL	= "{CALL " + tcRutaSP + " (?m.Entidad , ?@m.Contador , ?m.Actualizar)}"

		goConexion.cCursor = ""
		goConexion.DoSQL()
		goConexion.CloseCursor()

		RETURN ALLTRIM(m.Contador)
	ENDPROC


	*-- Crea un cursor con los productos disponibles en la tabla GProductos
	PROCEDURE cursor_producto
		*!*	---------------------------------------------------------------------------
		*!*	Recibe como parámetros la conexión y el nombre del cursor que desea generar
		*!*	---------------------------------------------------------------------------
		*!*	LPARAMETER toCnx_ODBC , tcCursor

		*!*	tcCursor =	IIF(VARTYPE(tcCursor)=='C',ALLTRIM(tcCursor),'GPRODUCTOS_'+SYS(3))
		*!*	LOCAL laTablas
		*!*	LOCAL lcTablas
		*!*	THIS.Ruta_Tabla(toCnx_ODBC,'GProductos',.F.,'0',@laTablas)


		*!*	toCnx_ODBC.cSQL =	"SELECT *,"+;
		*!*						"SPACE(100) AS MaestroEstiloxProducto ,"+;
		*!*						"SPACE(100) AS MaestroEstiloVerxProducto ,"+;
		*!*						"SPACE(100) AS MaestroDesarrolloVerxProducto ,"+;
		*!*						"SPACE(100) AS MaestroAtributos ,"+;
		*!*						"SPACE(100) AS MaestroAProbaciones ,"+;
		*!*						"SPACE(100) AS MaestroAProbaciones_Detalle ,"+;
		*!*						"SPACE(100) AS MaestroDatoGeneralPrenda "+;
		*!*						"FROM "+laTablas(1,1)

		*!*	toCnx_ODBC.cCursor = tcCursor
		*!*	toCnx_ODBC.DoSQL()

		*!*	SELECT(tcCursor)
		*!*	GO TOP
		*!*	SCAN WHILE NOT EOF()
		*!*		lcTablas =	IIF(VARTYPE(CodigoMaestroEstiloxProducto)='C',CodigoMaestroEstiloxProducto,'X')+";"+;
		*!*					IIF(VARTYPE(CodigoMaestroEstiloVerxProducto)='C',CodigoMaestroEstiloVerxProducto,'X')+";"+;
		*!*					IIF(VARTYPE(CodigoMaestroDesarrolloVerxProducto)='C',CodigoMaestroDesarrolloVerxProducto,'X')+";"+;
		*!*					IIF(VARTYPE(CodigoMaestroAtributos)='C',CodigoMaestroAtributos,'X')+";"+;
		*!*					IIF(VARTYPE(CodigoMaestroAProbaciones)='C',CodigoMaestroAProbaciones,'X')+";"+;
		*!*					IIF(VARTYPE(CodigoMaestroAProbaciones_Detalle)='C',CodigoMaestroAProbaciones_Detalle,'X')+";"+;
		*!*					IIF(VARTYPE(CodigoMaestroDatoGeneralPrenda)='C',CodigoMaestroDatoGeneralPrenda,'X')
		*!*		THIS.Ruta_Tabla(toCnx_ODBC,lcTablas,.T.,'0',@laTablas)
		*!*		SELECT(tcCursor)
		*!*		IF TYPE("laTablas(7,1)")=='C'
		*!*			m.MaestroEstiloxProducto		= laTablas(1,1)
		*!*			m.MaestroEstiloVerxProducto		= laTablas(2,1)
		*!*			m.MaestroDesarrolloVerxProducto	= laTablas(3,1)
		*!*			m.MaestroAtributos				= laTablas(4,1)
		*!*			m.MaestroAProbaciones			= laTablas(5,1)
		*!*			m.MaestroAProbaciones_Detalle	= laTablas(6,1)
		*!*			m.MaestroDatoGeneralPrenda		= laTablas(7,1)
		*!*		ELSE
		*!*			m.MaestroEstiloxProducto		= SPACE(0)
		*!*			m.MaestroEstiloVerxProducto		= SPACE(0)
		*!*			m.MaestroDesarrolloVerxProducto	= SPACE(0)
		*!*			m.MaestroAtributos				= SPACE(0)
		*!*			m.MaestroAProbaciones			= SPACE(0)
		*!*			m.MaestroAProbaciones_Detalle	= SPACE(0)
		*!*			m.MaestroDatoGeneralPrenda		= SPACE(0)
		*!*		ENDIF
		*!*		GATHER MEMVAR FIELD MaestroEstiloxProducto,MaestroEstiloVerxProducto,;
		*!*							MaestroDesarrolloVerxProducto,MaestroAtributos,;
		*!*							MaestroAProbaciones,MaestroAProbaciones_Detalle,;
		*!*							MaestroDatoGeneralPrenda
		*!*		=TABLEUPDATE(.T.,.T.,tcCursor)
		*!*	ENDSCAN

		*!*	RETURN tcCursor
	ENDPROC


	*-- Verifica si todos los componentes y el mismo diseño de la prenda esten aprobados.
	PROCEDURE chequeaaprobacionprenda
		PARAMETERS tcCodDesarrollo, tcVersionCodDesarrollo 

		LOCAL ARutas,lcTablas,ATablas, llAprobPrenda
		WITH THISFORM
			lcTablas =  'MTipoPyMxSolicitudDDP;'+;
						'MProductosxSolicitudDDP'
			THIS.Ruta_Tabla(.ocnx_odbc,lcTablas,.F.,'0',@ARutas, .DATASESSIONID)
			dimension ATablas[2,3]
			=ACOPY(ARutas,ATablas)

			********** NIVEL PRENDA :
			*** Buscamos los aprobados
			.ocnx_odbc.cSQL = 'SELECT * FROM '+ATablas[1,1]+" WHERE NumeroSolicitudDDP = '"+;
							tcCodDesarrollo+"' AND FlagEliminado = '0'"
			.ocnx_odbc.ccursor = 'VCheckTiposPyM'
			.ocnx_odbc.DoSQL()
			llAprobPrenda = .T.
			SELECT VCheckTiposPyM
			SCAN 
				IF !FlagAprobacion
					llAprobPrenda = .F.
					EXIT
				ENDIF
			ENDSCAN
			IF !llAprobPrenda
				THIS.CloseTable('VCheckTiposPyM')
				RETURN llAprobPrenda
			ENDIF
			VCheckRutas = THIS.cursor_producto(.ocnx_odbc,'VCheckRutas')
			SELECT VCheckRutas
			INDEX ON CodigoProducto TAG A
			************ NIVEL SUBPRODUCTOS :
			** Obtenemos todos los subproductos de la Solicitud de Desarrollo excepto PRENDA :
			.ocnx_odbc.cSQL = "SELECT CodigoProducto,CodigoFamilia,Item FROM "+;
							ATablas[2,1]+" WHERE NumeroSolicitudDDP = '"+;
							tcCodDesarrollo+"' AND CodigoProducto <> '001' AND FlagEliminado = 0 "
			.ocnx_odbc.ccursor = 'VCheckSubProductos'
			.ocnx_odbc.DoSQL()
			SELECT VCheckSubProductos
			SCAN
				SCATTER MEMVAR
				=SEEK(m.CodigoProducto,'VCheckRutas')
				IF !EMPTY(VCheckRutas.MaestroDatoGeneralPrenda) AND ;
				   !EMPTY(VCheckRutas.MaestroDesarrolloVerxProducto) AND ;
				    INLIST(m.Codigoproducto,'002','004')
				   ** Recuperamos todos las respuestas por cada versión de desarrollo de cada Familia-Item
				   ** de la Solicitud de Desarrollo Nro <tcCodDesarrollo> :
				   IF EMPTY(VCheckRutas.MaestroAprobaciones_Detalle)  && No es Color
						.ocnx_odbc.cSQL = "SELECT c.FlagAprobRechCliente, c.FlagAprobRechComercial FROM "+;
						VCheckRutas.MaestroDatoGeneralPrenda+" a INNER JOIN "+VCheckRutas.MaestroDesarrolloVerxProducto+ ;
						" b ON a.CodigoProducto+a.CodigoFamilia+a.CodigoDesarrolloEnDesarrollo+"+;
						"a.VersionCodigoDesarrolloEnDesarrollo = b.CodigoProducto+b.CodigoFamilia+"+;
						"b.CodigoDesarrollo+b.VersionCodigoDesarrollo INNER JOIN "+VCheckRutas.MaestroAprobaciones+;
						" c ON b.CodigoProducto+b.CodigoFamilia+b.CodigoDesarrollo = "+;
						" c.CodigoProducto+c.CodigoFamilia+c.CodigoDesarrollo WHERE a.CodigoDesarrollo = '"+;
						tcCodDesarrollo+"' AND a.VersionCodigoDesarrollo = '"+tcVersionCodDesarrollo+"'"+;
						" AND a.CodigoProducto = '"+m.Codigoproducto+"' AND a.CodigoFamilia = '"+m.CodigoFamilia+;
						"' AND a.Item = '"+m.Item+"' AND a.FlagAsignado = 'D' AND a.FlagEliminado = 0 AND "+;
						"b.FlagEliminado = 0 AND c.NumeroSolicitudDDP = '"+tcCodDesarrollo+"' AND "+;
						"c.VersionNumeroSolicitudDDP = '"+tcVersionCodDesarrollo+"' AND c.FlagEliminado = 0"+;
						" UNION "+;
						"SELECT c.FlagAprobRechCliente, c.FlagAprobRechComercial FROM "+;
						VCheckRutas.MaestroDatoGeneralPrenda+" a INNER JOIN "+VCheckRutas.MaestroDesarrolloVerxProducto+ ;
						" b ON a.CodigoProducto+a.CodigoFamilia+a.CodigoDesarrolloAsignado+"+;
						"a.VersionCodigoDesarrolloAsignado = b.CodigoProducto+b.CodigoFamilia+"+;
						"b.CodigoDesarrollo+b.VersionCodigoDesarrollo INNER JOIN "+VCheckRutas.MaestroAprobaciones+;
						" c ON b.CodigoProducto+b.CodigoFamilia+b.CodigoDesarrollo = "+;
						" c.CodigoProducto+c.CodigoFamilia+c.CodigoDesarrollo WHERE a.CodigoDesarrollo = '"+;
						tcCodDesarrollo+"' AND a.VersionCodigoDesarrollo = '"+tcVersionCodDesarrollo+"'"+;
						" AND a.CodigoProducto = '"+m.Codigoproducto+"' AND a.CodigoFamilia = '"+m.CodigoFamilia+;
						"' AND a.Item = '"+m.Item+"' AND a.FlagAsignado = 'A' AND a.FlagEliminado = 0 AND "+;
						"b.FlagEliminado = 0 AND c.NumeroSolicitudDDP = '"+tcCodDesarrollo+"' AND "+;
						"c.VersionNumeroSolicitudDDP = '"+tcVersionCodDesarrollo+"' AND c.FlagEliminado = 0"
						.ocnx_odbc.ccursor = 'VRespuestasAprobaciones'
						.ocnx_odbc.DoSQL
						llAprobProducto = .F.
						SELECT VRespuestasAprobaciones
						** Chequeamos si alguna de las respuestas tiene Aprobación :
						SCAN
							SCATTER MEMVAR
							IF FlagAprobRechCliente = 'A' OR FlagAprobRechComercial = 'A'
								llAprobProducto = .T.
								EXIT
							ENDIF
						ENDSCAN
					ELSE    && producto es COLOR :
						.ocnx_odbc.cSQL = "SELECT a.CodigoDesarrollo, a.VersionCodigoDesarrollo, "+;
						" a.CodigoProducto, a.CodigoFamilia, a.Item, a.NumeroLabDip, a.FlagAprobRechCliente, "+;
						" a.FlagAprobRechComercial FROM "+;
						VCheckRutas.MaestroAprobaciones_Detalle+" a WHERE a.CodigoDesarrollo = '"+;
						tcCodDesarrollo+"' AND a.VersionCodigoDesarrollo = '"+tcVersionCodDesarrollo+"'"+;
						" AND a.CodigoProducto = '"+m.Codigoproducto+"' AND a.CodigoFamilia = '"+m.CodigoFamilia+;
						"' AND a.Item = '"+m.Item+"' AND a.FlagEliminado = 0 "
						.ocnx_odbc.ccursor = 'VRespuestasAprobaciones'
						.ocnx_odbc.DoSQL
						llAprobProducto = .F.
						SELECT VRespuestasAprobaciones
						** Chequeamos si alguna de las pruebas tiene Aprobación :
						SCAN
							SCATTER MEMVAR
							IF FlagAprobRechCliente = 'A' OR FlagAprobRechComercial = 'A'
								llAprobProducto = .T.
								EXIT
							ENDIF
						ENDSCAN
					ENDIF
				ELSE
					llAprobProducto = .T.
				ENDIF
				IF !llAprobProducto
					EXIT
				ENDIF
			ENDSCAN
			THIS.CloseTable('VCheckTiposPyM')
			THIS.CloseTable('VCheckRutas')
			THIS.CloseTable('VCheckSubProductos')
			THIS.CloseTable('VRespuestasAprobaciones')
		ENDWITH
		RETURN llAprobProducto
	ENDPROC


	PROCEDURE cursor_esta_vacio
		PARAMETERS Pc_Tabla,Pl_NumReg
		IF VARTYPE(Pl_NumReg)<>'L'
			Pl_NumReg=.F.
		ENDIF

		IF PARAMETERS()=0
			Pc_Tabla=ALIAS()
		ENDIF
		IF EMPTY(Pc_Tabla)
			RETURN .T.
		ENDIF
		LOCAL LcArea_Act,LnNumReg,LnRegAct
		*LcArea_Act=ALIAS()
		*LnNumReg = IIF(EMPTY(LcArea_Act),0,RECNO())

		IF !EMPTY(Pc_Tabla) AND USED(Pc_Tabla)
			SELECT * FROM (pc_tabla) INTO CURSOR xTmp
			USE IN xTmp
			SELECT(pc_tabla)
			** VETT  25/08/2014 12:59 PM : Retornamos el numero de registros del cursor o tabla evaluada 
			IF Pl_NumReg
				RETURN _TALLY
			ELSE
				RETURN EMPTY(_TALLY)
			ENDIF
		ELSE
		** VETT  25/08/2014 12:59 PM :  No esta definida o no se encontro la tabla o cursor
			IF Pl_NumReg
				RETURN -1
			ELSE
				RETURN .T.
			ENDIF
		ENDIF

		*!*		SELE (Pc_Tabla)
		*!*		COUNT ALL TO LnNumReg FOR !DELETED()
		*!*		IF NOT EMPTY(LcArea_act) AND NOT Pc_Tabla==LcArea_act
		*!*			SELE (LcArea_Act)
		*!*			IF LnNumReg>0 AND NOT EOF() AND RECNO()#LnNumReg
		*!*				GO LnNumReg
		*!*			ENDIF
		*!*		ENDIF
		*!*		RETURN LnNumReg<=0
		*!*	ELSE
		*!*		RETURN .T.
		*!*	ENDIF
	ENDPROC


	*-- Altera la estructura de una tabla
	PROCEDURE modificatabla
		PARAMETERS _cAliasNombre,_cAccion,_cCampo,_cTipo,_nLongitud,_nPrecision

		** Por mejorar para todos los casos de modificacion de estrucuturas de tablas por ahora solo Agrega campos
		** Tipo C,N ,L,D,T


		IF PCOUNT()<4
			RETURN -1
		ENDIF
		IF EMPTY(_cAliasNombre) OR ISNULL(_cAliasNombre)
			IF !EMPTY(ALIAS())
				_CAliasNombre = ALIAS()
			ELSE
				_CAliasNombre = ''
			ENDIF
		ENDIF

		IF EMPTY(_cAliasNombre)
			RETURN -1
		ENDIF
		_cAccion = UPPER(_cAccion)
		LOCAL LsTipoLonPrec
		DO CASE
			CASE _cTipo='C'
				LsTipoLonPrec=' C('+TRANSFORM(_nLongitud,"@L 99")+')'
			CASE INLIST(_cTipo,'N','F')
				IF _nPrecision<=0
					LsTipoLonPrec=' N('+TRANSFORM(_nLongitud,"@L 99")+')'
				ELSE
					LsTipoLonPrec=' N('+TRANSFORM(_nLongitud,"@L 99")+','+TRANSFORM(_nPrecision,"@L 99")+')'
				ENDIF
			CASE _cTipo='L'
				LsTipoLonPrec=' L '
			CASE INLIST(_cTipo,'D','T')
				LsTipoLonPrec=' '+_cTipo+' '
			OTHERWISE

		ENDCASE

		DO CASE
			CASE	_cAccion = 'AGREGAR' 
				ALTER TABLE (_cAliasNombre) ADD COLUMN &_cCampo &LsTipoLonPrec
			CASE	_cAccion = 'BORRAR'

			CASE	_cAccion = 'MODIFICA'
		ENDCASE

		RETURN 1
	ENDPROC


	*-- Abrir archivo externo (DOC, XLS, PDF)
	PROCEDURE openfileext
		PARAMETERS PcFileName
		IF VARTYPE(PcFileName)<>'C'
			PcFileName = ''
		ENDIF
		IF EMPTY(PcFileName)
			RETURN 
		ENDIF
		DECLARE INTEGER ShellExecute IN shell32.dll ;
		INTEGER hndWin, ;
		STRING cAction, ;
		STRING cFileName, ;
		STRING cParams, ;
		STRING cDir, ;
		INTEGER nShowWin
		*!*	cFileName = "c:\GenLed\Images\CC.pdf"
		cAction = "open"
		ShellExecute(0,cAction,PcFileName,"","",1)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: util
**************************************************
