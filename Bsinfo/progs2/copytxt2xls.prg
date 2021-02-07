*!*	LcNvlFieldlist=[CAST(NVL(CODCTA,0) AS V(8)),CAST(NVL(NOMCTA,'') AS C(60)),CAST(NVL(CTAE2010,'') AS C(8)),CAST(NVL(CTAE2010B,'') AS C(8)),CAST(NVL(FILTRO,'') AS C(20)),CAST(NVL(NIVCTA,0) AS B),CAST(NVL(TPOMOV,'') AS C(1)),CAST(NVL(AFTMOV,'') AS C(1)),CAST(NVL(AFTDCB,'') AS C(1)),CAST(NVL(CODMON,0) AS B),CAST(NVL(TPOCMB,0) AS B),CAST(NVL(TPOCTA,0) AS B),CAST(NVL(PIDAUX,'') AS C(1)),CAST(NVL(CLFAUX,'') AS C(3)),CAST(NVL(PIDDOC,'') AS C(1)),CAST(NVL(PIDCCO,'') AS C(1)),CAST(NVL(CODDOC,'') AS C(3)),CAST(NVL(CIERES,'') AS C(1)),CAST(NVL(GENAUT,'') AS C(1)),CAST(NVL(AN1CTA,'') AS C(8)),CAST(NVL(CC1CTA,'') AS C(8)),CAST(NVL(AN2CTA,'') AS C(8)),CAST(NVL(CC2CTA,'') AS C(8)),CAST(NVL(AN2CTAME,'') AS C(8)),CAST(NVL(CODREF,'') AS C(5)),CAST(NVL(NROCTA,'') AS C(35)),CAST(NVL(CODBCO,'') AS C(3)),CAST(NVL(PIDGLO,'') AS C(1)),CAST(NVL(MAYAUX,'') AS C(1)),CAST(NVL(MAYCCO,'') AS C(1)),CAST(NVL(NROCHQ,'') AS C(10)),CAST(NVL(SECBCO,'') AS C(30)),CAST(NVL(REFBCO,'') AS C(10)),CAST(NVL(TPOGTO,'') AS C(3)),CAST(NVL(FLGBCO,'') AS C(1)),CAST(NVL(CTACJA,'') AS C(1)),CAST(NVL(PORCEN,0) AS B),CAST(NVL(CCTDEF,.F.) AS L),CAST(NVL(AN1_SUBCTA,.F.) AS L),CAST(NVL(CC1_SUBCTA,.F.) AS L),CAST(NVL(TIP_AFE_RV,'') AS C(1)),CAST(NVL(TIP_AFE_RC,'') AS C(1)),CAST(NVL(TIP_AFE_RT,'') AS C(1)),CAST(NVL(CTACOB,'') AS C(8)),CAST(NVL(CTADES,'') AS C(8)),CAST(NVL(CODCTA_B,'') AS C(8)),CAST(NVL(CTAGAS,'') AS C(8)),CAST(NVL(CTAINT,'') AS C(8))]


_archivo='c:\temp\Prueba.txt'
=ParseText(_archivo)

FUNCTION ParseText
PARAMETERS pArchivo
SET STEP ON
CREATE TABLE c:\temp\arctemp FREE (Archivo M )
APPEND BLANK
APPEND MEMO Archivo FROM c:\temp\prueba.txt
SET MEMOWIDTH TO 155
FOR k = 1 TO MEMLINES(Archivo)
	
ENDFOR


archerr=FOPEN(pArchivo,0)
STORE FSEEK(archerr, 0, 2) TO pa_size      && Mueve el puntero a EOF
STORE FSEEK(archerr, 0)    TO pa_arriba 
IF pa_size<= 0                             && ¨El archivo est  vac¡o?
   WAIT WINDOW ' Este archivo esta  vacio!' NOWAIT
ENDIF



DO WHILE !FEOF(archerr)
   WAIT WINDOWS "Espere un momento... Procesando..!!!" NOWAIT
   cadena = FREAD(archerr,240)
ENDDO
=FCLOSE(archerr)   

PROCEDURE xlsopen
*----------------
#DEFINE xlMaximized -4137
#DEFINE xlLastCell 11      && added on 15/04/2010

LPARAMETERS lcOutFile

LOCAL loExcel as Excel.Application
LOCAL loWorkBook as Excel.Workbook
LOCAL loActiveSheet as Excel.Sheets
LOCAL loRange as Excel.Range
LOCAL lError, lcFileName

lError = .F.
lcFileName = SYS(5)+SYS(2003)+"\"+lcOutFile
*!*	WAIT WINDOW lcFileName

loExcel = CREATEOBJECT("Excel.Application")
* Added on 15/04/2010
* open the workbook you just created
loExcel.SheetsInNewWorkBook = 1
loWorkbook = loExcel.Workbooks.Open(lcFileName)
loActiveSheet = loExcel.ActiveSheet

* Rename the Sheet to whatever you like, if you want
*!*	loActiveSheet.Name = "MyData"
* ----------------------------------------------

loExcelApp = loExcel.Application
loExcelApp.WindowState = xlMaximized

* -----------------------------
** Added on 15/04/2010
* Find address of last occupied cell
lcLastCell = loExcel.ActiveCell.SpecialCells(xlLastCell).Address()
* Resize all columns
lnMarker1 = at("$",lcLastCell,1)  && i.e. 1 when lcLastCell = "$AF$105"
lnMarker2 = at("$",lcLastCell,2)  && i.e. 4 when lcLastCell = "$AF$105"
lnStartPos = lnMarker1 + 1
lnStrLen = lnMarker2 - lnStartPos
loExcel.Columns("A:" + SUBSTR ;
  (lcLastCell,lnStartPos,lnStrLen)).EntireColumn.AutoFit
* -----------------------------

loExcel.visible = .T.
RETURN

**********************
PROCEDURE Dbf2XlsExample1
**********************
CREATE CURSOR curCompany (Company C(20), Qtr1 N(10,2), qtr2 N(10,2), qtr3 N(10,2), qtr4 N(10,2))
FOR lni = 1 TO 10
    APPEND BLANK
    REPLACE curCompany.company WITH SYS(2015)
    REPLACE curCompany.qtr1 WITH 1 + 1000 * RAND( )
    REPLACE curCompany.qtr2 WITH 1 + 1000 * RAND( )
    REPLACE curCompany.qtr3 WITH 1 + 1000 * RAND( )
    REPLACE curCompany.qtr4 WITH 1 + 1000 * RAND( )
ENDFOR
    
    
* Excel: HorizontalAlignment
* 2 = Left
* 3 = Center
* 4 = Right
    
local oExcel, oSheet
oExcel = CreateObject([Excel.Application])
oExcel.Visible = .T.
oExcel.Workbooks.Add()

oSheet = oExcel.ActiveSheet

lnRow = 0
SELECT curCompany
GO TOP
DO WHILE NOT EOF()
    lnRow = lnRow + 1
    IF lnRow = 1
        oSheet.Cells(lnRow,1).Value = [FoxPro Rocks!]
        
        lnRow = 3
        lnCol = 3
        oSheet.Range([C3]).Select
        oSheet.Cells(lnRow,lnCol).Value = [Qtr 1]
        oSheet.Cells(lnRow,lnCol).Font.Bold = .T.
        
        *oSheet.Cells(lnRow,lnCol).HorizontalAlignment = xlCenter
        oSheet.Cells(lnRow,lnCol).HorizontalAlignment = 3
        
        lnCol = lnCol + 1
        oSheet.Range([D3]).Select
        oSheet.Cells(lnRow,lnCol).Value = [Qtr 2]
        oSheet.Cells(lnRow,lnCol).Font.Bold = .T.
        *oSheet.Cells(lnRow,lnCol).HorizontalAlignment = xlCenter
        oSheet.Cells(lnRow,lnCol).HorizontalAlignment = 3
        
        lnCol = lnCol + 1
        oSheet.Range([E3]).Select
        oSheet.Cells(lnRow,lnCol).Value = [Qtr 3]
        oSheet.Cells(lnRow,lnCol).Font.Bold = .T.
        *oSheet.Cells(lnRow,lnCol).HorizontalAlignment = xlCenter
        oSheet.Cells(lnRow,lnCol).HorizontalAlignment = 3

        lnCol = lnCol + 1
        oSheet.Range([F3]).Select
        oSheet.Cells(lnRow,lnCol).Value = [Qtr 4]
        oSheet.Cells(lnRow,lnCol).Font.Bold = .T.
        *oSheet.Cells(lnRow,lnCol).HorizontalAlignment = xlCenter
        oSheet.Cells(lnRow,lnCol).HorizontalAlignment = 3
        
        lnRow = 4
        lnBeginRange = lnRow
    ENDIF
    
    oSheet.Cells(lnRow,1).Value = curCompany.Company
    oSheet.Cells(lnRow,3).Value = curCompany.qtr1
    oSheet.Cells(lnRow,4).Value = curCompany.qtr2
    oSheet.Cells(lnRow,5).Value = curCompany.qtr3
    oSheet.Cells(lnRow,6).Value = curCompany.qtr4

    SKIP
ENDDO        

* Create the formula rather than hardcoding total so the user can
* change the spreadsheet and it will reflect new totals.
* Example:  =SUM(D5:D10)
FOR lni = 1 TO 4
lcFormula = [=SUM(] + CHR(64 + lni) + ALLTRIM(STR(m.lnBeginRange)) + [:] +;
                CHR(64 + 3 + lni) + ALLTRIM(STR(m.lnRow)) + [)]
                

oSheet.Cells(lnRow+1,2+lni).Formula = [&lcFormula]
ENDFOR




*****************************************************
*!*	Late Edition.
*!*	These miscellaneous Excel automation command are compliments of jrbbldr
*!*	JRB-Bldr
*!*	VisionQuest Consulting
*!*	Business Analyst & CIO Consulting Services
*!*	CIOServices@yahoo.com
*****************************************************

tmpsheet = CREATEOBJECT('excel.application')
oExcel = tmpsheet.APPLICATION

* --- Set Excel to only have one worksheet ---
oExcel.SheetsInNewWorkbook = 1

* --- Delete the Default Workbook that has 3 worksheets ---
oExcel.Workbooks.CLOSE

* --- Now Add a new book with only 1 worksheet ---
oExcel.Workbooks.ADD
xlBook = oExcel.ActiveWorkbook.FULLNAME
xlSheet = oExcel.activesheet

* --- Name Worksheet ---
xlSheet.NAME = "Sheet Name"

* --- Make Excel Worksheet Visible To User ---
oExcel.VISIBLE = .T. && Set .F. if you want to print only

*!*	   <do whatever>

oExcel.WINDOWS(xlBook).ACTIVATE
xlSheet.RANGE([A2]).SELECT

* --- Save Excel Results ---
oExcel.CutCopyMode = .F. && Clear the clipboard from previous Excel Paste
oExcel.DisplayAlerts = .F.

* --- Save Results ---
xlSheet.SAVEAS(mcExclFName)

* --- Close the Worksheet ---
oExcel.workbooks.CLOSE

* --- Quit Excel ---
oExcel.QUIT
RELEASE oExcel

tmpsheet = CREATEOBJECT('excel.application')
oExcel = tmpsheet.APPLICATION
oExcel.ReferenceStyle = 1  && Ensure Columns in A-B Format instead of 1-2 Format

mcStrtColRow = 'A1'
mcEndColRow = 'AB5'
mcLastCol = 'AZ:'

* --- Time Masquerading As Text Format Cells ---
xlSheet.RANGE[mcStrtColRow,mcEndColRow].EntireColumn.NumberFormat = "h:mm:ss"

* --- Standard Text Format Cells ---
xlSheet.RANGE[mcStrtColRow,mcEndColRow].EntireColumn.NumberFormat = "@"

* --- Date Format Cells ---
xlSheet.RANGE[mcStrtColRow,mcEndColRow].EntireColumn.NumberFormat = "mm/dd/yyyy"

* --- Auto-Fit All Columns ---
xlSheet.COLUMNS("A:" + mcLastCol).EntireColumn.AutoFit

*********************** 
 PROCEDURE Dbf2XLsExample2
 ***********************
 loExcel=CREATEOBJECT("Excel.application")

*!*	*!*	Hacemos visible la aplicación Excel, para observar lo que hacemos mediante OLE:

loExcel.APPLICATION.VISIBLE = .T.

*!*	Agregamos un nuevo libro:

loExcel.APPLICATION.workbooks.ADD

*!*	Guardamos el libro con el nombre "C:\VFP_XLS.xls":

loExcel.APPLICATION.activeworkbook.SAVEAS("C:\VFP_XLS")

*!*	Si ya tenemos el nombre, directamente lo guardamos:

loExcel.APPLICATION.activeworkbook.SAVE

*!*	*!*	Escribimos el texto "FoxPro" en una celda del libro activo:

loExcel.APPLICATION.activeworkbook.activesheet.cells(2,2).VALUE = "FoxPro"

*!*	Escribimos el texto "Visual FoxPro" en una celda de la hoja activa:

loExcel.APPLICATION.activesheet.cells(2,2).VALUE = "Visual FoxPro"

*!*	Seleccionamos la celda "B2" del libro activo

loExcel.APPLICATION.activeworkbook.activesheet.cells(2,2).SELECT

*!*	Cambiamos el formato de la celda:

loExcel.APPLICATION.activecell.FONT.NAME = "Times New Roman"
loExcel.APPLICATION.activecell.FONT.SIZE = 16
loExcel.APPLICATION.activecell.FONT.Bold = .T.
loExcel.APPLICATION.activecell.FONT.Bold = .F.
loExcel.APPLICATION.activecell.FONT.Italic = .T.

*!*	Guardamos los cambios y cerramos Excel:

loExcel.APPLICATION.activeworkbook.SAVE
loExcel.APPLICATION.activeworkbook.CLOSE
loExcel.APPLICATION.QUIT
RELEASE loExcel

*!*	*!*	Ahora vamos a trabajar con una planilla ya creada. Creamos nuevamente el objeto Excel:

loExcel=CREATEOBJECT("Excel.application")
loExcel.APPLICATION.VISIBLE=.T.

*!*	Abrimos el libro Excel que ya existe:

loExcel.APPLICATION.workbooks.OPEN("C:\VFP_XLS")

*!*	Cambiamos el nombre de la hoja activa:

loExcel.APPLICATION.activesheet.NAME = "Mi Hoja"

*!*	Hacemos referencia directamente a "Mi Hoja", y ponemos valores en una celda y le damos formato:

loExcel.APPLICATION.Sheets("Mi Hoja").cells(1,1).VALUE = 125.789
loExcel.APPLICATION.Sheets("Mi Hoja").cells(1,1).VALUE = 2123.123456
loExcel.APPLICATION.Sheets("Mi Hoja").cells(1,1).NumberFormat = "#,##0.00"
loExcel.APPLICATION.Sheets("Mi Hoja").cells(1,1).VALUE = 0.045
loExcel.APPLICATION.Sheets("Mi Hoja").cells(1,1).NumberFormat = "0.00%"
loExcel.APPLICATION.activeworkbook.SAVE
loExcel.APPLICATION.QUIT
RELEASE loExcel

PROCEDURE  dbf2XlsExample3
#DEFINE xlsum -4157

*!* Create a reference to an Excel OLE object
oExcel = CREATEOBJECT("Excel.application")  

With oExcel
*!* Add a new workbook
	.application.workbooks.Add

*!* Make Excel visible
    .Visible = .T.

*!* Add records to workbook
	.Range("A1").Value = "Company"
	.Range("B1").Value = "Number Sold"
	.Range("C1").Value = "Paid 30+"
	.Range("D1").Value = "Paid 60+"

	.Range("A2").Value = "AAA"
	.Range("B2").Value = "1"
	.Range("C2").Value = "1"
	.Range("D2").Value = "0"
		
	.Range("A3").Value = "AAA"
	.Range("B3").Value = "2"
	.Range("C3").Value = "0"
	.Range("D3").Value = "1"
		
	.Range("A4").Value = "BBB"
	.Range("B4").Value = "3"
	.Range("C4").Value = "1"
	.Range("D4").Value = "0"
		
	.Range("A5").Value = "BBB"
	.Range("B5").Value = "4"
	.Range("C5").Value = "1"
	.Range("D5").Value = "0"

*!*	Select cells 	
	.Range("A1:D5").Select  

	oSelected = .Selection

EndWith

*!* Insure array is 1 based
COMARRAY(oSelected, 11) 

*!* Create a FoxPro array to hold columns to be subtotaled
*!* Choose columns two and four to subtotal
LOCAL ARRAY laArray(2) 
laArray(1) = 2
laArray(2) = 4

*!* Call the subtotal function
oSelected.Subtotal(1, xlsum, @laArray, .T., .F., .T.)  

**********************
PROCEDURE Dbf2XlsExample4
**********************
#define xlLastCelly 11
#define xlMaximized -4137
#define xlRangeAutoformatClassic2 2
#define xlPortrait 1

use MyTable  && or SELECT * INTO MyCursor

cFileName = "MyXLSFile"  && or whatever, including path
*copy to (cFileName) fields (cFields) TYPE xls
copy to (cFileName) TYPE xls

* then open excel and make the data look good, like this
oExcel = CreateObject("Excel.Application")
if vartype(oExcel) != "O"
  * could not instantiate Excel object
  * show an error message here
  return .F.
endif

* make excel visible during development
*oExcel.visible = .T.

* open the workbook you just created
oExcel.SheetsInNewWorkBook = 1
oWorkbook = oExcel.Workbooks.Open(cFileName)

* rename the Sheet to whatever you like
oActiveSheet = oExcel.ActiveSheet
oActiveSheet.Name = "MyData"

oExcelApp = oExcel.Application
oExcelApp.WindowState = xlMaximized

* find address of last occupied cell
lcLastCell = oExcel.ActiveCell.SpecialCells(xlLastCelly).Address()

* resize all columns
lnMarker1 = at("$",lcLastCell,1)  && i.e. 1 when lcLastCell = "$AF$105"
lnMarker2 = at("$",lcLastCell,2)  && i.e. 4 when lcLastCell = "$AF$105"
lnStartPos = lnMarker1 + 1
lnStrLen = lnMarker2 - lnStartPos
oExcel.Columns("A:" + substr ;
  (lcLastCell,lnStartPos,lnStrLen)).EntireColumn.AutoFit

* you can even add a nice autoformat
oExcel.Range("A" + alltrim(str(nTOPBLANKROWS+1)) + ":" + lcLastCell).Select
oExcel.Selection.AutoFormat(xlRangeAutoformatClassic2,.t.,.t.,.t.,.t.,.t.,.t.)

* set Excel Print Area
oActiveSheet.PageSetup.PrintArea = "$A$1:" + lcLastCell

* define printed page footer
With loActiveSheet.PageSetup
	*.LeftHeader   = ""
	*.CenterHeader = ""
	*.RightHeader  = ""
	.LeftFooter   = "&BMy Footer goes here&B"
	.CenterFooter = "&D"
	.RightFooter  = "Page &P"
	*.PrintHeadings  = .F.
	.PrintGridlines = .F.
	.CenterHorizontally = .T.
	.CenterVertically = .F.
	.Orientation = xlPortrait
endwith

* save Excel file in new Excel format (COPY TO XLS uses old format)
oWorkbook.Save()

* display finished product to the user
oExcel.visible = .T.
**********************
PROCEDURE Dbf2XlsExample5
**********************
#DEFINE xlLastCellz 11

LOCAL loLastCell AS Excel.Range, ;
  lnFieldCount, ;
  lnImportedColumns, ;
  lnField, ;
  xx
LOCAL ARRAY laData[1,1], ;
  laFieldInfo[1]

* I'm skipping the code to create the oExcel object, load a workbook, and select
* a worksheet.

WITH oExcel.ActiveWorkBook.ActiveSheet
  * This is just asking Excel to give us the last cell for the range of data,
  * but you can use whatever technique you want to determine the range to use.
  loLastCell = .Cells.SpecialCells( xlLastCellz )

  * This command re-dimensions and populates the array with all the data from
  * the specified Range.
  * Note that in this example I assume that the first row contains captions
  * or field names.
  laData = .Range( .Cells(2,1), m.loLastCell ).Value
ENDWITH

*-- MJP -- Begin Update 2011/09/13
lnFieldCount = AFIELDS( laFieldInfo, "MyAlias" )

* We need to check how many columns are actually being imported, since the user
* could have omitted some.
lnImportedColumns = MIN( m.lnFieldCount, ALEN( laData, 2 ) )

* Check the data being imported, and convert data types as needed.
FOR lnField = 1 TO m.lnImportedColumns
  * For now, assume that any data not being imported into a Character or Varchar
  * field is either of a compatible data type, or is invalid and should be ignored.
  IF NOT INLIST( laFieldInfo[m.lnField,2], "C", "V" )
    LOOP
  ENDIF

  FOR xx = 1 TO ALEN( laData, 1 )
    * The situation we are most likely to encounter is a Numeric value being
    * imported into a Character field.  INSERT .. FROM ARRAY does not perform
    * any kind of CAST, but simply ignores the numeric value, leaving the field
    * blank.  Converting the number to a string before the INSERT allows it to
    * be imported properly.
    IF VARTYPE( laData[m.xx,m.lnField] ) = "N"
      laData[m.xx,m.lnField] = TRANSFORM( laData[m.xx,m.lnField] )
    ENDIF
  ENDFOR
ENDFOR
*-- MJP -- End Update 2011/09/13

* You can now process the data directly in the array, or dump it into a cursor:
* INSERT INTO MyAlias FROM ARRAY laData
* -- OR --
* SELECT MyAlias
* APPEND FROM ARRAY laData FOR Some Condition

**********************
PROCEDURE Dbf2XlsExample6
**********************
*!*	    Sometimes the Last Cell is not up-to-date after deleting a row in Excel,
*!*	    Calling ActiveSheet.UsedRange after deleting a row will keep Last Cell
*!*	    up-to-date.

loExcel = createobject('Excel.Application')
loExcel.Workbooks.Open(tcFile)
loExcel.Rows("1").Delete(xlUp)
lnLastRowIncorrect = loExcel.Cells.SpecialCells(xlCellTypeLastCell).Row
loExcel.ActiveSheet.UsedRange && add this line
lnLastRowCorrect = loExcel.Cells.SpecialCells(xlCellTypeLastCell).Row

*!*	My suggestions:
*!*	Working with Excel means you're doing COM calls using VBA which by nature is slow. Therefore, whenever possible, do things at VFP side and call Excel automation commands as few as you can. ie:

*!*	Instead of this:

for ix = 1 to 5000
  for jx=1 to 10
    .Cells(m.ix,m.jx).Value = m.ix*100+m.jx
  endfor
endfor



*!*	Do this:

dimension aExcelData[5000,10]
for ix = 1 to 5000
  for jx=1 to 10
    aExcelData[m.ix,m.jx] = m.ix*100+m.jx
  endfor
endfor

WITH oExcel.ActiveWorkBook.ActiveSheet
  .Range(.Cells(1,1), .Cells(5000,10)).Value = GetArrayRef('aExcelData')
endwith

PROCEDURE GetArrayRef(tcArrayName)
RETURN @&tcArrayName

*!****************************************************************************!*
*!* Beginning of program VFPExcel.prg                                        *!*
*!****************************************************************************!*
PROCEDURE Dbf2XlsExample7
Parameter lnPaperOrientation

*!*            1 = letter size paper, portrait orientation    (1,1)          *!*
*!*            2 = letter size paper, landscape orientation   (1,2)          *!*
*!*            3 = legal size paper,  portrait orientation    (5,1)          *!*
*!*            4 = legal size paper,  landscape orientation   (5,2)          *!*

*!* The following line of code sets a default lnPaperOrientation value of 1  *!*
*!* where no parameter is passed                                             *!*
lnPaperOrientation = ;
	IIF(Type("lnPaperOrientation") = "L", 1, lnPaperOrientation)

*!* The following code sets the paper size and orientation variables based   *!*
*!* on the lnPaperOrientation value                                          *!*
Do Case

Case lnPaperOrientation = 2
	lnPaperSize = 1
	lnPrintOrientation = 2

Case lnPaperOrientation = 3
	lnPaperSize = 5
	lnPrintOrientation = 1

Case lnPaperOrientation = 4
	lnPaperSize = 5
	lnPrintOrientation = 2

Otherwise

	lnPaperSize = 1
	lnPrintOrientation = 1

Endcase

*!* The following code determines whether or not there is a table open in    *!*
*!* the currently selected work area.                                        *!*
lcTableAlias = Alias()
If Empty(lcTableAlias)
	=Messagebox("A table must be open in the currently selected work area" + ;
		CHR(13) + "in order for this program to work.")
	Return                     &&  If no table is open, then return           *!*
Endif
Delete For Total=0
SET DELETED ON
pack
*!* The following code determines the derived Excel file name and location.  *!*
lcTablePath = Left(Dbf(), Rat("\", Dbf()))
lcExcelFile = lcTablePath + lcTableAlias + ".xls"
If File(lcExcelFile)          &&  If a file by the derived name already      *!*
*!* exists in the derived location             *!*
	lcMessageText = "An Excel file by the name of " + lcTableAlias + ;
		".xls" + Chr(13) + "already exists at location:" + Chr(13) + ;
		lcTablePath + Chr(13) + ;
		"Do you want to delete it now and replace it?"
	lnDialogType  = 4 + 32 + 256
	lnFirstWarning = Messagebox(lcMessageText, lnDialogType)
	If lnFirstWarning = 6      && User responds with a "Yes"                  *!*
		lcMessageText = "This will delete the exist file:" + Chr(13) + ;
			lcExcelFile + Chr(13) + ;
			"Are you certain?"
		lnDialogType = 4 + 48 + 256
		lnSecondWarning = Messagebox(lcMessageText, lnDialogType)
		If lnSecondWarning = 6  && User responds with a "Yes"                  *!*
			Erase (lcExcelFile)  && Erase the existing file                     *!*
		Else
			Return
		Endif
	Else
		Return
	Endif
Endif

*!* The following code determines the selected range of the print area for   *!*
*!* the derived Excel file.  This is based on the number of fields in the    *!*
*!* source table (columns) and the number of records in the source table     *!*
*!* (rows).  A range of three rows is added to the number of records.  This  *!*
*!* allows for the following:                                                *!*
*!* One row is added by the COPY TO process to hold the names of the fields. *!*
*!* One row is inserted as a spacer between the field names and the first    *!*
*!* row of data.                                                             *!*
*!* One row is added to the bottom to contain a SUM function for numeric,    *!*
*!* integer, and/or currency data.                                           *!*
lcTotalRangeExpr = ;
	["A1:] + ColumnLetter(Fcount()) + Alltrim(Str(Reccount() + 3)) + ["]
lcTotalPrintArea = ;
	["$A$1:$] + ColumnLetter(Fcount()) + [$]+Alltrim(Str(Reccount() + 3)) + ["]

*!* The following code will erase any previously created temporary excel     *!*
*!* file created by this program                                             *!*
Erase Home() + "VFP_to_Excel.xls"

*!* The following code creates the temporary Excel file that will be used    *!*
*!* for the derived Excel file

llnFields = Afields(llaFields)

For iiField1 = 1 To llnFields
	If iiField1 > 1
		Sum &llaFields(iiField1,1) To me
		If me=0
			Alter Table (lcTableAlias) Drop Column &llaFields(iiField1,1)

		Endif

	Endif
Endfor

Copy To Home() + "VFP_to_Excel" Type Xl5

*!* The following code commences the OLE Automation process.                 *!*
oExcelObject = Createobject('Excel.Application')

*!* The following code opens the "VFP_to_Excel" file that was created by the *!*
*!* "COPY TO" command                                                        *!*
oExcelWorkbook = ;
	oExcelObject.Application.Workbooks.Open(Home() + "VFP_to_Excel")

*!* The following code activates the Worksheet which contains the "COPY TO"  *!*
*!* data                                                                     *!*
oActiveExcelSheet = oExcelWorkbook.Worksheets("VFP_to_Excel").Activate

*!* The following code establishes an Object Reference to the "VFP_to_Excel" *!*
*!* worksheet                                                                *!*
oExcelSheet = oExcelWorkbook.Worksheets("VFP_to_Excel")



Wait Window "Developing Microsoft Excel File..." + Chr(13) + "" + Chr(13) + ;
	"Passing formatting information to Excel." + Chr(13) + "" Nowait

*!* The following code selects row 2 and then inserts a row that will serve  *!*
*!* as a spacer between the field names and the first row of data.           *!*
oExcelSheet.Rows("1:1").Select
oExcelSheet.Rows("1:1").Insert
oExcelSheet.Rows("2:2").Select
oExcelSheet.Rows("2:2").Insert
*!* The following code sets font attributes of row 1 (the field names).      *!*
oExcelSheet.Rows("3:3").Font.Name = "Arial"
oExcelSheet.Rows("3:3").Font.FontStyle = "Bold"
oExcelSheet.Rows("3:3").font.size = 12
oExcelSheet.Rows("3:3").Select

#define xlGeneral                                         1
#define xlBottom                                          -4107
#define xlContext                                         -5002
#define False .F.

With oExcelSheet.Rows("3:3")
	.HorizontalAlignment = xlGeneral
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 45
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
endwith



*!* The following code creates an array using the AFIELDS() Function.  This  *!*
*!* array will provide information pertaining to the data type, width, and   *!*
*!* number of decimal places for each field of the source table.             *!*
lnFields = Afields(laFields)


*!* The following code in the FOR loop will be processed for each field in   *!*
*!* the source table.                                                        *!*
For iField1 = 1 To lnFields



*!* The following line of code uses a Procedure (ColumnLetter) that is    *!*
*!* contained in this program.  This procedure will return a              *!*
*!* corresponding Excel Column (letter) reference that must be used in    *!*
*!* passing any cell or column specific formatting or information to      *!*
*!* Excel.                                                                *!*
	lcColumn    = ColumnLetter(iField1)

*!* The following code creates strings of information in a format         *!*
*!* required by Excel for the processing of commands that are specific to *!*
*!* rows, columns, and/or cells.  For example, in order to SELECT a range *!*
*!* of cells from the third field of a 62 record table, you must bear the *!*
*!* following in mind:                                                    *!*
*!* 1. The top 2 rows consist of the field names and then a spacer row    *!*
*!*    between that and the top data.                                     *!*
*!* 2. On account of the above, the data will start at row 3 and end at   *!*
*!*    row 62 + 2.                                                        *!*
*!* 3. Also on account of the above, any added numeric calculation must   *!*
*!*    be contained at row 62 + 3.                                        *!*
*!* So, in order to pass the cell to contain a calculation for column 3,  *!*
*!* you must pass (with the quotes) "C65"  The range of cells for the     *!*
*!* calculation must be passed (with the quotes) as "C3:C64"  Lastly, the *!*
*!* string to pass to Select column 3 (with the quotes) as "C:C"          *!*
*!* Therefore, this program builds these strings out and stores them to   *!*
*!* variables for Macro Substitution so that the literal string contains  *!*
*!* quotes for passing the information to Excel.                          *!*
	lcCellForCalcuation = ;
		["] + lcColumn + Alltrim(Str(Reccount() + 3)) + ["]
	lcCalculationRange = ;
		lcColumn + [3:] + lcColumn + Alltrim(Str(Reccount() + 2))
	lcColumnExpression = ;
		["] + lcColumn + [:] + lcColumn + ["]

	oExcelSheet.Columns(&lcColumnExpression.).Select

*!* The following code checks for the data type of the source Visual      *!*
*!* FoxPro table by referencing the array created earlier in the program. *!*
*!* Depending upon the data type, a literal format expression is built to *!*
*!* contain quotes and is later passed to Excel by Macro Substituted      *!*
*!* reference (i.e. an ampersand [&] followed by a period [.] terminator).*!*
	Do Case

	Case (laFields(iField1,2)$"C.L")  &&  Is the field data type Character *!*
*!* or Logical                       *!*
		lcFmtExp = ["@"]               &&  Pass Character formatting        *!*

	Case (laFields(iField1,2)$"N.I.Y")&&  Is the field data type Numeric,  *!*
*!* Integer, or Currency             *!*
		If (laFields(iField1,2)$"Y")      &&  If it is Currency             *!*
			lcFmtExp = ["$#,##0.00"]          &&  Pass Currency Formatting   *!*
*!* with a comma separator     *!*
		Else                              &&  If it is other than Currency  *!*
			If laFields(iField1,4) = 0        &&  If the Decimal Width is    *!*
*!* zero                       *!*
				lcFmtExp = ["0"]                  &&  Pass Numeric formatting *!*
*!* with no decimals        *!*
			Else                              &&  Otherwise                  *!*
*!* Build a format string containing the appropriate number   *!*
*!* of decimals                                               *!*
				lcFmtExp = ["0.] + Replicate("0", laFields(iField1,4)) + ["]
			Endif
		Endif

	Case (laFields(iField1,2)$"D.T")  &&  Is the field data type Date or   *!*
*!* DateTime                         *!*
		lcFmtExp = ["mm/dd/yy"]           &&  Pass Date formatting          *!*

	Endcase

*!* The following code passes the derived format expression to Excel      *!*
	oExcelSheet.Columns(&lcColumnExpression.).NumberFormat = &lcFmtExp.

*!* If the field data type is Numeric, Integer, or Currency, will add a   *!*
*!* calculation to the cell immediately below the last row containing     *!*
*!* data.                                                                 *!*
	If (laFields(iField1,2)$"N.I.Y")     &&  Is the field data type Numeric,  *!*
*!* Integer, or Currency             *!*
		oExcelSheet.Range(&lcCellForCalcuation.).Value = ;
			[=SUM(&lcCalculationRange.)]
		If (laFields(iField1,2)$"N.I")       &&  Is the field data type        *!*
*!* Numeric or Integer            *!*
			oExcelSheet.Range(&lcCellForCalcuation.).Select

*!* The following code will format the cell containing the          *!*
*!* calculation to have a comma separator.  This process was        *!*
*!* already done for any event where the field data type was        *!*
*!* currency.                                                       *!*
			lcCalculationFormat = ["#,##0] + Iif(laFields(iField1,4) > 0, [.] +;
				REPLICATE("0", laFields(iField1,4)), []) + ["]
			oExcelSheet.Range(&lcCellForCalcuation.).NumberFormat = ;
				&lcCalculationFormat.
		Endif
	Endif

Endfor

*!* Once the data has been formatted and any calculation have been added,    *!*
*!* the file is ready for the application of final formatting, autofitting   *!*
*!* of cells, and the setting of print attributes.                           *!*
Wait Window "Developing Excel File Report" + Chr(13) + "" + Chr(13) +;
	"setting print area and final formatting" Nowait
oExcelSheet.Cells.Select
oExcelSheet.Cells.EntireColumn.AutoFit
oExcelSheet.Range(&lcTotalRangeExpr.).Select

*!* IMPORTANT NOTE - POSSIBILITY OF PAGE SETUP OBJECT UNAVAILABLE ERRORS IF  *!*
*!*                  THIS PROGRAM IS RUN ON A MACHINE WITH NO REGISTERED     *!*
*!*                  PRINTER DEVICE.                                         *!*
*!*                                                                          *!*
*!* The following code section performs operations that are offered in the   *!*
*!* "Page Setup" user interface of Microsoft Excel.  If this program is run  *!*
*!* from a computer where no printer driver is installed (it can be off line *!*
*!* or online or disconnected, but the printer driver software must be       *!*
*!* installed and a registered printer device must be available as a         *!*
*!* printer), then this section may produce errors than can be ignored.      *!*
With oExcelSheet.PageSetup

*!* This area sets to Title Rows of the spreadsheet that will be printed  *!*
*!* on each page.  Since this example contains the table field names on   *!*
*!* the top row, and then an empty row of cells that was inserted by this *!*
*!* program, then we will set row 1 through row 2 as the title rows.      *!*
	.PrintTitleRows = "$1:$2"
*!* Setting Title Columns would work in similar fashion to Setting Title  *!*
*!* Rows.  Here, however, the column letter would be used in syntax       *!*
*!* similar to the above example.  Here, however, a null string is        *!*
*!* passed.  This example simply shows that the option is available.      *!*
	.PrintTitleColumns = ""
	.PrintArea = &lcTotalPrintArea.      &&  The print area is set            *!*
	.LeftHeader = lcExcelFile            &&  The left header is populated     *!*
*!* with the file name               *!*
	.CenterHeader = ""                   && The Center Header and the ...     *!*
	.RightHeader = ""                    && Right Header are left blank       *!*
*!* The below referenced "cStamp" is a procedure contained in this        *!*
*!* program.  It builds out a string which contains the computer system   *!*
*!* date and time on which the resulting Excel file was created.          *!*
	.LeftFooter = cStamp()               &&  Left Footer is populated with    *!*
*!* cStamp returned string           *!*
	.RightFooter = "Page &P of &N"       &&  Right Footer is populated with   *!*
*!* Page _ of _                      *!*
	.CenterHorizontally = .T.            &&  Print area centered horizontally *!*
	.CenterVertically = .F.              &&  Print area not centered          *!*
*!* vertically                       *!*
	.Orientation = lnPrintOrientation    &&  The parameter derived print      *!*
*!* orientation is set               *!*
	.Papersize = lnPaperSize             &&  The parameter derived paper size *!*
*!* is set                           *!*
	.Zoom = .F.                          &&  The "Adjust to" scaling is       *!*
*!* suppressed                       *!*
	.FitToPagesWide = 1                  &&  The scaling of "Fit To" and 1    *!*
*!* page wide is selected            *!*
	.FitToPagesTall = 99                 &&  The scaling of "Fit To" and 99   *!*
*!* pages tall is selected           *!*
*!* NOTE: This will not cause a      *!*
*!* small file to span 99 pages, but *!*
*!* it would cause a smaller file to *!*
*!* be compressed.                   *!*

Endwith

*!* The following code selects the upper left cell of the derived Excel      *!*
*!* file                                                                     *!*
oExcelSheet.Range("A1").Select

*!* The following code saves the derived Excel file to its assigned name and *!*
*!* location                                                                 *!*
oExcelWorkbook.SaveAs(lcExcelFile)

=Messagebox("Your Excel File is Ready!",64)

*!* The following code turns the OLE instance of Excel visible               *!*
oExcelObject.Visible = .T.

*!****************************************************************************!*
*!*                       End of program VFPExcel.prg                        *!*
*!****************************************************************************!*


*!****************************************************************************!*
*!* Beginning of PROCEDURE ColumnLetter                                      *!*
*!* This procedure derives a letter reference based on a numeric value.  It  *!*
*!* uses the basis of the ASCII Value of the upper case letters A to Z (65   *!*
*!* through 90) to return the proper letter (or letter combination) for a    *!*
*!* provided numeric value.                                                  *!*
*!****************************************************************************!*

Procedure ColumnLetter

Parameter lnColumnNumber

lnFirstValue = Int(lnColumnNumber/27)
lcFirstLetter = Iif(lnFirstValue=0,"",Chr(64+lnFirstValue))
lcSecondLetter = Chr(64+Mod(lnColumnNumber,26))

Return lcFirstLetter + lcSecondLetter

*!****************************************************************************!*
*!*                      End of procedure ColumnLetter                       *!*
*!****************************************************************************!*


*!****************************************************************************!*
*!* Beginning of PROCEDURE cStamp                                            *!*
*!* This procedure derives a text representation of the system date and time *!*
*!* in the form of:                                                          *!*
*!* 01/01/2000 11:59:00 would be rendered as:                                *!*
*!* Saturday, January 1, 2000 @ 11:59 am                                     *!*
*!****************************************************************************!*

Procedure cStamp

cDTString1 = Cdow(Date()) + ", "
cDTString2 = Cmonth(Date()) + " "
cDTString3 = Alltrim(Str(Day(Date()))) + ", "
cDTString4 = Alltrim(Str(Year(Date()))) + " @ "
cDTString5 = Iif(Val(Left(Time(), 2)) > 12, ;
	ALLTRIM(Str(Val(Left(Time(), 2)) - 12)) +;
	SUBSTR(Time(), 3, 3), Left(Time(), 5))
cDTString6 = Iif(Val(Left(Time(),2))=>12,"pm","am")
cDTString  = "Created on " + cDTString1 + ;
	cDTString2 + cDTString3 + cDTString4 + cDTString5 + cDTString6

Return cDTString

*!****************************************************************************!*
*!*                    End of procedure cStamp                               *!*
*!****************************************************************************!*
**********************
PROCEDURE Dbf2XlsExample8
**********************
Local oExcel
oExcel = Createobject("Excel.Application")
With oExcel
 .WorkBooks.Add
 .Visible = .T.
 VFP2Excel(_samples+'data\testdata.dbc',;
 'select * from customer',;
 .ActiveWorkBook.ActiveSheet.Range('A1'))
Endwith
**************
Function VFP2Excel
**************
 Lparameters tcDataSource, tcSQL, toRange
 Local loConn As AdoDB.Connection, loRS As AdoDB.Recordset, ix
 
 loConn = Createobject("Adodb.connection")
 loConn.ConnectionString = "Provider=VFPOLEDB;Data Source="+m.tcDataSource
 loConn.Open()
 loRS = loConn.Execute(m.tcSQL)

 For ix=1 To loRS.Fields.Count
 	toRange.Offset(0,m.ix-1).Value = Proper(loRS.Fields(m.ix-1).Name)
 	toRange.Offset(0,m.ix-1).Font.Bold = .T.
 Endfor
 toRange.Offset(1,0).CopyFromRecordSet( loRS )
 loRS.Close
 loConn.Close
Endfunc

*!*	If you would want to use paste  method instead, then be careful about DataToClip(). 
*!*	It places an extra column at the end. I suggest instead of DataToClip(), simply use a tab delimited file. ie:

**********************
PROCEDURE Dbf2XlsExample8
**********************
USE (_samples+'data\Customer')
SET SAFETY off
LOCAL lcTemp, loExcel
** Mimic but do not prefer DataToClip()
lcTemp = FORCEPATH(Sys(2015)+'.tmp', SYS(2023))
Copy To (m.lcTemp) Type Csv For .F.
_Cliptext = Proper(Chrtran(Filetostr(m.lcTemp),',',Chr(9)))
Copy To (m.lcTemp) Type Delimited With "" With Tab
_Cliptext = _Cliptext + Filetostr(m.lcTemp)
Erase (m.lcTemp)

oExcel = Createobject('Excel.Application')
With oExcel
 .Workbooks.Add
 .Visible = .T.
 .Activeworkbook.Activesheet.Range('A1').PasteSpecial()
Endwith

**********************
PROCEDURE Dbf2XlsExample9
**********************
*!*	<< Commands >> 	<< Notes >>
  	 
oExcel = CreateObject("Excel.Application")  	&& Create Object
oSheet = oExcel.Activesheet 					&& Create Object
  	 
oExcel.Sheets.Add 								&& Add a new worksheet
oExcel.Workbooks.Add 							&& Add a new workbook
oExcel.Range("A2:A3").Verticalalignment = 2 	 
oExcel.Range("H2:N2").HorizontalAlignment = 3 	&& Alignment, Center
oExcel.Range(oExcel.Cells(mrow,mcol), oExcel.Cells(mrow,mcol)).HorizontalAlignment = 3 	&& Alignment, Center
oExcel.Range("H2:N2").HorizontalAlignment = 2 	&& Alignment, Left
oExcel.Cells(3,4).Horizontalalignment = 1 			&& Alignment, Right
oExcel.Columns("A:AD").Autofit 					&& Autofit
oExcel.Activewindow.Displayworkbooktabs = -1 	&& Book Tab
oExcel.Activeworkbook.Close() 						&& Close
oExcel.Cells(2,8).Interior.Colorindex = 6 			&& Color, Background
oExcel.Columns("C").ColumnWidth = 15 			&& Column Width
oExcel.Columns("C:H").ColumnWidth = 15 			&& Column Width
oExcel.Sheets("sheet1").Delete 					&& Delete Sheet
oExcel.Displayalerts = 0   							&&& or -1 	Displayalerts Off
oExcel.Cells(1,1).Font.Bold = 1 						&& Font
oExcel.Cells(1,1).Font.Colorindex = 55 				&& Font Color
oExcel.Cells(1,1).Font.Size = 16 					&& Font Size
oExcel.Columns("B:G").NumberFormatLocal = "0.00_ " 					&& Format : 2 Decimals
oExcel.Columns("A:A").NumberFormatLocal = "[$-404]e/m/d;@" 			&& Format : Year
oExcel.Activewindow.Freezepanes = -1 					&& Freezepanes
oExcel.Activewindow.Displaygridlines = -1 				&& Gridline, Display
oExcel.Activewindow.Displaygridlines = 0 				&& Gridline, Hide
oExcel.Range("B1").Entirecolumn.Insert 				&& Insert Column
oExcel.Range("2:20").Entirerow.Insert 					&& Insert Row
oExcel.Range("H2:N2").Borders.Linestyle = 1 			&& Linestyle
oExcel.Range("A2:B3").Merge 							&& Merge
oExcel.Range(oExcel.Cells(mrow,mcol), oExcel.Cells(mrow,mcol)).Merge 	&& Merge
oExcel.Activesheet.Name = "ABC" 					&& Name an Active Sheet
oExcel.Activeworkbook.Open("ABC.xls") 			&& Open
oExcel.Quit() 	&& Quit
#Define XLDBF 8 										&& Save Excel file as DBF file - step 1
oExcel.ActiveWorkbook.Saveas("ABC.dbf", XLDBF) 		&& Save Excel file as DBF file - step 2
oExcel.Activeworkbook.Saveas("ABC.xls") 				&& Saveas
oExcel.Cells("A1").Select 								&& Select
oExcel.Columns("B:E").Select 							&& Select
oExcel.range("A9").Select 								&& Select
oExcel.Selection.Copy 									&& Select and Copy
oExcel.Selection.Cut 									&& Select and Cut
oExcel.Selection.Paste 									&& Select and Paste
oExcel.Sheets("sheet1").Select 						&& Select Sheet
oExcel.Cells(1,1).Value = "ABC" 						&& Value, Assign a
oExcel.Cells(mrow,mcol).Value = "ABC" 				&& Value, Assign a
mValue=oExcel.Cells(mrow,mcol).Value 				&& Value, Return a
oExcel.Visible = -1     									&& Workbook Visible
oExcel.Visible = 0 										&& Workbook Invisible
oExcel.Activewindow.DisplayZeros = .F. 					&& Zero Values, Hide All
oExcel.Activewindow.Zoom = 70 						&& Zoom

Use ABC.dbf 											&& Arrange data for chart
Select fieldname1, fieldname2, fieldname3 from ABC.dbf Into Cursor crsData 		&& Arrange data for chart
Copy To (ABC.txt) Type Delimited With Tab 				&& Arrange data for chart
_Cliptext = "fieldname1"+CHR(9)+"fieldname2"+CHR(9)+"fieldname3"+CHR(13)+Filetostr(ABC.txt) 	&& Arrange data for chart
Erase (ABC.txt) 											&& Arrange data for chart
	
With oSheet 								&& Start of outer loop
    .Range('B2').PasteSpecial 				&& Paste _Cliptext
    oRange = .Application.Selection 			&& Chart Object Creation
	With oRange 	
	    oChartRange   = .Range(.Cells(0,1), .Cells(.Rows.Count-1, 3))  	&& Chart Range Creation
	    oLabelsRange = .Range(.Cells(0,0), .Cells(.Rows.Count-1, 0))    	&& Chart Label Creation
	Endwith 	 
	  	 

	#Define     xlColumnStacked 52 	&& Define Chart Type

	#Define     xlCategory 1 				&&	Define X Axis
	#Define     xlValue 2 				&& Define Y Axis
	
	.ChartObjects.Add(2, 2, 717, 245)     && Add new chart and specify its position and area
	With .ChartObjects(1).Chart 			&& Name chart object as 1
	    .SetSourceData(oChartRange) 	
	    .hastitle = .T. 	
	    .haslegend = .T. 	
	    .legend.position = 3 	&& or 1 or 2 or 4 or 5
	    .ChartTitle.Caption = "ChartTitle" 	&& "ChartTitle" or memory variable
	    .ChartType = xlLine 					&& or xlColumns or xlColumnClustered or xlPie …
	    .SeriesCollection(1).XValues = oLabelsRange 	&& Label (1st field of selected fields) of Y axis
	    .SeriesCollection(3).ApplyCustomType( xlColumnClustered ) 	&& Show bar(3rd field of selected fields) in line-chart
	    .Axes(xlCategory).HasTitle = .T. 	
	    .Axes(xlCategory).AxisTitle.caption = "Date" 	&& Title of X axis, "Date" or memory variable
	    .Axes(xlValue).HasTitle = .T. 	
	    .Axes(xlValue).AxisTitle.caption = "$$$" 	&& Title of Y axis, "$$$" or memory variable
	    .plotarea.width = 660 	&& Optional
	    .plotarea.height = 210 	&& Optional
	    .plotarea.left = 43 		&& Optional
	    .plotarea.top = 0 			&& Optional
	Endwith 	
Endwith 	&& Finish of outer loop
	
	
***  Re above, more solutions are available from Excel Macro *** 	
	
oWS = CreateObject("Wscript.Shell") 	&& Create Object
oWS.run("c:\ABC.doc") 				&& Open file
oWS.run("c:\ABC.pps") 	&& Open file
oWS.run("c:\ABC.ppt") 	&& Open file
oWS.run("c:\ABC.jpg") 	&& Open file
oWS.run("c:\ABC.pdf") 	&& Open file

*!*	    Edited by R C C Friday, May 22, 2009 8:44 AM 
*********************
PROCEDURE DefineValuesXLS  && Define Chart Type
*********************
#Define xlArea 1 				
#Define xlColumns 2 	
#Define xlLine 4 	
#Define xlPie 5 	
#Define xlColumnClustered 51 	
#Define xlColumnStacked 52 	
#Define xlColumnStacked100 53 	
#Define xl3DColumnClustered 54 	
#Define xl3DColumnStacked 55 	
#Define xl3DColumnStacked100 56 	
#Define xlBarClustered 57 	
#Define xlBarStacked 58 	
#Define xlBarStacked100 59 	
#Define xl3DBarClustered 60 	
#Define xl3DBarStacked 61 	
#Define xl3DBarStacked100 62 	
#Define xlLineStacked 63 	
#Define xlLineStacked100 64 	
#Define xlLineMarkers 65 	
#Define xlLineMarkersStacked 66 	
#Define xlLineMarkersStacked100 67 	
#Define xlPieOfPie 68 	
#Define xlPieExploded 69 	
#Define xl3DPieExploded 70 	
#Define xlBarOfPie 71 	
#Define xlXYScatterSmooth 72 	
#Define xlXYScatterSmoothNoMarkers 73 	
#Define xlXYScatterLines 74 	
#Define xlXYScatterLinesNoMarkers 75 	
#Define xlAreaStacked 76 	
#Define xlAreaStacked100 77 	
#Define xl3DAreaStacked 78 	
#Define xl3DAreaStacked100 79 	
#Define xlDoughnutExploded 80 	
#Define xlRadarMarkers 81 	
#Define xlRadarFilled 82 	
#Define xlSurface 83 	
#Define xlSurfaceWireframe 84 
#Define xlSurfaceTopView 85 	
#Define xlSurfaceTopViewWireframe 
#Define xlBubble 15 	
#Define xlBubble3DEffect 87 	
#Define xlStockHLC 88 	
#Define xlStockOHLC 89 	
#Define xlStockVHLC 90 	
#Define xlStockVOHLC 91 	
#Define xlCylinderColClustered 92 	
#Define xlCylinderColStacked 93 	
#Define xlCylinderColStacked100 94 	
#Define xlCylinderBarClustered 95 	
#Define xlCylinderBarStacked 96 	
#Define xlCylinderBarStacked100 97 	
#Define xlCylinderCol 98 	
#Define xlConeColClustered 99 	
#Define xlConeColStacked  100 	
#Define xlConeBarClustered 102 	
#Define xlConeBarStacked 103 	
#Define xlConeCol 105 	
#Define xlPyramidColClustered 106 
#Define xlPyramidColStacked 107
#Define xlPyramidBarClustered 109
#Define xlPyramidBarStacked 110
#Define xlPyramidCol 112 	
#Define xl3DColumn 0xFFFFEFFC
#Define xl3DLine 0xFFFFEFFB
#Define xl3DPie 0xFFFFEFFA
#Define xlXYScatter 0xFFFFEFB7
#Define xl3DArea 0xFFFFEFFE 	
#Define xlDoughnut 0xFFFFEFE8
#Define xlRadar 0xFFFFEFC9 	

***********************
PROCEDURE  Dbf2XlsExample10
***********************
Use Northwind\Customers
Set Point To "."
Local lcFile
lcFile = GetEnv("USERPROFILE")+"\Desktop\Customers.xls"
If File(m.lcFile)
   Erase (m.lcFile)
EndIf
Local lcRows, lnField, luValue, lcStyle, lcData
lcRows = ""
Scan
   lcRows = m.lcRows + "<Row>"
   For lnField = 1 to Fcount()
       luValue = Evaluate(Field(m.lnField))
       lcStyle = Iif(Recno()%2==0,"even","odd")
       Do case
       Case InList(Vartype(m.luValue),"C")
          lcData = ;
              [<Data ss:Type="String">]+Strconv(Alltrim(m.luValue),9)+[</Data>]
       Case InList(Vartype(m.luValue),"N")
          lcData = ;
              [<Data ss:Type="Number">]+Transform(Nvl(m.luValue,0))+[</Data]
       Otherwise 
          Loop
       EndCase
      lcRows = m.lcRows + ;
          [<Cell ss:StyleID="]+m.lcStyle+[">]+m.lcData+[</Cell>]
   EndFor 
   lcRows = m.lcRows + "</Row>"
endscan

Local lcXML
Text to m.lcXML Noshow Textmerge
<?xml version="1.0"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
  <Styles>
    <Style ss:ID="even">
      <Font ss:FontName="Tahoma" ss:Size="13" ss:Bold="1" />
    </Style>
    <Style ss:ID="odd">
      <Font ss:FontName="Tahoma" ss:Size="13" ss:Color="red" />
    </Style>
  </Styles>
  <Worksheet ss:Name="Sheet1">
    <Table><<m.lcRows>></Table>
  </Worksheet>
</Workbook>
EndText

StrToFile(m.lcXml,m.lcFile)