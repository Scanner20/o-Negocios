PUBLIC loExcel   && to keep it from being destroyed and closing the cursors
LOCAL lcFile
lcFile = GETFILE("xlsx", "Workbook", "Load", 0, "Select Workbook to load into Class")
IF !EMPTY(lcFile)
	loExcel = NEWOBJECT("VFPxWorkbookXLSX", "VFPxWorkbookXLSX.vcx")
	loExcel.OpenXlsxWorkbook(lcFile)
	loExcel.SaveWorkbookAs(1, ADDBS(JUSTPATH(lcFile))+JUSTSTEM(lcFile)+"2.xlsx")
ENDIF