===============================================================================
===========================onegocios.ejecuta_transaccion=======================
===============================================================================
PARAMETERS ;
cQue_Transaccion as string, ;
cQue_Accion AS String 
**PROCEDURE xGraba
LOCAL LnOkTrn, LnOk AS Integer 
LnOkTrn = S_OK		&& Definido en CONST.H , debe estar incluido en la clase o via codigo #INCLUDE CONST.H

this.que_transaccion =	cQue_Transaccion
** NOTA > Solo es crear y genera SIEMPRE correlativos **
**
DO CASE
	CASE cQue_transaccion = 'ALMACEN'

	CASE cQue_transaccion = 'VENTAS'
		
		*!*	IF !(&RegVal.)
		IF THIS.Crear 
			SELECT (this.cAliasCab)		&& GDOC
			IF SEEK(this.cValor_PK ,this.cAliasCab,this.cIndice_PK)
				This.XsNroDoc=this.gen_id('0')
				IF SEEK(this.cValor_PK ,this.cAliasCab,this.cIndice_PK)
				    RETURN REGISTRO_YA_EXISTE
				ENDIF
			ENDIF
			SELECT (THIS.cAliasCab)
			APPEND BLANK
			REPLACE TpoDoc WITH THIS.XsTpodoc 
			REPLACE CodDoc WITH this.XsCodDoc
			REPLACE NroDoc WITH this.XsNroDoc
			=this.gen_id(this.XsNroDoc)
*!*				REPLACE 
			IF VerifyVar('UserCrea','','CAMPO',THIS.cAliasCab)
				REPLACE UserCrea WITH GoEntorno.User.Login
			ENDIF	
			IF VerifyVar('FchCrea','','CAMPO',THIS.cAliasCab)	
				REPLACE FchCrea WITH DATETIME()
			ENDIF
		ELSE
			SELECT (THIS.cAliasCab)
			=SEEK(this.cValor_PK ,this.cAliasCab,this.cIndice_PK)
			IF ! RLOCK()
				RETURN -1
			ENDIF
		ENDIF
		**************
		SELECT (THIS.cAliasCab)
		REPLACE PtoVta	WITH EVALUATE(this.ccursor_c+'.PtoVta')
		REPLACE FchDoc WITH EVALUATE(this.ccursor_c+'.fchdoc')
		REPLACE FchVto WITH EVALUATE(this.ccursor_c+'.FchVto')
		REPLACE CodVen WITH EVALUATE(this.ccursor_c+'.CodVen')
		REPLACE TablDest WITH EVALUATE(this.ccursor_c+'.TablDest')
		REPLACE Destino WITH EVALUATE(this.ccursor_c+'.Destino')
		REPLACE TablVia WITH EVALUATE(this.ccursor_c+'.TablVia')
		REPLACE Via		WITH EVALUATE(this.ccursor_c+'.Via')
		REPLACE DiaVto WITH EVALUATE(this.ccursor_c+'.DiaVto')
		REPLACE NroPed WITH EVALUATE(this.ccursor_c+'.NroPed')
		IF !INLIST(this.XsCoddoc,'PEDI') && AND !INLIST(this.XsCoddoc,'PROF')
			Replace FchVto WITH FchDoc + DiaVto
			IF FIELD('FCHPED')='FCHPED'
				REPLACE FchPed WITH EVALUATE(this.ccursor_c+'.FchPed')
			ENDIF
		ELSE
			REPLACE FchVto WITH EVALUATE(this.ccursor_c+'.FchVto')
		ENDIF
		REPLACE NroO_C WITH EVALUATE(this.ccursor_c+'.NroO_C')
		REPLACE FchO_C WITH EVALUATE(this.ccursor_c+'.FchO_C')
		REPLACE FmaPgo WITH EVALUATE(this.ccursor_c+'.FmaPgo')
		REPLACE FmaSol WITH EVALUATE(this.ccursor_c+'.FmaSol')
		REPLACE CndPgo WITH EVALUATE(this.ccursor_c+'.CndPgo')
		REPLACE Ruta   WITH EVALUATE(this.ccursor_c+'.Ruta')
		IF This.Tag='REGULA_CCB' && No afecta importes, detalle ni contabilidad			
			SELECT (THIS.cAliasCab)
			UNLOCK 
			RETURN
		ENDIF
		REPLACE CodCli WITH EVALUATE(this.ccursor_c+'.CodCli')
		REPLACE NomCli WITH EVALUATE(this.ccursor_c+'.NomCli')
		REPLACE CodDire WITH EVALUATE(this.ccursor_c+'.CodDire')
		REPLACE DirCli WITH EVALUATE(this.ccursor_c+'.DirCli')
		REPLACE RucCli WITH EVALUATE(this.ccursor_c+'.RucCli')
		REPLACE CodMon WITH EVALUATE(this.ccursor_c+'.CodMon')
		REPLACE TpoCmb WITH EVALUATE(this.ccursor_c+'.TpoCmb')
		REPLACE PorIgv WITH EVALUATE(this.ccursor_c+'.PorIgv')
		REPLACE PorDto WITH EVALUATE(this.ccursor_c+'.PorDto')
		REPLACE ImpBto WITH EVALUATE(this.ccursor_c+'.ImpBto')
		REPLACE ImpDto WITH EVALUATE(this.ccursor_c+'.ImpDto')
		REPLACE TpoVta	WITH EVALUATE(this.ccursor_c+'.TpoVta')
		REPLACE ImpInt WITH EVALUATE(this.ccursor_c+'.ImpInt')
		REPLACE ImpGas WITH EVALUATE(this.ccursor_c+'.ImpGas')
		REPLACE ImpFlt WITH EVALUATE(this.ccursor_c+'.ImpFlt')
		REPLACE ImpSeg WITH EVALUATE(this.ccursor_c+'.ImpSeg')
		REPLACE ImpAdm WITH EVALUATE(this.ccursor_c+'.ImpAdm')
		REPLACE ImpIgv  WITH EVALUATE(this.ccursor_c+'.ImpIgv')
		REPLACE ImpTot  WITH EVALUATE(this.ccursor_c+'.ImpTot')
		REPLACE ImpNet  WITH EVALUATE(this.ccursor_c+'.ImpTot')
		REPLACE SdoDoc  WITH IIF(THIS.Crear ,EVALUATE(this.ccursor_c+'.ImpTot'),EVALUATE(this.ccursor_c+'.SdoDoc'))
		REPLACE GloDoc  WITH EVALUATE(this.ccursor_c+'.GloDoc')
		REPLACE FlgEst  WITH EVALUATE(this.ccursor_c+'.FlgEst')
		REPLACE FlgUbc  WITH EVALUATE(this.ccursor_c+'.FlgUbc')
		replace Glosa2  WITH EVALUATE(this.ccursor_c+'.Glosa2')
		REPLACE TpoRef  WITH this.XsTpoRef
		REPLACE CodRef	WITH this.XsCodRef
		REPLACE NroRef	WITH this.XsNroRef
		IF FIELD('RETEN')='RETEN'
			replace Reten  WITH EVALUATE(this.ccursor_c+'.Reten')
		ENDIF
		IF FIELD('AGENTE')='AGENTE'
			replace Agente  WITH EVALUATE(this.ccursor_c+'.Agente')
		ENDIF
		** Cotizacion **
		IF INLIST(this.XsCoddoc,'COTI')		
			replace CodCta   WITH EVALUATE(this.ccursor_c+'.CodCta')
			replace Despacho WITH EVALUATE(this.ccursor_c+'.Despacho')
			replace Validez  WITH EVALUATE(this.ccursor_c+'.Validez')
			replace TmpEnt   WITH EVALUATE(this.ccursor_c+'.TmpEnt')
		ENDIF
		** VETT  24/11/2011 05:14 PM :  Orden de servicio EHOLDING ***
		IF INLIST(this.XsCoddoc,'PEDI')	AND UPPER(GsSigCia)='EHOLDING'
			THIS.GrbCmp2Dbf('Clie_Cent','',THIS.cAliasCab,THIS.cCursor_c)	
			THIS.GrbCmp2Dbf('Comi_Cent','',THIS.cAliasCab,THIS.cCursor_c)	
			THIS.GrbCmp2Dbf('Si_No_Cent','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('FchAprob','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('FchVta','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('FchRev','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('FteVta','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('N_Cuotas','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('Plazo','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('Nro_Contr','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('OriServ','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('TipCliServ','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('TpoVta2','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('CodFac','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('FchFin','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('FchIni','',THIS.cAliasCab,THIS.cCursor_c)
			THIS.GrbCmp2Dbf('CodCon','',THIS.cAliasCab,THIS.cCursor_c)
		ENDIF

		IF VerifyVar('UserModi','','CAMPO',THIS.cAliasCab)
			REPLACE UserModi WITH GoEntorno.User.Login
		ENDIF
		IF VerifyVar('FchModi','','CAMPO',THIS.cAliasCab)	
			REPLACE FchModi WITH DATETIME()
		ENDIF
		
		this.graba_detalle_ventas(this.XsCodRef) 
		** ACTUALIZAMOS CONTABILIDAD **
		IF !INLIST(this.XsCoddoc,'PEDI','COTI')
			SELECT  (THIS.cAliasCab)
			SCATTER NAME oData1
			
			*** Convertimos a objeto el cursor con el detalle del documento ***
			oData2 = this.odatadm.genobjdatos(this.ccursor_d)    
			
			cKeyTpoDocSN = THIS.Codsed+This.XsCodDoc+This.XsPtoVta
			LnOk=this.oContab.Actualiza_Contabilidad(cQue_transaccion,cKeyTpoDocSN,@oData1,@oData2)
			
			
			
			IF LnOk = LnOkTrn && No Hay error 
				SELECT  (THIS.cAliasCab)
				REPLACE NroMes	WITH oData1.NroMes
				REPLACE CodOpe	WITH oData1.CodOpe
				REPLACE NroAst	WITH oData1.NroAst
				REPLACE FlgCtb	WITH oData1.FlgCtb
			 
				** VETT  07/07/2017 07:57 PM : Llamemos a nuestro amiguito FACTURADOR SEE - SFS
				this.envio_see_sfs_v1 && with oData1 , oData2, oData1,This.RutaSEE_SFS
				
			ELSE
				** VETT:Redireccionado los mensajes de error 2021/05/21 11:13:52 ** 
				
			ENDIF
		ENDIF
		* * *
		SELECT (THIS.cAliasCab)
		UNLOCK 
		** VETT:Respetamos la variable de control de estado de la transsacción 2021/05/21 12:12:34 ** 
		LnOkTrn = LnOk
	CASE cQue_transaccion = 'CJA_INGRESO_LIQ_CCB'
		SELECT (this.caliascab)
		LsLiqui= EVALUATE(this.ccursor_c+'.Liqui')
		SEEK LsLiqui
		IF FOUND() AND RLOCK()
			REPLACE TpoCmb WITH EVALUATE(this.ccursor_c+'.TpoCmb')
		ENDIF
		SELECT (this.ccursor_c)
		SCATTER NAME oData1  && Solo necesitamos el registro de la Liquidacion 
		** Codigo para actualizar cabecera de transaccion
		
		*SELECT (this.caliasdet)
		** Codigo para actualizar detalle de transaccion
		
		*SELECT (this.caliasdet_det)
		** Codigo para actualizar detalle del detalle de transaccion
		** Capturamos en objetos todos los registros de los cursores para enviarlos 
		** A la rutina principal de actualizacion contable. 
		
		oData2 = this.odatadm.genobjdatos(this.ccursor_d)    
		oData3 = this.odatadm.genobjdatos(this.ccursor_d_d)
			
		cKeyTpoDocSN =''
		**
		LnOk=this.oContab.Actualiza_Contabilidad(cQue_transaccion,cKeyTpoDocSN,@oData1,@oData2,@oData3)			
		IF LnOk = LnOkTrn && No Hay error 
			SELECT (this.caliascab)
				IF VARTYPE(NroMes)= 'C'
					REPLACE NroMes  WITH oData1.NroMes
				ENDIF
				REPLACE CodOpe  WITH oData1.CodOpe
				REPLACE Asiento WITH oData1.Asiento
				REPLACE Flag1 WITH .T.
				REPLACE Flag2 WITH .T.
				replace Fecha WITH oData1.fecha
			SELECT (this.ccursor_c )	
				IF VARTYPE(NroMes)= 'C'
					REPLACE NroMes  WITH oData1.NroMes
				ENDIF
				REPLACE CodOpe  WITH oData1.CodOpe
				REPLACE Asiento WITH oData1.Asiento
				REPLACE Flag1 WITH .T.
				REPLACE Flag2 WITH .T.
			
		ENDIF
		
ENDCASE

RETURN LnOk


===============================================================================
=========================Contabilidad.actualiza_contabilidad===================
===============================================================================