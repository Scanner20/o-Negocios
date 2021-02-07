IF _ano=2010 AND UPPER(Goentorno.User.Groupname)<>'MASTER'
	MESSAGEBOX('Este proceso solo debe ejecutarse en periodos anteriores al 2010',64,'AVISO IMPORTANTE')
	RETURN
ENDIF
IF UPPER(GsSigCia)='AROMAS' AND UPPER(Goentorno.User.Groupname)<>'MASTER' AND _ANO=2011
	=MESSAGEBOX('Los saldos para el año 2012 deberan cargarse manualmente. Consultar con area de sistemas.' ,48,'ATENCION / WARNING')
	RETURN
ENDIF
SET DISPLAY TO vga25
SYS(2700,0)           
=F1_BASE(GsNomCia,GsNomSub,"USUARIO:"+GsUsuario,"FECHA:"+GsFecha)
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

*if _ano = 1998 AND GsCodCia=[001]     && Solo Cia. Insumos 06/07/99 12:38p.m.
*	do f1MsgErr with [Imposible Actualizar Saldos al Pr¢ximo A¤o -> 1999]
*	return
*endif

IF F1_ALERT([Este proceso calcula los stocks y valores de todos los   ;]+;
            [almacenes el que nos encontramos hasta la fecha indicada.;]+;
            [Luego traslada los saldos obtenidos al proximo a¤o como  ;]+;
            [valores iniciales.                                       ;]+;
            [Antes de ejecutar este proceso se recomiendo haber reali-;]+;
            [zado el Recalculo de Stock y Valor.                      ;]+;
            [                                                         ;]+;
            [SE RECOMIENDA TENER BACKUP DE LA INFORMACION A PROCESAR. ;],2)#1
		DO Cerrar_Proc		
		RETURN
ENDIF

HayTransfer = .F.
MovTra   = []
m.Tipo   = 1   && 1 Stock y Valor, 2 Cantidad , 3 Valor
m.TipMat = 1
m.General = .F.
XfTpoCmb  = 0
UltTecla  = 0
m.Control = 1
Cancelar  = .F.
*** Variables necesarias ***
m.CodMatD = []
m.CodMatH = []
m.DesmatD = []
m.DesmatH = []
nCodMon   = 1
m.Cuales  = 2     && 1 Solo Materiales con Stock , 2 Todos los materiales seleccionados
dFchDocD  = iif(VARTYPE(GdFecha)='T',TTOD(GdFecha),GdFecha)
dFchDocH  = iif(VARTYPE(GdFecha)='T',TTOD(GdFecha),GdFecha)
m.estado  = 1
m.borratodo=1
m.SoloConSaldos = .F.
m.Tipo		= 1

*** Variables de control
sAyuda_O1 = [Presione F8 para consultar]
m.Control = 1
UltTecla  = 0
*** Variables que controlan los directorios a manipular
DirNew = []
DirAct = []
LcSlash = [\]
DO CASE
	CASE _UNIX
		LcSlash = [/]
	CASE _DOS
		LcSlash = [\]
ENDCASE
IF !LoDatAdm.AbrirTabla('ABRIR','admmtcmb','TCMB','TCMB01','')
	=MESSAGEBOX('No hay acceso a tabla de tipo de cambio',16,'¡¡¡ ATENCION !!!')
	DO Cerrar_Proc		
	RETURN 
ENDIF
DO FORM alm_almptsal
Ven_Actual = woutput()
IF !EMPTY(Ven_Actual)
    DEACTIVATE WINDOW (Ven_Actual)
    RELEASE WINDOW (Ven_actual)
ENDIF

DO Cerrar_Proc	       
DELE FILE &Arch..DBF
DELE FILE &Arch..CDX
=F1_ALERT([Una vez que se ha ejecutado este proceso sin tener   ;]+;
          [ningun problema en el sistema, ingresar al nuevo a¤o ;]+;
          [y ejecutar la opci¢n de recalculo de stock y valor   ;]+;
          [para situar los saldos iniciales.                    :],3)
          

RETURN
******************
FUNCTION AbrirDbfs
******************
=F1QEH("ABRE_DBF")
LoDatAdm.AbrirTabla('ABRIR','admmtcmb','TCMB','TCMB01','')
LoDatAdm.AbrirTabla('ABRIR','almcftra','CFTR','CFTR01','')
LoDatAdm.AbrirTabla('ABRIR','almdtran','DTRA','DTRA03','')
LoDatAdm.AbrirTabla('ABRIR','almctran','CTRA','CTRA01','')
LoDatAdm.AbrirTabla('ABRIR','almtdivf','DIVF','DIVF01','')
LoDatAdm.AbrirTabla('ABRIR','almcatal','CALM','CATA02','')
LoDatAdm.AbrirTabla('ABRIR','almcatge','CATG','CATG01','')
LoDatAdm.AbrirTabla('ABRIR','cbdtanos','','','')
LoDatAdm.AbrirTabla('ABRIR','ALMTALMA','ALMA','ALMA01','')
*
* SOLO PARA EL A¥O 1998 POR LA RECLASIFICACION DE CODIGOS
*
*!*	if _ano = 1998 AND GsCodCia=[001]  && 06/07/99 12:38p.m.
*!*	   sele 0 
*!*	   use catgenew order catg01 alias new
*!*	   if !used()
*!*			return .f.
*!*		endif
*!*	endif
*
** Preparamos archivo temporal **
SELE 0
Arch = PAthUser+SYS(3)
CREATE TABLE &Arch. FREE (SubAlm C(LEN(CALM.SubAlm)),;
                     CodMat C(LEN(CATG.Codmat)), StkIni N(14,3), ;
                     VIniMn N(14,3),Activo L(1),;
                     codnew c(len(catg.codnew)))

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
	GsMsgErr = [No se pudo generar temporal.]
	DO F1MsgErr WITH GsMsgErr
	RETURN .F.
ENDIF
INDEX ON SubAlm+CodMat TAG TMP01
INDEX ON CODMAT+SUBALM TAG TMP02
index on codnew+subalm tag TMP03
SET ORDER TO TMP01
=F1QEH("OK")
RETURN .T.

*******************
PROCEDURE TransArch
*******************
IF !F1_Apert('ALMACEN',5,2,7,2)
	=F1_alert([Error en transferencia de archivo al nuevo a¤o;]+;
             [Verificar atributos de lectura y escritura.],3)
	RETURN
ENDIF
IF !ABRIRDBFS()
	DO F1MSGERR WITH [Error en apertura de archivos]
*!*		CLOSE DATA
	RETURN
ENDIF
DO ABRENEWANO
m.CodMatD = SPACE(LEN(CATG.CodMat))
m.CodMatH = SPACE(LEN(CATG.CodMat))
m.DesmatD = SPACE(LEN(CATG.DesMat))
m.DesmatH = SPACE(LEN(CATG.DesMat))
DO TRFSaldos
RETURN

********************
PROCEDURE ABRENEWANO
********************
SELE 0
USE &DirNew.ALMCATAL ORDER CATA01 ALIAS CALMX
IF !USED()
	RETURN .f.
ENDIF
SET DELETED off
SET FILTER TO EMPTY(CodMat) OR EMPTY(SUBALM)

DIMENSION vDeletes(10)
STORE 0 TO vdeletes,n
LOCATE

SCAN 
	n = n + 1
	IF ALEN(vDeletes)<n
		DIMENSION vDeletes(n+10)
		FOR k= n +1 TO n+10
			STORE 0 TO vdeletes(k)
		ENDFOR
	ENDIF
	vDeletes(n)	= RECNO()
ENDSCAN
RELEASE n,k
SET FILTER TO 
LOCATE

*** Borramos registros fantasmas ***
FOR K = 1 TO ALEN(vDeletes)	
	IF vDeletes(k)>0
		GO vDeletes(k)
		=RLOCK()
		replace CodMat WITH SYS(2015)
		replace CodSed WITH SYS(3)
		replace SubAlm WITH SYS(3)
		replace fchhora WITH DATETIME()
		replace coduser WITH GsUsuario 
		IF !DELETED()
			DELETE 
		ENDIF
	ENDIF
ENDFOR
SET DELETED ON
LOCATE

***
SELE 0
USE &DirNew.ALMCATGE ORDER CATG01 ALIAS CATGX
IF !USED()
	RETURN .f.
ENDIF
=F1QEH("OK")
RETURN .T.

*******************
PROCEDURE TrfSalDos
*******************
LsMsg=[CALCULANDO SALDOS DE STOCK Y VALOR AL ]+DTOC(dFchDocH)
LnCol=WCOL()-LEN(LsMsg)
@ 5,2 SAY PADR(LsMsg,WCOL()-2)
** ARMAR LOS TEST DE IMPRESION **
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.CodMatH)+CHR(255)
m.Cuales  = 2   && 1 Solo Materiales con Stock , 2 Todos los materiales seleccionados
Cancelar = .f.
LlSinMov = .F.
SET STEP ON 
SELECT CATG
SEEK TRIM(m.CodMatD)
IF ! FOUND() .AND. RECNO(0)>0
	GOTO RECNO(0)
	IF DELETED()
		SKIP
	ENDIF
ENDIF
DO WHILE CATG->CodMat <= m.CodMatH .AND. ! EOF() .AND. ! Cancelar
	@ 7,2 say [PROCESANDO CODIGO:]+CATG->CodMat+"  "+CATG->DesMat SIZE 1,68
	IF codmat='999006-AGGG2 15'
*!*			SET STEP ON 
	ENDIF
	LlPaso=.f.
	LsCodMat = CodMat
	LlSinMov = .F.
	SELE CALM
	SEEK LsCodMat
	SCAN WHILE  CodMat=LsCodMat
		LsSubAlm = CALM.Subalm
		sCodMat  = CALM.CodMat
		fStkSub  = CALM->StkIni
		fStkAct  = CALM->StkIni
		fValAct  = IIF(nCodMon = 1, CALM->VIniMn, CALM->VIniUs)
		*** HALLAR EL STOCK DEL ALMACEN ***
		@ 7,2 say [PROCESANDO CODIGO:]+CATG->CodMat+"  "+CATG->DesMat+ ' ALMACEN:'+CALM.SubALm SIZE 1,68
		SELE DTRA
		GO TOP
		IF EOF()
			SELE CALM
			** VETT  31/03/2018 08:59 AM : Si no hay movimientos solo traslada el catalogo general y catalogo x almacen
			*!*				LOOP
			LlSinMov = .T.
		ENDIF
		IF !LlSinMov
			SET ORDER TO DTRA02
			SEEK LsSubAlm+sCodMat+DTOS(dFchDocH+1)
			IF !FOUND()
				IF RECNO(0)>0
					GO RECNO(0)
					IF DELETED()
						SKIP
					ENDIF
				ENDIF
			ENDIF
			SKIP -1
			IF SubAlm+CodMat = LsSubAlm+sCodMat AND FchDoc<=dFchDocH
				fStkSub = DTRA->StkSub
			ENDIF
			*** HALLAR EL VALOR GENERAL ***
			SELE DTRA
			SET ORDER TO DTRA03
			SEEK sCodMat+DTOS(dFchDocH+1)
			IF !FOUND()
				IF RECNO(0)>0
					GO RECNO(0)
					IF DELETED()
						SKIP
					ENDIF
				ENDIF
			ENDIF
			SKIP -1
			IF CodMat = sCodMat AND FchDoc<=dFchDocH
				fStkAct = DTRA.StkAct
				fValAct = IIF(nCodMon = 1,VCTOMN,VCTOUS)
			ENDIF
		ELSE	
		ENDIF
		** VETT  31/03/2018 08:59 AM :  Si no hay movimientos solo traslada el catalogo general y catalogo x almacen
		
		*** HALLAR EL VALOR DEL ALMACEN ***
		fValSub = IIF(fStkAct>0,fValAct/fStkAct*fStkSub,0)
		IF !(m.Cuales = 1 .AND. fStkSub<=0)
			SELE TEMPO
			SEEK LsSubAlm+sCodMat
			IF !FOUND()
				APPEND BLANK
				REPLACE TEMPO.SubAlm WITH LsSubAlm
				REPLACE TEMPO.CodMat WITH sCodMat
			ENDIF
			REPLACE TEMPO.StkIni WITH IIF(fStkSub>=0,fStkSub,0)
			REPLACE TEMPO.VIniMn WITH IIF(fValSub>=0,fValSub,0)
			REPLACE TEMPO.Activo WITH !CATG.Inactivo
			llPaso = .T.
			*** Poner la rutina de calcular el stock final por lote
			*** Almdlote 
			
		ENDIF
		
		
		SELE CALM
	ENDSCAN
	IF !LlPaso
*!*			SET STEP ON 
	ENDIF
	SELE CATG
	SKIP
ENDDO

SELE TCMB
SEEK DTOS(dfchdoch)
IF !FOUND() AND RECNO(0)>0
	GO RECNO(0)
ENDIF
XfTpoCmb = TCMB.OfiVta
@5,2 SAY SPACE(50)
@5,2 SAY [TRANSFIRIENDO NUEVO SALDO AL ]+dtoc(dfchdoch+1)

** Grabamos en CATALOGO POR ALMACEN DEL NUEVO A¥O
SELE CALMX
GO TOP
SCAN
	DO WHILE !RLOCK()
	ENDDO
	IF INLIST(m.Tipo,1,2)
		REPLACE StkIni WITH 0
	ENDIF
	IF INLIST(m.Tipo,1,3)
		REPLACE ViniMn WITH 0
		REPLACE ViniUs WITH 0
	endif
	UNLOCK
ENDSCAN
*
*!*	if _ano = 1998 AND GsCodCia=[001]  &&& Reclasificacion de Codigos 06/07/99 12:40p.m.
*!*		sele tempo
*!*		set order to tmp02
*!*		go top
*!*		scan
*!*			xscodmat = tempo.codmat
*!*			xscodnew = iif(seek(xscodmat,[new]),new.codnew,[])
*!*			=f1_rlock(0)
*!*			if left(xscodmat,2)>=[42] and xscodmat<=[95010430]
*!*				repla tempo.codnew with xscodnew 
*!*			else
*!*				repla tempo.codnew with xscodmat
*!*			endif   
*!*			unlock 
*!*		endscan
*!*		sele tempo
*!*		set filter to !empty(codnew)
*!*	endif
IF m.SoloConSaldos 
	LsTstLin = "TEMPO.StkIni<>0"
ELSE
	LsTstLin = ".T."
ENDIF

if _ano = 1998 AND GsCodCia=[001]   &&& Reclasificaci¢n de C¢digos 06/07/99 12:40p.m.
	SELE TEMPO
	SET ORDER TO TMP03
	GO TOP
	SCAN
		lfound=seek(tempo.codnew,[catgx])
		DO CASE
			CASE !lFound AND EVALUATE(LsTstLin)
				SELE CATG
				SEEK TEMPO.CodMat
				SCATTER MEMVAR
				SELE CATGX
				APPEN BLANK
				DO WHILE !RLOCK()
				ENDDO
				GATHER MEMVAR
				repla catgx.codmat with tempo.codnew
				UNLOCK
			CASE !lFOUND AND Tempo.StkIni=0 AND m.SoloConSaldos
		ENDCASE

		@7,2 SAY [PROCESANDO CODIGO :]+CODMAT+[ ]+catgX.dESMAT size 1 ,68
		SELE CALMX
		SEEK TEMPO.subalm+TEMPO.codnew
		DO CASE
			CASE !FOUND() AND EVALUATE(LsTstLin)
				APPEND BLANK
				DO WHILE !RLOCK()
				ENDDO
				REPLACE SUBALM WITH TEMPO.SUBALM
				REPLACE codmat WITH TEMPO.codnew
				REPLACE CALM->UndVta WITH CATG->UndStk
				REPLACE CALM->FacEqu WITH 1
			CASE !FOUND() AND Tempo.StkIni=0 AND m.SoloConSaldos
				SELE TEMPO
				LOOP
			CASE FOUND()
				DO WHILE !RLOCK()
				ENDDO
		ENDCASE

		REPLACE StkIni WITH TEMPO.StkIni
		REPLACE VIniMn WITH TEMPO.VIniMn
		IF XfTpoCmb >0
			REPLACE VIniUs WITH ROUND(VIniMn/XfTpoCmb,4)
		ELSE
			REPLACE VIniUs WITH 0
		ENDIF
		replace coduser WITH GsUsuario 
		replace fchhora WITH DATETIME()
		SELE TEMPO
	ENDSCAN
ELSE
	SET STEP ON 
	SELE TEMPO
	SET ORDER TO TMP02
	GO TOP
	SCAN
		LCodSed=SEEK(TEMPO.subalm,'ALMA')
		LFound=SEEK(CODMAT,[CATGX])
		DO CASE
			CASE !lFound AND EVALUATE(LsTstLin)
				SELE CATG
				SEEK TEMPO.CodMat
				SCATTER MEMVAR
				SELE CATGX
				APPEN BLANK
				GATHER MEMVAR
				replace coduser WITH GsUsuario 
				replace fchhora WITH DATETIME()
				UNLOCK
			CASE !lFOUND AND Tempo.StkIni=0 AND m.SoloConSaldos
		ENDCASE
		@7,2 SAY [PROCESANDO CODIGO :]+CODMAT+[ ]+catgX.dESMAT size 1 ,68
		SELE CALMX
		
*!*			IF SEEK(SPACE(21),'CALMX')
*!*				SET STEP ON 
*!*			ENDIF
*!*			IF EMPTY(tempo.subalm) OR EMPTY(Tempo.codmat)
*!*				SET STEP ON 
*!*			ENDIF
		IF Tempo.SubAlm+TEMPO.CodMat='003999006-AGG2 15'
*!*				SET STEP on
		ENDIF
		SET DELETED OFF
		IF SEEK(TEMPO.SubAlm+TEMPO.CodMAt,'CALMX') AND DELETED()
			=RLOCK()
			replace codnew WITH CodMat
			REPLACE CodMat WITH SYS(2015)
			replace coduser WITH GsUsuario 
			replace fchhora WITH DATETIME()

			UNLOCK
		ENDIF
		
		SET DELETED ON

		SEEK TEMPO.SubAlm+TEMPO.CodMAt
		DO CASE
			CASE !FOUND() AND EVALUATE(LsTstLin)

				APPEND BLANK
				=F1_rlock(0)
				REPLACE SUBALM WITH TEMPO.SUBALM
				REPLACE CODMAT WITH TEMPO.CODMAT
				REPLACE CALM->UndVta WITH CATG->UndStk
				REPLACE CALM->FacEqu WITH 1
			CASE !FOUND() AND Tempo.StkIni=0 AND m.SoloConSaldos
				SELE TEMPO
				LOOP
			CASE FOUND()
				=F1_rlock(0)
				
		ENDCASE
		replace codsed WITH IIF(LCodSed,alma.CodSed,'')
		IF INLIST(m.Tipo,1,2)
			REPLACE StkIni WITH TEMPO.StkIni 
		ENDIF
		IF INLIST(m.Tipo,1,3)
			REPLACE VIniMn WITH TEMPO.VIniMn
			IF XfTpoCmb >0
				REPLACE VIniUs WITH ROUND(VIniMn/XfTpoCmb,4)
			ELSE
				REPLACE VIniUs WITH 0
			ENDIF
		ENDIF
		replace coduser WITH GsUsuario 
		replace fchhora WITH DATETIME()
		SELE TEMPO
	ENDSCAN
endif
=F1QEH("Fin de procesamiento...")
SELE CATG
USE
SELE CALM
USE
SELE DTRA
USE
SELE CTRA
USE
SELE CFTR
USE
SELE DIVF
USE
SELE TCMB
USE
SELE CALMX
USE
SELE CATGX
USE
SELE TEMPO
USE
SELECT ALMA
USE
*** Registrando el nuevo a¤o ***
SELECT CBDTANOS
IF YEAR(DATE())<_Ano+1
	REPLACE ALL CIERRE WITH .T.
ENDIF
LOCATE FOR PERIODO = _ANO+1
IF ! FOUND()
	APPEND BLANK
	REPLACE PERIODO WITH _ANO+1
ENDIF
REPLACE CIERRE WITH .F.
use
RETURN
PROCEDURE Cerrar_Proc	
    RELEASE window __WFondo
    SYS(2700,1)           
	CLOSE TABLES ALL
	RELEASE LoDatAdm