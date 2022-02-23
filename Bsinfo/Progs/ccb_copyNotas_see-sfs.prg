PARAMETERS PsTipo,PsNota,PsFact

IF PsNota='E'
	RETURN
ENDIF

SET PROCEDURE TO setup_file_date additive 
** Ejemplo
**  MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000058.NOT
**  do ccb_copynotas_see-sfs with  "07","F002-00000110","F001-00006199"
*!*	REPLACE GDOC.usercrea WITH VMOV.digita
*!*	REPLACE GDOc.fchcrea WITH CTOT(DTOC(vmov.Fchdig)+" "+vmov.horDig)

Ejm_Total	="F002-00000083"
Ejm_parcial="F002-00000082"
** Detalle
LEY="IMPTOT"
TRI="IMPBTO,IMPIGV"
COL10="COL02*COL06"
COL07="COL10*.18"
COL09="COL10*.18"
COL35="IMPBTO"


*!*	LsModNotCAB=[0101|FECHA|HORA|0000|6|RUC|RAZSOC|MONEDA|CAT0910|NOMBRECAT0910|01|NROREF|IMPBTO|IGV|IMPTOT|0.00|0.00|0.00|IMPTOT|2.1|2.0|]
LoBorraObj1 = .F.
IF VARTYPE(LoDatAdm)<>'O'
	LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
	LoBorraObj1 = .T.	
ENDIF
IF !USED("GDOC")
	LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
ENDIF
IF !USED("RDOC")
	LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
ENDIF
SELECT GDOC 
SET ORDER TO GDOC01
PRIVATE LsTpoDoc,LsCodDoc,LsFchDoc,LsHora,LsMoneda,LsRuc,LsNomCli,LsCatNOT,LsDesNOT,LsLetSer
PRIVATE LsSerie,LsNroRef,LsImpBto,LsImpIgv,LsImpTot

LsTpoDoc	=ICASE(PsTipo='07','ABONO',PsTipo='08','CARGO','') 
LsCodDoc	=ICASE(PsTipo='07','N/C ',PsTipo='08','N/D ','')
LsCodDoc	=PADR(LsCodDoc,LEN(GDOC.CODDOC))
IF EMPTY(LsCodDoc)
	MESSAGEBOX("No esta definido el tipo de documento, debe ser 07 para N/Crédito  ó 08 para N/Débito ",48,"Atención / Warning !!") 
	RETURN 
ENDIF
SELECT GDOC 
SEEK LsTpoDoc+LsCodDoc+LEFT(CHRTRAN(PsNota,"F",""),3)+RIGHT(Psnota,7) && PsNota
IF !FOUND()
	MESSAGEBOX("No se encuentra el documento en GDOC "+LsTpoDoc+" "+LsCodDoc+" "+PsNota,48,"Atención / Warning !!") 
	RETURN 
ENDIF
SELECT RDOC
SEEK GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
IF !FOUND()
	MESSAGEBOX("No se encuentra DETALLE en RDOC del documento "+LsTpoDoc+" "+LsCodDoc+" "+PsNota,48,"Atención / Warning !!") 
	RETURN 
ENDIF


LsFchDoc 	=	TRANSFORM(DTOS(GDOC.FchDoc), "@R ####-##-##")
LsHora 	 	=	TRANSFORM(HOUR(gdoc.fchcrea),"@L ##")+":"+TRANSFORM(minute(gdoc.fchcrea),"@L ##")+":"+TRANSFORM(sec(gdoc.fchcrea),"@L ##")
LsMoneda 	=	ICASE(GDOC.CodMon=1,"PEN",GDOC.CodMOn=2,"USD","")
LsRuc	 	=	ALLTRIM(GDOC.RucCli)
LsNomCli 	=	ALLTRIM(GDOC.NomCli)
LsCatNOT 	=	IIF(INLIST(RDOC.Codigo,'A','C'),SUBSTR(RDOC.Codigo,2,2),'03')
LsDesNOT 	=	IIF(INLIST(RDOC.Codigo,'A','C'),ALLTRIM(RDOC.Glosa),'Error en la descripción')
LsLetSer	=	LEFT(GDOC.CodRef,1)
LsSerie		=	RIGHT(LsLetSer+LTRIM(LEFT(GDOC.NroRef,3)),4)
LsNroRef	=	LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(GDOC.NroRef,4)),8)
LsImpBto	=	ALLTRIM(STR(GDOC.ImpBto,15,2))
LsImpIgv	=	ALLTRIM(STR(GDOC.ImpIgv,15,2))
LsImpTot	=	ALLTRIM(STR(GDOC.ImpBto+GDOC.ImpIgv,15,2)) 

LcSep='|'
LsModNotCAB=[0101|FECHA|HORA|0000|6|RUC|RAZSOC|MONEDA|CAT0910|NOMBRECAT0910|01|NROREF|IGV|IMPBTO|IMPTOT|0.00|0.00|0.00|IMPTOT|2.1|2.0|]
LsModNotCAB =STRTRAN(LsModNotCAB,"FECHA"		,LsFchDoc)
LsModNotCAB =STRTRAN(LsModNotCAB,"HORA" 		,LsHora)
LsModNotCAB =STRTRAN(LsModNotCAB,"RUC" 			,LsRuc)
LsModNotCAB =STRTRAN(LsModNotCAB,"RAZSOC"		,LsNomCli)
LsModNotCAB =STRTRAN(LsModNotCAB,"MONEDA"		,LsMoneda)
LsModNotCAB =STRTRAN(LsModNotCAB,"CAT0910"		,LsCatNOT,1,1)
LsModNotCAB =STRTRAN(LsModNotCAB,"NOMBRECAT0910",LsDesNOT)
LsModNotCAB =STRTRAN(LsModNotCAB,"NROREF"		,LsNroRef)
LsModNotCAB =STRTRAN(LsModNotCAB,"IGV"	 		,LsImpIgv)
LsModNotCAB =STRTRAN(LsModNotCAB,"IMPBTO"		,LsImpBto)
LsModNotCAB =STRTRAN(LsModNotCAB,"IMPTOT"		,LsImpTot)

** VETT:Modificando archivo .DET si nota es por monto distinto al importe total de documento de referencia 2021/11/05 10:21:15 ** 
** [MTR|100.0000|0204  E705||PERFIL ESPONJA NEGRA PUERTA BRUCE|4.237|76.27|1000|76.27|423.70|IGV|VAT|10|18.00|-|0.00|||||15.00|-|||||15.00|-||||||4.9997|423.70|0.0000|]
LsModNotDET=[MTR|CANT|CODMAT||DESMAT|PREUNI|IMPIGV|1000|IMPIGV|BASE|IGV|VAT|10|18.00|-|0.00|||||15.00|-|||||15.00|-||||||4.9997|BASE|0.0000|]
** Calculos
** BASE		= LsImpBto
** IMPIGV	= LsImpIgv 
** CANT		= BASE/PREUNI 
** Comparamos importe de la Nota vs el importe del documento de referencia
LsCadDet = []	&& Si esta cadena permanece vacia entonces se debe copiar el .DET del documento de referencia
LsCadTRI = []	&& Si esta cadena permanece vacia entonces se debe copiar el .TRI del documento de referencia	
LsCadLEY = []	&& Si esta cadena permanece vacia entonces se debe copiar el .LEY del documento de referencia

LsDirIntf = ADDBS(JUSTPATH(JUSTPATH(goentorno.tspathadm)))+'Interface'
LsDirIntf = IIF(":"$LsDirIntf,LsDirIntf,SYS(5)+LsDirIntf)
**LsRutaCia	=	ADDBS("O:\o-negocios\Interface\facturador\cia_001\")
LsRutaCia	=	ADDBS(LsDirIntf)+"facturador\cia_001\"
LsRucCia	=	GsRucCia
LsFileFrom	=	LsRutaCia +GsRucCia+"-01-"+PsFact
LsFileTO	=	LsRutaCia +GsRucCia+"-"+PsTipo+"-"+PsNota


*!*	SET STEP ON 
SELECT GDOC
LfImpBto = GDOC.ImpBto
LfImpTot = GDOC.ImpBto+GDOC.ImpIgv
LiRegAct = RECNO()
LsTpoRef = GDOC.TpoRef
LsCodRef = GDOC.CodRef
LsNroRef = GDOC.NroRef
LfImpRef = 0
LsImpLet = NUMERO(GDOC.ImpBto+GDOC.ImpIgv,2,1)
IF SEEK(LsTpoRef+LsCodRef+LsNroRef,'GDOC') 

	LfImpRef = GDOC.ImpTot
	IF LfImpTot<LfImpRef && AND GDOC.FlgEst = 'P' 
		** Caso 1
		** Calculamos la cantidad para llegar a la base imponible de la NOTA sin modificar el precio.
		** Siempre tomanos el primer registro del archivo .DET
		local array aRegistro[1]
		ALINES(aRegistro,FILETOSTR(lsFileFrom+".DET"))
		LsCadDet = aRegistro[1]
		LnPos1   = AT("|",LsCadDet,1)
		LnPos2   = AT("|",LsCadDet,2)
		LnPos3   = AT("|",LsCadDet,5)
		LnPos4   = AT("|",LsCadDet,6) 
		LfPreuni = VAL(SUBSTR(LsCadDet,LnPos3+1,LnPos4-(LnPos3+1)))
		XfCant 	 = LfImpBto/LfPreUni
		LsCant=LTRIM(STR(ROUND(XfCant,4),8,4))
		** Cambiamos la cantidad **
		LsCadDet = STUFF(LsCadDet, LnPos1+1, LnPos2-(LnPos1+1), LsCant)
		** IGV **  
		LnPos6   = AT("|",LsCadDet,6)
		LnPos7   = AT("|",LsCadDet,7) 
		LsCadDet = STUFF(LsCadDet, LnPos6+1, LnPos7-(LnPos6+1), LsImpIgv)
		LnPos8   = AT("|",LsCadDet,8)
		LnPos9   = AT("|",LsCadDet,9) 
		LsCadDet = STUFF(LsCadDet, LnPos8+1, LnPos9-(LnPos8+1), LsImpIgv)
		LnPos10  = AT("|",LsCadDet,9)
		LnPos11  = AT("|",LsCadDet,10)
		LsCadDet = STUFF(LsCadDet, LnPos10+1, LnPos11-(LnPos10+1), LsImpBto)
		LnPos12  = AT("|",LsCadDet,34)
		LnPos13  = AT("|",LsCadDet,35)
		LsCadDet = STUFF(LsCadDet, LnPos12+1, LnPos13-(LnPos12+1), LsImpBto)		
		** Actualizamos el archivo .TRI
		ALINES(aRegistro,FILETOSTR(lsFileFrom+".TRI"))
		LsCadTRI = aRegistro[1]
		LnPos1   = AT("|",LsCadTRI,3)
		LnPos2   = AT("|",LsCadTRI,4)
		LsCadTRI = STUFF(LsCadTRI, LnPos1+1, LnPos2-(LnPos1+1), LsImpBto)
		LnPos2   = AT("|",LsCadTRI,4)
		LnPos3   = AT("|",LsCadTRI,5)
		LsCadTRI = STUFF(LsCadTRI, LnPos2+1, LnPos3-(LnPos2+1), LsImpIgv)
		** Actualizamos el archivo .LEY
		ALINES(aRegistro,FILETOSTR(lsFileFrom+".LEY"))
		LsCadLEY = aRegistro[1]
		LnPos1   = AT("|",LsCadLEY,1)
		LnPos2   = AT("|",LsCadLEY,2)		
		LsCadLEY = STUFF(LsCadLEY, LnPos1+1, LnPos2-(LnPos1+1), LsImpLet)
	ENDIF
ENDIF
IF LiREgAct>0 
	GO LiRegAct IN GDOC
ENDIF



=STRTOFILE(LsModNotCAB,LsFileTo+".NOT",.F.)
IF EMPTY(LsCadDet) 
	COPY FILE LsFileFrom+".DET" 	TO LsFileTO+".DET"
	COPY FILE LsFileFrom+".TRI"	 	TO LsFileTO+".TRI"
	COPY FILE LsFileFrom+".LEY"  	TO LsFileTO+".LEY"
ELSE
	=STRTOFILE(LsCadDET,LsFileTo+".DET",.F.)
	=STRTOFILE(LsCadTRI,LsFileTo+".TRI",.F.)
	=STRTOFILE(LsCadLEY,LsFileTo+".LEY",.F.)
ENDIF
** VETT: 2021/11/05 10:21:15 ** 
COPY FILE LsFileFrom+".ACA"	    TO LsFileTO+".ACA"

do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".DET",DATETIME()
do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".TRI",DATETIME()
do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".LEY",DATETIME()
do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".ACA",DATETIME()



IF LoBorraObj1
	RELEASE LoDatAdm
ENDIF
*******************
FUNCTION Envia_Nota
*******************
PARAMETERS PcAliasCAB, PcAliasDET
IF HasAccess('EnvioSunat')
	IF INLIST(THISFORM.ObjRefTran.XsCodDoc,'FACT','BOLE','N/C','N/D')
		LsTpoDoc=IIF(INLIST(THISFORM.ObjRefTran.XsCodDoc,'FACT','BOLE','N/D'),'CARGO','ABONO')
	
		IF SEEK(LsTpoDoc+THISFORM.ObjRefTran.XsCodDoc+thisform.objreftran.XsNroDoc,'GDOC') AND !INLIST(GDOC.FlgEst,'A')

			SELECT  (thisform.cCursor_C)
			SCATTER NAME oData1
			*** Convertimos a objeto el cursor con el detalle del documento ***
			oData2 = thisform.odata.genobjdatos(thisform.ccursor_d)    
			Thisform.Objreftran.envio_see_sfs_v1

		ENDIF
	ENDIF
ELSE
	=MESSAGEBOX('No tiene permiso para realizar este procedimiento',48,'¡ ATENCION ! / ¡ WARNING !')	
ENDIF