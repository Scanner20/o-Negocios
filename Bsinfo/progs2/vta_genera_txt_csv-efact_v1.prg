PARAMETERS PoDataCab as Object ,PoDataDet as Object,PoDataAdi as Object, PsRutA as Character, PsRutB as Character,PsVer as Character
IF VARTYPE(PsVer)<>'C'
*!*		PsVer = '1.2'
	** VETT:Actualización v1.3.2 2020/07/01 08:55:39 ** 
	PsVer = '1.3.2'
ENDIF
IF VARTYPE(PsRutB)<>"C"
	PsRutB	= ""
ENDIF
#include const.h 
IF .f. AND PoDataCab.NroRf1='E' AND INLIST(PoDataCab.TpoRf1,'FACT','BOLE','N/C','N/D')
	RETURN .T.
ENDIF


Lsruta   = ADDBS(TRIM(PsRuta))
LsCodDoc	=ICASE(PoDataCab.TpoRf1='FACT','01',PoDataCab.TpoRf1='BOLE','03',PoDataCab.TpoRf1='N/C','07',PoDataCab.TpoRf1='N/D','08',PoDataCab.TpoRf1='G/R','09')
LsLetSer	=ICASE(INLIST(PoDataCab.TpoRf1,'FACT','BOLE','G/R'),LEFT(PoDataCab.NroRf1,1),INLIST(PoDataCab.TpoRf1,'N/C','N/D'),LEFT(PoDataCab.NroRf1,1),'X')
LsSerie		=RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroRf1,2,3)),4)
LsExtFile1	=ICASE(INLIST(LsCodDoc,'01','03','09'),".txt",INLIST(LsCodDoc,'07','08'),".txt") 
LsExtFile2	=".csv"
LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8)+LsExtFile1	&&  '.CAB'

LlHayCuotas	= .F. 

*!*	DO Genera_Cadena_CAB WITH  PoDataCab,PsRuta
*!*	DO Genera_Cadena_DET WITH  PoDataDet,PsRuta,PoDataCab

DO CASE
	CASE INLIST(LsCodDoc,'01','03')
		DO Genera_Cadena_CSV_FB WITH  PoDataCab,PsRuta
	CASE INLIST(LsCodDoc,'07','08')
	
		DO Genera_Cadena_CSV_NOT WITH  PoDataCab,PsRuta
	CASE INLIST(LsCodDoc,'09')
		goentorno.open_dbf1("ABRIR","Zonas","Zona","Zona01")
		goentorno.open_dbf1("ABRIR","Provincias","Prov","Prov01")
		goentorno.open_dbf1("ABRIR","Distritos","DIST","DIST01")
		goentorno.open_dbf1("ABRIR","ALMTGSIS","ALMTGSIS","TABL01")
		goentorno.open_dbf1("ABRIR","CBDMTABL","CBDMTABL","TABL01")
		DO Genera_Cadena_CSV_GRE WITH  PoDataCab,PsRuta,PsRutB
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

IF USED('PROV')
	USE IN PROV
ENDIF
IF USED('DIST')
	USE IN DIST
ENDIF
IF USED('ZONA')
	USE IN ZONA
ENDIF
IF USED('ALMTGSIS')
	USE IN ALMTGSIS
ENDIF
IF USED('CBDMTABL')
	USE IN CBDMTABL
ENDIF

********************************
PROCEDURE Genera_Cadena_CSV_GRE 
********************************
PARAMETERS PoDataCab,PsRuta,PsRutB

	Lsruta   = ADDBS(TRIM(PsRuta)) && curdir()+lruta   
	IF !DIRECTORY(Lsruta)
		MKDIR (Lsruta)
	ENDIF	
	IF FILE(Lsruta+LsNomArc)
		DELETE FILE (Lsruta+LsNomArc)
	ENDIF
	
	
	LsCodDoc	=ICASE(PoDataCab.TpoRf1='FACT','01',PoDataCab.TpoRf1='BOLE','03',PoDataCab.TpoRf1='N/C','07',PoDataCab.TpoRf1='N/D','08',PoDataCab.TpoRf1='G/R','09',"")
	LsLetSer	=ICASE(INLIST(PoDataCab.TpoRf1,'FACT','BOLE','G/R'),LEFT(PoDataCab.NroRf1,1),INLIST(PoDataCab.TpoRf1,'N/C','N/D'),LEFT(PoDataCab.NroRf1,1),'X')
	LsSerie		=RIGHT(LsLetSer+LTRIM(SUBSTR(PoDataCab.NroRf1,2,3)),4)
	LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8)+'.txt'
	LsNroDoc    =LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),8)
	** Datos Adicionales **
	LsCodFac	=	ICASE(PoDataAdi.CodFac='FACT','01',PoDataAdi.CodFac='BOLE','03',PoDataAdi.CodFac='N/C','07',PoDataAdi.CodFac='N/D','08',PoDataAdi.CodFac='G/R','09',"")
	LsNroFac	=	PoDataAdi.NroFac
	LsDesDREL	=	ICASE(LsCodFac='01','FACTURA',LsCodFac='03','BOLETA',LsCodFac='09','GUIA REMISION REMITENTE','OTROS DOCUMENTOS')

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
	LsDesMot	= IIF(SEEK(PADR(GsMotivo,LEN(CBDMTABL.Tabla))+TRANSFORM(PoDataCab.Motivo,"@L ##"),"CBDMTABL","TABL01"),ALLTRIM(STUFF(CBDMTABL.Nombre,1,ATC("-",CBDMTABL.Nombre),"")),'Descripción motivo traslado') 
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

*!*		LsCadena = LsCadena +	ICASE(LEN(trim(PoDataCab.RucCli))=11,'6',LEN(TRIM(PoDataCab.RucCli))=8,'1','0')	+","
*!*		LsCadena = LsCadena +	ALLTRIM(PoDataCab.RucCli)											+","
*!*		LsCadena = LsCadena +	ALLTRIM(PoDataCab.NomCli)											+","
*!*		LsCadena = LsCadena +	ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','')			+","
*!*		LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpIgv,15,2))									+","	&& IGV
*!*		LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto,15,2))									+","	&& Ventas Gravadas
*!*		LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto+PoDataCab.ImpIgv,15,2)) 				+","    && IGV + Ventas Gravadas (TaxInclusiveAmount )
*!*		LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpDto,15,2))									+","	&& AllowanceTotalAmount/Total Descuentos
*!*		LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpAdm,15,2))									+","    && ChargeTotalAmount/Otros Cargos
*!*		LsCadena = LsCadena +	ALLTRIM(STR(LnTotAnt,15,2))											+","    && PrepaidAmount/Anticipos 
*!*		LsCadena = LsCadena +	ALLTRIM(STR(LfTotVta,15,2))											+","    && PayableAmount/Total Venta 
*!*		LsCadena = LsCadena +	ALLTRIM(LsVerUBL)													+","   	&& ublVersionId
*!*		LsCadena = LsCadena +	ALLTRIM(LsVerDOC)													+","   	&& customizationId
*!*		LsCadena = LsCadena +   TRANSFORM(PoDataCab.Motivo,'@L ##')									+","
*!*		LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpTot,15,2))									+","	&& Importe total
	
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