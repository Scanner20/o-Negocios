#include const.h 	
loExcel=CREATEOBJECT("Excel.application")
loExcel.APPLICATION.VISIBLE=.F.
PsNomFile=GETFILE("xls;xlsx","Archivo  ",'Seleccionar', 1,'Buscar lista de precios')

IF MESSAGEBOX('Este proceso sobreescribirá la lista de precios actual.'+CRLF+ '¿Desea continuar  con la actualización desde el archivo: '+CRLF+PsNomFile +'?',4+32,'Cargar la lista de precios desde archivo excel')=7
	RETURN 
ENDIF
WAIT WINDOW 'Abriendo archivo '+PsNomFile+'...'  NOWAIT
LoExcel.APPLICATION.workbooks.OPEN(PsNomFile)
LnMaxRows	= LoExcel.ActiveWorkBook.ActiveSheet.Rows.Count

LnTotRows		= Calc_TotRows_Excel(PsNomFile,'Hoja1')	
LnRowAct = 1
LnColumna = 1
LfPorIgv = GoSvrCbd.XfPorIgv
*!*	?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,LnColumna).Value
*!*	?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,2).Value
*!*	?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,3).Value
*!*	?loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,3).Value + 1
LlCloseCatg=.F.
IF !USED('CATG')
	SELECT 0
	LlCloseCatg	=	GoEntorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
ELSE
	SELECT CATG
	SET ORDER TO CATG01
ENDIF
IF !USED('CATG_ANT')
*!*		SELECT * FROM p0012016!v_materiales_sin_almacen ORDER BY codant INTO CURSOR CATG_ANT
	SELECT 0
	GoEntorno.open_dbf1('ABRIR','v_materiales_sin_almacen','CATG_ANT','','')
	INDEX ON CODANT TAG CODANT
ELSE
	SELECT  CATG_ANT
	SET ORDER TO CODANT
ENDIF
WAIT WINDOW  'Cargando Lista de Precio: '+JUSTFNAME(PsnomFile) NoWAIT
LfTpoCmb = 0
FOR LnRowAct= 1 TO LnTotRows 
	IF LnRowAct=1	AND VARTYPE(loExcel.ActiveWorkBook.ActiveSheet.Cells(1,4).Value)='C' AND ;
					                loExcel.ActiveWorkBook.ActiveSheet.Cells(1,4).Value='T.C:' AND ;
					                VAL(substr(loExcel.ActiveWorkBook.ActiveSheet.Cells(1,4).Value,5)) > 0
		LfTpoCmb	= VAL(substr(loExcel.ActiveWorkBook.ActiveSheet.Cells(1,4).Value,5))
	ENDIF
	IF VARTYPE(loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,3).Value)<>'N'
		LOOP
	ENDIF
	LsCodAnt	=	loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,LnColumna).Value
	LsDesMat	=	loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,2).Value
	LsCodAnt	=	IIF(VARTYPE(LsCodAnt)='C',LsCodAnt,'')
	LsDesMat	=	IIF(VARTYPE(LsDesMat)='C',LsDesMat,'')
	IF !EMPTY(LsCodAnt)
		LsAritculo =	 TRIM(LsCodAnt ) +' '+ TRIM(LsDesMat)
		IF LnTotRows>0
			WAIT WINDOW  'Cargando Lista de Precio: '+JUSTFNAME(PsnomFile)+' - Registro:'+LsAritculo+ ' - Avance: ' + TRANSFORM( LnRowAct/LnTotRows * 100, '999.99') + ' %' nowait
		ENDIF

		LfPreVta		=	NVL(loExcel.ActiveWorkBook.ActiveSheet.Cells(LnRowAct,3).Value,0)
		LfPreVta		=	IIF(VARTYPE(LfPreVta)<>'N',0,LfPreVta)
		SELECT CATG_ANT
		SEEK PADR(LsCodAnt,LEN(CodAnt))
		IF FOUND()
			LsCodMat =	CodMat
			SELECT CATG
			SEEK LsCodMat
			IF FOUND()  AND LfPreVta>0
				REPLACE 	PreVN1 WITH ROUND(LfPreVta/(1+LfPorIgv/100) ,3) && LfPreVta
				LfImpIgv	=	ROUND(LFPreVta-LFPreVta/(1+LfPorIgv/100) ,3)
				IF LfTpoCmb>0  && Actualizamos precio 1  en moneda extranjera 
					REPLACE 	PreVE1 WITH ROUND((LfPreVta/(1+LfPorIgv/100) )/ LfTpoCmb,3)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDFOR
SELECT CATG
FLUSH IN CATG
IF USED('CATG_ANT')
	USE IN CATG_ANT
ENDIF
IF USED('XlResults')
	USE IN XlResults
ENDIF
IF LlCloseCatg 
	USE IN CATG
ENDIF