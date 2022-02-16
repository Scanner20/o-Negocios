**************************************************
*-- Class Library:  k:\aplvfp\classgen\vcxs\o-nlib.vcx
**************************************************


**************************************************
*-- Class:        base_cmdhelp_multiselect (k:\aplvfp\classgen\vcxs\o-nlib.vcx)
*-- ParentClass:  base_cmdhelp (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/21/11 12:02:12 PM
*
DEFINE CLASS base_cmdhelp_multiselect AS base_cmdhelp


	*-- Cursor que contendra los item seleccionados
	caliascursorseleccionados = (SYS(2015))
	_memberdata = [<VFPData><memberdata name="odata" type="property" display="oData"/><memberdata name="caliascursorseleccionados" type="property" display="caliasCursorSeleccionados"/></VFPData>]
	multi_select = .T.
	Name = "base_cmdhelp_multiselect"


	PROCEDURE Click
		LOCAL loBoton
		SET TALK OFF

		THIS.GenerarWHERE()

		DO CASE
			CASE THIS.cModoObtenerDatos = "V"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, (THIS), THIS.multi_select 
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, (THIS), THIS.multi_select 
				ENDIF
			CASE THIS.cModoObtenerDatos = "L"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, (THIS), THIS.multi_select 
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, (THIS), THIS.multi_select 
				ENDIF
			CASE THIS.cModoObtenerDatos = "R"
				IF THIS.lFlagBusqueda
					DO FORM gen2_Ayuda_Codigo_Criterio WITH THIS.cWhere, (THIS), THIS.multi_select 
				ELSE
					DO FORM gen2_Ayuda_Codigo_Busqueda WITH THIS.cWhere, (THIS), THIS.multi_select 
				ENDIF
		ENDCASE
		IF VARTYPE(THIS.oData)='O' && Se ha generado el objeto en base a datos
			IF This.multi_select 
				** El objeto oData contiene un arreglo con los registros seleccionados
				** Los convertimos a un cursor y lo guardamos en cAliasCursorSeleccionados
				LOCAL Loda as dataadmin OF dosvr
				Loda=CREATEOBJECT('Dosvr.dataadmin')
				Loda.obj2cur(this.oData ,This.caliasCursorSeleccionados)
			ELSE
				** El objeto oData contiene el registro seleccionado
				** Invocarlo asi: oData.Campo1, oDato.Campo2, etc
			ENDIF
		ENDIF
		RELEASE Loda
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_cmdhelp_multiselect
**************************************************


**************************************************
*-- Class:        base_texbox_ctapre (k:\aplvfp\classgen\vcxs\o-nlib.vcx)
*-- ParentClass:  base_textbox (k:\aplvfp\classgen\vcxs\admvrs.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/17/07 10:48:06 PM
*
DEFINE CLASS base_texbox_ctapre AS base_textbox


	Name = "base_texbox_codpres"


	PROCEDURE DblClick
		KEYBOARD '{F8}' 
	ENDPROC


	PROCEDURE KeyPress
		LPARAMETERS TnKeyCode, TnShiftAltCtrl
		LOCAL lcOldSearchString, lnLength
		*
		* The user has entered some data
		* Save the old search string
		*
		IF this.Parent.Parent.Columns(3).Readonly
			RETURN
		ENDIF

		lcOldSearchString = This.cSearchString

		DO CASE
			CASE (TnKeyCode  = CTRLW OR TnKeyCode  = 103) AND  TnShiftAltCtrl = 2
				UltTecla = TnKeyCode
				IF this.Valid()
					thisform.pgfDetalle.page1.Cmdgrabar1.Click() 
				ENDIF
			CASE TnKeyCode  = F9   
				UltTecla = TnKeyCode
		*		IF this.Valid()
					thisform.pgfDetalle.page1.CmdCancelar1.Click() 
		*		ENDIF

		   CASE tnKeyCode >= 32 AND tnKeyCode <= 126
		      *
		      * Add the character to the current search string
		      *
		      this.cSearchString = this.cSearchString + CHR(tnKeyCode)

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
		   CASE TnKeyCode  = Enter 
		*   		WAIT WINDOW 'Presiono Enter'
				UltTecla = TnKeyCode
		   CASE TnKeyCode  = F8   
		*   		WAIT WINDOW 'Presiono F8'
				UltTecla = TnKeyCode
				this.Parent.CurrentControl='CboCtaPre'
				this.Parent.CboCtaPre.Destroy
				this.Parent.CboCtaPre.Init()  
				this.Parent.CboCtaPre.Generarcursor() 
				this.Parent.CboCtaPre.Value=This.Value
				this.Parent.Parent.refresh
				KEYBOARD '{ENTER}' 


				  

		   OTHERWISE
		      *
		      * Some other key, just do the default actions
		      *
		      This.SelLength = LENC(This.cSearchString)
		      RETURN
		ENDCASE
	ENDPROC


	PROCEDURE Valid
		XsCodPres = this.Value

		RETURN thisform.ValidaCampo('CTAPRE')
	ENDPROC


	PROCEDURE When
		IF !EMPTY(c_RMOV.EliItm)
			RETURN .f.
		ENDIF

		IF C_RMOV.PidPres='S'
			RETURN .T.
		ELSE
			RETURN .F.
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: base_texbox_ctapre
**************************************************


**************************************************
*-- Class:        openfileext (k:\aplvfp\classgen\vcxs\o-nlib.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   01/17/14 03:20:06 PM
*
DEFINE CLASS openfileext AS custom


	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="showpdf" type="method" display="ShowPDF"/></VFPData>]
	Name = "openfileext"


	PROCEDURE openfile
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
*-- EndDefine: openfileext
**************************************************


**************************************************
*-- Class:        sqlcmd (k:\aplvfp\classgen\vcxs\o-nlib.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   03/18/07 11:51:12 PM
*
DEFINE CLASS sqlcmd AS custom


	Height = 12
	Width = 169
	*-- XML Metadata for customizable properties
	_memberdata = [<VFPData><memberdata name="updif" type="method" display="Updif"/></VFPData>]
	Name = "sqlcmd"


	*-- Actualizar si existe el campo en la tabla
	PROCEDURE updif
		PARAMETERS PcCriterio,PcTable,PcCampo,PxValor,PcWhere
		LOCAL LoDatAdm AS DataAdmin OF DoSvr.vcx
		LoDatAdm=CREATEOBJECT('DoSvr.DataAdmin')
		LOCAL LnSelect AS Integer 
		LnSelect = SELECT()
		DO CASE
			CASE	PcCriterio='EXIST'  
					IF !USED(PcTable)
						LoDatAdm.AbrirTabla('ABRIR',PcTable,PcTable,'','')
					ENDIF

					SELECT (PcTable)
					LsCmpTbl= PcTable+'.'+PcCampo
					Lcvariable = 'Ls'+PcCampo 
					&LcVariable = PxValor
					IF FIELD(PcCampo,PcTable)=UPPER(PcCampo)
						LsCmdSql = 'UPDATE '+ PcTable + ' SET '+PcCampo+'= Ls'+PcCampo + ;
						' WHERE '+PcWhere 
						&LsCmdSql.
					ENDIF
		ENDCASE

		SELECT(LnSelect)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: sqlcmd
**************************************************
