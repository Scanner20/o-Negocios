** FACTURA ***
	PROCEDURE vincular_controles
		LOCAL LcAlmacen,LcTipMov,LcCodMov,LcNroDoc,LcTabla,LlExiste

		Public LoDatAdm as dataadmin OF  SYS(5)+"\aplvfp\classgen\vcxs\dosvr.vcx" 
		LoDatAdm = CREATEOBJECT('DOSVR.DataAdmin') 
		thisform.LockScreen = .T. 
		WITH THISFORM

			DO CASE 
				CASE thisform.que_transaccion ='ALMACEN'
					THISFORM.Vincular_controles_almacen 
				CASE thisform.que_transaccion = 'VENTAS'
					thisform.Vincular_controles_ventas 
			ENDCASE

			WITH thisform.PgfDetalle.Page1
				.cmdAdicionar1.ENABLED	= (thisform.xReturn<> 'E' AND ( thisform.objreftran.XsCodRef = 'FREE' or INLIST(thisform.objreftran.XsCodDoc ,'PEDI','PROF','COTI') ) )
				LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(THISFORM.cCursor_D)
				.cmdModificar1.ENABLED	= (LlHayRegistros AND THISFORM.XRETURN<>'E')
				.cmdEliminar1.ENABLED	= LlHayRegistros AND (THISFORM.XRETURN<>'E' AND (THISFORM.ObjReftran.XsCodRef='FREE' or INLIST(thisform.objreftran.XsCodDoc ,'PEDI','PROF','COTI') ) )
				IF THISFORM.XRETURN='I'
					.txtPORIGV.Value  = thisform.ObjrefTran.XfPorIgv
				ELSE
					.txtPORIGV.Value  = EVALUATE(THISFORM.cCursor_C+'.PorIgv')
				ENDIF
			ENDWITH

			WITH thisform.PgfDetalle.Page3
				thisform.vincular_detalle()  && Sera ??
				.TxtPreuni.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !INLIST(thisform.objreftran.XsCodDoc ,'PEDI','PROF','COTI')
				.TxtImpCto.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !INLIST(thisform.objreftran.XsCodDoc ,'PEDI','PROF','COTI')
				.LblPreuni.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !INLIST(thisform.objreftran.XsCodDoc ,'PEDI','PROF','COTI')
				.LblImpCto.VISIBLE = (THISFORM.ObjRefTran.lPidPco OR THISFORM.ObjRefTran.lCtoVta)  AND !INLIST(thisform.objreftran.XsCodDoc ,'PEDI','PROF','COTI')
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

		IF INLIST(Thisform.xReturn,'A','E')
			thisform.PgfDetalle.Page1.LblStatus1.Caption  = thisform.ObjRefTran.Est_Doc(EVALUATE(this.cCursor_C+'.FlgEst'))
		ENDIF
		thisform.PgfDetalle.Page1.LblStatus2.Caption  = thisform.PgfDetalle.Page1.LblStatus1.Caption

		IF THISFORM.xReturn ='I'
			&&  ??
		ELSE
			thisform.ObjRefTran.XcFlgEst = EVALUATE(this.cCursor_C+'.FlgEst')
		ENDIF
		RELEASE LoDatAdm
		THISFORM.LockScreen = .F.

		RETURN .t.
	ENDPROC


	PROCEDURE desvincular_controles
		WITH THIS.pgfDetalle.PAGES(1).grdDetalle
			this.pgfDetalle.Page1.TxtNro_itm.Visible	= .f.
			this.pgfDetalle.Page1.TxtNroitm.Visible		= .f.
			this.pgfDetalle.Page1.LblSepTotitm.Visible	= .f. 
			.ColumnCount		= 12
			.RECORDSOURCE		= ""
			.RECORDSOURCETYPE= 4
			.REFRESH()
		ENDWITH
	ENDPROC
	
	
	
	PROCEDURE vincular_detalle
		IF USED(thisform.cCursor_D)
			LlBufferOk=CURSORSETPROP("Buffering",5,this.cCursor_D )
		ENDIF
		this.pgfDetalle.Page1.TxtNro_itm.Visible	= .T.
		this.pgfDetalle.Page1.TxtNroitm.Visible		= .T.
		this.pgfDetalle.Page1.LblSepTotitm.Visible	= .T. 
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
			replace FchDoc WITH thisform.ObjReftran.XdFchDoc
		*!*	ENDIF
		thisform.objreftran.NumEle = RECNO()  && Sera ??

		IF INLIST(thisform.objreftran.XsCodRef , 'FREE' ,'PEDI','PROF','COTI')
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

			.cmdAceptar3.ENABLED			= .F.
			.cmdCancelar3.ENABLED			= .F.
		ENDWITH

		thisform.MostrarLineaCredito('MOSTRAR') 

		*thisform.vincular_detalle() 
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
			IF INLIST(thisform.objreftran.XsCodRef , 'FREE' ,'PEDI','PROF','COTI')
				thisform.objreftran.GiTotItm = thisform.objreftran.GiTotItm - 1
			ENDIF
			LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio(thisform.ccursor_d)
		    IF (THISFORM.ObjRefTran.lpidpco OR THISFORM.ObjRefTran.lCtoVta)
		       THISFORM.Calcular_Totales
		       THISFORM.MostrarLineaCredito('MOSTRAR')
		    ENDIF
		    WITH THISFORM.PgfDetalle.Page1
				.GrdDetalle.REFRESH()
				.CmdModificar1.ENABLED = LlHayRegistros
				.CmdEliminar1.ENABLED  = LlHayRegistros
			ENDWITH
			THISFORM.CmdIMprimir.ENABLED = LlHayRegistros
		ENDIF
	ENDPROC
	** Grabar los cambios realizados en un registro del grid
	PROCEDURE cmdaceptar1.Click
		thisform.LcTipope2 = thisform.xReturn 
		THIS.PARENT.Cmdterminar.Click 
		Thisform.Actualizar_Retencion(Thisform.pgfDetalle.Page1.txtImpTot.Value)
	ENDPROC
	** Descartar los cambios realizados en un registro del grid
	PROCEDURE cmdcancelar1.Click
		thisform.Cancelar_trn_detalle(thisform.ccursor_d)  
		THISFORM.Lctipope2 = 'C'
		THIS.PARENT.Cmdterminar.Click
	ENDPROC

*-- Confirmar transaccion en el detalle
	PROCEDURE confirma_trn_detalle
		PARAMETERS LsAlias
		IF !USED(LsAlias)
			RETURN .f.
		ENDIF
		LOCAL LlOk
		LlOk=TABLEUPDATE(0,.F.,LsAlias)
		RETURN LlOk
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