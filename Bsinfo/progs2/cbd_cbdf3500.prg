*****************************************************************************************
* PROGRAMA   : CBD_CBDRF3500.PRG                            							*
* OBJETO     : TRANSFERIR ARCHIVOS DE CONTABILIDAD AL PDT   							*
* AUTOR      : MAAV                                         							*
* CREACION   : 02/08/2001   para FPD26                      							*
* MODIFCADO  : VETT 2008/11/20 15:06:26 para VFP9  										*	 
* MODIFCADO  : VETT 2008/12/22 15:39:32 - Actualizado para calcule segun la base imponi-*
*				ble , queda opcional dividir el total entre el IGV 						*
*****************************************************************************************
PARAMETER XcFORM

*!*	SYS(2700,0)
*!*	DO def_teclas IN fxgen_2
*!*	SET DISPLAY TO VGA25

PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoContab = CREATEOBJECT('Dosvr.Contabilidad')
** APERTURAMOS ARCHIVOS **
DO MOVAPERT 

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "FORMULARIO 3500"
*!*	Do Fondo WITH cTit1,cTit2,cTit3,cTit4
ULTTECLA=0
SORTEO = 1
STORE '' TO XsCodOpe,XcSorteo,XsArchivo
DO FORM CBD_CBDF3500 WITH XcFORM
RELEASE LoContab
RELEASE LoDatAdm
*!*	@  9,15 FILL  TO 19,62      COLOR W/N
*!*	@  8,16 CLEAR TO 18,63
*!*	@  8,16       TO 18,63
*!*	@ 10,25 SAY "Generar      : " GET Sorteo PICT "@^ COSTOS;INGRESOS"
*!*	READ
********************
PROCEDURE P_Transfer
********************
*!*	IF LASTKEY() = 27
*!*		DO P_Terminar
*!*	ENDIF
*!*	IF SORTEO = 1
*!*		XCSORTEO = [COSTOS]
	SELE FPDT
	SEEK XcFORM+XCSORTEO
	DIMENSION xxCodCta(4)
	NumCta = 0
	LsxxCodCta = ALLTRIM(CodCta)
	DO WHILE .T.
		IF EMPTY(LsxxCodCta)
			EXIT
		ENDIF
		NumCta = NumCta + 1
		IF NumCta > ALEN(xxCodCta)
			DIMENSION xxCodCta(NumCta+5)
		ENDIF
		Z = AT(",",LsxxCodCta)
		IF Z = 0
			Z = LEN(LsxxCodCta) + 1
		ENDIF
		xxCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
		IF Z > LEN(LsxxCodCta)
			EXIT
		ENDIF
		LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
	ENDDO
*!*		XSCODOPE = CODOPE
*!*		XSARCHIVO = XCSORTEO+[.TXT]
*!*		@ 14,23 SAY "Nombre de Archivo   : " GET XSARCHIVO
*!*		READ
*!*	ELSE
*!*		XCSORTEO = [INGRESOS]
*!*		SELE FPDT
*!*		SEEK XcFORM+XCSORTEO
*!*		DIMENSION xxCodCta(4)
*!*		NumCta = 0
*!*		LsxxCodCta = ALLTRIM(CodCta)
*!*		DO WHILE .T.
*!*			IF EMPTY(LsxxCodCta)
*!*				EXIT
*!*			ENDIF
*!*			NumCta = NumCta + 1
*!*			IF NumCta > ALEN(xxCodCta)
*!*				DIMENSION xxCodCta(NumCta+5)
*!*			ENDIF
*!*			Z = AT(",",LsxxCodCta)
*!*			IF Z = 0
*!*				Z = LEN(LsxxCodCta) + 1
*!*			ENDIF
*!*			xxCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
*!*			IF Z > LEN(LsxxCodCta)
*!*				EXIT
*!*			ENDIF
*!*			LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
*!*		ENDDO
*!*		XSCODOPE = CODOPE-	-
*!*		XSARCHIVO = XCSORTEO+[.TXT]
*!*		@ 14,23 SAY "Nombre de Archivo   : " GET XSARCHIVO
*!*		READ
*!*	ENDIF
*!*	@ 14,23 SAY "Nombre de Archivo   : " + XSARCHIVO
*!*	@ 15,23 SAY "C¢digo de Operacion : " + XSCODOPE
*!*	ULTTECLA=LASTKEY()
*!*	IF ULTTECLA = K_Esc
*!*		DO P_Terminar
*!*	ELSE
	DO GENERA
*!*	ENDIF
SELECT PDT
ZAP
SET ORDER TO PDT01
SELECT TEMP
ZAP
*!*	DO P_Terminar

********************
PROCEDURE P_TERMINAR
********************
*!*	SYS(2700,1)
loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('RMOV')
loContab.oDatadm.CloseTable('AUXI')
loContab.oDatadm.CloseTable('OPER')
loContab.oDatadm.CloseTable('FPDT')
loContab.oDatadm.CloseTable('PDT')
loContab.oDatadm.CloseTable('TEMP')
loContab.oDatadm.CloseTable('RMOV2')

*!*	CLEAR
*!*	CLEAR MACROS
*!*	IF WEXIST('__WFONDO')
*!*		RELEASE WINDOWS __WFONDO
*!*	ENDIF
*!*	SYS(2700,1)
****************
PROCEDURE GENERA
****************

N=1
FOR Z = 1 TO NumCta
	XsCodCta = TRIM(xxCodCta(Z))
	LnLenCta = LEN(XsCodCta)
	SELECT RMOV
	SEEK XSCODCTA
	SCAN WHILE XSCODCTA = LEFT(CODCTA,LnLenCta)
		IF NroMes<> "00" AND CodOpe = XsCodOpe
			WAIT WINDOW [Procesando : ]+NROAST+[ de ]+UPPER(MES(VAL(NROMES))) NOWAIT
			**>>  Vo.Bo. VETT  2008/11/28 12:34:55 - Tenemos que buscar datos del proveedor 
			STORE '' TO XsClfAux,XsCodAux,XsCodDoc
			**>>  Vo.Bo. VETT  2008/12/22 15:43:37 - Acondicionamos para que sea por COSTOS /INGRESOS
			IF INLIST(XcSorteo,'INGRESOS','COSTOS')
				LsClfAux= IIF(XcSorteo='INGRESOS',GsClfCli,GsClfPro)
				SELECT RMOV2
				SEEK RMOV.Nromes+Rmov.CodOpe+RMOV.NroAst
				SCAN WHILE NroMes+CodoPe+NroAst=RMOV.Nromes+Rmov.CodOpe+RMOV.NroAst
					=SEEK(CodCta,'CTAS')
					IF CTAs.PidAux='S' AND RMOV2.ClfAux=LsClfAux AND CTAS.GenAut<>'S'
						XSCLFAUX = RMOV2.CLFAUX
						XSCODAUX = RMOV2.CODAUX
						XsCodDoc = RMOV2.CodDoc 
						EXIT 
					ENDIF
				ENDSCAN 
				SELECT RMOV
			ELSE	
				XSCLFAUX = RMOV.CLFAUX
				XSCODAUX = RMOV.CODAUX
			ENDIF
			IF INLIST(XsCodAux,"20999","21022","20074")
				XSRUCAUX=RMOV.NRORUC
				XSNOMAUX=RMOV.GLODOC
				DO CASE
					CASE LEFT(XSRUCAUX,2)=[10]
					    IF !INLIST(GSSIGCIA,'AROMAS','QUIMICA','RQU','CORPAROM')
					    	XSRUCAUX=SUBSTR(XSRUCAUX,3,8)
					    ENDIF 
						XSTIPO_PER=[01]
						XSTIPO_DOC=[1]
					CASE LEFT(XSRUCAUX,2)=[20]
						XSTIPO_PER=[02]
						XSTIPO_DOC=[6]
					OTHER
						XSTIPO_PER=[03]
						XSTIPO_DOC=[-]
				ENDCASE
			ELSE
				SELE AUXI
				SEEK XSCLFAUX+XSCODAUX
				XSRUCAUX=RUCAUX
				XSNOMAUX=NOMAUX
				SELE PDT
				DO CASE
					CASE LEFT(XSRUCAUX,2)=[10]
						IF !INLIST(GSSIGCIA,'AROMAS','QUIMICA','RQU','CORPAROM')
							XSRUCAUX=SUBSTR(XSRUCAUX,3,8)
						ENDIF
						XSTIPO_PER=[01]
						XSTIPO_DOC=[1]
					CASE LEFT(XSRUCAUX,2)=[20]
						XSTIPO_PER=[02]
						XSTIPO_DOC=[6]
					OTHER
						XSTIPO_PER=[03]
						XSTIPO_DOC=[-]
				ENDCASE
			ENDIF
			LfImporte = 0
			SELE PDT
			SEEK XSRUCAUX
			IF !FOUND()
				APPEND BLANK
				DO WHILE !RLOCK()
				ENDDO
				REPLACE D_TIPODOC WITH [6]
				REPLACE D_NUMDOC  WITH TRIM(GSRUCCIA)
				REPLACE PERIODO   WITH TRANS(_ANO,[####])
				REPLACE TIPO_PER  WITH XSTIPO_PER
				REPLACE TIPO_DOC  WITH XSTIPO_DOC
				REPLACE NUM_DOC   WITH XSRUCAUX
				**>>  Vo.Bo. VETT  2008/12/22 15:44:58
				IF XcSorteo='INGRESOS'
					IF RMOV.CodCta='12'
						REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)*IIF(RMOV.CodDoc='07',0,1),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)*IIF(RMOV.CodDoc='07',0,1)),0),[###############])
					ELSE
						IF INLIST(RMOV.AFecto,'A','I','N')
							REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT,-RMOV.IMPORT),0),[###############])						
						ENDIF
					ENDIF	
				ELSE
					**>>  Vo.Bo. VETT  2008/11/28 11:25:23  REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)),0),[###############])
					IF RMOV.CodCta='42'
						REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)),0),[###############])
					ELSE
						IF INLIST(RMOV.AFecto,'A','I','N')
							REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT,-RMOV.IMPORT),0),[###############])
						ENDIF
					ENDIF
						
				ENDIF
				*IF TIPO_PER=[02]
					REPLACE RAZON_SOC WITH XSNOMAUX
				*ELSE
				IF TIPO_PER=[01]
					REPLACE AP_PATER WITH AUXI.AP_PATER
					REPLACE AP_MATER WITH AUXI.AP_MATER
					REPLACE NOMBRE1  WITH AUXI.NOMBRE1
					REPLACE NOMBRE2  WITH AUXI.NOMBRE2
				ENDIF
				UNLOCK ALL
			ELSE
				DO WHILE !RLOCK()
				ENDDO
				**>>  Vo.Bo. VETT  2008/12/22 15:44:28 
				IF XcSorteo='INGRESOS'
					IF RMOV.CodCta='12'
						REPLACE IMPORTE WITH TRANS(VAL(IMPORTE)+ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)*IIF(RMOV.CodDoc='07',0,1),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)*IIF(RMOV.CodDoc='07',0,1)),0),[###############])
					ELSE
						IF INLIST(RMOV.AFecto,'A','I','N')
							REPLACE IMPORTE WITH TRANS(VAL(IMPORTE)+ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT,-RMOV.IMPORT),0),[###############])
						ENDIF	
					ENDIF	
				ELSE
					IF RMOV.CodCta='42'
						REPLACE IMPORTE WITH TRANS(VAL(IMPORTE)+ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)),0),[###############])
					ELSE
						IF INLIST(RMOV.AFecto,'A','I','N')
							REPLACE IMPORTE WITH TRANS(VAL(IMPORTE)+ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT,-RMOV.IMPORT),0),[###############])
						ENDIF	
					ENDIF	
				ENDIF
				UNLOCK ALL
			ENDIF
			LsCmpMes = 'Mes'+TRANSFORM(RMOV.NroMes,'@L 99')
			**>>  Vo.Bo. VETT  2008/12/22 15:44:44 
			IF XcSorteo='INGRESOS'
				IF RMOV.CodCta='12'
					LfImporte = ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)*IIF(RMOV.CodDoc='07',0,1),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)*IIF(RMOV.CodDoc='07',0,1)),0)
				ELSE	
					IF INLIST(RMOV.AFecto,'A','I','N')
						LfImporte = ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT,-RMOV.IMPORT),0)
					ENDIF
				ENDIF
			ELSE
				IF RMOV.CodCta='42'
					LfImporte = ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT/(1+gosvrcbd.xfporigv/100),-RMOV.IMPORT/(1+gosvrcbd.xfporigv/100)),0)
				ELSE
					IF INLIST(RMOV.AFecto,'A','I','N')
						LfImporte = ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT,-RMOV.IMPORT),0)
					ENDIF	
				ENDIF	
			ENDIF
			REPLACE (LsCmpMes) WITH EVALUATE(LsCmpMes) + LfImporte
			SELE RMOV
		ENDIF
	ENDSCAN
ENDFOR
SELE PDT
LOCATE
SELECT * FROM PDT INTO CURSOR  xxPDT WHERE VAL(IMPORTE)> FPDT.Factor * FPDT.Uit
LnHayReg = RECCOUNT('xxPDT')
SELECT PDT
DELE ALL FOR VAL(IMPORTE)<= FPDT.Factor * FPDT.Uit
PACK
LOCATE
IF XcSorteo='INGRESOS'
	COPY TO C:\TEMP\Ingresos WITH cdx 
ELSE
	COPY TO C:\TEMP\Costos WITH cdx 
ENDIF 
 
SCAN WHILE !EOF() AND LnHayReg>0  
	REPLACE CONTADOR  WITH TRANS(N,[###############])
	N=N+1
ENDSCAN
GO TOP


SCAN WHILE !EOF() AND LnHayReg>0  
	MICADENA=[]
	MICADENA=LTRIM(CONTADOR)+[|]
	MICADENA=MICADENA+TRIM(D_TIPODOC)+[|]
	MICADENA=MICADENA+TRIM(D_NUMDOC)+[|]
	MICADENA=MICADENA+TRIM(PERIODO)+[|]
	MICADENA=MICADENA+TRIM(TIPO_PER)+[|]
	MICADENA=MICADENA+TRIM(TIPO_DOC)+[|]
	MICADENA=MICADENA+TRIM(NUM_DOC)+[|]
	MICADENA=MICADENA+LTRIM(IMPORTE)+[|]
	MICADENA=MICADENA+TRIM(AP_PATER)+[|]
	MICADENA=MICADENA+TRIM(AP_MATER)+[|]
	MICADENA=MICADENA+TRIM(NOMBRE1)+[|]
	MICADENA=MICADENA+TRIM(NOMBRE2)+[|]
	MICADENA=MICADENA+TRIM(RAZON_SOC)+[|]
	SELE TEMP
	APPEN BLANK
	DO WHILE !RLOC()
	ENDDO
	REPLACE CADENA WITH TRIM(MICADENA)
	UNLOCK
	SELE PDT
ENDSCAN
SELE TEMP
GO TOP
COPY TO (PATHUSER)+XSARCHIVO SDF
LnVerReport = 0
IF LnHayReg<=0 
	LnVerReport=MESSAGEBOX('No existe información que cumpla los requisitos de presentacion del DAOT. ¿Desea ver el reporte ?',4+32+256,'Atencion !')
ENDIF
IF LnVerReport=7
	RETURN 
ENDIF	
* Modifcado por VETT 2008/11/14 14:33:32
SELECT PDT
INDEX ON IMPORTE TAG PDt02 DESCENDING
lcRptTxt	= "cbd_cbdf3500"
lcRptGraph	= "cbd_cbdf3500"
lcRptDesc	= "DAOT - "+XcSorteo
LnDS=SET("datasession")
DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , LnDs
**>>  Vo.Bo. VETT  2008/11/14 14:37:09 

RETURN

******************
PROCEDURE MOVAPERT
******************
WAIT WINDOW [Aperturando archivos...] NOWAIT
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV08','')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CBDFLPDT','FPDT','FPDT01','')
LoDatAdm.abrirtabla('ABRIR','PDT3500','PDT','PDT01','EXCL')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV2','RMOV01','')
SELECT PDT
ZAP
IF VARTYPE(MES01)<>'N'
	ALTER table PDT ADD MES01 n(12,2)
ENDIF
IF VARTYPE(MES02)<>'N'
	ALTER table PDT ADD MES02 n(12,2)
ENDIF
IF VARTYPE(MES03)<>'N'
	ALTER table PDT ADD MES03 n(12,2)
ENDIF
IF VARTYPE(MES04)<>'N'
	ALTER table PDT ADD MES04 n(12,2)
ENDIF
IF VARTYPE(MES05)<>'N'
	ALTER table PDT ADD MES05 n(12,2)
ENDIF
IF VARTYPE(MES06)<>'N'
	ALTER table PDT ADD MES06 n(12,2)
ENDIF
IF VARTYPE(MES07)<>'N'
	ALTER table PDT ADD MES07 n(12,2)
ENDIF
IF VARTYPE(MES08)<>'N'
	ALTER table PDT ADD MES08 n(12,2)
ENDIF
IF VARTYPE(MES09)<>'N'
	ALTER table PDT ADD MES09 n(12,2)
ENDIF
IF VARTYPE(MES10)<>'N'
	ALTER table PDT ADD MES10 n(12,2)
ENDIF
IF VARTYPE(MES11)<>'N'
	ALTER table PDT ADD MES11 n(12,2)
ENDIF
IF VARTYPE(MES12)<>'N'
	ALTER table PDT ADD MES12 n(12,2)
ENDIF
SET ORDER TO PDT01   && NUM_DOC

SELE 0
ArcTmp = GoEntorno.TmpPath+Sys(3)
CREATE TABLE (ArcTmp) FREE (cadena c(254))
USE (ArcTmp) ALIAS temp EXCLUSIVE 
WAIT WINDOW [Ok...] NOWAIT
