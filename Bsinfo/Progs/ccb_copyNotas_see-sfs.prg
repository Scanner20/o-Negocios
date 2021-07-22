PARAMETERS PsTipo,PsNota,PsFact

SET PROCEDURE TO setup_file_date additve 
** Ejemplo
**  MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000058.NOT
**  do ccb_copynotas_see-sfs with  "07","F002-00000059","F001-00004537"
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

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LsTpoDoc = 'ABONO'
LsCodDoc=ICASE(PsTipo='07','N/C ','08','N/D ','')
LsCodDoc=PADR(LsCodDoc,LEN(GDOC.CODDOC))
IF EMPTY(LsCodDoc)
	MESSAGEBOX("No esta definido el tipo de documento, debe ser 07 para N/Crédito  ó 08 para N/Débito ",48,"Atención / Warning !!") 
	RETURN 
ENDIF
SELECT GDOC 
SEEK LsTpoDoc+LsCodDoc+LEFT(CHRTRAN(PsNota,"F",""),3)+RIGHT(Psnota,7) && PsNota
IF !FOUND()
	MESSAGEBOX("No se encuentra el documento "+LsTpoDoc+" "+LsCodDoc+" "+PsNota,48,"Atención / Warning !!") 
	RETURN 
ENDIF
LsFchDoc 	=	TRANSFORM(DTOS(GDOC.FchDoc), "@R ####-##-##")
LsHora 	 	=	TRANSFORM(HOUR(gdoc.fchcrea),"@L ##")+":"+TRANSFORM(minute(gdoc.fchcrea),"@L ##")+":"+TRANSFORM(sec(gdoc.fchcrea),"@L ##")
LsMoneda 	=	ICASE(GDOC.CodMon=1,"PEN",GDOC.CodMOn=2,"USD","")
LsRuc	 	=	ALLTRIM(GDOC.RucCli)
LsNomCli 	=	ALLTRIM(GDOC.NomCli)
LsCatNOT 	=	IIF(RDOC.Codigo='A',SUBSTR(RDOC.Codigo,2,2),'03')
LsDesNOT 	=	IIF(RDOC.Codigo='A',ALLTRIM(RDOC.Glosa),'Error en la descripción')
LsLetSer	=	LEFT(GDOC.CodRef,1)
LsSerie		=	RIGHT(LsLetSer+LTRIM(LEFT(GDOC.NroRef,3)),4)
LsNroRef	=	LsSerie+'-'+RIGHT('00000000'+RTRIM(SUBSTR(GDOC.NroRef,4)),8)
LsImpBto	=	ALLTRIM(STR(GDOC.ImpBto,15,2))
LsImpIgv	=	ALLTRIM(STR(GDOC.ImpIgv,15,2))
LsImpTot	=	ALLTRIM(STR(GDOC.ImpBto+GDOC.ImpIgv,15,2)) 

LcSep='|'
LsModNotCAB=[0101|FECHA|HORA|0000|6|RUC|RAZSOC|MONEDA|CAT0910|NOMBRECAT0910|01|NROREF|IMPBTO|IGV|IMPTOT|0.00|0.00|0.00|IMPTOT|2.1|2.0|]
LsModNotCAB =STRTRAN(LsModNotCAB,"FECHA"		,LsFchDoc)
LsModNotCAB =STRTRAN(LsModNotCAB,"HORA" 		,LsHora)
LsModNotCAB =STRTRAN(LsModNotCAB,"RUC" 			,LsRuc)
LsModNotCAB =STRTRAN(LsModNotCAB,"RAZSOC"		,LsNomCli)
LsModNotCAB =STRTRAN(LsModNotCAB,"MONEDA"		,LsMoneda)
LsModNotCAB =STRTRAN(LsModNotCAB,"CAT0910"		,LsCatNOT,1,1)
LsModNotCAB =STRTRAN(LsModNotCAB,"NOMBRECAT0910",LsDesNOT)
LsModNotCAB =STRTRAN(LsModNotCAB,"NROREF"		,LsNroRef)
LsModNotCAB =STRTRAN(LsModNotCAB,"IMPBTO"		,LsImpBto)
LsModNotCAB =STRTRAN(LsModNotCAB,"IGV"	 		,LsImpIgv)
LsModNotCAB =STRTRAN(LsModNotCAB,"IMPTOT"		,LsImpTot)

LsRutaCia =ADDBS("O:\o-negocios\Interface\facturador\cia_001\")
LsRucCia  = GsRucCia
LsFileFrom=LsRutaCia +GsRucCia+"-01-"+PsFact
LsFileTO	    =LsRutaCia +GsRucCia+"-"+PsTipo+"-"+PsNota

=STRTOFILE(LsModNotCAB,LsFileTo+".NOT",.F.)
 
COPY FILE LsFileFrom+".DET" 	TO LsFileTO+".DET"
COPY FILE LsFileFrom+".TRI"	 	TO LsFileTO+".TRI"
COPY FILE LsFileFrom+".LEY"  	TO LsFileTO+".LEY"
COPY FILE LsFileFrom+".ACA"	    TO LsFileTO+".ACA"

do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".DET",DATETIME()
do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".TRI",DATETIME()
do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".LEY",DATETIME()
do k:\aplvfp\bsinfo\progs\setup_file_date.prg WITH LsFileTO+".ACA",DATETIME()

*******************
FUNCTION Envia_Nota
*******************
PARAMETERS PcAliasCAB, PcAliasDET
IF HasAccess('EnvioSunat')
	IF INLIST(THISFORM.ObjRefTran.XsCodDoc,'FACT','BOLE','N/C','N/D')
		LsTpoDoc=IFF(INLIST(THISFORM.ObjRefTran.XsCodDoc,'FACT','BOLE','N/D'),'CARGO','ABONO')
	
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