PARAMETERS PoDataCab as Object ,PoDataDet as Object,PoDataAdi as Object,PoDataAdi2 as Object, PsRutA as Character, PsRutB as Character,PsVer as Character
IF VARTYPE(PsVer)<>'C'
*!*		PsVer = '1.2'
	** VETT:Actualización v1.3.2 2020/07/01 08:55:39 ** 
	PsVer = '1.3.2'
ENDIF
IF VARTYPE(PsRutB)<>"C"
	PsRutB	= ""
ENDIF
#include const.h 
*!*	IF .f. AND PoDataCab.NroRf1='E' AND INLIST(PoDataCab.TpoRf1,'FACT','BOLE','N/C','N/D')
*!*		RETURN .T.
*!*	ENDIF

** VETT: Direccionamos exportacion segun tipo de documento IDUPD:3987723420-01/03/2024 05:02 PM
DO CASE 
	CASE VARTYPE(PoDataCab.TpoRf1)='C' AND VARTYPE(PoDataCab.NroRf1)='C'
		LsCodDoc	=ICASE(PoDataCab.TpoRf1='FACT','01',PoDataCab.TpoRf1='BOLE','03',PoDataCab.TpoRf1='N/C','07',PoDataCab.TpoRf1='N/D','08',PoDataCab.TpoRf1='G/R','09')
	CASE VARTYPE(PoDataCab.TpoRef)='C' AND VARTYPE(PoDataCab.CodDoc)='C'
		LsCodDoc	=ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08',"XX")
	OTHERWISE 
	    LsCodDoc 	= ""
ENDCASE

*!*	Lsruta   = ADDBS(TRIM(PsRuta))
*!*	LsCodDoc	=ICASE(PoDataCab.TpoRf1='FACT','01',PoDataCab.TpoRf1='BOLE','03',PoDataCab.TpoRf1='N/C','07',PoDataCab.TpoRf1='N/D','08',PoDataCab.TpoRf1='G/R','09')
*!*	LsLetSer	=ICASE(INLIST(PoDataCab.TpoRf1,'FACT','BOLE','G/R'),LEFT(PoDataCab.NroRf1,1),INLIST(PoDataCab.TpoRf1,'N/C','N/D'),LEFT(PoDataCab.NroRf1,1),'X')
*!*	LsSerie		=RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroRf1,2,3)),4)
*!*	LsExtFile1	=ICASE(INLIST(LsCodDoc,'01','03','09'),".txt",INLIST(LsCodDoc,'07','08'),".txt") 
LsExtFile2	=".csv"
*!*	LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8)+LsExtFile1	&&  '.CAB'
LsNomArc = ""
LsRuta	=	""		


LlHayCuotas	= .F. 

*!*	DO Genera_Cadena_CAB WITH  PoDataCab,PsRuta
*!*	DO Genera_Cadena_DET WITH  PoDataDet,PsRuta,PoDataCab
STORE .F. TO LlAliasZonas,LlAliasPROV,LlAliasDIST,LlAliasTABL,LlAliasGSIS,LlAliasSedes,LlAliasCTAS
IF !USED("Zona")
	LlAliasZonas = goentorno.open_dbf1("ABRIR","Zonas","Zona","Zona01")
ENDIF
IF !USED("PROV")
	LlAliasPROV	=	goentorno.open_dbf1("ABRIR","Provincias","Prov","Prov01")
ENDIF
IF !USED("DIST")
	LlAliasDIST =	goentorno.open_dbf1("ABRIR","Distritos","DIST","DIST01")
ENDIF
IF !USED("GSIS")
	LlAliasGSIS	=	goentorno.open_dbf1("ABRIR","ALMTGSIS","GSIS","TABL01")
ENDIF
IF !USED("MTABL")
	LlAliasTABL	=	goentorno.open_dbf1("ABRIR","CBDMTABL","MTABL","TABL01")
ENDIF
IF !USED("SEDES")
	LlAliasSedes	=	goentorno.open_dbf1("ABRIR","SEDES","SEDES","SEDE01")
ENDIF
IF !USED("CTAS")
	LlAliasCTAS	=	goentorno.open_dbf1("ABRIR","CBDMCTAS","CTAS","CTAS01")
ENDIF

DO CASE
	CASE INLIST(LsCodDoc,'01','03')
		** VETT: Generar archivo GRE-SUNAT formato CSV NO BOM para EFACT IDUPD:3122388993-08/02/2024 05:47 AM	
		DO Genera_Cadena_CSV_FB WITH  PoDataCab,PsRuta,PsRutB
		** VETT: [LAST UPDATED] IDUPD:3122388993-08/02/2024 05:47 AM 	 
	CASE INLIST(LsCodDoc,'07','08')
	
		DO Genera_Cadena_CSV_NOT WITH  PoDataCab,PsRuta,PsRutB
	CASE INLIST(LsCodDoc,'09')
		** VETT: Generar archivo GRE-SUNAT formato CSV NO BOM para EFACT IDUPD:3609281637-21/12/2023 05:43 AM 
		DO Genera_Cadena_CSV_GRE WITH  PoDataCab,PsRuta,PsRutB
		** VETT: [LAST UPDATED] IDUPD:2454762601-11/01/2024 03:22 PM 	 
ENDCASE

LsMensaje=""
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.csv' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.csv'),' [OK]',' [ERROR]') + CRLF  
*!*	LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.DET' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.DET'),' [OK]',' [ERROR]') + CRLF  
*!*	LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.ACA' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.ACA'),' [OK]',' [ERROR]') + CRLF  
*!*	LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.LEY' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.LEY'),' [OK]',' [ERROR]') + CRLF  
*!*	LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.TRI' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.TRI'),' [OK]',' [ERROR]') + CRLF  
*!*	LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.PAG' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.PAG'),' [OK]',' [ERROR]') + CRLF 
*!*	IF LlHayCuotas	 
*!*		LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.DPA' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.DPA'),' [OK]',' [ERROR]') + CRLF 
*!*	ENDIF

IF "ERROR"$LsMensaje
	LsMensaje = LsMensaje +  'Generación de archivos presenta algunos problemas, revisar en la ruta:'+CRLF
	LsMensaje = LsMensaje +  LsRuta
	=MESSAGEBOX(LsMensaje,16,'Envio de archivos a EFACT')
ELSE	
	LsMensaje = LsMensaje +  'Generación de archivos terminada sin problemas, revisar en la ruta:'+CRLF
	LsMensaje = LsMensaje +  LsRuta
	=MESSAGEBOX(LsMensaje,64,'Envio de archivos a EFACT')
ENDIF

IF USED('PROV')	AND LlAliasPROV
	USE IN PROV
ENDIF
IF USED('DIST')	AND LlAliasDIST
	USE IN DIST
ENDIF
IF USED('ZONA') AND LlAliasZonas
	USE IN ZONA
ENDIF
IF USED('GSIS')	AND LlAliasGSIS
	USE IN GSIS
ENDIF
IF USED('MTABL') AND LlAliasTABL
	USE IN MTABL
ENDIF
IF USED('CTAS') AND LlAliasCTAS
	USE IN CTAS
ENDIF


********************************
PROCEDURE Genera_Cadena_CSV_GRE 
********************************
PARAMETERS PoDataCab,PsRuta,PsRutB

LsCodDoc	=ICASE(PoDataCab.TpoRf1='FACT','01',PoDataCab.TpoRf1='BOLE','03',PoDataCab.TpoRf1='N/C','07',PoDataCab.TpoRf1='N/D','08',PoDataCab.TpoRf1='G/R','09',"")
LsLetSer	=ICASE(INLIST(PoDataCab.TpoRf1,'FACT','BOLE','G/R'),LEFT(PoDataCab.NroRf1,1),INLIST(PoDataCab.TpoRf1,'N/C','N/D'),LEFT(PoDataCab.NroRf1,1),'X')
LsSerie		=RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroRf1,2,3)),4)
LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8)+'.txt'
LsNroDoc    =LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8)
** Datos Adicionales **
LsCodFac	=	ICASE(PoDataAdi.CodFac='FACT','01',PoDataAdi.CodFac='BOLE','03',PoDataAdi.CodFac='N/C','07',PoDataAdi.CodFac='N/D','08',PoDataAdi.CodFac='G/R','09',"")
LsNroFac	=	PoDataAdi.NroFac
LsDesDREL	=	ICASE(LsCodFac='01','FACTURA',LsCodFac='03','BOLETA',LsCodFac='09','GUIA REMISION REMITENTE','OTROS DOCUMENTOS')
** Ruta y apertura de archivo
Lsruta   = ADDBS(TRIM(PsRuta)) && curdir()+lruta   
IF !DIRECTORY(Lsruta)
	MKDIR (Lsruta)
ENDIF	
IF FILE(Lsruta+LsNomArc)
	DELETE FILE (Lsruta+LsNomArc)
ENDIF
LnControlArc = fcreate(Lsruta+LsNomArc)

if LnControlArc<0
   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Cabecera de venta')
   RETURN .f.
ENDIF

** VETT: Convertimos a cursor el objeto que tiene los datos del detalle del documento IDUPD:3854169577-11/01/2024 04:10 PM 
gocfgvta.odatadm.obj2cur(PoDataDet,'cDVta')

LnTotItmGR = cursor_esta_vacio("cDVta",.t.)
IF VARTYPE(LnTotItmGR)<>"N"
	LnTotItmGR = 0
ENDIF
	
DIMENSION aFila(30)
STORE "" TO aFila

LsVerDOC	= "2.0"
LsVerUBL	= "2.1"
LnTotAnt	= 0
LfTotVta	= 0  && PoDataCab.ImpBto+PoDataCab.ImpIgv+PoDataCab.ImpAdm-PoDataCab.ImpDto-LnTotAnt
LsFecha		= TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##")
LsFchVto	= {} && IIF(!EMPTY(PoDataCab.FchVto),TRANSFORM(DTOS(PoDataCab.FchVto), "@R ####-##-##"),"-")
LsDesMot	= IIF(SEEK(PADR(GsMotivo,LEN(MTABL.Tabla))+TRANSFORM(PoDataCab.Motivo,"@L ##"),"MTABL","TABL01"),ALLTRIM(STUFF(MTABL.Nombre,1,ATC("-",MTABL.Nombre),"")),'Descripción motivo traslado') 
LsDesMot	= IIF(!EMPTY(PoDataAdi.Desmotivo),PoDataAdi.Desmotivo,LsDesMot)
LnCnGRef	= 0
IF !EMPTY(LsCodFac) AND !EMPTY(LsNroFac)
	LnCnDRel = 1
ELSE
	LnCnDRel = 0
ENDIF
LnCnCdRel	= 1  && Un conductor por defecto
LnCnPlRel	= 1  && Un nro. de Placa por defecto - Cantidad números de placas relacionados
LnCnConPr	= 0  && Cantidad de contenedores y precintos por defecto 
LsGRBaja	= "" && G/R de baja relacionada - Numeración, conformada por serie y número correlativo 
LsTDBaja	= "" && Código del tipo de documento de G/R de baja
LsDRBaja	= "" && Documento relacionado RELATED_DOC

LsDniCond	= "" 				&& Dni conductor (Chofer)
LsTPDCond	= "" 				&& Tipo documento conductor
LsNomCond	= "" 				&& Nombres conductor
LsApeCond	= "" 				&& Apellidos conductor
LsLicCond	= "" 				&& Licencia de conducir conductor
LsPlaTra	= PoDataAdi.PlaTra 	&& Numero Placa del vehiculo de transportista  
LsTarUCir	= ""				&& Tarjeta Única de Circulación Electrónica o Certificado de Habilitación vehicular 
LsNroAutv	= ""				&& Número de autorización especial - Vehículo
LsCdEntEmiV	= "06" 				&& Código de la entidad emisora de la autorización especial - Vehículo - Catalogo D-37
LsNContene	= ""				&& Número contenedor
LsNPrecint	= ""				&& Número precinto
LsUbiRemit  = PoDataAdi.UbiPpart    && Codigo Ubigeo remitente (Empresa), obtenerlo de suscursales/establecimiento de la empresa (CIAXXX)  
LsDirRemit  = PoDataAdi.DirRemit	&& Dirección segun sucursal o establecimiento de la empresa
LsUrbRemit  = PoDataAdi.UrbRemit	&& Urbanizacion remitente
LsPrvRemit  = IIF(SEEK(LEFT(LsUbiRemit,4),"PROV"),UPPER(PROV.DesPRovin),"")				&& Provincia remitente
LsDepRemit	= IIF(SEEK(LEFT(LsUbiRemit,2),"ZONA"),UPPER(ZONA.deszona),"")				&& Departamento remitente
LsDisRemit  = IIF(SEEK(LEFT(LsUbiRemit,6),"DIST"),UPPER(DIST.desdist),"")				&& Distrito remitente	
LsCodPaisR 	= "PE"				&& Codigo Pais remitente
LsAutRemit	= ""				&& Número de autorización especial - remitente
LsCdEntEmiR = "06"
LsCodEstR	= PoDatacab.CodEstPart
LfPesoBruto	= 0
LsNroRegMTC = PoDataAdi.NroRegMtc				&& Numero de registro MTC transportista


LsUbiDest	=	PoDataAdi.UbiPlleg 				&& Codigo Ubigeo Destinatario (Cliente/Empresa) obtenerlo de sucursal/establecimiento cliente
LsDirDest	=	PoDataAdi.DirEnt
LsUrbDest	=	""
LsPrvDest	=	IIF(SEEK(LEFT(LsUbiDest,4),"PROV"),UPPER(PROV.DesPRovin),"")
LsDepDest	=	IIF(SEEK(LEFT(LsUbiDest,2),"ZONA"),UPPER(ZONA.deszona),"")
LsDisDest	=	IIF(SEEK(LEFT(LsUbiDest,6),"DIST"),UPPER(DIST.desdist),"")
LsCdPaisD	=	"PE"
LsEmailDest	=	PoDataAdi.EmailDest
LsCodEstDes =	PoDataAdi.CodEstLleg

LsNomProv	=	""				&& Nombre proveedor
LsTDocProv	=	"" 				&& Código del tipo de documento identidad del proveedor "6" o "1"
LsRucProv	=	""				&& Codigo proveedor (RUC/DNI)
LsUbiProv	=   "" 				&& Codigo Ubigeo del proveedor  
LsDirProv	=	""				&& Dirección proveedor
LsUrbProv	=	""				&& Urbanizacion proveedor
LsPrvProv	=	""				&& Provincia proveedor
LsDepProv	=	""				&& Departamento proveedor
LsDisProv	=	""				&& Distrito proveedor	
LsCodPaisP 	=	""				&& Codigo Pais proveedor "PE"

LsIndTProg	=	""							&& Indicador de trasporte programado
LfPesoBruto	=	PoDataCab.PesoBruto			&& Peso bruto total de la carga
LsUndMed	=	PoDatacab.UndMed			&& Unidad de medida del peso bruto	
LsModTra	=	PoDataCab.ModTra  			&& Modalidad de traslado
LdFIniTras	=	PoDataCab.FiniTras 						&& Fecha inicio traslado
LsNomTra	=   IIF(LsModTra='01',PoDataCab.nomtra,"")  && Nombre de transportista
LsTDTransp	=	ICASE(LEN(trim(PoDataCab.RucTra))=11,'6',LEN(TRIM(PoDataCab.RucTra))=8,'1','0')
LsRucTra	=	IIF(LsModTra='01',PoDataCab.RucTra,"")  && RUC de transportista
LsUbiPPart	=	LsUbiRemit								&& Codigo ubigeo punto de partida
LsDirPPart  =	LsDirRemit								&& Dirección punto de partida
LsUrbPPart  =	LsUrbRemit								&& Urbanizacion punto de partida
LsPrvPPart  =	LsPrvRemit								&& Provincia punto de partida
LsDepPPart	=	LsDepRemit								&& Departamento punto de partida
LsDisPPart  =	LsDisRemit								&& Distrito punto de partida
LsUbiPLleg	=	LsUbiDest								&& Codigo ubigeo punto de llegada
LsDirPLleg  =	LsDirDest								&& Dirección punto de llegada
LsUrbPLleg  =	LsUrbDest								&& Urbanizacion  punto de llegada
LsPrvPLleg  =	LsPrvDest								&& Provincia punto de llegada
LsDepPLleg	=	LsDepDest								&& Departamento punto de llegada
LsDisPLleg  =	LsDisDest								&& Distrito punto de llegada
LnNroBultos =   0										&& Diferente de cero si Motivo es "08" o "09"	
LsRegMTC	=	LsNroRegMTC								&& Numero de registro MTC transportista
LsNroAutTra	=	PoDataAdi.NroAutESP						&& Numero de Autorizacion especial transportista
LsEntEmiTra	=	LsCdEntEmiR								&& 
LsCodEstPart=	PoDataAdi.CodEstPart
LsLongPart  =   0
LsLatiPart	=	0
LsCodEstLleg=	PoDataAdi.CodEstLleg
LsLongPLleg =   0
LsLatiPLleg	=	0


DO CASE
	CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '01','03',"13","07","17")
		LsDniCond 	= "" 
		LsTPDCond 	= "" 
		LsNomCond 	= "" 
		LsApeCond 	= ""
		LsLicCond 	= "" 
		LsPlaTra  	= ""  
		LsTarUCir 	= ""		 
		LsNroAutv 	= ""		
		LsCdEntemiV	= "" 	
		LsNContene	= ""				
		LsNPrecint	= ""	
		LnCnCdRel	= 0
		LnCnPlRel	= 0	
	CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '04')
		IF LsModTra = '02'   && Modalidad de traslado Privado
			LsDniCond	= PoDataAdi.DNICond 			&& Dni conductor (Chofer)
			LsTPDCond	= PoDataAdi.TPDCond 			&& Tipo documento conductor
			LsNomCond	= PoDataAdi.NomCond 			&& Nombres conductor
			LsApeCond	= PoDataAdi.ApeCond 			&& Apellidos conductor
			LsLicCond	= PoDataAdi.Brevet				&& Licencia de conducir conductor	
		ELSE
			LsDniCond	= "" 			&& Dni conductor (Chofer)
			LsTPDCond	= "" 			&& Tipo documento conductor
			LsNomCond	= "" 			&& Nombres conductor
			LsApeCond	= "" 			&& Apellidos conductor
			LsLicCond	= ""			&& Licencia de conducir conductor	
			LsPlaTra	= ""
			LsCdEntemiV = ""
			LsNroAutv	= ""	
		ENDIF
				
	OTHERWISE 	
ENDCASE
 
** Armamos la cadena **
LsCadena = 				aFila(1)															&& es solo para guiar al que viene por 1era vez
LsCadena = 				TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##") 					+","  && Fecha 
LsCadena = LsCadena + 	LsNroDoc															+","  && NroDoc 
LsCadena = LsCadena +	LsCodDoc															+","  && Codigo Documento Sunat 
LsCadena = LsCadena +	ALLTRIM(STR(LnTotItmGR,3))									+","  && Nro de items de G/R
LsCadena = LsCadena +	IIF(!EMPTY(LnCnGRef),ALLTRIM(STR(LnCnGRef,3)),"" )					+","  && Cantidad G/Rs referencia
LsCadena = LsCadena +	IIF(!EMPTY(LnCnDRel),ALLTRIM(STR(LnCnDRel,3)),"" )					+","  && Cantidad Docs relacionados
LsCadena = LsCadena +	IIF(!EMPTY(LnCnCdRel),ALLTRIM(STR(LnCnCdRel,3)),"" )				+","  && Cantidad conductores relacionados
LsCadena = LsCadena +	IIF(!EMPTY(LnCnPlRel),ALLTRIM(STR(LnCnPlRel,3)),"" )				+","  && Cantidad números de placas relacionados
LsCadena = LsCadena +	IIF(!EMPTY(LnCnConPr),ALLTRIM(STR(LnCnConPr,3)),"" )				+","  && Cantidad de contenedores y precintos por defecto 
LsCadena = LsCadena +	SUBSTR(TTOC(PoDatacab.fchCrea,3),12)								+"," && Hora de emision de G/R
LsCadena = LsCadena +   CRLF	&& CRLF = CHR(13)+CHR(10) esta definido en const.h 
LsCadena = LsCadena +	aFila(2)
LsCadena = LsCadena +	ALLTRIM(LsGRBaja)										+","
LsCadena = LsCadena +	ALLTRIM(LsTDBaja)										+","
LsCadena = LsCadena +	ALLTRIM(LsDRBaja)										+","		
LsCadena = LsCadena +   CRLF		
LsCadena = LsCadena +	aFila(3)	
LsCadena = LsCadena +   ALLTRIM(IIF(!EMPTY(LsNroFac),STUFF(LsNroFac, 5, 0, '-'),''))	+","
LsCadena = LsCadena +   IIF(EMPTY(LsNroFac),"",ALLTRIM(LsCodFac))						+","
LsCadena = LsCadena +  	IIF(EMPTY(LsNroFac),"",ALLTRIM(LsDesDREL))						+","
LsCadena = LsCadena +	IIF(EMPTY(LsCodFac),"",ALLTRIM(GsRucCia))						+","
LsCadena = LsCadena +	'ATTACH_DOC'													+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(4)		
LsCadena = LsCadena +	ALLTRIM(LsDniCond)	+","
LsCadena = LsCadena +	ALLTRIM(LsTPDCond)	+","
LsCadena = LsCadena +	ALLTRIM(LsNomCond)	+","
LsCadena = LsCadena +	ALLTRIM(LsApeCond)	+","
LsCadena = LsCadena +	ALLTRIM(LsLicCond) 	+","
LsCadena = LsCadena +	'ATTACH_DOC'		+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(5)	
LsCadena = LsCadena +	ALLTRIM(LsPlaTra)	+","
LsCadena = LsCadena +	ALLTRIM(LsTarUCir)	+","
LsCadena = LsCadena +	ALLTRIM(LsNroAutv)	+","
LsCadena = LsCadena +	ALLTRIM(LsCdEntemiV)	+","
LsCadena = LsCadena +	'ATTACH_DOC'											+","	
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(6)	
LsCadena = LsCadena +	ALLTRIM(LsNContene)		+","
LsCadena = LsCadena +	ALLTRIM(LsNPrecint)		+","
LsCadena = LsCadena +	'ATTACH_DOC'											+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(7)	
LsCadena = LsCadena +	ALLTRIM(GsNomCia)		+","
LsCadena = LsCadena +	ICASE(LEN(trim(GsRucCia))=11,'6',LEN(TRIM(GsRucCia))=8,'1','0')	+","
LsCadena = LsCadena +	ALLTRIM(GsRucCia)		+","	
LsCadena = LsCadena +	ALLTRIM(LsUbiRemit)		+","	
LsCadena = LsCadena +	ALLTRIM(LsDirRemit)		+","
LsCadena = LsCadena +	ALLTRIM(LsUrbRemit)		+","
LsCadena = LsCadena +	ALLTRIM(LsPrvRemit)		+","
LsCadena = LsCadena +	ALLTRIM(LsDepRemit)		+","	
LsCadena = LsCadena +	ALLTRIM(LsDisRemit)		+","
LsCadena = LsCadena +	ALLTRIM(LsCodPaisR)		+","
LsCadena = LsCadena +	ALLTRIM(LsAutRemit)		+","
LsCadena = LsCadena +	ALLTRIM(LsCdEntemiR)	+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(8)
LsCadena = LsCadena +	ALLTRIM(PoDataAdi.NomCli)		+","
LsCadena = LsCadena +	ICASE(LEN(trim(PoDataCab.CodCli))=11,'6',LEN(TRIM(PoDataCab.CodCli))=8,'1','0')	+","
LsCadena = LsCadena +	ALLTRIM(PoDataCab.CodCli)	+","	
LsCadena = LsCadena +	ALLTRIM(LsUbiDest)		+","	
LsCadena = LsCadena +	ALLTRIM(LsDirDest)		+","
LsCadena = LsCadena +	ALLTRIM(LsUrbDest)		+","
LsCadena = LsCadena +	ALLTRIM(LsPrvDest)		+","
LsCadena = LsCadena +	ALLTRIM(LsDepDest)		+","	
LsCadena = LsCadena +	ALLTRIM(LsDisDest)		+","
LsCadena = LsCadena +	ALLTRIM(LsCdPaisD)		+","
LsCadena = LsCadena +	ALLTRIM(LsEmailDest)	+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(9)
LsCadena = LsCadena +	ALLTRIM(LsNomProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsTDocProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsRucProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsUbiProv)		+","	  
LsCadena = LsCadena +	ALLTRIM(LsDirProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsUrbProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsPrvProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsDepProv)		+","	
LsCadena = LsCadena +	ALLTRIM(LsDisProv)		+","		
LsCadena = LsCadena +	ALLTRIM(LsCodPaisP)		+"," 	
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(10)	
LsCadena = LsCadena +	TRANSFORM(PoDataCab.Motivo,'@L ##')		+"," 
LsCadena = LsCadena +	ALLTRIM(LsDesMot)						+","						
LsCadena = LsCadena +	ALLTRIM(LsIndTProg)						+","
LsCadena = LsCadena +	ALLTRIM(STR(LfPesoBruto,10,2))			+","
LsCadena = LsCadena +	ALLTRIM(LsUndMed)						+","
LsCadena = LsCadena +	ALLTRIM(LsModTra)						+","
LsCadena = LsCadena +	IIF(EMPTY(LdFIniTras),"",TRANSFORM(DTOS(LdFIniTras), "@R ####-##-##"))	+","
LsCadena = LsCadena +	ALLTRIM(LsNomTra)						+","
LsCadena = LsCadena +	ALLTRIM(LsTDTransp)						+","
LsCadena = LsCadena +	ALLTRIM(LsRucTra)						+","
LsCadena = LsCadena +	ALLTRIM(LsUbiPPart)						+","
LsCadena = LsCadena +	ALLTRIM(LsDirPPart)						+","
LsCadena = LsCadena +	ALLTRIM(LsUrbPPart)						+","
LsCadena = LsCadena +	ALLTRIM(LsPrvPPart)						+","
LsCadena = LsCadena +	ALLTRIM(LsDepPPart)						+","
LsCadena = LsCadena +	ALLTRIM(LsDisPPart)						+","
LsCadena = LsCadena +	ALLTRIM(LsUbiPLleg)						+","
LsCadena = LsCadena +	ALLTRIM(LsDirPLleg)						+","
LsCadena = LsCadena +	ALLTRIM(LsUrbPLleg)						+","							
LsCadena = LsCadena +	ALLTRIM(LsPrvPLleg)						+"," 
LsCadena = LsCadena +	ALLTRIM(LsDepPLleg)						+","	
LsCadena = LsCadena +	ALLTRIM(LsDisPLleg)						+","

DO CASE 
	CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '01')
		LsCadena = LsCadena +	ALLTRIM(STR(LnNroBultos,6))				+","
		LsCadena = LsCadena +	""										+","
		LsCadena = LsCadena +	""										+","
		LsCadena = LsCadena +	""										+","
		LsCadena = LsCadena +	ALLTRIM(LsNroRegMTC)					+","
		LsCadena = LsCadena +	ALLTRIM(LsNroAutTra)					+","
		LsCadena = LsCadena +	ALLTRIM(LsEntEmiTra)					+","
	CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '04')
		LsCadena = LsCadena +',,,,,,,,,,,,,,,,,,,'						+","
		LsCadena = LsCadena + ALLTRIM(GsRucCia)							+","
		LsCadena = LsCadena + ALLTRIM(LsCodEstPart)						+","
		LsCadena = LsCadena + IIF(!EMPTY(LsLongPart),ALLTRIM(STR(LsLongPart,3,8)),"")	+","
		LsCadena = LsCadena + IIF(!EMPTY(LsLatiPart),ALLTRIM(STR(LsLatiPart,3,8)),"")	+","	
		LsCadena = LsCadena + ALLTRIM(GsRucCia)							+","
		LsCadena = LsCadena + ALLTRIM(LsCodEstLleg)						+","
		LsCadena = LsCadena + ',,,,,,,,,,,,,,,'							+","
	CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '13')
		LsCadena = LsCadena +	ALLTRIM(STR(LnNroBultos,6))				+","
		LsCadena = LsCadena +	""										+","
		LsCadena = LsCadena +	""										+","
		LsCadena = LsCadena +	""										+","
		LsCadena = LsCadena +	ALLTRIM(LsNroRegMTC)					+","
		LsCadena = LsCadena +	ALLTRIM(LsNroAutTra)					+","
		LsCadena = LsCadena +	ALLTRIM(LsEntEmiTra)					+","
		LsCadena = LsCadena +	',,,,,,,,,,,,'							+","
		LsCadena = LsCadena + ALLTRIM(GsRucCia)							+","
		LsCadena = LsCadena + ALLTRIM(LsCodEstPart)						+","
		LsCadena = LsCadena + IIF(!EMPTY(LsLongPart),ALLTRIM(STR(LsLongPart,3,8)),"")	+","
		LsCadena = LsCadena + IIF(!EMPTY(LsLatiPart),ALLTRIM(STR(LsLatiPart,3,8)),"")	+","	
		LsCadena = LsCadena + ALLTRIM(PoDataAdi.RucCli)					+","
		LsCadena = LsCadena + ALLTRIM(LsCodEstDes)						+","
		LsCadena = LsCadena + IIF(!EMPTY(LsLongPLleg),ALLTRIM(STR(LsLongPLleg,3,8)),"")	+","
		LsCadena = LsCadena + IIF(!EMPTY(LsLatiPLleg),ALLTRIM(STR(LsLatiPLleg,3,8)),"")	+","	
ENDCASE
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(11)
LsCadena = LsCadena +   ALLTRIM(PoDataCab.Observ)						+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(12)
** VETT: Agregamos items del detalle de  G/R IDUPD:659158006-28/12/2023 08:50 PM 

SELECT cDVta
LOCATE
SCAN
	LsCadena = LsCadena + ALLTRIM(STR(cDvta.nroitm,4,0))				+","
	LsCadena = LsCadena + ALLTRIM(ICASE(cDVta.UndVta='KG','KGM',cDVta.UndVta='MTS','MTR',cDVta.UndVta='ROL','RO','NIU'))				+","
	LsCadena = LsCadena + ALLTRIM(ICASE(cDVta.UndVta='KG','KILOGRAMOS',cDVta.UndVta='MTS','METROS',cDVta.UndVta='ROL','RO','UNIDAD'))	+","
	LsCadena = LsCadena + ALLTRIM(STR(cDVta.CanDes,12,4))	+","
	LsCadena = LsCadena + ALLTRIM(cDVta.DesMat)				+","
	LsCadena = LsCadena + ALLTRIM(cDVta.CodMat)				+","
	LsCadena = LsCadena +   CRLF	
ENDSCAN
LsCadena = LsCadena +		'FF00FF'

IF USED("cDVta")
	USE IN cDVta
ENDIF
	
=fput(LnControlArc,LsCadena)    
=fclose(LnControlArc)

** VETT: txt a csv con formato UTF-8 sin BOM IDUPD:1861213826-28/12/2023 07:20 PM
LcString = FILETOSTR(LsRuta+LsNomArc)	
LcFileCSV=ADDBS(JUSTPath(LsRuta+LsNomArc))+JUSTSTEM(LsRuta+LsNomArc)+LsExtFile2
STRTOFILE(STRCONV(lcString,9),LcFileCSV)	
** VETT: [FIN] IDUPD:1861213826-28/12/2023 07:20 PM

** VETT: Grabamos copia de respaldo en ruta secundaria IDUPD:2454762601-11/01/2024 03:22 PM 	
IF !EMPTY(PsRutB)	
	COPY FILE (LcFileCSV) TO ADDBS(goentpub.tspath_ose_csv)+JUSTFNAME(LcFileCSV)
ENDIF	
** VETT: [FIN] IDUPD:2454762601-11/01/2024 03:22 PM 	

RETURN

********************************
PROCEDURE Genera_Cadena_CSV_FB 
********************************
PARAMETERS PoDataCab,PsRuta,PsRutB
	
LsCodDoc	=ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08',"XX")
LsLetSer	=ICASE(INLIST(PoDataCab.CodDoc,'FACT','BOLE'),LEFT(PoDataCab.CodDoc,1),INLIST(PoDataCab.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodDoc,1),'X')
LsSerie		=RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroDoc,2,3)),4)
LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8)+'.txt'
LsNroDoc    =LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,5)),8)

** Ruta y apertura de archivo
Lsruta   = ADDBS(TRIM(PsRuta)) && curdir()+lruta   
IF !DIRECTORY(Lsruta)
	MKDIR (Lsruta)
ENDIF	
IF FILE(Lsruta+LsNomArc)
	DELETE FILE (Lsruta+LsNomArc)
ENDIF
IF .f.
LnControlArc = fcreate(Lsruta+LsNomArc)
ELSE
LnControlArc = 0
ENDIF
if LnControlArc<0
   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Cabecera de venta')
   RETURN .f.
ENDIF

** VETT: Convertimos a cursor los objetos que tiene los datos del detalle y documentos adicionales IDUPD:2521759342-21/02/2024 02:27 PM
gocfgvta.odatadm.obj2cur(PoDataDet,'cDVta')

LnTotItmDoc = cursor_esta_vacio("cDVta",.t.)
IF VARTYPE(LnTotItmDoc)<>"N"
	LnTotItmDoc = 0
ENDIF

STORE 0 TO LnTDocAdj,LnCuotas,LnGuias,LnDocAdi 

** Doc. adjuntos - Cuotas - G/Remision **
gocfgvta.odatadm.obj2cur(PoDataAdi,'cGuias')	
LnGuias = cursor_esta_vacio("cGuias",.t.)
IF gocfgvta.L_VTARCUOT
	gocfgvta.odatadm.obj2cur(PoDataAdi2,'cCuotas')	
	LnCuotas = cursor_esta_vacio("cCuotas",.t.)
ELSE
	LnCuotas = 0
ENDIF
LnCuotas = IIF(LnCuotas<0,0,LnCuotas)
** Creamos un cursor temporal para documentos adadjuntos adicionales sin entidad asociada
SELECT 0
Select Nrodoc , space(2) AS CdSunat  from cDvta where 0>1 INTO CURSOR cDocAdi
LnDocAdi 	= cursor_esta_vacio("cDocAdi",.t.)
LnTDocAdj	=   LnGuias + LnCuotas + LnDocAdi

LlDocAdj	=	LnTDocAdj>0 


** Datos Adicionales **
Store "" TO LsCodFac,LsCodRef
If  LnGuias >0
	LsCodRef	=	ICASE(cGuias.CodDoc='FACT','01',cGuias.CodDoc='BOLE','03',cGuias.CodDoc='N/C','07',cGuias.CodDoc='N/D','08',cGuias.CodDoc='G/R','09',"YY")
	LsNroRef	=	cGuias.NroDoc
ENDIF
If  LnCuotas >0
	LsCodFac	=	ICASE(cCuotas.CodDoc='FACT','01',cCuotas.CodDoc='BOLE','03',cCuotas.CodDoc='N/C','07',cCuotas.CodDoc='N/D','08',cCuotas.CodDoc='G/R','09',"YY")
	LsNroFac	=	cCuotas.NroDoc
ENDIF
LsDesDREL	=	ICASE(LsCodRef='01','FACTURA',LsCodRef='03','BOLETA',LsCodRef='09','GUIA REMISION REMITENTE','OTROS DOCUMENTOS')

LsCdPaisD	=	"PE"

DIMENSION aFila(30)
STORE "" TO aFila
LsVerDOC	= "2.0"
IF VARTYPE(GsNomCom)='U'
	GsNomCom = GsNomCia  && Nombre comercial
ENDIF	
LsTpoRef	=	PoDataCab.TpoRef
**LsCodRef	=	PoDataCab.CodRef
LfTotAnti	= 0
LfTotVta	= 0  && PoDataCab.ImpBto+PoDataCab.ImpIgv+PoDataCab.ImpAdm-PoDataCab.ImpDto-LnTotAnt
LsFecha		= TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##")
LsFchVto	= {} && IIF(!EMPTY(PoDataCab.FchVto),TRANSFORM(DTOS(PoDataCab.FchVto), "@R ####-##-##"),"-")
*!*		LsDesMot	= IIF(SEEK(PADR(GsMotivo,LEN(MTABL.Tabla))+TRANSFORM(PoDataCab.Motivo,"@L ##"),"MTABL","TABL01"),ALLTRIM(STUFF(MTABL.Nombre,1,ATC("-",MTABL.Nombre),"")),'Descripción motivo traslado') 
*!*		LsDesMot	= IIF(!EMPTY(PoDataAdi.Desmotivo),PoDataAdi.Desmotivo,LsDesMot)
LnCnGRef	= 0  && ???
LfBaseIGV	=	PoDataCab.ImpBto
LsMoneda	=	IIF(LfBaseIGV>=0,ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','XXX'),"")
LfPorIgv	=	PoDataCab.PorIgv	&& Porcentaje del IGV
LfTotalIGV	=	PoDataCab.ImpIgv
 
LfTotVta 	=	PoDataCab.ImpBto+PoDataCab.ImpIgv+PoDataCab.ImpAdm-PoDataCab.ImpDto-LfTotAnti 
*!*	LnTotItmDoc	=	PoDataCab.NroItm 
LlDocAdj	= .F.
LfBaseISC	= 0
LfTotalISC	= 0
LsMonedaISC	= IIF(LfBaseISC>0,ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','XXX'),"")
LfBaseOTR	= 0
LfTotalOTR	= 0
LsMonedaOTR	=	IIF(LfBaseOTR>0,ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','XXX'),"")
LsCndPgo	=	PoDataCab.CndPgo
LnDiaVto	=	PoDataCab.Diavto
LsFmaPgo	=	ICASE(LsCndPgo="C/E","Contado",LnDiavto>0 and !empty(LsCndPgo),"Credito")
LfSdoDoc	=	PoDataCab.SdoDoc
LsTipOpe	=	"0101"
STORE 0 TO LfTotICBPER,LfTotGrat,LfTotExport,LfImpOpeGra
LfTotInaf	=	0
LfTotExon	=	0
** Variables percepción
LfBasPerc	=	0
LfTotPerc	=	0
LsCodPerc	=	IIF(LfBasPerc<=0,"","51") && "51"  Código del régimen de la percepción CATALOGO Nº 53
** Variables detracción
LsCodDETR	= ""
LsCtaDETR	= ""
LfImpDETR	= PoDataCab.ImpDETR
LfPorDETR	= PoDataCab.PorDETR

LsCodDETR	= IIF(LfImpDETR<=0,"",PoDataCab.CAT54DETR) && AD Código de bien o servicio de la detracción CATALOGO Nº 54 &&IIF(SEEK(TRIM(GsTbDETR)+PoDataCab.CAT54DETR,"MTABL","TABL01"),TRIM(MTABL.Nombre)
LsCtaDETR	= IIF(LfImpDETR<=0,"",IIF(SEEK(GsCtDETR,"CTAS" ,"CTAS01"),TRIM(CTAS.NroCta) ,"NO DEFINIDO")) && Variable GsCtDETR configurada en ADMTCNFG
LsTipOpe	= IIF(LfImpDETR<=0,"0101","1001")	
LfTotDETR	= IIF(!INLIST(LsTipOpe,"1001","1002","1003","1004"),0,PoDataCab.ImpDETR	+ LfTotVta) 	&& PoDataCab.ImpTot
LsMPagoDETR = "999"     && CATALOGO Nº 59
** Variables retención
LfBasRETE	= 0
LfFacRETE	= 0 && Ejem: Si es 3% debe expresarse como 0.03
LfTotRETE	= 0

** Anticipos **
LfTotAnti 	= 0  && Total anticipos
LnCnAntAs	= IIF(LfTotAnti>0,1,0)
** Descuentos **
LfDtogAB	=	0
LfDtogNoAB	=	0
LfAntiGrav  =	0	&& AT Monto anticipo gravado IGV o IVAP
LfAntiExon	=	0
LfAntiInaf	=	0
LfBaseFise	= 	0
LfTotFise	=	0	&& Monto total Fise

LfRecargos	=	0	&& Recargo al consumo y/o propinas 
LfCargoGAB	=	0 	&& Monto cargo global AB
LfCarGNoAB	=	0   && Monto cargo global no AB

LfTotTribu	=	PoDataCab.ImpIgv + LfTotalISC + LfTotalOTR + LfTotICBPER
LfTotVenta	=	LfBaseIGV -  LfDtogAB + LfCargoGAB

LfTAntISCAB	=	0	&& Monto total anticipo ISC que AB

LfTotPreVta	=	LfTotVenta + LfTotalISC + LfTotalOTR + LfTotICBPER + (LfTotVenta)*LfPorIgv/100 
LfTDtoNoABIt=	0	&&	Montos total descuento no AB de los ítems 
LfTRet2cNoAB=	0	&&	Monto total Retención de renta de segunda categoría que no AB. Mandatorio si Tipo Operacion "2002"
LfTotDtoNoAB=	LfTDtoNoABIt + LfDtogNoAB	+  LfTRet2cNoAB
LfTCarNoABIt=	0	&&  Montos total cargo no AB' de los ítems
LfTotCarNoAB=	LfTCarNoABIt + 	LfTotFise + LfRecargos + LfCarGNoAB		&& BF Total cargos no AB
LfRedondeo	=	0	&&  BG Monto para Redondeo del Importe Total 
LfTDtoABIt	=	0	&&	Montos total descuento AB de los ítems
LfTotDtoAB	=	LfTDtoABIt + LfDtogAB 	&& BH 	Total descuentos AB
LfTotAntiISC=	0	&& Monto total Anticipo ISC que AB
LfBRet2cNoAB=	0	&& BJ Monto base Retención de renta de segunda categoría que no AB. Mandatorio si Tipo Operacion "2002"

LnPartLle = 0
** Fila 5 
LsUbiEmisor	= ""			&& Ubigeo emisor
LsNomUrbEmi	= ""			&& Urbanizacion emisor
LsCodPaisE 	= "PE"			&& Codigo Pais emisor
LsCodEstEmi	= ""			&& Codigo de establecimiento emisor
LsDirEmisor	= GsDircia
SELECT SEDES
Locate For Cod_sunat='0000'
IF FOUND()
	LsUbiEmisor	=	SEDES.Ubigeo
	LsNomUrbEmi	= 	SEDES.Nomurban
	LsCodEstEmi	=	SEDES.CodEstb
	LsDirEmisor = 	IIF(!EMPTY(SEDES.Dir_Sunat),SEDES.Dir_Sunat,GsDirCia)
ELSE
	SELE AUXI
	Locate For CodEstb='0000'
	IF FOUND()
		LsUbiEmisor	=	AUXI.Ubigeo
		LsNomUrbEmi	=	AUXI.Nomurban
		LsCodEstEmi	=	AUXI.CodEstb
		LsDirEmisor =	IIF(!EMPTY(AUXI.NomAux),AUXI.NomAux,GsDirCia)
	ENDIF	
ENDIF	
LsDepEmi	= IIF(SEEK(LEFT(LsUbiEmisor,2),"ZONA"),UPPER(ZONA.deszona),"")			&& Departamento emisor
LsPrvEmi	= IIF(SEEK(LEFT(LsUbiEmisor,4),"PROV"),UPPER(PROV.DesPRovin),"")		&& Provincia emisor
LsDisEmi	= IIF(SEEK(LEFT(LsUbiEmisor,6),"DIST"),UPPER(DIST.desdist),"")			&& Distrito emisor
** Fila 6
LsNomComRec	= ""
LsUbiRecept	= ""
LsTDRecept	= ICASE(LEN(trim(PoDataCab.CodCli))=11,'6',LEN(TRIM(PoDataCab.CodCli))=8,'1','0')
IF !USED("DIRE")
	=goCfgVta.odatadm.abrirtabla("ABRIR","CCTCDIRE","DIRE","DIRE02")
ENDIF
SELECT DIRE
SEEK GsClfCli+PoDataCab.CodCli
LsUbiRecept	= DIRE.Ubigeo
LsEstRecept	= DIRE.CodEstb
LsNomUrbRec = DIRE.NomUrban
LsDepRecept	= IIF(SEEK(LEFT(LsUbiRecept,2),"ZONA"),UPPER(ZONA.deszona),"")		&& Departamento receptor
LsPrvRecept	= IIF(SEEK(LEFT(LsUbiRecept,4),"PROV"),UPPER(PROV.DesPRovin),"")	&& Provincia receptor
LsDisRecept	= IIF(SEEK(LEFT(LsUbiRecept,6),"DIST"),UPPER(DIST.desdist),"")		&& Distrito receptor
LsCodPaisR	= "PE"
LsEmailRec	= DIRE.EmailD    
** Armamos la cadena **
LsCadena = 				aFila(1)														  && es solo para guiar al que viene por 1era vez
LsCadena = LsCadena +	LsFecha											 			+","  && A Fecha 
LsCadena = LsCadena + 	LsNroDoc													+","  && B NroDoc 
LsCadena = LsCadena +	LsCodDoc													+","  && C Codigo Documento Sunat 
LsCadena = LsCadena +	LsMoneda													+","  && D Moneda
LsCadena = LsCadena +	STRX(LfBaseIGV,15,2)										+","  && E Sumatoria monto base IGV o IVAP
LsCadena = LsCadena +	STRX(LfTotalIGV,15,2)										+","  && F Total IGV o IVAP
LsCadena = LsCadena +	LsMoneda													+","  && G Tipo de moneda del IGV o IVAP.
LsCadena = LsCadena +	STRX(LfBaseISC,15,2)										+","  && H Sumatorio monto base ISC
LsCadena = LsCadena +	STRX(LfTotalISC,15,2)										+","  && I Sumatoria monto total ISC 
LsCadena = LsCadena +	LsMonedaISC													+","  && J Tipo moneda ISC
LsCadena = LsCadena +	STRX(LfBaseOTR,15,2)										+","  && K Sumatoria monto base Otros tributos
LsCadena = LsCadena +	STRX(LfTotalOTR,15,2)										+","  && L Sumatoria total Otros tributos
LsCadena = LsCadena +	LsMonedaOTR													+","  && M Tipo moneda Otros tributos
LsCadena = LsCadena +	STRX(LfTotVta,15,2)											+","  && N PayableAmount/Total Venta 
LsCadena = LsCadena +	LsFmaPgo													+","  && O Forma de pago
LsCadena = LsCadena +	STRX(LfTotVta - LfImpDETR,15,2)											+","  && P Monto neto pendiente de pago 
LsCadena = LsCadena +	LsTipOpe													+","  && Q Tipo operación 
LsCadena = LsCadena +	SPACE(0)													+","  && R 
LsCadena = LsCadena +	STRX(LfTotICBPER,15,2)										+","  && S Sumatoria monto total ICBPER 
LsCadena = LsCadena +	STRX(LfImpOpeGra,15,2)										+","  && T Sumatoria de impuestos de operaciones gratuitas 
LsCadena = LsCadena +	STRX(LfTotExport,15,2)										+","  && U Total operaciones Exportación 
LsCadena = LsCadena +	STRX(LfBaseIGV  ,15,2)										+","  && V Total operaciones gravadas IGV o IVAP
LsCadena = LsCadena +	STRX(LfTotInaf,15,2)										+","  && Total operaciones Inafectas
LsCadena = LsCadena +	STRX(LfTotExon,15,2)										+","  && Total operaciones exoneradas
LsCadena = LsCadena +	STRX(LfTotGrat,15,2)										+","  && Total operaciones Gratuitas
LsCadena = LsCadena +	SPACE(0)													+","  && Z
LsCadena = LsCadena +	STRX(LfBasPerc,15,2)										+","  && Monto base de la percepción
LsCadena = LsCadena +	STRX(LfTotPerc,15,2)										+","  && Monto total de la percepción
LsCadena = LsCadena +	STRX(LfBasPerc+LfTotPerc,15,2)								+","  && Importe Total incluido la percepción
LsCadena = LsCadena +	LsCodDETR													+","  && AD Código de bien o servicio de la detracción
LsCadena = LsCadena +	STRX(LfImpDETR,15,2)										+","  && AE Monto detraído de la detracción
LsCadena = LsCadena +	STRX(LfPorDETR, 3,5)										+","  && AF Porcentaje de la detracción
LsCadena = LsCadena +	LsCtaDETR													+","  && Numero cuenta corriente en el Banco de la Nación
LsCadena = LsCadena +	STRX(LfTotDETR,15,2)										+","  && Importe total incluido la detracción
LsCadena = LsCadena +	STRX(LfBasRETE,15,2)										+","  && AI Monto base retención del IGV
LsCadena = LsCadena +	STRX(LfFacRETE,3,5)											+","  && AJ Factor retención del IGV	
LsCadena = LsCadena +	STRX(LfTotRETE,15,2)										+","  && Monto total retención del IGV								
LsCadena = LsCadena +	STRX(LnTotItmDoc,3)											+","  && AL Cantidad de lineas del documento
LsCadena = LsCadena +	LsCodPerc													+","  && Código del régimen de la percepción CATALOGO Nº 53
LsCadena = LsCadena +	STRX(LnTDocAdj,3)											+","  && AN Cantidad guías, otros documentos y pago único o cuotas relacionadas
LsCadena = LsCadena +	STRX(LnCnAntAs,3)											+","  && Cantidad de anticipos asociados												
LsCadena = LsCadena +	STRX(LfTotAnti,15,2)										+","  && AP Total anticipos
LsCadena = LsCadena +	STRX(LnPartLle,3)											+","  && AQ Cantidad de punto de partida y llegada										
LsCadena = LsCadena +	STRX(LfDtogAB ,15,2)										+","  && AR Monto descuento global AB
LsCadena = LsCadena +	STRX(LfDtogNoAB,15,2)										+","  && AS Monto descuento global no AB
LsCadena = LsCadena +	STRX(LfAntiGrav,15,2)										+","  && AT Monto anticipo gravado IGV o IVAP
LsCadena = LsCadena +	STRX(LfAntiExon,15,2)										+","  &&	Monto anticipo exonerado
LsCadena = LsCadena +	STRX(LfAntiInaf,15,2)										+","  &&	Monto anticipo inafecto
LsCadena = LsCadena +	STRX(LfbaseFise,15,2)										+","  &&	Monto base FISE
LsCadena = LsCadena +	STRX(LfTotFise ,15,2)										+","  && AX Monto total FISE
LsCadena = LsCadena +	STRX(LfRecargos,15,2)										+","  && AY	Recargo al consumo y/o propinas
LsCadena = LsCadena +	STRX(LfCargoGAB,15,2)										+","  && AZ	Monto cargo global AB
LsCadena = LsCadena +	STRX(LfCarGNoAB,15,2)										+","  && BA	Monto cargo global no AB
LsCadena = LsCadena +	STRX(LfTotTribu,15,2)										+","  && BB	Monto total de impuestos
LsCadena = LsCadena +	STRX(LfTotVenta,15,2)										+","  && BC	Total Valor de Venta
LsCadena = LsCadena +	STRX(LfTotPreVta,15,2)										+","  && BD Total precio de venta	
LsCadena = LsCadena +	STRX(LfTotDtoNoAB,15,2)										+","  && BE Total descuentos no AB	
LsCadena = LsCadena +	STRX(LfTotCarNoAB,15,2)										+","  && BF Total cargos no AB
LsCadena = LsCadena +	STRX(LfRedondeo  ,15,2)										+","  && BG Monto para Redondeo del Importe Total
LsCadena = LsCadena +	STRX(LfTotDtoAB  ,15,2)										+","  && BH Total descuentos AB
LsCadena = LsCadena +	STRX(LfTotAntiISC,15,2)										+","  && BI Monto total Anticipo ISC que AB
LsCadena = LsCadena +	STRX(LfBRet2cNoAB,15,2)										+","  && BJ Monto base Retención de renta de segunda categoría que no AB
LsCadena = LsCadena +	STRX(LfTRet2cNoAB,15,2)										+","  && BK Monto total Retención de renta de segunda categoría que no AB
LsCadena = LsCadena +   CRLF														      && CRLF = CHR(13)+CHR(10) esta definido en const.h 
LsCadena = LsCadena +	aFila(2)
LsCadena = LsCadena + ',,,,,,,,,,,,,,,,,,,,,,,,,,,'									+","
LsCadena = LsCadena +   CRLF
LsCadena = LsCadena +	aFila(3)	
LsCadena = LsCadena + ',,,,,,'														+","
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(4)	
IF LnTDocAdj<=0
	LsCadena = LsCadena + ',,,,,'													+","
	LsCadena = LsCadena +   CRLF
ELSE
	** Guias adjuntas
	IF LsCodRef = "09"	&& LsCodRef="G/R"
		SELECT cGuias
		SCAN
			LsCadena = LsCadena + 	STUFF(ALLTRIM(cGuias.NroDoc), 5, 1, "-")		+","
			LsCadena = LsCadena +	LsCodRef										+","
			LsCadena = LsCadena +	",,ATTACH_DOC"									+","
			LsCadena = LsCadena +   CRLF	
		ENDSCAN
	ENDIF
	** Otros documentos adjuntos
	IF LnDocAdi>0
		SELECT cDocAdi
		SCAN
			LsCadena = LsCadena + 	',,'+ALLTRIM(cDocAdi.NroDoc)	+","
			LsCadena = LsCadena +	+ALLTRIM(cDocAdi.CdSunat)		+","
			LsCadena = LsCadena +	"ATTACH_DOC"					+","
			LsCadena = LsCadena +   CRLF	
		ENDSCAN
	ENDIF
	** Cuotas
	IF LsFmaPgo = "Credito" AND LnCuotas>0
		SELECT cCuotas
		SCAN
			LsCuota="Cuota"+RIGHT("000"+cCuotas.Nrocta,3)
			LsFchCob=TRANSFORM(DTOS(FchCob), "@R ####-##-##")
			LsCadena = LsCadena + 	',,,,'+LsCuota					+","
			LsCadena = LsCadena +	+STRX(cCuotas.Import,15,2)		+","
			LsCadena = LsCadena +	LsFchCob						+","
			LsCadena = LsCadena +	"ATTACH_DOC"					+","
			LsCadena = LsCadena +   CRLF	
		ENDSCAN
	ENDIF	
ENDIF	

LsCadena = LsCadena +	aFila(5)
LsCadena = LsCadena +	ALLTRIM(GsNomCia)		+","			&&	A
LsCadena = LsCadena +	ALLTRIM(GsNomCom)		+","			&&	B
LsCadena = LsCadena +	ALLTRIM(GsRucCia)		+","			&&	C
LsCadena = LsCadena +	ALLTRIM(LsUbiEmisor)	+","			&&	D
LsCadena = LsCadena +	ALLTRIM(LsDirEmisor)	+","			&&	E
LsCadena = LsCadena +	ALLTRIM(LsNomUrbEmi)	+","			&&	F
LsCadena = LsCadena +	ALLTRIM(LsDepEmi)		+","			&&	G
LsCadena = LsCadena +	ALLTRIM(LsPrvEmi)		+","			&&	H	
LsCadena = LsCadena +	ALLTRIM(LsDisEmi)		+","			&&	I
LsCadena = LsCadena +	ALLTRIM(LsCodPaisE)		+","			&&	J
LsCadena = LsCadena +	ALLTRIM(LsCodEstEmi)	+","			&&	K
LsCadena = LsCadena +   CRLF
LsCadena = LsCadena +	aFila(6)	
LsCadena = LsCadena +	ALLTRIM(PoDataCab.CodCli)	+","	&& A
LsCadena = LsCadena +	ALLTRIM(LsTDRecept)			+","	&& B
LsCadena = LsCadena +	ALLTRIM(PoDataCab.NomCli)	+","	&& C
LsCadena = LsCadena +	ALLTRIM(LsNomComRec)		+","	&& D
LsCadena = LsCadena +	ALLTRIM(LsUbiRecept)		+","	&& E
LsCadena = LsCadena +	ALLTRIM(PoDataCab.DirCli)	+","	&& F
LsCadena = LsCadena +	ALLTRIM(LsNomUrbRec)		+","	&& G
LsCadena = LsCadena +	ALLTRIM(LsDepRecept)		+","	&& H
LsCadena = LsCadena +	ALLTRIM(LsPrvRecept)		+","	&& I
LsCadena = LsCadena +	ALLTRIM(LsDisRecept)		+","	&& J
LsCadena = LsCadena +	ALLTRIM(LsCodPaisR)			+","	&& K
LsCadena = LsCadena +	ALLTRIM(LsEmailRec)			+","	&& L
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(7)	
LsCadena = LsCadena +	NUMERO(LfTotVta,2,1)		+","	&& A
DO CASE
	CASE	LfBasPerc>0 
		LsCadena = LsCadena +   ",COMPROBANTE DE PERCEPCIÓN,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
	CASE	LfImpDETR>0
		LsCadena = LsCadena +   ",,,,,,,Operación sujeta a detracción,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
	OTHERWISE 	
		LsCadena = LsCadena +   ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
ENDCASE	
LsCadena = LsCadena +   CRLF	
LsCadena = LsCadena +	aFila(8)
DO CASE
	CASE  LfImpDETR>0
		LsCadena = LsCadena +   ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
		LsCadena = LsCadena +   ALLTRIM(LsMPagoDETR)+ ",,,,,,,,,,,,,,,,,,,"
	OTHERWISE 	
		LsCadena = LsCadena +   ",,,,,,,,,,,,,,"
ENDCASE							 
LsCadena = LsCadena +   CRLF
LsCadena = LsCadena +	aFila(9)

** VETT: Agregamos items del detalle de FACT/BOLE ** VETT:  IDUPD:2135419316-22/02/2024 04:43 AM
LsCdTpoTrib	= "1000"	&& Codigo de tipo de tributo 	
LsCdPreVtaU	= '01'		&& Código de tipo de precio de venta unitario (Catálogo No. 16)
LsCdPreRefU	= '01'		&& Código de tipo de precio de venta unitario (Catálogo No. 16)
LsCdTpoAfIGV=	'10'	&& Código de tipo de afectación del IGV	(Catálogo No. 07)
LsLsCdTpoISC=''			&& 01 Sistema al valor,02 Aplicación del Monto Fijo,03 Sistema de Precios de Venta al Público
LsCodTribISC=''			&& 2000
SELECT cDVta
LOCATE
SCAN
	LfPreuni 	= IIF(cDVta.CodDoc='FACT',cDVta.PreUni,ROUND(cDVta.PreUni/(1+LfPorIgv/100),3))
	LfBaseIgv	= IIF(cDVta.CodDoc='FACT',cDVta.ImpLin,ROUND(cDVta.implin/(1+LfPorIgv/100),2))
	LfIgvItem	= ROUND(LfBaseIgv *LfPorIgv/100 ,2)
	LfImpISC	= 0.00	
	LfTotISCit	= 0.00
	LfPreIGV	= ROUND(LfPreUni *( 1+LfPorIgv/100),4)
	LfPreRef	= 0.00
	LsCPSunat	=	""  && Codigo de producto Sunat    (Catálogo No. 25)
	LfValUnit	=	LfBaseIgv 
	IF LfPreRef<=0
		LsCdPreRefU	=	""
	ENDIF	
	LsCadena = LsCadena + ALLTRIM(STR(cDvta.nro_itm,3,0))	+","
	LsCadena = LsCadena + ALLTRIM(cDVta.UndVta)				+","
	LsCadena = LsCadena + STRX(cDVta.CanFac,12,10)			+","
	LsCadena = LsCadena + ALLTRIM(cDVta.DesMat)				+","
	LsCadena = LsCadena + STRX(LfPreIGV,12,10)				+","
	LsCadena = LsCadena + ALLTRIM(LsCdPreVtaU)				+","
	LsCadena = LsCadena + STRX(LfPreRef,12,10)				+","
	LsCadena = LsCadena + ALLTRIM(LsCdPreRefU)				+","
	LsCadena = LsCadena + STRX(LfBaseIgv,12,2)				+","
	LsCadena = LsCadena + STRX(LfIgvItem,12,2)				+","	
	LsCadena = LsCadena + ALLTRIM(LsCdTpoAfIGV)				+","	
	LsCadena = LsCadena + ALLTRIM(LsCdTpoTrib)				+","	
	LsCadena = LsCadena + STRX(LfPorIgv,3,5)				+","
	LsCadena = LsCadena + STRX(LfImpISC,12,2)				+","
	LsCadena = LsCadena + STRX(LfTotISCit,12,2)				+","
	LsCadena = LsCadena + ALLTRIM(LsLsCdTpoISC)				+","	
	LsCadena = LsCadena + ALLTRIM(LsCodTribISC)				+","	
	LsCadena = LsCadena + ALLTRIM(LsCPSunat)				+","
	LsCadena = LsCadena + ALLTRIM(cDVta.CodMat)				+","
	LsCadena = LsCadena + STRX(LfPreuni ,12,10)				+","
	LsCadena = LsCadena + STRX(LfBaseIgv,12,2)				+","
	LsCadena = LsCadena + ",,,,,,,,,,,,,,,"					
	LsCadena = LsCadena + STRX(LfIgvItem,12,2)				+","
	LsCadena = LsCadena + STRX(LfBaseIgv+LfIgvItem,12,2)	+","
	LsCadena = LsCadena + ",,,"
	LsCadena = LsCadena +   CRLF	
ENDSCAN
LsCadena = LsCadena +		'FF00FF'

IF USED("cDVta")
	USE IN cDVta
ENDIF

IF .F.	
=fput(LnControlArc,LsCadena)    
=fclose(LnControlArc)
ENDIF

** VETT:  
** VETT: txt a csv con formato UTF-8 sin BOM sin FCREATE IDUPD:3736051442-05/03/2024 12:15 PM 
*!*	LcString = FILETOSTR(LsRuta+LsNomArc)	
LcString = LsCadena
LcFileCSV=ADDBS(JUSTPath(LsRuta+LsNomArc))+JUSTSTEM(LsRuta+LsNomArc)+LsExtFile2
STRTOFILE(STRCONV(lcString,9),LsRuta+LsNomArc)
STRTOFILE(STRCONV(lcString,9),LcFileCSV)	
** VETT: [FIN] IDUPD:3736051442-05/03/2024 12:15 PM

** VETT: Grabamos copia de respaldo en ruta secundaria IDUPD:2454762601-11/01/2024 03:22 PM 	
IF !EMPTY(PsRutB)	
	COPY FILE (LcFileCSV) TO ADDBS(goentpub.tspath_ose_csv)+JUSTFNAME(LcFileCSV)
ENDIF	
** VETT: [FIN] IDUPD:3736051442-05/03/2024 12:15 PM	

RETURN
******************************
FUNCTION Genera_Cadena_CSV_NOT 
******************************
PARAMETERS PoDataCab,PsRuta,PsRutB
RETURN

*************
FUNCTION STRX
*************
PARAMETERS PfImport,PnDig,PnDec,PlNoZ
IF PCOUNT()<4
	PlNoZ=.F.
ENDIF
IF VARTYPE(PnDig)<>"N"
	PnDig =	0
ENDIF
IF VARTYPE(PnDec)<>"N"
	PnDec = 0
ENDIF
LsPict1 = IIF(PlNoZ,"","@Z ")
LsResult=""
LsPict 		=	IIF(PnDec>0,LsPict1+REPLICATE("9",PnDig)+"."+REPLICATE("9",PnDec),LsPict1+REPLICATE("9",PnDig))
LsResult	=	ALLTRIM(TRANSFORM(ROUND(PfImport,PnDec),LsPict))
LsResult    =	Remov0R(LsResult,"0")
RETURN LsResult
****************
FUNCTION Remov0R
****************
PARAMETERS PsCadena,LsChar
PRIVATE LsCadenaR
LnPosDec	=	RAT(".",PsCadena)
IF LnPosDec=0
	RETURN PsCadena
ENDIF
LnMaxLon	=	LEN(PsCadena)
posicion	=	LnMaxLon 	&& RAT(LsChar, PsCadena)
IF posicion=0
	RETURN PsCadena
ENDIF
*!*	Posicion = Posicion + 1
encontrado = .F.
DO WHILE posicion - LnPosDec > 2 AND NOT encontrado
  caracter = SUBSTR(PsCadena, posicion, 1)
  IF caracter $ ".123456789"
    encontrado = .T.
  ELSE
    posicion = posicion - 1
  ENDIF
ENDDO

LsCadenaR = SUBSTR(PsCadena,1, posicion)	&& STRTRAN(PsCadena,LsChar, "", -1,posicion)
RETURN LsCadenaR
**************************
FUNCTION cursor_esta_vacio
**************************
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

*LlHayRegistros = NOT THISFORM.Tools.cursor_esta_vacio("C_DTRA")
RETURN

PROCEDURE Junk_code

*** Convertimos a objeto el cursor con el detalle del documento ***
	oData2 = this.odatadm.genobjdatos(this.ccursor_d)    
			
	cKeyTpoDocSN = THIS.Codsed+This.XsCodDoc+This.XsPtoVta
	LnOk=this.oContab.Actualiza_Contabilidad(cQue_transaccion,cKeyTpoDocSN,@oData1,@oData2)
	
	THIS.oDatAdm.Obj2Cur(oData2,'cDetaVenta')
	
	
	LOCAL LoDatAdm as dataadmin OF SYS(5)+'\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
LOCAL LReturOk

Modificar  = gosvrcbd.mescerrado(_mes)

LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')