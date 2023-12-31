PARAMETERS PoDataCab as Object ,PoDataDet as Object,PoDataAdi as Object, PsRuta as Character, PsVer as Character
IF VARTYPE(PsVer)<>'C'
*!*		PsVer = '1.2'
	** VETT:Actualización v1.3.2 2020/07/01 08:55:39 ** 
	PsVer = '1.3.2'
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
LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('000000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),9)+LsExtFile1	&&  '.CAB'

LlHayCuotas	= .F. 

*!*	DO Genera_Cadena_CAB WITH  PoDataCab,PsRuta
*!*	DO Genera_Cadena_DET WITH  PoDataDet,PsRuta,PoDataCab

DO CASE
	CASE INLIST(LsCodDoc,'01','03')
		DO Genera_Cadena_CSV_FB WITH  PoDataCab,PsRuta
	CASE INLIST(LsCodDoc,'07','08')
		DO Genera_Cadena_CSV_NOT WITH  PoDataCab,PsRuta
	CASE INLIST(LsCodDoc,'09')
		DO Genera_Cadena_CSV_GRE WITH  PoDataCab,PsRuta
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




PROCEDURE Genera_Cadena_CSV_GRE 
PARAMETERS PoDataCab,PsRuta

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
	LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('000000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),9)+'.txt'
	LsNroDoc    =LsSerie+'-'+RIGHT('000000000'+RTRIM(SUBSTR(PoDataCab.NroRf1,5)),9)
	** Datos Adicionales **
	LsCodFac	=	ICASE(PoDataAdi.CodFac='FACT','01',PoDataAdi.CodFac='BOLE','03',PoDataAdi.CodFac='N/C','07',PoDataAdi.CodFac='N/D','08',PoDataAdi.CodFac='G/R','09',"")
	LsNroFac	=	PoDataAdi.NroFac
	LsDesDREL	=	ICASE(LsCodFac='01','FACTURA',LsCodFac='03','BOLETA',LsCodFac='09','GUIA REMISION REMITENTE','OTROS DOCUMENTOS')

	LnControlArc = fcreate(Lsruta+LsNomArc)

	if LnControlArc<0
	   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Cabecera de venta')
	   RETURN .f.
	ENDIF
		
	DIMENSION aFila(30)
	STORE "" TO aFila
	
	LsVerDOC	= "2.0"
	LsVerUBL	= "2.1"
	LnTotAnt	= 0
	LfTotVta	= 0  && PoDataCab.ImpBto+PoDataCab.ImpIgv+PoDataCab.ImpAdm-PoDataCab.ImpDto-LnTotAnt
	LsFecha		= TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##")
	LsFchVto	= {} && IIF(!EMPTY(PoDataCab.FchVto),TRANSFORM(DTOS(PoDataCab.FchVto), "@R ####-##-##"),"-")
	LsDesMot	= 	'Venta' && Falta asociar descripcion segun tabla (catalogo nro. 20)
	LnCnGRef	= 0
	IF !EMPTY(LsCodFac) AND !EMPTY(LsNroFac)
		LnCnDRel = 1
	ELSE
		LnCnDRel = 0
	ENDIF
	LnCnCdRel	= 1  && Un conductor por defecto
	LnCnPlRel	= 1  && Una # Placa  por defecto 
	LnCnConPr	= 0  && Cantidad de contenedores y precintos por defecto 
	LsGRBaja	= ""
	LsTDBaja	= ""
	LsDRBaja	= ""
	
	LsDniCond	= "" 				&& Dni conductor (Chofer)
	LsTPDCond	= "" 				&& Tipo documento conductor
	LsNomCond	= "" 				&& Nombres conductor
	LsApeCond	= "" 				&& Apellidos conductor
	LsLicCond	= "" 				&& Licencia de conducir conductor
	LsPlaTra	= PoDataCab.PlaTra 	&& Numero Placa del vehiculo de transportista  
	LsTarUCir	= ""				&& Tarjeta Única de Circulación Electrónica o Certificado de Habilitación vehicular 
	LsNroAutv	= ""				&& Número de autorización especial - Vehículo
	LsCdEntEmiV	= "06" 				&& Código de la entidad emisora de la autorización especial - Vehículo - Catalogo D-37
	LsNContene	= ""				&& Número contenedor
	LsNPrecint	= ""				&& Número precinto
	LsUbiRemit  = PoDataCab.UbiPpart          && Codigo Ubigeo remitente (Empresa), obtenerlo de suscursales/establecimiento de la empresa (CIAXXX)  
	LsDirRemit  = GsDirCia			&& Dirección segun sucursal o establecimiento de la empresa
	LsUrbRemit  = ""				&& Urbanizacion remitente
	LsPrvRemit  = ""				&& Provincia remitente
	LsDepRemit	= ""				&& Departamento remitente
	LsDisRemit  = ""				&& Distrito remitente	
	LsCodPaisR 	= "PE"				&& Codigo Pais remitente
	LsAutRemit	= ""				&& Número de autorización especial - remitente
	LsCdEntEmiR = "06"
	LsCodEstR	= PoDatacab.CodEstPart
	LfPesoBruto	= 0
	LsNroRegMTC = ""				&& Numero de registro MTC transportista
	
	
	LsUbiDest	=	PoDataCab.UbiPlleg 				&& Codigo Ubigeo Destinatario (Cliente/Empresa) obtenerlo de sucursal/establecimiento cliente
	LsDirDest	=	PoDataAdi.DirEnt
	LsUrbDest	=	""
	LsPrvDest	=	""
	LsDepDest	=	""
	LsDisDest	=	""
	LsCdPaisD	=	"PE"
	LsEmailDest	=	PoDataAdi.EmailDest
	LsCodEstDes =	PoDataCab.CodEstLleg
	
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
	LsNroAutTra	=	""										&& Numero de Autorizacion especial transportista
	LsEntEmiTra	=	LsCdEntEmiR								&& 
	LsCodEstPart=	PoDatacab.CodEstPart
	LsLongPart  =   0
	LsLatiPart	=	0
	LsCodEstLleg=	PoDataCab.CodEstLleg
	LsLongPLleg =   0
	LsLatiPLleg	=	0
	
	
	DO CASE
		CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '01','03')
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
		CASE INLIST(TRANSFORM(PoDataCab.Motivo,'@L ##') , '04')
			IF LsModTra = '02'   && Modalidad de traslado Privado
				LsDniCond	= PoDataCab.DNICond 			&& Dni conductor (Chofer)
				LsTPDCond	= PoDataCab.TPDCond 			&& Tipo documento conductor
				LsNomCond	= PoDataCab.NomCond 			&& Nombres conductor
				LsApeCond	= PoDataCab.ApeCond 			&& Apellidos conductor
				LsLicCond	= PoDataCab.Brevet				&& Licencia de conducir conductor	
			ENDIF
					
		OTHERWISE 	
	ENDCASE
	 
	** Armamos la cadena **
	LsCadena = 				aFila(1)															&& es solo para guiar al que viene por 1era vez
	LsCadena = 				TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##") 					+","  && Fecha 
	LsCadena = LsCadena + 	LsNroDoc															+","  && NroDoc 
	LsCadena = LsCadena +	LsCodDoc															+","  && Codigo Documento Sunat 
	LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.NroItm,3))									+","  && Nro de items de G/R
	LsCadena = LsCadena +	IIF(!EMPTY(LnCnGRef),ALLTRIM(STR(LnCnGRef,3)),"" )					+","  && Cantidad G/Rs referencia
	LsCadena = LsCadena +	IIF(!EMPTY(LnCnDRel),ALLTRIM(STR(LnCnDRel,3)),"" )					+","  && Cantidad Docs relacionados
	LsCadena = LsCadena +	IIF(!EMPTY(LnCnCdRel),ALLTRIM(STR(LnCnCdRel,3)),"" )				+","  && Cantidad conductores relacionados
	LsCadena = LsCadena +	IIF(!EMPTY(LnCnConPr),ALLTRIM(STR(LnCnConPr,3)),"" )				+","  && Cantidad de contenedores y precintos por defecto 
	LsCadena = LsCadena +	SUBSTR(TTOC(PoDatacab.fchCrea,3),12)								+"," && Hora de emision de G/R
	LsCadena = LsCadena +   CRLF	&& CRLF = CHR(13)+CHR(10) esta definido en const.h 
	LsCadena = LsCadena +	aFila(2)
	LsCadena = LsCadena +	ALLTRIM(LsGRBaja)										+","
	LsCadena = LsCadena +	ALLTRIM(LsTDBaja)										+","
	LsCadena = LsCadena +	ALLTRIM(LsDRBaja)										+","		
	LsCadena = LsCadena +   CRLF		
	LsCadena = LsCadena +	aFila(3)	
	LsCadena = LsCadena +   ALLTRIM(IIF(EMPTY(LsNroFac),STUFF(LsNroFac, 5, 0, '-'),''))						+","
	LsCadena = LsCadena +   ALLTRIM(LsCodFac)										+","
	LsCadena = LsCadena +  	ALLTRIM(LsDesDREL)										+","
	LsCadena = LsCadena +	IIF(EMPTY(LsCodFac),"",ALLTRIM(GsRucCia))				+","
	LsCadena = LsCadena +	'ATTACH_DOC'											+","
	LsCadena = LsCadena +   CRLF	
	LsCadena = LsCadena +	aFila(4)		
	LsCadena = LsCadena +	ALLTRIM(LsDniCond)	+","
	LsCadena = LsCadena +	ALLTRIM(LsTPDCond)	+","
	LsCadena = LsCadena +	ALLTRIM(LsNomCond)	+","
	LsCadena = LsCadena +	ALLTRIM(LsApeCond)	+","
	LsCadena = LsCadena +	ALLTRIM(LsLicCond) 	+","
	LsCadena = LsCadena +	'ATTACH_DOC'											+","
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
			LsCadena = LsCadena + ALLTRIM(STR(LsLongPart,3,8))				+","
			LsCadena = LsCadena + ALLTRIM(STR(LsLatiPart,3,8))				+","	
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
			LsCadena = LsCadena + ALLTRIM(STR(LsLongPart,3,8))				+","
			LsCadena = LsCadena + ALLTRIM(STR(LsLatiPart,3,8))				+","	
			LsCadena = LsCadena + ALLTRIM(PoDataCab.RucCli)					+","
			LsCadena = LsCadena + ALLTRIM(LsCodEstDes)						+","
			LsCadena = LsCadena + ALLTRIM(STR(LsLongPLleg,3,8))				+","
			LsCadena = LsCadena + ALLTRIM(STR(LsLatiPLleg,3,8))				+","	
	ENDCASE
	LsCadena = LsCadena +   CRLF	
	LsCadena = LsCadena +	aFila(11)
	LsCadena = LsCadena +   ALLTRIM(PoDataCab.Observ)						+","
	LsCadena = LsCadena +   CRLF	
	LsCadena = LsCadena +	aFila(12)
	** VETT: Agregamos items del detalle de  G/R IDUPD:659158006-28/12/2023 08:50 PM 
	gocfgvta.odatadm.obj2cur(PoDataDet,'cDVta')
	SELECT cDVta
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
	
RETURN
***************************
PROCEDURE Genera_Cadena_CAB
*************************** 
PARAMETERS PoDataCab,PsRuta

	Lsruta   = ADDBS(TRIM(PsRuta)) && curdir()+lruta   
	IF !DIRECTORY(Lsruta)
		MKDIR (Lsruta)
	ENDIF	
	
	LsCodDoc	=ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08')
	LsLetSer	=ICASE(INLIST(PoDataCab.CodDoc,'FACT','BOLE'),LEFT(PoDataCab.CodDoc,1),INLIST(PoDataCab.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodRef,1),'X')
	LsSerie		=RIGHT(LsLetSer+LTRIM(LEFT(PoDataCab.NroDoc,3)),4)
	LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,4)),8)+'.CAB'
	IF FILE(Lsruta+LsNomArc)
		DELETE FILE (Lsruta+LsNomArc)
	ENDIF

	LnControlArc = fcreate(Lsruta+LsNomArc)

	if LnControlArc<0
	   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Cabecera de venta')
	   RETURN .f.
	endif
	DO CASE 
		CASE PsVer='1.2'
			LsVerDOC = "2.0"
			LsVerUBL = "2.1"
			LnTotAnt = 0
			LfTotVta = PoDataCab.ImpBto+PoDataCab.ImpIgv+PoDataCab.ImpAdm-PoDataCab.ImpDto-LnTotAnt
			LsFecha	 = TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##")
			LsFchVto = IIF(!EMPTY(PoDataCab.FchVto),TRANSFORM(DTOS(PoDataCab.FchVto), "@R ####-##-##"),"-")
			LsCadena =				ALLTRIM('01'+TRANSFORM(PoDataCab.TpoVta,'@L ##'))					+"|"
			LsCadena = LsCadena +	TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##") 					+"|"
			LsCadena = LsCadena + 	SUBSTR(TTOC(gdoc.fchmodi,3),12)										+"|"
			LsCadena = LsCadena +	LsFchVto															+"|"  && fecVencimiento / "-" si es vacio
			LsCadena = LsCadena +	'001'																+"|" && '001' GsCodSed 
			LsCadena = LsCadena +	ICASE(LEN(trim(PoDataCab.RucCli))=11,'6',LEN(TRIM(PoDataCab.RucCli))=8,'1','0')	+"|"
			LsCadena = LsCadena +	ALLTRIM(PoDataCab.RucCli)											+"|"
			LsCadena = LsCadena +	ALLTRIM(PoDataCab.NomCli)											+"|"
			LsCadena = LsCadena +	ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','')			+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpIgv,15,2))									+"|"	&& IGV
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto,15,2))									+"|"	&& Ventas Gravadas
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto+PoDataCab.ImpIgv,15,2)) 				+"|"    && IGV + Ventas Gravadas (TaxInclusiveAmount )
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpDto,15,2))									+"|"	&& AllowanceTotalAmount/Total Descuentos
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpAdm,15,2))									+"|"    && ChargeTotalAmount/Otros Cargos
			LsCadena = LsCadena +	ALLTRIM(STR(LnTotAnt,15,2))											+"|"    && PrepaidAmount/Anticipos 
			LsCadena = LsCadena +	ALLTRIM(STR(LfTotVta,15,2))											+"|"    && PayableAmount/Total Venta 
			LsCadena = LsCadena +	ALLTRIM(LsVerUBL)													+"|"   	&& ublVersionId
			LsCadena = LsCadena +	ALLTRIM(LsVerDOC)													+"|"   	&& customizationId
			**LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpTot,15,2))									+"|"	&& Importe total
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)


			LsNomArc=JUSTSTEM(LsNomArc)+".ACA"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,': Adicionales de cabecera')
			   RETURN .f.
			ENDIF
			
			LsCadena = "|"														+"|"	
			LsCadena = LsCadena +												+"|"	
			LsCadena = LsCadena +												+"|"	
			LsCadena = LsCadena +												+"|"	
			LsCadena = LsCadena + 'PE'											+"|"
			LsCadena = LsCadena + '000000'										+"|"		
			LsCadena = LsCadena + ALLTRIM(PoDataCab.DirCli)						+"|"		
			LsCadena = LsCadena +   '-'											+"|"
			LsCadena = LsCadena +   '-'											+"|"
			LsCadena = LsCadena +   '-'											+"|"
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)		
				
			LsNomArc=JUSTSTEM(LsNomArc)+".LEY"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,' Leyendas')
			   RETURN .f.
			endif
			LsCadena = '1000'												+"|"	
			LsCadena = LsCadena +NUMERO(LfTotVta,2,1)						+"|"
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)		
			
			LsNomArc=JUSTSTEM(LsNomArc)+".TRI"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Tributos Generales')
			   RETURN .f.
			endif
			LsCadena = '1000'												+"|"	
			LsCadena = LsCadena + 'IGV'										+"|"
			LsCadena = LsCadena + 'VAT'										+"|"
			LsCadena = LsCadena +ALLTRIM(STR(PoDataCab.ImpBto,15,2))		+"|"
			LsCadena = LsCadena +ALLTRIM(STR(PoDataCab.ImpIgv,15,2))		+"|"
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)			
			** VETT:Actualización SFS v1.3.2 2020/07/01 08:54:04 ** 
		CASE PsVer='1.3.2'
		
			LsVerDOC = "2.0"
			LsVerUBL = "2.1"
			LnTotAnt = 0
			LfTotVta = PoDataCab.ImpBto+PoDataCab.ImpIgv+PoDataCab.ImpAdm-PoDataCab.ImpDto-LnTotAnt
			LsFecha	 = TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##")
			LsFchVto = IIF(!EMPTY(PoDataCab.FchVto),TRANSFORM(DTOS(PoDataCab.FchVto), "@R ####-##-##"),"-")
			LsCadena =				ALLTRIM('01'+TRANSFORM(PoDataCab.TpoVta,'@L ##'))					+"|"
			LsCadena = LsCadena +	TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##") 					+"|"
			LsCadena = LsCadena + 	SUBSTR(TTOC(gdoc.fchmodi,3),12)										+"|"
			LsCadena = LsCadena +	LsFchVto															+"|"  && fecVencimiento / "-" si es vacio
			LsCadena = LsCadena +	'001'																+"|" && '001' GsCodSed 
			LsCadena = LsCadena +	ICASE(LEN(trim(PoDataCab.RucCli))=11,'6',LEN(TRIM(PoDataCab.RucCli))=8,'1','0')	+"|"
			LsCadena = LsCadena +	ALLTRIM(PoDataCab.RucCli)											+"|"
			LsCadena = LsCadena +	ALLTRIM(PoDataCab.NomCli)											+"|"
			LsCadena = LsCadena +	ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','')			+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpIgv,15,2))									+"|"	&& IGV
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto,15,2))									+"|"	&& Ventas Gravadas
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto+PoDataCab.ImpIgv,15,2)) 				+"|"    && IGV + Ventas Gravadas (TaxInclusiveAmount )
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpDto,15,2))									+"|"	&& AllowanceTotalAmount/Total Descuentos
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpAdm,15,2))									+"|"    && ChargeTotalAmount/Otros Cargos
			LsCadena = LsCadena +	ALLTRIM(STR(LnTotAnt,15,2))											+"|"    && PrepaidAmount/Anticipos 
			LsCadena = LsCadena +	ALLTRIM(STR(LfTotVta,15,2))											+"|"    && PayableAmount/Total Venta 
			LsCadena = LsCadena +	ALLTRIM(LsVerUBL)													+"|"   	&& ublVersionId
			LsCadena = LsCadena +	ALLTRIM(LsVerDOC)													+"|"   	&& customizationId
			**LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpTot,15,2))									+"|"	&& Importe total
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)


			LsNomArc=JUSTSTEM(LsNomArc)+".ACA"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,': Adicionales de cabecera')
			   RETURN .f.
			ENDIF
			
			LsCadena = "|"														+"|"	
			LsCadena = LsCadena +												+"|"	
			LsCadena = LsCadena +												+"|"	
			LsCadena = LsCadena +												+"|"	
			LsCadena = LsCadena + 'PE'											+"|"
			LsCadena = LsCadena + '000000'										+"|"		
			LsCadena = LsCadena + ALLTRIM(PoDataCab.DirCli)						+"|"		
			LsCadena = LsCadena +   '-'											+"|"
			LsCadena = LsCadena +   '-'											+"|"
			LsCadena = LsCadena +   '-'											+"|"
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)		
				
			LsNomArc=JUSTSTEM(LsNomArc)+".LEY"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,' Leyendas')
			   RETURN .f.
			endif
			LsCadena = '1000'												+"|"	
			LsCadena = LsCadena +NUMERO(LfTotVta,2,1)						+"|"
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)		
			
			LsNomArc=JUSTSTEM(LsNomArc)+".TRI"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Tributos Generales')
			   RETURN .f.
			endif
			LsCadena = '1000'												+"|"	
			LsCadena = LsCadena + 'IGV'										+"|"
			LsCadena = LsCadena + 'VAT'										+"|"
			LsCadena = LsCadena +ALLTRIM(STR(PoDataCab.ImpBto,15,2))		+"|"
			LsCadena = LsCadena +ALLTRIM(STR(PoDataCab.ImpIgv,15,2))		+"|"
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)			

			LsNomArc=JUSTSTEM(LsNomArc)+".PAG"
			IF FILE(Lsruta+LsNomArc)
				DELETE FILE (Lsruta+LsNomArc)
			ENDIF

			LnControlArc = fcreate(Lsruta+LsNomArc)

			if LnControlArc<0
			   =messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Tributos Generales')
			   RETURN .f.
			endif
			LsCndPgo=PoDataCab.CndPgo
			LnDiaVto=PoDataCab.Diavto
			LsFchVto=IIF(!EMPTY(PoDataCab.FchVto),TRANSFORM(DTOS(PoDataCab.FchVto), "@R ####-##-##"),"-")			
			LsFmaPgo=ICASE(LsCndPgo="C/E","Contado",LnDiavto>0 and !empty(LsCndPgo),"Credito")
			LsMoneda=ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','')	
			
			LsCadena = LsFmaPgo												+"|"	
			LsCadena = LsCadena + ALLTRIM(STR(LfTotVta,15,2))				+"|"
			LsCadena = LsCadena + LsMoneda									+"|"
			
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)			

			IF LsFmaPgo="Credito"
				LsNomArc=JUSTSTEM(LsNomArc)+".DPA"
				IF FILE(Lsruta+LsNomArc)
					DELETE FILE (Lsruta+LsNomArc)
				ENDIF

				LnControlArc = fcreate(Lsruta+LsNomArc)

				if LnControlArc<0
					=messagebox("Error en la creación de "+Lsruta+LsNomArc,48,'Tributos Generales')
					RETURN .f.
				endif

				*Verificamos si hay sistema de cuotas*
				
				IF verifyvar('VTARCUOT','TABLE','INDBC','P'+GsCodCia+STR(_ANO,4,0))
					IF !USED("RCUO")
						goentorno.open_dbf1('ABRIR','VTARCUOT','RCUO','FACT','')
					ENDIF
					LlHayCuotas	= .T. 
					SELECT RCUO
					=SEEK(PoDataCab.TpoDoc+PoDataCab.CodDoc+PoDataCab.NroDoc,'RCUO','FACT')
					SCAN WHILE TpoRef+CodRef+NroRef=PoDataCab.TpoDoc+PoDataCab.CodDoc+PoDataCab.NroDoc 
						LsFchVto=TRANSFORM(DTOS(FchCob), "@R ####-##-##")

						LsCadena = ALLTRIM(STR(Import,15,2))							+"|"	
						LsCadena = LsCadena + LsFchVto									+"|"
						LsCadena = LsCadena + LsMoneda									+"|"

						=fput(LnControlArc,LsCadena) 
					ENDSCAN
				ELSE
					LsCadena = ALLTRIM(STR(LfTotVta,15,2))							+"|"	
					LsCadena = LsCadena + LsFchVto									+"|"
					LsCadena = LsCadena + LsMoneda									+"|"
					=fput(LnControlArc,LsCadena) 
				ENDIF
				=fclose(LnControlArc)			
			ENDIF
	OTHERWISE
			LsFecha		= TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##")
			LsCadena =				ALLTRIM(TRANSFORM(PoDataCab.TpoVta,'@L 99'))						+"|"
			LsCadena = LsCadena +	TRANSFORM(DTOS(PoDataCab.FchDoc), "@R ####-##-##") 					+"|"
			LsCadena = LsCadena +	'001'																+"|" && '001' GsCodSed 
			LsCadena = LsCadena +	ICASE(LEN(trim(PoDataCab.RucCli))=11,'6',LEN(TRIM(PoDataCab.RucCli))=8,'1','0')	+"|"
			LsCadena = LsCadena +	ALLTRIM(PoDataCab.RucCli)											+"|"
			LsCadena = LsCadena +	ALLTRIM(PoDataCab.NomCli)											+"|"
			LsCadena = LsCadena +	ICASE(PoDataCab.CodMon=1,'PEN',PoDataCab.CodMon=2,'USD','')			+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpDto,15,2))									+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpAdm,15,2))									+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(0,15,2))												+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpBto,15,2))									+"|"	&& Ventas Gravadas
			LsCadena = LsCadena +	ALLTRIM(STR(0,15,2))												+"|"    && Ventas Inafectas
			LsCadena = LsCadena +	ALLTRIM(STR(0,15,2))												+"|"	&& Ventas Exoneradas
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpIgv,15,2))									+"|"	&& IGV
			LsCadena = LsCadena +	ALLTRIM(STR(0.0,15,2))												+"|"   	&& ISC
			LsCadena = LsCadena +	ALLTRIM(STR(0.0,15,2))												+"|"   	&& Otros tributos
			LsCadena = LsCadena +	ALLTRIM(STR(PoDataCab.ImpTot,15,2))									+"|"	&& Importe total
			=fput(LnControlArc,LsCadena)    
			=fclose(LnControlArc)

	ENDCASE
RETURN




PROCEDURE Genera_Cadena_DET
PARAMETERS PoDataDet,PsRuta,PoDataCab

	LOCAL LoDatAdm as dataadmin OF SYS(5)+'\aplvfp\classgen\vcxs\dosvr.vcx' 
	LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
	
	LoDatAdm.Obj2Cur(PoDataDet,'cDVta')

	SELECT CDVTA
	LOCATE
	LsCodDoc	=ICASE(CDVTA.CodDoc='FACT','01',CDVTA.CodDoc='BOLE','03',CDVTA.CodDoc='N/C','07',CDVTA.CodDoc='N/D','08')

	LsLetSer	=ICASE(INLIST(CDVTA.CodDoc,'FACT','BOLE'),LEFT(CDVTA.CodDoc,1),INLIST(CDVTA.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodRef,1),'X')
	LsSerie		=RIGHT(LsLetSer+LTRIM(LEFT(CDVTA.NroDoc,3)),4)
*!*		LsSerie		=RIGHT('0'+LTRIM(LEFT(CDVTA.NroDoc,3)),4)
	LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(CDVTA.NroDoc,4)),8)+'.DET'


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
	LfPorIgv=GoCfgVta.XfPorigv
	LfPorIsc=GoCfgVta.XfPorISC
	SELECT cDVta
	SCAN 
		DO CASE 
		CASE PsVer='1.2'
			LfPreuni = IIF(cDVta.CodDoc='FACT',cDVta.PreUni,ROUND(cDVta.PreUni/(1+LfPorIgv/100),3))
			LfBaseIgv = IIF(cDVta.CodDoc='FACT',cDVta.ImpLin,ROUND(cDVta.implin/(1+LfPorIgv/100),2))
			LfIgvItem = ROUND(LfBaseIgv *LfPorIgv/100 ,2)
			LfImpISC  = 0.00	
			LfPreIGV = ROUND(LfPreUni *( 1+LfPorIgv/100),4)
			LfPreRef = 0.00
			LsCadena =				ALLTRIM(ICASE(cDVta.UndVta='KG','KGM',cDVta.UndVta='MTS','MTR',cDVta.UndVta='ROL','RO','NIU'))	+"|" && KG=KGM,MTS=MTR,ROL=RO,OTROS=NIU
			LsCadena = LsCadena +	ALLTRIM(STR(cDVta.CanFac,15,4))									+"|"
			LsCadena = LsCadena +	ALLTRIM(cDVta.CodMat)											+"|"
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +	ALLTRIM(cDVta.DesMat)											+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(LfPreUni,15,3))										+"|"	
			LsCadena = LsCadena +	ALLTRIM(STR(LfIgvItem,15,2))									+"|"	
			LsCadena = LsCadena +	'1000'															+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(LfIgvItem,15,2))									+"|"	
			LsCadena = LsCadena +	ALLTRIM(STR(LfBaseIgv,15,2))									+"|"	
			LsCadena = LsCadena +	'IGV'															+"|"
			LsCadena = LsCadena +	'VAT'															+"|"
			LsCadena = LsCadena +	'10'															+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(LfPorIgv,15,2))										+"|"
			LsCadena = LsCadena +   '-'																+"|" && Bloque para ISC - SIN ISC por defecto -
			LsCadena = LsCadena +   ALLTRIM(STR(LfImpISC,15,2))										+"|"
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +   '-'																+"|" && Bloque para Otros tirbutos - SIN otros por defecto -
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +																	+"|"	
			LsCadena = LsCadena +   ALLTRIM(STR(LfPreIGV,15,4))										+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(LfBaseIgv,15,2))									+"|"
			LsCadena = LsCadena +   ALLTRIM(STR(LfPreRef,15,4))										+"|"	
			
*!*				LsCadena = LsCadena +	ALLTRIM(STR(IIF(cDVta.CodDoc='FACT',cDVta.ImpLin*(1+LfPorIgv/100),cDVta.ImpLin ),15,2))		+"|"					
*!*				LsCadena = LsCadena +	ALLTRIM(STR(cDVta.D1+cDVta.D2+cDVta.D3,15,2))					+"|"
		CASE PsVer='1.3.2'
			LfPreuni = IIF(cDVta.CodDoc='FACT',cDVta.PreUni,ROUND(cDVta.PreUni/(1+LfPorIgv/100),3))
			LfBaseIgv = IIF(cDVta.CodDoc='FACT',cDVta.ImpLin,ROUND(cDVta.implin/(1+LfPorIgv/100),2))
			LfIgvItem = ROUND(LfBaseIgv *LfPorIgv/100 ,2)
			LfImpISC  = 0.00	
			LfPreIGV = ROUND(LfPreUni *( 1+LfPorIgv/100),4)
			LfPreRef = 0.00
			** VETT:Actualización SFS v1.3.2 2020/07/01 11:03:23 ** 
			LsUndVta =  ALLTRIM(ICASE(cDVta.UndVta='KG','KGM',cDVta.UndVta='MTS','MTR',cDVta.UndVta='ROL','RO','NIU'))  && KG=KGM,MTS=MTR,ROL=RO,OTROS=NIU
			LsCadena = LsUndVta																	+"|"  && 1
			LsCadena = LsCadena +	ALLTRIM(STR(cDVta.CanFac,15,4))								+"|"  && 2
			LsCadena = LsCadena +	ALLTRIM(cDVta.CodMat)											+"|"  && 3
			LsCadena = LsCadena +																	+"|"	 && 4
			LsCadena = LsCadena +	ALLTRIM(cDVta.DesMat)											+"|"  && 5
			LsCadena = LsCadena +	ALLTRIM(STR(LfPreUni,15,3))										+"|"	 && 6
			LsCadena = LsCadena +	ALLTRIM(STR(LfIgvItem,15,2))								      	        +"|"	 && 7
			LsCadena = LsCadena +	'1000'															+"|"  && 8
			LsCadena = LsCadena +	ALLTRIM(STR(LfIgvItem,15,2))									        +"|"	 && 9
			LsCadena = LsCadena +	ALLTRIM(STR(LfBaseIgv,15,2))									+"|"	 && 10
			LsCadena = LsCadena +	'IGV'															+"|"  && 11
			LsCadena = LsCadena +	'VAT'															+"|"  && 12
			LsCadena = LsCadena +	'10'															        +"|"  && 13
			LsCadena = LsCadena +	ALLTRIM(STR(LfPorIgv,15,2))										+"|"  && 14
			LsCadena = LsCadena +   '-'																+"|"  && 15    && Bloque para ISC - SIN ISC por defecto -
			LsCadena = LsCadena +   ALLTRIM(STR(LfImpISC,15,2))										+"|"  && 16
			LsCadena = LsCadena +																	+"|"	 && 17
			LsCadena = LsCadena +																	+"|"	 && 18
			LsCadena = LsCadena +																	+"|"	 && 19
			LsCadena = LsCadena +																	+"|"	 && 20
			LsCadena = LsCadena +	ALLTRIM(STR(LfPorISC,15,2))										+"|"	 && 21
			LsCadena = LsCadena +   '-'																+"|"   && 22  && Bloque para Otros tirbutos - SIN otros por defecto -
			LsCadena = LsCadena +																	+"|"	 && 23
			LsCadena = LsCadena +																	+"|"	 && 24
			LsCadena = LsCadena +																	+"|"	 && 25
			LsCadena = LsCadena +																	+"|"	 && 26
			LsCadena = LsCadena +	ALLTRIM(STR(LfPorISC,15,2))										+"|"	 && 27
			LsCadena = LsCadena +	'-'																+"|"	 && 28
			LsCadena = LsCadena +																	+"|"	 && 29
			LsCadena = LsCadena +																	+"|"	 && 30
			LsCadena = LsCadena +																	+"|"	 && 31
			LsCadena = LsCadena +																	+"|"	 && 32
			LsCadena = LsCadena +																	+"|"	 && 33	
			LsCadena = LsCadena +   ALLTRIM(STR(LfPreIGV,15,4))										+"|"	 && 34  
			LsCadena = LsCadena +	ALLTRIM(STR(LfBaseIgv,15,2))									+"|"	 && 35
			LsCadena = LsCadena +   ALLTRIM(STR(LfPreRef,15,4))										+"|"	 && 36	

		OTHERWISE 
	
			LsCadena =				ALLTRIM(ICASE(cDVta.UndVta='KG','KGM',cDVta.UndVta='MTS','MTR',cDVta.UndVta='ROL','RO','NIU'))	+"|" && KG=KGM,MTS=MTR,ROL=RO,OTROS=NIU
			LsCadena = LsCadena +	ALLTRIM(STR(cDVta.CanFac,15,4))									+"|"
			LsCadena = LsCadena +	ALLTRIM(cDVta.CodMat)											+"|"
			LsCadena = LsCadena +																		+"|"	
			LsCadena = LsCadena +	ALLTRIM(cDVta.DesMat)											+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(IIF(cDVta.CodDoc='FACT',cDVta.PreUni,ROUND(cDVta.PreUni/(1+LfPorIgv/100),3)),15,3))	+"|"	
			LsCadena = LsCadena +	ALLTRIM(STR(cDVta.D1+cDVta.D2+cDVta.D3,15,2))			+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(IIF(cDVta.CodDoc='FACT',ROUND(cDVta.ImpLin*LfPorIgv/100,2),ROUND(cDVta.implin*LfPorIgv/(100+LfPorIgv),2))  ,15,2))	+"|"	
			LsCadena = LsCadena +	'10'																+"|"
			LsCadena = LsCadena +	ALLTRIM(STR(0,15,2))												+"|"	
			LsCadena = LsCadena +	'01'																+"|"				
			LsCadena = LsCadena +	ALLTRIM(STR(IIF(cDVta.CodDoc='FACT',cDVta.ImpLin,ROUND(cDVta.implin/(1+LfPorIgv/100),2)),15,2))		+"|"	
			LsCadena = LsCadena +	ALLTRIM(STR(IIF(cDVta.CodDoc='FACT',cDVta.ImpLin*(1+LfPorIgv/100),cDVta.ImpLin ),15,2))		+"|"					
		ENDCASE
		=fput(LnControlArc,LsCadena)  
		  
	ENDSCAN
	
	
	
	
	=fclose(LnControlArc)
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

