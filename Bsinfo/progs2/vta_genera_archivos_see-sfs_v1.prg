PARAMETERS PoDataCab as Object ,PoDataDet as Object,PoDataAdi as Object, PsRuta as Character, PsVer as Character
IF VARTYPE(PsVer)<>'C'
*!*		PsVer = '1.2'
	** VETT:Actualización v1.3.2 2020/07/01 08:55:39 ** 
	PsVer = '1.3.2'
ENDIF
#include const.h 
Lsruta   = ADDBS(TRIM(PsRuta))
LsCodDoc	=ICASE(PoDataCab.CodDoc='FACT','01',PoDataCab.CodDoc='BOLE','03',PoDataCab.CodDoc='N/C','07',PoDataCab.CodDoc='N/D','08')
LsLetSer	=ICASE(INLIST(PoDataCab.CodDoc,'FACT','BOLE'),LEFT(PoDataCab.CodDoc,1),INLIST(PoDataCab.CodDoc,'N/C','N/D'),LEFT(PoDataCab.CodRef,1),'X')
LsSerie		=RIGHT(LsLetSer+LTRIM(LEFT(PoDataCab.NroDoc,3)),4)
LsExtFile	=ICASE(INLIST(LsCodDoc,'01','03'),".CAB",INLIST(LsCodDoc,'07','08'),".NOT") 

LsNomArc	=GsRucCia+'-'+LsCodDoc+'-'+LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(PoDataCab.NroDoc,4)),8)+LsExtFile	&&  '.CAB'

LlHayCuotas	= .F. 

DO Genera_Cadena_CAB WITH  PoDataCab,PsRuta
DO Genera_Cadena_DET WITH  PoDataDet,PsRuta,PoDataCab

DO CASE
	CASE INLIST(LsCodDoc,'01','03')
	CASE INLIST(LsCodDoc,'07','08')
ENDCASE

LsMensaje=""
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.CAB' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.CAB'),' [OK]',' [ERROR]') + CRLF  
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.DET' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.DET'),' [OK]',' [ERROR]') + CRLF  
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.ACA' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.ACA'),' [OK]',' [ERROR]') + CRLF  
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.LEY' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.LEY'),' [OK]',' [ERROR]') + CRLF  
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.TRI' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.TRI'),' [OK]',' [ERROR]') + CRLF  
LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.PAG' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.PAG'),' [OK]',' [ERROR]') + CRLF 
IF LlHayCuotas	 
	LsMensaje = LsMensaje + JUSTSTEM(LsNomArc)+'.DPA' + IIF(FILE(Lsruta+JUSTSTEM(LsNomArc)+'.DPA'),' [OK]',' [ERROR]') + CRLF 
ENDIF

IF "ERROR"$LsMensaje
	LsMensaje = LsMensaje +  'Generación de archivos presenta algunos problemas, revisar en la ruta:'+CRLF
	LsMensaje = LsMensaje +  LsRuta
	=MESSAGEBOX(LsMensaje,16,'Envio de archivos a SFS - SUNAT')
ELSE	
	LsMensaje = LsMensaje +  'Generación de archivos terminada sin problemas, revisar en la ruta:'+CRLF
	LsMensaje = LsMensaje +  LsRuta
	=MESSAGEBOX(LsMensaje,64,'Envio de archivos a SFS - SUNAT')
ENDIF

	 	
RETURN
PROCEDURE Genera_Cadena_CAB 
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

