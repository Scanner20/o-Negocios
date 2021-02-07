**********************************
* Reporte de Aportaciones de AFP *
**********************************
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrtafp
loContab.oDatadm.CloseTable('TSEM')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('TEMPO')
loContab.oDatadm.CloseTable('TEMP1')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlnrtafp
*******************
DIMENSION N(6)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroMES),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RESUMEN DE APORTACIONES A.F.P."
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
********** Inicializando Archivo **********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

LoDatAdm.abrirtabla('ABRIR','PLNMTSEM','TSEM','SEMA01','')
OpcionR  = 1
IF XsCodPln = "1"
	UltTecla = 0
	OpcionR  = 1
	@ 9,10 CLEAR TO 18,67
	@ 9,10       TO 18,67
	@ 12,23 SAY "Elegir : "
	DO WHILE !INLIST(UltTecla,Escape)
		GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
		DO LIB_Mtec with 99
		@ 12,33 GET OpcionR FUNCTION '^ Mensual;Gratificación'
		READ
		UltTecla  = LastKey()
		IF INLIST(UltTecla,Escape,Enter)
			EXIT
		ENDIF
	ENDDO
	IF UltTecla==Escape
		RETURN
	ENDIF
ENDIF
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
SELE TABL
xTipo  = 1
A      = 0
XsTabla = "23"
SEEK XsTabla
COPY REST TO ARRAY XATABLA FOR TABL->CodIGO > "02" WHILE XsTabla = TABL.Tabla FIELD TABL.NomBre,TABL.Codigo
FOR I = 1 TO ALEN(XATABLA,1)
	XATABLA[I,1] = LEFT(XATABLA[I,1],15)
ENDF
@ 05,10 CLEAR TO 15,67
@ 05,10       TO 15,67
@ 05,32  SAY " TIPO DE AFP " COLOR SCHEME 7
@ 08,13 SAY "Elegir Afp  : "
@ 10,15 SAY "Mes : " + " " + TRIM(MES(VAL(XsNroMes),1))
@ 07,27 GET XtIPO PICT '@^' FROM XATABLA
READ
UltTecla = LASTKEY()
IF ULTTECLA = ESCAPE
	RETURN
ENDI
TipoAfp = TRAN(XTIPO + 2,'@L 99')
IF UltTecla = Escape
	RETURN
ENDIF
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CODAFP = TipoAfp
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')

IF XsCodPln = "2" .AND. OpcionR = 2
	DO LLENATEMP
ENDIF

TEMP = SYS(3)
SELE 0
CREATE TABLE &TEMP FREE ( CodPer   C (    6  )  , ;
                        ApePat   C (   20  )  , ;
                        ApeMat   C (   20  )  , ;
                        Nombre   C (   20  )  , ;
                        REMASE   N ( 10,2  )  , ;
                        APOOBL   N ( 10,2  )  , ;
                        SegInv   N ( 10,2  )  , ;
                        ComFja   N ( 10,2  )  , ;
                        ComPor   N ( 10,2  )  , ;
                        N_Ipss   C (   16  )  , ;
                        CodAfp   C (    2  )  , ;
                        Total    N ( 10,4  )  )
USE &TEMP ALIAS TEMPO EXCLU
INDEX ON CodAfp+CodPer TAG CODAFP
SELE PERS
GOTO TOP
DO WHILE ! EOF()
	XCODPER = CODPER
	xApePat  = ApePat
	xApeMat  = ApeMat
	xNomBre  = Nombre
	xCodAfp  = PERS.CodAfp
	xN_Ipss  = PERS.CarAfp
*	XsCodPln = CODPLN
*	if XSCodpln = '1'
		XsNroPer1 = XSNROMES
		XsNroPer2 = XSNROMES
*	ELSE
*		XsNroPer = XsNroSEM
*		XsNroPer = XsNroPerO2
*	ENDI
	WAIT XCODPER + ' - ' + ALLT(XAPEPAT)+' ' + ALLT(XAPEMAT)+', '+ALLT(XNOMBRE) WINDOW NOWAIT
	STOR 0 TO XREMASE,XAPOOBL,XSegInv,XComFja,XComPor
	FOR I = VAL(XsNroPer1) TO VAL(XsNroPer2)
		XSNROPER = TRAN(I,'@L 99')
		IF VALCAL('@SIT') = 5
			STORE 0 TO XREMASE,XAPOOBL,XSegInv,XComFja,XComPor
			EXIT
		ENDI
		IF XSCODPLN=[1]
			DO CASE 
				CASE XSNROPER=[04]
					XREMASE  =  XREMASE + VALCAL("RD03") + VALCAL("VD03")
				CASE XSNROPER=[10]
					XREMASE  =  XREMASE + VALCAL("RD03") + VALCAL("VD03")
				OTHER
					XREMASE  =  XREMASE + VALCAL("RD03") + VALCAL("VD03") + VALCAL("TD01")
			ENDCASE
		ELSE
			DO CASE
				CASE XSNROPER=[17]
					XREMASE  =  XREMASE + VALCAL("RD03") + VALCAL("VD03")
				CASE XSNROPER=[43]
					XREMASE  =  XREMASE + VALCAL("RD03") + VALCAL("VD03")
				OTHER
					XREMASE  =  XREMASE + VALCAL("RD03") + VALCAL("VD03") + VALCAL("TD01")
			ENDCASE
		ENDIF
		XAPOOBL = XAPOOBL + VALCAL("RF01") + VALCAL("VF01") + VALCAL("TF01")
		IF VALCAL([AA02])>VALCAL("RD03") + VALCAL("VD03") + VALCAL("TD01")
*			IF PERS.CODPER=[020115]
*				XSEGINV   = XREMASE * (1.35/100) 
*			ELSE
				XSegInv   = XSegInv + VALCAL("RF03") + VALCAL("VF03") + VALCAL("TF03")
*			ENDIF
		ELSE
*		IF PERS.CODPER=[020115]
*			XSEGINV   = XREMASE * (1.35/100) 
*		ELSE
*			DO CASE
*				CASE PERS.CODAFP=[03]
*					XSegInv = XSegInv + ROUND(VALCAL("AA02"),2) * VALCAL("AE03")/100 * VALCAL("AF03")/100
*				CASE PERS.CODAFP=[05]
*					XSegInv = XSegInv + ROUND(VALCAL("AA02"),2) * VALCAL("AE05")/100 * VALCAL("AF05")/100
*				CASE PERS.CODAFP=[06]
*					XSegInv = XSegInv + ROUND(VALCAL("AA02"),2) * VALCAL("AE06")/100 * VALCAL("AF06")/100
*				CASE PERS.CODAFP=[07]
*					XSegInv = XSegInv + ROUND(VALCAL("AA02"),2) * VALCAL("AE07")/100 * VALCAL("AF07")/100
*				CASE PERS.CODAFP=[08]
*					XSegInv = XSegInv + ROUND(VALCAL("AA02"),2) * VALCAL("AE08")/100 * VALCAL("AF08")/100
*				ENDCASE
			XSegInv = XSegInv + ROUND(VALCAL("AA02"),0) * VALCAL("AE"+xCodAfp)/100
		ENDIF
*		ENDIF
		XComFja   = XComFja + VALCAL("RF04") + VALCAL("VF04") + VALCAL("TF04")
*		IF PERS.CODPER=[040009]
*			XCOMPOR   = XREMASE * (2.35/100) 
*		ELSE 
		XComPor = XComPor + VALCAL("RF05") + VALCAL("VF05") + VALCAL("TF05")
*		ENDI
	ENDF
	IF XREMASE > 0
		SELE TEMPO
		APPE BLANK
		REPL CodPer WITH XCODPER
		REPL ApePat WITH xApePat
		REPL ApeMat WITH xApemat
		REPL Nombre WITH XNOMBRE
		REPL REMASE WITH XREMASE
		REPL APOOBL WITH XAPOOBL
		REPL SegInv WITH XSegInv
		REPL ComFja WITH XComFja
		REPL ComPor WITH XComPor
		REPL N_Ipss WITH xN_Ipss
		REPL CodAfp WITH XCODAFP
	ENDI
	SELE PERS
	SKIP
ENDDO
SELE TEMPO
GO TOP
DO LIB_MTEC WITH 13
Largo  = 66
*** IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_pRN8A]
IniPrn = [_Prn4+_PRN8A]
xWhile = []
xFor   = []
sNomRep = "PLN_PL_RTAFP"
DO F0PRINT WITH "REPORTS"
DELETE FILE &TEMP.'.DBF'
DELETE FILE &TEMP.'.CDX'
RETURN

***************
FUNCTION SEMVAL
***************
PRIVATE wSemanas
wSemanas=""
SELE TSEM
LOCATE FOR MES=XsNroMes
DO WHILE MES=XsNroMes
	wSemanas=wSemanas+TSEM->SEMA+","
	SKIP
ENDDO
wSemanas=SUBSTR(wSemanas,1,LEN(wSemanas)-1)
SELE DMOV
RETURN wSemanas

*******************
PROCEDURE LLENATEMP
*******************
SELE DMOV
XlPosSem=SemVal()
ArcTmp = PathUser+sys(3)+".dbf"
COPY TO (ArcTmp) FOR NROPER $ XlPosSem AND XsCodPln=DMOV->CODPLN

SELE 0
USE (ArcTmp) ALIAS TEMP1 EXCL

SELE TEMP1
REPLA ALL NROPER WITH XsNroPer
INDEX ON CODPLN+CODPER+CODMOV TAG DMOV04

TOTAL ON CODPLN+CODPER+CODMOV TO TOTDMOV

SELE dmov
USE TOTDMOV ALIAS DMOV
IF !USED()
	RETURN
ENDIF
INDEX ON CODPLN+NROPER+CODPER+CODMOV+STR(VALREF,6,0) TAG DMOV01
INDEX ON CODPLN+NROPER+CODMOV+CODPER TAG DMOV02
INDEX ON CODPLN+CODPER TAG DMOV03
SET ORDER TO DMOV01
RETURN

****************
FUNCTION NROSEMA
****************
PARAMETER wNro
PRIVATE wSem
wSem = SUBSTR(XlPosSem+"    ",wNro*2-1,2)
RETURN wSem