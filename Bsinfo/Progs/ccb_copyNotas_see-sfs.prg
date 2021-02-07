PARAMETERS PsTipo,PsNota,PsFact
** Ejemplo
**  MODIFY COMMAND O:\o-negocios\Interface\facturador\cia_001\20427712959-07-F002-00000058.NOT
**  do ccb_copynotas_see-sfs with  "07","F002-00000059","F001-00004537"
LsModNotCAB=[0101|2020-12-16|09:09:54|0000|6|20100654025|RAZSOC|USD|07|DEVOLUCIÓN POR ÍTEM|01|F001-00005054|46.43|8.36|54.79|0.00|0.00|0.00|54.79|2.1|2.0|]

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
SEEK LsTpoDoc+LsCodDoc+PsNota
IF !FOUND()
	MESSAGEBOX("No se encuentra el documento "+LsTpoDoc+" "+LsCodDoc+" "+PsNota,48,"Atención / Warning !!") 
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