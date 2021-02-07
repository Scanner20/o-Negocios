function CopyToDBF
	Parameters sTable	
	If Select(sTable) = 0
		Return
	EndIf

	If RecCount(sTable) = 0	
		Return
	ENDIF
	WshShell = CreateObject("WScript.shell") 
	strDesktop = wshShell.SpecialFolders("Desktop")
	sNomFile = PutFile('Guardar como :',strDesktop+'\'+sTable,'Xls;Ods;Dbf;Txt')
	nchar = LEN(sNomFile)
	vaqui = 0
	FOR e=1 TO nchar
		IF SUBSTR(sNomFile,e,1)=='\'
			vaqui = e
		endif
	NEXT e
	mirutalt = LEFT(sNomFile,vaqui)
	mifle = RIGHT(sNomFile,(nchar-vaqui))
	mixy = LEN(mifle)
	
	mifilealt = STRTRAN(mifle,'.XLS','')	
	If Empty(sNomFile)
		Return
	EndIf
	Select &sTable
	Do Case
		Case Right(sNomFile,3) == 'DBF'
			Copy To (sNomFile) Fox2x
		Case Right(sNomFile,3) == 'XLS'
		LOCAL mierrorx,mierroro
		STORE 0 TO mierrorx,mierroro
		TRY 
			oExcel = Createobject("Excel.application")
		CATCH TO mierror
			mierrorx = mierror.errorno
		FINALLY
		
		ENDTRY
			IF mierrorx = 1733
				MESSAGEBOX("No se encontró aplicación Excel instalado, Se importara a aplicacion alternativa: OpenOffice.",32,"Proceso detenido.")
				=ExporToCalc(sTable,mirutalt,mifilealt)
				return
			ENDIF
				lnTotal = Reccount()
				IF lnTotal < 66536
					sNomFile = SubStr(sNomFile,1,Len(sNomFile)-4)
					LOCAL elerror
					elerror = 0
					try
					Export To (sNomFile) Xls 
					CATCH TO unerror
						elerror = unerror.errorno
					FINALLY
					
					ENDTRY
					IF elerror != 0
						MESSAGEBOX("No se puede guardar el archivo, verifique que no este en uso.",48,"proceso detenido")
						RETURN .t.
					endif
					sNomFile = sNomFile + '.XLS'
					COPY TO '"' + sNomFile+'"' TYPE xl5
					try
					loExcel=CREATEOBJECT("Excel.application")
					loExcel.APPLICATION.VISIBLE=.T.
					loExcel.APPLICATION.workbooks.OPEN(sNomFile)
					loExcel.Cells.SELECT
					WITH loExcel.SELECTION.FONT
					  .NAME = "Arial"
					  .SIZE = 8
					ENDWITH
					loExcel.Cells.EntireColumn.AUTOFIT
					loExcel.RANGE("A1").SELECT
					loExcel.ActiveWorkbook.SAVE
					loExcel = NULL
					CATCH
					FINALLY
					endtry
				else
					With oExcel
						.Visible = .T.
						oMasterWorkBook = .workbooks.Add 
						lnMaxRows = .ActiveWorkBook.ActiveSheet.Rows.Count 
						lnNeededSheets = Ceiling( lnTotal / (lnMaxRows - 1) ) 
						lnCurrentSheetCount = .sheets.Count
						If lnNeededSheets > lnCurrentSheetCount
							.sheets.Add(,.sheets(lnCurrentSheetCount),;
							lnNeededSheets - lnCurrentSheetCount) 
						Endif
					Endwith
					With oMasterWorkBook
						For ix = 1 To lnNeededSheets
							.sheets.Item(ix).Name = "Page "+Padl(ix,3,"0")
						Endfor
							lcExportName = Sys(5)+Curdir()+Sys(2015)+".dbf"
						For ix = 1 To lnNeededSheets
							lnStart = ( ix - 1 ) * (lnMaxRows-1) + 1
							Copy To (lcExportName) ;
							for Between(Recno(),lnStart,lnStart+lnMaxRows-2) ;
							type Fox2x
							oSourceWorkBook = oExcel.workbooks.Open(lcExportName)
							.WorkSheets(ix).Activate
							oSourceWorkBook.WorkSheets(1).UsedRange.Copy(;
							.WorkSheets(ix).Range('A1'))
							oSourceWorkBook.Close(.F.) 
							Erase (lcExportName)
						Endfor
						.WorkSheets(1).Activate	
					ENDWITH				
					oExcel.Cells.SELECT
					oExcel.Cells.EntireColumn.AUTOFIT
					WITH oExcel.SELECTION.FONT
					  .NAME = "Arial"
					  .SIZE = 8
					ENDWITH
					DELETE FILE (sNomFile)
					nFileFormat = oExcel.WorkBooks(1).FileFormat
					oMasterWorkBook.SaveAs(sNomFile,nFileFormat)
				endif
		Case Right(sNomFile,3) == 'TXT'
			Copy To (sNomFile) Type Sdf 
	EndCase
Return

FUNCTION ExporToCalc_inv(cCursor, cDestino, cFileSave)
	TRY
		  LOCAL oManager, oDesktop, oDoc, oSheet, oCell, oRow, FileURL,minerr
		  LOCAL ARRAY laPropertyValue[1]
		  STORE 0 TO minerr
		  cWarning = "Exportar a OpenOffice.org Calc"
		  IF EMPTY(cCursor)
		cCursor = ALIAS()
		  ENDIF
		  IF TYPE('cCursor') # 'C' 
			MESSAGEBOX("Parametros Invalidos",16,cWarning)
			RETURN .F.
		  ENDIF
		  IF !USED(cCursor)
		  	MESSAGEBOX("Archivo : "+cCursor+ " no esta en uso.",31,cWarning)
		  	RETURN .F.
		  endif
		  lColNum = AFIELDS(lColName,cCursor)
		  EXPORT TO (cDestino + cFileSave) TYPE XL5
		  *+ [.xls] 
		  oManager = CREATEOBJECT("com.sun.star.ServiceManager.1")
	CATCH TO nerror
		minerr = nerror.errorno
	FINALLY
	
	endtry
		IF minerr != 0
			MESSAGEBOX("Se encontró errores en el proceso, puede que no tenga instalado el OpenOffice. Revise",32,"Error no se encontró aplicación")
			return
		endif
		IF VARTYPE(oManager, .T.) # "O"
			MESSAGEBOX("OpenOffice.org Calc no esta instalado en su computador.",64,cWarning)
			RETURN .F.
		 ENDIF
		oDesktop = oManager.createInstance("com.sun.star.frame.Desktop")
		COMARRAY(oDesktop, 10)
		oReflection = oManager.createInstance("com.sun.star.reflection.CoreReflection")
		COMARRAY(oReflection, 10)
		laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
		laPropertyValue[1].NAME = "ReadOnly"
		laPropertyValue[1].VALUE= .F.
		FileURL = ConvertToURL(cDestino + cFileSave + [.xls])
		oDoc = oDesktop.loadComponentFromURL(FileURL , "_blank", 0, @laPropertyValue)
		oSheet = oDoc.getSheets.getByIndex(0)
		FOR i = 1 TO lColNum
			oColumn = oSheet.getColumns.getByIndex(i)
			oColumn.setPropertyValue("OptimalWidth", .T.)
			oCell = oSheet.getCellByPosition( i-1, 0 )
			oDoc.CurrentController.SELECT(oCell)
			WITH oDoc.CurrentSelection
				.CellBackColor = RGB(200,200,200)
				*.getCell
				.CharColor = RGB(255,0,0)
				.CharHeight = 10
				.CharPosture = 0
				.CharShadowed = .F.
				.FormulaLocal = lColName[i,1]
				.HoriJustify = 2
				.ParaAdjust = 3
				.ParaLastLineAdjust = 3
			ENDWITH
		ENDFOR
		oCell = oSheet.getCellByPosition( 0, 0 )
		oDoc.CurrentController.SELECT(oCell)
		laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
		laPropertyValue[1].NAME = "Overwrite"
		laPropertyValue[1].VALUE = .T.
		oDoc.STORE()
ENDFUNC
