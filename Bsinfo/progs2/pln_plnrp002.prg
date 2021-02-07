****************************
* Reporte de Haberes Fijos *
****************************
PRIVATE XsCodPln,XsNroPer
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

oPln = CREATEOBJECT('DosVr.Planillas')
*!*	Aperturamos Archivos *!*
goentorno.open_dbf1('ABRIR','PLNMTSEM','TSEM','SEMA01','')
goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
DO CASE
	CASE XsCodPln = "1"
		goentorno.open_dbf1('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = "2"
		goentorno.open_dbf1('ABRIR','PLNBLPG2','BPGO','BPGO01','')
	CASE XsCodPln = "3"
		goentorno.open_dbf1('ABRIR','PLNBLPG3','BPGO','BPGO01','')
	CASE XsCodPln = "4"
		goentorno.open_dbf1('ABRIR','PLNBLPG4','BPGO','BPGO01','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = '1'
		goentorno.open_dbf1('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = '2'
		goentorno.open_dbf1('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = '3'
		goentorno.open_dbf1('ABRIR','PLNTMOV3','TMOV','TMOV01','')
	CASE XsCodPln = '4'
		goentorno.open_dbf1('ABRIR','PLNTMOV4','TMOV','TMOV01','')
ENDCASE
goentorno.open_dbf1('ABRIR','PLNDMOVT','DMOV','DMOV01','')
goentorno.open_dbf1('ABRIR','PLNMPERS','PERS','PERS01','')
SET FILTER TO CodPln = XsCodPln
*!*	declaramos variables
DIMENSION vcodmo1(40),vdescr1(40),vmont1(40),vflgcal1(40)
DIMENSION vcodmo2(40),vdescr2(40),vmont2(40),vflgcal2(40)
DIMENSION vcodmo3(40),vdescr3(40),vmont3(40),vflgcal3(40)
DIMENSION vcodmo4(40),vdescr4(40),vmont4(40),vflgcal4(40)
DIMENSION vlinea(2)
*!*	Ejecutamos el formulario
DO FORM pln_plnrp002
RETURN

*****************
PROCEDURE xGenera
*****************
DO Crea_Temporales
SELECT PERS
GOTO TOP
RegAct = RECNO()
Cancelar = .F.
SCAN WHILE !EOF()
	IF !EMPTY(FchCes)
		WAIT WINDOW 'Trabajador no considerado' NOWAIT
	ELSE
		DO Cabecera
		DO Detalle
	ENDIF
ENDSCAN
RETURN

*************************
PROCEDURE Crea_Temporales
*************************
WAIT WINDOW 'Un momento por favor...' TIMEOUT .15
ArcTmp2 = PathUser+sys(3) && para el detalle
*!*	Para Detalle
IF USED('DetBol')
	SELECT DetBol
	USE
ENDIF
SELECT 0
CREATE TABLE (ArcTmp2) FREE ( CodPer c(LEN(PERS.CodPer)),;
							  ApePat c(LEN(PERS.ApePat)),;
							  ApeMat c(LEN(PERS.ApeMat)),;
							  Nombres c(LEN(PERS.Nombres)),;
							  CodSed c(LEN(PERS.CodSed)),;
							  CodAfp c(LEN(PERS.CodAfp)),;
							  Orden_I c(3),;
							  Orden_D c(3),;
							  Orden_A c(3),;
							  CodSnt_I c(LEN(TMOV.CodSnt)),;
							  CodMov_I c(LEN(TMOV.CodMov)),;
							  DesMov_I c(LEN(TMOV.DesMov)),;
							  MonMov_I n(16,2),;
							  CodSnt_D c(LEN(TMOV.CodSnt)),;
							  CodMov_D c(LEN(TMOV.CodMov)),;
							  DesMov_D c(LEN(TMOV.DesMov)),;
							  MonMov_D n(16,2),;
							  CodSnt_A c(LEN(TMOV.CodSnt)),;
							  CodMov_A c(LEN(TMOV.CodMov)),;
							  DesMov_A c(LEN(TMOV.DesMov)),;
							  MonMov_A n(16,2),;
							  MonTot n(16,2) )
USE (Arctmp2) ALIAS DetBol EXCLUSIVE
INDEX ON CodPer+Orden_I+Orden_D+Orden_A TAG DBOL01
INDEX ON CodPer+CodSnt_I TAG DBOL02		&& Ingresos
INDEX ON CodPer+CodSnt_D TAG DBOL03		&& Descuentos
INDEX ON CodPer+CodSnt_A TAG DBOL04		&& Aportaciones
*!*	Ordenamiento para las relaciones
INDEX ON ApePat+ApeMat+Nombres TAG DBOL05
INDEX ON CodSed+ApePat+ApeMat+Nombres TAG DBOL06
INDEX ON CodAfp+ApePat+ApeMat+Nombres TAG DBOL07
*!*	Para los ordenes de los reportes
SET ORDER TO DBOL01
WAIT WINDOW "Un momento por favor creando cabecera" TIMEOUT .25
ArcTmp1 = PathUser + SYS(3) && para la cabecera
*!*	Para Cabecera
IF USED('CabBol')
	SELECT CabBol
	USE
ENDIF
SELECT 0
CREATE TABLE (ArcTmp1) FREE ( CodPer c(LEN(PERS.CodPer)),;
							  ApePat c(LEN(PERS.ApePat)),;
							  ApeMat c(LEN(PERS.ApeMat)),;
							  Nombres c(LEN(PERS.Nombres)),;
							  NomTpoPer c(LEN(TABL.Nombre)),;
							  Email c(LEN(PERS.Email)),;
							  NomDoc c(LEN(TABL.Nombre)),;
							  NroDoc c(LEN(PERS.NroDoc)),;
							  CodSed c(LEN(PERS.CodSed)),;
							  NomSed c(LEN(SEDE.Nombre)),;
							  CarPer c(LEN(TABL.Nombre)),;
							  FchIng d(8),;
							  NomReg c(80),;
							  FchCes d(8),;
							  MesVac c(15),;
							  CodAfp c(LEN(PERS.CodAfp)),;
							  NomAfp c(LEN(TABL.Nombre)),;
							  FchAfp d(8),;
							  CarAfp c(15),;
							  DiaTra n(3),;
							  Faltas n(3),;
							  DiaSub n(3),;
							  HorTra n(3),;
							  HorExt25 n(3),;
							  HorExt35 n(3),;
							  HorExt100 n(3),;
							  Tardan n(3),;
							  Sueldo n(16,2),;
							  DiaVac n(3) )
USE (Arctmp1) ALIAS CabBol EXCLUSIVE
INDEX ON CodPer TAG CBOL01
INDEX ON ApePat+ApeMat+Nombres TAG CBOL02
INDEX ON CodSed+ApePat+ApeMat+Nombres TAG CBOL03
INDEX ON CodAfp+ApePat+ApeMat+Nombres TAG CBOL04
*!*	Ordenamiento para llenado de temporal
SET ORDER TO CBOL01

******************
PROCEDURE Cabecera
******************
*!*	Aqui código de Cabecera
XsCodPer = CodPer
XsApePat = ApePat
XsApeMat = ApeMat
XsNombres = Nombres
XsTpoPer = TpoPer
=SEEK(PsTpoTra+XsTpoPer,'TABL')
XsNomTpoPer = TRIM(TABL.Nombre)
XsEmail = Email
XsTpoDoc = TpoDoc
=SEEK(PsTpoDoc+XsTpoDoc,'TABL')
XsNomDoc = TRIM(TABL.Nombre)
XsNroDoc = NroDoc
XsCodSed = PERS.CodSed
=SEEK(PERS.CodSed,'SEDE')
XsNomSed = TRIM(SEDE.Nombre)
=SEEK(PsCodOcu+PERS.CodCar,'TABL')
XsNomCar = TRIM(TABL.Nombre)
XdFchIng = FchIng
XsRegLab = RegLab
=SEEK(PsRegLab+XsRegLab,'TABL')
XsNomReg = TRIM(TABL.Nombre)
XdFchCes = FchCes
XsMesVac = MesVac
=SEEK(PsNroMes+XsMesVac,"TABL")
XsNomVac = TABL.Nombre
XsCodAfp = CodAfp
=SEEK(PsRegPen+XsCodAfp,"TABL")
XsNomAfp = TABL.Nombre
XdFchAfp = FchAfp
XsCarAfp = CarAfp
SELECT CabBol
APPEND BLANK
REPLACE CodPer WITH XsCodPer
REPLACE ApePat WITH XsApePat
REPLACE ApeMat WITH XsApeMat
REPLACE Nombres WITH XsNombres
REPLACE NomTpoPer WITH XsNomTpoPer
REPLACE Email WITH XsEmail
REPLACE NomDoc WITH XsNomDoc
REPLACE NroDoc WITH XsNroDoc
REPLACE NomSed WITH XsNomSed
REPLACE CarPer WITH XsNomCar
REPLACE FchIng WITH XdFchIng
REPLACE NomReg WITH XsNomReg
REPLACE FchCes WITH XdFchCes
REPLACE MesVac WITH XsNomVac
REPLACE NomAfp WITH XsNomAfp
REPLACE FchAfp WITH XdFchAfp
REPLACE CarAfp WITH XsCarAfp
REPLACE CodSed WITH XsCodSed
REPLACE CodAfp WITH XsCodAfp
STORE 0 TO x1
SELECT BPGO
GO TOP
SEEK '4'		&& Cambia esta nota
DO WHILE TpoVar = '4'
	=SEEK(BPGO.CodMov,'TMOV')
	SELECT DMOV
	XfValCal = oPln.ValCal(BPGO.CodMov)
	IF ! EMPTY(BPGO.CodRef)
		XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
		IF RIGHT(XsValRef,1) = '0'
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
		ENDIF
		IF RIGHT(XsValRef,1) = '0'
			XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
		ENDIF
		XsValRef = ' ' + XsValRef
	ELSE
		XsValRef = ''
	ENDIF
	x1 = x1 + 1
	SELECT CabBol
	DO CASE
		CASE x1 = 1
			REPLACE DiaTra WITH XfValCal
		CASE x1 = 2
			REPLACE Faltas WITH XfValCal
		CASE x1 = 3
			REPLACE DiaSub WITH XfValCal
		CASE x1 = 4
			REPLACE HorTra WITH XfValCal
		CASE x1 = 5
			REPLACE HorExt25 WITH XfValCal
		CASE x1 = 6
			REPLACE HorExt35 WITH XfValCal
		CASE x1 = 7
			REPLACE HorExt100 WITH XfValCal
	ENDCASE
	SELECT BPGO
	SKIP
ENDDO
SELECT PERS
RETURN

*****************
PROCEDURE Detalle
*****************
STORE 0 TO n1,n2,n3,n4,xTot01,xTot02,xTot03,xTot04
XsCodPer = PERS.CodPer
XsApePat = ApePat
XsApeMat = ApeMat
XsNombres = Nombres
XsCodSed = PERS.CodSed
XsCodAfp = CodAfp
IF oPln.ValCal('@SIT') <> 5
	Ing = 1
	Des = 1
	Apo = 1
	*!*	Para Ingresos
	SELECT BPGO
	SEEK '1'
	DO WHILE TpoVar = '1'
		SELECT TMOV
		SEEK BPGO.CodMov
		XsCodSnt = CodSnt
		WAIT WINDOW 'Procesando '+BPGO.CodMov+' '+ALLTRIM(TMOV.DesMov) NOWAIT
		SELECT DMOV
		XfValCal = oPln.ValCal(BPGO.CodMov)
		IF !EMPTY(BPGO.CodRef)
			XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
			ENDIF
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
			ENDIF
			XsValRef = ' ' + XsValRef
		ELSE
			XsValRef = ''
		ENDIF
		xTot01 = xTot01 + XfValCal
		n1 = n1 + 1
		vcodmo1(n1) = BPGO.CodMov
		vdescr1(n1) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
		vmont1(n1)  = XfValCal
		SELECT BPGO
		vflgcal1(n1) =  BPGO.FlgCal
		REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
		IF vMont1(n1)<>0.00
			SELECT DetBol
			APPEND BLANK
			REPLACE CodPer WITH XsCodPer
			REPLACE ApePat WITH XsApePat
			REPLACE ApeMat WITH XsApeMat
			REPLACE Nombres WITH XsNombres
			REPLACE CodSed WITH XsCodSed
			REPLACE CodAfp WITH XsCodAfp
			REPLACE Orden_I WITH TRANSFORM(Ing,[@l ###])
			REPLACE CodSnt_I WITH XsCodSnt
			REPLACE CodMov_I WITH vcodmo1(n1)
			REPLACE DesMov_I WITH vdescr1(n1)
			REPLACE MonMov_I WITH vmont1(n1)
			Ing = Ing+ 1
		ENDIF
		SELECT BPGO
		SKIP
	ENDDO
	*!*	Para Ingresos por vacaciones
	SELECT BPGO
	SEEK '5'
	SCAN WHILE TpoVar = '5'
		SELECT TMOV
		SEEK BPGO.CodMov
		XsCodSnt = CodSnt
		WAIT WINDOW 'Procesando '+BPGO.CodMov+' '+ALLTRIM(TMOV.DesMov) NOWAIT
		SELECT DMOV
		XfValCal = oPln.ValCal(BPGO.CodMov)
		IF !EMPTY(BPGO.CodRef)
			XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
			ENDIF
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
			ENDIF
			XsValRef = ' ' + XsValRef
		ELSE
			XsValRef = ''
		ENDIF
		xTot01 = xTot01 + XfValCal
		n1 = n1 + 1
		vcodmo1(n1) = BPGO.CodMov
		vdescr1(n1) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
		vmont1(n1)  = XfValCal
		SELECT BPGO
		vflgcal1(n1) =  BPGO.FlgCal
		REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
		IF vMont1(n1)<>0.00
			SELECT DetBol
			=SEEK(XsCodPer+XsCodSnt,'DetBol','DBOL02')
			IF !FOUND()
				APPEND BLANK
				REPLACE CodPer WITH XsCodPer
				REPLACE ApePat WITH XsApePat
				REPLACE ApeMat WITH XsApeMat
				REPLACE CodSed WITH XsCodSed
				REPLACE CodAfp WITH XsCodAfp
				REPLACE Nombres WITH XsNombres
				REPLACE Orden_I WITH TRANSFORM(Ing,[@l ###])
				REPLACE CodSnt_I WITH XsCodSnt
				REPLACE CodMov_I WITH vcodmo1(n1)
				REPLACE DesMov_I WITH vdescr1(n1)
				REPLACE MonMov_I WITH vmont1(n1)
				Ing = Ing+ 1
			ELSE
				REPLACE MonMov_I WITH MonMov_I+vmont1(n1)
			ENDIF
		ENDIF
		SELECT BPGO
	ENDSCAN
	*!*	Para Descuentos
	LPrimera = .F.
	SELECT BPGO
	SEEK '2'
	DO WHILE TpoVar = '2'
		SELECT TMOV
		SEEK BPGO.CodMov
		XsCodSnt = CodSnt
		SELECT DMOV
		XfValCal = oPln.ValCal(BPGO.CodMov)
		IF ! EMPTY(BPGO->CODREF)
			XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
			ENDIF
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
			ENDIF
			XsValRef = ' ' + XsValRef
		ELSE
			XsValRef = ''
		ENDIF
		xTot02 = xTot02 + XfValCal
		n2 = n2 + 1
		vcodmo2(n2) = BPGO.CodMov
		vdescr2(n2) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
		vmont2(n2) = XfValCal
		SELECT BPGO
		vflgcal2(n2) = BPGO.FlgCal
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
					REPLACE CodPer WITH XsCodPer
					REPLACE ApePat WITH XsApePat
					REPLACE ApeMat WITH XsApeMat
					REPLACE Nombres WITH XsNombres
					REPLACE CodSed WITH XsCodSed
					REPLACE CodAfp WITH XsCodAfp
				ENDIF
			ENDIF
			REPLACE Orden_D WITH TRANSFORM(Des,[@l ###])
			IF EMPTY(Orden_I)
				REPLACE Orden_I WITH TRANSFORM(Des,[@l ###])
			ENDIF
			REPLACE CodSnt_D WITH XsCodSnt
			REPLACE CodMov_D WITH vcodmo2(n2)
			REPLACE DesMov_D WITH vdescr2(n2)
			REPLACE MonMov_D WITH vmont2(n2)
			Des = Des + 1
		ENDIF
		SELECT BPGO
		SKIP
	ENDDO
	*!*	Para Descuentos por vacaciones
	SELECT BPGO
	SEEK '6'
	SCAN WHILE TpoVar = '6'
		SELECT TMOV
		SEEK BPGO.CodMov
		XsCodSnt = CodSnt
		SELECT DetBol
		=SEEK(XsCodPer+XsCodSnt,'DetBol','DBOL03')
		IF FOUND()
			EXIT
		ENDIF
	ENDSCAN
	SELECT DetBol
	IF !FOUND()
		lPrimera = .F.
		SELECT BPGO
		SEEK '6'
		SCAN WHILE TpoVar = '6'
			SELECT TMOV
			SEEK BPGO.CodMov
			XsCodSnt = CodSnt
			WAIT WINDOW 'Procesando '+BPGO.CodMov+' '+ALLTRIM(TMOV.DesMov) NOWAIT
			SELECT DMOV
			XfValCal = oPln.ValCal(BPGO.CodMov)
			IF !EMPTY(BPGO.CodRef)
				XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
				ENDIF
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
				ENDIF
				XsValRef = ' ' + XsValRef
			ELSE
				XsValRef = ''
			ENDIF
			xTot02 = xTot02 + XfValCal
			n2 = n2 + 1
			vcodmo2(n2) = BPGO.CodMov
			vdescr2(n2) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
			vmont2(n2) = XfValCal
			SELECT BPGO
			vflgcal1(n2) =  BPGO.FlgCal
			REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
			IF vMont2(n2)<>0.00
				SELECT DetBol
				IF lPrimera = .F.
					SEEK XsCodPer
					lPrimera = .T.
				ELSE
					IF !EOF()
						SKIP
					ENDIF
					IF EOF()
						APPEND BLANK
						REPLACE CodPer WITH XsCodPer
						REPLACE ApePat WITH XsApePat
						REPLACE ApeMat WITH XsApeMat
						REPLACE Nombres WITH XsNombres
						REPLACE CodSed WITH XsCodSed
						REPLACE CodAfp WITH XsCodAfp
					ENDIF
				ENDIF
				REPLACE CodPer WITH XsCodPer
				REPLACE ApePat WITH XsApePat
				REPLACE ApeMat WITH XsApeMat
				REPLACE Nombres WITH XsNombres
				REPLACE CodSed WITH XsCodSed
				REPLACE CodAfp WITH XsCodAfp
				REPLACE Orden_D WITH TRANSFORM(Des,[@l ###])
				IF EMPTY(Orden_I)
					REPLACE Orden_I WITH TRANSFORM(Des,[@l ###])
				ENDIF
				REPLACE CodSnt_D WITH XsCodSnt
				REPLACE CodMov_D WITH vcodmo2(n2)
				REPLACE DesMov_D WITH vdescr2(n2)
				REPLACE MonMov_D WITH vmont2(n2)
				Des = Des + 1
			ENDIF
			SELECT BPGO
		ENDSCAN
	ELSE
		SELECT BPGO
		SEEK '6'
		SCAN WHILE TpoVar = '6'
			SELECT TMOV
			SEEK BPGO.CodMov
			XsCodSnt = CodSnt
			WAIT WINDOW 'Procesando '+BPGO.CodMov+' '+ALLTRIM(TMOV.DesMov) NOWAIT
			SELECT DMOV
			XfValCal = oPln.ValCal(BPGO.CodMov)
			IF !EMPTY(BPGO.CodRef)
				XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
				ENDIF
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
				ENDIF
				XsValRef = ' ' + XsValRef
			ELSE
				XsValRef = ''
			ENDIF
			xTot02 = xTot02 + XfValCal
			n2 = n2 + 1
			vcodmo2(n2) = BPGO.CodMov
			vdescr2(n2) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
			vmont2(n2) = XfValCal
			SELECT BPGO
			vflgcal1(n2) =  BPGO.FlgCal
			REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
			IF vMont2(n2)<>0.00
				SELECT DetBol
				=SEEK(XsCodPer+XsCodSnt,'DetBol','DBOL03')
				IF !FOUND()
					IF lPrimera = .F.
						SEEK XsCodPer
						lPrimera = .T.
					ELSE
						IF !EOF()
							SKIP
						ENDIF
						IF EOF()
							APPEND BLANK
							REPLACE CodPer WITH XsCodPer
							REPLACE ApePat WITH XsApePat
							REPLACE ApeMat WITH XsApeMat
							REPLACE Nombres WITH XsNombres
							REPLACE CodSed WITH XsCodSed
							REPLACE CodAfp WITH XsCodAfp
						ENDIF
					ENDIF
					REPLACE CodPer WITH XsCodPer
					REPLACE ApePat WITH XsApePat
					REPLACE ApeMat WITH XsApeMat
					REPLACE Nombres WITH XsNombres
					REPLACE CodSed WITH XsCodSed
					REPLACE CodAfp WITH XsCodAfp
					REPLACE Orden_D WITH TRANSFORM(Des,[@l ###])
					IF EMPTY(Orden_I)
						REPLACE Orden_I WITH TRANSFORM(Des,[@l ###])
					ENDIF
					REPLACE CodSnt_D WITH XsCodSnt
					REPLACE CodMov_D WITH vcodmo2(n2)
					REPLACE DesMov_D WITH vdescr2(n2)
					REPLACE MonMov_D WITH vmont2(n2)
					Des = Des + 1
				ELSE
					REPLACE MonMov_D WITH MonMov_D+vmont2(n2)
				ENDIF
			ENDIF
			SELECT BPGO
		ENDSCAN
	ENDIF
	*!*	Para Aportaciones
	lSegunda = .F.
	SELECT BPGO
	SEEK '3'
	DO WHILE TpoVar = '3'
		SELECT TMOV
		SEEK BPGO.CodMov
		XsCodSnt = CodSnt
		SELECT DMOV
		XfValCal = oPln.ValCal(BPGO.CodMov)
		IF ! EMPTY(BPGO.CodRef)
			XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
			ENDIF
			IF RIGHT(XsValRef,1) = '0'
				XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
			ENDIF
			XsValRef = ' ' + XsValRef
		ELSE
			XsValRef = ''
		ENDIF
		xTot04 = xTot04 + XfVALCAL
		n4 = n4 + 1
		vcodmo4(n4) = BPGO.CodMov
		vdescr4(n4) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
		vmont4(n4) = XfVALCAL
		SELECT BPGO
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
					REPLACE CodPer WITH XsCodPer
					REPLACE ApePat WITH XsApePat
					REPLACE ApeMat WITH XsApeMat
					REPLACE Nombres WITH XsNombres
					REPLACE CodSed WITH XsCodSed
					REPLACE CodAfp WITH XsCodAfp
				ENDIF
			ENDIF
			REPLACE Orden_A WITH TRANSFORM(Apo,[@l ###])
			IF EMPTY(Orden_I)
				REPLACE Orden_I WITH TRANSFORM(Apo,[@l ###])
			ENDIF
			REPLACE CodSnt_A WITH XsCodSnt
			REPLACE CodMov_A WITH vcodmo4(n4)
			REPLACE DesMov_A WITH vdescr4(n4)
			REPLACE MonMov_A WITH vmont4(n4)
			Apo = Apo + 1
		ENDIF
		SELECT BPGO
		SKIP
	ENDDO
	*!*	Para aportaciones por Vacaciones
	SELECT BPGO
	SEEK '7'
	SELECT TMOV
	SEEK BPGO.CodMov
	XsCodSnt = CodSnt
	SELECT DetBol
	=SEEK(XsCodPer+XsCodSnt,'DetBol','DBOL04')
	IF !FOUND()
		lSegunda = .F.
		SELECT BPGO
		SEEK '7'
		DO WHILE TpoVar = '7'
			SELECT TMOV
			SEEK BPGO.CodMov
			XsCodSnt = CodSnt
			SELECT DMOV
			XfValCal = oPln.ValCal(BPGO.CodMov)
			IF ! EMPTY(BPGO.CodRef)
				XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
				ENDIF
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
				ENDIF
				XsValRef = ' ' + XsValRef
			ELSE
				XsValRef = ''
			ENDIF
			xTot04 = xTot04 + XfVALCAL
			n4 = n4 + 1
			vcodmo4(n4) = BPGO.CodMov
			vdescr4(n4) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
			vmont4(n4) = XfVALCAL
			SELECT BPGO
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
						REPLACE CodPer WITH XsCodPer
						REPLACE ApePat WITH XsApePat
						REPLACE ApeMat WITH XsApeMat
						REPLACE Nombres WITH XsNombres
						REPLACE CodSed WITH XsCodSed
						REPLACE CodAfp WITH XsCodAfp
					ENDIF
				ENDIF
				REPLACE Orden_A WITH TRANSFORM(Apo,[@l ###])
				IF EMPTY(Orden_I)
					REPLACE Orden_I WITH TRANSFORM(Apo,[@l ###])
				ENDIF
				REPLACE CodSnt_A WITH XsCodSnt
				REPLACE CodMov_A WITH vcodmo4(n4)
				REPLACE DesMov_A WITH vdescr4(n4)
				REPLACE MonMov_A WITH vmont4(n4)
				Apo = Apo + 1
			ENDIF
			SELECT BPGO
			SKIP
		ENDDO
	ELSE
		SELECT BPGO
		SEEK '7'
		SCAN WHILE TpoVar = '7'
			SELECT TMOV
			SEEK BPGO.CodMov
			XsCodSnt = CodSnt
			WAIT WINDOW 'Procesando '+BPGO.CodMov+' '+ALLTRIM(TMOV.DesMov) NOWAIT
			SELECT DMOV
			XfValCal = oPln.ValCal(BPGO.CodMov)
			IF !EMPTY(BPGO.CodRef)
				XsValRef = ALLTRIM(STR(oPln.ValCal(BPGO.CodRef),12,2))
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-1)
				ENDIF
				IF RIGHT(XsValRef,1) = '0'
					XsValRef = LEFT(XsValRef,LEN(XsValRef)-2)
				ENDIF
				XsValRef = ' ' + XsValRef
			ELSE
				XsValRef = ''
			ENDIF
			xTot04 = xTot04 + XfValCal
			n4 = n4 + 1
			vcodmo4(n4) = BPGO.CodMov
			vdescr4(n4) = LEFT(TRIM(UPPER(TMOV.DesMov))+XsValRef,80)
			vmont4(n4) = XfValCal
			SELECT BPGO
			vflgcal1(n4) =  BPGO.FlgCal
			REPLACE ValAcm WITH ValAcm + IIF(BPGO.FlgCal,XfValCal,0)
			IF vMont4(n4)<>0.00
				SELECT DetBol
				=SEEK(XsCodPer+XsCodSnt,'DetBol','DBOL04')
				IF !FOUND()
					REPLACE Orden_A WITH TRANSFORM(Apo,[@l ###])
					IF EMPTY(Orden_I)
						REPLACE Orden_I WITH TRANSFORM(Des,[@l ###])
					ENDIF
					REPLACE CodSnt_A WITH XsCodSnt
					REPLACE CodMov_A WITH vcodmo4(n4)
					REPLACE DesMov_A WITH vdescr4(n4)
					REPLACE MonMov_A WITH vmont4(n4)
					Apo = Apo + 1
				ELSE
					REPLACE MonMov_A WITH MonMov_A+vmont4(n4)
				ENDIF
			ENDIF
			SELECT BPGO
		ENDSCAN
	ENDIF
	SELECT DetBol
	bb = 0
	SEEK XsCodPer
	SCAN WHILE DetBol.CodPer = XsCodPer
		bb = VAL(Orden_i)
	ENDSCAN
	bb = bb + 1
	APPEND BLANK
	REPLACE CodPer WITH XsCodPer
	REPLACE ApePat WITH XsApePat
	REPLACE ApeMat WITH XsApeMat
	REPLACE Nombres WITH XsNombres
	REPLACE CodSed WITH XsCodSed
	REPLACE CodAfp WITH XsCodAfp
	REPLACE Orden_I WITH TRANSFORM(bb,"@l ###")
	REPLACE MonTot WITH xTot01 - xTot02
	SELECT PERS
ENDIF
RETURN