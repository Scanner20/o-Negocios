*!*	DO TEST_CSV IN csv_varios WITH "G/R ","T00500000001" 
******************
PROCEDURE Test_CSV
******************
PARAMETERS PsCodDoc,PsNroDoc  
*!*	SET STEP ON
gocfgvta.odatadm.abrirtabla("ABRIR","ALMCTRAN","CTRA","CTRA03")  && TPORF1+NRORF1+SUBALM+TIPMOV+CODMOV+NRODOC
gocfgvta.odatadm.abrirtabla("ABRIR","ALMDTRAN","DTRA","DTRA04")  && TPOREF+NROREF+CODMAT+SUBALM+TIPMOV+CODMOV+NRODOC
gocfgvta.odatadm.abrirtabla("ABRIR","vtavguia","GUIA","VGUI01")  && CODDOC+NRODOC

SELECT CTRA
SET RELATION TO Ctra.tporf1+ Ctra.nrorf1 INTO Dtra ADDITIVE
SEEK PsCodDoc+PsNroDoc
IF FOUND()
	SCATTER NAME oData1
	SELECT DTRA
	IF DTRA.TpoRef+DTRA.NroRef=PsCodDoc+PsNroDoc
		oData2 = gocfgvta.odatadm.genobjdatos("DTRA",[TpoRef+NroRef="]+CTRA.TpoRf1+CTRA.NroRf1+["])
		SELE GUIA
		SEEK PsCodDoc+PsNroDoc
		IF FOUND()
			SCATTER NAME oData3
		ELSE
			MESSAGEBOX("NO EXISTE DOCUMENTO "+PsCodDoc+" "+PsNroDoc+"EN GUIA" ,0+16,"Verficar parametros del test")
			RETURN
		ENDIF
	ENDIF
ELSE
	MESSAGEBOX("NO EXISTE DOCUMENTO "+PsCodDoc+" "+PsNroDoc+" EN CTRA",0+16,"Verficar parametros del test")
	RETURN
ENDIF

*!*	IF EMPTY(gocfgvta.RutaSEE_SFS)
*!*		gocfgvta.Ruta_Factura_SEE_SFS()
*!*	ENDIF
*!*	LsRuta=gocfgvta.RutaSEE_SFS
IF EMPTY(goentpub.rutasee_sfs)
	goentpub.ruta_interfaces_see_ose_csv()
ENDIF

LsRuta1=goentpub.tspath_ose_gre
LsRuta2=goentpub.tspath_ose_csv

do vta_genera_txt_csv-efact_v1 WITH oData1,odata2,odata3,LsRuta1,LsRuta2
USE IN CTRA
USE IN DTRA
USE IN GUIA
RETURN
*!*	cClients = FILETOSTR("clients.txt")
*!*	nRows = ALINES(aClients,STRTRAN(cClients,",",CHR(13)))

*!*	COPY TO archivo.txt TYPE CSV CODEPAGE 65001 WITH  CR/LF


* Ejemplo de uso.
* Llamado
* Genera un cursor y llama a GenFileText()
*******************************************
SELECT nombre,idclien,cuit,calle,numero,cpostal,ciudad,provincia ;
	FROM clientes ;
	WHERE !EMPTY(cuit) AND VAL(idclien)#0 ;
	INTO CURSOR trclien
 
* Tipo: Cvs simil Excel
 
cFile="trclien<shut>"
cNomFiletext=ADDBS(dtemp)+"TxtClientes"
lHeader=.f.
lNotQuotes=.T.
cSymbol=";"
nFlag=0
GENFILETEXT(cFile,cNomFileText,cSymbol,lHeader,lNotQuotes,nFlag)
 
**********************************************************************************
PROCEDURE GENFILETEXT(xcFile,xcNomFileText,xcSymbol,xlHeader,xlNotQuotes,xnFlag)
**********************************************************************************
* Genera un archivo de texto plano, de tipo delimitado por Bajo Nivel
* xcFile: Tabla o cursor. Puede enviarse p.ej: cFile="MiCursor<shut>"
*         Con lo cual se cierra la tabla o cursor al terminar el proceso.
*         Tipicamente se genera un cursor ad-hoc para despachar los datos.
* xcNomFileText: Path\Nombre.ext del archivo de texto saliente.
*                La extensión por defecto será ".txt". Si desea otra extensión
*                incluya el nombre con la extensión requerida
*                Ej: xcNomfileText="\\MqCentral\TextOuput\miarchivoplano.ths"
* xcSymbol: Separador de campos: [,] [;] [|] [*] etc. (Default [,] )
* xlHeader: Si incluye el nombre de los campos en la primer fila
* xlNotQuotes: Por defecto, los campos caracter son encomillados (Delimited)
*              Si xlNotQuotes=.t., no tendrán comillas (SDF)
* xnFlag (manejado por FputLine() )
* 0 - Con Retorno de Carro, no incluye último separador
* 1 - Con Retorno de Carro, incluir útlimo separador
* 2 - Sin Retorno de Carro, no inlcuye último separador
* 3 - Sin REtorno de Carro, incluir último separador
******************************************************************************
* Funciones de usuario Utilizadas por GenFileTExt
* FPutLine()
* Qualifer()
* TelDecim() (convocada por Qualifer)
******************************************************************************
LOCAL nfop,lcRow,i,lnCampos,lShut
IF EMPTY(xcFile)
	RETURN
ENDIF
xcfile=LOWER(xcFile)
IF AT("<shut>",xcfile)#0
	lshut=.t.
	xcFile=STRTRAN(xcFile,"<shut>","")
ENDIF
 
IF !USED(xcFile)
	RETURN
ENDIF
IF EMPTY(xcNomFileText)
	RETURN
ENDIF
xnFlag=EVL(xnFlag,0)
IF xnFlag>3
	xnFlag=0
ENDIF
 
xcNomfileText=ALLTRIM(xcNomfileText)
lcExt=JUSTEXT(xcNomFileText)
IF EMPTY(lcExt)
	xcNomFileText=xcNomFileText+".txt"
ENDIF
 
xcSymbol=EVL(xcSymbol,[,])
nfop=FCREATE(xcNomFileText)
IF nfop<0
	RETURN
ENDIF
 
SELECT (xcFile)
lnCampos=FCOUNT()
IF xlHeader
	lcRow=""
	FOR i=1 TO lnCampos
		lcRow=lcRow+Qualifer(FIELD(i),xcSymbol,xlNotQuotes)
	NEXT
	fputLine(nfop,lcRow,xnFlag,xcSymbol)
ENDIF
 
SCAN
	lcRow=""
	FOR i=1 TO lnCampos
		lcCampo=FIELD(i)
 
		lcRow=lcRow+Qualifer(EVALUATE(lcCampo),xcSymbol,xlNotQuotes)
	NEXT
	fputLine(nfop,lcRow,xnFlag,xcSymbol)
 
ENDSCAN
=FCLOSE(nfop)
IF lshut
	IF USED(xcfile)
		SELECT (xcFile)
		USE
	ENDIF
ENDIF
o = CREATEOBJECT("Shell.Application")
o.ShellExecute("write.exe", '&xcNomFileText', "", "open", 1)
ENDPROC
 
PROCEDURE fputLine(xnfop,xcRow,xnFlag,xcSymbol)
***********************************************
xcRow=ALLTRIM(xcRow)
xcSymbol=EVL(xcSymbol,",")
xnFlag=EVL(xnFlag,0)
IF MOD(xnFlag,2)=0
	IF RIGHT(xcRow,1)=xcSymbol
		xcRow=LEFT(xcRow,LEN(xcRow)-1)
	ENDIF
ELSE
	IF RIGHT(xcRow,1)#xcSymbol
		xcRow=xcRow+xcSymbol
	ENDIF
ENDIF
DO case
	CASE INLIST(xnFlag,0,1)
		=FPUTS(xnfop,xcRow)
	CASE INLIST(xnFlag,2,3)
		=FWRITE(xnfop,xcRow)
ENDCASE
ENDPROC
 
 
*****************************************
PROCEDURE TelDecim(xcnNUmero,xnPrecision)
*****************************************
* Determina la cantidad de decimales de un número.
* xnPrecision podría ser Entre 10 y 16
* 16 daría una precisión mayor pero válida para
* números con alta cantidad de decimales.
*********************************************
local i_,minumero,pnumero,cRest,nDecimales
if vartype(xnprecision)#"N"
	xnPrecision=10
endif
kevar=Vartype(xcnNumero)
do case
	case kevar="C"
		minumero=val(xcnNumero)
	case kevar$'NI'
		Minumero=xcnNumero
	other
		return 0
endcase
if minumero=0
	return 0
endif
nDecimales=16
for i_=0 to 16
	pNumero=Round(MiNumero*10**i_,xnPrecision)
	cRest=pNumero-Int(pNumero)
	nDecimales=i_
	if Round(cRest,xnPrecision)=0
		exit
	endif
next
return nDecimales
ENDPROC
 
 
**********************************
PROCEDURE QUALIFER(xDato,xcSymbol,xlNotQuotes)
***********************************
* Calificador de datos simil Delimited
 
LOCAL lcQuot,lcClin,lcRemp,kvt,vret,qdezim
lcQuot=IIF(xlNotQuotes,[],["])
if vartype(xcSymbol)#"C".or.empty(xcSymbol)
	xcSymbol=","
endif

kvt=vartype(xDato)
vret=""
lcClin=CHR(9)+CHR(10)+CHR(13)
lcRemp=REPLICATE(SPACE(1),3)
do case
	case kvt="C"
		xDato=CHRTRAN(xDato,lcClin,lcRemp)
		vret=lcQuot+alltrim(strtran(xdato,xcSymbol))+lcQuot
	case kvt="N"
		qDezim=TelDecim(xDato)
		vret=ltrim(str(xDato,20,qDezim))
	
	case kvt="I"
		vret=ltrim(str(xdato))
	
	case kvt="D"
		vret=dtoc(xdato)
	case kvt="T"
		vret=ttoc(xdato)
	case kvt="L"
		vret=iif(xdato,".T.",".F.")
	other
	
endcase

return vret+xcSymbol
ENDPROC

*!*	En Visual Foxpro 9 tengo una tabla DBF tabla1.dbf con 13 registros y 10 campos, campo1,campo2,campo3,campo4,campo5,campo6,campo7,campo8,campo9,campo10 ; necesito exportarlo a un archivo de texto con formato CSV con nombre file1.csv, cada fila del archivo file1.csv debe tener un salto de linea entre cada fila resultante. 
*!*	Ademas el archivo resultante file1.csv debe tener la codificación UTF-8 SIN BOM. 
*!*	Tomar en cuenta que en la ayuda de VFP9 se explica que la funcion STRTOFILE tiene un 3er parámetro: 
*!*	nFlag Bit Description 
*!*	0 (default) 0000 The file is overwritten with the character string (formerly lAdditive=.f.) 
*!*	1 0001 The string is appended to the end of the file (formerly lAdditive=.t.). 
*!*	2 0010 Write Unicode Byte Order Mark (BOM) FF FE at the beginning of file. cExpression is   assumed to be UNICODE, therefore no translation is performed. The file is overwritten 
*!*	4 0100 Write UTF-8 Byte Order Mark (BOM) EF BB BF at the beginning of file. cExpression is assumed to be UTF-8, therefore no translation is performed. The file is overwritten. 
*!*	También tomar en cuenta que al final del campo10 debe haber un salto de línea para pasar a formar la siguiente fila del archivo file1.csv
*!*	Puedes generar el codigo en VFP9 que realice lo anteriormente explicado?



****************
FUNCTION DBF2CSV
****************
LOCAL lnFields

SELECT DBF
lnFieldCount = AFIELDS(laFields)
lnHandle = FOPEN("filename.csv", 1)
ASSERT lnHandle > 0 MESSAGE "Unable to create CSV file"

SCAN
    lcRow = ""
    FOR lnFields = 1 TO lnFieldCount
    IF INLIST(laFields[lnFields,2], 'C', 'M')
            lcRow = lcRow + IIF(EMPTY(lcRow), "", ",") + '"' + ;
                            STRTRAN(EVALUATE(laFields[lnFields,1]),'"', '""') + '"'
        ELSE
            lcRow = lcRow + IIF(EMPTY(lcRow), "", ",") + ;
                            TRANSFORM(EVALUATE(laFields[lnFields,1]))
        ENDIF
    ENDFOR

    FWRITE(lnHandle, lcRow)
ENDSCAN
FCLOSE(lnHandle)

*****************************
FUNCTION DBF2CSV_SIM_BOM_UTF8
*****************************
lcFileName = "file1.csv"

SET TEXTMERGE TO (lcFileName) NOSHOW
TEXT TO m.lcText NOSHOW PRETEXT 1

SCAN
   ? TRANSFORM(campo1), ",", TRANSFORM(campo2), ",", TRANSFORM(campo3), ",", TRANSFORM(campo4), ",", TRANSFORM(campo5), ",", ;
      TRANSFORM(campo6), ",", TRANSFORM(campo7), ",", TRANSFORM(campo8), ",", TRANSFORM(campo9), ",", TRANSFORM(campo10)
   ? CHR(13) + CHR(10)  && Salto de línea al final de cada fila
ENDSCAN

POSTTEXT 1
SET TEXTMERGE TO

MODI FILE (lcFileName) NOWAIT
STRTOFILE(m.lcText, (lcFileName), 4)  && El tercer parámetro 4 indica UTF-8 SIN BOM

RETURN

*****************************
FUNCTION DBF2CSV2-SIM_BOM_UTF8
*****************************

LOCAL lnFileHandle, lcLine, lnI
lnFileHandle = FCREATE("file1.csv")
IF lnFileHandle > 0
    FOR lnI = 1 TO 13
        lcLine = ""
        lcLine = campo1[lnI] + "," + campo2[lnI] + "," + campo3[lnI] + "," + campo4[lnI] + "," + campo5[lnI] + "," + campo6[lnI] + "," + campo7[lnI] + "," + campo8[lnI] + "," + campo9[lnI] + "," + campo10[lnI] + CHR(13) + CHR(10)
        FPUTS(lnFileHandle, lcLine)
    ENDFOR
    STRTOFILE("", "file1.csv", 4)
    FCLOSE(lnFileHandle)
ENDIF
*********************
DBF2CSV3-SIM_BOM_UTF8
*********************
*!*	// Definimos los parámetros de la tabla DBF
LOCAL nRecs := 13
LOCAL nFields := 10
LOCAL cTable := "tabla1.dbf"

*!*	// Abrimos la tabla DBF
USE cTable

*!*	// Bucle para recorrer los registros de la tabla
FOR n := 1 TO nRecs

*!*	  // Guardamos los valores de los campos en variables locales
  LOCAL aValues := {}
  FOR i := 1 TO nFields
    LOCAL cValue := UPPER(ALLTRIM(FIELD(i)))
    ADDITEM aValues, cValue
  NEXT i

*!*	  // Generamos la línea CSV
  LOCAL cLine := aValues[1]
  FOR i := 2 TO nFields - 1
    cLine := cLine + "," + aValues[i]
  NEXT i

*!*	  // Agregamos el salto de línea al final del campo10
  cLine := cLine + CRLF

*!*	  // Escribimos la línea CSV en el archivo
  STRTOFILE cLine, "file1.csv", 0, 4

NEXT n

*!*	// Cerramos la tabla DBF
CLOSE cTable

*********************
DBF2CSV4-SIM_BOM_UTF8
*********************
LOCAL lcOutputFile
lcOutputFile = "file1.csv"

TEXT TO lcContent TEXTMERGE NOSHOW
<<
campo1,campo2,campo3,campo4,campo5,campo6,campo7,campo8,campo9,campo10
>>

SELECT tabla1
SCAN FOR !EMPTY(campo1) && Assuming campo1 as a key field
    STRTOFILE(ALLTRIM(campo1) + "," + ;
              ALLTRIM(campo2) + "," + ;
              ALLTRIM(campo3) + "," + ;
              ALLTRIM(campo4) + "," + ;
              ALLTRIM(campo5) + "," + ;
              ALLTRIM(campo6) + "," + ;
              ALLTRIM(campo7) + "," + ;
              ALLTRIM(campo8) + "," + ;
              ALLTRIM(campo9) + "," + ;
              ALLTRIM(campo10), lcOutputFile, 1+4)
ENDSCAN

USE IN SELECT('tabla1')

******************************
FUNCTION DBF2CSV5-SIM_BOM_UTF8
******************************
*!*	You can prevent the parse error generated by converting the string to UTF-8 
*!*	when the XML is written or when it is written to the file. The following example 
*!*	converts the string to UTF-8 as it is being written to the file by using the STRCONV( ) function with the STRTOFILE( ) function:
*!*	CLOSE DATABASE ALL
*!*	USE HOME(2)+"\data\customer"
*!*	CURSORTOXML("customer","lcXML",1,32)
*!*	STRTOFILE(STRCONV(lcXML,9),"customer.xml")
*!*	XMLTOCURSOR("customer.xml","curCustomer",512)

** VETT:  Esta es la forma de convertir un archivo CSV a formato encode "UTF-8 sin BOM" IDUPD:3318093114-21/12/2023 03:08 PM
lcFile="b:\users\victor\documents\o-negocios\queirolo\gre\envio directo csv\guia de remision remitente csv\01 motivo de traslado venta\ejemplo 1 - venta con traslado privado\prueba_ansi.csv"
LcString = FILETOSTR(LcFile)
ADDBS(JUSTPATH(lcfile))+"prueba_utf8.csv"
STRTOFILE(STRCONV(lcString,9),ADDBS(JUSTPATH(lcfile))+"prueba_utf8.csv")
RETURN
 
