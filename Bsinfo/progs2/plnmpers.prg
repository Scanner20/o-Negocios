**************************************************************************
*  Nombre    : Plnmpers.PRG                                              *
*  Objeto    : Registro de Datos Personales                              *
**************************************************************************
DO def_teclas IN fxgen_2
SET DISPLAY TO VGA25
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS01','')
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')

cTit1 = "Maestro de Personal"
cTit2 = ""
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = GsNomCia
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
*!*	SELE 3
*!*	USE PLNMTABL ORDER TABL01 ALIAS TABL
*!*	IF !USED(3)
*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
*!*	SELE 1
*!*	USE PLNMPERS ORDER PERS01 ALIAS PERS
*!*	IF !USED(1)
*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
SELE PERS
*!*	SET FILTER TO CodPln == XsCodPln
GO TOP
Private VecOpc
Dimension VecOpc(10)
XCodPer = SPACE(LEN(PERS->CodPer))            && llave de busqueda
XCodPln = SPACE(LEN(PERS->CodPln))
XCodSec = SPACE(LEN(PERS->CodSec))
XNCGFAM = 0
*
**********************************************************************
* Dibujar Pantalla
**********************************************************************
CLEAR
@ 0,0    SAY PADC(ALLTRIM(GsNomCia),30)    COLOR SCHEME 7
@ 1,0    SAY PADC("DPTO. DE PERSONAL",30)  COLOR SCHEME 7
@ 0,40   SAY [ANO:]+TRAN(_ANO,[9999])      COLOR SCHEME 7
@ 0,56   say " Fecha : " + Dtoc(date())
IF XsCodPln=[1]
	@ 1,53   say " REGISTRO DE EMPLEADOS"   COLOR SCHEME 7
ELSE
	@ 1,53   say " REGISTRO DE OBREROS  "   COLOR SCHEME 7
ENDIF
@  2,0   TO  22,78 DOUBLE
@  3,4   SAY "C¢digo    :"
@  3,30  SAY "Nombre:"
@  4,4   SAY "Cod. Plan.:"
@  4,39  SAY "Ventas:"
@  4,58  SAY "Sede :"
@  5,4   SAY "Division  : "
@  5,39  SAY "Areas : "
@  6,4   SAY "Secciones :"
@  6,56  SAY "Sexo :"
@  7,4   SAY "Cargo     :"
@  7,56  SAY "G.Ins:"
@  8,4   SAY "Programa  :"
@  8,56  SAY "Profe:"
@  9,4   SAY "Lugar Pago:"
@  9,39  SAY "G.Sangui:"
@  9,56  SAY "Tarje:"
@ 10,1   TO 12,77
@ 10,30  say "Tpo.Cta.:"
@ 11,4   SAY "Grupo    :"
@ 11,30  SAY "Cta.Banco:"
@ 11,56  SAY "C.Cts:"
@ 13,4   SAY "Direcci¢n  :"
@ 13,54  SAY "Tlf.:"
@ 14,4   SAY "Localidad  :"
@ 14,41  SAY "Ubic.Geog.:"
@ 15,4   SAY "Fch Nacimie:"
@ 15,31  SAY "Edad:"
@ 15,41  SAY "Provincia :"
@ 16,4   SAY "Nro. Hijos :"
@ 16,25  SAY "Carga Fami:"
@ 16,41  SAY "Est.Civil :"
@ 17,4   SAY "Carnet IPSS:"
@ 17,41  SAY "Carnet AFP:"
@ 18,4   SAY "Lib.Elect  :"
@ 18,41  SAY "Lib.Milit :"
@ 19,4   SAY "Cod. A.F.P.:"
@ 20,4   SAY "Fch Ingreso:"
@ 20,31  SAY "T.Serv.:    A¤os    Meses    Dias"
@ 21,4   SAY "Fecha Cese :"
@ 19,41  SAY "Fch AFP:"
@ 19,59  SAY "Fch.Con:"
@ 20,66  SAY "Pln :"
@ 21,31  SAY "Mes Vac.:"
@ 21,55  SAY "Per. Vac.:"
DO LIB_MTEC WITH 3
DO EDITA_X WITH 'PERLlave','PERMuest','PEREdita','PERElimi','PERlista',[],[],'CMAR',[]
RETURN
**********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE PERLlave
**********************************************************************
XCodPer = CodPer
IF Crear
	GOTO BOTTOM
	XCodPer = CodPer
	XCodPer = TRANSFORM(VAL(XCodPer) + 1,"@L "+REPLICATE("9",LEN(XCodPer)))
ENDIF
DO Lib_MTec WITH 11
UltTecla = 0
DO WHILE  UltTecla<>Escape
   @  3,20  GET XCodPer PICTURE REPLICATE("9",LEN(XCodPer))
   READ
   UltTecla = Lastkey()
   IF UltTecla = F8
      If PlnBusca("PERS")
          XCodPer = CodPer
          UltTecla = CtrlW
      ENDIF
   ENDIF
   @  3,20  SAY XCodPer PICTURE "@!"
   IF UltTecla = Enter
		UltTecla = CtrlW
		exit
	ENDIF
ENDDO
SEEK XCodPer
DO LIB_MTEC WITH 3
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE PERMuest
**********************************************************************
*          10        20        30        40        50        60        70
*0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
*1     E M P R E S A
*2   .--7------------20---------31------39--------49-----56-----63-66----------.
*3   | *C¢digo     : XXXXXX     Nombre: XXXXXXXXX0XXXXXXXXX0XXXXXXXXX0XXXXX    |
*4   | *C¢d. Plan. : X XXXXXXXXX        Nro.Plaza: XXX      Sede : XXXX        |
*5   | *Division   : XXXXXXXXXXXXXXXX   Area   : XXXXXXXXXXX                   |
*6   | *Seccion    : XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX    Sexo : XXXXXXXXX      |
*7   | *Cargo      : XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX    G.Ins: XX XXXXXXXX    |
*8   | *Programa   : XXXX XXXXXXXXXXXXXXXXXXXX           Prof.: XX XXXXXXXX    |
*9   | *Lugar Pago : XX XXXXXXXXXXXXXX  G.Sangui: XXXXXX Tarje: XXXXXXXXXX     |
*0   +-------------------------Tpo.Cta:-XX-XXXXXXXXXXX-------------------------+
*1   |  Grupo    : XXXXXXXXXX  Cta.Banco: XXXXXXXXXXXX  C.Cts: XXXXXXXXXX      |
*2   +---------------20-------------------41-----------54----------------------+
*3   |  Direcci¢n  : XXXXXXXXXXXXXXXXXXX  Telefono   : XXXXXXXXXXXXX           |
*4   |  Localidad  : XXXXXXXXXXXXXXX      Ubic.Geog. : XX XXXXXXXXXX           |
*5   |  Fch Nacimie: dd/mm/aaaa Edad:xx   Provincia  : XXXXXXXXXXXXX           |
*6   |  Nro. Hijos : XX   Carga Fami: X   Est.Civil  : XXXXXXXXX0              |
*7   |  Carnet IPSS: XXXXXXXXXXXXXXXX     Carnet AFP : XXXXXXXXXXXXXXX         |
*8   |  Lib.Elect  : XXXXXXXXX0           Lib.Milit  : XXXXXXXXX0              |
*9   |  Cod.A.F.P. : XX XXXXXXXXXXXX      Fch AFP: dd/mm/aa  Fch.Con: dd/mm/aa |
*0   |  Fch Ingreso: dd/mm/aa   T.Serv.: xx A¤os xx Meses XX D¡as              |
*1   |  Fch Cese   : dd/mm/aa   Mes Vac.: XX XXXXXXXXX  Per. Vac.: XXXXX       |
*2   `-------------------------------------------------------------------------'
@  3,20 SAY CodPer
@  3,39 SAY NomBRE() PICT "@S36"
@  4,20 SAY CodPln
   =SEEK('01'+PERS.CodPln,'TABL')
@  4,22 SAY LEFT(TABL.Nombre,9)
   SELE PERS
*  4,50 SAY NplAza PICT "###"
   =SEEK('CV'+PERS.Nplaza,'TABL')
@  4,47 CLEAR TO 4,57
@  4,47 SAY LEFT(TRIM(TABL.Nombre),07)
   =SEEK("27"+PERS.Gra_Sg,"TABL")
@  4,66 SAY LEFT(TABL.NomBre,12)
   =SEEK('29'+PERS.Division,'TABL')
@  5,20 SAY LEFT(TABL.NomBre,15)
   =SEEK('30'+PERS.Area,'TABL')
@  5,47 SAY LEFT(TABL.NomBre,25)
@  6,20 SAY CodSec pict "999999"
   =SEEK('28'+PERS.CodSec,'TABL')
@  6,27 SAY LEFT(TABL.Nombre,25)
@  6,63 SAY IIF(SexPer = "2","Femenino","Masculino")
@  7,20 SAY CodCar pict "@L "
   =SEEK('04'+PERS.CodCar,'TABL')
@  7,27 SAY LEFT(TABL.Nombre,25)
@  7,63 SAY GrdIns
   =SEEK('07'+PERS.GrdIns,'TABL')
@  7,66 SAY LEFT(TABL.Nombre,8)
@  8,20 SAY ProGra  pict "9999"
   =SEEK('05'+PERS.ProGra,'TABL')
@  8,25 SAY LEFT(TABL.Nombre,15)
@  8,63 SAY ProPer
   =SEEK('08'+PERS.ProPer,'TABL')
@  8,66 SAY LEFT(TABL.Nombre,8)
@  9,20 SAY LugPag  pict "99"
   =SEEK('06'+PERS.LugPag,'TABL')
@  9,23 SAY LEFT(TABL.Nombre,12)
@  9,49 SAY GruSan
@  9,63 SAY NroTar PICT "#########"
@ 11,18 SAY GrpPer
  =SEEK('GP'+PERS.LugPag,'TABL')
@ 11,21 SAY LEFT(TABL.Nombre,9)
@ 10,39 SAY TpoCta
  =SEEK('CT'+PERS.TPOCTA,'TABL')
@ 10,42 SAY LEFT(TABL.NOMBRE,9)
@ 11,42 SAY CtaHor
  =SEEK("02"+PERS.CtaCts,"TABL")
@ 11,63 SAY LEFT(TABL.NomBre,13)
@ 13,20 SAY LEFT(Direcc,30)
@ 13,60 SAY LEFT(TlfPer,12)
@ 14,20 SAY LocAli
@ 14,54 SAY UbiGeo
  =SEEK('11'+PERS.Ubigeo,'TABL')
@ 14,57 SAY LEFT(TABL.Nombre,12)
@ 15,20 SAY FchNac
IF CTOD("  /  /  ") <> FchNac
	Edad = INT( ( VAL(DTOC(DATE(),1))-VAL(DTOC(FchNac,1)) )/10000 )
	@ 15,36 SAY Edad PICT "##"
ELSE
	@ 15,36 SAY "**"
ENDIF
@ 15,54 SAY ProVin
@ 16,20 SAY NhiJos PICT "##"
@ 16,37 SAY NcgFam PICT "#"
@ 16,54 SAY EstCvl
DO CASE
  CASE EstCvl="1"
     @ 16,54 SAY "Soltero/a   "
  CASE EstCvl="2"
     @ 16,54 SAY "Casado/a    "
  CASE EstCvl="3"
     @ 16,54 SAY "Viudo/a     "
  CASE EstCvl="4"
     @ 16,54 SAY "Divorciado/a"
  CASE EstCvl="5"
     @ 16,54 SAY "Conviviente "
  OTHER
     @ 16,54 say "            "
ENDCASE
@ 17,20 SAY N_ipss
@ 17,54 SAY CarAfp
@ 18,20 SAY LElect
@ 18,54 SAY LMilit
@ 19,20 SAY CodAfp  pict "99"
  =SEEK('23'+PERS.CodAfp,'TABL')
@ 19,23 SAY LEFT(TABL.Nombre,12)
@ 20,20 SAY FchIng
IF CTOD("  /  /  ") <> FchIng
   Serv = INT( ( VAL(DTOC(DATE(),1))-VAL(DTOC(FchIng,1)) )/10000 )
   IF DAY(DATE())>DAY(FchIng)
      Dias = DAY(DATE()) - DAY(FchIng)
      Mese = MONTH(DATE())
   ELSE
      Dias = DAY(DATE() - DAY(DATE())) + DAY(DATE()) - DAY(FchIng)
      Mese = MONTH(DATE()) - 1
   ENDIF
   IF Mese>=MONTH(FchIng)
      Mesi = Mese - MONTH(FchIng)
   ELSE
      Mesi = Mese - MONTH(FchIng) + 12
   ENDIF
   @ 20,40 SAY Serv PICT "##"
   @ 20,48 SAY Mesi PICT "##"
   @ 20,57 SAY Dias PICT "##"
ELSE
   @ 20,40 SAY "**"
   @ 20,48 SAY "**"
   @ 20,57 SAY "**"
ENDIF
@ 21,20 SAY FchCes
IF ctod("  /  /  ") <> fchces
	Serv = INT( ( VAL(DTOC(Fchces,1))-VAL(DTOC(FchIng,1)) )/10000 )
	IF DAY(fchces) > DAY(Fching)
		dias=day(fchces)-day(fching)
		mese=month(FCHCES)
	ELSE
		Dias = DAY(DATE() - DAY(DATE())) + DAY(Fchces) - DAY(FchIng)	
		mese = month(FCHCES) - 1
	ENDIF
	IF Mese>=MONTH(Fching)
		Mesi = Mese - MONTH(FchING)
	ELSE
		Mesi = Mese - MONTH(FchING) + 12
	ENDIF
	@ 20,40 SAY Serv PICT "##"
	@ 20,48 SAY Mesi PICT "##"
	@ 20,57 SAY Dias PICT "##"
ENDIF	
@ 19,50 SAY FchAfp
@ 19,69 say Fchcon
@ 20,72 say Gerec
@ 21,41 SAY MesVac
  =SEEK('20'+PERS.MesVac,'TABL')
@ 21,66 SAY PerVac
  =SEEK('20'+PERS.PerVac,'TABL')
@ 21,44 SAY LEFT(TABL.Nombre,9)
  =SEEK('29'+PERS.Division,'TABL')
NomVar = "Reg. "+LTRIM(STR(RECNO()))+"/"+LTRIM(STR(RECCOUNT()))
RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE PEREdita
**********************************************************************
NomVar = "Reg. "+LTRIM(STR(RECNO()))+"/"+LTRIM(STR(RECCOUNT()))
XCodPln = CodPln     && nuevo
XCodSec = CodSec
XCodCar = CodCar
XProGra = ProGra
XGra_Sg = Gra_Sg
XNplAza = NplAza
XGrpPer = GrpPer
XNomPer = NomPer
XQuinqe = Quinqe
*Guardi = Guardi
*Domini = Domini
XDirecc = Direcc
XLocali = Locali
XUbiGeo = UbiGeo
XProvin = Provin
XTlfPer = TlfPer
XSexPer = SexPer
XGrdIns = GrdIns
XProPer = ProPer
XNroTar = NroTar
XEstCvl = EstCvl
XFchNac = FchNac
XNacion = Nacion
XLElect = LElect
XLMilit = LMilit
XN_ipss = N_ipss
XFchIng = FchIng
XFchCes = FchCes
XFAntIn = FchAnt
XFCtoIn = FCtoIn
XFCtoFi = FCtoFi
XFVacIn = FVacIn
XFVacFi = FVacFi
XTpoCta = TpoCta     && nuevo
XCtaHor = CtaHor     && nuevo
XLugPag = LugPag     && nuevo
XNhiJos = NhiJos
XNCGFAM = NCGFAM
XGruSan = GruSan
XMesVac = MesVac
XCtaCts = CtaCts
XDesCar = DesCar
*NCuspp = NCuspp
XFchAfp = FchAfp
XFchCon = FchCon	&& nuevo
XCarAfp = CarAfp
XCodAfp = CodAfp
Xgerec  = Gerec
XArea   = Area
Xdivision = Division
XPervac   = Pervac  && NUEVO
XFcingr   = Fcingr  && nuevo
XFchfin   = Fchfin  && nuevo
IF EOF()
   XEstCvl = "1" && Soltero
   XSexPer = "1"
   XNacion = "Peruano/a"
ENDIF
UltTecla = 0
IF .NOT. EOF()               && Modificando
   IF !RLock()
      RETURN                 && No pudo bloquear registro
   ENDIF
ENDIF
i    = 1
iMax = 37
UltTecla  = 0
GsMsgKey = "[] [] Posiciona  [F8] Consulta  [Enter] Registrar  [F10] Grabar"
DO LIB_Mtec with 99
DO WHILE ! INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
         PATERNO = SUBSTR(XNomPer, 1,20)
         MATERNO = SUBSTR(XNomPer,21,20)
         NOMBRES = SUBSTR(XNomPer,41,20)
         SAVE SCREEN
         @ 2,37 TO 6,79
         @ 3,39 SAY "APELLIDO PATERNO :" GET M.PATERNO PICT "@!"
         @ 4,39 SAY "APELLIDO MATERNO :" GET M.MATERNO PICT "@!"
         @ 5,39 SAY "NOMBRES          :" GET M.NOMBRES PICT "@!"
         READ
         RESTORE SCREEN
         ULtTECLA = LASTKEY()
         XNOMPER = M.PATERNO+M.MATERNO+M.NOMBRES
         @  3,39 SAY SPACE(36)
         @  3,39 SAY TRIM(LEFT(XNomPer,20))+" "+TRIM(SUBSTR(XNOMPER,21,20))+" "+TRIM(RIGHT(XNOMPER,20)) PICT "@S36"
      CASE i = 2
         SELE TABL
         XsTabla  = '01'
         xCodPln=TRIM(XsCodPln)
         @  4,20 GET XCodPln PICT "9"
         READ
         ULTTECLA = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XCodPln
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @  4,20 SAY XCodPln
         SEEK XsTabla+XCodPln
         IF ! FOUND()
            GsMsgErr = "C¢digo de Planilla no Registrado"
            DO LIB_MERR WITH 0
            LOOP
         ENDIF
         @  4,22 SAY LEFT(TABL->NOMBRE,11)
      CASE i = 3
        XsTabla=[CV]
        SAVE SCREEN
        @ 3,35 CLEAR TO 6,65
        @ 3,35 TO 6,65
        @ 3,44 SAY " Ventas " COLOR SCHEME 7
        @ 4,39  SAY "Ventas:"
        @ 4,47 GET XNplaza PICT "##"
        READ
        RESTORE SCREEN
        ULTTECLA = LASTKEY()
        IF UltTecla = Escape
           EXIT
        ENDIF
        IF UltTecla==F8
           DO TABLA WITH XsTabla,XnPlaza
            IF LASTKEY() = 27
                LOOP
            ENDIF
        ENDIF
        SEEK XsTabla+XNplaza
        @  4,47 SAY LEFT(TRIM(TABL->NOMBRE),07)
      CASE i = 4
         SELE TABL
         XsTabla = [27]
         @  4,66 GET XGra_Sg PICT "@!"
         READ
         ULtTECLA = LASTKEY()
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XGra_Sg
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         IF !EMPTY(XGra_Sg)
            =SEEK("27"+XGra_Sg,"TABL")
            @  4,66 SAY LEFT(Tabl.NomBre,14) PICT "@!"
         ENDIF
      CASE I = 5
         XsTabla = "29"
         @  5,20 GET XDivision PICT "@!"
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XDivision
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         =SEEK(XsTabla+XDivision,"TABL")
         @  5,20 SAY LEFT(TABL.NomBre,15)
      CASE I = 6
         XsTabla = "30"
         @  5,47 GET XArea PICT "@!"
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XArea
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         =SEEK(XsTabla+XArea,"TABL")
         @  5,47 SAY LEFT(TABL.NomBre,25)

      CASE i = 7
         SELE TABL
         XsTabla  = "28"
         @  6,20 GET XCodSec PICT REPLICATE("9",LEN(XCodSec))
         READ
         ULTTECLA = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XCodSec
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @  6,20 SAY XCodSec
         SEEK XsTabla+XCodSec
         @  6,27 SAY LEFT(TABL->NOMBRE,25)
      CASE i = 8
         SELECT TABL
         XsTabla  = '04'
         @  7,20 GET XCodCar PICT REPLICATE("9",Len(XCodCar))
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XCodCar
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @  7,20 SAY XCodCar
         SEEK XsTabla+XCodCar
         IF ! FOUND()
            GsMsgErr = "C¢digo de Cargo No Registrado"
         ENDIF
         @  7,27 SAY Left(TabL->Nombre,25)

      CASE i = 9
         VecOpc(1)  = "Masculino"
         VecOpc(2)  = "Femenino "
         XSexPer = Elige(XSexper,6,63,2)
         IF XSEXPER = "Femenino "
            XSexPer = "2"
         ELSE
            XSexPer = "1"
         ENDIF
      CASE i = 10
         SELECT TABL
         XsTabla = "07"
         @  7,63 GET XGrdIns PICT REPLICATE("9",Len(XGrdIns))
         READ
         ULTTECLA=Lastkey()
         IF UltTecla == Escape
            EXIT
         ENDIF
         IF UltTecla == F8
            DO TABLA WITH XsTabla,XGrdIns
            IF LASTKEY() == 27
               LOOP
            ENDIF
         ENDIF
         @  7,63 SAY XGrdIns
         SEEK XsTabla+XGrdIns
         @  7,66 SAY Left(TRIM(TabL->Nombre),8)
      CASE i = 11
         SELE TABL
         XsTabla  = '05'
         @  8,20 GET XProGra PICT REPLICATE("9",LEN(XProGra))
         READ
         ULTTECLA = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XProGra
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @  8,20 SAY XProGra
         SEEK XsTabla+XProGra
         IF ! FOUND()
            GsMsgErr = "C¢digo Programa no Registrado"
            DO LIB_MERR WITH 0
         ENDIF
         @  8,25 SAY LEFT(TABL->NOMBRE,15)
      CASE i = 12
         SELECT TABL
         XsTabla  = '08'
         @  8,63 GET XProPer PICT REPLICATE("9",Len(XProPer))
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XProPer
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @  8,63 SAY XProPer
         SEEK XsTabla+XProPer
         IF ! FOUND()
            GsMsgErr = "C¢digo de Profesi¢n No Registrado"
         ENDIF
         @  8,66 SAY Left(TabL->Nombre,8)
      CASE i = 13
         SELE TABL
         XsTabla  = '06'
         @  9,20 GET XLugPag PICT REPLICATE("9",Len(XLugPag))
         READ
         UltTecla= Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF ULTTECLA = F8
            DO TABLA WITH XsTabla,XLugPag
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         SEEK XsTabla+XLugPag
         @  9,20 SAY XLugPag
         IF ! FOUND()
            GsMsgErr = "C¢digo Lugar de Pago no Registrado"
         ENDIF
         @  9,23 SAY Left(TabL->Nombre,12)
      CASE i = 14
         @  9,49 GET XGruSan PICT "@!"
         READ
         ULtTECLA = LASTKEY()
         @  9,49 SAY XGruSan PICT "@!"
      CASE i = 15
         @  9,63 GET XNroTar PICT "##########"
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @  9,63 SAY XNroTar PICT "##########"
      CASE i = 16
         SELE TABL
         XsTabla  = 'GP'
         @ 11,21 GET XGrpPer PICT REPLICATE("9",Len(XGrpPer))
         READ
         UltTecla= Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF ULTTECLA = F8
            DO TABLA WITH XsTabla,XGrpPer
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         SEEK XsTabla+XGrpPer
         @ 11,21 SAY XGrpPer
         IF ! FOUND()
            GsMsgErr = "C¢digo Lugar de Pago no Registrado"
         ENDIF
      *  @ 11,22 SAY Left(TabL->Nombre,12)
      *  @ 11,18 GET XGrpPer PICT "@!"
      *  READ
      *  ULTTECLA = LASTKEY()
      *  IF UltTecla = Escape
      *     EXIT
      *  ENDIF
      *  @ 11,18 SAY XGrpPer PICT "@!"
      CASE I =17
         SELE TABL
         XsTabla  = 'CT'
         @ 10,39 GET XTpoCta PICT REPLICATE("9",Len(XTpoCta))
         READ
         UltTecla= Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF ULTTECLA = F8
            DO TABLA WITH XsTabla,XTpoCta
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         SEEK XsTabla+XTpocta
         @ 10,39 SAY XTpoCta
         IF ! FOUND()
            GsMsgErr = "Tipo de Cuenta no Regeistrada"
         ENDIF
      CASE i = 18
         @ 11,42 GET XCtaHor PICT "@!"
         READ
         UltTecla= Lastkey()
         @ 11,42 SAY XCtaHor
      CASE i = 19
         XsTabla = "02"
         @ 11,63 GET XCtaCts PICT REPLICATE("9",LEN(XCtaCts))
         READ
         ULtTECLA = LASTKEY()
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XCtaCts
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         SEEK XsTabla+XCtaCts
         IF ! FOUND()
            GsMsgErr = "C¢digo de Centro de Costo no Registrado"
            DO LIB_MERR WITH 0
            LOOP
         ENDIF
         @  11,63 SAY Left(TabL->Nombre,13)
      CASE i = 20
         @ 13,20 GET XDirecc PICT "@!"
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @ 13,20 SAY XDirecc
      CASE i = 21
         @ 13,60 GET XTlfPer PICT REPLICATE("9",Len(XTlfPer))
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @ 13,60 SAY XTlfPer
      CASE i = 22
         @ 14,20 GET XLocali PICT "@!"
         READ
         UltTecla= Lastkey()
         @ 14,20 SAY XLocali
      CASE i = 23
         SELECT TABL
         XsTabla  = '11'
         @ 14,54 GET XUbiGeo PICT REPLICATE("9",Len(XUbiGeo))
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XUbiGeo
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @ 14,54 SAY XUbiGeo
         SEEK XsTabla+XUbiGeo
         IF ! FOUND()
            GsMsgErr = "C¢digo No Registrado"
         ENDIF
         @ 14,57 SAY LEFT(TABL->Nombre,12)
      CASE i = 24
         @ 15,20 GET XFchNac
         READ
         UltTecla= Lastkey()
         @ 15,20 SAY XFchNac
         IF CTOD("  /  /  ") <> XFchNac
            Edad = INT( ( VAL(DTOC(Date(),1))-VAL(DTOC(XFchNac,1)) )/10000 )
            @ 15,36 SAY Edad PICT "##"
         ELSE
            @ 15,36 SAY 0 PICT "##"
         ENDIF
      CASE i = 25
         @ 15,54 GET XProvin PICT "@!"
         READ
         ULTTECLA = LASTKEY()
         @ 15,54 SAY XProvin
      CASE i = 26
         @ 16,20 GET XNhijos PICT "99"
         READ
         ULTTECLA = LASTKEY()
         @ 16,20 SAY XNhijos PICT "99"
      CASE i = 27
         @ 16,37 GET XNcgfaM  PICT "9"
         READ
         ULTTECLA = LASTKEY()
         @ 16,37 SAY XNcgFam  PICT "9"
      CASE i = 28
         VecOpc(1)="Soltero/a   "
         VecOpc(2)="Casado/a    "
         VecOpc(3)="Divorciado/a"
         VecOpc(4)="Viudo/a     "
         VecOpc(5)="Conviviente "
         XEstCvl = Elige(XEstCvl,16,54,5)
         DO CASE
            CASE XESTCVL = "Soltero/a   "
                 XESTCVL = "1"
            CASE XESTCVL = "Casado/a    "
                 XESTCVL = "2"
            CASE XESTCVL = "Divorciado/a"
                 XESTCVL = "3"
            CASE XESTCVL = "Viudo/a     "
                 XESTCVL = "4"
            CASE XESTCVL = "Conviviente "
                 XESTCVL = "5"
         ENDCASE
      CASE i = 29
         @ 17,20 GET XN_ipss PICT "@!"
         READ
         UltTecla= Lastkey()
         @ 17,20 SAY XN_ipss PICT "@!"
      CASE i = 30
         @ 17,54 GET XCarAfp PICT "@!"
         READ
         UltTecla= Lastkey()
         @ 17,54 SAY XCarAfp PICT "@!"
      CASE i = 31
         @ 18,20 GET XLElect PICT "@!"
         READ
         UltTecla= Lastkey()
         @ 18,20 SAY XLElect
      CASE i = 32
         @ 18,54 GET XLMilit PICT "@!"
         READ
         UltTecla= Lastkey()
         @ 18,54 SAY XLMilit
      CASE i = 33
         SELECT TABL
         XsTabla  = '23'
         @ 19,20 GET XCodAfp PICT REPLICATE("9",Len(XCodAfp))
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TABLA WITH XsTabla,XCodAfp
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @ 19,20 SAY XCodAfp
         SEEK XsTabla+XCodAfp
         IF ! FOUND()
            GsMsgErr = "C¢digo de Afp No Registrado"
         ENDIF
         @ 19,23 SAY Left(TabL->Nombre,12)
      CASE i = 34
         @ 20,20 GET XFchIng
         READ
         UltTecla= Lastkey()
         @ 20,20 SAY XFchIng
         IF CTOD("  /  /  ") <> XFchIng
            Serv = INT( ( VAL(DTOC(Date(),1))-VAL(DTOC(XFchIng,1)) )/10000 )
            IF DAY(DATE())>DAY(XFchIng)
               Dias = DAY(DATE()) - DAY(XFchIng)
               Mese = MONTH(DATE())
            ELSE
               Dias = DAY(DATE() - DAY(DATE())) + DAY(DATE()) - DAY(XFchIng)
               Mese = MONTH(DATE()) - 1
            ENDIF
            IF Mese>=MONTH(XFchIng)
               Mesi = Mese - MONTH(XFchIng)
            ELSE
               Mesi = Mese - MONTH(XFchIng) + 12
            ENDIF
            @ 20,40 SAY Serv PICT "##"
            @ 20,48 SAY Mesi PICT "##"
            @ 20,57 SAY Dias PICT "##"
         ELSE
            @ 20,40 SAY 0    PICT "##"
            @ 20,48 SAY 0    PICT "##"
            @ 20,57 SAY 0    PICT "##"
         ENDIF
      CASE i = 35
         SAVE SCREEN TO SC001
         @ 16,31 CLEAR TO 21,65
         @ 16,31 TO 21,65 DOUBLE
         @ 17,33 SAY "Ingreso al Grupo    : " GET XFcingr
         @ 18,33 SAY "Inicio de Contrato  : " GET XFCtoIn
         @ 19,33 SAY "Termino de Contrato : " GET XFCtoFi
         @ 20,33 SAY "Fecha Anterior Ing. : " GET XFAntIn
         READ
         UltTecla= Lastkey()
         RESTORE SCREEN FROM SC001
      CASE i = 36
         @ 21,20 GET XFchCes
         READ
         UltTecla= Lastkey()
         @ 21,20 SAY XFchCes
		 if ctod("  /  /  ") <> Xfchces
			Serv = INT( ( VAL(DTOC(XFchces,1))-VAL(DTOC(XFchIng,1)) )/10000)
			IF DAY(XFCHCES)>DAY(XFchIng)
				dias=day(Xfchces)-day(Xfching)
				mese=month(XFCHCES)
			ELSE
				Dias = DAY(DATE() - DAY(DATE())) + DAY(XFchces) - DAY(XFchIng)	
				mese=month(XFCHCES)-1
			ENDIF
			IF Mese>=MONTH(XFching)
				Mesi = Mese - MONTH(XFchING)
			ELSE
				Mesi = Mese - MONTH(XFchING) + 12
			ENDIF
			@ 20,40 SAY Serv PICT "##"
			@ 20,48 SAY Mesi PICT "##"
			@ 20,57 SAY Dias PICT "##"
		 endif	
      CASE i = 37
         @ 19,50 GET XFchAfp
         READ
         UltTecla= Lastkey()
         @ 19,50 SAY XFchAfp
      CASE i = 38
         @ 19,69 GET XFchcon
         READ
         UltTecla= Lastkey()
         @ 19,69 SAY XFchcon
      CASE i = 39
         SAVE SCREEN TO SC001
         @16,31 CLEAR TO 21,65
         @16,31 TO 19,65 DOUBLE
         @ 17,33 SAY "Fecha fin Convenio  : " GET XFchfin
         READ
         UltTecla= Lastkey()
         RESTORE SCREEN FROM SC001
      CASE i = 40
         @ 20,72 GET Xgerec
         READ
*         IF XGEREC<>[G] OR XGEREC<>[N]
*         	WAIT WINDOW "ENTRADA NO VALIDA"
*         	CLEAR READ
*         ENDIF
         UltTecla= Lastkey()
         @ 20,72 SAY Xgerec
      CASE i = 41
         SELECT TABL
         XsTabla  = '20'
         @ 21,41 GET XMesVac PICT "99"
         READ
         ULTTECLA=Lastkey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            DO TA\BLA WITH XsTabla,XMesVac
            IF LASTKEY() = 27
               LOOP
            ENDIF
         ENDIF
         @ 21,41 SAY XMesVac
         SEEK XsTabla+XMesVac
         IF ! FOUND()
            GsMsgErr = "Mes No Registrado"
         ENDIF
         @ 21,44 say left(tabl->nombre,9)
      CASE i = 42
         @ 21,66 GET XPervac
         READ
         UltTecla= Lastkey()
         @ 21,66 SAY XPervac
         IF UltTecla = Enter .or. UltTecla=Escape
            EXIT
         ENDIF
   ENDCASE
   I = IIF(UltTecla = Arriba,I-1,I+1)
   I = IIF(I>42,42,i)
   I = IIF(I<1,1,I)
ENDDO
SELECT PERS
IF UltTecla <> Escape
   IF EOF()                  && Creando
      SEEK XCodPer
      IF FOUND()
         DO LIB_MERR WITH 11
         RETURN
      ENDIF
      APPEND BLANK
      IF !RLOCK()
         RETURN              && No pudo bloquear registro
      ENDIF
      REPLACE CodPer WITH XCodPer
   ENDIF
   **************************************************************************
   ** REEMPLAZA CAMPOS
   **************************************************************************
   REPLACE NomPer WITH XNomPer
   REPLACE CodPln WITH XCodPln
   REPLACE CodSec WITH XCodSec
   REPLACE CodCar WITH XCodCar
   REPLACE PROGRA WITH XPROGRA
   REPLACE Gra_Sg WITH XGra_Sg
   REPLACE NPLAZA WITH XNPLAZA
   REPLACE GrpPer WITH XGrpPer
   REPLACE NOMPER WITH XNOMPER
   REPLACE Direcc WITH XDirecc
   REPLACE Locali WITH XLocali
   REPLACE Ubigeo WITH XUbigeo
   REPLACE Provin WITH XProvin
   REPLACE TlfPer WITH XTlfPer
   REPLACE Sexper WITH TRIM(XSexPer)
   REPLACE GrdIns WITH XGrdIns
   REPLACE ProPer WITH XProPer
   REPLACE NroTar WITH XNroTar
   REPLACE EstCvl WITH TRIM(XEstCvl)
   REPLACE FchNac WITH XFchNac
   REPLACE Nacion WITH XNacion
   REPLACE LElect WITH XLElect
   REPLACE LMilit WITH XLMilit
   REPLACE N_ipss WITH XN_ipss
   REPLACE FchIng WITH XFchIng
   REPLACE FchCes WITH XFchCes
   REPLACE FCtoIn WITH XFCtoIn
   REPLACE FCtoFi WITH XFCtoFi
   REPLACE FchAnt WITH XFAntIn
   REPLACE FVacIn WITH XFVacIn
   REPLACE FVacFi WITH XFVacFi
   REPLACE CTAHOR WITH XCTAHOR
   REPLACE TPOCTA WITH XTPOCTA
   REPLACE LugPag WITH XLugPag
   REPLACE NHIJOS WITH XNHIJOS
   REPLACE NCGFAM WITH XNCGFAM
   REPLACE DesCar WITH XDesCar
   REPLACE CtaCts WITH XCtaCts
   REPLACE MesVac WITH XMesVac
   REPLACE GRUSAN WITH XGRUSAN
   REPLACE CARAFP WITH XCarAfp
   REPLACE CODAFP WITH XCodAfp
   REPLACE QUINQE WITH XQuinQe
   REPLACE Division WITH xDivision
   REPLACE Area     WITH xArea
   REPLACE FchAFP   WITH XFchAFP
   REPLACE Pervac   WITH XPervac
   REPLACE FchCon   WITH XFchCon
   REPLACE Fcingr   WITH XFcingr
   REPLACE Fchfin   WITH XFchfin
   REPLACE Gerec    WITH Xgerec
ENDIF
UNLOCK
DO LIB_MTEC WITH 3
RETURN
**********************************************************************
* Edita datos en la pantalla ( Modificar , Anular )                  *
**********************************************************************
PROCEDURE PERElimi
**********************************************************************
IF .NOT. RLock()
   RETURN                 && No pudo bloquear registro
ENDIF
DELETE
SKIP
UNLOCK
DO LIB_MTEC WITH 3
RETURN
**********************************************************************
PROCEDURE PERLista
**********************************************************************
PRIVATE XlRecno,cPnt
SAVE SCREEN TO cPnt
XlRecno=RECNO()
xFor   = []
xWhile = []
**SEEK VClave
sNomRep = "PLNMPERS"
DO ADMPRINT WITH "REPORTS"
RESTORE SCREEN FROM cPnt ADDIT
IF EOF()
  GOTO BOTTOM
ELSE
  GOTO (XlRecno)
ENDIF
RETURN
**********************************************************************
PROCEDURE EligeOpc
**********************************************************************
PARAMETERS LiOpcion
SAVE SCREEN
GsMsgKey = "[ ] Posiciona.  [Enter] Registrar.  [Esc] Salir."
DO lib_Mtec with 99
@14,23 CLEAR TO 19,55
@14,23       TO 16,55 DOUBLE COLOR W+
@15,29 SAY   " Registro de Personal " COLOR W+
@17,23       TO 19,55 DOUBLE COLOR W+
@18,26 GET   LiOpcion PICTURE  '@*H \<Empleados  ;\<Obreros    '
READ CYCLE
RESTORE  SCREEN
UltTecla = LASTKEY()
RETURN LiOpcion
