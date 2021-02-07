PARAMETERS PsTable_Str,PsExcelFile,PsSheet,PsColumnsXLS,PsFiltroXls,PsFieldTbl,PsFiltroTbl,PlNoHeaderRow,PlZapTable

IF VARTYPE(PsTable_Str)<>'C'
	PsTable_Str	=	''
ENDIF
IF VARTYPE(PsExcelFile)<>'C'
	PsExcelFile	=	''
ENDIF
IF VARTYPE(PsSheet)<>'C'
	PsSheet	=	'Sheet1'
ENDIF
IF VARTYPE(PsColumnsXLS)<>'C'
	PsColumnsXLS	=	''
ENDIF
IF VARTYPE(PsFiltroXls)<>'C'
	PsFiltroXls	=	IIF(EMPTY(PsFiltroXls),'.T.',PsFiltroXls)
ENDIF
IF VARTYPE(PsFieldTbl)<>'C'
	PsFieldTbl	=	''
ENDIF
IF VARTYPE(PsFiltroTbl)<>'C'
	PsFiltroTbl	=	IIF(EMPTY(PsFiltroTbl),'.T.',PsFiltroTbl)
ENDIF
IF VARTYPE(PlNoHeaderRow)<>'L'
	PlNoHeaderRow = '.T.'
ENDIF

IF VARTYPE(PlZapTable)<>'L'
	PlZapTable = '.F.'
ENDIF

********************************
*!* Simple Sample Usage
********************************
*!*	SELECT 0
*!*	USE P0012011!CbdMctas ALIAS CTAS2011
*!*	COPY TO d:\o-negocios\update\PCGA_Equi  TYPE FOX2X FOR .F.
*!*	USE d:\o-negocios\interface\modelo-trab ALIAS PCGA_RIO
*!*	USE d:\o-negocios\interface\Libro_mayor ALIAS LMayor
USE (PsTable_Str) ALIAS Tbl_Str EXCLUSIVE
IF PlZapTable
	ZAP IN Tbl_Str
ENDIF
DIMENSION aWrkSht(1), aCols(1)
m.lcXlsFile = IIF(EMPTY(PsExcelFile) OR !FILE(PsExcelFile), GETFILE("Excel:XLS,XLSX,XLSB,XLSM"),PsExcelFile)
IF FILE(m.lcXlsFile)
	CLEAR
	?AWorkSheets(@aWrkSht,m.lcXlsFile,.T.)
	?AWorkSheetColumns(@aCols,m.lcXlsFile,PsSheet)
*!*		AppendFromExcel(m.lcXlsFile, "Sheet1", "MyTable", "column1,column2,column3", "Recnum Is Not Null", "field1,field2,field3", "field1 > 14000")
	AppendFromExcel(m.lcXlsFile, PsSheet, "Tbl_Str", "","1=1", "", ".T.")
	SELECT Tbl_Str
	Locate
	BROWSE LAST NOWAIT
ENDIF
*!*	CopyToExcel("D:\o-Negocios\update\plan_contable_equitransport_2011.xls", "plancuentas-2011-o-negocios", "PCGA_Equi") && try xls, xlsb, and xlsm as well
USE IN Tbl_Str