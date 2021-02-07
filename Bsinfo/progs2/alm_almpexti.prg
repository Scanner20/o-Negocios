*!*	=F1_BASE(GsNomCia,GsNomSub,"Usuario:"+GsUsuario,GsFecha)
LsSubAlm = [   ]
LdFch1   = CTOD("01/"+STR(_Mes,2,0)+"/"+STR(_Ano,4,0))
LdFch2   = GdFecha
M.SUCURSAL  = []
M.UNIDAD    = 1
M.DRIVE     = 1
cDrive      = [A:]
XcTipo      = IIF(GsCodCia=[001],[Insumos],[Repuestos])
lExtAlma = .T.
lExtCalm = .T.
lExtCatg = .T.
lExtMOVI = .T.
lExtCftr = .T.
lExtCdoc = .T.
lExtdivf = .T.
lExtIni  = .F.
lReindex = .t.
lCentral = .f.
TfCanDes = 0
TfImpNac = 0
TfImpUsa = 0
m.salir  = 1
UltTecla = 0
LcSLash     = [\]


zOpc=F1_ALERT([Este proceso EXPORTA informaci¢n de los almacenes de una  ;]+;
             [SEDE para ser recepcionados en otra, los datos seran gra- ;]+;
             [bados en diskette para ser recepcionada en otra SEDE por  ;]+;
             [medio de la opci¢n de IMPORTACION de informaci¢n.         ;]+;
             [Este proceso abre las bases de datos en forma exclusiva,  ;]+;
             [por lo que ser  la £nica tarea a realizarse en el sistema.;]+;
             [                                                          ;]+;
             [Este proceso genera un archivo : ALMaamm.xxy en el direc- ;]+;
             [torio \APLICA\TRASLADO\. xx = Sede,  y = Insumos o Repues-;]+;
             [tos                                                       ;],4)


*[Si existen problemas por falta de memoria sera necesario  ;]+;
*[hacerlo externamente haciendo lo siguiente desde el DOS : ;]+;
*[ - Posicionese en el directorio APLICA.                   ;]+;
*[ - Digite EXTCPI CPIaamm.DAT A:                           ;]+;
*[                     ³       ³                            ;]+;
*[                  archivo    unidad destino               ;],4)



IF zOpc#1
    RETURN
ENDIF

IF UltTecla = K_ESC
   RETURN
ENDIF
UltTecla = 0

m.Dir_Orig = CURDIR()
SET DEFA TO (PAThTRAS)
m.Dir_act = CURDIR()
IF SYS(5)+m.Dir_Act#PATHTRAS
**IF m.Dir_Act#"\APLICA\TRASLADO\"
	SET DEFA TO PATHDEF
	!MD TRASLADO
	!CD \APLICA\TRASLADO
	m.Dir_act = CURDIR()
	IF m.Dir_Act#"\APLICA\TRASLADO\"
		DO F1MSGERR WITH [Imposible crear directorio de transferencia de datos]
	ENDIF
ENDIF
SET DEFA TO (m.Dir_Orig)
IF !FILE("SEDES.DBF")
	DO F1MSGERR WITH [No existe la tabla SEDES.DBF]
	RETURN
ENDIF

goentorno.open_dbf1('ABRIR','SEDES','SEDE','SEDE01','')
*!*	SELE 0
*!*	USE SEDES ALIAS SEDE
*!*	IF !USED()
*!*		CLOSE DATA
*!*		RETURN
*!*	ENDIF
SET FILTER TO Activa=[X]
GO TOP

private xact
COUNT TO Xact FOR Activa=[X]

IF Xact>1
	=F1_ALERT([Existe m s de una sede activa marque con una X solo a  ;]+;
			  [la sede en que se esta ejecutando el sistema.          ;]+;
			  [Puede hacerlo en el menu principal de aplica en el menu;]+;
			  [de configuraciones.                                    ;],3)
	RETURN
ENDIF

IF Xact<=0
	=F1_ALERT([No esta marcada la sede activa.                        ;]+;
			  [Marque con una X a la sede en que se esta ejecutando el;]+;
			  [sistema. Salga hasta el menu pricipal de aplica y entre;]+;
			  [a la opci¢n de configuraci¢n.                          ;],3)
	RETURN
ENDIF
GO TOP

M.SEDE = SEDE.CODIGO
lCentral = SEDE.Central
private vSede_exp
dimension vSede_exp(1)
nse=0
IF lCentral
	SET FILTER TO
	SCAN FOR !activa=[X]
		nse=nse+1
		IF ALEN(vSede_Exp)<nse
			DIMENSION vSede_exp(nse+1)
		ENDIF
		vSede_exp(nse)=Codigo+[ ]+LEFT(Nombre,15)		
	ENDSCAN
	IF nse<>0
		DIMENSION vSede_exp(nse)
	ENDIF
	DIMENSION vSede_Exp(nSe+1)
	vSede_exp(nse+1)=[ACTUAL]
	m.Sede_exp=NSE
ELSE	
	DIMENSION vSede_Exp(nSe+1)
	vSede_exp(nse+1)=[ACTUAL]
	m.Sede_exp=NSE+1
ENDIF
SET FILTER TO Activa=[X]
GO TOP
goentorno.open_dbf1('ABRIR','ALMTALMA','ALMA','ALMA01','')
*!*	SELE 0
*!*	USE ALMTALMA ORDER ALMA01 ALIAS ALMA
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
LsSubAlm = SPACE(LEN(ALMA.SubAlm))
XsPathTras = PATHTRAS
cDrive     = JUSTPATH(XsPathTras)
DO almpexti.spr
IF UltTecla = K_ESC
	M.CURRWIN = WOUTPUT()
	IF !EMPTY(M.CURRWIN)
		RELEASE WINDOW (M.CURRWIN)
	ENDIF
	RETURN
ENDIF
XsSede_Exp=LEFT(vsede_exp(m.Sede_Exp),3)
IF XsSede_Exp#[ACT]
	m.Sede=XsSede_Ext
ENDIF
LsSubALm = TRIM(LsSubAlm)
SET CURSOR OFF
LfHoraIni = SECONDS()
SET CLOCK TO 03,02
DO CASE
	CASE _Unix
		LcSlash = [/]
	CASE _Dos
		LcSlash = [\]
	CASE _wINDOWS
		LcSlash = [\]
ENDCASE
XsPathtras=ADDBS(XsPathTras)
IF lExtalma
    SELE ALMA
	ARCTRA =XsPATHTRAS+[TALMA]+m.sede
	COPY TO &ARCTRA.
ENDIF
IF lExtCalm
	DO Extcalm
ENDIF
IF lExtCatg
	DO EXTcatg
ENDIF
IF lExtMovi
	DO EXTmovi
ENDIF
IF lExtCftr
	DO EXTcftr
ENDIF
IF lExtCdoc
	DO EXTcdoc
ENDIF
IF lExtDIVF
	DO EXTDIVF
ENDIF
=F1QEH([OK])
LsCanDes =TRAN(TfCanDes,"9999,999,999")
LsImpNac =TRAN(TfImpNac,"9999,999,999")
SET CURSOR ON
M.CURRWIN = WOUTPUT()
IF !EMPTY(M.CURRWIN)
	RELEASE WINDOW (M.CURRWIN)
ENDIF
VsCurDir= m.Dir_Orig
VsDrive = cDrive
VsRuta  = PATHDEF+[\]
VsArcDes=[ALM]+right(TRAN(_ANO,'9999'),2)+TRAN(_MES,"@L ##")+[.]+right(m.sede,2)+LEFT(XcTipo,1)
Vsbatch =[ALM]+m.sede
VsRuta  =ADDBS(JUSTPATH(LOCFILE(Vsbatch,[BAT;EXE],[Buscar ]+VsBatch)))
IF !EMPTY(VsRuta)
	RUN &VsRuta.&vsbatch. &VsArcDes. &VsDrive.
	SET DEFA TO (VsCurDir)
ELSE
	=F1_ALERT([El archivo de proceso por lotes ]+VsBatch+[ no se puede localizar.;]+;
			  [Verificar en Menu -> Mantenimiento\Configuración de sistema],[MENSAJE])	
ENDIF
=F1QEH([PROCESO TERMINADO])
LfHoraFin = SECONDS()
DO CASE
	CASE (LfHoraFin - LfHoraIni)/(60*60)>1
		LfHora    = INT((LfHoraFin - LfHoraIni)/(60*60))
		LfMinutos = ROUND((LfHoraFin - LfHoraIni)/(60*60) - INT((LfHoraFin - LfHoraIni)/(60*60)),0)*60
		LsHora=TRAN(LfHora,'@L ##')+[Hrs ]+TRAN(LfMinutos,'99')+[Min]
	CASE (LfHoraFin - LfHoraIni)/(60*60)<=1
		IF (LfHoraFin - LfHoraIni)/60>1
			LfMinutos = INT((LfHoraFin - LfHoraIni)/60)
			LfSegundos= ROUND((LfHoraFin - LfHoraIni)/60 - INT((LfHoraFin - LfHoraIni)/60),2)*60
			IF LfSegundos>=60
				LfMinutos = LfMinutos + INT(LfSegundos/60)
				LfSegundos= (LfSegundos - INT(LfSegundos))*60
			ENDIF
			LsHora=TRAN(Lfminutos,'@L ##')+[Min ]+TRAN(Lfsegundos,'99')+[ Seg]
		ELSE
			LfSegundos= ROUND(LfHoraFin - LfHoraIni,2)
			LsHora=TRAN(Lfsegundos,'99.99')+[ Seg]
		ENDIF
ENDCASE
SET CLOCK OFF
WAIT WINDOW [OK] NOWAIT
WAIT WINDOW [DURACION DEL PROCESO :]+LsHora NOWAIT
RETURN
*****************
PROCEDURE EXTCALM
*****************
goentorno.open_dbf1('ABRIR','ALMCATAL','CALM','CATA01','')
*!*	SELE 0
*!*	USE ALMCATAL ORDER CATA01 ALIAS CALM
*!*	IF !USED()
*!*	    CLOSE DATA
*!*	    RETURN .F.
*!*	ENDIF
ArcTra = XsPATHTRAS+[CATAL]+m.sede
COPY STRU TO &ArcTra. WITH CDX
SELE 0
USE &ArcTra. ALIAS CALMX EXCLU
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
SELE CALM
WAIT WINDOW [Transfiriendo codigos por almacen ] NOWAIT
GO TOP
SCAN FOR SubAlm = LsSubAlm
	WAIT WINDOW CodMat+[ ]+SubAlm NOWAIT
	SCATTER MEMVAR
	SELE CALMX
	APPEND BLANK
	GATHER MEMVAR
	SELE CALM
ENDSCAN
RETURN
*****************
PROCEDURE EXTCATG
*****************
goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
*!*	SELE 0
*!*	USE ALMCATGE ORDER CATG01 ALIAS CATG
*!*	IF !USED()
*!*	    CLOSE DATA
*!*	    RETURN .F.
*!*	ENDIF
ArcTra = XsPATHTRAS+[CATGE]+m.sede
COPY STRU TO &ArcTra. WITH CDX
SELE 0
USE &ArcTra. ALIAS CATGX EXCLU
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
SELE CATG
WAIT WINDOW [Transfiriendo Catalogo general] NOWAIT
GO TOP
SCAN
	SCATTER MEMVAR
	SELE CATGX
	APPEND BLANK
	GATHER MEMVAR
	SELE CATG
ENDSCAN
RETURN
*****************
PROCEDURE EXTMOVI
*****************
IF !USED([ALMA])
	goentorno.open_dbf1('ABRIR','ALMTALMA','ALMA','ALMA01','')
*!*		USE ALMTALMA ORDER ALMA01 ALIAS ALMA
*!*		IF !USED()
*!*			CLOSE DATA
*!*			RETURN .F.
*!*		ENDIF
ENDIF
WAIT WINDOW [Verificando informaci¢n...Un momento por favor.] nowait
SELE 0
IF LREINDEX
	goentorno.open_dbf1('ABRIR','ALMDTRAN','DTRA','DTRA10','EXCLU')
*!*		USE ALMDTRAN ORDER DTRA10 ALIAS DTRA EXCLU
ELSE
	goentorno.open_dbf1('ABRIR','ALMDTRAN','DTRA','DTRA10','')
*!*		USE ALMDTRAN ORDER DTRA10 ALIAS DTRA
ENDIF
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
IF lReindex
	INDEX ON DTOS(Fchdoc)+CodMat+TipMov+CodMov+NRODOC TAG DTRA10
ENDIF
ArcTra = XsPATHTRAS+[DTRAN]+m.sede
COPY STRU TO &ArcTra. WITH CDX
SET RELA TO SUBALM INTO ALMA	
SELE 0
USE &ArcTra. ALIAS DTRAX  EXCLU
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
WAIT WINDOW [Ya casi estamos listos...Un momento por favor.] NOWAIT
SELE 0
IF LREINDEX
	goentorno.open_dbf1('ABRIR','ALMCTRAN','CTRA','CTRA01','EXCLU')
*!*		USE ALMCTRAN ORDER CTRA01 ALIAS CTRA EXCLU
ELSE
	goentorno.open_dbf1('ABRIR','ALMCTRAN','CTRA','CTRA01','')
*!*		USE ALMCTRAN ORDER CTRA01 ALIAS CTRA 
ENDIF	
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
IF lReindex
	INDEX ON SUBALM+TIPMOV+CODMOV+NRODOC TAG CTRA01
ENDIF
ArcTra = XsPATHTRAS+[CTRAN]+m.sede
COPY STRU TO &ArcTra. WITH CDX
SELE 0
USE &ArcTra. ALIAS CTRAX  EXCLU
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
SET ORDER TO CTRA01
TfCanDes = 0
TfImpNac = 0
TfImpUsa = 0
CanCelar = .f.
WAIT WINDOW [TRANSFIRIENDO MOVIMIENTOS UN MOMENTO POR FAVOR...] NOWAIT
SELE DTRA
SEEK DTOS(LdFch1)
IF !FOUND() AND RECNO(0)>0
    GO RECNO(0)
ENDIF
SCAN WHILE FchDoc>=LdFch1 AND FchDoc<=LdFch2 AND !Cancelar FOR SubAlm=LsSubAlm
	IF !ALMA.CODALM=M.SEDE	
		LOOP	 		
	ENDIF 				
	WAIT WINDOW Subalm+[ ]+Tipmov+[ ]+CodMov+[ ]+NroDoc+[ ]+DTOC(FchDoc) NOWAIT
	fCanDes = DTRA->CanDes
	fImpNac = DTRA.ImpNac
	fImpUsa = DTRA.ImpUsa
	fStkSub = DTRA.StkSub
	fCanDes = IIF(DTRA.Factor>0,DTRA->CanDes * DTRA->Factor,fCanDes)
	cAjuste = IIF(DTRA.CodAjt#[A]," ","@")
	fPCtoMn = IIF(fCanDes#0,fImpNac/fCanDes,fImpNac)
	fPCtoUs = IIF(fCanDes#0,fImpUsa/fCanDes,fImpUsa)
	IF DTRA->TipMov $ "RI"
		IF fCanDes > 0
			iImpNac  = fCanDes*fPCtoMn
			iImpUsa  = fCanDes*fPCtoUs
		ELSE
			iImpNac  = ABS(fCanDes*fPCtoMn)
			iImpUsa  = ABS(fCanDes*fPCtoUs)
		ENDIF
		TfCanDes = TfCanDes + fCandes
		TfImpNac = TfImpNac + iImpNac
		TfImpUsa = TfImpUsa + iImpUsa
	ELSE
		IF fCanDes > 0
			iImpNac  = fCanDes*fPCtoMn
			iImpUsa  = fCanDes*fPCtoUs
		ELSE
			iImpNac  = ABS(fCanDes*fPCtoMn)
			iImpUsa  = ABS(fCanDes*fPCtoUs)
		ENDIF
		TfCanDes = TfCanDes - fCandes
		TfImpNac = TfImpNac - iImpNac
		TfImpUsa = TfImpUsa - iImpUsa
	ENDIF
	SCATTER MEMVAR
	SELE DTRAX
	APPEND BLANK
	GATHER MEMVAR
	REPLACE CODALM WITH M.SEDE
	SELE CTRA
	SEEK DTRAX.SubAlm+DTRAX.TipMov+DTRAX.CodMov+DTRAX.NroDoc
	IF FOUND()
		SCATTER MEMVAR
		SELE CTRAX
		SEEK DTRAX.SubAlm+DTRAX.TipMov+DTRAX.CodMov+DTRAX.NroDoc
		IF !FOUND()
			APPEND BLANK
			GATHER MEMVAR
			REPLACE CODALM WITH M.SEDE
		ENDIF
	ENDIF
	SELE DTRA
	Cancelar = (INKEY()=K_ESC OR Cancelar)
ENDSCAN
RETURN
*****************
PROCEDURE ExtCdoc
*****************
goentorno.open_dbf1('ABRIR','ALMCDOCM','CDOC','CDOC01','')
*!*	SELE 0
*!*	USE ALMCDOCM ORDER CDOC01 ALIAS CDOC
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
ArcTra = XsPATHTRAS+[CDOCM]+m.sede
COPY STRU TO &ArcTra. WITH CDX
SELE 0
USE &ArcTra. ALIAS CDOCX EXCLU
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
SELE CDOC
WAIT WINDOW [Exportando tabla de correlativos] NOWAIT
GO TOP
SCAN
	WAIT WINDOW Subalm+[ ]+Tipmov+[ ]+CodMov NOWAIT
	SCATTER MEMVAR
	SELE CDOCX
	APPEND BLANK
	GATHER MEMVAR
	SELE CDOC
ENDSCAN
RETURN
*****************
PROCEDURE ExtCFTR
*****************
goentorno.open_dbf1('ABRIR','ALMCFTRA','CFTR','CFTR01','')
*!*	SELE 0
*!*	USE ALMCFTRA ORDER CFTR01 ALIAS CFTR
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
ArcTra = XsPATHTRAS+[CFTRA]+m.sede
COPY STRU TO &ArcTra.
SELE 0
USE &ArcTra. ALIAS CFTRX EXCLU
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN .F.
*!*	ENDIF
SELE CFTR
WAIT WINDOW [TRANSFIRIENDO CONFIGURACION DE TRANSACCIONES] NOWAIT
GO TOP
SCAN
	WAIT WINDOW TIPMOV+[ ]+CODMOV+[ ]+DESMOV NOWAIT
	SCATTER MEMVAR
	SELE CFTRX
	APPEND BLANK
	GATHER MEMVAR
	SELE CFTR
ENDSCAN
RETURN
*****************
PROCEDURE Extdivf
*****************
goentorno.open_dbf1('ABRIR','ALMTDIVF','DIVF','DIVF01','')
*!*	SELE 0
*!*	USE ALMtdivf ORDER divf01 ALIAS divf
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
ArcTra = XsPathTras+[TDIVF]+m.sede
COPY STRU TO &ArcTra. WITH CDX
SELE 0
USE &ArcTra. ALIAS DIVFX
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
SELE DIVF
GO TOP
WAIT WINDOW [TRANSFIRIENDO TABLA DE DIVISIONES Y FAMILIAS] NOWAIT
SCAN
	SCATTER MEMVAR
	SELE DIVFX
	APPEND BLANK
	GATHER MEMVAR
	WAIT WINDOW CLFDIV+[ ]+CODFAM+[ ]+DESFAM NOWAIT
	SELE DIVF
ENDSCAN
RETURN
