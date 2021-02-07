PUBLIC loExcel   && to keep it from being destroyed and closing the cursors
LOCAL lnTime, lnWb, lnSh, lnRow, lnCol
loExcel = NEWOBJECT("VFPxWorkbookXLSX", "VFPxWorkbookXLSX.vcx")
loExcel.Demo()
*-*	loExcel.DeleteAllWorkbooks()

*-*	loExcel.SaveTableToWorkbook(HOME(2) + "Data\customer", "ExcelDemo2.xlsx", .T., .F.)
*-*	loExcel.SaveTableToWorkbook(HOME(2) + "Data\employee", "ExcelDemo2.xlsx", .T., .F.)
*-*	loExcel.SaveTableToWorkbook(HOME(2) + "Data\products", "ExcelDemo2.xlsx", .T., .T.)
*-*	loExcel.DeleteAllWorkbooks()

*-*	SET DEBUGOUT TO "TimeTest.txt"
*-*	lnWb = loExcel.CreateWorkbook("TimeTest1.xlsx")
*-*	IF lnWb > 0
*-*		DEBUGOUT "Writing First Time Test Workbook"
*-*	 	lnSh = loExcel.AddSheet(lnWb, "Test Sheet 1")
*-*	 	lnTime = SECONDS()
*-*		FOR lnRow=1 TO 100000
*-*			FOR lnCol=1 TO 10
*-*				loExcel.SetCellValue(lnWb, lnSh, lnRow, lnCol, SYS(2015))
*-*			ENDFOR
*-*		ENDFOR
*-*		DEBUGOUT "SetCellValue:", SECONDS()-lnTime
*-*	 	loExcel.SaveWorkbook(lnWb)
*-*		DEBUGOUT "SaveWorkbook:", SECONDS()-lnTime
*-*	ENDIF
*-*	loExcel.DeleteAllWorkbooks()

*-*	lnWb = loExcel.CreateWorkbook("TimeTest2.xlsx")
*-*	IF lnWb > 0
*-*		DEBUGOUT "Writing Second Time Test Workbook"
*-*	 	lnSh = loExcel.AddSheet(lnWb, "Test Sheet 1")
*-*	 	lnTime = SECONDS()
*-*		FOR lnRow=1 TO 100000
*-*			FOR lnCol=1 TO 10
*-*				loExcel.SetCellValue(lnWb, lnSh, lnRow, lnCol, lnRow*lnCol)
*-*			ENDFOR
*-*		ENDFOR
*-*		DEBUGOUT "SetCellValue:", SECONDS()-lnTime
*-*		loExcel.SaveWorkbook(lnWb)
*-*		DEBUGOUT "SaveWorkbook:", SECONDS()-lnTime
*-*	ENDIF
*-*	SET DEBUGOUT TO