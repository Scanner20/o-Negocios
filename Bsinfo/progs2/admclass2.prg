PARAMETERS _classLibRut,_ClassAnt,_ClassNew
SELECT 0
USE (_classLibRut) excl
LnActu = 0
IF !EMPTY(_ClassAnt)
	SET FILTER TO _ClassAnt$classloc
ENDIF

SCAN
	LnActu = LnActu + 1
	STORE '' TO LsClass ,LsClassLoc
	DO CASE 
		CASE UPPER(BaseClass)=='FORM'
			LsClass = "Base_form"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
		CASE UPPER(BaseClass)=='GRID'
			LsClass = "Base_grid"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
		CASE UPPER(BaseClass)=='LABEL'
			LsClass = "Base_label"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
		CASE UPPER(BaseClass)=='TEXTBOX'
			LsClass = "Base_textbox"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"			
		CASE UPPER(BaseClass)=='CONTAINER'
			LsClass = "Base_container"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
		CASE UPPER(BaseClass)=='COMBOBOX'
			LsClass = "Base_CboHelp"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
		CASE UPPER(BaseClass)=='CHECKBOX'
			LsClass = "Base_Checkbox"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
		CASE UPPER(BaseClass)=='SHAPE'
			LsClass = "Base_Shape"
			LsClassLoc = "..\..\classgen\vcxs\admvrs.vcx"
			
		CASE UPPER(BaseClass)=='COMMANDBUTTON'
			LsClass = "CmdProcesar"
			LsClassLoc = "..\..\classgen\vcxs\admgral.vcx"
	ENDCASE
	IF !EMPTY(LsClass)
		replace Class 	 WITH  LsClass 
	ENDIF
	IF !EMPTY(LsClassLoc)
		REPLACE classloc WITH LsClassLoc   
	ENDIF
	DO xAdmClass3 WITH  BaseClass
ENDSCAN 
USE
WAIT WINDOW TRANSFORM(LnActu,'99,999') + ' Actualizaciones' NOWAIT  
********************
PROCEDURE xAdmClass3
********************
PARAMETERS _BaseClass
DO CASE 
	CASE UPPER(_BaseClass) == 'FORM'
		lnSettings = ALines( laSettings, Properties )
		* Find the Picture Propertie
		lnPropLine = ASCAN( laSettings, "Picture",1,0,0,4)
		* Change it to Picture = ''
		IF LnPropLine>0
			laSettings( lnPropLine ) = "Picture = ''" 
		ENDIF
		* Build a new Expr string out of the array
		lcExpr = ""
		For lnSetting = 1 to lnSettings
			IF LnSetting = lnPropLine
				** La obviamos para que tome el valor por defecto
			ELSE
				lcExpr = lcExpr + laSettings( lnSetting ) + Chr(13)
			ENDIF
		EndFor

		* store the new Expr
		Replace Properties with lcExpr
	CASE UPPER(_BaseClass) == 'HEADER' 
		lnSettings = ALines( laSettings, Properties )
		* Find the Picture Propertie
		lnPropLine = ASCAN( laSettings, "BackColor",1,0,0,4)
		* Change it to BackColor = ''
		IF LnPropLine>0
			laSettings( lnPropLine ) = "BackColor = ''" 
		ENDIF
		* Build a new Expr string out of the array
		lcExpr = ""
		For lnSetting = 1 to lnSettings
			IF LnSetting = lnPropLine
				** La obviamos para que tome el valor por defecto
			ELSE
				lcExpr = lcExpr + laSettings( lnSetting ) + Chr(13)
			ENDIF
		EndFor

		* store the new Expr
		Replace Properties with lcExpr
	CASE UPPER(_BaseClass) == 'COMMANDBUTTON' 
		lnSettings = ALines( laSettings, Properties )
		* Find the Picture Propertie
		
		lnPropLine = ASCAN( laSettings, "Picture",1,0,0,4)
		* Change it to Picture = ''
		IF LnPropLine>0
			laSettings( lnPropLine ) = "Picture = ''" 
		ENDIF
		* Build a new Expr string out of the array
		lcExpr = ""
		For lnSetting = 1 to lnSettings
			 
			IF LnSetting = lnPropLine
				** La obviamos para que tome el valor por defecto
			ELSE
				lcExpr = lcExpr + laSettings( lnSetting ) + Chr(13)
			ENDIF
		EndFor
		** Chequeamos si existe SpecialEffect
		lnPropLine2 = ASCAN( laSettings, "SpecialEffect",1,0,0,4)
		IF LnPropLine2<=0
			LcExpr = LcExpr + "SpecialEffect = 2"
		ENDIF
		** Chequeamos si existe PicturePosition
		lnPropLine3 = ASCAN( laSettings, "PicturePosition",1,0,0,4)
		IF LnPropLine3<=0
			LcExpr = LcExpr + "PicturePosition = 7"
		ENDIF
		
		lnPropLine4 = ASCAN( laSettings, "Caption",1,0,0,4)		
		lnPropLine5 = ASCAN( laSettings, "ToolTipText",1,0,0,4)
		IF (LnPropLine4>0 AND 'Grabar' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Grabar' $ LaSettings(lnPropLine5))
			REPLACE Class WITH 'CmdGrabar'
		ENDIF
		IF (LnPropLine4>0 AND 'Nuevo' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Nuevo' $ LaSettings(lnPropLine5) )
			REPLACE Class WITH 'CmdNuevo'
		ENDIF
		IF 	(LnPropLine4>0 AND 'Agregar' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Agregar' $ LaSettings(lnPropLine5))
			REPLACE Class WITH 'CmdNuevo_Detalle'
		ENDIF

		IF (LnPropLine4>0 AND 'Cancelar' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Cancelar' $ LaSettings(lnPropLine5))
			REPLACE Class WITH 'CmdCancelar'
		ENDIF
		
		IF (LnPropLine4>0 AND 'Anular' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Anular' $ LaSettings(lnPropLine5))
			REPLACE Class WITH 'CmdCancelar'
		ENDIF

		IF (LnPropLine4>0 AND 'Quitar' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Quitar' $ LaSettings(lnPropLine5))
			REPLACE Class WITH 'CmdEliminar'
		ENDIF
		IF (LnPropLine4>0 AND 'Salir' $ LaSettings(lnPropLine4)) OR (LnPropLine5>0 AND 'Salir' $ LaSettings(lnPropLine5))
			REPLACE Class WITH 'CmdSalir'
		ENDIF

		* store the new Expr
		Replace Properties with lcExpr
	
	
	
ENDCASE