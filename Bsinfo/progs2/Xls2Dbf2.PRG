***********************************
FUNCTION CopyToExcel(tcXLSFile, tcSheet, tvWorkArea, tcExcelFieldList, tcTableFieldList, tcTableForExpr)
	***********************************
	* PARAMETER Information
	* tcXLSFile := a string specifying an excel file (*.xls, *.xlsx, *.xlsm, *.xlsb) on disk
	* tcSheet := a string specifying the name of the worksheet to create within the excel workbook
	* tvWorkarea [optional] := the Alias, Work Area, or File Name of the table you want to be copied to the worksheet (default is currently selected Alias)
	* tcExcelFieldList [optional] := a comma delimited list of columns you want to create in the worksheet (default is '*' - columns will match table field list)
	* tcTableFieldList [optional] :=  a comma delimited list of fields you want this function to copy from tvWorkArea
	* tcTableForExpr [optional] := a valid VFP Where/For clause to be used when querying tvWorkArea for data to be copied to the worksheet
	*
	* RETURN Information
	* returns numeric, the number of records inserted into the worksheet
	*
	* Provider Information
	* the default provider being used in the SQLStringConnect function can be downloaded and installed from:
	* http://www.microsoft.com/downloads/details.aspx?FamilyID=7554F536-8C28-4598-9B72-EF94E038C891&displaylang=en
	**********************************
	#DEFINE adOpenStatic 3
	#DEFINE adOpenKeyset 1
	#DEFINE adLockOptimistic 3
	#DEFINE adUseClient 3
	#DEFINE adUseServer 2
	#DEFINE adCmdText 0x0001
	LOCAL loConnection as ADODB.Connection, lnRecnoWas, lcCreateTableCommand, llOpenedtvWorkArea, loExc as Exception
	LOCAL lnReturn, lnResult, lnFieldCounter, lnSQL, loCursorAdapter as CursorAdapter
	LOCAL lcFieldName, lcFieldType, lcSelectFields, lcUpdateNameListFields, lcUpdatableFieldList
	Local loRecordSet as ADODB.Recordset, lcConversionFunc, lcVFPFieldName, lnSelect
	LOCAL ARRAY laTableFields[1], laErr[1]

	m.lnSelect = SELECT(0)
	m.lnReturn = 0
	
	m.llOpenedtvWorkArea = .F.
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
	m.tcExcelFieldList = EVL(m.tcExcelFieldList,"")
	m.tcTableFieldList = EVL(m.tcTableFieldList,"*")
	m.tcTableForExpr = EVL(m.tcTableForExpr,".T.")
	m.lnSQL = 0
	m.lcTempAlias = SYS(2015)
	
	TRY
		CreateExcelTemplate(m.tcXLSFile)
		IF !FILE(m.tcXLSFile)
			m.lnReturn
		ENDIF
		m.loConnection = CreateObject ( "ADODB.Connection")
		*!* This is the only provider/driver that appears to work without showing Select Data Source dialog
		*!* or throwing a weird error about the excel Database being readonly.
		m.loConnection.ConnectionString = [Provider=Microsoft.ACE.OLEDB.12.0;Data Source="] + m.tcXLSFile + [";Extended Properties="Excel 12.0 Xml;HDR=Yes;";]
		m.loConnection.Open()
		m.loConnection.Execute("DROP TABLE [Sheet1$]")
		
		SELECT &tcTableFieldList ;
			FROM (m.tvWorkarea) ;
			WHERE .F. ;
			INTO CURSOR (m.lcTempAlias) READWRITE
		SELECT (m.tvWorkarea)
		m.lnRecnoWas = RECNO(m.tvWorkarea)
		SCAN FOR &tcTableForExpr
			INSERT INTO (m.lcTempAlias) VALUES (&tcTableFieldList)
		ENDSCAN
		GO RECORD m.lnRecnoWas IN (m.tvWorkarea)
*!*			SELECT &tcTableFieldList ;
*!*				FROM (m.tvWorkarea) WITH (Buffering = .T.) ;
*!*				WHERE &tcTableForExpr ;
*!*				INTO CURSOR (m.lcTempAlias) NOFILTER
		GO TOP IN (m.lcTempAlias)
		m.lnReturn = RECCOUNT(m.lcTempAlias)
		m.lcCreateTableCommand = ""
		m.lcSelectFields = ""
		m.lcUpdateNameListFields = ""
		m.lcUpdatableFieldList = ""
		m.lcConversionFunc = ""
		FOR m.lnFieldCounter = 1 TO AFIELDS(m.laTableFields, m.lcTempAlias)
			m.lcVFPFieldName = m.laTableFields(m.lnFieldCounter, 1)
			m.lcFieldName = ALLTRIM(GETWORDNUM(m.tcExcelFieldList, m.lnFieldCounter, ","))
			IF EMPTY(m.lcFieldName)
				m.lcFieldName = m.laTableFields(m.lnFieldCounter, 1)
			ENDIF
			m.lcSelectFields = m.lcSelectFields + "[" + m.lcFieldName + "] " + " AS " + m.lcVFPFieldName
			m.lcUpdateNameListFields = m.lcUpdateNameListFields + m.lcVFPFieldName + " [" + m.tcSheet + "].[" + m.lcFieldName + "]"
			m.lcUpdatableFieldList = m.lcUpdatableFieldList + m.lcVFPFieldName
			m.lcCreateTableCommand = m.lcCreateTableCommand + "[" + m.lcFieldName + "] "
			m.lcFieldType = m.laTableFields(m.lnFieldCounter, 2)
			m.lcCreateTableCommand = m.lcCreateTableCommand + ;
				ICASE(m.lcFieldType = 'C', 'Char(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ')', ;
				 m.lcFieldType = 'Y', 'Currency', ;
				 m.lcFieldType = 'D', 'Date', ;
				 m.lcFieldType = 'T', 'DateTime', ;
				 m.lcFieldType = 'B', 'Double', ;
				 m.lcFieldType = 'F', 'Double', ;
				 m.lcFieldType = 'G', 'Binary', ;
				 m.lcFieldType = 'I', 'Integer', ;
				 m.lcFieldType = 'L', 'Logical', ;
				 m.lcFieldType = 'M', 'Text', ;
				 m.lcFieldType = 'N', 'Numeric(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ',' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 4)) + ')', ;
				 m.lcFieldType = 'Q', 'Binary', ;
				 m.lcFieldType = 'V', 'VarChar(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ')', ;
				 m.lcFieldType = 'W', 'Blob', ;
				 'Char(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ')')
			IF INLIST(m.lcFieldType,"T","D")
				m.lcConversionFunc = m.lcConversionFunc + IIF(!EMPTY(m.lcConversionFunc), ", ", "") + m.lcVFPFieldName + " EmptyFieldToNull"
			ENDIF
			IF m.lnFieldCounter != ALEN(m.laTableFields,1)
				m.lcCreateTableCommand = m.lcCreateTableCommand + ','
				m.lcSelectFields = m.lcSelectFields + ','
				m.lcUpdateNameListFields = m.lcUpdateNameListFields + ','
				m.lcUpdatableFieldList = m.lcUpdatableFieldList + ','
			ENDIF
		ENDFOR
		IF !EMPTY(m.lcCreateTableCommand)
			IF m.tcSheet != [Sheet1$]
				m.tcSheet = STRTRAN(m.tcSheet,"$","")
			ENDIF
			m.lcCreateTableCommand = "CREATE TABLE [" + m.tcSheet + "](" + m.lcCreateTableCommand + ")"
			m.loConnection.Errors.Clear()
			m.loConnection.Execute(m.lcCreateTableCommand)
			IF m.loConnection.Errors.Count>0
				ERROR m.loConnection.Errors(0).Description
			ENDIF
			m.loRecordSet = CreateObject("ADODB.Recordset")
			With m.loRecordSet
			    .ActiveConnection = m.loConnection
			    .CursorLocation = adUseClient
			    .CursorType = adOpenStatic
			    .LockType = adLockOptimistic
			ENDWITH
			m.loCursorAdapter = CREATEOBJECT("CursorAdapter")
			m.loCursorAdapter.Alias = SYS(2015)
			m.loCursorAdapter.DataSourceType = "ADO"
			m.loCursorAdapter.DataSource = m.loRecordSet
			m.loCursorAdapter.SelectCmd = "Select " + m.lcSelectFields + " From [" + m.tcSheet + "]"
			IF m.loCursorAdapter.CursorFill(.F.,.T.)
				m.loCursorAdapter.Tables = "[" + m.tcSheet + "]"
				m.loCursorAdapter.BufferModeOverride = 3 && faster than 5 when dealing with larger record sets
				m.loCursorAdapter.UpdateNameList = m.lcUpdateNameListFields
				m.loCursorAdapter.UpdatableFieldList = m.lcUpdatableFieldList
				IF !EMPTY(m.lcConversionFunc)
					m.loCursorAdapter.ConversionFunc = m.lcConversionFunc
				ENDIF
				INSERT INTO (m.loCursorAdapter.Alias) SELECT * FROM (m.lcTempAlias)
				m.lnReturn = TABLEUPDATE(.T.,.T.,m.loCursorAdapter.Alias)
			ELSE
				AERROR(m.laErr)
				ERROR m.laErr(2)
			ENDIF
		ENDIF
		m.loConnection.Close()
	CATCH TO m.loExc
		m.lnReturn = 0
	FINALLY
		m.loCursorAdapter = Null
		m.loConnection = Null
		RELEASE loCursorAdapter, loConnection
		IF m.llOpenedtvWorkArea
			USE IN SELECT(m.tvWorkarea)
		ENDIF
		USE IN SELECT(m.lcTempAlias)
		SELECT (m.lnSelect)
	ENDTRY
	RETURN m.lnReturn
ENDFUNC