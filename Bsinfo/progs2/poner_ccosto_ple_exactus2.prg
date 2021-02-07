
** Modo de uso:
** DO Poner_Ccosto_Ple_Exactus WITH 'D:\o-Negocios\Oltursa\local\SINCCOSTO\LE2013541493120140100050100001111.xlsx'
**                             T:\COMUN\o-Negocios\Oltursa\local\SINCCOSTO\LE2013541493120140100060100001111.xlsx

*!*	PsNomFile = 'D:\o-Negocios\Oltursa\local\SINCCOSTO\LE2013541493120140100050100001111.xlsx'
PARAMETERS PsNomFile
LfHoraIni = SECONDS()
** VETT  30/12/2015 11:53 AM : Cargamos parametros de conexion a otros servidores - MUY IMPORTANTE!!!
goconexion.CargaParmsCadCnxArcIni('config.ini')
** VETT  30/12/2015 11:54 AM : Fin :Cargamos parametros de conexion a otros servidores 
*!*	loExcel=CREATEOBJECT("Excel.application")
*!*	loExcel.APPLICATION.VISIBLE=.F.
*!*	loExcel.APPLICATION.workbooks.OPEN(PsNomFile)


*!*	lnMaxRows = LoExcel.ActiveWorkBook.ActiveSheet.Rows.Count 

*!*	LsAsientoItem=loExcel.ActiveWorkBook.ActiveSheet.Cells(2,1).Value
*!*	LsAsiento 		= LEFT(LsAsientoItem,10)
*!*	LsConsecutivo	= VAL(RIGHT(LsAsientoItem,7))

*!*	LnTotRows 		= LoExcel.Activeworkbook.activesheet.UsedRange.Rows.Count
LsBaseDatos    = 'OLTURSA'
LsAsiento 		= ''
LnConsecutivo	= 0
LsCentro_Costo	= ''
SELECT 0
USE d:\o-negocios\interface\Libro_mayor ALIAS LMAYOR
LnTotRows = RECCOUNT()


goconexion.gennewstringconn(GoConexion.cDriver2,GoConexion.cServer ,'EXACTUS','',GoConexion.cUser ,GoConexion.cPassword,GoConexion.cestacion )	
LnRowAct = 0	
LsStringExactus	=	GoConexion.cStringCnxNew
CnExactus		=	SQLSTRINGCONNECT(LsStringExactus)
LsLibro=SUBSTR(JUSTSTEM(PsnomFile),23,3)

SET STEP ON 
SCAN 
	LnRowAct = LnRowAct + 1
	DO CASE
		CASE LsLibro	=	'501'
			LnColumna			=	10
		CASE LsLibro	=	'601'
			LnColumna			=	9
	ENDCASE
	IF LnTotRows>0
		WAIT WINDOW  'PLE: '+JUSTFNAME(PsnomFile)+' - Total registros procesados: ' + TRANSFORM( LnRowAct/LnTotRows * 100, '999.99') + ' %' nowait

	ENDIF
*!*		LsAsientoItem		=	NVL(loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,2).Value , '')

	LsASientoItem =	NVL(LMAYOR.ASiento,'')
	IF !EMPTY(LsAsientoItem)
		LsAsiento 			=	LEFT(LsAsientoItem,10)
		LnConsecutivo		=	VAL(RIGHT(RTRIM(LsAsientoItem),7))
		LsCentro_Costo		=	''
		GoConexion.cSql	= 	"{CALL " + [dbo.Get_Centro_Costo] + " (" + ;
						"?LsBaseDatos  , ?LsAsiento , ?LnConsecutivo , ?@LsCentro_Costo)}"
		GoConexion.cCursor = ""
		lnControl 			 = SQLEXEC(CnExactus,GoConexion.cSql,GoConexion.cCursor)
		SELECT LMAYOR
		IF LnControl>0
*!*				loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,LnColumna).Value = LsCentro_Costo	
			replace CCosto	WITH LsCentro_Costo
		ENDIF	
	ENDIF
ENDSCAN
=SQLDISCONNECT(CnExactus)
SELECT LMAYOR
FLUSH
LOCATE
*!*	loExcel.ActiveWorkbook.SAVE
LsFileLibroMayor='D:\o-negocios\Interface\LE20135414931201402000601000011'+'.xlsx'
LnRegPro=CopytoExcel(LsFileLibroMayor,"",'')
LfHoraFin = SECONDS()
LsHora    = TotHoras(LfHoraIni,LfHoraFin)
MESSAGEBOX('PROCESO TERMINADO. Tiempo transcurrido:'+LsHora,64) 



*********************************
PROCEDURE Calc_TotRows_Excel
*********************************
PARAMETERS PsExcelFile,PsSheet
*-----------------------------------
* AUTHOR: Trevor Hancock
* CREATED: 02/15/08 04:55:31 PM
* ABSTRACT: Code demonstrates how to connect to
* and extract data from an Excel 2007 Workbook
* using the "Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)"
* from the 2007 Office System Driver: Data Connectivity Components
*-----------------------------------
IF VARTYPE(PsExcelFile)<>'C'
	RETURN -1
ENDIF
IF PARAMETERS()=2
	IF VARTYPE(PsSheet)<>'C'
		RETURN -2
	ENDIF
ENDIF
IF EMPTY(PsSheet)
	PsSheet ='Sheet1'
ENDIF
LOCAL lcXLBook AS STRING, lnSQLHand AS INTEGER, ;
    lcSQLCmd AS STRING, lnSuccess AS INTEGER, ;
    lcConnstr AS STRING
CLEAR

lcXLBook = PsExcelFile && [C:\SampleWorkbook.xlsx]

lcConnstr = [Driver=] + ;
    [{Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};] + ;
    [DBQ=] + lcXLBook

IF !FILE( lcXLBook )
    ? [Excel file not found]
    RETURN .F.
ENDIF
*-- Attempt a connection to the .XLSX WorkBook.
*-- NOTE: If the specified workbook is not found,
*-- it will be created by this driver! You cannot rely on a
*-- connection failure - it will never fail. Ergo, success
*-- is not checked here. Used FILE() instead.
lnSQLHand = SQLSTRINGCONNECT( lcConnstr )

*-- Connect successful if we are here. Extract data...
lcSQLCmd = [Select * FROM "]+PsSheet+[$"]
lnSuccess = SQLEXEC( lnSQLHand, lcSQLCmd, [xlResults] )
? [SQL Cmd Success:], IIF( lnSuccess > 0, 'Good!', 'Failed' )
IF lnSuccess < 0
    LOCAL ARRAY laErr[1]
    AERROR( laErr )
    ? laErr(3)
    SQLDISCONNECT( lnSQLHand )
    RETURN .F.
ENDIF


*-- Show the results
SELECT xlResults
*!*	BROWSE NOWAIT
LnTotalReg	= RECCOUNT()
SQLDISCONNECT( lnSQLHand )
RETURN LnTotalReg

********************
Function VFP2Excel
********************
Lparameters tcCursorName, toSheet, tcTargetRange
tcCursorName = Iif(Empty(m.tcCursorName),Alias(),m.tcCursorName)
tcTargetRange = Iif(Empty(m.tcTargetRange),'A1',m.tcTargetRange)
Local loConn As AdoDB.Connection, loRS As AdoDB.Recordset,;
lcTempRs, lcTemp, oExcel
lcTemp = Forcepath(Sys(2015)+'.dbf',Sys(2023))
lcTempRs = Forcepath(Sys(2015)+'.rst',Sys(2023))
Select (m.tcCursorName)
Copy To (m.lcTemp)
loConn = Createobject("Adodb.connection")
loConn.ConnectionString = "Provider=VFPOLEDB;Data Source="+Sys(2023)
loConn.Open()
loRS = loConn.Execute("select * from "+m.lcTemp)
loRS.Save(m.lcTempRs)
loRS.Close
loConn.Close
Erase (m.lcTemp)
loRS.Open(m.lcTempRs)

With toSheet
	.QueryTables.Add( loRS, .Range(m.tcTargetRange)).Refresh()
Endwith
loRS.Close
Erase (m.lcTempRs)
***************************
FUNCTION VFP2Excel_ejm
**************************
 #include xlConstants.h
 Local oExcel, lcXLSFilename
 lcXLSFilename = "c:\MyExcelAutomationCustomer.xls"
 
 oExcel = Createobject("Excel.Application") && create Excel object
 With oExcel
   .WorkBooks.Add && Add new workbook
 
   * we are interested in active sheet of active workbook
   With .ActiveWorkBook.ActiveSheet
     .Range('A1').Value = "LIST OF CUSTOMER" && Add title to A1
 
     * Place data starting at A2
     *VFP2Excel('data\recorddb.dbc',;
       'select * from ("data\recordtrack")',;
       .Range('A2'))
       SELECT recordtrack
       SELECT * FROM recordtack INTO CURSOR UsedRange

    With .UsedRange.Rows(1) && This is first ROW of USED range
       .Merge                           && Merge the title cells
       .HorizontalAlignment = xlCenter  && Align Center
       With .Font                       && edit font properties
         .Name = "Arial Black"
         .Size = 15                && Excel has its own 56 indexed colors
         .ColorIndex = 3           && rgb() could be used too but not everywhere
       Endwith
    Endwith
     * Place the borders by setting each border side
     * to continous line
     Store xlContinuous To ;
      .UsedRange.Borders(xlEdgeLeft).LineStyle,;
      .UsedRange.Borders(xlEdgeTop).LineStyle,;
      .UsedRange.Borders(xlEdgeBottom).LineStyle,;
       .UsedRange.Borders(xlEdgeRight).LineStyle
 
     .UsedRange.Columns.AutoFit && autofit the columns
  ENDWITH
   * We are done
   
   * Close the workbook saving as lcXLSFileName
   .ActiveWorkBook.Close(.T., m.lcXLSFilename )
   .Quit && and Quit Excel application itself
 Endwith
****************** 
FUNCTION TotHoras
****************** 
PARAMETER _HoraIni,_HoraFin
DO CASE
   CASE (_HoraFin - _HoraIni)/(60*60)>1
        LfHora    = INT((_HoraFin - _HoraIni)/(60*60))
        LfMinutos = ROUND((_HoraFin - _HoraIni)/(60*60) - INT((_HoraFin - _HoraIni)/(60*60)),0)*60
        _Hora=TRAN(LfHora,'@L ##')+[Hrs ]+TRAN(LfMinutos,'99')+[Min]
        
   CASE (_HoraFin - _HoraIni)/(60*60)<=1
        IF (_HoraFin - _HoraIni)/60>1
           LfMinutos = INT((_HoraFin - _HoraIni)/60)
           LfSegundos= ROUND((_HoraFin - _HoraIni)/60 - INT((_HoraFin - _HoraIni)/60),2)*60
           IF LfSegundos>=60
              LfMinutos = LfMinutos + INT(LfSegundos/60)
              LfSegundos= (LfSegundos - INT(LfSegundos))*60
           ENDIF
           _Hora=TRAN(Lfminutos,'@L ##')+[Min ]+TRAN(Lfsegundos,'99')+[ Seg]
        ELSE
           LfSegundos= ROUND(_HoraFin - _HoraIni,2)
           _Hora=TRAN(Lfsegundos,'99.99')+[ Seg]
        ENDIF
ENDCASE
RETURN _Hora
