PARAMETERS PsTipo,PsNota,PsFact
** Ejemplo
**  MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000058.NOT
**  do ccb_copynotas_see-sfs with  "07","F002-00000059","F001-00004537"
LsModNotCAB=[0101|2020-12-16|09:09:54|0000|6|20100654025|RAZSOC|USD|07|DEVOLUCI�N POR �TEM|01|F001-00005054|46.43|8.36|54.79|0.00|0.00|0.00|54.79|2.1|2.0|]

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LsTpoDoc = 'ABONO'
LsCodDoc=ICASE(PsTipo='07','N/C ','08','N/D ','')
LsCodDoc=PADR(LsCodDoc,LEN(GDOC.CODDOC))
IF EMPTY(LsCodDoc)
	MESSAGEBOX("No esta definido el tipo de documento, debe ser 07 para N/Cr�dito  � 08 para N/D�bito ",48,"Atenci�n / Warning !!") 
	RETURN 
ENDIF
SELECT GDOC 
SEEK LsTpoDoc+LsCodDoc+PsNota
IF !FOUND()
	MESSAGEBOX("No se encuentra el documento "+LsTpoDoc+" "+LsCodDoc+" "+PsNota,48,"Atenci�n / Warning !!") 
	RETURN 
ENDIF
LdFchDoc = GDOC.FchDoc

LsRutaCia =ADDBS("O:\o-negocios\Interface\facturador\cia_001\")
LsRucCia  = GsRucCia
LsFileFrom=LsRutaCia +GsRucCia+"-01-"+PsFact
LsFileTO	    =LsRutaCia +GsRucCia+"-"+PsTipo+"-"+PsNota
 
COPY FILE LsFileFrom+".DET" 	TO LsFileTO+".DET"
COPY FILE LsFileFrom+".TRI"	 	TO LsFileTO+".TRI"
COPY FILE LsFileFrom+".LEY"  	TO LsFileTO+".LEY"
COPY FILE LsFileFrom+".ACA"	TO LsFileTO+".ACA"


*******************
FUNCTION Envia_Nota
*******************
PARAMETERS PcAliasCAB. PcAlasDET
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
	=MESSAGEBOX('No tiene permiso para realizar este procedimiento',48,'� ATENCION ! / � WARNING !')	
ENDIF