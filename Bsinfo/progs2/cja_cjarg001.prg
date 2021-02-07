CLEAR
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
Escape = 27

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RELACION DE CHEQUES GIRADOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

DO Listar
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('CTAS')
loContab.oDatadm.CloseTable('VMOV')
loContab.oDatadm.CloseTable('OPER')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

****************
PROCEDURE Listar
****************
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
SET RELATION TO "04"+CODBCO INTO TABL
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV02','')
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')

@  6,10 FILL  TO 15,88      COLOR W/N
@  7,11 CLEAR TO 14,89
@  7,11       TO 14,89
SELECT OPER
XsNroMes = TRANSFORM(_mes,"@l ##")
XdFchAstD = CTOD("01/"+TRANSFORM(_MES,"@L 99")+"/"+STR(_ano,4,0))
XdFchAstH = CTOD("01/"+TRANSFORM(_MES+1,"@L 99")+"/"+STR(_ano,4,0)) - 1
*----- Control de Egresos de Caja ----* vett 12-abr-2000
SELE OPER
SET FILTER TO MOVCJA=2
LOCATE
XsCodOpe=CodOpe
SEEK XsCodOpe
IF CodOpe = XsCodOpe
	XiNroRel = OPER->NroRel
ELSE
	XiNroRel = 1
ENDIF


@ 08,18 SAY "                  OPERACION : "
@ 10,18 SAY "             NRO. RELACIÓN  : "
@ 11,18 SAY "                     DESDE	 : "
@ 12,18 SAY "                     HASTA  : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
	DO CASE
		CASE i = 1
			SELE OPER
			@ 08,48 GET XsCodOpe
			READ
			UltTecla = LASTKEY()
			IF UltTecla = Escape_
				EXIT
			ENDIF
			IF UltTecla = F8
				IF !CBDBUSCA("OPER")
					UltTecla = 0
					LOOP
				ENDIF
				XsCodOpe = OPER->CodOpe
				UltTecla = ENTER
			ENDIF
			SEEK XsCodOpe 
			IF !FOUND() AND !EMPTY(XsCodOpe)
				GsMsgErr = "Operación "+XsCodOpe+" no registrada"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			@ 08,48 SAY XsCodOpe +' '+OPER.NomOpe PICT "@S50"
		CASE i = 2
			@ 10,48 GET XiNroRel PICTURE "@L 999999"
			READ
			UltTecla = LASTKEY()
		CASE i = 3
			@ 11,48 GET XdFchAstD PICTURE "@RD dd/mm/aa"
			READ
			UltTecla = LASTKEY()
		CASE i = 4			
			@ 12,48 GET XdFchAstH PICTURE "@RD dd/mm/aa"
			READ
			UltTecla = LASTKEY()
	ENDCASE
	DO CASE
		CASE UltTecla = Arriba
			i = IIF( i > 4 , i - 1 , 1)
		CASE UltTecla = Abajo
			i = IIF( i< 4 , i + 1, 1 )
		CASE UltTecla = Enter
			IF  i < 4
				i = i + 1
			ELSE
				EXIT
			ENDIF
	ENDCASE
ENDDO
XsCodOpe=TRIM(XsCodOpe)
SELECT VMOV
SET RELATION TO CTACJA INTO CTAS
SET RELATION TO CODOPE INTO OPER ADDITIVE
SET FILTER TO codope==OPER.codope
IF XiNroRel>0  && Puntero segun nro relacion
	XsNroRel = PADR(TRANSF(XiNroRel,"@L 999999"),LEN(NROVOU))
	SEEK XsNroMes+XsCodOpe+XsNroRel
	xWhile = [NroMes+CodOpe+NroVou = XsNroMes+XsCodOpe+XsNroRel]
	xFor   = [!EMPTY(VMOV->CTACJA) AND FchAst>=XdFchAstD AND FchAst<=XdFchAstH]
ELSE  && Puntero segun Operacion y Fecha
	SEEK XsNroMes+XsCodOpe
	xWhile = [NroMes+CodOpe = XsNroMes+XsCodOpe]	
	xFor   = [!EMPTY(VMOV->CTACJA) AND FchAst>=XdFchAstD AND FchAst<=XdFchAstH]
ENDIF	
IF !FOUND()
	GsMSgErr="Fin De Archivo"
	DO LIB_MERR WITH 99
	RETURN
ENDIF
Largo  = 36
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn2]
*!*	xWhile = [NroMes+CodOpe+NroVou = XsNroMes+XsCodOpe+XsNroRel]
*!*	xFor   = [!EMPTY(VMOV->CTACJA)]
sNomRep = "CJA_CJARG001"
xNomRep = "CJA_CJARGP01"
DO F0PRINT WITH "REPORTS"
RETURN
