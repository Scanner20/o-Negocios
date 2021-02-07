PARAMETERS _BaseClass
DO CASE 
	CASE UPPER(_BaseClass) == 'FORM'
		lnSettings = ALines( laSettings, Properties )
		* Find the Picture Propertie
		lnPropLine = ASCAN( laSettings, "Picture",1,0,0,4)
		* Change it to Picture = ''
		laSettings( lnPropLine ) = "Picture = ''" 
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
		laSettings( lnPropLine ) = "BackColor = ''" 
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
		laSettings( lnPropLine ) = "Picture = ''" 
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
		IF 'Grabar' $ LaSettings(lnPropLine4) OR 'Grabar' $ LaSettings(lnPropLine5)
			REPLACE Class WITH 'CmdGrabar'
		ENDIF
		IF 'Nuevo' $ LaSettings(lnPropLine4) OR 'Nuevo' $ LaSettings(lnPropLine5) 
			REPLACE Class WITH 'CmdNuevo'
		ENDIF
		IF 	'Agregar' $ LaSettings(lnPropLine4) OR 'Agregar' $ LaSettings(lnPropLine5)
			REPLACE Class WITH 'CmdNuevo_Detalle'
		ENDIF

		IF 'Cancelar' $ LaSettings(lnPropLine4) OR 'Cancelar' $ LaSettings(lnPropLine5)
			REPLACE Class WITH 'CmdCancelar'
		ENDIF
		
		IF 'Anular' $ LaSettings(lnPropLine4) OR 'Anular' $ LaSettings(lnPropLine5)
			REPLACE Class WITH 'CmdCancelar'
		ENDIF

		IF 'Quitar' $ LaSettings(lnPropLine4) OR 'Quitar' $ LaSettings(lnPropLine5)
			REPLACE Class WITH 'CmdEliminar'
		ENDIF
		IF 'Salir' $ LaSettings(lnPropLine4) OR 'Salir' $ LaSettings(lnPropLine5)
			REPLACE Class WITH 'CmdSalir'
		ENDIF

		* store the new Expr
		Replace Properties with lcExpr
	
	
	
ENDCASE