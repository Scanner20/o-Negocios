***********************************************************
* PROGRAMA   : CBDRF3500.PRG                              *
* OBJETO     : TRANSFERIR ARCHIVOS DE CONTABILIDAD AL PDT *
* AUTOR      : MAAV                                       *
* CREACION   : 02/08/2001                                 *
***********************************************************
PARAMETER FORM
** APERTURAMOS ARCHIVOS **

DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')

DO MOVAPERT && PROGRAMA DE APERTURA
*!* FINALIZAMOS APERTURA

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "FORMULARIO 3500"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
ULTTECLA=0
SORTEO = 1
@  9,15 FILL  TO 19,62      COLOR W/N
@  8,16 CLEAR TO 18,63
@  8,16       TO 18,63
@ 10,25 SAY "Generar      : " GET Sorteo PICT "@^ COSTOS;INGRESOS"
READ
IF SORTEO = 1
	XCSORTEO = [COSTOS]
	SELE FPDT
	SEEK FORM+XCSORTEO
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
	XSCODOPE = CODOPE
	XSARCHIVO = XCSORTEO+[.TXT]
	@ 14,23 SAY "Nombre de Archivo   : " GET XSARCHIVO
	READ
ELSE
	XCSORTEO = [INGRESOS]
	SELE FPDT
	SEEK FORM+XCSORTEO
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
	XSCODOPE = CODOPE
	XSARCHIVO = XCSORTEO+[.TXT]
	@ 14,23 SAY "Nombre de Archivo   : " GET XSARCHIVO
	READ
ENDIF
@ 14,23 SAY "Nombre de Archivo   : " + XSARCHIVO
@ 15,23 SAY "C¢digo de Operacion : " + XSCODOPE
ULTTECLA=LASTKEY()
IF ULTTECLA = K_Esc
	RETURN
ELSE
	DO GENERA
ENDIF

loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('RMOV')
loContab.oDatadm.CloseTable('AUXI')
loContab.oDatadm.CloseTable('OPER')
loContab.oDatadm.CloseTable('FPDT')
loContab.oDatadm.CloseTable('PDT')
loContab.oDatadm.CloseTable('TEMP')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

****************
PROCEDURE GENERA
****************
N=1
FOR Z = 1 TO NumCta
	XsCodCta = TRIM(xxCodCta(Z))
	SELECT RMOV
	SEEK XSCODCTA
	SCAN WHILE XSCODCTA = LEFT(CODCTA,3)
		IF NroMes<> "00" AND CodOpe = XsCodOpe
			WAIT WINDOW [Procesando : ]+NROAST+[ de ]+UPPER(MES(VAL(NROMES))) NOWAIT
			XSCLFAUX = RMOV.CLFAUX
			XSCODAUX = RMOV.CODAUX
			IF INLIST(XsCodAux,"20999","21022","20074")
				XSRUCAUX=RMOV.NRORUC
				XSNOMAUX=RMOV.GLODOC
				DO CASE
					CASE LEFT(XSRUCAUX,2)=[10]
						XSRUCAUX=SUBSTR(XSRUCAUX,3,8)
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
						*XSRUCAUX=SUBSTR(XSRUCAUX,3,8) Aromas del Peru
						XSTIPO_PER=[01]
						XSTIPO_DOC=[6]
						*XSTIPO_DOC=[1] Aromas del Peru
					CASE LEFT(XSRUCAUX,2)=[20]
						XSTIPO_PER=[02]
						XSTIPO_DOC=[6]
					OTHER
						XSTIPO_PER=[03]
						XSTIPO_DOC=[-]
				ENDCASE
			ENDIF
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
				IF SORTEO=2
					REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT/1.19,-RMOV.IMPORT/1.19),0),[###############])
				ELSE
					REPLACE IMPORTE WITH TRANS(ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT/1.19,-RMOV.IMPORT/1.19),0),[###############])
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
				IF SORTEO=2
					REPLACE IMPORTE WITH TRANS(VAL(IMPORTE)+ROUND(IIF(RMOV.TPOMOV=[D],RMOV.IMPORT/1.19,-RMOV.IMPORT/1.19),0),[###############])
				ELSE
					REPLACE IMPORTE WITH TRANS(VAL(IMPORTE)+ROUND(IIF(RMOV.TPOMOV=[H],RMOV.IMPORT/1.19,-RMOV.IMPORT/1.19),0),[###############])
				ENDIF
				UNLOCK ALL
			ENDIF
			SELE RMOV
		ENDIF
	ENDSCAN
	SELE PDT
	GO TOP
	DELE ALL FOR VAL(IMPORTE)<= FPDT.Factor * FPDT.Uit
	PACK
	GO TOP
	SCAN WHILE !EOF()
		REPLACE CONTADOR  WITH TRANS(N,[###############])
		N=N+1
	ENDSCAN
	GO TOP
ENDFOR
SCAN WHILE !EOF()
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
SELECT PDT
ZAP
SELE 0
ArcTmp = GoEntorno.TmpPath+Sys(3)
CREATE TABLE (ArcTmp) FREE (cadena c(254))
USE (ArcTmp) ALIAS temp
WAIT WINDOW [Ok...] NOWAIT
