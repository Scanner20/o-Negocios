PARAMETERS PoDataCab AS Object, PoDataDet AS Object, PoDataAdi AS Object, PoDataAdi2 AS Object, PsRuta_A AS Character, PsRuta_B AS Character
IF VARTYPE(PsRuta_B) <> "C"
	PsRuta_B = ""
ENDIF
#include const.h
DO CASE 
	CASE VARTYPE(PoDataCab.TpoRf1)='C' AND VARTYPE(PoDataCab.NroRf1)='C'
		LsCodDoc = ICASE(PoDataCab.TpoRf1='FACT','01',PoDataCab.TpoRf1='BOLE','03',PoDataCab.TpoRf1='N/C','07',PoDataCab.TpoRf1='N/D','08',PoDataCab.TpoRf1='G/R','09')
	CASE VARTYPE(PoDataCab.TpoRef)='C' AND VARTYPE(PoDataCab.CodDoc)='C'
		LsCodDoc = ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08',"XX")
	OTHERWISE
		LsCodDoc = ""
ENDCASE
*!*	Los dos modelos de archivos que exige nubefact
LsExtFile1 = ".xml"
LsExtFile2 = ".txt"
LsExtFile3 = ".json"
LsNomArc_TXT = ""
LsNomArc_JSON = ""
LsRuta_A = ""
LlHayCuotas = .F.
*!*	Cargamos la tablas a utilizar
STORE .F. TO LlAliasZonas, LlAliasProv, LlAliasDist, LlAliasTabl, LlAliasGSis, LlAliasSedes, LlAliasCtas
IF !USED("Zona")
	LlAliasZonas = goentorno.open_dbf1("ABRIR","Zonas","Zona","Zona01")
ENDIF
IF !USED("Prov")
	LlAliasProv	= goentorno.open_dbf1("ABRIR","Provincias","Prov","Prov01")
ENDIF
IF !USED("Dist")
	LlAliasDist = goentorno.open_dbf1("ABRIR","Distritos","Dist","DIST01")
ENDIF
IF !USED("GSIS")
	LlAliasGSis	= goentorno.open_dbf1("ABRIR","ALMTGSIS","GSis","TABL01")
ENDIF
IF !USED("MTABL")
	LlAliasTabl	= goentorno.open_dbf1("ABRIR","CBDMTABL","MTabl","TABL01")
ENDIF
IF !USED("SEDES")
	LlAliasSedes = goentorno.open_dbf1("ABRIR","SEDES","Sedes","SEDE01")
ENDIF
IF !USED("CTAS")
	LlAliasCtas	= goentorno.open_dbf1("ABRIR","CBDMCTAS","Ctas","CTAS01")
ENDIF
*!*	Cargamos las variables a utilizar por todos lor pocedure
DO CASE
	CASE INLIST(LsCodDoc,'01','03')
		*!*	MAAV: Generar archivo para factura y Boleta en formato TXT y JSON para NubeFact 23/06/2024 09:09 AM	
		** VETT:<TODO> Falta control de Fecha limite  IDUPD:2079448224-12/11/2024 11:08 AM
		IF PoDataCab.FLgEst="A"  && Anulado 
			DO Genera_Cadena_JSON_Anulacion_FBN	WITH PoDataCab, PsRuta_A, PsRuta_B
		ELSE
			DO Genera_Cadena_TXT_FB WITH PoDataCab, PsRuta_A, PsRuta_B
			DO Genera_Cadena_JSON_FB WITH PoDataCab, PsRuta_A, PsRuta_B
		ENDIF
	CASE INLIST(LsCodDoc,'07','08')
		*!*	MAAV: Generar archivo para las Notas de Credito y Debito en formato TXT y JSON para NubeFact 23/06/2024 09:09 AM	
		** VETT:<TODO> Falta control de Fecha limite  IDUPD:2079448224-12/11/2024 11:08 AM
		IF PoDataCab.FLgEst="A"  && Anulado
			DO Genera_Cadena_JSON_Anulacion_FBN	WITH PoDataCab, PsRuta_A, PsRuta_B
		ELSE
			DO Genera_Cadena_TXT_Not WITH PoDataCab, PsRuta_A, PsRuta_B
			DO Genera_Cadena_JSON_Not WITH PoDataCab, PsRuta_A, PsRuta_B
		ENDIF	
	CASE INLIST(LsCodDoc,'09')
		*!*	MAAV: Generar archivo para la Guía de Remisión Electrónica (GRE) en formato TXT y JSON para NubeFact 23/06/2024 09:09 AM	
		IF PoDataCab.FLgEst="A"  && Anulado
		** VETT:<TODO> ALGUN DIA  IDUPD:2079448224-12/11/2024 11:08 AM
		ELSE
			DO Genera_Cadena_JSON_GRE WITH PoDataCab, PsRuta_A, PsRuta_B
		ENDIF
ENDCASE
*!*	Cargamos mensaje de finalización
sMensaje_TXT = ""
sMensaje_JSON = ""
*!*	Cerramos las tablas
IF USED("Zona") AND llAliasZonas && Arvhivo de los departamentos
	USE IN Zona
ENDIF
IF USED('Prov')	AND llAliasProv && Archivo de las provincias
	USE IN Prov
ENDIF
IF USED('Dist')	AND llAliasDist && Archivo de los distritos
	USE IN Dist
ENDIF
IF USED('GSis')	AND llAliasGSis && Tablas del sistema AlmTGSis
	USE IN GSis
ENDIF
IF USED('MTabl') AND llAliasTabl && Tablas del sistema CbdMTabl
	USE IN MTabl
ENDIF
IF USED("Sedes") AND llAliasSedes && Tablas de las sedes
	USE IN Sedes
ENDIF
IF USED('Ctas') AND LlAliasCtas
	USE IN Ctas
ENDIF
*!*	Cadeta TXT para las facturas y boletas
PROCEDURE Genera_Cadena_TXT_FB
	PARAMETERS PoDataCab, PsRuta_A, PsRuta_B
	sCodDoc = ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08',"XX")
	sLetSer = ICASE(INLIST(PoDataCab.CodDoc,'FACT','BOLE'),LEFT(PoDataCab.CodDoc,1),INLIST(PoDataCab.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodDoc,1),'X')
	sSerie = RIGHT(sLetSer+LTRIM(SUBSTR(PoDataCab.NroDoc,2,3)),4)
	sNomArc = GsRucCia + '-' + sCodDoc + '-' + sSerie + '-' + RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8) + '.txt'
	sNroDoc = sSerie + '-' + RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8)
ENDPROC

*!*	Cadena JSON para las facturas y boletas
PROCEDURE Genera_Cadena_JSON_FB
	PARAMETERS PoDataCab, PsRuta_A, PsRuta_B
	sCodDoc = ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08',"XX")
	sLetSer = ICASE(INLIST(PoDataCab.CodDoc,'FACT','BOLE'),LEFT(PoDataCab.CodDoc,1),INLIST(PoDataCab.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodDoc,1),'X')
	sSerie = RIGHT(sLetSer+LTRIM(SUBSTR(PoDataCab.NroDoc,2,3)),4)
	sNomArc_JSON = GsRucCia + '-' + sCodDoc + '-' + sSerie + '-' + RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8) + '.json'
	sNroDoc = sSerie + '-' + RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8)
	sRuta_A = ADDBS(TRIM(PsRuta_A)) && curdir()+lruta   
	IF !DIRECTORY(sRuta_A)
		MKDIR (sRuta_A)
	ENDIF	
	IF FILE(sRuta_A + sNomArc_JSON)
		DELETE FILE (sRuta_A + sNomArc_JSON)
	ENDIF
	nControlArc_JSON = FCREATE(sRuta_A + sNomArc_JSON)
	IF nControlArc_JSON < 0
		=MESSAGEBOX("Error en la creación de " + sRuta_A + sNomArc_JSON, 48, 'Atención')
		RETURN .F.
	ENDIF
	goCfgVta.oDatAdm.Obj2Cur(PoDataDet,'cDVta')
	nTotItmDoc = Cursor_Esta_Vacio("cDVta", .T.)
	IF VARTYPE(nTotItmDoc) <> "N"
		nTotItmDoc = 0
	ENDIF
	STORE 0 TO nTDocAdj, nCuotas, nGuias, nDocAdi 
	goCfgVta.oDatAdm.Obj2Cur(PoDataAdi,'cGuias')	
	nGuias = Cursor_Esta_Vacio("cGuias",.T.)
	IF gocfgvta.L_VtaRCuot
		goCfgVta.oDatAdm.Obj2Cur(PoDataAdi2,'cCuotas')	
		nCuotas = Cursor_Esta_Vacio("cCuotas",.t.)
	ELSE
		nCuotas = 0
	ENDIF
	nCuotas = IIF(nCuotas<0,0,nCuotas)
	SELECT 0
	SELECT NroDoc, SPACE(2) AS CdSunat FROM cDvta WHERE 0 > 1 INTO CURSOR cDocAdi
	nDocAdi = Cursor_Esta_Vacio("cDocAdi", .T.)
	nTDocAdj = nGuias + nCuotas + nDocAdi
	lDocAdj	= nTDocAdj > 0 
	*!*	Datos adicionales
	STORE "" TO sCodFac, sCodRef
	IF nGuias > 0
		sCodRef = ICASE(cGuias.CodDoc='FACT','01',cGuias.CodDoc='BOLE','03',cGuias.CodDoc='N/C','07',cGuias.CodDoc='N/D','08',cGuias.CodDoc='G/R','09',"YY")
		sNroRef = cGuias.NroDoc
	ENDIF
	IF nCuotas > 0
		sCodFac = ICASE(cCuotas.CodDoc='FACT','01',cCuotas.CodDoc='BOLE','03',cCuotas.CodDoc='N/C','07',cCuotas.CodDoc='N/D','08',cCuotas.CodDoc='G/R','09',"YY")
		sNroFac = cCuotas.NroDoc
	ENDIF
	sDesDRel = ICASE(sCodRef='01','FACTURA',sCodRef='03','BOLETA',sCodRef='09','GUIA REMISION REMITENTE','OTROS DOCUMENTOS')
	sCdPaisD = "PE"
	DIMENSION aFila(30)
	*!*	Cargamos las variables del documento
	sOperacion = "generar_comprobante"
	sTipoComprobante = ICASE(PoDataCab.CodDoc='FACT','1', PoDataCab.CodDoc='BOLE','2', PoDataCab.CodDoc='N/C','3', PoDataCab.CodDoc='N/D','4','0')
	sSerieDocumento = sSerie
	sNumero = ALLTRIM(STR(VAL(SUBSTR(PoDataCab.NroDoc,5,10)),10,0))
	sSunatTransac = "1"
	sClienteTpoDocIden = ICASE(LEN(trim(PoDataCab.CodCli))=11,'6',LEN(TRIM(PoDataCab.CodCli))=8,'1','4')
	sClienteNroDocIden = ALLTRIM(PoDataCab.CodCli)
	sClienteNombre = ALLTRIM(PoDataCab.NomCli)
	sClienteDireccion = ALLTRIM(PoDataCab.DirCli)
	sClienteEMail01 = ALLTRIM(cGuias.EmailDest)
	sClienteEMail02 = ""
	sClienteEMail03 = ""
	sFechaEmision = LEFT(DTOC(PoDataCab.FchDoc),2) + "-" + SUBSTR(DTOC(PoDataCab.FchDoc),4,2) + "-" + SUBSTR(DTOC(PoDataCab.FchDoc),7,4)
	sFechaVcto = LEFT(DTOC(PoDataCab.FchVto),2) + "-" + SUBSTR(DTOC(PoDataCab.FchVto),4,2) + "-" + SUBSTR(DTOC(PoDataCab.FchVto),7,4)
	sMoneda = ICASE(PoDataCab.CodMon=1,'1',PoDataCab.CodMon=2,'2',PoDataCab.CodMon=3,'3','4')
	sTipoCambio = IIF(sMoneda='1',"",ALLTRIM(STR(PoDataCab.TpoCmb,10,3)))
	sPorIGV = ALLTRIM(STR(PoDataCab.PorIgv,10,2))
	sDescuentoGlobal = IIF(PoDataCab.ImpDto<>0.00,ALLTRIM(STR(PoDataCab.ImpDto,10,2)),'')
	sTotalDescuento = IIF(PoDataCab.ImpDto<>0.00,ALLTRIM(STR(PoDataCab.ImpDto,10,2)),'')
	sTotalAnticipo = ""
	sTotalGravada = ALLTRIM(STR(PoDataCab.ImpBto,10,2))
	sTotalInafecta = ""
	sTotalExonerada = ""
	sTotalIGV = ALLTRIM(STR(PoDataCab.ImpIgv,10,2))
	sTotalGratuita = ""
	sTotalOtrosCargos = ""
	fTotAnti = 0.00
	nTotalDocumento = PoDataCab.ImpBto + PoDataCab.ImpIgv + PoDataCab.ImpAdm - PoDataCab.ImpDto - fTotAnti
	sTotalDocumento = ALLTRIM(STR(nTotalDocumento,16,2))
	sPercepcionTipo = ""
	sPercepcionBaseImponible = ""
	sTotalPercepcion = ""
	sTotalIncluidoPercepcion = ""
	IF PoDataCab.Reten = 0
		sRetencionTipo = ""
		sRetencionBaseImponible = ""
		sTotalRetencion = ""
	ELSE
		sRetencionTipo = "1"
		sRetencionBaseImponible = ALLTRIM(STR(nTotalDocumento,16,2))
		sTotalRetencion = ALLTRIM(STR(PoDataCab.Reten,16,2))
	ENDIF
	sTotalImpBolsas = ""
	sDetraccion = "false" && Por el momento le pongo falso pero puede cambiar
	sObservaciones = "" && Cual es el campo que tiene las observaciones
	sTpoDocModifica = ""
	sSerDocModifica = ""
	sNroDocModifica = ""
	sTpoNotaCredito = ""
	sTpoNotaDebito = ""
	sEnviarAutoSunat = "true"
	sEnviarAutoCliente = "false"
	sCodigoUnico = ""
	** VETT: Medio de pago IDUPD:4071957517-21/08/2024 05:59 PM 
	LnDiaVto = PoDataCab.Diavto
	sCondPago = ALLTRIM(PoDataCab.CndPgo)
	sMedioPago = ICASE(sCondPago="C/E","Contado",LnDiavto>0 and !empty(sCondPago),"Credito")
	sPlacaVehiculo = ""
	sOCServicio = ""
	sTablaPersoCodigo = ""
	sFormatoPDF = "A4"
	LOCAL MiCadenaJSON
	MiCadenaJSON = ""
	MiCadenaJSON = MiCadenaJSON + '{' + CRLF && Apertura de llave para el inicio del proceso
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"operacion": "' + sOperacion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tipo_de_comprobante": ' + sTipoComprobante + ',' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"serie": "' + sSerieDocumento + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"numero": "' + sNumero + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"sunat_transaction": ' + sSunatTransac + ',' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_tipo_de_documento": ' + sClienteTpoDocIden + ',' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_numero_de_documento": "' + sClienteNroDocIden + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_denominacion": "' + sClienteNombre + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_direccion": "' + sClienteDireccion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_email": "' + sClienteEMail01 + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_email_1": "' + sClienteEMail02 + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_email_2": "' + sClienteEMail03 + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"fecha_de_emision": "' + sFechaEmision + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"fecha_de_vencimiento": "' + sFechaVcto + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"moneda": "' + sMoneda + '",' + CRLF && Fijarse aca en el archivo ejemplo esta de una forma y en el manual de otra (")
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tipo_de_cambio": "' + sTipoCambio + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"porcentaje_de_igv": "' + sPorIGV + '",' + CRLF && Fijarse aca en el archivo ejemplo esta de una forma y en el manual de otra (")
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"descuento_global": "' + sDescuentoGlobal + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_descuento": "' + sTotalDescuento + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_anticipo": "' + sTotalAnticipo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_gravada": "' + sTotalGravada + '",' + CRLF && Mismo problema que el anterior
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_inafecta": "' + sTotalAnticipo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_exonerada": "' + sTotalExonerada + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_igv": "' + sTotalIGV + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_gratuita": "' + sTotalGratuita + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_otros_cargos": "' + sTotalOtrosCargos + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total": "' + sTotalDocumento + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"percepcion_tipo": "' + sPercepcionTipo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"percepcion_base_imponible": "' + sPercepcionBaseImponible + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_percepcion": "' + sTotalPercepcion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_incluido_percepcion": "' + sTotalIncluidoPercepcion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"retencion_tipo": "' + sRetencionTipo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"retencion_base_imponible": "' + sRetencionBaseImponible + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"total_retencion": "' + sTotalRetencion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"detraccion": "' + sDetraccion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"observaciones": "' + sObservaciones + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"documento_que_se_modifica_tipo": "' + sTpoDocModifica + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"documento_que_se_modifica_serie": "' + sSerDocModifica + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"documento_que_se_modifica_numero": "' + sNroDocModifica + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tipo_de_nota_de_credito": "' + sTpoNotaCredito + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tipo_de_nota_de_debito": "' + sTpoNotaDebito + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"enviar_automaticamente_a_la_sunat": "' + sEnviarAutoSunat + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"enviar_automaticamente_al_cliente": "' + sEnviarAutoCliente + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"codigo_unico": "' + sCodigoUnico + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"condiciones_de_pago": "' + sCondPago + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"medio_de_pago": "' + sMedioPago + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"placa_vehiculo": "' + sPlacaVehiculo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"orden_compra_servicio": "' + sOCServicio + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tabla_personalizada_codigo": "' + sTablaPersoCodigo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"formato_de_pdf": "' + sFormatoPDF + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"items": [' + CRLF
	SELECT CDVta
	GO TOP
	SCAN
		*!*	Cargamos las variables del el detalle:
		sUnidadMedida = ALLTRIM(ICASE(cDVta.UndVta='KG','KGM',cDVta.UndVta='MTS','MTR',cDVta.UndVta='ROL','RO','NIU'))
		sCodMat = ALLTRIM(cDVta.CodMat)
		sDesMat = ALLTRIM(cDVta.DesMat)
		sCantidad = ALLTRIM(STR(cDVta.CanFac,16,4))
		sValUni = ALLTRIM(STR(cDVta.PreUni,16,2))
		sPreUni = ALLTRIM(STR(VAL(sValUni) * (PoDataCab.PorIGV/100+1),16,2))
		sDescuento = ALLTRIM(STR(d1+d2+d3,16,2))
		sSubTotal = ALLTRIM(STR(cDVta.PreUni*cDVta.CanFac,16,2))
		sTipoIGV = "1"
		sIGV = ALLTRIM(STR((VAL(sValUni) * (PoDataCab.PorIGV/100+1)-VAL(sValUni))*cDVta.CanFac,16,2))
		sTotal = ALLTRIM(STR((cDVta.PreUni*cDVta.CanFac)+VAL(ALLTRIM(STR((VAL(sValUni) * (PoDataCab.PorIGV/100+1)-VAL(sValUni))*cDVta.CanFac,16,2))),16,2))
		*!*	Colocamos las variables en orden del archivo solicitado:
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '{' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"unidad_de_medida": "' + sUnidadMedida + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"codigo": "' + sCodMat + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"descripcion": "' + sDesMat + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"cantidad": "' + sCantidad + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"valor_unitario": "' + sValUni + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"precio_unitario": "' + sPreUni + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"descuento": "' + sDescuento + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"subtotal": "' + sSubTotal + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"tipo_de_igv": "' + sTipoIGV + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"igv": "' + sIGV + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"total": "' + sTotal + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"anticipo_regularizacion": "' + "false" + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"anticipo_documento_serie": "' + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"anticipo_documento_numero": "' + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"codigo_producto_sunat": "' + '"' + CRLF
		IF !UltimoRegistro()
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '},' + CRLF
		ELSE
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '}' + CRLF
		ENDIF
	ENDSCAN
	IF nCuotas <> 0
		*!*	VETT: aqui va el [ IDUPD:307144772-21/08/2024 06:44 PM 
		MiCadenaJSON = MiCadenaJSON + CHR(9) + '],' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + '"venta_al_credito": [' + CRLF
		SELECT cCuotas
		GO TOP
		SCAN
			sCuota = ALLTRIM(STR(VAL(NroCta),3,0))
			sFechaPago = LEFT(DTOC(FchCob),2) + "-" + SUBSTR(DTOC(FchCob),4,2) + "-" + RIGHT(DTOC(FchCob),4)
			sImporte = ALLTRIM(STR(Import,16,2))
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + "{" + CRLF
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"cuota": ' + sCuota + ',' + CRLF
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"fecha_de_pago": "' + sFechaPago + '",' + CRLF
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"importe": ' + sImporte + CRLF
			IF !UltimoRegistro()
				MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '},' + CRLF
			ELSE
				MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '}' + CRLF
			ENDIF
		ENDSCAN
	** MAAV Guias en Factura/Boleta IDUPD:183516526-11/11/2024 5:48 PM
		IF nGuias <> 0
			MiCadenaJSON = MiCadenaJSON + CHR(9) + '],' + CRLF
		ELSE 
			MiCadenaJSON = MiCadenaJSON + CHR(9) + ']' + CRLF
		ENDIF
	ELSE
		IF nGuias <> 0
			MiCadenaJSON = MiCadenaJSON + CHR(9) + '],' + CRLF
		ELSE
			MiCadenaJSON = MiCadenaJSON + CHR(9) + ']' + CRLF
		ENDIF
	ENDIF
	IF nGuias <> 0
		MiCadenaJSON = MiCadenaJSON + CHR(9) + '"guias": [' + CRLF
		SELECT cGuias
		GO TOP
		SCAN
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '{' + CRLF
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"guia_tipo": ' + '1' + ',' + CRLF
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"guia_serie_numero": ' + '"' + LEFT(cGuias.NroDoc,4) + '-' + ALLTRIM(TRANSFORM(VAL(SUBSTR(cGuias.NroDoc, 5, 9)), "#########")) + '"' + CRLF
			IF !UltimoRegistro()
				MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '},' + CRLF
			ELSE
				MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '}' + CRLF
			ENDIF
		ENDSCAN
		MiCadenaJSON = MiCadenaJSON + CHR(9) + ']' + CRLF
	ENDIF
	** MAAV [FIN] 						IDUPD:183516526-11/11/2024 5:48 PM
	MiCadenaJSON = MiCadenaJSON + '}' + CRLF && Cerramos la llave para el fin del proceso
	*!*	Fin de archivo
	IF USED("cDVta")
		USE IN cDVta
	ENDIF
	=FPUTS(nControlArc_JSON, MiCadenaJSON)
	=FCLOSE(nControlArc_JSON) && Aca estoy
	cStringJSON = FILETOSTR(sRuta_A + UPPER(sNomArc_JSON))
	cFileJSON = ADDBS(JUSTPATH(sRuta_A + sNomArc_JSON)) + JUSTSTEM(sRuta_A + sNomArc_JSON) + LsExtFile3
	STRTOFILE(STRCONV(cStringJSON,9),cFileJSON)
	IF !EMPTY(PsRuta_B)
		COPY FILE (cFileJSON) TO ADDBS(goentpub.tspath_ose_csv)+JUSTFNAME(cFileJSON)
	ENDIF
	*!*	Pasamos la cadena para el envío automático
	sRuta = "https://api.pse.pe/api/v1/2f63157007254185ae981196f06eadb50fae23d793154422ae28e7f2cd3b45b1"
	sToken = "eyJhbGciOiJIUzI1NiJ9.ImQxM2Q4MzY0NDZiYTQyOWY5Yzk5ZjkwN2EyMWFjOTljYTVhMTY0MjU4MDk2NDNjYTg1ZjFlMGMxZmUyNjMwMmEi.TlwVhKGVPeVsHOuSLMZXDZhWNiPS4dUH7ljX12h-B7A"	
	post_conectar = CreateObject("MSXML2.ServerXMLHTTP")
	post_conectar.Open("POST", sRuta, .F.) && sRuta viene del ruta del usario demo
	post_conectar.setRequestHeader("Content-Type", "application/json")
	post_conectar.setRequestHeader("Authorization", "Token token=" + sToken)
	post_conectar.send(MiCadenaJSON)
	JSON_Respuesta = post_conectar.responseText
	*!*	Leemos la respuesta:
	Leer_Respuesta = JSON_Decode(JSON_Respuesta)
	*!*	VETT: Administrar mensaje de respuesta al envio a Sunat, aceptacion o error de CPE IDUPD:4157169953-12/09/2024 10:41 AM
	STORE "" TO LsMensaje , LsTitMensaje
	LnMsjTipo = 0
	IF EMPTY(Leer_Respuesta.get('errors')) THEN
		LsTitMensaje = "Respuesta de CPE enviado"
		LuRpta = Leer_Respuesta.get('tipo_de_comprobante')    
	    LsMensaje = LsMensaje + "Tipo de comprobante:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('serie')    
	    LsMensaje = LsMensaje + "Serie:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('numero')    
	    LsMensaje = LsMensaje +  "Numero:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('enlace')    
	    LsMensaje = LsMensaje +  "Enlace:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('aceptada_por_sunat')    
	    LsMensaje = LsMensaje +  "Aceptada por Sunat:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_description')    
	    LsMensaje = LsMensaje +  "Sunat descripción:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_note')    
	    LsMensaje = LsMensaje +  "Sunat nota:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_responsecode')    
	    LsMensaje = LsMensaje +  "Sunat codigo respuesta:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_soap_error')    
	    LsMensaje = LsMensaje +  "Sunat soap error:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('pdf_zip_base64')    
	    LsMensaje = LsMensaje +  "PDF Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('xml_zip_base64')    
	    LsMensaje = LsMensaje +  "XML Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('cdr_zip_base64')   
	    LsMensaje = LsMensaje +  "CDR Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('cadena_para_codigo_qr')    
	    LsMensaje = LsMensaje +  "Cadena QR:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('codigo_hash')    
	    LsMensaje = LsMensaje +  "Codigo Hash:" +  UResp2Str(LuRpta) + CRLF
		LnMsjTipo = 64
	ELSE
		LsTitMensaje = "Envio de CPE con errores"
		LsMensaje = LsMensaje + Leer_Respuesta.get('errors')
		LnMsjTipo = 16
	ENDIF
	LnRpta = MESSAGEBOX(LsMensaje,LnMsjTipo,LsTitMensaje)
	*!*	VETT: [FIN] IDUPD:4157169953-12/09/2024 10:41 AM
	RETURN
ENDPROC

FUNCTION UResp2Str
	PARAMETERS PuVar
	LsVar = ICASE(VARTYPE(PuVar) = "N", STR(PuVar, 3, 0),VARTYPE(PuVar) = "C", PuVar, VARTYPE(PuVar)="L",IIF(PuVar,"True","False"),VARTYPE(PuVar)="T",TTOC(PuVar),VARTYPE(PuVar)="D", DTOS(PuVar), ISNULL(PuVar),"","" )
	RETURN LsVar
ENDFUNC

*!*	Cadena TXT para las notas de credito y debito
*!*	VETT: N/C, N/D  IDUPD:3923294561-09/10/2024 04:58 PM
PROCEDURE Genera_Cadena_TXT_Not
	PARAMETERS PoDataCab, PsRuta_A, PsRuta_B
	DO Genera_Cadena_TXT_FB WITH PoDataCab, PsRuta_A, PsRuta_B
ENDPROC

*!*	Cadena JSON para las notas de credito y debito
PROCEDURE Genera_Cadena_JSON_Not
	PARAMETERS PoDataCab, PsRuta_A, PsRuta_B
	DO Genera_Cadena_JSON_FB WITH PoDataCab, PsRuta_A, PsRuta_B
ENDPROC
** VETT: [FIN] DUPD:3923294561-09/10/2024 04:58 PM

*!*	Cadena JSON para las facturas y boletas
PROCEDURE Genera_Cadena_JSON_Anulacion_FBN
	PARAMETERS PoDataCab, PsRuta_A, PsRuta_B
	*!*	VETT: Anulación de FACT/BOLE/NOTAS IDUPD:1440977411-24/09/2024 16:07
	sCodDoc = ICASE(PoDataCab.CodDoc='FACT','01', PoDataCab.CodDoc='BOLE','03', PoDataCab.CodDoc='N/C','07', PoDataCab.CodDoc='N/D','08', "XX")
	sLetSer = ICASE(INLIST(PoDataCab.CodDoc,'FACT','BOLE'),LEFT(PoDataCab.CodDoc,1),INLIST(PoDataCab.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodDoc,1),'X')
	sSerie = RIGHT(sLetSer+LTRIM(SUBSTR(PoDataCab.NroDoc,2,3)),4)
	sNomArc_JSON = GsRucCia + '-RA-' + sCodDoc + '-' + sSerie + '-' + RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8) + '.json'
	sNroDoc = sSerie + '-' + RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8)
	sRuta_A = ADDBS(TRIM(PsRuta_A)) && curdir()+lruta   
	IF !DIRECTORY(sRuta_A)
		MKDIR (sRuta_A)
	ENDIF	
	IF FILE(sRuta_A + sNomArc_JSON)
		DELETE FILE (sRuta_A + sNomArc_JSON)
	ENDIF
	sTipoComprobante = ICASE(PoDataCab.CodDoc='FACT', '1', PoDataCab.CodDoc='BOLE', '2', PoDataCab.CodDoc='N/C', '3', PoDataCab.CodDoc='N/D', '4', '0')
	sSerieDocumento = sSerie
	sNumero = ALLTRIM(STR(VAL(SUBSTR(PoDataCab.NroDoc,5,10)),10,0))
	sMotivo = "ERROR DEL SISTEMA"
	sCodigoUnico = ""
	sFormatoPDF = "A4"
	LOCAL MiCadenaJSON
	TEXT TO MiCadenaJSON NOSHOW TEXTMERGE PRETEXT 15
	{
		"operacion": "generar_anulacion",
		"tipo_de_comprobante": <<sTipoComprobante>>,
		"serie": "<<sSerieDocumento>>",
		"numero": <<sNumero>>,
		"motivo": "<<sMotivo>>",
		"codigo_unico": "<<sCodigoUnico>>"
	}
	ENDTEXT
	cStringJSON = MiCadenaJSON
	cFileJSON = ADDBS(JUSTPATH(sRuta_A + sNomArc_JSON)) + JUSTSTEM(sRuta_A + sNomArc_JSON) + LsExtFile3
	STRTOFILE(STRCONV(cStringJSON,9),cFileJSON)
	IF !EMPTY(PsRuta_B)
		COPY FILE (cFileJSON) TO ADDBS(goentpub.tspath_ose_csv)+JUSTFNAME(cFileJSON)
	ENDIF
	*!*	Pasamos la cadena para el envío automático
	sRuta = "https://api.pse.pe/api/v1/2f63157007254185ae981196f06eadb50fae23d793154422ae28e7f2cd3b45b1"
	sToken = "eyJhbGciOiJIUzI1NiJ9.ImQxM2Q4MzY0NDZiYTQyOWY5Yzk5ZjkwN2EyMWFjOTljYTVhMTY0MjU4MDk2NDNjYTg1ZjFlMGMxZmUyNjMwMmEi.TlwVhKGVPeVsHOuSLMZXDZhWNiPS4dUH7ljX12h-B7A"	
	post_conectar = CreateObject("MSXML2.ServerXMLHTTP")
	post_conectar.Open("POST", sRuta, .F.) && sRuta viene del ruta del usario demo
	post_conectar.setRequestHeader("Content-Type", "application/json")
	post_conectar.setRequestHeader("Authorization", "Token token=" + sToken)
	post_conectar.send(MiCadenaJSON)
	JSON_Respuesta = post_conectar.responseText
	*!*	Leemos la respuesta:
	Leer_Respuesta = JSON_Decode(JSON_Respuesta)
	*!*	VETT: Administrar mensaje de respuesta al envio a Sunat, aceptacion o error de CPE IDUPD:4157169953-12/09/2024 10:41 AM
	STORE "" TO LsMensaje , LsTitMensaje
	LnMsjTipo = 0
	IF EMPTY(Leer_Respuesta.get('errors')) THEN
		LsTitMensaje = "Respuesta de anulacion CPE enviado"
	    LuRpta = Leer_Respuesta.get('tipo_de_comprobante')    
	    LsMensaje = LsMensaje + "Tipo de comprobante:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('serie')    
	    LsMensaje = LsMensaje + "Serie:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('numero')    
	    LsMensaje = LsMensaje +  "Numero:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('enlace')    
	    LsMensaje = LsMensaje +  "Enlace:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('aceptada_por_sunat')    
	    LsMensaje = LsMensaje +  "Aceptada por Sunat:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_description')    
	    LsMensaje = LsMensaje +  "Sunat descripción:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_note')    
	    LsMensaje = LsMensaje +  "Sunat nota:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_responsecode')    
	    LsMensaje = LsMensaje +  "Sunat codigo respuesta:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_soap_error')    
	    LsMensaje = LsMensaje +  "Sunat soap error:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('pdf_zip_base64')    
	    LsMensaje = LsMensaje +  "PDF Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('xml_zip_base64')    
	    LsMensaje = LsMensaje +  "XML Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('cdr_zip_base64')   
	    LsMensaje = LsMensaje +  "CDR Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('cadena_para_codigo_qr')    
	    LsMensaje = LsMensaje +  "Cadena QR:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('codigo_hash')    
	    LsMensaje = LsMensaje +  "Codigo Hash:" +  UResp2Str(LuRpta) + CRLF
		LnMsjTipo = 64
	ELSE
		LsTitMensaje = "Envio de CPE con errores"
		LsMensaje = LsMensaje + Leer_Respuesta.get('errors')
		LnMsjTipo = 16
	ENDIF
	LnRpta = MESSAGEBOX(LsMensaje,LnMsjTipo,LsTitMensaje)
	** VETT: [FIN] IDUPD:1440977411-24/09/2024 16:07
RETURN

*!*	Cadena JSON para la GRE (guía de remisión electrónica)
PROCEDURE Genera_Cadena_JSON_GRE
	PARAMETERS PoDataCab, PsRuta_A, PsRuta_B
	LsLetSer = ICASE(INLIST(PoDataCab.TpoRf1,'FACT','BOLE','G/R'),LEFT(PoDataCab.NroRf1,1),INLIST(PoDataCab.TpoRf1,'N/C','N/D'),LEFT(PoDataCab.NroRf1,1),'X')
	LsSerie = RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroRf1,2,3)),4)
	LsNroDoc = LsSerie + '-' + RIGHT('00000000' + RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8) && Fijate aca debe ser solo el numero sin la serie
	LsNomArc_JSON = GsRucCia + '-' + LsCodDoc + '-' + UPPER(LsSerie) + '-' + RIGHT('00000000' + RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8) + '.json'
	LsCodFac = ICASE(PoDataAdi.CodFac='FACT','01',PoDataAdi.CodFac='BOLE','03',PoDataAdi.CodFac='N/C','07',PoDataAdi.CodFac='N/D','08',PoDataAdi.CodFac='G/R','09',"")
	LsDesDREL = ICASE(LsCodFac='01','FACTURA',LsCodFac='03','BOLETA',LsCodFac='09','GUIA REMISION REMITENTE','OTROS DOCUMENTOS')
	LsRuta_A = ADDBS(TRIM(PsRuta_A))
	IF !DIRECTORY(LsRuta_A)
		MKDIR (LsRuta_A)
	ENDIF
	IF FILE(LsRuta_A + LsNomArc_JSON)
		DELETE FILE (LsRuta_A + LsNomArc_JSON)
	ENDIF
	LnControlArc_JSON = FCREATE(LsRuta_A + LsNomArc_JSON)
	IF LnControlArc_JSON < 0
		=MESSAGEBOX("Error en la creación de " + LsRuta_A + LsNomArc_JSON, 48, 'Atención')
		RETURN .F.
	ENDIF
	*!*	VETT: Convertimos a cursor el objeto que tiene los datos del detalle del documento IDUPD: 3854169577-11/01/2024 04:10 PM 
	goCfgVta.oDatAdm.Obj2Cur(PoDataDet,'cDVta')
	LnTotItmGR = Cursor_Esta_Vacio("cDVta", .T.)
	SELECT cDVta
	INDEX ON NroRef+STR(NroItm,3,0) TAG cDVta01
	IF VARTYPE(LnTotItmGR) <> "N"
		LnTotItmGR = 0
	ENDIF
	DIMENSION aFila(30)
	*!*	Variables de cabecera
	sOperacion = "generar_guia"
	nTipoComprobante = IIF(LsCodDoc="09",7,8) && segun el tipo de documento es 7 para GRE remitente y 8 para GRE transportista
	sSerie = RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroRf1,2,3)),4)
	nNroDoc = VAL(ALLTRIM(SUBSTR(PoDataCab.NroRf1,5,10))) && Fijate aca debe ser solo el numero sin la serie
	sNroDoc = ALLTRIM(STR(nNroDoc,10,0))
	sClienteTpoDoc = ICASE(LEN(trim(PoDataCab.CodCli))=11,'6',LEN(TRIM(PoDataCab.CodCli))=8,'1','4')
	sClienteNroDoc = ALLTRIM(PoDataCab.CodCli)
	sClienteNombre = ALLTRIM(PoDataAdi.NomCli)
	sClienteDireccion = ALLTRIM(PoDataAdi.DirCli)
	sClienteEMail01 = ALLTRIM(PoDataAdi.EmailDest)
	sClienteEMail02 = ""
	sClienteEMail03 = ""
	sFechaEmision = LEFT(DTOC(PoDataCab.FchDoc),2) + "-" + SUBSTR(DTOC(PoDataCab.FchDoc),4,2) + "-" + SUBSTR(DTOC(PoDataCab.FchDoc),7,4)
	sObservaciones = ALLTRIM(PoDataCab.Observ)
	sMotivoTraslado = TRANSFORM(PoDataCab.Motivo,"@L ##")
	sPesoBruto = ALLTRIM(STR(PoDataCab.PesoBruto,10,2))
	sPesoBrutoUM = ALLTRIM(PoDatacab.UndMed)
	sNroBultos = "0"
	sTpoTransporte = PoDataCab.ModTra
	sFechaIniTraslado = LEFT(DTOC(PoDataCab.FIniTras),2) + "-" + SUBSTR(DTOC(PoDataCab.FIniTras),4,2) + "-" + SUBSTR(DTOC(PoDataCab.FIniTras),7,4)
	sTpoDocTransportista = ICASE(LEN(TRIM(PoDataCab.RucTra))=11,'6',LEN(TRIM(PoDataCab.RucTra))=8,'1','0')
	LsModTra = PoDataCab.ModTra && Modalidad de traslado
	sNroDocTransportista = IIF(LsModTra='01',PoDataCab.RucTra,"")
	sTransNombre = IIF(LsModTra='01',PoDataCab.nomtra,"")
	sNroPlaca = ALLTRIM(PoDataAdi.PlaTra)
	sTpoDocConductor = ALLTRIM(PoDataAdi.TPDCond)
	sNroDocConductor = ALLTRIM(PoDataAdi.DNICond)
	sNomConductor = ALLTRIM(PoDataAdi.NomCond)
	sApeConductor = ALLTRIM(PoDataAdi.ApeCond)
	sLicenciaConductor = ALLTRIM(PoDataAdi.Brevet)
	sPtoPartidaUbiGeo = ALLTRIM(PoDataAdi.UbiPPart)
	sPtoPartidaDireccion = ALLTRIM(PoDataAdi.DirRemit)
	sPtoPartidaCodEstabSunat = ALLTRIM(PoDatacab.CodEstPart)
	sPtoLegadaUbiGeo = ALLTRIM(PoDataAdi.UbiPlleg)
	sPtoLlegadaDireccion = ALLTRIM(PoDataAdi.DirEnt)
	sPtoLlegadaCodEstabSunat = ALLTRIM(PoDatacab.CodEstLleg)
	sEnvioAutomatico = "false"
	sFormatoPDF = ""
	*!*	Armamos el archivo JSON
	LOCAL MiCadenaJSON
	MiCadenaJSON = ""
	MiCadenaJSON = MiCadenaJSON + '{' + CRLF && Apertura de llave para el inicio del proceso
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"operacion": "' + sOperacion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tipo_de_comprobante": ' + ALLTRIM(STR(nTipoComprobante)) + ',' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"serie": "' + sSerie + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"numero": "' + sNroDoc + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_tipo_de_documento": ' + sClienteTpoDoc + ',' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_numero_de_documento": "' + sClienteNroDoc + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_denominacion": "' + sClienteNombre + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_direccion": "' + sClienteDireccion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_email": "' + sClienteEMail01 + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_email_1": "' + sClienteEMail02 + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"cliente_email_2": "' + sClienteEMail03 + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"fecha_de_emision": "' + sFechaEmision + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"observaciones": "' + sObservaciones + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"motivo_de_traslado": "' + sMotivoTraslado + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"peso_bruto_total": "' + sPesoBruto + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"peso_bruto_unidad_de_medida": "' + sPesoBrutoUM + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"numero_de_bultos": "' + sNroBultos + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"tipo_de_transporte": "' + sTpoTransporte + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"fecha_de_inicio_de_traslado": "' + sFechaIniTraslado + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"transportista_documento_tipo": "' + sTpoDocTransportista + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"transportista_documento_numero": "' + sNroDocTransportista + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"transportista_denominacion": "' + sTransNombre + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"transportista_placa_numero": "' + sNroPlaca + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"conductor_documento_tipo": "' + sTpoDocConductor + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"conductor_documento_numero": "' + sNroDocConductor + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"conductor_nombre": "' + sNomConductor + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"conductor_apellidos": "' + sApeConductor + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"conductor_numero_licencia": "' + sLicenciaConductor + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"punto_de_partida_ubigeo": "' + sPtoPartidaUbiGeo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"punto_de_partida_direccion": "' + sPtoPartidaDireccion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"punto_de_partida_codigo_establecimiento_sunat": "' + sPtoPartidaCodEstabSunat + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"punto_de_llegada_ubigeo": "' + sPtoLegadaUbiGeo + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"punto_de_llegada_direccion": "' + sPtoLlegadaDireccion + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"punto_de_llegada_codigo_establecimiento_sunat": "' + sPtoLlegadaCodEstabSunat + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"enviar_automaticamente_al_cliente": "' + sEnvioAutomatico + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"formato_de_pdf": "' + sFormatoPDF + '",' + CRLF
	MiCadenaJSON = MiCadenaJSON + CHR(9) + '"items": [' + CRLF
	SCAN
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '{' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"unidad_de_medida": "' + ALLTRIM(ICASE(cDVta.UndVta='KG','KGM',cDVta.UndVta='MTS','MTR',cDVta.UndVta='ROL','RO','NIU')) + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"codigo": "' + ALLTRIM(cDVta.CodMat) + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"descripcion": "' + ALLTRIM(cDVta.DesMat) + '",' + CRLF
		MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + CHR(9) + '"cantidad": "' + ALLTRIM(STR(cDVta.CanDes,12,4)) + '"' + CRLF
		IF !UltimoRegistro()
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '},' + CRLF
		ELSE
			MiCadenaJSON = MiCadenaJSON + CHR(9) + CHR(9) + '}' + CRLF
		ENDIF
	ENDSCAN
	MiCadenaJSON = MiCadenaJSON + CHR(9) + ']' + CRLF
	MiCadenaJSON = MiCadenaJSON + '}' + CRLF && Cerramos la llave para el fin del proceso
	*!*	Fin de archivo
	IF USED("cDVta")
		USE IN cDVta
	ENDIF
	=FPUTS(LnControlArc_JSON, MiCadenaJSON)
	=FCLOSE(LnControlArc_JSON) && Aca estoy
	LcStringJSON = FILETOSTR(LsRuta_A + LsNomArc_JSON)
	LcFileJSON = ADDBS(JUSTPATH(LsRuta_A + LsNomArc_JSON)) + JUSTSTEM(LsRuta_A + LsNomArc_JSON) + LsExtFile3
	STRTOFILE(STRCONV(lcStringJSON,9),LcFileJSON)
	IF !EMPTY(PsRuta_B)
		COPY FILE (LcFileJSON) TO ADDBS(goentpub.tspath_ose_csv)+JUSTFNAME(LcFileJSON)
	ENDIF
SET STEP ON
	** VETT: Envio NUBEFACT IDUPD:1790732881-20/08/2024 02:18 PM 
	*!*	Pasamos la cadena para el envío automático
	sRuta = "https://api.pse.pe/api/v1/2f63157007254185ae981196f06eadb50fae23d793154422ae28e7f2cd3b45b1"
	sToken = "eyJhbGciOiJIUzI1NiJ9.ImQxM2Q4MzY0NDZiYTQyOWY5Yzk5ZjkwN2EyMWFjOTljYTVhMTY0MjU4MDk2NDNjYTg1ZjFlMGMxZmUyNjMwMmEi.TlwVhKGVPeVsHOuSLMZXDZhWNiPS4dUH7ljX12h-B7A"
	post_conectar = CreateObject("MSXML2.ServerXMLHTTP")
	post_conectar.Open("POST", sRuta, .F.) && sRuta viene del ruta del usario demo
	post_conectar.setRequestHeader("Content-Type", "application/json")
	post_conectar.setRequestHeader("Authorization", "Token token=" + sToken)
	post_conectar.send(MiCadenaJSON)
	JSON_Respuesta = post_conectar.responseText
	*!*	Leemos la respuesta:
	Leer_Respuesta = JSON_Decode(JSON_Respuesta)
	
	** VETT: Administrar mensaje de respuesta al envio a Sunat, aceptacion o error de CPE IDUPD:4157169953-12/09/2024 10:41 AM
	STORE "" TO LsMensaje , LsTitMensaje
	LnMsjTipo = 0
	IF EMPTY(Leer_Respuesta.get('errors')) THEN
		LsTitMensaje = "Respuesta de GRE - REMITENTE enviado"
	    LuRpta = Leer_Respuesta.get('tipo_de_comprobante')    
	    LsMensaje = LsMensaje + "Tipo de comprobante:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('serie')    
	    LsMensaje = LsMensaje + "Serie:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('numero')    
	    LsMensaje = LsMensaje +  "Numero:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('enlace')    
	    LsMensaje = LsMensaje +  "Enlace:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('aceptada_por_sunat')    
	    LsMensaje = LsMensaje +  "Aceptada por Sunat:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_description')    
	    LsMensaje = LsMensaje +  "Sunat descripción:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_note')    
	    LsMensaje = LsMensaje +  "Sunat nota:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_responsecode')    
	    LsMensaje = LsMensaje +  "Sunat codigo respuesta:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('sunat_soap_error')    
	    LsMensaje = LsMensaje +  "Sunat soap error:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('pdf_zip_base64')    
	    LsMensaje = LsMensaje +  "PDF Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('xml_zip_base64')    
	    LsMensaje = LsMensaje +  "XML Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('cdr_zip_base64')   
	    LsMensaje = LsMensaje +  "CDR Zip base64:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('cadena_para_codigo_qr')    
	    LsMensaje = LsMensaje +  "Cadena QR:" + UResp2Str(LuRpta) + CRLF    
	    LuRpta = Leer_Respuesta.get('codigo_hash')    
	    LsMensaje = LsMensaje +  "Codigo Hash:" +  UResp2Str(LuRpta) + CRLF
		LnMsjTipo = 64
	ELSE
		LsTitMensaje = "Envio de GRE-REMITENTE con errores"
		LsMensaje = LsMensaje + Leer_Respuesta.get('errors')
		LnMsjTipo = 16
	ENDIF
	LnRpta = MESSAGEBOX(LsMensaje,LnMsjTipo,LsTitMensaje)
	*!*	VETT: [FIN] IDUPD:4157169953-12/09/2024 10:41 AM
	RETURN
ENDPROC

FUNCTION Cursor_Esta_Vacio
	PARAMETERS Pc_Tabla, Pl_NumReg
	IF VARTYPE(Pl_NumReg) <> 'L'
		Pl_NumReg = .F.
	ENDIF
	IF PARAMETERS() = 0
		Pc_Tabla =  ALIAS()
	ENDIF
	IF EMPTY(Pc_Tabla)
		RETURN .T.
	ENDIF
	LOCAL LcArea_Act,LnNumReg,LnRegAct
	*!*	LcArea_Act=ALIAS()
	*!*	LnNumReg = IIF(EMPTY(LcArea_Act),0,RECNO())
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
		*!* VETT  25/08/2014 12:59 PM :  No esta definida o no se encontro la tabla o cursor
		IF Pl_NumReg
			RETURN -1	
		ELSE
			RETURN .T.
		ENDIF
	ENDIF
	*!*	LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
	RETURN
ENDFUNC

FUNCTION UltimoRegistro
	IF EOF()
		RETURN .T.
	ENDIF
	LOCAL lUltimo
	SKIP
	lUltimo = EOF()
	SKIP -1
	RETURN lUltimo
ENDFUNC