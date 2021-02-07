**********************************
FUNCTION AppendFromExcel(tcXLSFile, tcSheet, tvWorkarea, tcExcelFieldList, tcExcelWhereExpr, tcTableFieldList, tcTableForExpr, tlNoHeaderRow)
	**********************************
	* PARAMETER Information
	* tcXLSFile := a string specifying an excel file (*.xls, *.xlsx, *.xlsm, *.xlsb) on disk
	* tcSheet := a string specifying the name of a worksheet within the excel workbook (can also be a range Sheet1$A1:C20 for instance)
	* tvWorkarea [optional] := the Alias, Work Area, or File Name of the table you want the worksheet result set appended to (default is currently selected Alias)
	* tcExcelFieldList [optional] := a comma delimited list of columns you want from the worksheet (default is '*' - all columns)
	* tcExcelWhereExpr [optional] := a valid SQL Where clause to be used when querying the worksheet (default is '1=1')
	* tcTableFieldList [optional] :=  a comma delimited list of fields you want the worksheet result set inserted into (default is '*' - all fields)
	* tcTableForExpr [optional] := a valid VFP Where clause to be used when querying the worksheet result set (cursor) (default is '.T.')
	* tlNoHeaderRow [optional] := pass .T. if the worksheet does not contain a header row, .F. is the default which specifies that a header row does exist
	*
	* RETURN Information
	* returns numeric, the number of records inserted into tvWorkArea
	*
	* Provider Information
	* the default provider being used in the SQLStringConnect function can be downloaded and installed from:
	* http://www.microsoft.com/downloads/details.aspx?FamilyID=7554F536-8C28-4598-9B72-EF94E038C891&displaylang=en
	**********************************
	LOCAL lnSelect, laErr[1], laTableFields[1], laExcelFields[1], lnFieldCounter
	Local lcSQLAlias, lnResult, lcInsertValues, lcFieldList, lcNvlFieldList
	Local lcFieldType, lcExcelFieldType, lcNvlFieldName, lcTempAlias, loExc, lnReturn
	Local lcHeaderRow, llOpenedtvWorkArea
	
	m.lnSelect = SELECT(0)
	m.lnReturn = 0
	IF NOT FILE(m.tcXLSFile)
		ERROR 1, m.tcXLSFile
	ENDIF

	IF !USED(m.tvWorkarea) AND TYPE("m.tvWorkArea") = "C" AND FILE(DEFAULTEXT(m.tvWorkarea,"DBF"))
		SELECT 0
		USE (DEFAULTEXT(m.tvWorkarea,"DBF")) SHARED AGAIN
		m.tvWorkarea = ALIAS()
		m.llOpenedtvWorkArea = .T.
	ELSE
		IF !USED(m.tvWorkarea)
			m.tvWorkarea = ALIAS()
		ENDIF
	ENDIF
	IF TYPE("m.tvWorkArea") = "N"
		m.tvWorkArea = ALIAS(m.tvWorkArea)
	ENDIF
	
	m.tcSheet = ALLTRIM(EVL(m.tcSheet,"Sheet1$"))
	IF AT("$",m.tcSheet) = 0
		m.tcSheet = m.tcSheet + "$"
	ENDIF
	m.tcExcelFieldList = EVL(m.tcExcelFieldList,"*")
	m.tcExcelWhereExpr = EVL(m.tcExcelWhereExpr,"1=1")
	m.tcTableFieldList = EVL(m.tcTableFieldList,"*")
	m.tcTableForExpr = EVL(m.tcTableForExpr,".T.")
	m.lcSQLAlias = SYS(2015)
	m.lcTempAlias = SYS(2015)
	m.lnSQL = 0
	m.lcHeaderRow = IIF(EMPTY(m.tlNoHeaderRow), "Yes", "No")
	TRY
		SELECT (m.tvWorkarea)
		
*!*			m.lnSQL = SQLSTRINGCONNECT([Provider=Microsoft.ACE.OLEDB.12.0;Data Source="] + m.tcXLSFile + [";Extended Properties="Excel 12.0 Xml;HDR=] + m.lcHeaderRow + [;";])

		*!* Alternate using DSN that comes with Office install (MSDASQL = OLEDB wrapper for ODBC)
		*!*			m.lnSQL = SQLSTRINGCONNECT("Provider=MSDASQL.1;" ;
		*!*				+"Persist Security Info=False;" ;
		*!*				+"DSN=Excel Files;" ;
		*!*				+"DBQ="+FULLPATH(m.tcXLSFile)+";" ;
		*!*				+"DriverId=790;" ;
		*!*				+"MaxBufferSize=2048;" ;
		*!*				+"PageTimeout=5;")
		
		*!* Try a few other drivers that may be on the user's machine
*!*			IF m.lnSQL < 0
			m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
				+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
			IF m.lnSQL < 0 AND UPPER(ALLTRIM(JUSTEXT(m.tcXLSFile))) == "XLS" && can we try using the older driver?
				IF m.lnSQL < 0
					m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls)};" ;
						+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
				ENDIF
			ENDIF
			IF m.lnSQL < 0
				AERROR(m.laErr)
				ERROR m.laErr[2]
			ENDIF
*!*			ENDIF

		m.lnResult = SQLEXEC(m.lnSQL,[SELECT ] + m.tcExcelFieldList + [ FROM "] + m.tcSheet + [" Where ] + m.tcExcelWhereExpr, m.lcSQLAlias)
		IF m.lnResult < 0
			AERROR(m.laErr)
			ERROR m.laErr[2]
		ENDIF

		IF USED(m.lcSQLAlias)
			m.lcFieldList = ""
			m.lcNvlFieldList = ""
			m.lnTotalExcelFields = AFIELDS(m.laExcelFields, m.lcSQLAlias)
			SELECT &tcTableFieldList FROM (m.tvWorkarea) WHERE .F. INTO CURSOR (m.lcTempAlias)
			FOR m.lnFieldCounter = 1 TO MIN(AFIELDS(m.laTableFields, m.lcTempAlias), m.lnTotalExcelFields)
				m.lcFieldList = m.lcFieldList + IIF(!EMPTY(m.lcFieldList),",","")+m.laTableFields[m.lnFieldCounter,1]
				m.lcFieldType =  CHRTRAN(m.laTableFields[m.lnFieldCounter,2],"NIFYD","BBBBT")
				m.lcExcelFieldType = CHRTRAN(m.laExcelFields[m.lnFieldCounter,2],"CVNIFYD","MMBBBBT")
				m.lcNvlFieldName = m.laExcelFields[m.lnFieldCounter,1]
				IF !m.laTableFields[m.lnFieldCounter,5]
					m.lcNvlFieldName = [NVL(]+m.lcNvlFieldName+[,]+;
						ICASE(m.lcExcelFieldType="B", "0", ;
						m.lcExcelFieldType="M", "''", ;
						m.lcExcelFieldType="T", "{//}", ;
						m.lcExcelFieldType="L", ".F.", ;
						"''")+[)]
				ENDIF
				IF INLIST(m.lcFieldType, "C", "V")
					m.lcNvlFieldName = [CAST(]+m.lcNvlFieldName+[ AS ]+m.lcFieldType+[(] + TRANSFORM(m.laTableFields[m.lnFieldCounter,3]) + [))]
				ELSE
					m.lcNvlFieldName = [CAST(]+m.lcNvlFieldName+[ AS ]+m.lcFieldType+[)]
				ENDIF
				m.lcNvlFieldList = m.lcNvlFieldList + IIF(!EMPTY(m.lcNvlFieldList),",","") + m.lcNvlFieldName
			ENDFOR
			INSERT INTO (m.tvWorkarea) (&lcFieldList) SELECT &lcNvlFieldList FROM (m.lcSQLAlias) WHERE &tcTableForExpr
			m.lnReturn = _TALLY
		ENDIF

	CATCH TO m.loExc
		*!*			MESSAGEBOX(m.loExc.MESSAGE + " : " + TRANSFORM(m.loExc.LINENO))
	FINALLY
		IF m.llOpenedtvWorkArea
			USE IN SELECT(m.tvWorkArea)
		ENDIF
		IF m.lnSQL > 0
			SQLDISCONNECT(m.lnSQL)
		ENDIF
		USE IN SELECT(m.lcTempAlias)
		USE IN SELECT(m.lcSQLAlias)
		SELECT (m.lnSelect)
	ENDTRY
	RETURN m.lnReturn
ENDFUNC