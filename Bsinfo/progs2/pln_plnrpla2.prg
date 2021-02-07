DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrpla2
loContab.oDatadm.CloseTable('BPGO')
loContab.oDatadm.CloseTable('TABL')
loContab.oDatadm.CloseTable('TMOV')
loContab.oDatadm.CloseTable('DMOV')
loContab.oDatadm.CloseTable('PERS')
loContab.oDatadm.CloseTable('TSEM')
loContab.oDatadm.CloseTable('SEDE')
RELEASE LoContab
RELEASE LoDatAdm
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF

*******************
PROCEDURE xPlnrpla2
*******************
cTit1 = "Boleta de Pagos"
cTit2 = MES(VAL(XsNroPer),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = GsNomCia
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos*********
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
Srepor = 1
GiMaxEle = 0
UltTecla = 0
@ 9,10 CLEAR TO 18,67
@ 9,10       TO 18,67
@ 11,13 SAY "Planilla   : "
@ 12,13 SAY "Mes        : "
LsNroPer=XsNroPer
DO WHILE .T.
	IF XsCodPln=[2]
		VecOpc(1) = "Semanal"
	ELSE
		VecOpc(1) = "Normal"
	ENDIF
	VecOpc(2) = "Vacaciones"
	VecOpc(3) = "Gratificaciones"
	Srepor    = Elige(Srepor,11,26,3)
	IF UltTecla = Escape
		EXIT
	ENDIF
	@ 12,13 SAY "Mes        :" GET LsNroPer PICT "99"
	READ
	UltTecla = LASTKEY()
	EXIT
ENDDO
IF UltTecla = Escape
	RETURN
ENDIF

DO F0PRINT
IF LASTKEY() = ESCAPE
	RETURN
ENDIF
Largo    = 33       && Largo de pagina
LinFin   = 33 - 2
IniImp   =_PRN5A+CHR(LARGO)+_PRN8B
Ancho    = 202
Numpag   = 0
Tit_SIzq = _PRN6A+alltrim(GsNomCia)+_PRN6B
Tit_SDer = "Fecha : "+DTOC(DATE())
Tit_IIzq = GsDirCia
Titulo   = []
SubTitulo= "PLANILLA DE SUELDOS  DE "+LEFT(MES(VAL(XSNroMes),3),9)+" DE "+TRANS(_ANO,'9,999')+" NRO. DE R.U.C. "+GSRUCCIA
En1    = "R.U. 92C9758"
En2    = IIF(SREPOR=3,_PRN6A+[G R A T I F I C A C I O N]+_PRN6B,[])
En3    = [ÿ]
En4    = "ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
En5    = "บCODIGO  APELLIDOS Y NOMBRES                      No. DE D.N.I.     C A R G O                                    PERIODO  VACACIONAL    FECHA  DE   FECHA DE                                              บ"
En6    = "บ                                                                                                                INGRESO  -  RETORNO     INGRESO      CESE                                                บ"
En7    = "ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
En8    =  []
En9    =  []
*          xxxxx 7xxxxxxxx0xxxxxxxxx0xxxxxxxxx0 38X 42x 46xxxxx 54x 58xXXXXXXXX 70xXXXXXX0XXXXXXXXX0XXXXXXX 98xxXXXXXXXXXX 113xXXXXXXXXXX
*          123456 123456789012345678901234567890 1234568890123456789012345 12345678901234567890 1234567890123456789012345 123456789 123456789 1234567890 1234567890123456  28
*          1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
DIMENSION vcodmo1(40),vdescr1(40),vmont1(40),vflgcal1(40)
DIMENSION vcodmo2(40),vdescr2(40),vmont2(40),vflgcal2(40)
DIMENSION vcodmo3(40),vdescr3(40),vmont3(40),vflgcal3(40)
DIMENSION vcodmo4(40),vdescr4(40),vmont4(40),vflgcal4(40)
DIMENSION vlinea(2)
STORE 0 TO TTot01,TTot02,TTot03,TTot04
STORE 0 TO tmont1,tmont4
UltTecla = 0
ImpFin = .f.

ArcTmp = PathUser+sys(3)+".dbf"

LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
DO CASE
	CASE SREPOR=1
		SET FILTER TO CODPLN=XSCODPLN .AND. MESVAC<>LSNROPER
	CASE SREPOR=2
		SET FILTER TO CODPLN=XSCODPLN .AND. MESVAC=LSNROPER
	CASE SREPOR=3
		SET FILTER TO CODPLN=XSCODPLN
ENDCASE
GO TOP
SELE 0
DO CASE
	CASE XSCODPLN=[1]
		LoDatAdm.abrirtabla('ABRIR','PLNCFGP1','BPGO','CFGP101','')
	CASE XSCODPLN=[2]
		LoDatAdm.abrirtabla('ABRIR','PLNCFGP2','BPGO','CFGP201','')
	CASE XSCODPLN=[3]
		LoDatAdm.abrirtabla('ABRIR','PLNCFGP3','BPGO','CFGP301','')
ENDCASE
DO CASE
	CASE SREPOR=1
		COPY TO (ArcTmp) FOR TPOVAR$"1234"
	CASE SREPOR=2
		COPY TO (ArcTmp) FOR TPOVAR$"ABCD"
	CASE SREPOR=3
		COPY TO (ArcTmp) FOR TPOVAR$"6789"
ENDCASE
IF USED("BPGO")
	SELECT BPGO
	USE
ENDIF
SELECT 0
USE (ArcTmp) ALIAS BPGO EXCL
SELECT BPGO
INDEX ON TPOVAR+STR(NROITM,4,0)+CODMOV TAG BPGO01
REPLACE ALL ValAcm WITH 0

SELECT PERS
GOTO TOP
REGACT=RECNO()
Cancelar = .F.
SET DEVICE TO PRINT
PRINTJOB
	Inicio = .T.
	GO REGACT
	DO FORMATO
	EJECT PAGE
ENDPRINTJOB
SET DEVICE TO SCREEN
DO F0PRFIN
SELECT BPGO
USE
DELETE FILE (ArcTmp)
RETURN

*****************
PROCEDURE FORMATO
*****************
DO WHILE !EOF()  .AND. ! Cancelar
	xSitPer = VALCAL("@SIT")
	IF xSITPER=5
		SKIP
		LOOP
	ENDIF
	STORE 0 TO n1,n2,n3,n4,xTot01,xTot02,xTot03,xTot04
	IF CTOD("  /  /  ") <> FchNac
		xEdad = INT( ( VAL(DTOC(DATE(),1))-VAL(DTOC(FchNac,1)) )/10000 )
	ELSE
		xEdad = 00
	ENDIF
	=SEEK("02"+PERS->CODSEC,"TABL")
	SECCION=TABL->NOMBRE
	=SEEK('04'+PERS.CodCar,'TABL')
	cNomCar = LEFT(TABL.Nombre,25)
	nNroDias = VALCAL("BA01") - VALCAL("BA10")
	VLINEA(1)=' '+CODPER+'  '+LEFT(NOMBRE(),40)+' '+LEFT(N_IPSS,16)+'  '+cNomCar+' '+SPACE(17)+'   '+DTOC(FVACIN)+'   '+DTOC(FVACFI)+'    '+DTOC(FCHING)+'    '+DTOC(FCHCES)
	DO INGRESOS       && 1
	DO IMPUESTOS      && 2
	DO DESCUENT       && 3
	DO APORTES        && 4
	DO IMPRIME WITH []
	TTot01 = TTot01 + xTot01
	TTot02 = TTot02 + xTot02
	TTot03 = TTot03 + xTot03
	TTot04 = TTot04 + xTot04
	SELE PERS
	SKIP
ENDDO
RETURN
******************
PROCEDURE INGRESOS
******************
SELE BPGO
GOTO TOP
DO WHILE !EOF()
	IF TpoVar # '1' .AND. TPOVAR # 'A' .AND. TPOVAR # '6'
		SKIP
		LOOP
	ENDIF
	SELE TMOV
	SEEK BPGO->CODMOV
	SELE DMOV
	XfValCal = VALCAL(BPGO->CODMOV)
	IF ! EMPTY(BPGO->CODREF)
		XsValRef = ALLTRIM(STR(VALCAL(BPGO->CODREF),12,2))
		IF RIGHT(XsValRef,1)="0"
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
		ENDIF
		IF RIGHT(XsValRef,1)="0"
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
		ENDIF
		XsValRef = " "+XsValRef
	ELSE
		XsValRef = ""
	ENDIF
	xTot01 = xTot01 + XfVALCAL
	n1     = n1 + 1
	vcodmo1(n1)=  BPGO->CODMOV
	vdescr1(n1)=  LEFT(TRIM(UPPER(TMOV->DESMOV))+XsValRef,23)
	vmont1(n1) =  XfVALCAL
	SELE BPGO
	vflgcal1(n1) =  BPGO.FlgCal
	REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
	SELE BPGO
	SKIP
ENDDO
RETURN

*******************
PROCEDURE IMPUESTOS
*******************
SELE BPGO
GO TOP
DO WHILE !EOF()
	IF TpoVar # '2'  .AND. TPOVAR # 'B' .AND. TPOVAR # '7'
		SKIP
		LOOP
	ENDIF
	SELE TMOV
	SEEK BPGO->CODMOV
	SELE DMOV
	XfValCal = VALCAL(BPGO->CODMOV)
	IF ! EMPTY(BPGO->CODREF)
		XsValRef = ALLTRIM(STR(VALCAL(BPGO->CODREF),12,2))
		IF RIGHT(XsValRef,1)="0"
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
		ENDIF
		IF RIGHT(XsValRef,1)="0"
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
		ENDIF
		XsValRef = " "+XsValRef
	ELSE
		XsValRef = ""
	ENDIF
	IF XfValCAL#0
		xTot02 = xTot02 + XfVALCAL
		n2     = n2 + 1
		vcodmo2(n2)=  BPGO->CODMOV
		vdescr2(n2)=  LEFT(TRIM(UPPER(TMOV->DESMOV))+XsValRef,23)
		vmont2(n2) =  XfVALCAL
		SELE BPGO
		vflgcal2(n2) =  BPGO.FlgCal
		REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
	ENDIF
	SELE BPGO
	SKIP
ENDDO

******************
PROCEDURE DESCUENT
******************
SELE BPGO
GO TOP
DO WHILE !EOF()
	IF TpoVar # '3' .AND. TPOVAR # 'C' .AND. TPOVAR # '8'
		SKIP
		LOOP
	ENDIF
	SELE TMOV
	SEEK BPGO->CODMOV
	SELE DMOV
	zLLave = XsCodPln+LsNroPer+PERS->CodPer+BPGO->CODMOV
	SEEK zLlave
	DO WHILE ! EOF() .AND. CodPln+NroPer+CodPer+CODMOV = zLlave
		XfValCal = VALCAL
		XsValRef = ""
		IF VALREF <> 0
			XsValRef = ALLTRIM(STR(VALREF,12,2))
		ELSE
			IF ! EMPTY(BPGO->CODREF)
				XsValRef = ALLTRIM(STR(VALCAL(BPGO->CODREF),12,2))
			ENDIF
		ENDIF
		IF ! EMPTY(XsValref)
			IF RIGHT(XsValRef,1)="0"
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
			ENDIF
			IF RIGHT(XsValRef,1)="0"
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
			ENDIF
			XsValRef = " "+XsValRef
		ENDIF
		IF XfValCAL#0
			xTot03 = xTot03 + XfVALCAL
			n3     = n3 + 1
			vcodmo3(n3)=  BPGO->CODMOV
			vdescr3(n3)=  LEFT(TRIM(UPPER(TMOV->DESMOV))+XsValRef,23)
			vmont3(n3) =  XfVALCAL
			SELE BPGO
			vflgcal3(n3) =  BPGO.FlgCal
			REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
		ENDIF
		SELECT DMOV
		SKIP
	ENDDO
	SELE BPGO
	SKIP
ENDDO
RETURN

*****************
PROCEDURE APORTES
*****************
SELE BPGO
GO TOP
DO WHILE !EOF()
	IF TpoVar # '4' .and. TpoVar # 'D' .AND. TPOVAR # '9'
		SKIP
		LOOP
	ENDIF
	SELE TMOV
	SEEK BPGO->CODMOV
	SELE DMOV
	XfValCal = VALCAL(BPGO->CODMOV)
	IF ! EMPTY(BPGO->CODREF)
		XsValRef = ALLTRIM(STR(VALCAL(BPGO->CODREF),12,2))
		IF RIGHT(XsValRef,1)="0"
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
		ENDIF
		IF RIGHT(XsValRef,1)="0"
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
		ENDIF
		XsValRef = " "+XsValRef
	ELSE
		XsValRef = ""
	ENDIF
	xTot04 = xTot04 + XfVALCAL
	n4     = n4 + 1
	vcodmo4(n4)=  BPGO->CODMOV
	vdescr4(n4)=  LEFT(TRIM(UPPER(TMOV->DESMOV))+XsValRef,23)
	vmont4(n4) =  XfVALCAL
	SELE BPGO
	vflgcal4(n4) =  BPGO.FlgCal
	REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
	SELE BPGO
	SKIP
ENDDO
RETURN

*****************
PROCEDURE IMPRIME
*****************
PARAMETER xTit
n=0
tt=iif(n1>n2,n1,n2)
tt=iif(tt>n3,tt,n3)
tt=iif(tt>n4,tt,n4)
n5=n4+3
IF LinFin <= PROW() .OR. Inicio
	Inicio = .F.
	DO F0MBPRN
	IF UltTecla = Escape
		Cancelar = .T.
		EXIT
	ENDIF
ENDIF
IF ImpFin
	@ PROW()+2,0 SAY xTit
	@ PROW()+2,0 SAY []
ENDIF
IF ! ImpFin
	@ PROW()+1,0   SAY VLINEA(1)
*!*		@ PROW()+1,0   SAY VLINEA(2)
	@ PROW()+1,0   SAY []
	@ PROW()+1,0 SAY  "ษออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออป"
	@ PROW()+1,0 SAY  "บ      R E M U N E R A C I O N E S       บ          R E T E N C I O N E S         บ          D E S C U E N T O S           บ             A P O R T E S            บ              N E T O   A              บ"
	@ PROW()+1,0 SAY  "ฬออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออออออออออออออออออออออฮอออออออออออออออออออออออออออออออออออออออน"
ENDIF

IF ! ImpFin .AND. xSitPer > 1
	@ PROW()+1,10 SAY _Prn7a+SITPER()+_PRN7B
ENDIF
STORE 0 TO xTot01,xTot02,xTot03,xTot04
DO WHILE tt>=n
	IF LinFin <= PROW() .OR. Inicio
		Inicio = .F.
		DO F0MBPRN IN F0PRINT
		IF LASTKEY() = 27
			Cancelar = .T.
			EXIT
		ENDIF
	ENDIF
	n=n+1
	@ PROW()+1,0  SAY 'บ'
	IF n<=n1
		@ prow()  ,2   say vcodmo1(n)
		@ prow()  ,7   say vdescr1(n)
		@ prow()  ,30  say vmont1(n)   PICT "999,999.99"
		xTot01 = xTot01 + IIF(vFlgCal1(n),vmont1(n),0)
	ENDIF
	@ PROW()  ,41  SAY 'บ'
	IF n<=n2
		@ prow()  ,43  say vcodmo2(n)
		@ prow()  ,48  say vdescr2(n)
		@ prow()  ,71  say vmont2(n)   PICT "999,999.99"
		xTot02 = xTot02 + IIF(vFlgCal2(n),vmont2(n),0)
	ENDIF
	@ PROW()  ,82  SAY 'บ'
	IF n<=n3
		@ prow()  ,84  say vcodmo3(n)
		@ prow()  ,89  say vdescr3(n)
		@ prow()  ,112 say vmont3(n)    PICT "999,999.99"
		xTot03 = xTot03 + IIF(vFlgCal3(n),vmont3(n),0)
	ENDIF
	@ PROW()  ,123 SAY 'บ'
	IF n<=n4
		@ prow()  ,125 say vcodmo4(n)
		@ prow()  ,130 say vdescr4(n)
		@ prow()  ,151 say vmont4(n)  PICT "999,999.99"
		xTot04 = xTot04 + IIF(vFlgCal4(n),vmont4(n),0)
	ENDIF
	@ PROW()  ,162 SAY 'บ'
	IF n=n4+4
		@ prow() ,170 say '---------------------'
	ENDIF
	IF n=n4+5
		@ prow(), 170 say '      F I R M A      '
	ENDIF
	@ PROW()  ,202 SAY 'บ'
ENDDO
@ PROW()+1,0  SAY 'บ'
@ PROW()       ,07  SAY  "TOTAL REMUNERACION: "
@ PROW()       ,28  SAY  XTot01   PICT "9,999,999.99"
@ PROW()  ,41  SAY 'บ'
@ PROW()       ,50  SAY  "TOTAL RETENCION "
@ PROW()       ,69  SAY  xTot02   PICT "9,999,999.99"
@ PROW()  ,82  SAY 'บ'
@ PROW()       ,90  SAY  "TOTAL DESCUENTO "
@ PROW()       ,110 SAY  xTot03   PICT "9,999,999.99"
@ PROW()  ,123 SAY 'บ'
@ PROW()       ,130 SAY "TOTAL APORTES "
@ PROW()       ,149 SAY  xTot04   PICT "9,999,999.99"
xNeto = xTot01 -(xTot02+xTot03)
@ PROW()  ,162 SAY 'บ'
@ PROW()       ,170 SAY  "NETO        : "
@ PROW()       ,189 SAY  xneto    PICT "9,999,999.99"
@ PROW()  ,202 SAY 'บ'
@ PROW()+1,0 SAY  "ศออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออออออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออผ"
@ 32,0 SAY []
Cancelar = (INKEY() = Escape)
RETURN

*****************
PROCEDURE IMP_TOT
*****************
SELE BPGO
*!*	Ingresos
GO TOP
STORE 0 TO n1
DO WHILE !EOF()
	IF TPOVAR#'1' .and. TPOVAR#'A'
		SKIP
		LOOP
	ENDIF
	IF VALACM # 0
		SELE TMOV
		SEEK BPGO->CODMOV
		SELE BPGO
		n1=n1+1
		vcodmo1(n1)=CODMOV
		vdescr1(n1)=LEFT(UPPER(TMOV->DESMOV),20)
		vmont1(n1) =VALACM
	ENDIF
	SKIP
ENDDO
*!*	Impuestos
GO TOP
STORE 0 TO n2
DO WHILE !EOF()
	IF TPOVAR#'2' .AND. TPOVAR#'B'
		SKIP
		LOOP
	ENDIF
	IF VALACM # 0
		SELE TMOV
		SEEK BPGO->CODMOV
		SELE BPGO
		n2=n2+1
		vcodmo2(n2)=CODMOV
		vdescr2(n2)=LEFT(UPPER(TMOV->DESMOV),20)
		vmont2(n2) =VALACM
	ENDIF
	SKIP
ENDDO
*!*	Descuentos
GO TOP
STORE 0 TO n3
DO WHILE !EOF()
	IF TPOVAR#'3'  .AND. TPOVAR#'C'
		SKIP
		LOOP
	ENDIF
	IF VALACM # 0
		SELE TMOV
		SEEK BPGO->CODMOV
		SELE BPGO
		n3=n3+1
		vcodmo3(n3)=CODMOV
		vdescr3(n3)=LEFT(UPPER(TMOV->DESMOV),20)
		vmont3(n3) =VALACM
	ENDIF
	SKIP
ENDDO
*!*	Aportes
GO TOP
STORE 0 TO n4
DO WHILE !EOF()
	IF TPOVAR#'4' .AND. TPOVAR#'D'
		SKIP
		LOOP
	ENDIF
	IF VALACM # 0
		SELE TMOV
		SEEK BPGO->CODMOV
		SELE BPGO
		n4=n4+1
		vcodmo4(n4)=CODMOV
		vdescr4(n4)=LEFT(UPPER(TMOV->DESMOV),18)
		vmont4(n4) =VALACM
	ENDIF
	SKIP
ENDDO
Inicio = .t.
ImpFin = .t.
DO IMPRIME  WITH  _Prn7a+'R E S U M E N     G E N E R A L    E M P L E A D O S'+_Prn7b
RETURN
*
*   *******************************************************************************************************************************************************************"
*   *COD.TRABAJ.     APELLIDOS Y NOMBRES           DIRECCION                NACIONALIDAD     F.INGRESO     L.ELECT.    IPSS           EDAD                            *"
*   *                CARGO                                                                                                                                            *"
*   *******************************************************************************************************************************************************************"
*   *          H A B E R E S                 *      R E T E N C I O N E S             *        D E S C U E N T O S             *          A P O R T E S               *"
*   *COD.  DESCRIPCION               IMPORTE *COD.  DESCRIPCION               IMPORTE *COD.  DESCRIPCION               IMPORTE *COD.  DESCRIPCION             IMPORTE *"
*   *******************************************************************************************************************************************************************"
*   * 1234 12345678901234567890 9,999,999.99 * 1234 12345678901234567890 9,999,999.99 * 1234 12345678901234567890 9,999,999.99 * 1234 123456789012345678 9,999,999.99 *
