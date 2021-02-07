*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý almimdac.prg                                                Ý
*Ý---------------+--------------------------------------------a----------------Ý
*Ý Sistema       Ý Almacenes e Inventarios                                     Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 5755242 - 9180457              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Inf. movimiento diario de almacen en cantidad y/o valor.    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 08/03/96                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý 22/JUN/1999 Formato para productos terminados               Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
*=f1_base(gsnomcia,gsnomsub,"USUARIO:"+gsusuario,"FECHA:"+gsfecha)
PUBLIC  arcctb,lsencab1,lsencab2,lsencab3,lsencab4,lsencab5,haytransfer,;
movtra,m.tipo,m.tipmat,m.general,ulttecla,m.control,cancelar,m.Sel_Col,; 
m.Ctrl_Ctb,m.Estado_R,nSedes,m.codmatd,m.codmath,m.desmatd,m.desmath,;
ncodmon,m.cuales,m.contable,XsCodMod,dfchdocd,dfchdoch,m.estado,m.sede,;    
m.DesSed,sayuda_o1,m.control,ulttecla 

arcctb = []
lsencab1 = []
lsencab2 = []
lsencab3 = []
lsencab4 = []
lsencab5 = []
haytransfer = .F.
movtra   = []
m.tipo   = 1   && 1 Cantidad , 2 Valor
m.tipmat = 1
m.general = .F.
ulttecla  = 0
m.control = 1
cancelar  = .F.
m.Sel_Col = .F.
m.Ctrl_Ctb = .f.
m.Estado_R = 1   && 1 Todos 2 Solo con movimientos 3 Sin movimiento
*
nSedes=2
DIMENSION vSedes(nSedes,3)
*
*IF !abrirdbfs()
*	DO f1msgerr WITH [Error en apertura de archivos]
*	CLOSE DATA
*	RETURN
*ENDIF
*** Variables necesarias ***
m.codmatd = ""
m.codmath = ""
m.desmatd = ""
m.desmath = ""
ncodmon   = 1
m.cuales  = 1
m.contable = 2
XsCodMod  = [CI01]
dfchdocd  = gdfecha
dfchdoch  = gdfecha
m.estado  = 1
m.sede    = GsCodSed
m.DesSed  = GsNomSed
*** Variables de control
sayuda_o1 = [Presione F8 para consultar]
m.control = 1
ulttecla  = 0
******************************************************************
DO FORM alm_almimdac && llamada al formulario
******************************************************************

*ven_actual = WOUTPUT()
*IF !EMPTY(ven_actual)
*	DEACTIVATE WINDOW (ven_actual)
*	RELEASE WINDOW (ven_actual)
*ENDIF
IF m.contable = 1
	IF messagebox([Desea generar el archivo de interface para la posterior;]+;
			[actualizaci¢n de el sistema contable.                  ;]+;
			[El nombre que tomar  el archivo ser  las iniciales ALM ;]+;
			[seguido del a¤o y la letra del mes contable en curso : ;]+;
			[ALMaaaam.IBD. La actualizaci¢n a contabilidad se ejecu-;]+;
			[tar  en el sistema contable, en la opci¢n de ASIENTOS  ;]+;
			[DE INTERFACE del men£ de MANTENIMIENTO.                 ],4+64+0)#7

*		CLOSE DATA
		DELE FILE &arcctb..dbf
		DELE FILE &arcctb..cdx
	ENDIF
ENDIF
*CLOSE DATA
*RELEASE arcctb,lsencab1,lsencab2,lsencab3,lsencab4,lsencab5,haytransfer,;
movtra,m.tipo,m.tipmat,m.general,ulttecla,m.control,cancelar,m.Sel_Col,; 
m.Ctrl_Ctb,m.Estado_R,nSedes,m.codmatd,m.codmath,m.desmatd,m.desmath,;
ncodmon,m.cuales,m.contable,XsCodMod,dfchdocd,dfchdoch,m.estado,m.sede,;    
m.DesSed,sayuda_o1,m.control,ulttecla 
RETURN
******************
FUNCTION abrirdbfs
******************
=f1qeh("ABRE_DBF")
SELE 0
USE almtalma ORDER alma01 ALIAS ALMA
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE almcftra ORDER cftr01 ALIAS cftr
IF !USED()
	RETURN .F.
ENDIF
*
SELE 0
USE almdtran ORDER dtra03 ALIAS dtra
IF !USED()
	RETURN .F.
ENDIF
SELE 0
USE almtdivf ORDER divf01 ALIAS divf
IF !USED()
	RETURN .F.
ENDIF
SELE 0
USE almcatal ORDER cata01 ALIAS calm
IF !USED()
	RETURN .F.
ENDIF
SELE 0
USE almcatge ORDER catg01 ALIAS catg
IF !USED()
	RETURN .F.
ENDIF
*
IF !FILE([CBDVMDLO.DBF])
	m.Ctrl_Ctb=.f.
ELSE
	SELE 0
	USE cbdVMDLO ORDER VMDL01   ALIAS VMDL
	IF !used()
	    return .f.
	ENDIF
	m.Ctrl_Ctb=.T.
ENDIF
*
SELE 0
USE SEDES ORDER SEDE01 ALIAS SEDE
IF !USED()
	CLOSE DATA
	RETURN 
ENDIF
SELE SEDE
SET FILTER TO !CENTRAL  && Central de informaci¢n
COUNT TO nSedes
DIMENSION vSedes(nSedes,3)
COPY TO ARRAY vSedes FIELDS LIKE C*,N*,A*
GO TOP


=f1qeh("OK")
RETURN .T.
*******************
PROCEDURE genreport
*******************
IF m.tipo=1
	xsarcmdlo = [ALMIMDAC.DBF]
ELSE
	xsarcmdlo = [ALMIMDAV.DBF]
ENDIF
arch = pathuser+SYS(3)
IF !FILE(xsarcmdlo)
	SELE 0
	IF m.tipo=1
		CREATE TABLE &arch. free (codmat C(LEN(catg.codmat)), stkact N(14,3),ci00 N(14,4), ;
			ci01 N(14,4),ci02 N(14,4),ci03 N(14,4),ci04 N(14,4),ci05 N(14,4),ci06 N(14,4),;
			ci07 N(14,4),ci08 N(14,4),ci09 N(14,4),ci10 N(14,4),ci11 N(14,4),ci12 N(14,4),;
			ci13 N(14,4),ci14 N(14,4),ci15 N(14,4),ci16 N(14,4),cs00 N(14,4),;
			cs01 N(14,4),cs02 N(14,4),cs03 N(14,4),cs04 N(14,4),cs05 N(14,4),cs06 N(14,4),;
			cs07 N(14,4),cs08 N(14,4),cs09 N(14,4),cs10 N(14,4),cs11 N(14,4),cs12 N(14,4),;
			cs13 N(14,4),cs14 N(14,4),cs15 N(14,4),cs16 N(14,4),cs17 N(14,4),cs18 N(14,4),;
			ct01 N(14,4),cr02 N(14,4),cncsmo N(14,4),vccsmo N(14,4),tcing N(14,4),;
			tving N(14,4),tcsal N(14,4),tvsal N(14,4),totval N(14,4),totcan N(14,4),;
			nivel C(3),stkini N(14,4),valini N(14,4),desmat c(40))
	ELSE
		CREATE TABLE &arch. FREE  (codmat C(LEN(catg.codmat)), stkact N(14,3),vi00 N(14,4), ;
			vi01 N(14,4),vi02 N(14,4),vi03 N(14,4),vi04 N(14,4),vi05 N(14,4),vi06 N(14,4),;
			vi07 N(14,4),vi08 N(14,4),vi09 N(14,4),vi10 N(14,4),vi11 N(14,4),vi12 N(14,4),;
			vi13 N(14,4),vi14 N(14,4),vi15 N(14,4),vi16 N(14,4),vs00 N(14,4),;
			vs01 N(14,4),vs02 N(14,4),vs03 N(14,4),vs04 N(14,4),vs05 N(14,4),vs06 N(14,4),;
			vs07 N(14,4),vs08 N(14,4),vs09 N(14,4),vs10 N(14,4),vs11 N(14,4),vs12 N(14,4),;
			vs13 N(14,4),vs14 N(14,4),vs15 N(14,4),vs16 N(14,4),vs17 N(14,4),vs18 N(14,4),;
			vt01 N(14,4),vr02 N(14,4),;
			cncsmo N(14,4),vccsmo N(14,4),tcing N(14,4),;
			tving N(14,4),tcsal N(14,4),tvsal N(14,4),totval N(14,4),totcan N(14,4),;
			nivel C(3),stkini N(14,4),valini N(14,4),desmat c(40)) 
	ENDIF
ELSE
	SELE 0
	USE &xsarcmdlo.
	IF !USED()
		gsmsgerr = [No se pudo abrir archivo modelo]
		*DO f1msgerr WITH gsmsgerr
		=MESSAGEBOX("ERROR : "+gsmsgerr,48)
		RETURN
	ENDIF
	COPY STRU TO &arch. WITH CDX
ENDIF
USE &arch. ALIAS tempo EXCLU
IF !USED()
	gsmsgerr = [No se pudo generar reporte]
	*DO f1msgerr WITH gsmsgerr
	=MESSAGEBOX("ERROR : "+gsmsgerr,48)
	RETURN
ENDIF
INDEX ON codmat TAG tmp01
SET ORDER TO tmp01
arch2 = pathuser+SYS(3)
SELE tempo
COPY STRU TO &arch2.
SELE 0
USE &arch2. ALIAS tempo2
IF !USED()
	gsmsgerr = [No se pudo generar reporte]
	*DO f1msgerr WITH gsmsgerr
	=MESSAGEBOX("ERROR : "+gsmsgerr,48)
	RETURN
ENDIF
INDEX ON nivel+codmat TAG tmp01
SET ORDER TO tmp01
** Creamos archivo para interface contable **
IF m.contable = 1
	**ArcCtb = PathTras+[AI]+TRAN(_ANO,[9999])+TRAN(_MES,"@L ##")+[.ALM]
	arcctb = pathuser+[ALM]+TRAN(_ano,[9999])+f1chrmes(_mes)+[.IBD]

	IF !FILE(arcctb)
		SELE 0
		CREATE TABLE &arcctb. FREE (fchdoc D(8),codaux C(8),nomaux C(30),coddoc C(4)   ,;
			nroref C(10)  ,codmon N(1)   ,tpocmb N(10,4),;
			impbrt N(14,4),impigv N(14,4),imptot N(14,4),impusa N(14,4),;
			IMPORT N(14,4),codmat C(8)   ,nrodoc C(10)  ,codmov C(4) )
		USE &arcctb. ALIAS rctb EXCLU
		IF !USED()
			gsmsgerr = [No se pudo generar reporte de interface contable]
			*DO f1msgerr WITH gsmsgerr
			=MESSAGEBOX(gsmsgerr,48)
			RETURN
		ENDIF
	ELSE
		SELE 0
		USE &arcctb. ALIAS rctb EXCLU
		IF !USED()
			gsmsgerr = [No se pudo generar reporte]
			*DO f1msgerr WITH gsmsgerr
			=MESSAGEBOX("ERROR : "+gsmsgerr,48)
			RETURN
		ENDIF
		ZAP
	ENDIF
	INDEX ON codmat+codmov TAG rctb01
ENDIF
**
DIMENSION aingres(5,4),asalida(5,4),atransf(2,3)
STORE [] TO aingres,asalida,atransf
STORE 0  TO ntoting,ntotsal,ntottrf
** Verificamos todos los tipos de transacciones que tiene informaci¢n **
DIMENSION aingres(5,4),asalida(5,4),atransf(2,3)
STORE [] TO aingres,asalida,atransf
STORE 0  TO ntoting,ntotsal,ntottrf
** Verificamos todos los tipos de transacciones que tiene informaci¢n **
IF m.general
	SELE dtra
	SET ORDER TO dtra06
	SELE calm
	SET ORDER TO cata02
ELSE
	SELE dtra
	SET ORDER TO dtra01
	SELE calm
	SET ORDER TO cata01
ENDIF
SELE cftr
SET ORDER TO cftr03
SCAN
	DO CASE
	CASE tipmov=[I]
		IF m.general
			lfound  = SEEK(tipmov+codmov,[DTRA])
		ELSE
			lfound  = SEEK(gssubalm+tipmov+codmov,[DTRA])
		ENDIF
		IF lfound
			ntoting = ntoting + 1
			IF ALEN(aingres,1)<ntoting
				DIMENSION aingres(ntoting+5,4)
			ENDIF
			aingres(ntoting,1) = tipmov+codmov
			aingres(ntoting,2) = desmov
			aingres(ntoting,3) = IIF(m.general,[],gssubalm)
			aingres(ntoting,4) = [ ]
		ENDIF
	CASE tipmov=[S]
		IF m.general
			lfound  = SEEK(tipmov+codmov,[DTRA])
		ELSE
			lfound  = SEEK(gssubalm+tipmov+codmov,[DTRA])
		ENDIF
		IF lfound
			ntotsal = ntotsal + 1
			IF ALEN(asalida,1)<ntotsal
				DIMENSION asalida(ntotsal+5,4)
			ENDIF
			asalida(ntotsal,1) = tipmov+codmov
			asalida(ntotsal,2) = desmov
			asalida(ntotsal,3) = IIF(m.general,[],gssubalm)
			asalida(ntotsal,4) = [ ]
		ENDIF
		IF TRANSF AND !haytransfer
			haytransfer = TRANSF
			movtra      = codmov
		ENDIF
	ENDCASE
ENDSCAN
SET ORDER TO cftr01
*** Trasnferencias ***
IF haytransfer
	ntottrf = ntottrf + 1
	IF ALEN(atransf,1)<ntottrf
		DIMENSION atransf(ntottrf+5,3)
	ENDIF
	atransf(ntottrf,1) = [T]+movtra
	atransf(ntottrf,2) = [Salida]
	atransf(ntottrf,3) = IIF(m.general,[],gssubalm)
	** Recepci¢n x Trasnferencia **
	ntottrf = ntottrf + 1
	IF ALEN(atransf,1)<ntottrf
		DIMENSION atransf(ntottrf+5,2)
	ENDIF
	atransf(ntottrf,1) = [R]+movtra
	atransf(ntottrf,2) = [Ingreso]
	atransf(ntottrf,3) = IIF(m.general,[],gssubalm)
ENDIF
***
okk=.F.
IF ntoting>0
	DIMENSION aingres(ntoting,4)
	okk = .T.
ENDIF
IF ntotsal>0
	DIMENSION asalida(ntotsal,4)
	okk = .T.
ENDIF
IF ntottrf>0
	DIMENSION atransf(ntottrf,3)
	okk = .T.
ENDIF

IF !okk
	*DO f1msgerr WITH [NO EXISTEN MOVIMIENTOS]
	gsmsgerr="NO EXISTEN MOVIMIENTOS"
	=MESSAGEBOX("ERROR : "+gsmsgerr,48)
	RETURN .f.
ENDIF

***
IF m.general
	SELE dtra
	SET ORDER TO dtra03
	SELE catg
	** ARMAR LOS TEST DE IMPRESION **
	m.codmatd = TRIM(m.codmatd)
	m.codmath = TRIM(m.codmath)+CHR(255)
	IF EMPTY(m.codmatd)
		GO TOP
	ELSE
		SEEK m.codmatd
		IF !FOUND()
			IF RECNO(0)>0
				GO RECNO(0)
				IF DELETED()
					SKIP
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	lswhile = [CodMat <= m.CodMatH]
	lswhile2= [DTRA.CodMat = m.CodMat]
	lsalias = ALIAS()
ELSE
	SELE calm
	** ARMAR LOS TEST DE IMPRESION **
	m.codmatd = TRIM(m.codmatd)
	m.codmath = TRIM(m.codmath)+CHR(255)
	IF EMPTY(m.codmatd)
		SEEK gssubalm
	ELSE
		SEEK gssubalm+m.codmatd
		IF !FOUND()
			IF RECNO(0)>0
				GO RECNO(0)
				IF DELETED()
					SKIP
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	lswhile = [SubAlm+CodMat <= GsSubAlm+m.CodMatH]
	lswhile2= [DTRA.SubAlm+DTRA.CodMat = GsSubAlm+m.CodMat]
	lsalias = ALIAS()
ENDIF
******************************************************************
tinici  = 0
tsaldo  = 0
fvalini = 0
tvalini = 0
STORE 0 TO fing,fsal,fving,fvsal
STORE 0 TO ting,tsal,tving,tvsal
SCAN WHILE EVAL(lswhile)	
	=SEEK(gsclfdiv+LEFT(codmat,gnlendiv),[DIVF])		
	*WAIT WINDOW "Divison: "+gsclfdiv+",CM:"+LEFT(codmat,gnlendiv)+",cFad:"+divf.codfam+",tipfamd:"+STR(divf.tipfam,2)+",timat:"+STR(m.tipmat,2) nowait
	*IF divf.tipfam#m.tipmat
	*	loop
	*ENDIF
	IF m.general	
		WAIT WINDOW catg->codmat nowait
		m.codmat = catg->codmat
		WAIT WINDOW m.codmat+[ ]+catg.desmat NOWAIT
		STORE 0 TO fstkact,fvalact,fPrcPmd
		IF !c_Val_Ini_g()
		    SELE CATG 
		    LOOP
		ENDIF
		*
		fstkini = fstkact
		fprmini = fprcpmd
		fvalini = fvalact
		*
	ELSE
		m.codmat = calm.codmat
		fstkini = calm.stkini
		fstksub = fstkini
		fvalini = IIF(ncodmon = 1, calm.vinimn, calm.vinius)
		fvalsub = fvalini
		fprmini = IIF(fstkini>0,IIF(ncodmon=1, calm.vinimn, calm.vinius)/fstkini,0)
		fprmfin = fprmini
		=SEEK( m.codmat,[CATG])
		WAIT WINDOW m.codmat+[ ]+catg.desmat NOWAIT
		SELECT dtra
		SET ORDER TO dtra03
		GO TOP
		IF EOF()
			SELE (lsalias)
			LOOP
		ENDIF
		*** HALLAR EL PRECIO PROMEDIO INICIAL GENERAL ***
		SEEK m.codmat+DTOS(dfchdocd)
		IF !FOUND()
			IF RECNO(0)>0
				GO RECNO(0)
				IF DELETED()
					SKIP
				ENDIF
			ENDIF
		ENDIF
		SKIP -1
		IF codmat = m.codmat AND fchdoc<dfchdocd
			fprmini = IIF(dtra.stkact>0,IIF(ncodmon = 1,vctomn,vctous)/dtra.stkact,0)
			fprmfin = fprmini
		ENDIF
		*** HALLAR EL PRECIO PROMEDIO FINAL GENERAL ***
		SEEK m.codmat+DTOS(dfchdoch+1)
		IF !FOUND()
			IF RECNO(0)>0
				GO RECNO(0)
				IF DELETED()
					SKIP
				ENDIF
			ENDIF
		ENDIF
		SKIP -1
		IF codmat = m.codmat AND fchdoc<=dfchdoch
			fprmfin = IIF(dtra.stkact>0,IIF(ncodmon = 1,vctomn,vctous)/dtra.stkact,0)
		ENDIF
		*** Busca el Stock de Almacen Inicial  ***
		SELE dtra
		SET ORDER TO dtra02
		SEEK gssubalm+m.codmat+DTOS(dfchdocd)
		IF !FOUND()
			IF RECNO(0)>0
				GO RECNO(0)
				IF DELETED()
					SKIP
				ENDIF
			ENDIF
		ENDIF
		m.reg_ini = RECNO()
		SKIP -1
		IF subalm+codmat = gssubalm+m.codmat AND fchdoc<dfchdocd
			fstkini = dtra->stksub
			fstksub = dtra->stksub
		ENDIF
		SKIP
		IF RECNO()<>m.reg_ini AND m.reg_ini>0
			GO m.reg_ini
		ENDIF
		* * verificamos si existen movimientos a listar * *
		IF (dtra.subalm+dtra.codmat = gssubalm+m.codmat) .AND. ;
				(dtra.fchdoc <= dfchdoch) .AND. ! EOF()
		ELSE
			fprmini = fprmfin
		ENDIF
		*** No Lista los que no tienen movimiento ***
		IF !(dtra.subalm+dtra.codmat = gssubalm+m.codmat) AND fstkini = 0
			SELE (lsalias)
			LOOP
		ENDIF
		fvalini = fstkini * fprmini
		fvalsub = fvalini
	ENDIF
	
	SELECT catg 
	regactual=RECNO()
	=SEEK(m.codmat,[CATG])
	lscadena =LEFT(catg.desmat,35)+[ ]+catg.undstk+[ ]				
	GO regactual
	
	SELE tempo
	SEEK m.codmat
	*SET STEP ON 
	IF !FOUND()
		*SET STEP ON
		APPEND BLANK		
		REPLACE codmat WITH m.codmat
		replace desmat WITH lscadena
	ENDIF
	REPLACE stkini WITH fstkini
	**REPLACE PrmIni WITH fPrmIni
	REPLACE valini WITH fvalini
	m.regtmp = RECNO()
	tvalini = tvalini + fvalini
	numele  = 0
	SELE dtra
	STORE 0 TO fing,fsal,fving,fvsal
	DO WHILE EVAL(lswhile2) .AND. (dtra.fchdoc <= dfchdoch) .AND. ! EOF()
		IF dtra->subalm = "WF " && No altera los costos ***
			SELE dtra
			SKIP
			LOOP
		ENDIF
		m.consumo = SEEK(tipmov+codmov,[CFTR]) AND cftr.modcsm
		=SEEK(tipmov+codmov,[CFTR])
		lrevalori= (TYPE("CFTR.REVALO")=[L] AND cftr.revalo)
		ingresos = dtra->tipmov $ "RID"
		fcandes = dtra->candes
		fimpcto = IIF(ncodmon = 1, dtra->impnac, dtra->impusa)
		fstksub = dtra.stksub
		fcandes = IIF(dtra.factor>0,dtra->candes * dtra->factor,fcandes)
		cajuste = IIF(dtra.codajt#[A]," ","@")
		fpreuni = IIF(fcandes#0,fimpcto/fcandes,fimpcto)
		numele  = numele   + 1
		smovi   = dtra->tipmov+dtra->codmov
		DO CASE
		CASE INLIST(gssigcia,[ATECO],[RANKIN])
			IF INLIST(smovi,[T77],[R77])
				smovi=LEFT(smovi,1)+[00]
			ENDIF
		ENDCASE
		lnposic = f_posic(smovi)
		cmpgrb1 = [C]+LEFT(smovi,1)+TRAN(lnposic,[@L ##])
		cmpgrb2 = [V]+LEFT(smovi,1)+TRAN(lnposic,[@L ##])
		IF dtra->tipmov $ "RI"
			IF fcandes >= 0
				iimporte = fcandes*fpreuni
				iimporte = IIF(lrevalori,fpreuni,fcandes*fpreuni)
				tving = tving + iimporte
				fving = fving + iimporte
				fing  = fing  + fcandes
				ting  = ting  + fcandes
			ELSE
				iimporte = ABS(fcandes*fpreuni)
				iimporte = IIF(lrevalori,fpreuni,ABS(fcandes*fpreuni))
				tvsal = tvsal + iimporte
				fvsal = fvsal + iimporte
				fsal  = fsal  + ABS(fcandes)
				tsal  = tsal  + ABS(fcandes)
			ENDIF
			SELE tempo
			IF m.tipo=1
				REPLACE &cmpgrb1. WITH &cmpgrb1. + fcandes
			ELSE
				REPLACE &cmpgrb2. WITH &cmpgrb2. + iimporte
			ENDIF
			IF m.consumo
				REPLACE cncsmo  WITH cncsmo - fcandes
				REPLACE vccsmo  WITH vccsmo - iimporte
			ENDIF
			IF dtra.tipmov=[I]
				REPLACE tcing WITH tcing + fcandes
				REPLACE tving WITH tving + iimporte
			ENDIF
		ELSE
			IF fcandes >= 0
				iimporte = fcandes*fpreuni
				iimporte = IIF(lrevalori,fpreuni,fcandes*fpreuni)
				tvsal = tvsal + iimporte
				fvsal = fvsal + iimporte
				fsal  = fsal  + fcandes
				tsal  = tsal  + fcandes
			ELSE
				iimporte = ABS(fcandes*fpreuni)
				iimporte = IIF(lrevalori,fpreuni,ABS(fcandes*fpreuni))
				tving = tving + iimporte
				fving = fving + iimporte
				fing  = fing  + ABS(fcandes)
				ting  = ting  + ABS(fcandes)
			ENDIF
			SELE tempo
			IF m.tipo=1
				REPLACE &cmpgrb1. WITH &cmpgrb1. + fcandes
			ELSE
				REPLACE &cmpgrb2. WITH &cmpgrb2. + iimporte
			ENDIF
			IF m.consumo
				REPLACE cncsmo  WITH cncsmo + fcandes
				REPLACE vccsmo  WITH vccsmo + iimporte				
			ENDIF
			IF dtra.tipmov=[S]
				REPLACE tcsal WITH tcsal + fcandes
				REPLACE tvsal WITH tvsal + iimporte
			ENDIF
		ENDIF
		DO genarcctb
		SELE dtra
		SKIP
		*IF INKEY() = k_esc
		*	cancelar = .T.
		*	EXIT
		*ENDIF
	ENDDO
	SELE tempo
	GO m.regtmp
	IF m.tipo=1
		IF !glcontra
			REPLACE totcan WITH stkini + tcing - tcsal
		ELSE
			REPLACE totcan WITH stkini + tcing + cr02 - ct01 - tcsal
		ENDIF
	ELSE
		IF !glcontra
			REPLACE totval WITH valini + tving - tvsal
		ELSE
			REPLACE totval WITH valini + tving + vr02 - vt01 - tvsal
		ENDIF
	ENDIF
	**
	DO CASE
		CASE m.Estado_R=1
		CASE m.Estado_r=2
			IF m.Tipo=1
				IF tcing=0 and cr02=0 and ct01=0 and tcsal=0 
					DELETE
				ENDIF
			ELSE
				IF tving=0 and vr02=0 and vt01=0 and tvsal=0
					DELETE
				ENDIF
			ENDIF
		CASE m.Estado_r=3
			IF m.Tipo=1
				IF tcing#0 and cr02#0 and ct01#0 and tcsal#0 
					DELETE
				ENDIF
			ELSE											
				IF tving#0 and vr02#0 and vt01#0 and tvsal#0 
					DELETE
				ENDIF						
			ENDIF	
	ENDCASE
	DO resumen WITH [TOT],[]
	DO resumen WITH [FAM],LEFT(m.codmat,gnlendiv)
	SELE (lsalias)
ENDSCAN
DO rdimension
*=f1qeh("Fin de procesamiento...")
*DO imprimir
DO FORM alm_almimdacbrowse
RETURN
*********************
PROCEDURE C_Val_Ini_g
*********************
IF !EMPTY(m.Sede)
	SELE calm
	SEEK catg->codmat
	SCAN WHILE codmat=m.codmat
		fstkact = fstkact + calm->stkini
		fvalact = fvalact + IIF(ncodmon = 1, calm->vinimn, calm->vinius)
	ENDSCAN
	SELECT dtra
	GO TOP
	IF EOF()
		SELE catg
		LOOP
	ENDIF
	** BUSCAR STOCK INICIAL **
	SEEK m.codmat+DTOC(dfchdocd,1)
	IF !FOUND()
		IF RECNO(0)>0
			GO RECNO(0)
			IF DELETED()
				SKIP
			ENDIF
		ENDIF
	ENDIF
	m.reg_ini = RECNO()
	SKIP -1
	IF codmat = m.codmat AND fchdoc < dfchdocd
		fstkact = dtra.stkact
		fvalact = IIF(ncodmon = 1,vctomn,vctous)
	ENDIF
	SKIP
	IF RECNO()<>m.reg_ini AND m.reg_ini>0
		GO m.reg_ini
	ENDIF
	*** No Lista los que no tienen movimiento ***
	IF !(dtra->codmat = m.codmat) .AND. fstkact = 0
		RETURN .f.
	ENDIF
	fprcpmd  = IIF(fstkact>0,fvalact /fstkact,0)
ELSE
	SELE calm
	SET RELA TO subalm INTO ALMA
	SEEK CATG.codmat
	SCAN WHILE codmat=m.codmat FOR ALMA.codSed=TRIM(m.Sede)
		fstkact = fstkact + calm->stkini
		fvalact = fvalact + IIF(ncodmon = 1, calm->vinimn, calm->vinius)
	ENDSCAN
ENDIF
RETURN .T.
*****************
PROCEDURE resumen
*****************
PARAMETER m.nivel,ccodmat
sele tempo
if deLeted()
	RETURN
endif
SELE tempo2
SEEK m.nivel+ccodmat
IF !FOUND()
	APPEND BLANK
	REPLACE nivel  WITH m.nivel
	REPLACE codmat WITH ccodmat
ENDIF
PRIVATE i,s
FOR i = 1 TO nTotIng
	campo1 = [CI]+TRAN(i,"@L ##")
	campo2 = [VI]+TRAN(i,"@L ##")
	IF m.tipo=1
		REPLACE &campo1 WITH &campo1. + tempo.&campo1.
	ELSE
		REPLACE &campo2 WITH &campo2. + tempo.&campo2.
	ENDIF
ENDFOR
FOR s = 1 TO ntotsal
	campo1 = [CS]+TRAN(s,"@L ##")
	campo2 = [VS]+TRAN(s,"@L ##")
	IF m.tipo=1
		REPLACE &campo1 WITH &campo1. + tempo.&campo1.
	ELSE
		REPLACE &campo2 WITH &campo2. + tempo.&campo2.
	ENDIF
ENDFOR
REPLACE totval WITH totval + tempo.totval
REPLACE totcan WITH totcan + tempo.totcan
REPLACE cncsmo WITH cncsmo + tempo.cncsmo
REPLACE vccsmo WITH vccsmo + tempo.vccsmo
IF m.tipo=1
	REPLACE ct01 WITH ct01 + tempo.ct01
	REPLACE cr02 WITH cr02 + tempo.cr02
ELSE
	REPLACE vr02 WITH vr02 + tempo.vr02
	REPLACE vt01 WITH vt01 + tempo.vt01
ENDIF
REPLACE stkini WITH stkini + tempo.stkini
REPLACE valini WITH valini + tempo.valini
RELEASE i,s
RETURN
********************
PROCEDURE rdimension
********************
PRIVATE i,s,t
SELE tempo2
SEEK [TOT]
ntotdel=0
FOR i = 1 TO ntoting
	DO CASE
	CASE m.tipo = 1
		lscmp  = [CI]
	CASE m.tipo = 2
		lscmp  = [VI]
	ENDCASE
	lscmp = lscmp + TRANS(i,'@L ##')
	IF &lscmp.=0
		aingres(i,4)=[*]
		ntotdel = ntotdel + 1
	ENDIF
ENDFOR
*nTotIng = nTotIng - nTotDel
*DIMENSION aIngres(nTotIng,4)
*
ntotdel=0
FOR s = 1 TO ntotsal
	DO CASE
	CASE m.tipo = 1
		lscmp  = [CS]
	CASE m.tipo = 2
		lscmp  = [VS]
	ENDCASE
	lscmp = lscmp + TRANS(s,'@L ##')
	IF &lscmp.=0
		asalida(s,4)=[*]
	ENDIF
ENDFOR
*nTotSal = nTotSal - nTotDel
*DIMENSION aSalida(nTotSal,4)
*
RETURN
****************
FUNCTION f_posic
****************
PARAMETER m.motivo
PRIVATE K
m.posicion = 0
DO CASE
CASE m.motivo = [S]
	FOR K = 1 TO ntotsal
		IF asalida(K,1)=m.motivo
			m.posicion = K
		ENDIF
	ENDFOR
CASE m.motivo = [I]
	FOR K = 1 TO ntoting
		IF aingres(K,1)=m.motivo
			m.posicion = K
		ENDIF
	ENDFOR
CASE INLIST(m.motivo ,[T],[R])
	FOR K = 1 TO ntottrf
		IF atransf(K,1)=m.motivo
			m.posicion = K
		ENDIF
	ENDFOR
ENDCASE
RETURN m.posicion
*******************
PROCEDURE genarcctb
*******************
IF m.contable = 2
	RETURN
ENDIF
SELE rctb
SEEK m.codmat+smovi
IF !FOUND()
	APPEND BLANK
	REPLACE codmat WITH m.codmat
	REPLACE codmov WITH smovi
	REPLACE fchdoc WITH gdfecha
ENDIF
REPLACE IMPORT WITH IMPORT + dtra.impnac
REPLACE impusa WITH impusa + dtra.impusa
IF m.consumo
	SEEK m.codmat+XsCodMod
	IF !FOUND()
		APPEND BLANK
		REPLACE codmat WITH m.codmat
		REPLACE codmov WITH XsCodMod
		REPLACE fchdoc WITH gdfecha
	ENDIF
	IF dtra.tipmov=[I]
		REPLACE IMPORT WITH IMPORT - dtra.impnac
		REPLACE impusa WITH impusa - dtra.impusa
	ELSE
		REPLACE IMPORT WITH IMPORT + dtra.impnac
		REPLACE impusa WITH impusa + dtra.impusa
	ENDIF
ENDIF
RETURN
******************
PROCEDURE imprimir
******************
SELECT temporal
GO TOP
if eof()
	*do f1MSGERR with [No existen registros a listar]
	gsmsgerr="No existen registros a listar"
	=MESSAGEBOX("ERROR : "+gsmsgerr,48)
	*close data
	return
endif
*  Impresi¢n ---------------------------------------------------------------------------
tit_sder = "Fecha : "+DTOC(gdfecha)
DO f0print
IF LASTKEY()= k_esc
	svenact = WOUTPUT()
	IF !EMPTY(svenact)
		RELEASE WINDOW (svenact)
	ENDIF
	*CLOSE DATA	
	RETURN	
ENDIF
iniimp   = _prn4    && 15   cpi
largo    = 66
ancho    = 255
tit_sizq = gsnomcia
tit_iizq = gsnomsub
tit_ider = ''
IF m.general
	titulo   = "MOVIMIENTO DE ALMACEN GENERAL"
ELSE
	titulo   = "MOVIMIENTO DE ALMACEN "+TRIM(gsnomsub)
ENDIF
subtitulo= ""
IF m.tipo=2
	IF ncodmon = 2
		subtitulo= "VALOR EN DOLARES AMERICANOS"
	ELSE
		subtitulo= "VALOR EN NUEVOS SOLES"
	ENDIF
ENDIF
en1    = []
en2    = []
en3    = []
en4    = []
en5    = []
IF ! TRIM(m.codmatd) == ""
	en3  = "Materiales del "+m.codmatd+" al "+m.codmath
ENDIF
IF dfchdoch<>dfchdocd
	en4  = "Periodo del "+DTOC(dfchdocd)+" al "+DTOC(dfchdoch)
ELSE
	en4  = "Del :"+DTOC(dfchdocd)
ENDIF
DO genencab
en6='********** ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******'
en7='  SALDO                                                                                                                                                                                                       '
en8='  INICIAL     1        2      3       4      5        6       7      8       9       10        11     12      13      14     15       16      17     18       19     20  '
en9='********** ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******* ******'
    *9999999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999 9999999
**                                                                                                       100                                                                                                 200                                               250  
**  *0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123546789-123456789-123456789-123456789-123456789-123456789-123456789-12345
*              1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8          9        0         1         2         3         4         5   
*
en5=lsencab1
en6=lsencab2
en7=lsencab3
en8=lsencab4
en9=lsencab5
ancho  = LEN(lsencab1)
*
linfin = largo - 8
cancelar  = .F.
SELECT temporal
GO TOP
regini = RECNO()
SET DEVICE TO PRINT
PRINTJOB
esp = 08
sfmt = [9999999]
sfmti= [999999999]
sfmtj= [99999999]
npos = 0
GO regini
DO WHILE !EOF()
	tinici  = 0
	tsaldo  = 0
	fvalini = 0
	tvalini = 0
	STORE 0 TO fing,fsal,fving,fvsal
	STORE 0 TO ting,tsal,tving,tvsal
	numpag  = 0
	ndim    = ntoting+ntotsal+ntottrf
	DIMENSION x(ndim),y(ndim),z(ndim)
	DO WHILE codmat<=m.codmath AND !EOF() AND !cancelar
		IF PROW() > linfin .OR. numpag = 0
			DO resetpag
			numlin = PROW() +1
		ENDIF
		lscodfam = LEFT(codmat,gnlendiv)
		=SEEK(gsclfdiv+lscodfam,[DIVF])
		numlin = PROW() + 1
		
		@numlin , 02 SAY _prn6a+lscodfam +[ ]+LEFT(divf.desfam,20)+_prn6b
		SCAN WHILE LEFT(codmat,gnlendiv) = lscodfam AND !cancelar
			numlin = PROW() + 1
			IF PROW() > linfin .OR. numpag = 0
				DO resetpag
				numlin = PROW() +1
			ENDIF
			=SEEK(codmat,[CATG])
			LfValIni = IIF(m.tipo=1,stkini,valini)
			LsCadena = codmat+[ ]+LEFT(catg.desmat,35)+[ ]+catg.undstk+[ ]
			LsCadena = LsCadena + TRAN(LfValIni,sFmti)			
			@ numlin ,00 SAY LsCadena
			numlin = PROW() + 1
			IF PROW() > linfin .OR. numpag = 0
				DO resetpag
				numlin = PROW() +1
			ENDIF
***			@ numlin ,00 SAY IIF(m.tipo=1,stkini,valini) PICT sfmti
			** Ingresos
			nposing = 0
			FOR K=1 TO ntoting
				IF aingres(K,4)#[*]
					nposing = nposing + 1
					DO CASE
					CASE m.tipo = 1
						lscmp  = [CI]
					CASE m.tipo = 2
						lscmp  = [VI]
					ENDCASE
					lscmp = lscmp + TRANS(K,'@L ##')
					@ numlin , npos + (nposing-1)*esp SAY &lscmp. PICT sfmt
					valor = &lscmp.
				ENDIF
			ENDFOR
			** Transferencias
			npos1 = npos + nposing*esp
			FOR K=1 TO ntottrf
				DO CASE
				CASE m.tipo = 1
					IF K = 1
						lscmp  = [CT]
					ELSE
						lscmp  = [CR]
					ENDIF
				CASE m.tipo = 2
					IF K = 1
						lscmp  = [VT]
					ELSE
						lscmp  = [VR]
					ENDIF
				ENDCASE
				IF INLIST(lscmp,[VT],[CT])
					lscmp = lscmp + [01]
				ELSE
					lscmp = lscmp + [02]
				ENDIF
				@ numlin , npos1 + (K-1)*esp SAY &lscmp. PICT sfmt
				valor = &lscmp.
			ENDFOR
			** Salidas
			npos2 = npos1 + esp*ntottrf
			npossal = 0
			FOR K=1 TO ntotsal
				IF asalida(K,4)#[*]
					npossal = npossal + 1
					DO CASE
					CASE m.tipo = 1
						lscmp  = [CS]
					CASE m.tipo = 2
						lscmp  = [VS]
					ENDCASE
					lscmp = lscmp + TRANS(K,'@L ##')					
					@ numlin , npos2 + (npossal-1)*esp SAY &lscmp. PICT sfmt
					valor = &lscmp.
				ENDIF
			ENDFOR
			npos3 = npos2 + esp*npossal
			** Consumos **
			IF m.tipo = 1
				@ numlin,npos3 SAY cncsmo PICT sfmtj
			ELSE
				@ numlin,npos3 SAY vccsmo PICT sfmtj
			ENDIF
			**
			npos4 = npos3 + (LEN(sfmtj)+1)*1
			** Total Fila **
			IF m.tipo = 1
				@ numlin,npos4 SAY totcan PICT sfmti
			ELSE
				@ numlin,npos4 SAY totval PICT sfmti
			ENDIF
			**
		ENDSCAN
		numlin = PROW() + 1
		IF PROW() > linfin .OR. numpag = 0
			DO resetpag
			numlin = PROW() +1
		ENDIF
		DO totalfam		
		*IF INKEY() = k_esc
		*	cancelar = .T.
		*	EXIT
		*ENDIF
		IF PROW() > linfin .OR. numpag = 0			
			DO resetpag
			numlin = PROW() +1
		ENDIF
	ENDDO
ENDDO
DO totalgen
EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO f0prfin
*CLOSE DATA
ven_actual = WOUTPUT()
IF !EMPTY(ven_actual)
	DEACTIVATE WINDOW (ven_actual)
	RELEASE WINDOW (ven_actual)
ENDIF
RETURN
******************
PROCEDURE totalgen
******************
SELE tempo2
SEEK [TOT]
IF FOUND()
	DO resetpag
	numlin = PROW() + 1
	** @ NumLin ,02 SAY [T O T A L   G E N E R A L]
	** @ numlin ,00 SAY REPLI("=",LEN(sfmti))
	** Ingresos
	nposing = 0	
	FOR K=1 TO ntoting
		IF aingres(K,4)#[*]
			nposing = nposing + 1
			@ numlin , npos + (nposing-1)*esp SAY REPLI("=",esp-1)
		ENDIF
	ENDFOR
	** Transferencias
	npos1 = npos + nposing*esp
	FOR K=1 TO ntottrf
		@ numlin , npos1 + (K-1)*esp SAY REPLI("=",esp-1)
	ENDFOR
	** Salidas
	npos2 = npos1 + esp*ntottrf
	npossal = 0
	FOR K=1 TO ntotsal
		IF asalida(K,4)#[*]
			npossal = npossal + 1
			@ numlin , npos2 + (npossal-1)*esp SAY REPLI("=",esp-1)
		ENDIF
	ENDFOR
	npos3 = npos2 + esp*npossal
	** Consumos **
	IF m.tipo = 1
		@ numlin,npos3 SAY REPLI("=",LEN(sfmtj))
	ELSE
		@ numlin,npos3 SAY REPLI("=",LEN(sfmtj))
	ENDIF
	**
	npos4 = npos3 + (LEN(sfmtj)+1)*1
	** Total Fila **
	IF m.tipo = 1
		@ numlin,npos4 SAY REPLI("=",LEN(sfmti))
	ELSE
		@ numlin,npos4 SAY REPLI("=",LEN(sfmti))
	ENDIF
	**
	DO resetpag
	numlin = PROW() + 1
    if DTOS(dFchDocD)=[19971201] .AND. DTOS(dFchDocH)=[19971231];    
       .and. m.general .and. TRIM(m.CodMatd)=[430] .and. EMPTY(m.codMatH)
       LfVariac= 0
    else
       LfVariac= 0
	endif
	LsCadena = IIF(m.tipo=1,[S.I:],[V.I:])
	LsCadena = LsCadena+[ ]+TRAN(IIF(m.tipo=1,stkini,valini+LfVariac),sFmti)
	@ numlin ,00 SAY LsCadena PICT sfmti
	**
	DO resetpag
	numlin = PROW() + 1
	** Ingresos
	nposing = 0
	FOR K=1 TO ntoting
		IF aingres(K,4)#[*]
			nposing = nposing + 1
			DO CASE
			CASE m.tipo = 1
				lscmp  = [CI]
			CASE m.tipo = 2
				lscmp  = [VI]
			ENDCASE
			lscmp = lscmp + TRANS(K,'@L ##')
			@ numlin , npos + (nposing-1)*esp SAY &lscmp. PICT sfmt
			valor = &lscmp.
		ENDIF
	ENDFOR
	** Transferencias
	npos1 = npos + nposing*esp
	FOR K=1 TO ntottrf
		DO CASE
		CASE m.tipo = 1
			IF K = 1
				lscmp  = [CT]
			ELSE
				lscmp  = [CR]
			ENDIF
		CASE m.tipo = 2
			IF K = 1
				lscmp  = [VT]
			ELSE
				lscmp  = [VR]
			ENDIF
		ENDCASE

		IF INLIST(lscmp,[VT],[CT])
			lscmp = lscmp + [01]
		ELSE
			lscmp = lscmp + [02]
		ENDIF
		@ numlin , npos1 + (K-1)*esp SAY &lscmp. PICT sfmt
		valor = &lscmp.
	ENDFOR
	** Salidas
	npos2 = npos1 + esp*ntottrf
	npossal = 0
	FOR K=1 TO ntotsal
		IF asalida(K,4)#[*]
			npossal = npossal + 1
			DO CASE
			CASE m.tipo = 1
				lscmp  = [CS]
			CASE m.tipo = 2
				lscmp  = [VS]
			ENDCASE
			lscmp = lscmp + TRANS(K,'@L ##')
			@ numlin , npos2 + (npossal-1)*esp SAY &lscmp. PICT sfmt
			valor = &lscmp.
		ENDIF
	ENDFOR
	npos3 = npos2 + esp*npossal
	** Consumos **
	IF m.tipo = 1
		@ numlin,npos3 SAY cncsmo PICT sfmtj
	ELSE
		@ numlin,npos3 SAY vccsmo PICT sfmtj
	ENDIF
	**
	npos4 = npos3 + (LEN(sfmtj)+1)*1
	** Total Fila **
	IF m.tipo = 1
		@ numlin,npos4 SAY totcan PICT sfmti
	ELSE
	    if ((DTOS(dFchDocD)=[19971101] AND DTOS(dFchDocH)=[19971130]) or ;
	       (DTOS(dFchDocD)=[19971201] AND DTOS(dFchDocH)=[19971231]) ) ;
	       and m.general and TRIM(m.CodMatd)=[430] and EMPTY(m.codMatH)
	       LfVariac= 0
	    else
	       LfVariac= 0
		endif
		@ numlin,npos4 SAY totval+LfVariac  PICT sfmti
		
	ENDIF
	**
ENDIF
SELE temporal
RETURN
******************
PROCEDURE totalfam
******************
SELE tempo2
SEEK [FAM]+lscodfam
IF FOUND()
	DO resetpag
	numlin = PROW() + 1
	**@NumLin , 02 SAY _Prn6a+[TOTAL ]+LEFT(DIVF.DesFam,20)+_Prn6b
	**@ numlin ,00 SAY REPLI("=",LEN(sfmti))
	** Ingresos
	nposing = 0
	FOR K=1 TO ntoting
		IF aingres(K,4)#[*]
			nposing = nposing + 1
			@ numlin , npos + (nposing-1)*esp SAY REPLI("=",esp-1)
		ENDIF
	ENDFOR
	** Transferencias
	npos1 = npos + nposing*esp
	FOR K=1 TO ntottrf
		@ numlin , npos1 + (K-1)*esp SAY REPLI("=",esp-1)
	ENDFOR
	** Salidas
	npos2 = npos1 + esp*ntottrf
	npossal = 0
	FOR K=1 TO ntotsal
		IF asalida(K,4)#[*]
			npossal = npossal + 1
			@ numlin , npos2 + (npossal-1)*esp SAY REPLI("=",esp-1)
		ENDIF
	ENDFOR
	npos3 = npos2 + esp*npossal
	** Consumos **
	IF m.tipo = 1
		@ numlin,npos3 SAY REPLI("=",LEN(sfmtj))
	ELSE
		@ numlin,npos3 SAY REPLI("=",LEN(sfmtj))
	ENDIF
	**
	npos4 = npos3 + (LEN(sfmtj)+1)*1
	** Total Fila **
	IF m.tipo = 1
		@ numlin,npos4 SAY REPLI("=",LEN(sfmti))
	ELSE
		@ numlin,npos4 SAY REPLI("=",LEN(sfmti))
	ENDIF
	**
	DO resetpag
	numlin = PROW() + 1
    if DTOS(dFchDocD)=[19971201] .AND. DTOS(dFchDocH)=[19971231] .and. m.general .and. inlist(LsCodFam,[53140],[53115])
       IF LsCodFam = [53140]
	       LfVariac= 0
       else
	       LfVariac= 0
       endif
    else
       LfVariac= 0
	endif
	*
	LsCadena = IIF(m.tipo=1,[S.I:],[V.I:])
	LsCadena = LsCadena+[ ]+TRAN(IIF(m.tipo=1,stkini,valini+LfVariac),sFmti)
	@ numlin ,00 SAY LsCadena
	DO resetpag
	numlin = PROW() + 1
	**@ numlin ,00 SAY IIF(m.tipo=1,stkini,valini+LfVariac) PICT sfmti
	** Ingresos
	nposing = 0
	FOR K=1 TO ntoting
		IF aingres(K,4)#[*]
			nposing = nposing + 1
			DO CASE
			CASE m.tipo = 1
				lscmp  = [CI]
			CASE m.tipo = 2
				lscmp  = [VI]
			ENDCASE
			lscmp = lscmp + TRANS(K,'@L ##')
			@ numlin , npos + (nposing-1)*esp SAY &lscmp. PICT sfmt
			valor = &lscmp.
		ENDIF
	ENDFOR
	** Transferencias
	npos1 = npos + nposing*esp
	FOR K=1 TO ntottrf
		DO CASE
		CASE m.tipo = 1
			IF K = 1
				lscmp  = [CT]
			ELSE
				lscmp  = [CR]
			ENDIF
		CASE m.tipo = 2
			IF K = 1
				lscmp  = [VT]
			ELSE
				lscmp  = [VR]
			ENDIF
		ENDCASE

		IF INLIST(lscmp,[VT],[CT])
			lscmp = lscmp + [01]
		ELSE
			lscmp = lscmp + [02]
		ENDIF
		@ numlin , npos1 + (K-1)*esp SAY &lscmp. PICT sfmt
		valor = &lscmp.
	ENDFOR
	** Salidas
	npos2 = npos1 + esp*ntottrf
	npossal = 0
	FOR K=1 TO ntotsal
		IF asalida(K,4)#[*]
			npossal = npossal + 1
			DO CASE
			CASE m.tipo = 1
				lscmp  = [CS]
			CASE m.tipo = 2
				lscmp  = [VS]
			ENDCASE
			lscmp = lscmp + TRANS(K,'@L ##')
			@ numlin , npos2 + (npossal-1)*esp SAY &lscmp. PICT sfmt
			valor = &lscmp.
		ENDIF
	ENDFOR
	npos3 = npos2 + esp*npossal
	** Consumos **
	IF m.tipo = 1
		@ numlin,npos3 SAY cncsmo PICT sfmtj
	ELSE
		@ numlin,npos3 SAY vccsmo PICT sfmtj
	ENDIF
	**
	npos4 = npos3 + (LEN(sfmtj)+1)*1
	** Total Fila **
	IF m.tipo = 1
		@ numlin,npos4 SAY totcan PICT sfmti
	ELSE
	    if ((DTOS(dFchDocD)=[19971101] AND DTOS(dFchDocH)=[19971130]) or ;
	       (DTOS(dFchDocD)=[19971201] AND DTOS(dFchDocH)=[19971231]) ) ;
	       and m.general and inlist(LsCodFam,[53140],[53115])
	       IF LsCodFam = [53140]
		       LfVariac= 0
	       else
		       LfVariac= 0
	       endif
	    else
	       LfVariac= 0
		endif
		@ numlin,npos4 SAY totval+ LfVariac PICT sfmti
		
	ENDIF
	**
ENDIF
SELE temporal
RETURN
******************
PROCEDURE genencab
******************
**lsencab1 =    [**********]
**IF m.tipo=1
**	lsencab2 =[ STOCK    ]
**ELSE
**	lsencab2 =[ VALOR    ]
**ENDIF
**lsencab3 =    [          ]
**lsencab4 =    [INICIAL   ]
**lsencab5 =    [**********]
*** Cambio en el encabezado ***
*
lsencab1 =[]
lsencab2 =[]
lsencab3 =[]
lsencab4 =[]
lsencab5 =[]
*
FOR kk = 1 TO ntoting
	IF aingres(kk,4)=[*]
	ELSE
		=SEEK(aingres(kk,1),[CFTR])
		DIMENSION xxdesmov(3)
		STORE [] TO xxdesmov
		lsxxdesmov = aingres(kk,2)
		numdes = 0
		DO WHILE .T.
			IF EMPTY(lsxxdesmov)
				EXIT
			ENDIF
			numdes = numdes + 1
			IF numdes > ALEN(xxdesmov)
				DIMENSION xxdesmov(numdes+1)
			ENDIF
			z = AT(" ",lsxxdesmov)
			IF z = 0
				z = LEN(lsxxdesmov) + 1
			ENDIF
			xxdesmov(numdes) = PADC(LEFT(lsxxdesmov,z-1),07)
			IF z > LEN(lsxxdesmov)
				EXIT
			ENDIF
			lsxxdesmov = SUBSTR(lsxxdesmov,z+1)
		ENDDO
		lsencab1=lsencab1 + [ *******]
		lsencab2=lsencab2 + [ ]+PADL(TRIM(xxdesmov(1)),07)
		lsencab3=lsencab3 + [ ]+PADL(TRIM(xxdesmov(2)),07)
		lsencab4=lsencab4 + [ ]+PADL(TRIM(xxdesmov(3)),07)
		lsencab5=lsencab5 + [ *******]
	ENDIF
ENDFOR
IF haytransfer
	lsencab1=lsencab1 + [ ***************]
	lsencab2=lsencab2 + [ ]+PADC('TRANSFERENCIAS',15)
	lsencab3=lsencab3 + [ ]+PADC('ENTRE ALMACENES',15)
	lsencab4=lsencab4 + [ ]+PADC('Sal.     Ingr.',15)
	lsencab5=lsencab5 + [ ***************]
ENDIF

FOR kk = 1 TO ntotsal
	IF asalida(kk,4)=[*]
	ELSE
		=SEEK(asalida(kk,1),[CFTR])
		DIMENSION xxdesmov(3)
		STORE [] TO xxdesmov
		lsxxdesmov = asalida(kk,2)
		numdes = 0
		DO WHILE .T.
			IF EMPTY(lsxxdesmov)
				EXIT
			ENDIF
			numdes = numdes + 1
			IF numdes > ALEN(xxdesmov)
				DIMENSION xxdesmov(numdes+1)
			ENDIF
			z = AT(" ",lsxxdesmov)
			IF z = 0
				z = LEN(lsxxdesmov) + 1
			ENDIF
			xxdesmov(numdes) = PADC(LEFT(lsxxdesmov,z-1),07)
			IF z > LEN(lsxxdesmov)
				EXIT
			ENDIF
			lsxxdesmov = SUBSTR(lsxxdesmov,z+1)
		ENDDO
		lsencab1=lsencab1 + [ *******]
		lsencab2=lsencab2 + [ ]+PADL(TRIM(xxdesmov(1)),07)
		lsencab3=lsencab3 + [ ]+PADL(TRIM(xxdesmov(2)),07)
		lsencab4=lsencab4 + [ ]+PADL(TRIM(xxdesmov(3)),07)
		lsencab5=lsencab5 + [ *******]
	ENDIF
ENDFOR

lsencab1=lsencab1 + [ *********]
lsencab2=lsencab2 + [ ]+PADL([],08)
lsencab3=lsencab3 + [ ]+PADL([TOTAL ],08)
lsencab4=lsencab4 + [ ]+PADL([CONSUMO],08)
lsencab5=lsencab5 + [ *********]

lsencab1=lsencab1 + [ *********]
lsencab2=lsencab2 + [ ]+PADL([],08)
lsencab3=lsencab3 + [ ]+PADL([TOTAL ],08)
lsencab4=lsencab4 + [ ]+PADL([FINAL ],08)
lsencab5=lsencab5 + [ *********]
RETURN
*********************************