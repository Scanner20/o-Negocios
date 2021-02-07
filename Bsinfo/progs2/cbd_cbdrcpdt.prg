*!*	PARAMETERS cFormulario
*!*	IF PARAMETERS()=0
*!*		MESSAGEBOX('Indicar el numero o codigo de formulario correspondiente segun lo indican en el PDT.'+;
*!*					' Ejemplo : 0621 -> Importacion de recibo por honorarios',16,'ATENCION !!' )
*!*		RETURN
*!*		
*!*	ENDIF
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
*!*	DO CASE 
*!*		CASE cFormulario='0621R'
*!*		CASE cFormulario='0621P'
*!*		CASE cFormulario='0621L'
*!*		CASE cFormulario='0621'
*!*			cTit4 = "GENERAR INFORMACION DE RECIBOS PARA EL PDT"
*!*		
*!*	ENDCASE

XdFchAst = DATE()
XsNombre =[]
XxImp=0
XsCodAux = SPACE(11)
XsCodDiv = SPACE(3)
XsNomDiv = []
XsCodRef = []
XsNroAst = []
XsClfAux = []
XnFormat = 1
XcEliItm = '*'

***

XsNroMes = TRANSFORM(_Mes,"@L ##")
XsCodOpe = SPACE(3)
CsCodCco =  '' 
XiCodMon = 1   
XnOrden  = 2 
XsRutaArchivo = ''



DO FORM Cbd_CbdRcPdt

RETURN
*****************
PROCEDURE xGENERA
*****************
DO AbrirTablas IN Cbd_Report_Registro_Retenciones

Wait Window "Generando Archivo para el PDT" NoWait

DO CreaTemp IN Cbd_Report_registro_retenciones WITH 'Temporal' 
SELECT Temporal 
IF XnOrden = 1
	INDEX ON nroAst tag tmp01
ELSE
	IF XnOrden = 2
		INDEX ON nroDoc tag tmp01
	ELSE
		INDEX ON CodCco+NroAst TAG tmp01
	ENDIF
ENDIF
SET ORDER TO tmp01


DO imprimir IN Cbd_Report_registro_retenciones

IF !USED('tempPdt')
	SELE 0
	ArcTmp = GoEntorno.TmpPath+Sys(3)
	CREATE TABLE (ArcTmp) FREE (cadena c(254))
	USE (ArcTmp) ALIAS tempPdt
ELSE
	SELE TempPdt
	DELETE ALL

ENDIF

SELECT Temporal
LOCATE
SCAN 
	IF CtaCate=0
		replace Nograva WITH Importe
	ENDIF
	PRO = ALLT(PROVEEDOR)
	P1  = ATC(' ',PRO,1)
	P2  = ATC(' ',PRO,2)
	IF P1<1 OR P2<1
		APE = 'P'
		MAT = 'M'
		NOM = 'N'
	ELSE
		APE = LEFT(PRO,P1-1)
		MAT = SUBSTR(PRO,P1+1,P2-P1-1)
		NOM = SUBSTR(PRO,P2+1)
	ENDIF
*	Wait Window "Generando Archivo para el PDT "+cFormulario NoWait
*	@Numlin,0 SAY RUCAUX+"|"+ALLT(LEFT(APE,20))+"|"+ALLT(LEFT(MAT,20))+"|"+ALLT(LEFT(NOM,20))+"|"+ALLT(LEFT(SERDOC,3))+"|"+ALLT(LEFT(NRODOC,8))+"|"+DTOC(FCHDOC)+"|"+ALLT(TRANS(NOGRAVA,'@L 999999999.99'))+"|"+IIF(CTACATE<>0,'1','0')+"|"+'10'+"|"+IIF(FONAVI<>0,'1','0')+"|"++"|"
	MiCadena= RUCAUX+"|"+ALLT(LEFT(APE,20))+"|"+ALLT(LEFT(MAT,20))+"|"+ALLT(LEFT(NOM,20))+"|"+"0"+ALLT(LEFT(SERDOC,3))+"|"+ALLT(LEFT(NRODOC,8))+"|"+DTOC(FCHDOC)+"|"+ALLT(TRANS(NOGRAVA,'@L 999999999.99'))+"|"+IIF(CTACATE<>0,'1','0')+"|"+'10'+"|"+IIF(FONAVI<>0,'','')+"|"++"|"
	SELECT TempPdt
	APPEND BLANK
	REPLACE CADENA WITH TRIM(MICADENA)
	SELECT Temporal
ENDSCAN

*!*	Wait Window "Generando Archivo para el PDT" NoWait
*!*	xNomFile = [0621]+ALLT(GsRucCia)+Str(_Ano,4,0)+Trans(_mes,'@l 99')+[.TXT]
*!*	xCommand = [!Copy C:\PDTRECIB.TXT C:\]+xNomFile+[ /V/Y]
*!*	xComman2 = [!del c:\]+xNomFile
*!*	&xComman2.
*!*	&xCommand.
SELECT tempPdt
XsArchivo = [0621]+ALLT(GsRucCia)+Str(_Ano,4,0)+Trans(_mes,'@l 99')+[.TXT]
COPY TO (XsRutaArchivo)+XsArchivo SDF

*

RETURN




