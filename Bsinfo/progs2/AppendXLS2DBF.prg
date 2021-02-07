********************************
*!* Simple Sample Usage
********************************
*!*	SELECT 0
*!*	USE P0012011!CbdMctas ALIAS CTAS2011
*!*	COPY TO d:\o-negocios\update\PCGA_Equi  TYPE FOX2X FOR .F.
USE  d:\o-negocios\interface\cia_01\modelo-trab ALIAS TRABAJ

DIMENSION aWrkSht(1), aCols(1)
m.lcXlsFile = GETFILE("Excel:XLS,XLSX,XLSB,XLSM")
IF FILE(m.lcXlsFile)
	CLEAR
	SET STEP ON 
	?AWorkSheets(@aWrkSht,m.lcXlsFile,.T.)
	?AWorkSheetColumns(@aCols,m.lcXlsFile,"trabajadores")
*!*		AppendFromExcel(m.lcXlsFile, "Sheet1", "MyTable", "column1,column2,column3", "Recnum Is Not Null", "field1,field2,field3", "field1 > 14000")
	AppendFromExcel(m.lcXlsFile, "trabajadores", "TRABAJ", "","1=1", "", ".T.")
	SELECT TRABAJ
	GO TOP IN "TRABAJ"
	BROWSE LAST NOWAIT
ENDIF

