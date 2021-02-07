XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005

goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')

DO FORM pln_plnrebol

********************
PROCEDURE Genera_Bol
********************
Tit_SIzq = ALLTRIM(GsNomCia)
Tit_IIzq = GsDirCia
Tit_SDer = "Fecha : " + DTOC(DATE())
SubTitulo= "Boleta de Pago del Mes de "+LEFT(MES(VAL(XsNroMes),3),9)+" DE "+TRANS(_ANO,'9,999')+" R.U.C. "+GsRucCia
DIMENSION vcodmo1(40),vdescr1(40),vmont1(40),vflgcal1(40)
DIMENSION vcodmo2(40),vdescr2(40),vmont2(40),vflgcal2(40)
DIMENSION vcodmo3(40),vdescr3(40),vmont3(40),vflgcal3(40)
DIMENSION vcodmo4(40),vdescr4(40),vmont4(40),vflgcal4(40)
DIMENSION vlinea(2)
STORE 0 TO TTot01,TTot02,TTot03,TTot04
STORE 0 TO tmont1,tmont4

ArcTmp = PathUser+sys(3)+".dbf"

goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
DO CASE
	CASE INLIST(SREPOR,1,2)
		SET FILTER TO CODPLN=XSCODPLN .AND. MESVAC<>LSNROPER
	CASE SREPOR=3
		SET FILTER TO CODPLN=XSCODPLN .AND. MESVAC=LSNROPER
	CASE SREPOR=4
		SET FILTER TO CODPLN=XSCODPLN
ENDCASE
GO TOP
SELE 0
DO CASE
	CASE XsCodPln = [1]
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = [2]
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = [3]
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
ENDCASE
DO CASE
	CASE INLIST(SREPOR,1,2)
		COPY TO (ArcTmp) FOR TPOVAR$"12345"
	CASE SREPOR=3
		COPY TO (ArcTmp) FOR TPOVAR$"5ABCD"
	CASE SREPOR=4
		COPY TO (ArcTmp) FOR TPOVAR$"56789"
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

wait window "Un Momento por favor..." timeout .25

ArcTmp2 = PathUser+sys(3) && para el detalle
*!*	Para Detalle
SELECT 0
CREATE TABLE (ArcTmp2) FREE ( CodPer c(LEN(PERS.CodPer)),;
							  Orden_I c(3),;
							  Orden_D c(3),;
							  Orden_A c(3),;
							  CodMov_I c(LEN(TMOV.CodMov)),;
							  DesMov_I c(LEN(TMOV.DesMov)),;
							  MonMov_I n(16,2),;
							  CodMov_D c(LEN(TMOV.CodMov)),;
							  DesMov_D c(LEN(TMOV.DesMov)),;
							  MonMov_D n(16,2),;
							  CodMov_A c(LEN(TMOV.CodMov)),;
							  DesMov_A c(LEN(TMOV.DesMov)),;
							  MonMov_A n(16,2),;
							  MonTot n(16,2) )

USE (Arctmp2) ALIAS DetBol
INDEX ON CodPer+Orden_I+Orden_D+Orden_A TAG dbol01

wait window "Un Momento por favor....." timeout .25

ArcTmp1 = PathUser+sys(3) && para la cabecera

*!*	Para Cabecera
SELECT 0
CREATE TABLE (ArcTmp1) FREE ( CodPer c(LEN(PERS.CodPer)),;
							  NomPer c(LEN(PERS.NomPer)),;
							  lElect c(LEN(PERS.lElect)),;
							  NomSed c(20),;
							  CarPer c(40),;
							  FchIng d(8),;
							  FchCes d(8),;
							  MesVac c(15),;
							  Sistem c(15),;
							  NomAfp c(15),;
							  FchAfp d(8),;
							  CarAfp c(15),;
							  DiaTra n(3),;
							  HorTra n(3),;
							  HorExt25 n(3),;
							  HorExt35 n(3),;
							  HorExt100 n(3),;
							  Tardan n(3),;
							  Faltas n(3),;
							  Sueldo n(16,2),;
							  DiaVac n(3) )

USE (Arctmp1) ALIAS CabBol
INDEX ON CodPer TAG cbol01

SELECT PERS
GOTO TOP
REGACT=RECNO()
Cancelar = .F.
SCAN WHILE !EOF()
	DO Cabecera
	DO Detalle
ENDSCAN
SELECT BPGO
USE
DELETE FILE (ArcTmp)
RETURN

******************
PROCEDURE Cabecera
******************
*!*	Aqui código de Cabecera
XsCodPer = CodPer
XsNomPer = NomPer
XslElect = lElect
=SEEK(PERS.Gra_Sg,"SEDE")
XsNomSed = TRIM(SEDE.Nombre)
=SEEK([04]+PERS.CodCar,"TABL")
XsNomCar = TRIM(TABL.Nombre)
XdFchIng = FchIng
XdFchCes = FchCes
XsMesVac = MesVac
=SEEK("20"+XsMesVac,"TABL")
XsNomVac = TABL.Nombre
XsTpoAfi = TpoAfi
=SEEK("40"+XsTpoAfi,"TABL")
XsSistema = TABL.Nombre
XsCodAfp = CodAfp
=SEEK("23"+XsCodAfp,"TABL")
XsNomAfp = TABL.Nombre
XdFchAfp = FchAfp
XsCarAfp = CarAfp
SELECT CabBol
APPEND BLANK
replace CodPer WITH XsCodPer
replace NomPer WITH XsNomPer
replace lElect WITH XslElect
replace NomSed WITH XsNomSed
replace CarPer WITH XsNomCar
replace FchIng WITH XdFchIng
replace FchCes WITH XdFchCes
replace MesVac WITH XsNomVac
replace Sistem WITH XsSistema
replace NomAfp WITH XsNomAfp
replace FchAfp WITH XdFchAfp
replace CarAfp WITH XsCarAfp
STORE 0 TO x1
SELECT bpgo
GO TOP
DO WHILE !EOF()
	IF INLIST(TpoVar,'5')
		SELE TMOV
		SEEK BPGO.CODMOV
		SELE DMOV
		XfValCal = VALCAL(BPGO.CODMOV)
		IF ! EMPTY(BPGO->CODREF)
			XsValRef = ALLTRIM(STR(VALCAL(BPGO.CODREF),12,2))
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
		x1 = x1 + 1
		SELECT CabBol
		DO CASE
			CASE x1 = 1
				replace DiaTra WITH XfValCal
			CASE x1 = 2
				replace HorTra WITH XfValCal
			CASE x1 = 3
				replace HorExt25 WITH XfValCal
			CASE x1 = 4
				replace HorExt35 WITH XfValCal
			CASE x1 = 5
				replace HorExt100 WITH XfValCal
			CASE x1 = 6
				replace Tardan WITH XfValCal
			CASE x1 = 7
				replace Faltas WITH XfValCal
			CASE x1 = 8
				replace Sueldo WITH XfValCal
			CASE x1 = 9
				replace DiaVac WITH XfValCal
		ENDCASE
	ENDIF
	SELE BPGO
	SKIP
ENDDO
SELECT pers
RETURN

*****************
PROCEDURE Detalle
*****************
STORE 0 TO n1,n2,n3,n4,xTot01,xTot02,xTot03,xTot04
XsCodPer = PERS.CodPer
SELE BPGO
GOTO TOP
Ing = 1
Des = 1
Apo = 1
*!*	Para Ingresos
DO WHILE !EOF()
*!*		IF TpoVar # '1' .AND. TPOVAR # 'A' .AND. TPOVAR # '6'
	IF !INLIST(TpoVar,'1','A','6')
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
	vcodmo1(n1) = BPGO->CODMOV
	vdescr1(n1) = LEFT(TRIM(UPPER(TMOV->DESMOV))+XsValRef,23)
	vmont1(n1)  = XfValCal
	SELE BPGO
	vflgcal1(n1) =  BPGO.FlgCal
	REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
	IF vMont1(n1)<>0.00
		SELECT DetBol
		APPEND BLANK
		replace CodPer WITH XsCodPer
		replace Orden_I WITH TRANSFORM(Ing,[@l ###])
		replace CodMov_I WITH vcodmo1(n1)
		replace DesMov_I WITH vdescr1(n1)
		replace MonMov_I WITH vmont1(n1)
		Ing = Ing+ 1
	ENDIF
	SELE BPGO
	SKIP
ENDDO
*!*	Para Descuentos
LPrimera = .F.
SELE BPGO
GO TOP
DO WHILE !EOF()
	IF !INLIST(TpoVar,'2','B','7')
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
	xTot02 = xTot02 + XfVALCAL
	n2     = n2 + 1
	vcodmo2(n2)=  BPGO->CODMOV
	vdescr2(n2)=  LEFT(TRIM(UPPER(TMOV->DESMOV))+XsValRef,23)
	vmont2(n2) =  XfValCal
	SELE BPGO
	vflgcal2(n2) =  BPGO.FlgCal
	REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
	IF vMont2(n2)<>0.00
		SELECT DetBol
		IF lPrimera = .F.
			SEEK XsCodPer
			lPrimera = .T.
		ELSE
			SKIP
			IF EOF()
				APPEND BLANK
				replace CodPer WITH XsCodPer
			ENDIF
		ENDIF
		replace Orden_D WITH TRANSFORM(Des,[@l ###])
		IF EMPTY(Orden_I)
			replace Orden_I WITH TRANSFORM(Des,[@l ###])
		ENDIF
		replace CodMov_D WITH vcodmo2(n2)
		replace DesMov_D WITH vdescr2(n2)
		replace MonMov_D WITH vmont2(n2)
		Des = Des + 1
	ENDIF
	SELE BPGO
	SKIP
ENDDO
*!*	Para Aportaciones
lSegunda = .F.
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
	IF vMont4(n4)<>0.00
		SELECT DetBol
		IF lSegunda = .F.
			SEEK XsCodPer
			lSegunda = .T.
		ELSE
			SKIP
			IF EOF()
				APPEND BLANK
				replace CodPer WITH XsCodPer
			ENDIF
		ENDIF
		replace Orden_A WITH TRANSFORM(Apo,[@l ###])
		IF EMPTY(Orden_I)
			replace Orden_A WITH TRANSFORM(Apo,[@l ###])
		ENDIF
		replace CodMov_A WITH vcodmo4(n4)
		replace DesMov_A WITH vdescr4(n4)
		replace MonMov_A WITH vmont4(n4)
		Apo = Apo + 1
	ENDIF
	SELE BPGO
	SKIP
ENDDO
SELECT DetBol
bb = 0
SEEK XsCodPer
SCAN WHILE DetBol.CodPer = XsCodPer
	bb = VAL(Orden_i)
ENDSCAN
bb = bb + 1
APPEND BLANK
replace CodPer WITH XsCodPer
replace Orden_i WITH TRANSFORM(bb,"@l ###")
replace MonTot WITH xTot01 - xTot02
SELECT PERS
RETURN
