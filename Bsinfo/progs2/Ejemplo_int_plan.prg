DO CASE

	CASE	This.Tipo_Arch	=	'XLS'
		LsFile=ADDBS(this.cDirIntCia)+ THIS.Model_Arch
		SELECT 0
		USE  (LsFile) ALIAS  (THIS.CTABLA_EN_PROCESO)
		IF EMPTY(This.Arch_Xls)
			This.Arch_Xls= ADDBS(JUSTPATH(LsFile))+JUSTSTEM(LsFile)
		ENDIF
		LsRutaArchXls=ADDBS(RTRIM(This.ruta_arch))+this.Arch_Xls
		AppendFromExcel(LsRutaArchXls, THIS.Hoja_Xls, THIS.CTABLA_EN_PROCESO, "","1=1", "", ".T.")
		**
		LnTotReg		= RECCOUNT()
		LnTRegProc	= 0
		thisformset.procesoInterfaces.TxtAviso1.Value	=	[PROCESANDO:] + RTRIM(THIS.CTABLA_EN_PROCESO) + [ - ] + RTRIM(this.Arch_Xls) + [ - ]+ RTRIM(THIS.Hoja_Xls)
		**
		SELECT  (THIS.CTABLA_EN_PROCESO)
		LOCATE
		SCAN  
			IF EMPTY(ALLTRIM(Empresa+Ano+Mes+Codigo+Cod_Con)) 
				LOOP
			ENDIF
			SCATTER MEMVAR
				
				m.CodSuc='01'
				m.Mes 		= TRANSFORM(VAL(m.Mes)		,"@L ##")
				m.Semana	= TRANSFORM(VAL(m.Semana)	,"@L ##")
				LsCodigo	= Codigo
				m.Codigo	=	PADL(ALLTRIM(codigo),7,'0')

				IF !USED('TRAB')
					SELECT  0
					USE ADDBS(this.cDirIntCia)+'TRAB' ALIAS TRAB
					SET ORDER TO Codigo
				ELSE
					SELECT TRAB
					SET ORDER TO Codigo	
				ENDIF
				SELECT  TRAB
				SEEK 	PADR(LsCodigo,LEN(TRAB.Codigo))
				IF !FOUND()
					SELECT  (THIS.CTABLA_EN_PROCESO)
					REPLACE Error WITH '#' , MsgErr WITH 'No se encuentra codigo de trabajador en TRAB.DBF'  IN  (THIS.CTABLA_EN_PROCESO)
					LOOP
				ELSE
					IF EMPTY(Nomina)	OR  !INLIST(TRIM(Nomina),'1','2','3','4','5','6')
						SELECT  (THIS.CTABLA_EN_PROCESO)
						** Generar Log de inconsistencia
						REPLACE Error WITH '#' , MsgErr WITH 'Codigo de nomina es inválido'  IN  (THIS.CTABLA_EN_PROCESO)
						LOOP
					ENDIF
				ENDIF	 
				** Obtenemos el codigo de nomina TPL_CODTPL --> Valor deber existir en  dbo.TIPO_PLANILLA_TPL
				m.CodTpl	=  TRANSFORM(VAL(nomina),"@L ##")
				SELECT  (THIS.CTABLA_EN_PROCESO)
				DO CASE
					CASE m.Tip_Pla = 'M'		&& Mensual
						m.Tip_Pla	=	'01'							
					CASE m.Tip_Pla = 'S'		&& Semanal
						m.Tip_Pla	=	'02'
					CASE m.Tip_Pla = 'G'		&& Gratificacion
						m.Tip_Pla	=	'03'							
					CASE m.Tip_Pla = 'V'		&& Vacaciones
						m.Tip_Pla	=	'04'							
					CASE m.Tip_Pla = 'U'		&& Utilidades
						m.Tip_Pla	=	'05'							
					CASE m.Tip_Pla = 'Q'		&& Quincena
						m.Tip_Pla	=	'06'							
					CASE m.Tip_Pla = 'P'		&& Planilla LBS
						m.Tip_Pla	=	'07'							
					CASE m.Tip_Pla = 'E'		&& Extraordinaria
						m.Tip_Pla	=	'09'							

					OTHERWISE 	
						** Generar Log de inconsistencia **
				ENDCASE
				m.CorPPE	= '001'   && Secuencia
				** Variable para el correlativo de la llave 
				m.CorPCA    = '000'   && CIA_CODCIA+SUC_CODSUC+ANO_CODANO+MES_CODMES+TPL_CODTPL+PPE_CORPPE+AUX_CODAUX
				m.CodCTE	= '00000000000000'
				m.NumDoc	= ''
				** -- **
				m.Indest = 1
				m.FecAct = DATETIME()
				m.Usuario	= goentorno.user.login
				m.Estacion	= goentorno.user.estacion
				m.TipoOperacion = 'I1'

				LsStringBD2	= This.Ocnx_Odbc.cStringCnx2 
				CnxDB2		= SQLSTRINGCONNECT(LsStringBD2)

*!*	*!*					.ocnx_ODBC.cSQL	= "EXEC INT_PLANILLA_CALCULO_PCA " + ;       && Si activan esta linea comentar las 2 anteriores

				LsCadSql = 	"EXEC INT_PLANILLA_CALCULO_PCA " + ;			
						"@CIA_CODCIA     	= ?m.Empresa , " + ;
						"@SUC_CODSUC	= ?m.CodSuc , " + ;
						"@ANO_CODANO	= ?m.Ano , " + ;
						"@MES_CODMES	= ?m.Mes , " + ;
						"@TPL_CODTPL	= ?m.CodTpl , " + ;
						"@PPE_CORPPE	= ?m.CorPPE , " + ;
						"@AUX_CODAUX	= ?m.Codigo , " + ;
						"@CON_CODCON	= ?m.Cod_Con , " + ;
						"@PCA_CORPCA	= ?m.CorPCA , " + ;
						"@CTE_CODCTE	= ?m.CodCTE , " + ;
						"@PCA_NUMDOC	= ?m.NumDoc , " + ;
						"@PCA_MDATO3	= ?m.Importe , " + ;
						"@PCA_FECACT	= ?m.FecAct  , " + ;
						"@Usuario 			= ?m.Usuario , " + ;
						"@Estacion 			= ?m.Estacion , " + ;
						"@TipoOperacion 	= ?m.TipoOperacion "

				LnControl  = SQLEXEC(CnxDB2,LsCadSQL)  && Comentar doble esta linea si activan las  2 siguientes

				IF lnControl < 0
					SET STEP ON 
					REPLACE Error WITH '@' , MsgErr WITH MESSAGE()  IN  (THIS.CTABLA_EN_PROCESO)
				ENDIF

*!*	*!*						.ocnx_ODBC.cCursor = ""
*!*	*!*						lnControl = .ocnx_ODBC.DoSQL()
					=SQLDISCONNECT(CnxDB2)     && Comentar doble esta linea si activan las  2 anteriores

					IF lnControl < 0
*!*							=MESSAGEBOX("No se actualizaron los datos",64,"Error")
*!*							RETURN
					ENDIF			
					IF LnTotReg>0
						LnTRegProc = LnTRegProc + 1
						this.caviso2 = "PROCESANDO: "+STR(ROUND(LnTRegProc/LnTotReg*100,2),10,2) + ' %'
						thisformset.procesoInterfaces.TxtAviso2.Value	=	This.cAviso2
					ENDIF
		ENDSCAN
		
	CASE	This.Tipo_Arch	=	'DBF'
	CASE	This.Tipo_Arch	=	'CSV'
ENDCASE