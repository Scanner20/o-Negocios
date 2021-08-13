*******************************************************************************
*  Nombre        : CBD_DiarioGeneral.PRG    
*  Sistema       : Contabilidad
*  Proposito     : Ingresos al Diario General
*  Creacion		 : VETT Enero 1994
*  Actualizacion : VETT 11/06/1999
*  Actualizacion : VETT 11/09/2002  Migracion a Visual Foxpro 6 , 7 y 8
*****************************************************************************
* Flag
* A    Anulado
* R    Registrado en el sistema
* C    Documento Cerrado
* M    Asiento generado autom ticamente
* E    Estimado (no actualiza los acumulados contables)
***************************************************************************
IF !verifyvar('GsClfCt9','C','TABLA')
	RETURN
ENDIF
IF !verifyvar('GsClfCt6','C','TABLA')
	RETURN
ENDIF

PUSH KEY clear
#include const.h 	
STORE '' TO XsHola
GlInterface = .F.
GlModTpoCmb	= .F.
GlRegenerAuto	= .F.
** Variables de compatibilidad con librerias de versiones anterirores
GsSistema = [CONTAB]
GsBusca   = "CbdSelec"
GsProgram  = PROGRAM()
EXTERNAL ARRAY VecOpc
set century on
DIMENSION vCdMDos(1,1)
STORE [] TO vCdmDos
NroDec   = 4
Crear    = .T.
ScrMov   = ""
XsNroMes = TRANSF(_MES,"@L ##")
XsAno    = RIGHT(STR(_ANO,4),2)
TsCodDiv1=[01]    &&  Divisionaria por defecto
lTpoCorr = 1
Modificar = .T.
TnLenGlo  = 12
*
dimension vcodcta(10)
store 0 to numcta, numcta1
** Variables globales para todo el programa y formulario
***** Cabecera
STORE "" TO XsNroAst,XsNotAst,XsNroVou,XsCodDiv,XsCtaPre,XsAuxil
STORE 1  TO XiCodMon,XfTpoCmb
STORE {} TO XdFchAst
********* Detalle
**OJO* Estas variables son las que se definian en la rutina que llamaba a la libreria DBROWSE o F1Browse
**OJO* Las definimos aqui para poder reutilizar la mayoria del codigo de grabacion de el detalle e 
**OJO* integrarlo con el formulario
STORE '' TO NCLAVE,VCLAVE,REGVAL
STORE '' to XsCodCta,XsClfAux,XsCodAux,XsCodPrv,XsNomPrv,XsRefPrv,XsIniAux,XsCodRef ,xsglodoc,XsProyecto
STORE {} to XdFchVto,XdFchPed,XdFchDoc,XdFchDtr,XdFchRef
STORE '' to xsnivadi,XsCodDoc,XsNroDoc,XsTipRef,XsNroRef ,XSCODFIN,XcTpoMov
STORE 0  TO XiNroitm,xsimpnac1,xsimpnac2,XfImport,XfImpNac,XfImpUsa
STORE '' TO XcTipoC,XsNroRuc,XsTipDoc,xstipdoc1,xscodcta1,xsnroref1,xstipori,xsnumori,xsfecori,xsimpori
STORE '' to xsnumpol,XsNroDtr
STORE '' TO XsCodCco,XsAn1Cta,XsCC1Cta,XsAn2Cta,XsCC2Cta,XsChkCta,XsTipOri1,XsNumOri1
STORE SPACE(1) TO XcAfecto
*********
** VETT  08/05/2017 05:03 AM : Verificar si existe VTACONFG.MEM para cargar variables generales de ventas
IF !FILE(ADDBS(GoCfgVta.oentorno.tspathcia)+'vtaCONFG.MEM') AND FILE(ADDBS(goentorno.Tspathadm)+'VTACONFG.ME1')
	COPY FILE ADDBS(goentorno.Tspathadm)+'VTACONFG.ME1' TO ADDBS(GoCfgVta.oentorno.tspathcia)+'vtaCONFG.MEM'
ENDIF
** VETT  02/05/2017 09:32 AM : Retencion RH - Renta 4ta. CAT 
IF FILE(ADDBS(GoCfgVta.oentorno.tspathcia)+'vtaCONFG.MEM')
	RESTORE FROM ADDBS(GoCfgVta.oentorno.tspathcia)+'vtaCONFG.MEM' ADDITIVE
	XFPorRet4ta=CFGADMRET
ELSE 
	MESSAGEBOX('Verificar configuración de valores globales para transacciones de VENTAS / COMPRAS.'+CHR(13)+CHR(13)+ ;
			'ATENCION: Se pueden generar transacciones incompletas en registro de COMPRAS / VENTAS.'	,16 ,'Configuración')
				
	XFPorRet4ta=0
ENDIF

***** Calculos de importes
STORE "" TO nImpNac,nImpUsa,cTitulo

XdFchAst = GdFecha
XfTpoCmb = 1.00

IF !MOVApert()
	MESSAGEBOX('Error en apertura de tablas de la base de datos',16 ,'Acceso a datos')
	RETURN
ENDIF
** **
** VETT  08/05/2017 08:36 AM : Validamos configuracion de DIF.CAMBIO 
SELE CNFG
SEEK "01" 
IF EOF() OR (!SEEK(CNFG.codcta1,'CTAS') AND Dif_ME=0 AND Dif_MN=0)
		LsCodOpe=[]
		SELECT OPER
		LOCATE FOR 'DIF.CAMB'$UPPER(SIGLAS)
		IF FOUND()
			LsCodOpe=OPER.CodOpe
		ENDIF
		SELECT CNFG
		
		IF FILE(ADDBS(goentorno.tspathadm )+'CBDTCNFG.DB1')
			DELETE REST IN CNFG
			APPEND FROM ADDBS(goentorno.tspathadm )+'CBDTCNFG.DB1'
			replace CodOpe WITH LsCodOpe FOR !EMPTY(LsCodOpe) AND INLIST(CodCfg,'01','02')
			FLUSH IN CNFG
		ENDIF
		=RLOCK()
		REPLACE CodOpe WITH OPER.CodOpe
ENDIF
LlCfgDcmb01=.F.
SELE CNFG
SEEK "01" 
XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.09)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.09)
IF Dif_ME=0 OR Dif_MN=0
	=MESSAGEBOX('El valor del tope mínimo y máximo para la generación de ajuste por redondeo de diferencia cambio no estan completos.'+;
				 'Ir al menú de configuración opción "3. Configuración de Diferencia de Cambio", registro 01.',0+64,'Aviso importante')
ELSE
	LlCfgDcmb01=.t. 
ENDIF

SELE CNFG
SEEK "03"
IF !FOUND()
	IF LlCfgCmb01
		XfDif_ME2 = XfDif_ME
		XfDif_MN2 = XfDif_MN 
	ENDIF
ELSE 
	XfDif_ME2 = IIF(Dif_ME<>0,Dif_ME,.09)
	XfDif_MN2 = IIF(Dif_MN<>0,Dif_MN,.09)
	IF Dif_ME=0 OR Dif_MN=0
		=MESSAGEBOX('El valor del tope mínimo y máximo para saldos pendientes de cuenta corriente y/o ajuste por redondeo de diferencia cambio no estan completos.'+;
					 'Ir al menú de configuración opción "3. Configuración de Diferencia de Cambio", registro 03.',0+64,'Aviso importante')
		 
	ENDIF
ENDIF
** ** 
*STORE .f. TO oSn 

*** Buscando que operaciones puede tomar el usuario ***
SELECT OPER

replace ALL Len_ID WITH 8 FOR Len_ID=0
FLUSH IN OPER

SET FILTER TO CODUSR = GsUsuario .OR. EMPTY(CODUSR)
GOTO TOP
IF EOF()
	GsMsgErr = "Usuario no autorizado a registrar Operaciones"
	MESSAGEBOX(GsMsgErr,16,'Acceso denegado')
	RETURN
ENDIF
XsCodOpe = SPACE(LEN(OPER.CodOpe))
UltTecla = 0
cTitulo =" - "+Mes(VAL(XsNroMes),3)+" "+TRANS(_ANO,"9999 ")
**
DO FORM cbd_DiarioGeneral2
*** Tratare de reutilizar todo el codigo posible de este programa llamandolo desde el formulario
*** para evitar la demora en la conversion a interface Visual, lo contrario es colocar este codigo 
*** en metodos y definir que variables deben ser propiedades en el formulario ,pero exige tiempo de codificacion y
*** ya no tengo VETT 24/08/02
*** Segui con mi plan original ya funciona :P  VETT 17/08/2003
*-------------------------------------------------------------------------------
** Rutina Principal **
*-------------------------------------------------------------------------------
POP KEY
RELEASE oSn,oSn2
RETURN
**************************
PROCEDURE Rutina_Principal    
DO WHILE (.T.)
	DO MOVSlMov               && Pide el código de operación a ingresar
	IF UltTecla = K_Esc
		EXIT
		RETURN
	ENDIF
	IF XsCodOpe = "9"
		GsMsgErr = "SOLO PARA MOVIMIENTOS EXTRA CONTABLES DE CAJA"
		=MESSAGEBOX(GsMsgErr,16,'Atención')
		EXIT
	ENDIF
	**** Correlativo Mensual ****
	SELECT RMOV
	SET ORDER TO RMOV01
	SELECT VMOV
	SET ORDER TO VMOV01
	DO WHILE (.T.)
		DO MovNoDoc            && Lectura de Llave
		SELECT VMOV
		if ulttecla <> k_esc
			if ! modificar
				define   window rpta from 15,15 to 18,65 double
				activate window rpta
				rpta = [N]
				@00,02 say [Mes Cerrado, registro no puede ser alterado]
				@01,02 say [       Imprimir Voucher <S/N> =>] get rpta pict [@!];
					   valid (rpta$[SN])
				read
				release  window rpta
				if rpta = [S]
					do imprvouc
				endif
				loop
			endif
		endif
		DO CASE
			CASE UltTecla = K_Esc
				EXIT
			CASE UltTecla = F9            && Borrado (Queda Auditado)
				IF ! Modificar
					GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					LOOP
				ENDIF
				IF FlgEst = "C"
					GsMsgErr = "Asiento Cerrado, no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					IF ! Clave(CFGPasswD)
						LOOP
					ENDIF
				ENDIF
				IF ! INLIST(FlgEst,"C"," ","R","G")
					GsMsgErr = "Asiento, no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					LOOP
				ENDIF
				DO MOVBorra
			CASE UltTecla = F1  .AND. FlgEst = "A"   && Borrado Definitivo
				IF ! Modificar
					GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					LOOP
				ENDIF
				IF ! Clave(CFGPasswD)
					LOOP
				ENDIF
				DO MovBorra
			OTHER
				IF ! Modificar
					GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					LOOP
				ENDIF
				IF Crear
					DO MovInVar
				ELSE
					IF FlgEst = "C"
						GsMsgErr = "Asiento Cerrado, no puede ser alterado"
						=MESSAGEBOX(GsMsgErr,16,'Atención')
						IF ! Clave(CFGPasswD)
							LOOP
						ENDIF
					ENDIF
					IF ! INLIST(FlgEst,"M","C"," ","R")
						GsMsgErr = "Asiento, no puede ser alterado"
						=MESSAGEBOX(GsMsgErr,16,'Atención')
						LOOP
					ENDIF
					DO MovMover
				ENDIF
				DO MovEdita
				DO MovGraba
				DO MovBrows
		ENDCASE
		UNLOCK ALL
		FLUSH
	ENDDO
ENDDO
RETURN

************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
PROCEDURE MOVAPERT
** Abrimos areas a usar **
LOCAL LoDatAdm as dataadmin OF SYS(5)+'\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
LOCAL LReturOk

Modificar  = gosvrcbd.mescerrado(_mes)

LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')

lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
** Archivo de Control de Documentos del Proveedor **
lreturnok=LoDatAdm.abrirtabla('ABRIR','CJADPROV','DPRO','DPRO06','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV02','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDDRMOV','DRMOV','DRMO01','')
lopCTA2=.f.
lopDIAF=.f.
*
lexiste=.t.
lreturnok=LoDatAdm.abrirtabla('ABRIR','FLCJTBDF','DIAF','DIAF01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDMCTA2','CTA2','CTA201','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDTCNFG','CNFG','CNFG01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDPPRES','PPRE','PPRE01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','ADMTCNFG','CNFG2','CNFG01','')

RELEASE LoDatAdm
RETURN lReturnOk

************************************************************************* FIN
* Procedimiento Pide el codigo de movimiento
******************************************************************************
PROCEDURE MOVSlMov
** Pide Operación **
SELECT OPER
DO CASE
	CASE UltTecla = K_Esc

	CASE UltTecla = PgDn
		SKIP
		IF EOF()
			GOTO TOP
		ENDIF
	CASE UltTecla = PgUp
		SKIP - 1
		IF BOF()
			GOTO BOTTOM
		ENDIF
	OTHER
		IF !  XsCodOpe  =  OPER.CodOpe .OR. UltTecla = F8
			SEEK XsCodOpe
			IF ! FOUND()
				GsMsgErr ='Codigo no existe'		
				=MESSAGEBOX(GsMsgErr,16,'Atención')
				UltTecla = 0
				RETURN .f.								
			ENDIF
		ENDIF
ENDCASE
* VERIFICA SI ES UNA PROVISION PARA GRABAR FCHVTO EN FCHPED
if UltTecla <> k_esc
	dimension vcodcta(10)
	store 0 to numcta, numcta1
	sele prov
	seek xscodope
	if found()
		do carga_ctas
	endif
	sele oper
endif
RETURN .t.

************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
@ 0,0 TO 23,79
@ 0,11 SAY " D I A R I O    G E N E R A L "

@ 5,0  SAY "Ã"
@ 5,1  TO  5,49
@ 5,79 SAY "³"

@ 0,50 SAY "Â"
@ 1,50 TO 5,50
@ 5,50 SAY "Ù"

@ 3,0 SAY "Ã"
@ 3,1 TO  3,49 COLOR SCHEME 7
@ 3,50 SAY "´"


@ 20,0  SAY "Ã"
@ 20,1 TO 20,78
@ 20,79 SAY "´"

@ 1,1 SAY PADR(" COMPA¥IA  : "+GsCodCia+" "+GsNomCia,49) COLOR SCHEME 7
@ 2,1 SAY PADR(" Usuario   : "+GsUsuario,49)             COLOR SCHEME 7

cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9999 ")
nCol    = (49-LEN(cTitulo))/2
@ 3,1+nCol SAY cTitulo
@ 4,1 SAY PADR(" OPERACION : ",49) COLOR SCHEME 7

@ 1,52 SAY "No. ASIENTO   :"
@ 2,52 SAY "FECHA         :"
@ 3,52 SAY "MONEDA        :"
@ 4,52 SAY "TIPO DE CAMBIO:"
@ 5,52 SAY "REFERENCIA    :"
@ 6,2  SAY "OBSERVACIONES : "

@ 7,0  SAY "Ã"
@ 7,1  TO  7,78
@ 7,79 SAY "´"
@ 8,1  SAY "       CUENTA                             FECHA                T                " COLOR SCHEME 7
@ 9,1  SAY "   DV CONTABLE AUXILIAR  PROVISION        VCMTO.  GLOSA        M        IMPORTE " COLOR SCHEME 7

@ 10,0  SAY "Ã"
@ 10,1  TO  10,78
@ 10,79 SAY "´"
RETURN

*-------------------------------------------------------------------------------
* Procedimiento de Lectura de llave
*-------------------------------------------------------------------------------
PROCEDURE MovNoDoc
i = 1
IF Crear
	XsNroAst = GoSvrCbd.NROAST()
ENDIF
SELECT VMOV
Llave = (XsNroMes+XsCodOpe+XsNroAst)
SEEK LLave
** Siempre me aseguro de si ya existe o no a pesar de que sea modificar o crear VETT  25/08/02
Crear = ! FOUND()    
DO CASE
	CASE UltTecla = Enter  .and. Crear   && Hizo click en Adicionar  VETT 25/08/02
		Genero = .F.
		SELE DPRO
		SEEK XsNroMes+XsCodOpe+XsNroAst+'-'+XsAno
		DO CASE
			CASE FOUND() .AND. !FLGEST$'GXA'   && Ni Generado ni Desbalanceado
				DO ASTPROV
				SELE DPRO
				IF !Genero
					GsMsgErr = "No pudo generar asiento de recepci¢n"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					UltTecla = 0
					LOOP
				ELSE
					DO WHILE !RLOCK("DPRO")
					ENDDO
					REPLACE FLGEST WITH 'G'
					IF ( ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) >=.01 ) .AND. ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) <=.03 ) );
					 .OR.  ( ( ABS(VMOV.DbeNac-VMOV.HbeNac) >=.01 ) .AND. ( ABS(VMOV.DbeNac-VMOV.HbeNac) <=.05 ) )
						REPLACE FLGEST WITH 'X'
					ENDIF
					UNLOCK IN DPRO
					CREAR=.F.
				ENDIF
			CASE FOUND() AND FlgEst$"GX"
				DO ASTPROV
				SELE DPRO
				IF !Genero
					REPLACE DPRO.FlgEst WITH "P"
					UNLOCK IN DPRO
					GsMsgErr = "No pudo generar asiento de recepci¢n"
					=MESSAGEBOX(GsMsgErr,16,'Atención')
					UltTecla = 0
					LOOP
				ELSE
					DO WHILE !RLOCK("DPRO")
					ENDDO
					REPLACE DPRO.FLGEST WITH 'G'
					IF ( ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) >=.01 ) .AND. ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) <=.03 ) );
					 .OR.  ( ( ABS(VMOV.DbeNac-VMOV.HbeNac) >=.01 ) .AND. ( ABS(VMOV.DbeNac-VMOV.HbeNac) <=.05 ) )
						REPLACE DPRO.FLGEST WITH 'X'
					ENDIF
					UNLOCK
					CREAR=.F.
				ENDIF
			CASE !FOUND()
				&& Actualizamos cuando grabamos
		ENDCASE
		SELE VMOV
		UNLOCK
	CASE UltTecla = F9
		IF ! Modificar
			GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
			MESSAGEBOX(GsMsgerr,16,'ATENCION')
			RETURN .f.
		ENDIF
		IF ! FOUND()
			GsMsgErr = "No existe el Nº de asiento "+XsNroAst
			MESSAGEBOX(GsMsgerr,16,'ATENCION')
			UltTecla = 0
			RETURN .F.
		ENDIF
		DO MovPinta
	CASE UltTecla = F1
		IF ! Modificar
			GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
			MESSAGEBOX(GsMsgerr,16,'ATENCION')
		ENDIF
		IF ! FOUND()
			GsMsgErr = "No existe el Nº de asiento "+XsNroAst
			MESSAGEBOX(GsMsgerr,16,'ATENCION')
			UltTecla = 0
		ELSE
			IF VMOV.FlgEst = "A"
				DO MovPinta
			ENDIF
		ENDIF
	CASE UltTecla = PgUp                    && Anterior Documento
		IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe)
			SEEK (XsNroMes+XsCodOpe+Chr(255))
			IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
				GOTO RECNO(0)
			ELSE
				GOTO BOTTOM
			ENDIF
			IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe)
				SKIP -1
			ENDIF
		ELSE
			IF ! BOF()
				SKIP -1
			ENDIF
		ENDIF
		XsNroAst = NROAST
	CASE UltTecla = PgDn  .AND. ! EOF()     && Siguiente Documento
		SKIP
		XsNroAst = NROAST
	CASE UltTecla = Home                    && Primer Documento
		SEEK (XsNroMes+XsCodOpe)
		XsNroAst = NROAST
	CASE UltTecla = K_End                     && Ultimo Documento
		SEEK (XsNroMes+XsCodOpe+Chr(255))
		IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
			GOTO RECNO(0)
			SKIP -1
		ELSE
			GOTO BOTTOM
		ENDIF
		XsNroAst = NROAST
	OTHER
		IF XsNroAst < GoSvrCbd.NROAST()
			SEEK LLave
			IF ! FOUND() .AND. INLIST(UltTecla,CtrlW,Enter)
				Crear = .t.
			ENDIF
			IF ! FOUND()
				GsMsgErr = "No existe el Nº de asiento "+XsNroAst
				MESSAGEBOX(GsMsgerr,16,'ATENCION')
				UltTecla = 0
			ELSE
				IF VMOV.FlgEst = "A"
					GsMsgErr = "Nº de asiento "+XsNroAst+ " esta ANULADO"
					MESSAGEBOX(GsMsgerr,16,'ATENCION')
					UltTecla = 0
				ENDIF
			ENDIF
		ENDIF
ENDCASE
IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
	XsNroAst = GoSvrCbd.NROAST()
	Crear = .t.
ELSE
	XsNroAst = VMOV.NroAst
	DO MovPinta
	Crear = .f.
ENDIF
SELECT VMOV
RETURN Crear 

************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar
XsNroVou = SPACE(LEN(VMOV.NROVOU))
XiCodMon = 1
XsNotAst = SPACE(LEN(VMOV.NOTAST))
XsDigita = GsUsuario
XsAuxil	 = SPACE(LEN(VMOV.Auxil))
RETURN

************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
do MovMover
LinAct = 11
IF VMOV.FlgESt = "A"
	SELECT c_rmov
	ZAP
	GO TOP IN C_RMOV
	DO MovPImp

ELSE
	*** Calateamos al temporal ***
	SELECT c_rmov
	ZAP
	*** Fin del calateo
	SELECT RMOV
	LsLLave  = XsNroMes+XsCodOpe+VMOV.NroAst
	SEEK LsLLave
	DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF() && AND LinAct < 20
		=SEEK(CodCta,'CTAS','CTAS01')
		=SEEK(ClfAux+CodAux,'AUXI','AUXI01')
		=SEEK('SN'+CodDoc,'TABL','TABL01')
		=SEEK(CtaPre,'PPRE','PPRE01')
		SCATTER memvar
		m.NroReg = RECNO()	
		m.Nomcta = Ctas.NomCta
		m.NomAux = AUXI.NomAux
		m.PidAux = CTAS.PidAux
		m.PidDoc = Ctas.PidDoc
		m.PidGlo = Ctas.PidGlo
		m.GenAut = CTAS.GenAut
		m.DesDoc = TABL.NomBre		
		m.NomCtaPre = PPRE.Nombre
		=SEEK(PADR(GsClfCct,LEN(Tabl.Tabla))+PADR(CodCco,LEN(TABL.Codigo)),'TABL','TABL01')
		m.NomCodCco = TABL.Nombre
		=SEEK('DV '+TRIM(CodDiv),'AUXI','AUXI01')
		m.NomCodDiv = AUXI.NomAux
		=SEEK('OTR'+TRIM(TpoGto),'AUXI','AUXI01')
		m.NomTpoGto = AUXI.NomAux
		m.An1Cta = CTAS.An1Cta
		m.CC1Cta = CTAS.Cc1Cta
		m.An2Cta = CTAS.An2Cta
		m.An2Cta = CTAS.An2CtaME
		m.CC2Cta = CTAS.Cc2Cta
		m.tip_afe_RC = CTAS.tip_afe_RC
		m.tip_afe_RV = CTAS.tip_afe_RV
		m.tip_afe_RT = CTAS.tip_afe_RT
		IF m.tip_afe_RC='A' OR m.tip_afe_RV='A' OR m.tip_afe_RT='A'
			LsCodCtaAn2=IIF(XiCodMon=1,CTAS.An2Cta,CTAS.An2CtaME)
			=SEEK(LsCodCtaAn2,'CTAS','CTAS01')
			m.Pid2Aux	=	CTAS.PidAux
			m.Pid2Doc	=	CTAS.PidDoc
			m.Pid2Glo	=	CTAS.PidGlo
		ENDIF
		=SEEK(CodCta,'CTAS','CTAS01')
		INSERT into c_rmov from memvar	
		LinAct = LinAct + 1
		SKIP
	ENDDO
	GO TOP IN C_RMOV
	DO MovPImp
ENDIF
SELECT VMOV
RETURN

*******************************************************************************
* NUMERO DE ASIENTO CORRELATIVO POR ORIGEN
*******************************************************************************
FUNCTION NROAST
PARAMETER XsNroAst
LOCAL LnLen_ID
DO CASE
	CASE XsNroMES = "00"
		iNroDoc = OPER.NDOC00
	CASE XsNroMES = "01"
		iNroDoc = OPER.NDOC01
	CASE XsNroMES = "02"
		iNroDoc = OPER.NDOC02
	CASE XsNroMES = "03"
		iNroDoc = OPER.NDOC03
	CASE XsNroMES = "04"
		iNroDoc = OPER.NDOC04
	CASE XsNroMES = "05"
		iNroDoc = OPER.NDOC05
	CASE XsNroMES = "06"
		iNroDoc = OPER.NDOC06
	CASE XsNroMES = "07"
		iNroDoc = OPER.NDOC07
	CASE XsNroMES = "08"
		iNroDoc = OPER.NDOC08
	CASE XsNroMES = "09"
		iNroDoc = OPER.NDOC09
	CASE XsNroMES = "10"
		iNroDoc = OPER.NDOC10
	CASE XsNroMES = "11"
		iNroDoc = OPER.NDOC11
	CASE XsNroMES = "12"
		iNroDoc = OPER.NDOC12
	CASE XsNroMES = "13"
		iNroDoc = OPER.NDOC13
	OTHER
		iNroDoc = OPER.NRODOC
ENDCASE
LnLen_ID = OPER.Len_ID
IF OPER.ORIGEN
	iNroDoc = VAL(TsCodDiv1+XsNroMes+RIGHT(TRANSF(iNroDoc,"@L ########"),4))
ENDIF
IF PARAMETER() = 1
	IF VAL(XsNroAst) > iNroDoc
		iNroDoc = VAL(XsNroAst) + 1
	ELSE
		iNroDoc = iNroDoc + 1
	ENDIF
	DO CASE
		CASE XsNroMES = "00"
			REPLACE   OPER.NDOC00 WITH iNroDoc
		CASE XsNroMES = "01"
			REPLACE   OPER.NDOC01 WITH iNroDoc
		CASE XsNroMES = "02"
			REPLACE   OPER.NDOC02 WITH iNroDoc
		CASE XsNroMES = "03"
			REPLACE   OPER.NDOC03 WITH iNroDoc
		CASE XsNroMES = "04"
			REPLACE   OPER.NDOC04 WITH iNroDoc
		CASE XsNroMES = "05"
			REPLACE   OPER.NDOC05 WITH iNroDoc
		CASE XsNroMES = "06"
			REPLACE   OPER.NDOC06 WITH iNroDoc
		CASE XsNroMES = "07"
			REPLACE   OPER.NDOC07 WITH iNroDoc
		CASE XsNroMES = "08"
			REPLACE   OPER.NDOC08 WITH iNroDoc
		CASE XsNroMES = "09"
			REPLACE   OPER.NDOC09 WITH iNroDoc
		CASE XsNroMES = "10"
			REPLACE   OPER.NDOC10 WITH iNroDoc
		CASE XsNroMES = "11"
			REPLACE   OPER.NDOC11 WITH iNroDoc
		CASE XsNroMES = "12"
			REPLACE   OPER.NDOC12 WITH iNroDoc
		CASE XsNroMES = "13"
			REPLACE   OPER.NDOC13 WITH iNroDoc
		OTHER
			REPLACE   OPER.NRODOC WITH iNroDoc
	ENDCASE
	UNLOCK IN OPER
ENDIF
RETURN  RIGHT(repli("0",LnLen_ID) + LTRIM(STR(iNroDoc)), LnLen_ID)

************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE MOVMover
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsNotAst = VMOV.NOTAST
XsDigita = VMOV.Digita
XsAuxil  = VMOV.Auxil
RETURN

************************************************************************** FIN
* Procedimiento de edita las variables de cabecera
******************************************************************************
PROCEDURE MOVEdita
UltTecla = 0
IF ! Crear
	IF .NOT. RLock()
		GsMsgErr = "Asiento usado por otro usuario"
		=MESSAGEBOX(GsMsgErr,16,'Atención')
		UltTecla = K_esc
		RETURN              && No pudo bloquear registro
	ENDIF
ENDIF
I = 1
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,K_esc)
	DO CASE
		CASE I = 1
			@ 2,68 GET XdFchAst
			READ
			UltTecla = LastKey()
			@ 2,68 SAY XdFchAst
		CASE I = 2
			VecOpc(1)="S/."
			VecOpc(2)="US$"
			DO CASE
				CASE OPER.CODMON = 1
					XiCodMon= 1
				CASE OPER.CODMON = 2
					XiCodMon= 2
				OTHER
					XiCodMon= Elige(XiCodMon,3,68,2)
			ENDCASE
			@ 3,68 SAY IIF(XiCODMON=1,"S/.","US$")
		CASE I = 3
			SELECT TCMB
			SEEK DTOC(XdFchAst,1)
			OK = .T.
			IF ! FOUND()
				OK = .F.
				?? chr(7)
				WAIT "T/Cambio no registrado" NOWAIT WINDOW
				GOTO BOTTOM
			ENDIF
			IF Crear
				XfTpoCmb = iif(OPER.TpoCmb=1,OFICMP,OFIVTA)
			ELSE
				IF XdFchAst<>VMOV.FchAst
					XfTpoCmb = iif(OPER.TpoCmb=1,OFICMP,OFIVTA)
				ENDIF
			ENDIF
			@ 4 ,68 GET XfTpoCmb PICT "9999.9999" VALID XfTpoCmb > 0
			READ
			UltTecla = LastKey()
			@ 4 ,68 SAY XfTpoCmb PICT "9999.9999"
			IF ! OK
				APPEND BLANK
				REPLACE FCHCMB WITH XdFchast
			ENDIF
			IF OPER.TpoCmb=1
				IF OFICMP = 0
					REPLACE OFICMP WITH XfTpoCmb
				ENDIF
			ELSE
				IF OFIVTA = 0
					REPLACE OFIVTA WITH XfTpoCmb
				ENDIF
			ENDIF
		CASE I = 4
			IF Crear
				XsNroVou = XsNroAst+"-"+RIGHT(STR(_ANO,4),2)
			ENDIF
			@ 5 ,68 GET XsNroVou PICT "@!"
			READ
			UltTecla = LastKey()
			@ 5 ,68 SAY XsNroVou
		CASE I = 5
			@ 6, 18 GET XsNotAst
			READ
			UltTecla = LastKey()
			IF UltTecla = Enter
				UltTecla = CtrlW
			ENDIF
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>5,5, i)
	i = IIF(i<1, 1, i)
ENDDO
SELECT VMOV
RETURN

************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
PARAMETERS __Nromes,__CodOpe,__NroAst
IF PARAMETERS()=0
	__NroMes=XsNroMes
	__CodOpe=XsCodOpe
	__NroAst=XsNroAst
ENDIF
LnOk=GoSvrCbd.MovBorra(__Nromes,__CodOpe,__NroAst)
RETURN

************************************************************************** FIN
* Procedimiento de Grabar las variables de cabecera
******************************************************************************
PROCEDURE MOVGraba
#INCLUDE CONST.H
IF UltTecla = K_esc
	RETURN
ENDIF
UltTecla = 0
IF Crear                  && Creando
	SELE OPER
	IF ! RLock()
		UltTecla = K_esc
		RETURN              && No pudo bloquear registro
	ENDIF
	SELECT VMOV
	SEEK (XsNroMes + XsCodOpe + XsNroAst)
	IF FOUND()
		cDesErr = "Registro creado por otro usuario"
		=MESSAGEBOX(cDesErr,16,'Error de creación')
		UltTecla = K_esc
		RETURN
	ENDIF
	APPEND BLANK
	REPLACE VMOV.NROMES WITH XsNroMes
	REPLACE VMOV.CodOpe WITH XsCodOpe
	REPLACE VMOV.NroAst WITH XsNroAst
	REPLACE VMOV.FLGEST WITH "R"
	replace vmov.fchdig  with date()
	replace vmov.hordig  with time() 
	SELECT OPER
	=GoSvrCbd.NROAST(XsNroAst)
	SELECT VMOV
ELSE
	*** ACTULIZA CAMBIOS DE LA CABECERA EN EL CUERPO ***
	IF VMOV.FchAst <> XdFchAst .OR. VMOV.NroVou <> XsNroVou
		SELECT RMOV
		Llave = (XsNroMes + XsCodOpe + XsNroAst )
		SEEK Llave
		DO WHILE ! EOF() .AND. Llave = (NroMes + CodOpe + NroAst )
			IF Rlock()
				REPLACE RMOV.FchAst  WITH XdFchAst
				IF VARTYPE(NroVou)='C'
					REPLACE RMOV.NroVou  WITH XsNroVou
				ENDIF    
				UNLOCK
			ENDIF
			SKIP
		ENDDO
	ENDIF
	SELECT VMOV
ENDIF
REPLACE VMOV.FchAst  WITH XdFchAst
REPLACE VMOV.NroVou  WITH XsNroVou
REPLACE VMOV.CodMon  WITH XiCodMon
REPLACE VMOV.TpoCmb  WITH XfTpoCmb
REPLACE VMOV.NotAst  WITH XsNotAst
REPLACE VMOV.Digita  WITH GsUsuario
REPLACE VMOV.Auxil	 WITH IIF(VARTYPE(XsAuxil)!='C','',XsAuxil)
Crear = .F.
RETURN

******************************************************************************
*  Prop¢sito     : Procedimientos de browse (Ingresos de Cuentas)
******************************************************************************
PROCEDURE MOVBrows
#Include CONST.H
PARAMETERS lSetupVarDetalle
IF lSetupVArDetalle
	IF UltTecla = K_esc
		RETURN
	ENDIF
	UltTecla = 0
	NClave   = [NroMes+CodOpe+NroAst]
	VClave   = XsNroMes+XsCodOpe+XsNroAst
	Adiciona = .T.
	SELECT RMOV
	*** Variable a Conocer ****
	XsCtaPre = SPACE(LEN(RMOV.CtaPre))
	XsCodCta = SPACE(LEN(RMOV.CodCta))
	XsClfAux = SPACE(LEN(RMOV.ClfAux))
	XsCodAux = SPACE(LEN(RMOV.CodAux))
	XsCodPrv = SPACE(LEN(RMOV.CodAux))
	XsNomPrv = SPACE(LEN(AUXI.NomAux))
	XsRefPrv = SPACE(LEN(RMOV.NroRef))
	XsIniAux = SPACE(LEN(RMOV.IniAux))
	XsCodRef = SPACE(LEN(RMOV.CodRef))
	XsCodDiv = SPACE(LEN(RMOV.CodDiv))
	xsglodoc = vmov.notast
	XdFchDoc = VMOV.FCHAST
	XdFchVto = {  ,  ,    }
	XdFchPed = {  ,  ,    }
	*
	xsnivadi = space(len(rmov.tpoo_c))
	*
	XsCodDoc = SPACE(LEN(RMOV.CodDoc))
	XsTipRef = IIF(VerifyVar('TipRef','','CAMPO','RMOV'),RMOV.TipRef,'') && SPACE(LEN(RMOV.TipRef))
	
	XsNroDoc = SPACE(LEN(RMOV.NroDoc))
	XsNroRef = SPACE(LEN(RMOV.NroRef))
	XSCODFIN = SPACE(LEN(RMOV.CODFIN))
	XsNroDtr = SPACE(LEN(RMOV.NRODTR))
	XdFchDtr = {  ,  ,    }
	XsTipOri1 = SPACE(LEN(RMOV.TipOri))
	XsNumOri1 = SPACE(LEN(RMOV.NumOri))
	XiCodMon = VMOV.CodMon
	XcTpoMov = "D"
	XfImport = 0.00
	XfImpNac = 0.00
	XfImpUsa = 0.00
	XiNroItm = VMOV.NroItm+1
	XiNroItm = 1
	XcTipoC  = SPACE(LEN(RMOV.TipoC))
	* DATOS SUNAT
	XsNroRuc = space(len(rmov.NroRuc))
	XsFecOri = {  ,  ,    }
	store 0 to XsImpOri,XsImpNac1, XsImpNac2
	XsTipOri = space(len(drmov.tipori))
	XsTipDoc = space(len(drmov.tipdoc))
	XsNumOri = space(len(drmov.numori))
	XsNumPol = space(len(drmov.n_poliza))
	XsTipDoc1= space(len(drmov.tipdoc))
	XsCodCta1= SPACE(LEN(RMOV.CodCta))
	XsNroRef1= SPACE(LEN(RMOV.NroRef))
	XsCodCco = SPACE(LEN(RMOV.CodCco))
	DIMENSION vCdMDos(1,1)
	STORE [] TO vCdmDos
	TnLenGlo = 12
	** Aqui llamabamos antiguamente al DBROWSE o F1BROWSE
	** Ahora solo configuramos las variables remanentes
	IF (LEN(TRIM(VClave)) <> 0)
		RegVal   = "&NClave = VClave"
		SEEK VClave
		Set_Append = ! (&RegVal) .AND. Adiciona
	ELSE
		* - Todos los registros son v lidos.
		RegVal = ".T."
		LOCATE
		Set_Append = EOF() .AND. Adiciona
	ENDIF
ELSE
	** Verificamos Flag a Grabar en DPRO **
	SELE DPRO
	SEEK XsNroMes+XsCodOpe+XsNroAst+'-'+XsAno
	IF FOUND()
		lDesBal = ( ABS(VMOV.HbeUsa-VMOV.DbeUsa) >.01 ) .or. ( ABS(VMOV.HbeNac-VMOV.DbeNac) >.05 )
		LlRlock = .F.
		LlRlock = F1_RLock(0)
		IF lDesBal
			REPLACE FlgEst WITH [X]
		ELSE
			REPLACE FlgEst WITH [G]
		ENDIF
		UNLOCK
	ELSE
		&& agregar algo por aca
	ENDIF
	SELECT VMOV
ENDIF	
RETURN

************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVbline
PARAMETERS Contenido
		   *		   1	     2         3         4         5         6         7        
		   *0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-
		   *  112-12345678-12345678-12345678901234-1234567890-123456789012-1-12312345678901
Contenido = EliItm+CodDiv+" "+CodCta+" "+CodAux+" "+NroDoc+" "
if empty(fchvto)
	contenido = contenido + space(11)
else
	xsfchvto = dtoc(fchvto)
	contenido = contenido + xsfchvto + " "
endif
contenido = contenido + left(glodoc,TnLenGlo)+" "+tpomov+"    "
IF VMOV.CodMon <> 1
	Contenido = Contenido + TRAN(ImpUsa,"99999999.99")
ELSE
	Contenido = Contenido + TRAN(Import,"99999999.99")
ENDIF
if codcta=[42] or (inlist(codope,[270],[272],[280]) and inlist(codcta,[28],[42],[46]))
	=seek(clfaux+codaux,[auxi])
	xscodprv = codaux
	xsnomprv = auxi.nomaux
	xsrefprv = nroref
endif
RETURN

************************************************************************ FIN *
* Objeto : Complementa una linea del browse
******************************************************************************
PROCEDURE MOVbcomp
@ 20,02 SAY PADC(ALLTRIM(STR(RMOV.NroItm,5))+"/"+ALLTRIM(STR(VMOV.NroItm,5)),11) COLOR SCHEME 7
@ 21,1 clear to 22,78
=SEEK(RMOV.CodCta,"CTAS")
IF ! EMPTY(CODAUX)
	=SEEK(CLFAUX+CODAUX,"AUXI")
	@ 22,1 SAY "AUXILIAR: "+AUXI.NomAux
ENDIF
IF CodAux="09990"
	@ 22,1 clear to 22,78
	@ 22,01 SAY "Iniciales:"  COLOR SCHEME 11
	@ 22,12 SAY IniAux
	@ 22,60 SAY "R.U.C. :"    COLOR SCHEME 11
	@ 22,69 SAY NroRuc
ENDIF
***
IF CodCta=[10]
	@ 22,01 SAY [Fecha Finanzas:] COLOR SCHEME 11
	@ 22,30 SAY [Marcar:]         COLOR SCHEME 11
	@ 22,17 SAY FchPed
	@ 22,37 SAY TipoC
ENDIF	
***
IF VMOV.CODMON = 1
	@ 21,60  SAY "US$"  COLOR SCHEME 11
	@ 21,62  SAY IMPUSA  PICTURE "999,999,999.99"  COLOR SCHEME 11
ELSE
	@ 21,60  SAY "S/."  COLOR SCHEME 11
	@ 21,62  SAY IMPORT  PICTURE "999,999,999.99"  COLOR SCHEME 11
ENDIF
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit
#INCLUDE CONST.H
PARAMETERS PcAccion,i
IF EMPTY(PcAccion)
	RETURN .t.
ENDIF
&& Solo para inicializar las variables que corresponden a una linea del detalle
IF i = '999'  
	DO CASE 
		CASE PcAccion ='A'		&& Actualizar
		   IF INLIST(C_RMOV.EliItm , "*")
		      GsMsgErr = " Linea no puede ser modificada, es cuenta automatica"
		      =MESSAGEBOX(GsMsgErr,16,'Acceso denegado')
		      UltTecla = K_esc
		      RETURN .f.
		   ENDIF
		   DO Cap_Detalle_Cursor WITH PcAccion
		CASE PcAccion = 'I'
		   XsCodRef = SPACE(LEN(C_RMOV.CodRef))
		   XdFchDoc = VMOV.FCHAST
		   XdFchVto = {  ,  ,    }  
		   XfImpUsa    = 0
		   XfImpNac    = 0
		   XsCodDoc = SPACE(LEN(C_RMOV.CodDoc))
		   XsNroDoc = SPACE(LEN(C_RMOV.NroDoc))
		   XsTipRef = IIF(VerifyVar('TipRef','','CAMPO','RMOV'),C_RMOV.TipRef,'') && SPACE(LEN(C_RMOV.TipRef))
		   XsNroRef = SPACE(LEN(C_RMOV.NroRef))
		   XdFchRef = {  ,  ,    }
		   XsNroDtr = SPACE(LEN(C_RMOV.NroDtr))
		   XdFchDtr = {  ,  ,    }			
		   if !empty(vmov.notast) AND RECCOUNT('C_RMOV')=0
		      xsglodoc = vmov.notast
		   endif
		   XiCodMon = VMOV.CodMon
		   XiNroItm = VMOV.NroItm+1
		   XdFchPed = VMOV.FchAst
		   XcTipoC  = SPACE(LEN(RMOV.TipOC))
		   store [NO] to XsTipDoc, XsTipDoc1
		   XsCodCta1= SPACE(LEN(C_RMOV.CodCta))
		   XsNroRef1= SPACE(LEN(C_RMOV.NroRef))
		   store 0 to xsimpori, xsimpnac1, xsimpnac2
		   XsTipOri = space(len(drmov.tipori))
		   XsNumOri = space(len(drmov.numori))
		   XsNumPol = space(len(drmov.n_poliza))
	ENDCASE
	lActCta40=.f.
	Td40FchRef=CTOD([01/01/]+STR(_ANO,4,0))
	Td40FchVto=Td40FchRef
	Ts40NroDoc=[]
	Ts40CodAux=[]
	TsClfAuxAc=XsClfAux
	RETURN .t.
ENDIF

DO CASE
	CASE i = 'CODCCO'  && AND ( gocfgcbd.tipo_empre = 3	OR (INLIST(gocfgcbd.tipo_empre,1,2) AND GOCFGCBD.C_COSTO =3 AND GoCfgCbd.Tipo_Conso=1) )

		SELECT TABL
		SEEK PADR(GsClfCct,LEN(TABL.Tabla))+PADR(XsCodCCo,LEN(Tabl.Codigo))
        IF !FOUND()
			GsMsgErr = [Codigo de Centro de costo no existe]
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla=0
			RETURN .F.
		ENDIF
		replace c_rmov.CodCCo WITH XsCodCCo
		replace c_rmov.NomCodCco WITH TABL.NomBre

	CASE i = 'CTAPRE'  && AND ( gocfgcbd.tipo_empre = 3	OR (INLIST(gocfgcbd.tipo_empre,1,2) AND GOCFGCBD.C_COSTO =3 AND GoCfgCbd.Tipo_Conso=1) )
		SELECT PPRE
		SEEK XsCtaPre
        IF !FOUND()
			GsMsgErr = [Codigo de Presupuesto/Proyecto no existe]
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla=0
			RETURN .F.
		ENDIF
		replace c_rmov.CtaPre WITH XsCtaPre
		replace c_rmov.NomCtaPre WITH PPRE.NomBre
	
	CASE i = 'CODDIV'  && AND gocfgcbd.tipo_conso = 2
		SELECT AUXI	
        SEEK [DV ]+PADR(XsCodDiv,LEN(AUXI.CodAux))
        IF !FOUND()
			GsMsgErr = [Codigo de divisionaria invalido]
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla=0
			RETURN .F.
		ENDIF
		replace c_rmov.CodDiv WITH XsCodDiv
		replace c_rmov.NomCodDiv WITH Auxi.NomAux
		
	CASE I = 'TPOGTO'	
		SELECT AUXI	
        SEEK [OTR]+PADR(XsTpoGto,LEN(AUXI.CodAux))
        IF !FOUND()
			GsMsgErr = [Codigo de proyecto invalido]
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla=0
			RETURN .F.
		ENDIF
		replace c_rmov.TpoGto		WITH XsTpoGto
		replace c_rmov.NomTpoGto	WITH Auxi.NomAux

	CASE i = 'CODCTA'        && C¢digo de Cuenta
		SELECT CTAS
		IF EMPTY(XsCodCta)
			RETURN .t.
		ENDIF
		SEEK XsCodCta
		IF ! FOUND()
			GsMsgErr = "Cuenta no Registrada"
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.
		ENDIF
		** 
		** VETT  08/05/2017 09:59 AM : validar cuentas automaticas clase 6 
		IF UPPER(GsSigCia)='RAUO'
*!*				SET STEP ON 
			IF EMPTY(Tag_Migra) AND AftMov='S' AND (GenAut='S' OR CtaDrv='S') AND ClfAux='05' AND (CodCta>='62' AND CodCta<='69')
				** VETT  09/05/2017 09:04 AM : El codigo siguiente es para ayudar a cargar valores en plan de cuentas 
				IF FILE(ADDBS(goentorno.tspathadm )+'CBDMCTAS.DB1')  && OJO para evitar este codigo borrar archivo 'CBDMCTAS.DB1'
*!*						IF NOT (EMPTY( An1Cta) AND !EMPTY(CC1Cta) AND LEN(CC1Cta)=8)
						IF !USED('CTAMOD1')
							SELECT 0
							USE ADDBS(goentorno.tspathadm )+'CBDMCTAS.DB1' ALIAS CTAMOD1
						ELSE
							SELECT CTAMOD1
						ENDIF
						LOCATE FOR CODCTA='6'
						IF FOUND()
							SELECT CTAS
							=RLOCK()
							IF GenAut='S' AND CTaDrv<>'S'
								REPLACE CC1CTA WITH CTAMOD1.CC1CTA
							ENDIF
							IF CtaDrv='S' AND GenAut<>'S'
								REPLACE GenAut WITH 'S'
							ENDIF
							IF CTAS.CodCta='62'
								REPLACE tip_afe_rc 	WITH 'X' IN CTAS
						
							ELSE
								REPLACE An2Cta WITH CTAMOD1.An2Cta,CC2Cta WITH CTAMOD1.CC2Cta, ;
								An2CtaMe WITH CTAMOD1.An2CtaMe,tip_afe_rc WITH CTAMOD1.tip_afe_rc ,;
								PidGlo WITH CTAMOD1.PidGlo,PidDoc WITH CTAMOD1.PidDoc IN CTAS
							ENDIF
							REPLACE PidGlo    WITH 'N' ,PidDoc WITH 'N' IN CTAS
							REPLACE MayAux    WITH 'N'
							REPLACE Tag_Migra WITH 'A' IN CTAS
							UNLOCK
						ENDIF	
						
*!*						ENDIF
				ENDIF
			ENDIF
		ENDIF
		SELECT CTAS
		** VETT  08/05/2017 09:59 AM : validar cuentas automaticas clase 6 
		IF CTAS.AFTMOV#"S"
			GsMsgErr = "Cuenta no Afecta a movimiento"
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ENDIF
		IF Ctas.PidAux='S'	
			SELECT TABL
			XsTabla = PADR("01",LEN(TABL.Tabla))
			IF EMPTY(CTAS.CLFAUX) 
				GsMsgErr = " Invalida Configuración de Cuenta. No registro la clasificaci¢n del auxiliar"
				=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
				UltTecla = 0
				RETURN .F.	
			ELSE
				XsClfAux = CTAS.ClfAux
			ENDIF
			SEEK XsTabla+XsClfAux
			IF ! FOUND()
				GsMsgErr = " Invalida Configuración de Cuenta. No registro la clasificaci¢n del auxiliar"
				=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
				UltTecla = K_esc
				RETURN .F.	
			ENDIF
			iDigitos = TABL.Digitos
			IF iDigitos < 0 .OR. iDigitos > LEN(XsCodAux)
				iDigitos = LEN(XsCodAux)
			ENDIF
		ELSE
			XsClfAux = ''
		ENDIF
		IF XsCodCta=[40] 
			lExiste=SEEK(XsCodCta,[CTA2])
			IF lExiste
				LsVcto=[CTA2.Vcto]+XsNroMes
				IF !EMPTY(EVAL(LsVcto)) 
					Td40FchVto = EVAL(LsVcto)
					lActCta40= .t.
					IF Td40FchVto#Td40FchRef AND !EMPTY(Td40FchVto) ; 
						AND XdFchVto#Td40FchVto and EMPTY(XdFchVto)
						XdFchVto=Td40FchVto
					ENDIF
				ENDIF	
				IF _ANO<2000
					Ts40NroDoc=PADR(XsNroMes+[0001]+[-]+RIGHT(STR(_ANO,4),2),LEN(RMOV.NroDoc))
				ELSE
					Ts40NroDoc=PADR(XsNroMes+[0001]+[-]+STR(_ANO,4),LEN(RMOV.NroDoc))
				ENDIF	         		
				Ts40CodAux=CTA2.CodAux
			ENDIF
		ENDIF
		replace c_rmov.Clfaux WITH XsClfaux
		replace c_rmov.NomCta WITH CTAS.NomCta  
		REPLACE c_RMOV.PidAux WITH CTAS.PidAux
		REPLACE c_Rmov.PidDoc WITH CTAS.PidDoc
		REPLACE c_rmov.PidGlo WITH CTAS.PidGlo
		REPLACE c_Rmov.GenAut WITH CTAS.GenAut
		REPLACE c_RMOV.Editando WITH 'E'
        replace C_rmov.tip_Afe_RC WITH CTAS.tip_Afe_RC
        replace C_rmov.tip_Afe_RV WITH CTAS.tip_Afe_RV         	
        replace C_rmov.tip_Afe_RT WITH CTAS.tip_Afe_RT
        IF C_RMOV.GenAut='S'
	        replace C_rmov.An1Cta WITH CTAS.An1Cta
	        replace C_rmov.Cc1Cta WITH CTAS.Cc1Cta
	    ELSE
	        replace C_rmov.An1Cta WITH ''
	        replace C_rmov.Cc1Cta WITH ''
	    ENDIF
	    IF C_rmov.tip_Afe_RC='A'   OR C_rmov.tip_Afe_RV='A'  OR C_rmov.tip_Afe_RT='A'
	        replace C_rmov.An2Cta WITH CTAS.An2Cta
    	    replace C_rmov.Cc2Cta WITH CTAS.Cc2Cta
    	ELSE
	        replace C_rmov.An2Cta WITH ''
    	    replace C_rmov.Cc2Cta WITH ''
		ENDIF
        *** VETT 2007-07-14
        IF c_Rmov.PidAux='S'
	   		replace c_RMOV.NomClf WITH TABL.Nombre
	   		REPLACE c_RMOV.LonAux WITH TABL.Digitos
   		ENDIF
   		IF C_rmov.tip_afe_rc='A' OR  C_rmov.tip_afe_rV='A' OR C_rmov.tip_afe_rt='A'
			IF SEEK(XsAn2Cta,'CTAS')
				REPLACE C_RMOV.Pid2Aux WITH CTAS.PidAux
				REPLACE C_RMOV.Pid2Doc WITH CTAS.PidDoc
				REPLACE C_RMOV.Pid2Glo WITH CTAS.PidGlo 
			ENDIF
		ENDIF
   		=SEEK(XsCodCta,'CTAS')
   		
	CASE i = 'CODAUX' .AND. CTAS.PidAux = [S]
		SELECT TABL
		XsTabla = PADR("01",LEN(TABL.Tabla))
		IF EMPTY(CTAS.CLFAUX)
			GsMsgErr = " Invalida Configuración de Cuenta. No registro la clasificaci¢n del auxiliar"
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ELSE
			XsClfAux = CTAS.ClfAux
		ENDIF
		SEEK XsTabla+XsClfAux
		IF ! FOUND()
			GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = K_esc
			RETURN .F.	
		ENDIF
		iDigitos = TABL.Digitos
		IF iDigitos < 0 .OR. iDigitos > LEN(XsCodAux)
			iDigitos = LEN(XsCodAux)
		ENDIF
		IF (EMPTY(XsCodAux) AND XsCodCta=[40]) OR (XsCodCta="40" AND Crear)
			XsCodAux=iif(!empty(Ts40CodAux),padr(Ts40CodAux,idigitos),xscodaux)
		ENDIF
		SELECT AUXI
		XsCodAux = PADR(XsCodAux,LEN(C_RMOV.CodAUX))
		SEEK XsClfAux+XsCodAux
		IF ! FOUND() AND !EMPTY(XsCodAux)
			GsMsgErr = 'Código de auxiliar invalido'
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ENDIF
		replace c_RMOV.NomClf WITH TABL.Nombre	
		replace c_rmov.Nomaux WITH Auxi.NomAux
		REPLACE c_RMOV.LonAux WITH iDigitos
		
	CASE i = 'CODAUX' .AND. CTAS.PidAux # [S]
		XsClfAux = SPACE(LEN(C_RMOV.CLFAUX))
		XsCodAux = SPACE(LEN(C_RMOV.CODAUX))
		replace c_RMOV.NomClf WITH ''
		replace c_rmov.Nomaux WITH ''
	CASE i = 'CODDOC' 	 
		LlFound= SEEK(PADR('SN',LEN(TABL.Tabla))+XsCodDoc,'TABL','TABL01')
		IF !LlFound  && AND !EMPTY(XsCodDoc)
			GsMsgErr = 'Codigo de documento inválido'
	        =MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN LlFound
		ENDIF
		REPLACE C_Rmov.DesDoc WITH TABL.NomBre
		REPLACE C_RMOV.TipDoc WITH C_RMOV.CodDoc
	CASE i = 'NRODOC' .AND. CTAS.PidDoc=[S]
		** No modificar documento en caso de Proveedores y Modificacion **
		IF EMPTY(XsNroDoc)
			RETURN .T.
		ENDIF         
		DO CASE
			CASE PcAccion='I'
				** Generamos Numero de Documento **
				IF USED('CTACTE')
  					=SEEK(XsNroDoc,'CTACTE')
					IF XiCodMon = 1
						XfImport =	CTACTE.Import                     		
					ELSE
						XfImport =  CTACTE.ImpUsa                     		
					ENDIF
					IF XiCodMon=1
						XfImpNac    = XfImport
						XfImpUsa    = IIF(VMOV.TpoCmb>0,round(XfImport/VMOV.TpoCmb,2),0)
					ELSE
						XfImpUsa    = XfImport
						XfImpNac    = round(XfImport*VMOV.TpoCmb,2)
					ENDIF

					replace C_RMOV.Import	WITH   XfImpNac
					replace C_RMOV.ImpUsa	WITH   XfImpUsa
					UltTecla = Enter
				ENDIF
				IF SEEK(XsNroMes+XsCodOpe+XsNroDoc,"DPRO")
					XdFchVto = DPRO.FchVto
					IF Td40FchVto#Td40FchRef AND !EMPTY(Td40FchVto) ;
					  AND XdFchVto#Td40FchVto AND XsCodOpe#[040] ;
					  AND XsCodCta=[40]
						XdFchVto = Td40FchVto
						XdFchPed = XdFchVto	
					ENDIF		
					XiCodMon = DPRO.CodMon
					XfImport = DPRO.Import
					XsNroRef = DPRO.NroDoc
					XdFchDoc = DPRO.FchDoc
					XsNroRuc = DPRO.RucAux
					XsCodDoc = DPRO.CodDoc
				ENDIF
		ENDCASE
		replace C_RMOV.NroDoc   WITH  XsNroDoc	
	CASE i = 'NRODOC' .AND. CTAS.PidDoc # [S]
		XsNroDoc = SPACE(LEN(C_RMOV.NroDoc))
		
	CASE i = 'TIPREF' 	 
		LlFound= SEEK(PADR('SN',LEN(TABL.Tabla))+XsTipRef,'TABL','TABL01')
		IF !LlFound  && AND !EMPTY(XsCodDoc)
			GsMsgErr = 'Codigo de documento de referencia inválido'
	        =MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN LlFound
		ENDIF
		REPLACE C_Rmov.DesRef WITH TABL.NomBre
		REPLACE C_RMOV.TipRef WITH XsTipRef
	CASE i = 'NROREF' 
		IF CTAS.PidGlo = [S]
			REPLACE C_RMOV.NroRef WITH XsNroRef
		ELSE
			XsNroRef = SPACE(LEN(C_RMOV.NroRef))
		ENDIF
	CASE i = 'FCHREF'
		IF CTAS.PidGlo = [S]
			REPLACE C_RMOV.FchRef WITH XdFchRef
		ELSE
			XdFchRef = {  ,  ,    }           
		ENDIF
	CASE i = 'FCHDTR'
		REPLACE C_RMOV.FchDtr WITH XdFchDtr
	CASE i = 'NRODTR'
		REPLACE C_RMOV.NroDtr WITH XsNroDtr
	CASE i = 'FCHVTO'
		IF CTAS.PidDoc="S"
		ELSE
			XdFchVto = {  ,  ,    }           
		ENDIF
	CASE i = 'TPOMOV'
		IF !INLIST(XcTpoMov,'D','H')
			GsMsgErr = 'Tipo de movimiento invalido'
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ENDIF
	CASE i = 'CODMON' .AND. OPER.CodMon = 4
		IF XiCodMon = 1
			XfTpoCmb = VMOV.TPOCMB
		ENDIF
		IF LefT(XsCodcta,2)$[10,12,14,16,28,38,41,42,46,47]
			DO SALDO
		ENDIF
	CASE INLIST(i,'MULTIPLE') AND OPER.CodMon = 4
		IF XiCodMon = 2
			XfImpNac = c_rmov.Import  && Equivale al @say get que pedia el valor XfImpnac
			IF XfImpNac < 0
				GsMsgErr = 'Importe invalido'
				=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
				UltTecla = 0
				RETURN .F.	
			ENDIF	
		ELSE
			XfImpUsa =  c_rmov.ImpUsa  && Equivale al @say get que pedia el valor XfImpUsa
			IF XfImpUsa < 0
				GsMsgErr = 'Importe invalido'
				=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
				UltTecla = 0
				RETURN .F.	
			ENDIF	
		ENDIF
		IF XfImpUsa=0
			
		ELSE
			XfTpoCmb = ROUND(XfImpNac/XfImpUsa,4)	
			replace c_rmov.TpoCmb WITH  XfTpoCmb
		ENDIF
		
	CASE INLIST(i,'IMPORT','IMPUSA')
		IF XfImport < 0
			GsMsgErr = 'Importe invalido'
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ENDIF	
		IF XiCodMon=1
			XfImpNac    = XfImport
*!*				XfImpUsa    = IIF(VMOV.TpoCmb>0,round(XfImport/VMOV.TpoCmb,2),0)
			XfImpUsa    = IIF(XfTpoCmb>0,round(XfImport/XfTpoCmb,2),0)
		ELSE
			XfImpUsa    = XfImport
*!*				XfImpNac    = round(XfImport*VMOV.TpoCmb,2)
			XfImpNac    = round(XfImport*XfTpoCmb,2)			
		ENDIF
		replace c_rmov.Import WITH XfImpNac
		replace c_rmov.ImpUsa WITH XfImpUsa
		
	CASE INLIST(I,'SUNAT')
		IF C_rmov.tip_Afe_RC='A' OR C_rmov.tip_Afe_RV='A' OR C_rmov.tip_Afe_RT='A'   && VETT 2010-07-05
			DO dat_sunat	
		ENDIF

	CASE i = '91'
	CASE i = '12' .AND. CTAS.PidGlo = "S"    && Documento de referencia
	CASE I = '13'
	CASE i = '14' .AND. XsCodAux="09990"
ENDCASE
SELECT RMOV
RETURN .t.

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbborr
***> Enviar mensaje de estado   WITH 10
LsKeyRegAct=C_RMOV.NroMes+C_RMOV.CodOPe+C_RMOV.NroAst+STR(C_RMOV.NroItm,5)
LnReturn=GoSvrCbd.LineaActiva('RMOV',LsKeyRegAct,C_RMOV.NroReg)
ULTTECLA = F10
LsChkCta=TRIM(RMOV.ChkCta)
DO BORRLIN
XiNroItm = NroItm
REPLACE VMOV.NroItm  WITH VMOV.NroItm-1
SKIP
DO WHILE ! EOF() .AND. &RegVal  AND RMOV.ChkCta==LsChkCta  && .AND. EliItm = "*"
	DO BORRLIN
	REPLACE VMOV.NroItm  WITH VMOV.NroItm-1
	SKIP
ENDDO
DO RenumItms WITH XiNroItm
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recalculo"
RETURN

************************************************************************ FIN *
PROCEDURE BORRLIN
*****************
SELECT RMOV
IF ! F1_RLock(5)
	UltTecla = K_esc
ENDIF
IF SEEK(RMOV.CodAux+[P]+RMOV.NroDoc,"DPRO")
	IF RLOCK("DPRO")
		REPLACE DPRO.NroAst WITH []
		REPLACE DPRO.FchAst WITH {  ,  ,    }        
		REPLACE DPRO.FlgEst WITH [R]   && Recepcionado
		UNLOCK IN "DPRO"
	ENDIF
ENDIF
SELE RMOV
DELETE
UNLOCK
IF ! XsCodOpe = "9"
	DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
ELSE
	DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
ENDIF
REPLACE VMOV.ChkCta  WITH VMOV.ChkCta-VAL(TRIM(RMOV.CodCta))
DO CalImp
IF RMOV.TpoMov = 'D'
	REPLACE VMOV.DbeNac  WITH VMOV.DbeNac-nImpNac
	REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa-nImpUsa
ELSE
	REPLACE VMOV.HbeNac  WITH VMOV.HbeNac-nImpNac
	REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa-nImpUsa
ENDIF
if inlist(xscodope,[065],[070],[072])
	SELE DRMOV
	llave = [SUNAT]+xsnromes+xscodope+xsnroast+xscodcta1+xstipdoc1+xsnroref1
	seek llave
	if found()
		do registro
		delete
		unlock
	endif
	SELECT RMOV
endif
RETURN

************************************************************************ FIN *
* Renumerar los items
******************************************************************************
PROCEDURE RenumItms
PARAMETERS T_Itms
DO WHILE &RegVal .AND. ! EOF()
	IF RLOCK()
		REPLACE NroItm   WITH T_Itms
	ENDIF
	UNLOCK
	SKIP
	T_Itms = T_Itms + 1
ENDDO
RETURN

************************************************************************ FIN *
* Objeto : Verificar si debe generar cuentas autom ticas
******************************************************************************
PROCEDURE MovbVeri
PARAMETERS PsKeyRegAct,PnNroReg,PsAn1Cta,PsCc1Cta
IF !VARTYPE(PsKeyRegAct)=='C'
	=MESSAGEBOX('Imposible actualizar detalle de registro ')
	RETURN AST_DETALLE_NO_GRABO_PARM
ENDIF
IF !VARTYPE(PnNroReg)=='N'
	PnNroReg = 0
ENDIF
*** Debo posicionarme en el registro a grabar 
LnReturn=GoSvrCbd.LineaActiva('RMOV',PsKeyRegAct,PnNroReg)
IF LnReturn<0
	=MESSAGEBOX('No se puede actualizar',16)
	RETURN -1
ENDIF
LlCreaDeta=IIF(LnReturn=1,.f.,.t.)
**** Grabando la linea activa ****
XcEliItm = " "
IF TYPE("YcEliItm")= "C"
	XcEliItm=YcEliItm
ENDIF
** VETT  21/07/2011 05:57 PM : Total o Base imponible 
*!*	SET STEP ON 
=SEEK(XsCodCta,"CTAS")

LlAfe_REG_CMP_VTA_RET = (CTAS.TIP_AFE_RC='A') OR (CTAS.TIP_AFE_RV='A') OR (CTAS.TIP_AFE_RT='A')
LlAfe_REG_C_V_R_TOT = (CTAS.TIP_AFE_RC='AT') OR (CTAS.TIP_AFE_RV='AT') OR (CTAS.TIP_AFE_RT='AT')
** VETT  07/02/2014 04:49 PM : Provisiones Anticipos que no generan cuenta automatica 6x,9x,79
LlAfe_REG_CMP_PROV_ANT = (CTAS.TIP_AFE_RC='P') OR (CTAS.TIP_AFE_RV='P') OR (CTAS.TIP_AFE_RT='P')
** VETT  07/02/2014 04:50 PM : Provisiones Anticipos que utiliza cuenta auxiliar para generar contra cuenta automatica 6x o 9x
LlAfe_REG_CMP_AUT_AUX = (CTAS.TIP_AFE_RC='X') OR (CTAS.TIP_AFE_RV='X') OR (CTAS.TIP_AFE_RT='X')
STORE 0 TO  XfIGV_TOT, XfBase_TOT,XfTotal_TOT
IF LlAfe_REG_C_V_R_TOT && Tomamos el importe como total incluido el impuesto (IGV o RENTA 3era ) 
	XfTotal_TOT  = XfImport
	XfIGV_TOT    = ROUND(XfImport*GoSvrCbd.XfPorIgv/(100+GoSvrCbd.XfPorIgv),2)
	XfBase_TOT  = ROUND(IIF(GoSvrCbd.XfPorIgv <>0,XfImport/(1+GoSvrCbd.XfPorIgv/100),0) ,2)
	XfImport       = ROUND(IIF(GoSvrCbd.XfPorIgv <>0,XfImport/(1+GoSvrCbd.XfPorIgv/100),0) ,2)
	XfImpNac     = ROUND(IIF(GoSvrCbd.XfPorIgv <>0,XfImpNac/(1+GoSvrCbd.XfPorIgv/100),0) ,2)
	XfImpUsa     = ROUND(IIF(GoSvrCbd.XfPorIgv <>0,XfImpUsa/(1+GoSvrCbd.XfPorIgv/100),0) ,2)
	XsChkCta = 'T'+SUBSTR(XsChkCta,2)
ENDIF
XsAn1Cta=PsAn1Cta
XsCc1Cta=PsCc1Cta
=MOVbGrab(LlCreaDeta)
RegAct = RECNO('RMOV')
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
LsChkCta		=	TRIM(RMOV.ChkCta)
LcTpoMov_ORI	=	RMOV.TpoMov
LsCodCta_ORI	=	RMOV.CodCta
XfImpNac_ORI	=   RMOV.Import
XfImpUsa_ORI	=   RMOV.ImpUsa
XfImport_ORI	=   IIF(RMOV.CodMon=1,RMOV.Import,RMOV.ImpUsa)
LLCtaDrv=.F.

IF CTAS.GenAut <> "S" 
	IF ! LlCreaDeta
		*** anulando cuentas autom ticas anteriores ***
		SELECT RMOV
		SKIP 
		Listar = .f.
		XinroItm = NroItm
		DO WHILE ! EOF() .AND. &RegVal  AND RMOV.ChkCta==LsChkCta && .AND. EliItm = "*"
			Listar   = .T.
			Refresco = .T.
			DO BORRLIN
			REPLACE VMOV.NroItm  WITH VMOV.NroItm-1
			SELECT RMOV
			SKIP
		ENDDO
		IF Listar
			DO RenumItms WITH XiNroItm
		ELSE
			GOTO RegAct
			XinroItm = NroItm  && VETT 2009-06-04
		ENDIF
	ENDIF
	RETURN
ENDIF

IF GlInterface 
	RETURN 1
ENDIF
XcEliItm = "*"
TsClfAux = []
TsCodAux = []
IF EMPTY(PsAn1Cta)
	TsAn1Cta = CTAS.An1Cta
ELSE
	TsAn1Cta = PsAn1Cta
ENDIF
IF EMPTY(PsCC1Cta)
	TsCC1Cta = CTAS.CC1Cta
ELSE
	TsCC1Cta = PsCC1Cta
ENDIF
XsAn1Cta = ''
XsCC1Cta = ''
*** ATENCION: EL Codigo siguiente sera redefinido como un componente de negocio, por ahora nos valdremos
*** de un case para usar el harcode que nos permita identificar claramente los casos que se dan en las empresas.
*** VETT : 18/10/2002
*!*	SET STEP ON 
*** VETT : 04/07/2005
IF LlAfe_REG_CMP_PROV_ANT 
ELSE 

	LsCtaCto	=	GoCfgcbd.GenAut_costos
	IF INLIST(XsCodCta,&LsCtaCto)    && Cuentas de costos
		IF EMPTY(TsAn1Cta) AND GoCfgcbd.g_An1Cta='2'	&& Auxiliar
			TsClfAux = ''
			TsCodAux = ''
			TsAn1Cta = PADR(RMOV.CodAux,LEN(CTAS.CodCta))
		ENDIF

		IF EMPTY(TsCc1Cta) AND GoCfgcbd.g_Cc1Cta='5'	&& Valor Fijo
			TsCc1Cta = PADR(gocfgcbd.cc1cta,LEN(CTAS.CodCta))
		ENDIF
	ENDIF
	LsCtaExi	=	GoCfgcbd.GenAut_Existen
	IF INLIST(XsCodCta,&LsCtaExi)   && Cuentas de Existencias
		IF EMPTY(TsAn1Cta) AND GoCfgcbd.g_An2Cta='2'	&& Auxiliar
			TsClfAux = ''
			TsCodAux = ''
			TsAn1Cta = PADR(RMOV.CodAux,LEN(CTAS.CodCta))	
		ENDIF

		IF EMPTY(TsCc1Cta) AND GoCfgcbd.g_Cc2Cta='5'	&& Valor Fijo
			TsCc1Cta = PADR(gocfgcbd.cc2cta,LEN(CTAS.CodCta))
		ENDIF
	ENDIF
	*** FIN: VETT 04/07/2005

	DO CASE
		*** CASO 1 : La cuentas automaticas no estan predefinidas en el maestro de cuentas
		***   Con regla para generar la contrcuenta
		CASE EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)  AND !(ctas.CodCta>='60' AND ctas.CodCta<='99' AND CTAS.TpoCta=3) && AND !LlAfe_REG_CMP_VTA_RET
			*** Variante 1 : Utiliza la cuenta automatica para acumular otro auxiliar: EJEM; el tipo de gasto
			TsClfAux = GsClfTgt   && Tipo de gasto
			TsCodAux = CTAS.TpoGto
			TsAn1Cta = PADR(RMOV.CodAux,LEN(CTAS.CodCta))
			TsCC1Cta = CTAS.CC1Cta
			TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
			TsClfAn1 = CTAS.ClfAux
			IF VerifyVar('CTAREF','','CAMPO','AUXI')
				TsCC1Cta	=	AUXI.CtaRef
			ENDIF
			** Verificamos su existencia **
			IF ! SEEK(TsClfAn1+TsAn1Cta,"AUXI")
				GsMsgErr = "Cuenta Autom tica no existe o esta en blanco ["+TsAn1Cta+"] generado por ["+XsCodCta+"]. Actualizaci¢n queda pendiente, verifique el Maestro de Cuentas Auxiliares"
				=MESSAGEBOX(GsMsgErr,16,'Atención')
				RETURN 2
			ENDIF
			*** FIN: VETT 22/05/2009
		*** CASO 2 : La cuenta automatica no esta definida pero la contracuenta si.
		CASE EMPTY(TsAn1Cta) AND !EMPTY(TsCC1Cta) AND !(ctas.CodCta>='60' AND ctas.CodCta<='99' AND CTAS.TpoCta=3)
			*** Variante 1: La cuenta automatica es en base al centro de costo 
			*** Centro de costo pertenece a una tabla
			IF CTAS.PidCco="S" AND EMPTY(CTAS.AN1CTA)
				TsAn1Cta = ALLT(XsCodCCo) + SUBS(CTAS.CodCta,2,2) + RIGHT(ALLT(CTAS.CodCta),1)
				TsCC1Cta = IIF(EMPTY(CTAS.CC1Cta),gocfgcbd.cc1cta,CTAS.CC1Cta)
			ENDIF
			*** Variante 2: La cuenta automatica es segun el auxiliar de la cuenta origen
			*** Centro de costo pertenece a una tabla

			IF ! SEEK(TsAn1Cta,"ctas")
				=SEEK(RMOV.COdCta,'CTAS')
				IF CTAS.ClfAux=RMOV.ClfAux		&& vett 18/10/2002
					TsAn1Cta = PADR(RMOV.CodAux,LEN(CTAS.COdCta))
				ENDIF
				IF ! SEEK(TsAn1Cta,"ctas") AND !(ctas.CodCta>='60' AND ctas.CodCta<='99' AND CTAS.TpoCta=3)
					GsMsgErr = "Cuenta Autom tica no existe o esta en blanco ["+TsAn1Cta+"] generado por ["+XsCodCta+"]. Actualizaci¢n queda pendiente, verifique el Maestro de Cuentas"
			        =MESSAGEBOX(GsMsgErr,16,'Atención')
					RETURN 2
				ENDIF
			ENDIF
			*** FIN: VETT 22/05/2009
	ENDCASE
	*** Direccionamos el auxiliar de las cuenta automatica generada por compra de existencias 60 vs clase 2
	IF !EMPTY(TsAn1Cta)
		IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
			IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
				TsClfAux = XSCLFAUX
				TsCodAux = XSCODAUX
			ENDIF
		ENDIF
		IF ! SEEK(TsAn1Cta,"CTAS") AND !(ctas.CodCta>='60' AND ctas.CodCta<='99' AND CTAS.TpoCta=3)
			GsMsgErr = "Cuenta Autom tica no existe o esta en blanco ["+TsAn1Cta+"] generado por ["+XsCodCta+"]. Actualizaci¢n queda pendiente, verifique el Maestro de Cuentas"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN
		else
			IF CTAS.CodCta==TsAn1Cta and ctas.mayaux="S"
				IF CTAS.ClfAux=XsClfAux	
					TsClfAux = XSCLFAUX
					TsCodAux = XSCODAUX
				endif
			endif
		endif	   
	ENDIF
	IF !EMPTY(TsCc1Cta)   
		IF ! SEEK(TsCC1Cta,"CTAS") AND !(ctas.CodCta>='60' AND ctas.CodCta<='99' AND CTAS.TpoCta=3)
			GsMsgErr = "Cuenta Autom tica no existe o esta en blanco ["+TsCc1Cta+"] generado por ["+XsCodCta+"]. Actualizaci¢n queda pendiente, verifique el Maestro de Cuentas"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN 2
		ENDIF
	ENDIF
	*** FIN: VETT 22/05/2009
	*****
ENDIF

IF !EMPTY(TsAn1Cta) 
	DO CompBrows WITH .F.
	SKIP
	LlCrearDeta = .T.
	IF RMOV.ChkCta==LsChkCta  AND CodCta=TsAn1Cta .AND. &RegVal
		LlCrearDeta  = .F.
	ENDIF
	** Grabando la primera cuenta autom tica **
	IF LlCrearDeta 
		XiNroItm = XiNroItm + 1
	ELSE
		XiNroItm = NroItm
	ENDIF
	IF LlCrearDeta  .AND. NroItm <= XiNroitm
		DO  RenumItms WITH XiNroItm + 1
	ENDIF
	XsCodCta = TsAn1Cta
	XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
	XsClfAux = TsClfAux
	XsCodAux = TsCodAux
	=MOVbGrab(LlCrearDeta)
ENDIF
	
IF !EMPTY(TsCc1Cta)
	DO CompBrows WITH LlCrearDeta 
	SKIP
	LlCrearDeta  = .T.
	IF RMOV.ChkCta==LsChkCta AND CodCta=TsCc1Cta .AND. &RegVal
		LlCrearDeta  = .F.
	ENDIF
	** Grabando la segunda cuenta autom tica **
	IF LlCrearDeta 
		XiNroItm = XiNroItm + 1
	ELSE
		XiNroItm = NroItm
	ENDIF
	IF LlCrearDeta  .AND. NroItm <= XiNroitm
		DO  RenumItms WITH XiNroItm + 1
	ENDIF
	XsCodCta = TsCC1Cta
	XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
	XsClfAux = SPACE(LEN(RMOV.ClfAux))
	XsCodAux = SPACE(LEN(RMOV.CodAux))
	=MOVbGrab(LlCrearDeta)
ENDIF

*** AQUI COMIENZA OTRA CHANFAINITA VETT 2007-07-25 ASI QUE MEJOR LO VOLVEMOS UNA RUTINA
IF GlRegenerAuto
	RETURN 
ENDIF


SELECT CTAS
LlHayAn2CtaME = VARTYPE(An2CtaME)='C'
SELECT RMOV
=SEEK(LsCodCta_ORI,'CTAS')
DO CASE
	CASE CTAS.TIP_AFE_RC='A'
		XsCodCta=LsCodCta_ORI
		XcTpoMov=LcTpoMov_ORI		
		TsAn1Cta=CTAS.AN2CTA
		TsCC1Cta=CTAS.CC2CTA
		TsAn2CtaME = IIF(LlHayAn2CtaME,CTAS.AN2CTAME,'')
		LlHayAn2CtaME = IIF(EMPTY(TsAn2CtaME),.F.,.T.)
		IF ! SEEK(TsAn1Cta,"CTAS")
			GsMsgErr = "Cuenta " + TsAn1Cta+" no existe. Actualizaci¢n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN
		ENDIF
		IF ! SEEK(TsCC1Cta,"CTAS")
			GsMsgErr = "Cuenta " + TsCC1Cta+" no existe. Actualizaci¢n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN 2
		ENDIF
		
		XsCodCta = TsCC1Cta
		XcEliItm = ''
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = SPACE(LEN(RMOV.ClfAux))
		XsCodAux = SPACE(LEN(RMOV.CodAux))
		IF LlAfe_REG_C_V_R_TOT 
			XfImport = XfIGV_TOT
			IF XiCodMon = 1
				XfImpNac = XfImport
				XfImpUsa = IIF(XfTpoCmb=0,0,round(XfImport/XfTpoCmb,2))
			ELSE
				XfImpUsa  = XfImport
				XfImpNac  = ROUND(XfImport*XfTpoCmb,2)
			ENDIF	
		ELSE
			XfImport = ROUND(XfImport_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
			XfImpNac = ROUND(XfImpNac_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
			XfImpUsa = ROUND(XfImpUsa_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		ENDIF
		** Grabando la TsCC1Cta=CTAS.CC2CTA     **
		IF !INLIST(XcAfecto,'N','I')  && VETT 2010-07-06 
			SKIP
			LlCrearDeta  = .T.
			IF RMOV.ChkCta==LsChkCta AND CodCta=TsCC1Cta  AND &RegVal
				LlCrearDeta  = .F.
			ENDIF
			
			IF LlCrearDeta 
				XiNroItm = XiNroItm + 1
			ELSE
				XiNroItm = NroItm
			ENDIF
			IF LlCrearDeta  .AND. NroItm <= XiNroitm
				DO  RenumItms WITH XiNroItm + 1
			ENDIF
			=MOVbGrab(LlCrearDeta)
		ENDIF
		** Grabando la TsAn1Cta=CTAS.AN2CTA **
		SKIP
		LlCrearDeta = .T.
		IF RMOV.ChkCta==LsChkCta  AND CodCta=TsAn1Cta  AND  &RegVal
			LlCrearDeta  = .F.
		ENDIF
		IF LlCrearDeta 
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsAn1Cta
		=SEEK(XsCodCta,'CTAS')
		IF XiCodMon=1
			LsforMon='CTAS.CODMON<>0' 
		ELSE
			LsforMon='.T.' 			
		ENDIF	

		IF CTAS.PidAux='S'	AND CTAS.ClfAux=GsClfPro AND XiCodMon<>CTAS.CodMon AND EVALUATE(LsForMon) 
			IF !LlHayAn2CtaME
				LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
				LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
				LsWhere = "LEFT('"+XsCodCta+"',3)"
				LoDatAdm.gencursor('c_ctaCmp','cbdmctas','CTAS01','','',"pidaux='S' AND codmon>1 AND CodCta="+LsWhere)
				IF _TALLy>0
					TsAn1Cta = c_CtaCmp.CodCta
					XsCodCta = TsAn1Cta
				ENDIF
				USE IN c_CtaCmp
				RELEASE LoDatAdm
			ELSE
				XsCodCta = IIF(XiCodMon=2,TsAn2CtaME,TsAn1Cta)
			ENDIF
		ENDIF
		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux

		IF LlAfe_REG_C_V_R_TOT 
			XfImport = XfTotal_TOT
			IF XiCodMon = 1
				XfImpNac = XfImport
				XfImpUsa = IIF(XfTpoCmb=0,0,round(XfImport/XfTpoCmb,2))
			ELSE
				XfImpUsa  = XfImport
				XfImpNac  = ROUND(XfImport*XfTpoCmb,2)
			ENDIF	
		ELSE
			XfImport = ROUND(XfImport_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
			XfImpNac = ROUND(XfImpNac_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
			XfImpUsa = ROUND(XfImpUsa_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
		ENDIF
		XcEliItm = ''  && Ojito Ojito  VETT 2004/02/13
		IF VARTYPE(oSn2)='O'
			XsClfAux = oSn2.ClfAux
			XsCodAux = oSn2.NroRuc
			XdFchVto = oSn2.FchVto
			XdFchDoc = oSn2.FchDoc
		ENDIF	
		IF VARTYPE(oSn2)='O'			
			XsTipDoc = oSn.TipDoc
			XsCodDoc = oSn.TipDoc
			XsNroDoc = oSn2.NroDoc
			XsNroDtr = oSn2.NroDtr  && para las detracciones MAAV
			XdFchDtr = oSn2.Fchdtr  && para las detracciones MAAV
			XsTipRef = oSn2.TipRef
			XsNroRef = oSn2.NroRef
			XdFchRef = oSn2.FchRef
			XsTipOri1 = oSn2.TipRef && oSn.TipOri
			XsNumOri1 = oSn2.NroRef && oSn.NumOri
		ENDIF	
		=MOVbGrab(LlCrearDeta)
		
	CASE CTAS.TIP_AFE_RV='A'

		XsCodCta=LsCodCta_ORI
		XcTpoMov=LcTpoMov_ORI		
		TsAn1Cta=CTAS.AN2CTA
		TsCC1Cta=CTAS.CC2CTA
		TsAn2CtaME = IIF(LlHayAn2CtaME,CTAS.AN2CTAME,'')
		LlHayAn2CtaME = IIF(EMPTY(TsAn2CtaME),.F.,.T.)
		IF ! SEEK(TsAn1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN
		ENDIF
		IF ! SEEK(TsCC1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN 2
		ENDIF
		XsCodCta = TsCC1Cta
		XcEliItm = ''
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = SPACE(LEN(RMOV.ClfAux))
		XsCodAux = SPACE(LEN(RMOV.CodAux))
		IF LlAfe_REG_C_V_R_TOT 
			XfImport = XfIGV_TOT
			IF XiCodMon = 1
				XfImpNac = XfImport
				XfImpUsa = IIF(XfTpoCmb=0,0,round(XfImport/XfTpoCmb,2))
			ELSE
				XfImpUsa  = XfImport
				XfImpNac  = ROUND(XfImport*XfTpoCmb,2)
			ENDIF	
		ELSE
			XfImport = ROUND(XfImport_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
			XfImpNac = ROUND(XfImpNac_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
			XfImpUsa = ROUND(XfImpUsa_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		ENDIF
		** Grabando la TsCC1Cta=CTAS.CC2CTA
		IF !INLIST(XcAfecto,'N','I')	&& VETT 2010-07-06
			SKIP
			LlCrearDeta  = .T.
			IF RMOV.ChkCta==LsChkCta  AND CodCta=TsCc1Cta  AND  &RegVal
				LlCrearDeta  = .F.
			ENDIF
			IF LlCrearDeta 
				XiNroItm = XiNroItm + 1
			ELSE
				XiNroItm = NroItm
			ENDIF
			IF LlCrearDeta  .AND. NroItm <= XiNroitm
				DO  RenumItms WITH XiNroItm + 1
			ENDIF
			=MOVbGrab(LlCrearDeta)
		ENDIF
		** Grabando la TsAn1Cta=CTAS.AN2CTA **
		SKIP
		LlCrearDeta = .T.
		IF RMOV.ChkCta==LsChkCta  AND  CodCta=TsAn1Cta AND &RegVal
			LlCrearDeta  = .F.
		ENDIF
		IF LlCrearDeta 
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsAn1Cta
		=SEEK(XsCodCta,'CTAS')
		IF XiCodMon=1
			LsforMon='CTAS.CODMON<>0' 
		ELSE
			LsforMon='.T.' 			
		ENDIF	

		IF CTAS.PidAux='S'	AND CTAS.ClfAux=GsClfPro AND XiCodMon<>CTAS.CodMon AND EVALUATE(LsForMon) 
			IF !LlHayAn2CtaME
				LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
				LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
				LsWhere = "LEFT('"+XsCodCta+"',3)"
				LoDatAdm.gencursor('c_ctaCmp','cbdmctas','CTAS01','','',"pidaux='S' AND codmon>1 AND CodCta="+LsWhere)
				IF _TALLy>0
					TsAn1Cta = c_CtaCmp.CodCta
					XsCodCta = TsAn1Cta
				ENDIF
				USE IN c_CtaCmp
				RELEASE LoDatAdm
			ELSE
				XsCodCta = IIF(XiCodMon=2,TsAn2CtaME,TsAn1Cta)
			ENDIF
		ENDIF

		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux
		IF LlAfe_REG_C_V_R_TOT 
			XfImport = XfTotal_TOT
			IF XiCodMon = 1
				XfImpNac = XfImport
				XfImpUsa = IIF(XfTpoCmb=0,0,round(XfImport/XfTpoCmb,2))
			ELSE
				XfImpUsa  = XfImport
				XfImpNac  = ROUND(XfImport*XfTpoCmb,2)
			ENDIF	
		ELSE
			XfImport = ROUND(XfImport_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
			XfImpNac = ROUND(XfImpNac_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
			XfImpUsa = ROUND(XfImpUsa_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
		ENDIF
		XcEliItm = ''   && Ojito Ojito  VETT 2004/02/13
		IF VARTYPE(oSn2)='O'
			XsClfAux = oSn2.ClfAux
			XsCodAux = oSn2.NroRuc
			XdFchVto = oSn2.FchVto
			XdFchDoc = oSn2.FchDoc
		ENDIF	
		IF VARTYPE(oSn2)='O'			
			XsTipDoc = oSn.TipDoc
			XsCodDoc = oSn.TipDoc
			XsNroDoc = oSn2.NroDoc
			XsNroDtr = oSn2.NroDtr  && para las detracciones MAAV
			XdFchDtr = oSn2.Fchdtr  && para las detracciones MAAV
			XsTipRef = oSn2.TipRef
			XsNroRef = oSn2.NroRef
			XdFchRef = oSn2.FchRef
			XsTipOri1 = oSn2.TipRef && oSn.TipOri
			XsNumOri1 = oSn2.NroRef && oSn.NumOri
		ENDIF	
		=MOVbGrab(LlCrearDeta)
	****	
		
	CASE CTAS.TIP_AFE_RT='A'	&& VETT 2010-07-05 

		XsCodCta=LsCodCta_ORI
		XcTpoMov=LcTpoMov_ORI		
		TsAn1Cta=CTAS.AN2CTA
		TsCC1Cta=CTAS.CC2CTA
		TsAn2CtaME = IIF(LlHayAn2CtaME,CTAS.AN2CTAME,'')
		LlHayAn2CtaME = IIF(EMPTY(TsAn2CtaME),.F.,.T.)
		IF ! SEEK(TsAn1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN
		ENDIF
		IF ! SEEK(TsCC1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atención')
			RETURN 2
		ENDIF
		
		XsCodCta = TsCC1Cta
		XcEliItm = ''
		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = SPACE(LEN(RMOV.ClfAux))
		XsCodAux = SPACE(LEN(RMOV.CodAux))
		** % Retencion de Renta de 4ta Categoria **
		
		LfPorRet = XFPorRet4ta  && Porcentaje de retencion 4ta categoria    && 10   ** VETT  02/05/2017 09:49 AM : Segun configuracion global ventas
		** 
		XfImport   = ROUND(XfImport_ORI * IIF(INLIST(XcAfecto,'N','I'),0,LfPorRet/100),2) 
		XfImpNac = ROUND(XfImpNac_ORI * IIF(INLIST(XcAfecto,'N','I'),0,LfPorRet/100),2) 
		XfImpUsa = ROUND(XfImpUsa_ORI * IIF(INLIST(XcAfecto,'N','I'),0,LfPorRet/100),2) 
		
		** Grabando la TsCC1Cta=CTAS.CC2CTA **
		IF !INLIST(XcAfecto,'N','I')
			SKIP
			LlCrearDeta  = .T.
			IF RMOV.ChkCta==LsChkCta  AND CodCta=TsCc1Cta  AND  &RegVal
				LlCrearDeta  = .F.
			ENDIF
			IF LlCrearDeta 
				XiNroItm = XiNroItm + 1
			ELSE
				XiNroItm = NroItm
			ENDIF
			IF LlCrearDeta  .AND. NroItm <= XiNroitm
				DO  RenumItms WITH XiNroItm + 1
			ENDIF
			=MOVbGrab(LlCrearDeta)
		ENDIF
		** Grabando la  TsAn1Cta=CTAS.AN2CTA
		SKIP
		LlCrearDeta = .T.
		IF RMOV.ChkCta==LsChkCta  AND CodCta=TsAn1Cta  AND  &RegVal
			LlCrearDeta  = .F.
		ENDIF
		IF LlCrearDeta 
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsAn1Cta
		=SEEK(XsCodCta,'CTAS')
		IF XiCodMon=1
			LsforMon='CTAS.CODMON<>0' 
		ELSE
			LsforMon='.T.' 			
		ENDIF	
		 
			** VETT  26/06/2012 12:05 PM : Veamos como va con recibo por honorarios sin verificar clasificacion auxiliar CTAS.ClfAux 
*!*			IF CTAS.PidAux='S'	AND CTAS.ClfAux=GsClfPro AND XiCodMon<>CTAS.CodMon AND EVALUATE(LsForMon) 
		IF CTAS.PidAux='S'	 AND XiCodMon<>CTAS.CodMon AND EVALUATE(LsForMon) 
			IF !LlHayAn2CtaME
				LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
				LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
				LsWhere = "LEFT('"+XsCodCta+"',3)"
				LoDatAdm.gencursor('c_ctaCmp','cbdmctas','CTAS01','','',"pidaux='S' AND codmon>1 AND CodCta="+LsWhere)
				IF _TALLy>0
					TsAn1Cta = c_CtaCmp.CodCta
					XsCodCta = TsAn1Cta
				ENDIF
				USE IN c_CtaCmp
				RELEASE LoDatAdm
			ELSE
				XsCodCta = IIF(XiCodMon=2,TsAn2CtaME,TsAn1Cta)
			ENDIF
		ENDIF
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux
		** % Retencion de Renta de 4ta Categoria **
		LfPorRet = XFPorRet4ta  && Porcentaje de retencion 4ta categoria    && 10   ** VETT  02/05/2017 09:49 AM : Segun configuracion global ventas
		** 
		XfImport = ROUND(XfImport_ORI * (1 - IIF(INLIST(XcAfecto,'N','I'),0,LfPorRet/100)),2) 
		XfImpNac = ROUND(XfImpNac_ORI * (1 - IIF(INLIST(XcAfecto,'N','I'),0,LfPorRet/100)),2) 
		XfImpUsa = ROUND(XfImpUsa_ORI * (1 - IIF(INLIST(XcAfecto,'N','I'),0,LfPorRet/100)),2) 
		XcEliItm = ''  
		IF VARTYPE(oSn2)='O'
			XsClfAux = oSn2.ClfAux
			XsCodAux = oSn2.NroRuc
			XdFchVto = oSn2.FchVto
			XdFchDoc = oSn2.FchDoc
		ENDIF	
		IF VARTYPE(oSn2)='O'			
			XsTipDoc = oSn.TipDoc
			XsCodDoc = oSn.TipDoc
			XsNroDoc = oSn2.NroDoc
			XsNroDtr = oSn2.NroDtr  && para las detracciones MAAV
			XdFchDtr = oSn2.Fchdtr  && para las detracciones MAAV
			XsTipRef = oSn2.TipRef
			XsNroRef = oSn2.NroRef
			XdFchRef = oSn2.FchRef
			XsTipOri1 = oSn2.TipRef && oSn.TipOri
			XsNumOri1 = oSn2.NroRef && oSn.NumOri
		ENDIF	
		=MOVbGrab(LlCrearDeta)
		
ENDCASE
RELEASE oSn,Osn2
RETURN 1

**********************************************************************
* Inserta Items
**********************************************************************
PROCEDURE MovInser
******************
RegAct = RECNO()
DO RenumItms WITH XiNroItm + 1
GOTO RegAct
DO MovbVeri
RETURN

************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab
PARAMETERS Crear
***> Enviar mensaje de estado   WITH 4
LLReturnOk = .F.
SELE RMOV
IF Crear
	APPEND BLANK
ENDIF && maav
IF ! F1_RLock(5)
	RETURN LLReturnOk
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
	&& Ojo esto es excluyente si mayoriza por auxiliar no lo hara por centro de costo y viceversa	
	IF CTAS.MAYAUX = "S"    
		XsCodRef = PADR(XsCodAux,LEN(RMOV.CodRef))
	ELSE 
		IF CTAS.MAYCco = "S"
			XsCodRef = PADR(XsCodCCo,LEN(RMOV.CodRef))
		ENDIF
	ENDIF
ENDIF
*SET STEP ON 
IF Crear
	REPLACE RMOV.NroMes WITH XsNroMes
	REPLACE RMOV.CodOpe WITH XsCodOpe
	REPLACE RMOV.NroAst WITH XsNroAst
	REPLACE RMOV.NroItm WITH XiNroItm
	REPLACE VMOV.NroItm WITH VMOV.NroItm + 1
	replace rmov.fchdig  with date()
	replace rmov.hordig  with time()
ELSE
	IF ! XsCodOpe = "9"
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
	ELSE
		DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , COdDiv
	ENDIF
	REPLACE VMOV.ChkCta  WITH VMOV.ChkCta-VAL(TRIM(RMOV.CodCta))
	_chktpocmb = .T.
	DO CalImp && MAAV1
	IF RMOV.TpoMov = 'D'
		REPLACE VMOV.DbeNac  WITH VMOV.DbeNac-nImpNac
		REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa-nImpUsa
	ELSE
		REPLACE VMOV.HbeNac  WITH VMOV.HbeNac-nImpNac
		REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa-nImpUsa
	ENDIF
	** Buscamos documento Provisionado
	IF SEEK(RMOV.CodAux+[P]+RMOV.NroDoc,"DPRO")
		IF RLOCK("DPRO")
			REPLACE DPRO.NroAst WITH []
			REPLACE DPRO.FchAst WITH {  ,  ,    }           
			REPLACE DPRO.FlgEst WITH [R]   && Recepcionado
			UNLOCK IN "DPRO"
		ENDIF
	ENDIF
ENDIF
REPLACE RMOV.CodDiv WITH XsCodDiv
REPLACE RMOV.EliItm WITH XcEliItm
REPLACE RMOV.FchAst WITH XdFchAst
REPLACE RMOV.CodMon WITH XiCodMon
REPLACE RMOV.TpoCmb WITH XfTpoCmb
REPLACE RMOV.FchDoc WITH XdFchAst
REPLACE RMOV.CodCta WITH XsCodCta
REPLACE RMOV.CodRef WITH XsCodRef
REPLACE RMOV.ClfAux WITH XsClfAux
REPLACE RMOV.CodAux WITH XsCodAux
REPLACE RMOV.TpoMov WITH XcTpoMov
replace RMOV.CtaPre WITH XsCtaPre
REPLACE RMOV.NroDtr WITH XsNroDtr
REPLACE RMOV.FchDtr WITH XdFchDtr
REPLACE RMOV.NumOri WITH XsNumOri1
REPLACE RMOV.TipOri WITH XsTipOri1
IF USED('CNFG2')
	SELECT CNFG2
	LOCATE FOR CodOpe=CNFG2.CodOpe
	SELECT RMOV
	IF XcEliItm=':' AND CodOpe==CNFG2.CodOpe AND EMPTY(XcAfecto)
		XcAfecto =  'A'
	ENDIF
ENDIF
replace RMOV.Afecto WITH XcAfecto
replace RMOV.CodCCo WITH XsCodCCo
IF GlInterface
	IF Oper.Siglas='RV'
		REPLACE Afecto WITH CTAS.Tip_Afe_RV
	ENDIF
	IF 	Oper.Siglas='RC'
		REPLACE Afecto WITH CTAS.Tip_Afe_RC
	ENDIF
	REPLACE RMOV.Import WITH XfImpNac
	REPLACE RMOV.ImpUsa WITH XfImpUsa
ELSE
	IF OPER.CodMon = 4
		REPLACE RMOV.Import WITH XfImpNac
		REPLACE RMOV.ImpUsa WITH XfImpUsa
	ELSE
		IF CodMon = 1
			REPLACE RMOV.Import WITH XfImport
			IF TpoCmb = 0
				REPLACE RMOV.ImpUsa WITH 0
			ELSE
				REPLACE RMOV.ImpUsa WITH round(XfImport/TpoCmb,2)
			ENDIF
		ELSE
			REPLACE RMOV.Import WITH round(XfImport*TpoCmb,2)
			REPLACE RMOV.ImpUsa WITH XfImport
		ENDIF
	ENDIF
ENDIF
REPLACE RMOV.GloDoc WITH XsGloDoc
REPLACE RMOV.CodDoc WITH XsCodDoc
REPLACE RMOV.NroDoc WITH XsNroDoc
*!*	XsTipRef	= IIF(VerifyVar('TipRef','','CAMPO','RMOV'),RMOV.TipRef,'')  && RMOV.TipRef
*!*	XdFchRef	= IIF(VerifyVar('FchRef','','CAMPO','RMOV'),RMOV.FchRef,{})  && RMOV.FchRef

REPLACE RMOV.TipRef WITH IIF(VerifyVar('TipRef','','CAMPO','RMOV'),XsTipRef,'') && XsTipRef
REPLACE RMOV.FchRef WITH IIF(VerifyVar('FchRef','','CAMPO','RMOV'),XdFchRef,{}) && XdFchRef
REPLACE RMOV.NroRef WITH XsNroRef
REPLACE RMOV.CODFIN WITH XSCODFIN
REPLACE RMOV.FchDoc WITH XdFchDoc
REPLACE RMOV.FchVto WITH XdFchVto
REPLACE RMOV.IniAux WITH XsIniAux
REPLACE RMOV.NroRuc WITH XsNroRuc
REPLACE VMOV.ChkCta  WITH VMOV.ChkCta+VAL(TRIM(XsCodCta))
IF CodCta=[10]
	REPLACE RMOV.FchPed   WITH XdFchPed
ENDIF
IF TYPE([GenDifCmb])=[L]
	IF GenDifCmb
		REPLACE RMOV.FchPed WITH RMOV.FchAst
	ENDIF
ENDIF
if empty(rmov.fchped)
	if rmov.codcta=[40]
		repla rmov.fchped with rmov.fchvto
	else
		do case
			case chkcta(rmov.codcta)
				repla rmov.fchped with rmov.fchvto
			other
				repla rmov.fchped with rmov.fchast
		endcase
	endif
endif
if rmov.tpomov = [H]
	if empty(xdfchped)     
		repla rmov.fchped with rmov.fchvto
	else
		repla rmov.fchped with xdfchped
	endif
endif        
*
if rmov.codcta=[46] .and. inlist(rmov.codope,[016],[231],[241],[030],[031]) .and. rmov.tpomov=[H]
	repla rmov.fchped with rmov.fchvto
endif
*
if !empty(rmov.fchped) AND USED('DIAF')
	repla rmov.fchped with iif(seek(dtos(rmov.fchped),[diaf]),diaf.fchven,rmov.fchped)
endif
*
replace rmov.tpoo_c with xsnivadi
*
REPLACE RMOV.TipoC  WITH XcTipoC
REPLACE RMOV.Tipdoc WITH Xstipdoc
REPLACE RMOV.An1Cta WITH XsAn1Cta
REPLACE RMOV.CC1Cta WITH XsCc1Cta
REPLACE RMOV.ChkCta WITH XsChkCta
*
IF ! XsCodOpe = "9"
	DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa , CodDiv
ELSE  && EXTRA CONTABLE
	DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa , CodDiv
ENDIF
SELECT RMOV
DO CalImp
IF RMOV.TpoMov = 'D'
	REPLACE VMOV.DbeNac  WITH VMOV.DbeNac+nImpNac
	REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa+nImpUsa
ELSE
	REPLACE VMOV.HbeNac  WITH VMOV.HbeNac+nImpNac
	REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa+nImpUsa
ENDIF
IF LEFT(RMOV.CodCta,4)=[4211] .AND. RMOV.TpoMov=[D]
	** Buscamos documento
	IF USED('DPRO')
		IF SEEK(RMOV.CodAux+[R]+RMOV.NroDoc,"DPRO") 
			IF RLOCK("DPRO")
				REPLACE DPRO.NroAst WITH XsNroAst
				REPLACE DPRO.FchAst WITH XdFchAst
				REPLACE DPRO.FlgEst WITH [P]   && Provisionado
				UNLOCK IN "DPRO"
			ENDIF
		ENDIF
	ENDIF
ENDIF
*
** ACTUALIZACION INFORMACION SUNAT
*
if inlist(xscodope,[065],[070],[072])
	sele drmov
	llave = [SUNAT]+xsnromes+xscodope+xsnroast+xscodcta1+xstipdoc1+xsnroref1
	seek llave
	if found()
		do registro
		if xstipdoc = [NO]
			delete
		else
			repla drmov.codcta   with xscodcta
			repla drmov.tipdoc   with xstipdoc
			repla drmov.nroref   with xsnroref
			repla drmov.vctori   with xsfecori
			repla drmov.impori   with xsimpori
			repla drmov.tipori   with xstipori
			repla drmov.numori   with xsnumori
			repla drmov.n_poliza with xsnumpol
			repla drmov.impnac1  with xsimpnac1
			repla drmov.impnac2  with xsimpnac2
		endif
		unlock
	else
		if !inlist(xstipdoc,[NO],[  ])
			llave = [SUNAT]+xsnromes+xscodope+xsnroast+xscodcta+xstipdoc+xsnroref
			seek llave
			if .not. found()
				append blank
			endif
			do registro
			repla drmov.modulo   with [SUNAT]
			repla drmov.nromes   with xsnromes
			repla drmov.codope   with xscodope
			repla drmov.nroast   with xsnroast
			repla drmov.codcta   with xscodcta
			repla drmov.tipdoc   with xstipdoc
			repla drmov.nroref   with xsnroref
			repla drmov.vctori   with xsfecori
			repla drmov.impori   with xsimpori
			repla drmov.tipori   with xstipori
			repla drmov.numori   with xsnumori
			repla drmov.n_poliza with xsnumpol
			repla drmov.impnac1  with xsimpnac1
			repla drmov.impnac2  with xsimpnac2
			unlock
		endif
	endif
endif
SELE RMOV
UNLOCK
LLReturnOk = .T.
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recalculo"
RETURN LLReturnOk

******************
PROCEDURE pAlmacen
******************
IF INLIST(RMOV.CodCta,[6040],[6041],[6050],[6060],[2340])
	DO ALMPIVAL WITH XsCodPrv,XfTpoCmb,XiCodMon,[FACT],XsRefPrv,XsNomPrv
ENDIF
RETURN
**********************************************************************

**********************************************************************
* Complemento del db_Brows para cuentas autom ticas
**********************************************************************
PROCEDURE CompBrows
*******************
PARAMETER INSERTA
RETURN

**********************************************************************
* Pinta Importe Totales
**********************************************************************
PROCEDURE MovPImp
******************
RETURN

********************************************************************
* CHEQUEO DE FIN DE BROWSE ===========================================
**********************************************************************
PROCEDURE MovFin
****************
&&& Ojo esto debe ser por configuracion de tabla 2003-09-08 VETT

IF ( ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) >=.01 ) .AND. ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) <=XfDif_ME ) );
  .OR.  ( ( ABS(VMOV.DbeNac-VMOV.HbeNac) >=.01 ) .AND. ( ABS(VMOV.DbeNac-VMOV.HbeNac) <=XfDif_MN ) )
	DO MOVF3
ENDIF
lDesBal = ( ABS(VMOV.HbeUsa-VMOV.DbeUsa) >XfDif_ME ) .or. ( ABS(VMOV.HbeNac-VMOV.DbeNac) >XfDif_MN )
IF lDesBal
	messageBox("Asiento Desbalanceado. Para poder salir debe cuadrar el asiento",16,'ATENCION / WARNING') 
ENDIF

IF  ! lDesBal
*	DO IMPRVOUC

ENDIF
RETURN !lDesbal


**********************************************************************
* Pantalla de Ayuda    ===============================================
**************************************************************************
PROCEDURE MovF1
***************
SAVE SCREEN
GsMsgKey = "[Esc] Retorna"
***> do lib_mtec WITH 99
@ 3,12 FILL TO 22,64 COLOR W/N
@ 2,13 TO 19,65 COLOR SCHEME 7
@  3,14 SAY  'Teclas de Selecci¢n :                              ' COLOR SCHEME 7
@  4,14 SAY  '   Cursor Arriba ....... Retroceder un Registro    ' COLOR SCHEME 7
@  5,14 SAY  '   Cursor Abajo  ....... Adelentar un Registro     ' COLOR SCHEME 7
@  6,14 SAY  '   Home          ....... Primer Registro           ' COLOR SCHEME 7
@  7,14 SAY  '   End           ....... Ultimo Registro           ' COLOR SCHEME 7
@  8,14 SAY  '   PgUp          ....... Retroceder en Bloque      ' COLOR SCHEME 7
@  9,14 SAY  '   PgDn          ....... Adelantar en Bloque       ' COLOR SCHEME 7
@ 10,14 SAY  'Teclas de Edici¢n :                                ' COLOR SCHEME 7
@ 11,14 SAY  '   Enter         ....... Modificar el Registro     ' COLOR SCHEME 7
@ 12,14 SAY  '   Del  (Ctrl G) ....... Anular el Registro        ' COLOR SCHEME 7
@ 13,14 SAY  '   Ins  (Ctrl V) ....... Insertar un  Registro     ' COLOR SCHEME 7
@ 14,14 SAY  '                                                   ' COLOR SCHEME 7
@ 15,14 SAY  '   F1            ....... Pantalla Actual de Ayuda  ' COLOR SCHEME 7
@ 16,14 SAY  '   F3            ....... Renumerar Items           ' COLOR SCHEME 7
@ 17,14 SAY  '   F5            ....... Impresi¢n del Asiento     ' COLOR SCHEME 7
@ 18,14 SAY  '   F10           ....... Terminar el Proceso       ' COLOR SCHEME 7
DO WHILE INKEY(0)<>K_esc
ENDDO
RESTORE SCREEN
RETURN

**********************************************************************
* Regenerar Acumulados ===============================================
**********************************************************************
PROCEDURE MovF3
*******************
** VETT:AUXIL a CodDiv , para respetar el codigo de divisonaria 2021/04/16 12:30:20 ** 
IF verifyvar('CODDIV','C','CAMPO','VMOV')
	IF NOT EMPTY(VMOV.CodDiv)
		TsCodDiv1  = VMOV.CodDiv
		XsCodDiv	= VMOV.COdDiv
		XsCjaDiv	= VMOV.CodDiv
	ENDIF
ENDIF
** VETT: 2021/04/16 12:30:32 ** 

T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
**** Recalculando Importes ****
T_Itms =0
Chqado =0
SELECT CNFG2
LOCATE FOR CodCfg='VTA' AND CodOpe=XsCodOpe
XsCtaTotVta= CNFG2.CtaTota
LlRegVta = FOUND() AND !EMPTY(XsCtaTotVta)
SELECT RMOV
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
	T_Itms = T_Itms + 1
	IF T_Itms <> NroItm
		Chqado =Chqado +1
	ENDIF
	IF RLOCK()
		REPLACE ChkItm   WITH T_Itms
	ENDIF
	UNLOCK
	=CalImp(GlModTpoCmb)
	IF LlRegVta AND GlModTpoCmb
		IF INLIST(CodCta,&XsCtaTotVta) AND INLIST(CodDoc,'01','03','07','08','20')
			=SEEK(Codcta,'CTAS')
			DO CASE
				CASE INLIST(CodDoc,'01','02','08') AND TpoMov='D'
					LsCcbTpoDoc = 'CARGO'
					LsCcbCodDoc=IIF(CodDoc='01','FACT',IIF(CodDoc='03','BOLE','N/D'))
				CASE INLIST(CodDoc,'07','20') AND TpoMov='H'
					LsCcbTpoDoc = 'ABONO'
				    LsCcbCodDoc=IIF(CodDoc='07','N/C',IIF(CodDoc='20','RETC',''))
				OTHERWISE 
					LsCcbTpoDoc = ''
				    LsCcbCodDoc = ''
			ENDCASE
			IF CTAS.PidAux='S'
				LsCCbNroDoc=NroDoc
				LsCcbCodCli=CodAux			
			ENDIF
			LsAsiento=NroMes+CodOpe+NroAst
			LfCcbImpNac = RMOV.Import
			LfCcbImpUsa = RMOV.ImpUsa
			LnCcbCodMon = RMOV.CodMon
			IF CodOpe='004' AND NroAst='11000027' 
*!*					SET STEP ON 
			ENDIF
			DO Regraba_Ventas WITH LsCcbTpoDoc,LsCCbCodDoc,LsCCbNroDoc,XfTpoCmb,LsAsiento,LfCcbImpNac,LfCcbImpUsa,LnCcbCodMon			
			SELECT RMOV
		ENDIF
	ENDIF
	IF TpoMov  ="D"
		T_DbeNac = T_DbeNac + nImpNac
		T_DbeUsa = T_DbeUsa + nImpUsa
	ELSE
		T_HbeNac = T_HbeNac + nImpNac
		T_HbeUsa = T_HbeUsa + nImpUsa
	ENDIF
	T_Ctas = T_Ctas + VAL(LTRIM(TRIM(CodCta)))
	SELECT RMOV
	SKIP
ENDDO
DO AJUSTE    &&  AJUSTA DESCUADRES POR DIFERENCIA CAMBIO ( VETT )
SELE VMOV
IF F1_RLock(5)
	REPLACE VMOV.ChkCta  WITH T_Ctas
	REPLACE VMOV.DbeNac  WITH T_DbeNac
	REPLACE VMOV.DbeUsa  WITH T_DbeUsa
	REPLACE VMOV.HbeNac  WITH T_HbeNac
	REPLACE VMOV.HbeUsa  WITH T_HbeUsa
	REPLACE VMOV.NroItm  WITH T_Itms
ENDIF
SELE RMOV
**** Chequeo del Nro de Items **********************
IF Chqado > 0
	TnItms = 0
	DO WHILE TnItms < T_Itms
		TnItms =0
		SEEK VCLAVE
		DO WHILE EVALUATE(RegVal) .AND. ! EOF()
			IF NroItm <> ChkItm
				IF RLOCK()
					REPLACE NroItm   WITH ChkItm
				ENDIF
				UNLOCK
			ELSE
				TnItms = TnItms + 1
			ENDIF
			SKIP
		ENDDO
	ENDDO
ENDIF
Fin  = .T.
RETURN

****************
PROCEDURE AJUSTE  && 26/01/95 VETT
****************
IF !used("CNFG")
	RETURN
ENDIF

IF !verifyvar('GsCfgAjt','C')
	LsCfgAjt = "01"
ELSE
	LsCfgAjt = PADR(GsCfgAjt,LEN(CNFG.CodCfg))
ENDIF

** VETT  12/11/2014 11:13 AM : PARCHE para grabar ajuste por redondeo con cuentas de divisionaria 2 
IF TsCodDiv1= '02'
	LsCfgAjt = '04' && Parche 
ENDIF
** VETT  12/11/2014 11:58 AM : FIN PARCHE 
SELE CNFG
SEEK LsCfgAjt  && Ajuste por redondeo
IF !FOUND()
	=MESSAGEBOX('No esta configurado registro de ajuste x dif.cmb o redondeo ['+LsCfgAjt+'] para divsionaria [' + TsCodDiv1+']',16,'¡ ATENCION !')
	RETURN 
ENDIF
XsCodCta1=CodCta1
XsCodCta2=Codcta2
XsCodaux1=CodAux1
XsCodAux2=CodAux2
XfDif_ME = Dif_ME
XfDif_MN = Dif_MN
* AJUSTA DESCUADRE POR DIFERENCIAS DE CAMBIO ENTRE  [ 0.01 , 0.05 ]
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=XfDif_ME
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=XfDif_MN

**XcEliItm    = "ø"   && Marca de grabaci¢n autom tica
YcEliItm = ":" 
XXTpoCmb    = XfTpoCmb
XfImport    = 0.0000
store 0 TO XfImpNac,XfImpUsa
If VARTYPE(TsCodDiv1)='C'
	XsCodDiv=TsCodDiv1
ENDIF

IF lDesBal1 .AND. XiCodMon = 2
	IF T_HbeUsa > T_DbeUsa
		XsCodCta    = XsCodCta1
		XsCodAux    = XsCodaux1
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = XsCodCta2
		XsCodAux    = XsCodaux2
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeUsa - T_DbeUsa,2))
	XiCodMon    = 2
	XfImpUsa    = XfImport
	XfImpNac    = 0
	XfTpoCmb    = 0
	IF XfImport<>0.00
		XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
		Crear = .T.
		=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
		IF LcTpoMov = "D"
			T_DbeUsa = T_DbeUsa + XfImport
		ELSE
			T_HbeUsa = T_HbeUsa + XfImport
		ENDIF
	ENDIF
ENDIF
IF lDesBal2 .AND. XiCodMon = 1
	IF T_HbeNac > T_DbeNac
		XsCodCta    = XsCodCta1
		XsCodAux    = XsCodaux1
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = XsCodCta2
		XsCodAux    = XsCodaux2
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeNac - T_DbeNac,2))
	XiCodMon    = 1
	XfImpUsa    = 0
	XfImpNac    = XfImport
	XfTpoCmb    = 0
	IF XfImport<>0.00
		XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
		Crear = .T.
		=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
		IF LcTpoMov = "D"
			T_DbeNac = T_DbeNac + XfImport
		ELSE
			T_HbeNac = T_HbeNac + XfImport
		ENDIF
	ENDIF
ENDIF
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=XfDif_ME
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=XfDif_MN
XfImport = 0.0000
store 0 TO XfImpNac,XfImpUsa
XfTpoCmb    = 0
IF ! lDesBal1 .AND. lDesBal2 .AND. XiCodMon = 2
	IF T_HbeNac > T_DbeNac
		XsCodCta    = XsCodCta1
		XsCodAux    = XsCodaux1
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = XsCodCta2
		XsCodAux    = XsCodaux2
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeNac - T_DbeNac,2))
	XiCodMon    = 1
	XfImpUsa    = 0
	XfImpNac    = XfImport
	XfTpoCmb    = 0
	IF XfImport<>0.00
		XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
		Crear = .T.
		=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
		IF LcTpoMov = "D"
			T_DbeNac = T_DbeNac + XfImport
		ELSE
			T_HbeNac = T_HbeNac + XfImport
		ENDIF
	ENDIF
ENDIF
IF ! lDesBal2 .AND. lDesBal1 .AND. XiCodMon = 1
	IF T_HbeUsa > T_DbeUsa
		XsCodCta    = XsCodCta1
		XsCodAux    = XsCodaux1
		XcTpoMov    = "D"
	ELSE
		XsCodCta    = XsCodCta2
		XsCodAux    = XsCodaux2
		XcTpoMov    = "H"
	ENDIF
	LcTpoMov = XcTpoMov
	XfImport    = ABS(ROUND(T_HbeUsa - T_DbeUsa,2))
	XiCodMon    = 2
	XfImpUsa    = XfImport
	XfImpNac    = 0
	XfTpoCmb    = 0
	IF XfImport<>0.00
		XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
		Crear = .T.
		=Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
		IF LcTpoMov = "D"
			T_DbeUsa = T_DbeUsa + XfImport
		ELSE
			T_HbeUsa = T_HbeUsa + XfImport
		ENDIF
	ENDIF
ENDIF
XfTpoCmb = XXTpoCmb
Listar   = .T.
Refresco = .T.
release YcEliItm
RETURN
***************
PROCEDURE SALDO
***************
SELECT RMOV
RegAct1 = RECNO()
EOF1    = EOF()
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK XsCodCta+XsCodAux+XsNroDoc
Saldo  = 0
SdoUsa = 0
DO WHILE (CodCta+CodAux+NroDoc = Llave) .AND. ! EOF()
	IF RegAct1 <> RECNO()
		Saldo  = Saldo  + IIF(TpoMov = 'D' , 1 , -1)*Import
		SdouSA = SdouSA + IIF(TpoMov = 'D' , 1 , -1)*ImpUsa
	ENDIF
	SKIP
ENDDO
SET ORDER TO RMOV01
IF ! EOF1
	GOTO RegAct1
ELSE
	GOTO BOTTOM
	IF ! EOF()
		SKIP
	ENDIF
ENDIF

@ 22,1 SAY SPACE(77)
@ 22,2 SAY [SALDO --.]                             COLOR SCHEME 7
@ 22,19 SAY "S/."                                   COLOR SCHEME 7
@ 22,23 SAY Saldo   PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
@ 22,55 SAY "US$"                                   COLOR SCHEME 7
@ 22,59 SAY SdoUsa  PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
RETURN

******************
PROCEDURE IMPRVOUC
******************
PRIVATE Largo,Ancho,Temp
SELECT VMOV
REGACT=RECNO()
_Fontsize = 8
UltTecla = 0

DO f0PRINT &&IN ADMPRINT
IF UltTecla = K_esc
	RETURN
ENDIF

Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Tit_I_CEN= []
TITULO   = ""
SUBTITULO = ""
IniImp   = _Prn3    && 16.6 cpi
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN

*!*	Largo    = 66
*!*	LinFin   = Largo - 5
Ancho    = 115
numpag  = 0
En1 =[]
En2 =[]
En3 =[]
En4 =[]


*!*	En5 = "*********** ************** *************************** ******** **************************************** *************** ***************"
*!*	En6 = "COD.                              D O C U M E N T O     CUENTA                                                                                         "
*!*	En7 = "AUXI-        N§            ***************************  CONTAB              D E S C R I P C I O N         C A R G O S      A B O N O S  "
*!*	En8 = "LIAR         REFERENCIA    Tpo   No.           VENCTO.                                                                                                 "
*!*	En9 = "*********** ************** *** ************** ******** ******** **************************************** *************** ***************"


	En5 = "*********** *************************** ******** ************************************* ************** **************"
	En6 = "COD.              D O C U M E N T O      CUENTA                                                                     "
	En7 = "AUXI-       ***************************  CONTAB              D E S C R I P C I O N      C A R G O S     A B O N O S "
	En8 = "LIAR        Tpo   No.           VENCTO.                                                                             "
	En9 = "*********** *** ************** ******** ******** ************************************* ************** **************"

	*      12345678901 123 12345678901234 12345678 12345678 1234567890123456789012345678901234567 999,999,999.99 999,999,999.99
	*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-1234567890
	*                1         2         3         4         5         6         7         8         9         0         1         2         3

IF GoCfgCbd.TIPO_CONSO=2
	En5 = En5 +  " **"
	En6 = En6 +  "   "
	En7 = En7 +  " DV"
	En8 = En8 +  "   "
	En9 = En9 +  " **"
	Ancho = 118
ENDIF

SET DEVICE TO PRINTER
PRINTJOB
	sKey = XsNroMes+XsCodOpe+XsNroAst
	=SEEK(sKey,"VMOV")
	=SEEK(VMOV.CodOpe,'OPER')
	LsNomOpe=OPER.NomOpe
	DO MovMemb
	nDbe = 0
	nHbe = 0
	SELECT RMOV
	cNroChq = []
	SEEK XsNroMes+XsCodOpe+XsNroAst
	DO WHILE  ! EOF() .AND. sKey = RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst
		IF ELIITM#'*'
			IF Prow() > (Largo - 4)
				DO MovMemb
			ENDIF
			NumLin = Prow() + 1
			@ NumLin,00  SAY CodAux
			*@ NumLin,12  SAY NroRef
			@ NumLin,12  SAY CodDoc
			@ NumLin,16  SAY NroDoc
			IF ! EMPTY(FchVto)
			*	@ NumLin,46  SAY FchVto 
				m.DesFch=TRANSF(DAY(FCHVTO),"@L ##")+TRANSF(MONTH(FCHVTO),"@L ##")+RIGHT(STR(YEAR(FCHVTO),4,0),2)	
				@ NumLin,31  SAY m.DesFch
			ENDIF
			@ NumLin,40  SAY CodCta
			=SEEK(ClfAux+CodAux,"AUXI")
			DO CASE
				CASE ! EMPTY(RMOV.Glodoc)
					LsGlodoc = LEFT(RMOV.GloDoc,40)
				CASE ! EMPTY(VMOV.NotAst)
					LsGlodoc = LEFT(VMOV.NotAst,40)
				OTHER
					LsGlodoc = LEFT(AUXI.NOMAUX,40)
			ENDCASE
			IF RMOV.CodMon <> 1
				LsImport = 'US$' + ALLTRIM(STR(ImpUsa,14,2))
				IF RIGHT(LsImport,3)=".00"
					LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
				ENDIF
				LsGloDoc = LEFT(LsGloDoc,37-LEN(LsImport))+LsImport
			ENDIF
			*@ NumLin,64  SAY LsGloDoc PICT "@S40" 
			IF _Fontsize>8
				@ NumLin,49 SAY LsGloDoc    PICT "@S37" font _Fontname,8
			ELSE
				@ NumLin,49 SAY LsGloDoc    PICT "@S37" font _Fontname,_Fontsize -1
			ENDIF

			DO CalImp
			IF TpoMov='D'
				@ NumLin,87 SAY nImpNac PICT "999,999,999.99"
				nDbe = nDbe + nImpNac
			ELSE
				@ NumLin,102 SAY nImpNac PICT "999,999,999.99"
				nHbe = nHbe + nImpNac
			ENDIF
			IF GoCfgCbd.TIPO_CONSO=2
				@ NumLin,117  SAY CodDiv 
			ENDIF
		ENDIF
		SKIP
	ENDDO
	IF Prow() > (Largo - 10)
		DO MovMemb
	ENDIF
	NumLin = PROW() + 2
	@ NumLin,70  SAY _Prn7a+"TOTALES"+_Prn7B font _FontName,_FOntSize Style 'B'  
	@ NumLin,0  SAY [ ]
	@ NumLin,87 SAY _Prn6a
	@ NumLin,87 SAY nDbe PICT "999,999,999.99" font _FontName,_FontSize style 'B'
	@ NumLin,102 SAY nHbe PICT "999,999,999.99" font _FontName,_FontSize style 'B'
	@ NumLin,Ancho-1 SAY _Prn6b
	DO MovIPie
ENDPRINTJOB
EJECT PAGE
SET DEVICE TO SCREEN

DO F0PRFIN
RETURN

*****************
PROCEDURE MovMemb
*****************
IF NumPag = 0
	IF _WINDOWS OR _MAC
	ELSE
		@ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
	ENDIF   
ENDIF
IF NumPag > 0
	NumLin = PROW() + 1
	@ NumLin,70  SAY "VAN ......"
	@ NumLin,87 SAY nDbe PICT "999,999,999.99"
	@ NumLin,102 SAY nHbe PICT "999,999,999.99"
ENDIF
NumPag = NumPag + 1
IF _WINDOWS OR _MAC
ELSE
	@ 0,0  SAY IniImp
ENDIF   
@ 1,0  SAY _Prn7a+GsNomCia+_Prn7b font _FontName,_FontSize style 'B'
@ 2,0  SAY GsDirCia
@ 2,Ancho - 33  SAY "OPERACION  "+_Prn7a+Vmov.CodOpe+_Prn7b  font _FontName,_FontSize style 'B'
@ 3,0           SAY "REGISTRO "+LsNomOpe
@ 3,Ancho - 33  SAY "ASIENTO    "+_Prn7a+XsNroAst+_Prn7b  font _FontName,_Fontsize style 'B'   
IF VARTYPE(cTitulo)<>'C'
	cTitulo =''
ENDIF
@ 4,0           SAY cTitulo
@ 4,Ancho - 54  SAY "MONEDA     "+IIF(Vmov.CodMon=1,"S/.","US$")
@ 4,Ancho - 33  SAY "REFERENCIA "+VMOV.NroVou
@ 5,0           SAY Vmov.NotAst
@ 5,Ancho - 54  SAY "T/C   "+TRAN(VMOV.TpoCmb,"##,###.####")
@ 5,Ancho - 33  SAY "Fecha      "+DTOC(Vmov.FchAst)
@ 6, 0          SAY En5
@ 7, 0          SAY En6
@ 8, 0          SAY En7
@ 9, 0          SAY En8
@ 10,0          SAY En9
IF NumPag > 1
	NumLin = PROW() + 1
	@ NumLin,70  SAY "VIENEN ..."
	@ NumLin,87 SAY nDbe PICT "999,999,999.99"
	@ NumLin,102 SAY nHbe PICT "999,999,999.99"
ENDIF
RETURN
**********************************************************************
PROCEDURE MovIPie
*****************
NumLin = Largo - 7
Pn1 = "   PREPARADO        REVISADO        GERENCIA                                  _____________________________________________________"
Pn2 = "                                                                                           Recibi Conforme                         "
Pn3 = "                                                                                                                                   "
Pn4 = "_______________ _______________ _______________                                D.N.I. No : ________________________________________"
Pn5 = PADC(VMOV.Digita,15)
@ NumLin+1,0    SAY Pn1
@ NumLin+2,0    SAY Pn4
@ NumLin+3,0    SAY Pn5
RETURN
**********************************************************************
********************
procedure act_codope
********************
parameter pscodope
wait window [Actualizando Informaci¢n .....] nowait
sele vmov
llave = xsnromes+xscodope+xsnroast
seek llave
if !found()
	tsnroast = xsnroast
	wait window [Grabando en Asiento N§: ]+tsnroast+[ CodOpe : ]+pscodope+[...] nowait
	sele vmov
	do registro
	repla codope with pscodope
	unlock
	sele rmov
	seek llave
	do while found()
		do registro
		replace codope with pscodope
		unlock
		seek llave
	enddo
else
	sele oper
	do registro
	tsnroast = nroast()
	wait window [Grabando en Asiento N§: ]+tsnroast+[ CodOpe : ]+pscodope+[...] nowait
	sele vmov
	seek llave
	replace codope with pscodope
	replace nroast with tsnroast
	sele oper
	=nroast(tsnroast)
	unlock
	sele rmov
	seek llave
	do while found()
		do registro
		replace codope with pscodope
		replace nroast with tsnroast
		unlock
		seek llave
	enddo
endif
sele oper
seek pscodope
xscodope = pscodope
xsnroast = tsnroast
sele vmov
seek xsnromes+xscodope+xsnroast
do movpinta
return

******************
procedure v_codope
******************
parameter pscodope
pscodope = tran(val(pscodope),[@L 999])
MsgErr=[]
seek pscodope
if .not. found()
	MsgErr = [C¢digo de Operaci¢n No Existe....]
	return .f.
endif
return .t.

******************
procedure registro
******************
do while !rlock()
enddo
return


***************
FUNCTION ChkCta
***************
parameter _cta
FOR KK = 1 TO NumCta - 1
	IF vCodCta(kk)=_Cta
		RETURN .T.
	ENDIF
ENDFOR
RETURN .F.

********************
PROCEDURE CARGA_CTAS
********************
scan while codope = xscodope
	LsxxCodCta = ALLTRIM(PROV.CodCta)
	DO WHILE .T.
		IF EMPTY(LsxxCodCta)
			EXIT
		ENDIF
		NumCta = NumCta + 1
		IF NumCta > ALEN(vCodCta)
			DIMENSION vCodCta(NumCta+5)
		ENDIF
		Z = AT(",",LsxxCodCta)
		IF Z = 0
			Z = LEN(LsxxCodCta) + 1
		ENDIF
		okk = .T.
		FOR k = 1 TO NumCta1
			IF vCodCta(k)= PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV.CODCTA))
				Okk = .F.
			ENDIF
		NEXT
		NumCta1 = NumCta
		IF okk
			vCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV.CODCTA))
		ELSE
			vCodCta(NumCta) = []
		ENDIF
		IF Z > LEN(LsxxCodCta)
			EXIT
		ENDIF
		LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
	ENDDO
endscan
return

*****************
PROCEDURE PORDCOM
*****************
if inlist(rmov.codcta,[6040],[6041],[6050],[6060],[2340])
	xsnroo_c = nroo_c
	define   window o_c from 14,23 to 18,57 double
	activate window o_c
	@01,02 say [Ingrese N§ O/C => ]
	@01,20 get xsnroo_c pict [!999999]
	read
	release window o_c
	do while !rlock()
	enddo
	repla rmov.tpoo_c with [O_CM]
	repla rmov.nroo_c with xsnroo_c
	unlock
endif
return

*****************
PROCEDURE ASTPROV
*****************
* variables de control *
PRIVATE XsClfAux,XsTabla,XsCodCta
XsClfAux = [01 ]     && Proveedores/Clientes
XsTabla  = [02]      && Codigo de Documentos
* bases a usar *
* variables del sistema *
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XdFchVto,XsCodAux,XfImport,XiCodMon,XfTpoCmb
PRIVATE XdFchRec,XsNomRec,XsNomEnv,XcFlgEst,XfSdoDoc,XsObserv,XsNroO_C,XsNroGui
PRIVATE XiDiaVto,XfImpBrt,XfImpIgv,XsRucAux,XsNomAux
Private XdFchPed
private xstipdoc
XsCodDoc = DPRO.CodDoc
XsNroDoc = DPRO.NroDoc
XsNroRef = DPRO.NroRef
XsCodAux = DPRO.CodAux
XsNomAux = DPRO.NomAux
XsRucAux = DPRO.RucAux
XdFchDoc = DPRO.FchDoc
XdFchVto = DPRO.FchVto
XiDiaVto = DPRO.DiaVto
XdFchPed = DPRO.FchPed
XfImport = DPRO.Import
XfImpBrt = DPRO.ImpBrt
XfImpIgv = DPRO.ImpIgv
XiCodMon = DPRO.CodMon
XfTpoCmb = DPRO.TpoCmb
XdFchRec = DPRO.FchRec
XsNomRec = DPRO.NomRec
XsNomEnv = DPRO.NomEnv
XcFlgEst = DPRO.FlgEst
XsObserv = DPRO.Observ
XsNroO_C = DPRO.NroO_C
XsNroGui = DPRO.NroGui
XsNroVou = DPRO.NroVou
Genero = .F.
SELE OPER
SEEK XsCodOpe
IF !RLOCK()
	RETURN
ENDIF
** GENERAMOS ASIENTO CONTABLE **
DO xGEN_AST
Genero = .T.
RETURN

* ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
* ³ Objetivo : Generaci¢n del asiento contable Automatico  ³
* ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE xGEN_AST
******************
PRIVATE nImpNac,nImpUsa
STORE 0 TO nImpNac,nImpUsa
SELECT VMOV
SET ORDER TO VMOV01
SEEK (XsNroMes + XsCodOpe + XsNroAst)
IF FOUND()
	OK = .F.
	GsMsgErr = "Registro creado por otro usuario"
	=MESSAGEBOX(GsMsgErr,16,'Atención')
	RETURN
ENDIF
APPEND BLANK
IF ! F1_RLock(5)
	OK = .F.
	RETURN              && No pudo bloquear registro
ENDIF
REPLACE VMOV.NROMES WITH XsNroMes
REPLACE VMOV.CodOpe WITH XsCodOpe
REPLACE VMOV.NroAst WITH XsNroAst
REPLACE VMOV.FLGEST WITH "R"
replace vmov.fchdig  with date()
replace vmov.hordig  with time() 
** GRABACION DEL CORRELATIVO **
SELECT OPER
DO CASE
	CASE XsNroMES = "00"
		iNroDoc = OPER.NDOC00
	CASE XsNroMES = "01"
		iNroDoc = OPER.NDOC01
	CASE XsNroMES = "02"
		iNroDoc = OPER.NDOC02
	CASE XsNroMES = "03"
		iNroDoc = OPER.NDOC03
	CASE XsNroMES = "04"
		iNroDoc = OPER.NDOC04
	CASE XsNroMES = "05"
		iNroDoc = OPER.NDOC05
	CASE XsNroMES = "06"
		iNroDoc = OPER.NDOC06
	CASE XsNroMES = "07"
		iNroDoc = OPER.NDOC07
	CASE XsNroMES = "08"
		iNroDoc = OPER.NDOC08
	CASE XsNroMES = "09"
		iNroDoc = OPER.NDOC09
	CASE XsNroMES = "10"
		iNroDoc = OPER.NDOC10
	CASE XsNroMES = "11"
		iNroDoc = OPER.NDOC11
	CASE XsNroMES = "12"
		iNroDoc = OPER.NDOC12
	CASE XsNroMES = "13"
		iNroDoc = OPER.NDOC13
	OTHER
		iNroDoc = OPER.NRODOC
ENDCASE
IF VAL(XsNroAst) = iNroDoc
	iNroDoc = VAL(XsNroAst) + 1
	DO CASE
		CASE XsNroMES = "00"
			REPLACE   OPER.NDOC00 WITH iNroDoc
		CASE XsNroMES = "01"
			REPLACE   OPER.NDOC01 WITH iNroDoc
		CASE XsNroMES = "02"
			REPLACE   OPER.NDOC02 WITH iNroDoc
		CASE XsNroMES = "03"
			REPLACE   OPER.NDOC03 WITH iNroDoc
		CASE XsNroMES = "04"
			REPLACE   OPER.NDOC04 WITH iNroDoc
		CASE XsNroMES = "05"
			REPLACE   OPER.NDOC05 WITH iNroDoc
		CASE XsNroMES = "06"
			REPLACE   OPER.NDOC06 WITH iNroDoc
		CASE XsNroMES = "07"
			REPLACE   OPER.NDOC07 WITH iNroDoc
		CASE XsNroMES = "08"
			REPLACE   OPER.NDOC08 WITH iNroDoc
		CASE XsNroMES = "09"
			REPLACE   OPER.NDOC09 WITH iNroDoc
		CASE XsNroMES = "10"
			REPLACE   OPER.NDOC10 WITH iNroDoc
		CASE XsNroMES = "11"
			REPLACE   OPER.NDOC11 WITH iNroDoc
		CASE XsNroMES = "12"
			REPLACE   OPER.NDOC12 WITH iNroDoc
		CASE XsNroMES = "13"
			REPLACE   OPER.NDOC13 WITH iNroDoc
		OTHER
			REPLACE   OPER.NRODOC WITH iNroDoc
	ENDCASE
	UNLOCK IN OPER
ENDIF
SELECT VMOV
PRIVATE XdFchAst,XsNotAst,XsAuxil
XdFchAst = DATE()
XsNroVou = XsNroAst+[-]+RIGHT(DTOC(XdFchAst),2)
XsNotAst = DPRO.NOMAUX
REPLACE VMOV.FchAst  WITH XdFchAst
REPLACE VMOV.NroVou  WITH XsNroVou
REPLACE VMOV.CodMon  WITH XiCodMon
REPLACE VMOV.TpoCmb  WITH XfTpoCmb
REPLACE VMOV.NotAst  WITH XsNotAst
REPLACE VMOV.Digita  WITH GsUsuario
** Generamos Detalles **
PRIVATE XsCodCta,XsCodAux,XsCodRef,XsGloDoc,XdFchDoc
PRIVATE XsNroDoc,XsNroRef,XiCodMon,XcTpoMov,XfImport
PRIVATE XiNroItm,Crear,XcEliItm
SELE DPRO
XsCodAux = CodAux
XsRucAux = RucAux
XsCodRef = SPACE(LEN(RMOV.CodRef))
XsGloDoc = XsNomAux
do case
	case inlist(codope,[065],[070]) and !empty(fchdoc)
		xdfchdoc = fchdoc
	otherwise
		xdfchdoc = vmov.fchast
endcase
XdFchVto = FchVto
XsCodDoc = CodDoc
XdFchPed = FchPed
*
do case
	case inlist(xscoddoc,[001 ],[002 ])  && FACTURAS
		xstipdoc = [01]
	case inlist(xscoddoc,[006 ],[007 ])  && NOTAS DE CREDITO
		xstipdoc = [07]
	case inlist(xscoddoc,[004 ],[005 ])  && NOTAS DE DEBITO
		xstipdoc = [08]
	otherwise
		xstipdoc = [NO]
endcase
XsNroDoc = NroDoc
XsNroRef = NroRef
XiCodMon = CodMon
XfImport = Import
XcCodCta = CodCta
XiNroItm = 1
Crear    = .T.
XcEliItm = "*"
** Primera Linea **
XsCodCta = XcCodCta
XcTpoMov="H"
DO MOVbgrab_R
** Segunda Linea **
SELE DPRO
IF ImpIgv > 0
	xstipdoc = [NO]
	XfImport = ImpIgv
	XsCodCta = [40100100]
	IF _ANO<2000
		XsNroDoc = XsNroMes+[0001-]+RIGHT(STR(_ANO,4,0),2)
	ELSE
		XsNroDoc = XsNroMes+[0001-]+STR(_ANO,4,0)
	ENDIF
	XcTpoMov = [D]
	XsClfAux = [40]
	XsCodAux = space(len(rmov.codaux))
	lExiste=SEEK(XsCodCta,[CTA2])
	IF lExiste
		LsVcto=[CTA2.Vcto]+XsNroMes
		IF !EMPTY(EVAL(LsVcto)) 
			Td40FchVto = EVAL(LsVcto)
			lActCta40  = .t.
			IF !EMPTY(Td40FchVto) 
				XdFchVto=TD40FchVto
				XdFchPed=TD40FchVto
			ENDIF 
		ENDIF	
		XsCodAux=CTA2.CodAux
	ENDIF
	DO MOVbgrab_R
ENDIF
RETURN

************************************************************************** FIN
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab_R
SELE RMOV
IF Crear
	APPEND BLANK
ENDIF
IF ! F1_RLock(5)
	OK = .F.
	RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
	IF CTAS.MAYAUX = "S"
		XsCodRef = PADR(XsCodAux,LEN(RMOV.CodRef))
	ENDIF
ENDIF
IF Crear
	REPLACE RMOV.NroMes WITH XsNroMes
	REPLACE RMOV.CodOpe WITH XsCodOpe
	REPLACE RMOV.NroAst WITH XsNroAst
	REPLACE RMOV.NroItm WITH XiNroItm
	REPLACE VMOV.NroItm WITH VMOV.NroItm + 1
	replace rmov.fchdig  with date()
	replace rmov.hordig  with time() 
ELSE
	IF ! XsCodOpe = "9"
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv
	ELSE
		DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv
	ENDIF
	REPLACE VMOV.ChkCta  WITH VMOV.ChkCta-VAL(TRIM(RMOV.CodCta))
	DO CalImp
	IF RMOV.TpoMov = 'D'
		REPLACE VMOV.DbeNac  WITH VMOV.DbeNac-nImpNac
		REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa-nImpUsa
	ELSE
		REPLACE VMOV.HbeNac  WITH VMOV.HbeNac-nImpNac
		REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa-nImpUsa
	ENDIF
ENDIF
REPLACE RMOV.EliItm WITH XcEliItm
REPLACE RMOV.FCHAST WITH XDFCHAST
REPLACE RMOV.CodMon WITH XiCodMon
REPLACE RMOV.TpoCmb WITH XfTpoCmb
REPLACE RMOV.FchDoc WITH XdFchAst
REPLACE RMOV.CodCta WITH XsCodCta
REPLACE RMOV.CodRef WITH XsCodRef
REPLACE RMOV.ClfAux WITH XsClfAux
REPLACE RMOV.CodAux WITH XsCodAux
REPLACE RMOV.TpoMov WITH XcTpoMov
REPLACE RMOV.NroRuc WITH XsRucAux
REPLACE RMOV.CodDiv  WITH TsCodDiv1
IF CodMon = 1
	REPLACE RMOV.Import WITH XfImport
	IF TpoCmb = 0
		REPLACE RMOV.ImpUsa WITH 0
	ELSE
		REPLACE RMOV.ImpUsa WITH ROUND(XfImport/TpoCmb,2)
	ENDIF
ELSE
	REPLACE RMOV.Import WITH ROUND(XfImport*TpoCmb,2)
	REPLACE RMOV.ImpUsa WITH XfImport
ENDIF
REPLACE RMOV.GloDoc WITH XsGloDoc
REPLACE RMOV.CodDoc WITH XsCodDoc
replace rmov.tipdoc  with xstipdoc
REPLACE RMOV.NroDoc WITH XsNroDoc
REPLACE RMOV.NroRef WITH XsNroRef
REPLACE RMOV.FchDoc WITH XdFchDoc
REPLACE RMOV.FchVto WITH XdFchVto
do case
	case chkcta(rmov.codcta)
		repla rmov.fchped with rmov.fchvto
	case rmov.codcta=[46] .and. rmov.codope=[016]  &&& PAGARES
		repla rmov.fchped with rmov.fchvto
	case rmov.codcta=[46] .and. rmov.codope=[231]  &&& LEASING
		repla rmov.fchped with rmov.fchvto
	other
		repla rmov.fchped WITH rmov.fchast
endcase
if rmov.tpomov = [H]
	if empty(xdfchped)     
		repla rmov.fchped with rmov.fchvto
	else
		repla rmov.fchped with xdfchped
	endif
endif        
if !empty(rmov.fchped) AND USED('DIAF')
	repla rmov.fchped with iif(seek(dtos(rmov.fchped),[diaf]),diaf.fchven,rmov.fchped)
endif

REPLACE VMOV.ChkCta  WITH VMOV.ChkCta+VAL(TRIM(XsCodCta))
IF ! XsCodOpe = "9"
	DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa ,CodDiv
ELSE  && EXTRA CONTABLE
	DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa ,CodDiv
ENDIF
SELECT RMOV
DO CalImp
IF RMOV.TpoMov = 'D'
	REPLACE VMOV.DbeNac  WITH VMOV.DbeNac+nImpNac
	REPLACE VMOV.DbeUsa  WITH VMOV.DbeUsa+nImpUsa
ELSE
	REPLACE VMOV.HbeNac  WITH VMOV.HbeNac+nImpNac
	REPLACE VMOV.HbeUsa  WITH VMOV.HbeUsa+nImpUsa
ENDIF
SELE RMOV
UNLOCK
RETURN

****************************
PROCEDURE Cap_Detalle_Cursor
****************************
PARAMETERS LcTipOpe

	XsCodDiv = C_RMOV.CodDiv
	XsCtaPre = C_RMOV.CtaPre
	XsCodCta = C_RMOV.CodCta
	XsClfAux = C_RMOV.ClfAux
	XsCodAux = C_RMOV.CodAux
	XsCodRef = C_RMOV.CodRef
	XcTpoMov = C_RMOV.TpoMov
	XcAfecto = C_RMOV.Afecto
	XsCodCCo = C_RMOV.CodCco
	
	
	
	=SEEK(C_RMOV.CodCta,'CTAS')
	IF CTAS.PidAux = 'S'
		=SEEK(C_RMOV.ClfAux+C_RMOV.CodAux,'AUXI')		   
	ENDIF
	IF LcTipOpe = 'I'
		XsChkCta = SYS(2015) 
		XsAn1Cta = CTAS.An1Cta
		XsCC1Cta = CTAS.CC1Cta
		XsAn2Cta 	= CTAS.An2Cta
		XsCC2Cta	= CTAS.CC2Cta
	ELSE
		XsChkCta = C_RMOV.ChkCta
	    XsAn1Cta = IIF(EMPTY(C_RMOV.An1Cta) AND CTAS.GENAUT='S' , CTAS.An1Cta,C_RMOV.An1Cta)
		XsCC1Cta = IIF(EMPTY(C_RMOV.CC1Cta) AND CTAS.GENAUT='S' , CTAS.CC1Cta,C_RMOV.CC1Cta)
	    XsAn2Cta = IIF(EMPTY(C_RMOV.An2Cta) AND CTAS.GENAUT='S' , CTAS.An2Cta,C_RMOV.An2Cta)
		XsCC2Cta = IIF(EMPTY(C_RMOV.CC2Cta) AND CTAS.GENAUT='S' , CTAS.CC2Cta,C_RMOV.CC2Cta)		
	ENDIF
	
	
	IF OPER.CodMon # 4
		XiCodMon = VMOV.CodMon
		XfTpoCmb = VMOV.TpoCmb
	ELSE
		XiCodMon = IIF(LcTipOpe='I',VMOV.CodMon,C_RMOV.CodMon)
		XfTpoCmb = IIF(LcTipOpe='I',VMOV.TpoCmb,C_RMOV.TpoCmb)
	ENDIF
	IF XiCodMon = 1
		XfImport = C_RMOV.Import
	ELSE
		XfImport = C_RMOV.ImpUsa
	ENDIF
	XfImpUsa    = C_RMOV.ImpUsa
	XfImpNac    = C_RMOV.Import
	IF INLIST(LcTipOpe,'A','C') 
		XiNroItm = C_RMOV.NroItm
	ELSE
		*** Determinamos el NroItm ***
		Local LsLLave_Reg
		LsLlave_Reg=C_RMOV.NroMes+C_RMOV.CodOpe+C_RMOV.NroAst 
		XiNroItm = gosvrcbd.cap_nroitm(C_RMOV.NroMes+C_RMOV.CodOpe+C_RMOV.NroAst,'RMOV','nromes+codope+nroast')
	ENDIF
	XsGloDoc = C_RMOV.GloDoc
	XdFchDoc = C_RMOV.FchDoc
	XdFchVto = C_RMOV.FchVto
	XsCodDoc = C_RMOV.CodDoc
	XsNroDoc = C_RMOV.NroDoc
	XsNroRef = C_RMOV.NroRef
*!*		XiCodMon = VMOV.CodMon
*!*		XfTpoCmb = VMOV.TpoCmb
	XsIniAux = C_RMOV.IniAux
	XdFchPed = C_RMOV.FchPed
	xsnivadi = C_rmov.tpoo_c
	XcTipoC  = C_RMOV.TipoC
	XsNroRuc = C_RMOV.NroRuc
	XsTipDoc = iif(C_rmov.tipdoc=space(len(rmov.tipdoc)),[NO],C_rmov.tipdoc)
	xstipdoc1= iif(C_rmov.tipdoc=space(len(rmov.tipdoc)),[NO],C_rmov.tipdoc)
	xscodcta1= C_rmov.codcta
	xsnroref1= C_rmov.nroref
	*!*	XsTipRef	= IIF(VerifyVar('TipRef','','CAMPO','RMOV'),RMOV.TipRef,'')  && RMOV.TipRef
	*!*	XdFchRef	= IIF(VerifyVar('FchRef','','CAMPO','RMOV'),RMOV.FchRef,{})  && RMOV.FchRef
	XsTipRef = IIF(VerifyVar('TipRef','','CAMPO','RMOV'),C_RMOV.TipRef,'')
	XdFchRef = IIF(VerifyVar('FchRef','','CAMPO','RMOV'),C_RMOV.FchRef,{})
	XsNroDtr = C_RMOV.NroDtr
	XdFchDtr = C_RMOV.FchDtr
	* DATOS SUNAT
	SELE DRMOV
	llave = [SUNAT]+xsnromes+xscodope+xsnroast+xscodcta1+xstipdoc1+xsnroref1
	seek llave
	if found()
		xstipori = drmov.tipori
		xsnumori = drmov.numori
		xsfecori = drmov.vctori
		xsimpori = drmov.impori
		xsnumpol = drmov.n_poliza
		xsimpnac1= drmov.impnac1
		xsimpnac2= drmov.impnac2
	else
		store 0 to xsimpori, xsimpnac1, xsimpnac2
		XsTipOri = space(len(drmov.tipori))
		XsNumOri = space(len(drmov.numori))
		XsNumPol = space(len(drmov.n_poliza))
	ENDIF
RETURN

********************
Function Pendientes
********************
parameters _XsCodCta,_XsCodAux,_XsNroDoc
Local LsAreaAct
LsAreaAct = ALIAS()
IF PArameters() = 2
	_XsNroDoc= ''
ENDIF
IF !USED('RMOV')
	sele 0
	use cbdrmovm order rmov01 alias rmov
	if !used()
		wait window 'No hay acceso a tabla de movimientos, Pulse <Enter>'
		return .f.
	endif
ENDIF
IF !USED('CTAS')
	sele 0
	use cbdmctas order CTAS01 alias CTAS
	if !used()
		wait window 'No hay acceso a maestro de cuentas, Pulse <Enter>'	
		return .f.
	endif
	
ENDIF
SELECT CNFG2
COPY TO ARRAY  aOpeProv FIELDS CodOpe FOR !EMPTY(CodOpe)
COPY TO ARRAY  aCtaProv FIELDS Ctatota FOR !EMPTY(CodOpe)
Private Llave,RegAct1,Eof1,SdoNac,SdoUsa,Order1,LcArcTmp
IF !USED('CTACTE')
	SELECT RMOV
	**LcArcTmp = PAthUSer+sys(3)
	LcArcTmp = SYS(2023)+'\'+sys(2015)
	Copy stru to (LcArCTmp)
	selec 0
	use (LcArcTmp) ALIAS CTACTE EXCLU
	INDEX ON NroDoc TAG NroDOc
	SET ORDER TO Nrodoc
ELSE
	SELECT CTACTE
	IF USED('CTACTE') AND ALIAS()=='CTACTE'
		ZAP
	ENDIF
ENDIF
**
SELE RMOV
RegAct1 = RECNO()
EOF1    = EOF()
Order1	= ORDER()
SET ORDER TO RMOV06
_XsCodCta = PADR(_XsCodCta,LEN(RMOV.CodCta))
Llave = _XsCodCta+_XsCodAux+TRIM(_XsNroDoc)
STORE 0 TO Saldo1,SdoUsa1,xMonProv
SEEK LLave
DO WHILE CodCta+CodAux+NroDoc = LLave AND !EOF()
	LsNroDoc =NroDoc
	Llave2 = CodCta+CodAux+NroDoc
	SdoNac  = 0
	SdoUsa = 0
	xMonProv = 0
	xLfImport = 0
	m.TpoMovProv = IIF(INLIST(CodCta,'42','46'),'H',IIF(CodCta='12','D','H'))
	SCAN WHILE (CodCta+CodAux+NroDoc = Llave2) 
		=SEEK(CodCta,'CTAS')
		DO CASE 
			CASE Ctas.ClfAux = RMOV.ClfAux AND Ctas.PidDoc='S' AND CTAS.PidAux='S'
				IF Check_OpeProv(CodOpe)
					scatter memvar
					m.nrocta = iif(CodMon=1,'S/. '+tran(Import,'99,999,999.99'),'US$ '+tran(ImpUsa,'99,999,999.99'))
*!*						m.GloDoc = iif(CodMon=1,'S/. '+tran(Import,'99,999,999.99'),'US$ '+tran(ImpUsa,'99,999,999.99'))
					m.TpoMovProv=TpoMov
					xMonProv=CodMon
				ENDIF
				SdoNac = SdoNac + IIF(TpoMov = m.TpoMovProv , 1 , -1)*Import
				SdouSA = SdouSA + IIF(TpoMov = m.TpoMovProv , 1 , -1)*ImpUsa
		endCase
	ENDSCAN
	IF abs(SdoNac)>XfDif_MN2 OR abs(SdoUsa)>XfDif_ME2   && Esta pendiente
		IF xMonProv = 1
			xLfImport = SdoNac
		ELSE
			xLfImport = SdoUsa
		ENDIF
		IF XiCodMon # xMonProv
			IF XiCodMon = 1
				xLfImport = ROUND(xLfImport*XfTpoCmb,2)
			ELSE
				xLfImport = ROUND(xLfImport/XfTpoCmb,2)
			ENDIF
		ENDIF
		LlAgregarPendiente = .F.
		DO CASE 
*!*				CASE xMonProv#XiCodMon AND xMonProv<>0
			CASE XiCodMon=1 AND abs(SdoNac)>XfDif_MN2	
				LlAgregarPendiente = .T.
			CASE XiCodMon=2 AND abs(SdoUsa)>XfDif_ME2
				LlAgregarPendiente = .T.
			OTHERWISE 
		ENDCASE
		m.Import = SdoNac 	&& VETT 2010-03-06 , Variable Saldo no jalaba saldo
								&&  en soles por que se confundia con campo de la tabla CTACTE
		m.ImpUsa = SdoUsa
		IF LlAgregarPendiente
			INSERT into CTACTE From MemVar
		ENDIF
	ENDIF
ENDDO	
SET ORDER TO (Order1)
IF ! EOF1
	GOTO RegAct1
ELSE
	GOTO BOTTOM
	IF ! EOF()
		SKIP
	ENDIF
ENDIF
Llreturn = .F.
SELECT CTACTE
GO TOP
IF EOF()
	llreturn = .f.
ENDIF
Llreturn = .T.
IF !EMPTY(LsAreaAct)
	SELECT (LsAreaAct)
ENDIF
return llReturn

**********************
FUNCTION Check_OpeProv
**********************
PARAMETERS _CodOpe
PRIVATE LlOk
LlOk=.F.
FOR K= 1 TO ALEN(aOpeProv) 
	IF aOpeProv(k)=_CodOpe
		RETURN .T.
	ENDIF
ENDFOR
RETURN LlOk

**********************
FUNCTION Check_CtaProv
**********************
PARAMETERS _CodCta
PRIVATE LlOk
LlOk=.F.
FOR K= 1 TO ALEN(aCtaProv) 
	LsCtas = aCtaProv(k)
	IF INLIST(_CodCta,&LsCtas)
		RETURN .T.
	ENDIF
ENDFOR
RETURN LlOk

*************************
FUNCTION Recalculo_TPOCMB
*************************
LcFile=ADDBS(SYS(2023))+'LogRegVta.txt' 
GlModTpoCmb = .T.
LlPrimeraVtas = .T.
SELECT vmov
SEEK XsNroMes+XsCodOpe
SCAN WHILE NroMes+CodOpe=XsNroMes+XsCodOpe
	XsNroAst = NroAst
	WAIT WINDOW "Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" -" nowait
	NClave   = [NroMes+CodOpe+NroAst]
	VClave   = XsNroMes+XsCodOpe+XsNroAst
	RegVal   = "&NClave = VClave"
	XiCodMon = VMOV.CodMon
	XdFchAst = VMOV.FchAst 
	=SEEK(DTOS(FchAst),"TCMB")
	=SEEK(VMOV.CodOpe,'OPER','OPER01')
	XfTpoCmb = iif(OPER.TpoCmb=1,TCMB.OFICMP,TCMB.OFIVTA)
	WAIT WINDOW "Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" \" nowait
	replace VMOV.TpoCmb WITH XfTpoCmb
	WAIT WINDOW "Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" |" nowait
	DO movf3
	WAIT WINDOW "Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" /" nowait
	SELECT VMOV
ENDSCAN 
GlModTpoCmb = .F.
IF USED('GDOC')
	USE IN GDOC
ENDIF
RETURN 

****************
PROCEDURE CalImp
****************
PARAMETERS _ChkTpoCmb
IF _ChkTpoCmb && VETT 2009-05-29  
	STORE 0 TO 	XfImpNac,XfImpUsa,XfImport
	=RLOCK("RMOV")
	IF !RMOV.TpoCmb==VMOV.TpoCmb
		REPLACE RMOV.TpoCmb WITH VMOV.TpoCmb
	ENDIF
	IF VMOV.CodMon=1
		XfImport = RMOV.Import
		XfImpNac    = XfImport
		XfImpUsa    = round(XfImport/VMOV.TpoCmb,2)
	ELSE
		XfImport = RMOV.ImpUsa
		XfImpUsa    = XfImport
		XfImpNac    = round(XfImport*VMOV.TpoCmb,2)
	ENDIF
	IF OPER.CodMon = 4
		REPLACE RMOV.Import WITH XfImpNac
		REPLACE RMOV.ImpUsa WITH XfImpUsa
	ELSE
		IF RMOV.CodMon = 1
			REPLACE RMOV.Import WITH XfImport
			IF RMOV.TpoCmb = 0
				REPLACE RMOV.ImpUsa WITH 0
			ELSE
				REPLACE RMOV.ImpUsa WITH round(XfImport/RMOV.TpoCmb,2)
			ENDIF
		ELSE
			REPLACE RMOV.Import WITH round(XfImport*RMOV.TpoCmb,2)
			REPLACE RMOV.ImpUsa WITH XfImport
		ENDIF
	ENDIF
ENDIF
nImpNac = Import
nImpUsa = ImpUsa
RETURN
************************
PROCEDURE Regraba_Ventas && VETT 2009-06-03  
************************
PARAMETERS PsTpoDoc,PsCodDoc,PsNroDoc,PfTpoCmb,PsAsiento,PfImpNac,PfImpUsa,PnCodMon
IF EMPTY(PsTpoDoc) OR EMPTY(PsNroDoc) OR EMPTY(PsNroDoc)
	RETURN 
ENDIF
LlReturnOk = .f.
IF !USED('GDOC')
	lreturnok=GOENTORNO.Open_dbf1('ABRIR','CCBRGDOC','GDOC','GDOC01','')
ELSE
	SELECT GDOC
	SET ORDER TO GDOC01
ENDIF
PsCodDoc=PADR(PsCodDoc,LEN(GDOC.CodDoc))
PsNroDoc=PADR(PsNroDoc,LEN(GDOC.NroDoc))
SEEK PsTpoDoc+PsCodDoc+PsNroDoc
IF FOUND() AND RLOCK()
	REPLACE TpoCmb WITH PfTpoCmb
ENDIF

IF GDOC.CodMon=1
	LfImpNac = GDOC.ImpTot
	IF GDOC.TpoCmb>0
		LfImpUsa = ROUND(GDOC.ImpTot/TpoCmb,2)
	ELSE
		LfImpUsa = 0	
	ENDIF
ELSE
	LfImpUsa = GDOC.ImpTot
	LfImpNac = ROUND(GDOC.ImpTot*TpoCmb,2)
ENDIF
IF PfImpNac <> LfImpNac OR PfImpUsa <> LfImpUsa
	IF LlPrimeraVtas
		=STRTOFILE('****  REGISTRO DE VENTAS QUE NO COINCIDE EN CONTABILIDAD '+TTOC(DATETIME())+' *****  '+CRLF,LcFile,.T.)	
		=STRTOFILE('Documento        Fecha Doc.  Vcto     Moneda.  Importe    T/C.VTA    Digitado     Fecha     Hora     Asiento        T.C.CBD     ImpNac    ImpUsa   '+CRLF,LcFile,.T.)	
		LlPrimeraVtas= .F.
	ENDIF
	=STRTOFILE(GDOC.CodDoc+'-'+GDOC.NroDoc+' '+DTOC(GDOC.FchDoc)+' '+DTOC(GDOC.FchVto)+'   '+;
	IIF(gdoc.CodMon=1,'S/.',IIF(GDOC.CodMon=2,'US$',''))+' '+TRANSFORM(GDOC.imptot,'999,999.99')+'    '+TRANSFORM(GDOC.TpoCmb,'9.9999')+'    '+VMOV.Digita+;
	'  '+DTOC(VMOV.FchDig)+' '+VMOV.HorDig+' '+RMOV.Nromes+'-'+RMOV.CodOpe+'-'+RMOV.NroAst+' '+TRANSFORM(RMOV.TpoCmb,'9.9999')+;
	' '+TRANSFORM(RMOV.import,'999,999.99')+' '+TRANSFORM(RMOV.ImpUsa,'999,999.99')+CRLF,LcFile,.T.)
	
ENDIF

UNLOCK IN GDOC
*******************
FUNCTION GenRegAuto
*******************
PARAMETERS _Siglas
LOCAL LsCtas1,LsCtas2,LsCursor
IF !SEEK(_Siglas,'CNFG')
	=MessageBox('No existe configuración de asiento automatico para esta operación ')
	RETURN .F.
ENDIF
LsCtas1 = CtaTota
LsCtas2 = CtaImpu
LsCursor = SYS(2015)
LcSql = "SELECT CodCta,ClfAux,Pidaux,TpoMov FROM ctas.aftmov='S' AND ctas.PidAux='S' AND Tip_Afe_rc='A' AND CTAS WHERE CodCta IN ("+LsCtas1+")"
LcSql = LcSql + " INTO CURSOR "+LsCursor

*******************
procedure dat_sunat
*******************
RESTORE MACROS FROM ADMCONFG
*!*	SET STEP ON 
IF VARTYPE(oSn)<>'O'
	PUBLIC oSn as Object 
	SELECT DRMOV
	SCATTER name oSn blank
ENDIF
IF VARTYPE(oSn2)<>'O'
	PUBLIC oSn2 as Object 
	SELECT C_RMOV 
	SCATTER name oSn2 blank
	ADDPROPERTY(oSn2,"NroReg",0)
ENDIF	
SELECT c_rmov
LnCurRec = RECNO()
LsCurChk = ChkCta
LlExisteChkCta = .f.
SCAN 
	IF INLIST(CodCta,'12','42') AND (!EMPTY(ChkCta) AND ChkCta=LsCurChk) 
		LlExisteChkCta = .T.
		EXIT
	ENDIF
ENDSCAN
IF  LlExisteChkCta &&FOUND() && Ya existe
	oSn2.CodCta	= IIF(EMPTY(c_rmov.CodCta),oSn2.CodCta,c_rmov.CodCta)
	oSn2.ClfAux	= IIF(EMPTY(c_rmov.ClfAux),oSn2.ClfAux,c_rmov.ClfAux)
	oSn2.NroRuc = IIF(EMPTY(c_rmov.CodAux),oSn2.NroRuc,c_rmov.CodAux)
	oSn2.IniAux = IIF(EMPTY(c_rmov.CodAux),oSn2.IniAux,c_rmov.IniAux)
	oSn2.NroDoc	= IIF(EMPTY(c_rmov.NroDoc),oSn2.NroDoc,c_rmov.NroDoc)
	oSn2.FchDoc	= IIF(EMPTY(c_rmov.FchDoc),oSn2.FchDoc,c_rmov.FchDoc)
	oSn2.FchVto	= IIF(EMPTY(c_rmov.FchVto),oSn2.FchVto,c_rmov.FchVto)
	oSn2.NroMes	= IIF(EMPTY(c_rmov.NroMes),oSn2.NroMes,c_rmov.NroMes)
	oSn2.CodOpe	= IIF(EMPTY(c_rmov.CodOpe),oSn2.CodOpe,c_rmov.CodOpe)
	oSn2.NroAst	= IIF(EMPTY(c_rmov.NroAst),oSn2.NroAst,c_rmov.NroAst)
	oSn2.NroRef	= IIF(EMPTY(c_rmov.NroDoc),oSn2.NroDoc,c_rmov.NroDoc)
	oSn2.NroDtr = IIF(EMPTY(c_rmov.NroDtr),oSn2.NroDtr,c_rmov.NroDtr)
	oSn2.FchDtr = IIF(EMPTY(c_rmov.FchDtr),oSn2.FchDtr,c_rmov.FchDtr)
	oSn2.Import = IIF(EMPTY(c_rmov.Import),oSn2.Import,c_rmov.Import)
	oSn2.ImpUsa = IIF(EMPTY(c_rmov.Impusa),oSn2.ImpUsa,c_rmov.ImpUsa)
	oSn2.TpoMov	= IIF(EMPTY(c_rmov.TpoMov),oSn2.TpoMov,c_rmov.TpoMov)
	oSn.TipDoc	= IIF(EMPTY(c_rmov.TipDoc),oSn.TipDoc,c_rmov.TipDoc)
	oSn.TipOri	= IIF(EMPTY(c_rmov.TipOri),oSn.TipOri,c_rmov.TipOri)
	oSn.NumOri	= IIF(EMPTY(c_rmov.NumOri),oSn.NumOri,c_rmov.NumOri)
	oSn2.NroReg = c_rmov.NroReg
	oSn2.Afecto = c_rmov.Afecto
	oSn2.Pid2Aux= c_rmov.Pid2Aux
	oSn2.Pid2Doc= c_rmov.Pid2Doc
	oSn2.Pid2Glo= c_rmov.Pid2Glo
	oSn2.An2Cta = c_Rmov.An2Cta
	oSn2.An2CtaME = c_Rmov.An2CtaME
	oSn2.CC2Cta = c_Rmov.CC2Cta
	IF LnCurRec>0
		GO LnCurRec
	ENDIF
ELSE
	IF LnCurRec>0
		GO LnCurRec
	ENDIF
	oSn2.CodOpe = c_rmov.CodOpe
	oSn2.NroDoc	= IIF(EMPTY(c_rmov.NroDoc),oSn2.NroDoc,c_rmov.NroDoc)
	oSn2.FchDoc	= IIF(EMPTY(c_rmov.FchDoc),oSn2.FchDoc,c_rmov.FchDoc)
	oSn2.FchVto	= IIF(EMPTY(c_rmov.FchVto),oSn2.FchVto,c_rmov.FchVto)
	oSn2.Import = IIF(EMPTY(c_rmov.Import),oSn2.Import,c_rmov.Import)
	oSn2.ImpUsa = IIF(EMPTY(c_rmov.Impusa),oSn2.ImpUsa,c_rmov.ImpUsa)
	oSn.TipDoc	= IIF(EMPTY(c_rmov.TipDoc),oSn.TipDoc,c_rmov.TipDoc)
	oSn.TipOri	= IIF(EMPTY(c_rmov.TipOri),oSn.TipOri,c_rmov.TipOri)
	oSn.NumOri	= IIF(EMPTY(c_rmov.NumOri),oSn.NumOri,c_rmov.NumOri)
	oSn2.CodCta = TraerCuentaxCodMon(c_rmov.An2Cta,XiCodMon)
	oSn2.NroReg = C_RMOV.NroReg   && Debe ser cero cuando es un registro nuevo
	oSn2.TpoMov	= IIF(oSn2.CodCta='12','D',IIF(oSn2.CodCta='42','H',''))
	oSn2.Afecto = c_rmov.Afecto
	IF Oper.Siglas='RV'
		oSn2.ClfAux	= IIF(EMPTY(oSn2.ClfAux),GsClfCli,oSn2.ClfAux)
	ENDIF
	IF Oper.Siglas='RC'
		oSn2.ClfAux	= IIF(EMPTY(oSn2.ClfAux),GsClfPro,oSn2.ClfAux)
	ENDIF
	oSn2.Pid2Aux= c_rmov.Pid2Aux
	oSn2.Pid2Doc= c_rmov.Pid2Doc
	oSn2.Pid2Glo= c_rmov.Pid2Glo
	oSn2.An2Cta = c_Rmov.An2Cta
	oSn2.An2CtaME = c_Rmov.An2CtaME
	oSn2.CC2Cta = c_Rmov.CC2Cta
ENDIF

sErr = ''
do case
	case xscodope = [070] .and. left(xscodcta,2) = '40' && Importaciones
		cTit1 = 'Datos de importación'   
		define   window sunat from 14,20 to 20,86 FLOAT GROW ;
			TITLE (cTit1) COLOR SCHEME 16
		activate window sunat
		@ 00,01 say 'N§ Poliza         =>'
		@ 01,01 say 'Total Importaci¢n =>'
		@ 02,01 say 'Total Advalorem   =>'
		@ 03,01 say 'Total IGV + IPM   =>'
		@ 04,01 say 'Fecha de Pago     =>'
		xstipdoc  = '50'  && Importaciones
		xstipdoc1 = '50'  && Importaciones
		@00,22 get xsnumpol  valid (xsnumpol<>space(len(drmov.n_poliza)))
		@01,22 get xsimpori  pict '999,999,999.99' valid (xsimpori<>0)
		@02,22 get xsimpnac1 pict '999,999,999.99'
		@03,22 get xsimpnac2 pict '999,999,999.99' valid (xsimpnac2<>0)
		@04,22 get xsfecori  pict '@E' valid (xsfecori<>ctod(space(08)))
		READ
		UltTecla = LASTKEY()
	otherwise
		cTit1 = 'Datos Adicionales'   
		define   window sunat from 11,20 to 22,100 FLOAT GROW ;
			TITLE (cTit1) COLOR SCHEME 16
		activate window sunat
		@ 00,01 SAY 'T.Doc.           ==>'
		@ 01,01 SAY 'Clasificación    ==>'
		@ 02,01 say 'N§ Ruc           ==>'
		@ 03,01 say 'Razon Social     ==>'
		@ 04,01 SAY 'N§ Doc.          ==>'
		@ 05,01 SAY 'Fecha Documento  ==>'
		@ 06,01 SAY 'Fecha Vencimiento==>'
		@ 07,01 say 'Referencia T.Doc ==>                Nº.Doc.:			  Fecha:'
		@ 08,01 say 'Nº Detracción    ==>'
		@ 09,01 say 'Fecha Detracción ==>'
          **	     1234567890123456789012345678901234567890123456789012345678901234567890
        **					  1		    2 	      3         4         5         6 	 			 	
		if trim(xsclfaux) = GsClfCli
			oSn2.iniaux = iif(seek(xsclfaux+xscodaux,[auxi]),left(auxi.nomaux,20),space(len(rmov.IniAux)))
			oSn2.nroruc = iif(seek(xsclfaux+xscodaux,[auxi]),auxi.rucaux,space(11))
		else
			oSn2.iniaux = iif(oSn2.iniaux=space(len(rmov.iniaux)),space(len(AUXI.NomAux)),oSn2.iniaux)
			oSn2.nroruc = iif(oSn2.nroruc=space(len(rmov.nroruc)),space(len(rmov.nroruc)),oSn2.nroruc)
		endif
		@00,22 get oSn.tipdoc  valid vTipDoc()  ERROR serr
		@01,22 get oSn2.ClfAux  valid vClfAux() ERROR serr
		@02,22 get oSn2.nroruc pict '99999999999' valid  vNroRuc()  ERROR serr
		@03,22 get oSn2.iniaux pict '@!'
		@04,22 get oSn2.NroDoc pict '@R XXXXXXXXXXXXXXXXXXXX' valid vNroDoc() &&(oSn2.nroDoc<>space(len(rmov.nroDoc)))
		** Verificamos Número de documento existente **
		@05,22 get oSn2.FchDoc && valid (oSn2.fchdoc<>ctod(space(08)))
		@06,22 get oSn2.FchVto && valid (oSn2.fchVto<>ctod(space(08)))
		@07,22 get oSn2.TipRef  valid vTipRef() pict '99' && valid (xstipori$[01^08])
		@07,45 get oSn2.NroRef  pict '@R XXXXXXXXXX' && valid (oSn.numori<>space(10))
		@07,65 get oSn2.FchRef  pict '@E' && valid (oSn.Vctori<>ctod(space(08)) .and. oSn.Vctori<=oSn2.fchdoc)
		@08,22 get oSn2.NroDtr
		@09,22 get oSn2.FchDtr
		READ
		UltTecla = LASTKEY()
		lvalidado=SEEK(oSn2.ClfAux+oSn2.nroruc,"auxi")
		IF lvalidado = .f. AND !EMPTY(oSn2.nroruc) AND !EMPTY(oSn2.ClfAux)
			DO Nuevo_Ruc && PARA INGRESAR ruc POR SI NO EXISTE
		ENDIF
*!*			if oSn.NroRef <> space(10)
*!*				oSn.NroRef = tran(val(left(oSn.nroref,3)),[@L 999])+;
*!*	                      tran(val(subs(oSn.nroref,4)),[@L 9999999])
*!*				@ 04,22 get oSn.NroRef pict '@R 999-99999999'
*!*				clear gets
*!*			endif
*!*			IF INLIST(oSn.tipdoc,[07],[08])
*!*				@07,22 get oSn.tipori  pict '99' && valid (xstipori$[01^08])
*!*				@07,35 get oSn.numori  pict '@R 9999999999' && valid (oSn.numori<>space(10))
*!*				@09,55 get oSn.FchRef  pict '@E' && valid (oSn.Vctori<>ctod(space(08)) .and. oSn.Vctori<=oSn2.fchdoc)
*!*				read
*!*	*!*				oSn.numori = TRANSFORM(val(left(oSn.numori,3)),[@L 999]) + TRANSFORM(val(subs(oSn.numori,4)),[@L 9999999])
*!*			ELSE
*!*				oSn.TipOri  = SPACE(LEN(drmov.tipori))
*!*				oSn.NumOri  = SPACE(LEN(drmov.numori))
*!*	*!*				oSn.VctOri  = {  ,  ,    }          
*!*			ENDIF
ENDCASE
CLEAR macros
release  window sunat
return

****************
FUNCTION vTipDoc
****************
LsVar=oSn.TipDoc
lValido=F1_busca(@LsVar,[Codigo],[TABL],[TABL],[SN],.t.,[])
IF lValido
	oSn.TipDoc = LsVar
	XsNombre1=IIF(EMPTY(oSn.TipDoc),'',LEFT(TABL.Nombre,30))
	@0,22 say oSn.TipDoc
	@0,26 say XsNomBre1
ELSE
	sErr = [Codigo de documento invalido]
ENDIF
RETURN lValido

****************
FUNCTION vClfAux
****************
LsVar=oSn2.ClfAux
lValido=F1_busca(@LsVar,[Codigo],[TABL],[TABL],[01],.t.,[])
IF lValido
	oSn2.ClfAux = LsVar
	XsNombre2=IIF(EMPTY(oSn2.ClfAux),'',LEFT(TABL.Nombre,30))
	@01,22 say oSn2.ClfAux
	@01,26 say XsNomBre2
ELSE
	sErr = [Codigo invalido]
ENDIF
RETURN lValido

****************
FUNCTION vNroRuc
****************
LsVar = PADR(oSn2.NroRuc,LEN(AUXI.CodAux))
lValido=F1_busca(@LsVar,[CodAux],[AUXI],[AUXI],oSn2.Clfaux,.t.,[])
IF lValido
	oSn2.NroRuc = LsVar
	XsNombre3=IIF(EMPTY(oSn2.NroRuc),'',LEFT(AUXI.NomAux,30))
	@02,22 say oSn2.NroRuc
	@02,35 say XsNomBre3
	oSn2.IniAux = XsNomBre3
ELSE
	sErr = [Codigo de documento invalido]
ENDIF
return .t.

*******************
PROCEDURE Nuevo_Ruc
*******************
IF !SEEK(oSn2.ClfAux+oSn2.NroRuc,'AUXI','AUXI01')
	INSERT INTO auxi   (clfaux,codaux,nomaux,rucaux) ;
				VALUES (oSn2.ClfAux,oSn2.NroRuc,oSn2.IniAux,oSn2.NroRuc)
ELSE

ENDIF			
****************
FUNCTION vNroDoc
****************
*!* solo verificamos si documento existe solo para crear
SELECT CNFG2
LOCATE FOR CNFG2.CodOpe=oSn2.CodOpe AND INLIST(CodCfg,'VTA','CMP','HON')
XsCtaBase = CNFG2.CtaBase
** VETT  25/05/2017 10:12 AM : NO existe configuracion para esta operacion en Variables Generales de Contabilidad ADMTCNFG
IF VARTYPE(XsCtaBase) <> 'C' OR EMPTY(XsCtaBase) 
	XsCtaBase = ["XX","YY"] 
ENDIF
** VETT  25/05/2017 10:12 AM :  FIN
LOCAL  LnRegAct as Integer ,  LlNoExisteDoc AS Boolean 
LlNoExisteDoc = .T.
SELECT rmov
LnRegAct = IIF(EOF() OR EOF(),0, RECNO() )
DO CASE
	CASE INLIST(oSn2.CodCta,'12','42') AND INLIST(oSn2.Afecto,'A','G')
		IF XiCodMon=1
			LsForImport = [Import=ROUND(oSn2.Import*(1+gosvrcbd.xfporigv/100),2)]
		ELSE
			LsForImport = [ImpUsa=ROUND(oSn2.ImpUsa*(1+gosvrcbd.xfporigv/100),2)]
		ENDIF
	CASE INLIST(oSn2.CodCta,'12','42')	AND INLIST(oSn2.Afecto , 'I','N')
		IF XiCodMon=1
			LsForImport = [Import=oSn2.Import]
		ELSE
			LsForImport = [ImpUsa=oSn2.ImpUsa]
		ENDIF
	CASE INLIST(CodCta,&XsCtaBase) AND INLIST(oSn2.Afecto,'A','G')
		IF XiCodMon=1
			LsForImport = [Import=ROUND(oSn2.Import*(1+gosvrcbd.xfporigv/100),2)]
		ELSE
			LsForImport = [ImpUsa=ROUND(oSn2.ImpUsa*(1+gosvrcbd.xfporigv/100),2)]
		ENDIF
	OTHERWISE 
		IF XiCodMon=1
			LsForImport = [Import=oSn2.Import]
		ELSE
			LsForImport = [ImpUsa=oSn2.ImpUsa]
		ENDIF
	
		
ENDCASE 

SET ORDER TO rmov10
SEEK XsCodOpe + oSn2.NroDoc
SCAN WHILE CodOpe+NroDoc=XsCodOpe + oSn2.NroDoc
	IF  CodCta=oSn2.CodCta AND CodDoc=PADR(oSn.tipdoc,LEN(RMOV.CodDoc)) AND ; 
					TpoMov=oSn2.TpoMov  AND ;
				  &LsForImport AND ; 
				  (NroAst<>oSn2.NroAst OR (NroAst=oSn2.NroAst AND oSn2.NroReg=RECNO()))
				  
		LlNoExisteDoc = .f.
		EXIT
	ENDIF
ENDSCAN
IF !LlNoExisteDoc 
	=MESSAGEBOX("Este documento ya fue ingresado en: " + SUBSTR(Rmov.NroAst,1,2)+"-"+SUBSTR(Rmov.NroAst,3),0+48,'ATENCION!!!!')
	LlNoExisteDoc = .F.
ENDIF
SET ORDER TO rmov01
IF LnRegAct >0
	GO LnRegAct
ENDIF

RETURN LlNoExisteDoc 

****************
FUNCTION vTipRef
****************
LsVar=oSn2.TipRef
lValido=F1_busca(@LsVar,[Codigo],[TABL],[TABL],[SN],.t.,[])
IF lValido
	oSn2.TipRef = LsVar
	XsNombre4=IIF(EMPTY(oSn2.TipRef),'',LEFT(TABL.Nombre,30))
	@07,22 say oSn.TipDoc
	@07,25 say XsNomBre4 PICT "@S10"
ELSE
	sErr = [Codigo de documento invalido]
ENDIF
RETURN lValido
***************************
FUNCTION TraerCuentaxCodMon  && Buscamos la cuenta en la moneda especificada
***************************
PARAMETERS __CodCta,__CodMon
=SEEK(__CodCta,'CTAS')
IF __CodMon=1
	LsforMon='CTAS.CODMON<>0' 
ELSE
	LsforMon='.T.' 			
ENDIF	
IF CTAS.PidAux='S'	AND CTAS.ClfAux=GsClfCli AND __CodMon<>CTAS.CodMon AND EVALUATE(LsForMon)
	LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
	LsWhere = "LEFT('"+__CodCta+"',3)"
	LoDatAdm.gencursor('c_ctaCmp','cbdmctas','CTAS01','','',"pidaux='S' AND codmon>1 AND CodCta="+LsWhere)
	IF _TALLy>0
		__CodCta = c_CtaCmp.CodCta
	ENDIF
	USE IN c_CtaCmp
	RELEASE LoDatAdm
ENDIF

RETURN __CodCta

***********************
**  VETT 2009-07-02
***********************
PROCEDURE CopiarAsiento  && Con este procedimiento podemos copiar un asiento en otro mes, operacion 
***********************
PARAMETERS PsNroMes,PsCodOpe,PsNroAst,PsNewMes,PsNewOpe,PsNewAst

**********************************
PROCEDURE Regeracion_Cuentas_Automaticas
**********************************
PARAMETERS LcOpcion
IF VARTYPE(LcOpcion)<>'C'
	LcOpcion ='S'
ENDIF
LcOpcion = UPPER(LcOpcion)
IF LcOpcion = 'S'
	LsLlavePro = XsNroMes+XsCodOpe
ELSE
	LsLlavePro = XsNroMes
ENDIF
GlRegenerAuto	= .T.
WAIT WINDOW 'Borrando cuentas de destino y contracuenta previamente grabadas automaticamente...' NOWAIT
SELECT  RMOV
SEEK LsLlavePro
DELETE REST WHILE NroMes+CodOpe = LsLlavePro FOR INLIST(EliItm , '*',':')
SELECT vmov
SEEK LsLlavePro
SCAN WHILE NroMes+CodOpe=LsLlavePro
	XsCodOpe = CodOpe
	XsNroAst = NroAst
	WAIT WINDOW "Regenerando >>>  Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" -" nowait
	NClave   = [NroMes+CodOpe+NroAst]
	VClave   = XsNroMes+XsCodOpe+XsNroAst
	RegVal   = "&NClave = VClave"
	XiCodMon = VMOV.CodMon
	XdFchAst = VMOV.FchAst 
	=RLOCK('VMOV')
	=SEEK(VMOV.CodOpe,'OPER','OPER01')
	WAIT WINDOW "Regenerando >>>  Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" \" nowait
	SELECT RMOV
	SEEK VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	DO  RenumItms WITH  1
	SEEK VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	SCAN WHILE NroMes+CodOpe+Nroast = VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst 
		=SEEK(RMOV.CodCta,'CTAS')
		LnNroRec1 = RECNO('RMOV')
		IF CTAS.GenAut='S'
			LcTipOpe = 'A'
			WAIT WINDOW "Regenerando >>>  Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" |" nowait			
				XsCodDiv = RMOV.CodDiv
				XsCtaPre = RMOV.CtaPre
				XsCodCta = RMOV.CodCta
				XsClfAux = RMOV.ClfAux
				XsCodAux = RMOV.CodAux
				XsCodRef = RMOV.CodRef
				XcTpoMov = RMOV.TpoMov
				XcAfecto = RMOV.Afecto
				XsCodCCo = RMOV.CodCco
				=SEEK(RMOV.CodCta,'CTAS')
				IF CTAS.PidAux = 'S'
					=SEEK(RMOV.ClfAux+RMOV.CodAux,'AUXI')		   
				ENDIF
				IF LcTipOpe = 'I'
					XsChkCta = SYS(2015) 
					XsAn1Cta = CTAS.An1Cta
					XsCC1Cta = CTAS.CC1Cta
				ELSE
					XsChkCta = IIF(!EMPTY(RMOV.ChkCta),RMOV.ChkCta,SYS(2015) )
				       XsAn1Cta = IIF(EMPTY(RMOV.An1Cta) AND CTAS.GENAUT='S' , CTAS.An1Cta,CTAS.An1Cta)
					XsCC1Cta = IIF(EMPTY(RMOV.CC1Cta) AND CTAS.GENAUT='S' , CTAS.CC1Cta,CTAS.Cc1Cta)
				ENDIF
				IF OPER.CodMon # 4
					XiCodMon = VMOV.CodMon
					XfTpoCmb = VMOV.TpoCmb
				ELSE
					XiCodMon = IIF(LcTipOpe='I',VMOV.CodMon,RMOV.CodMon)
					XfTpoCmb = IIF(LcTipOpe='I',VMOV.TpoCmb,RMOV.TpoCmb)
				ENDIF
				IF XiCodMon = 1
					XfImport = RMOV.Import
				ELSE
					XfImport = RMOV.ImpUsa
				ENDIF
				XfImpUsa    = RMOV.ImpUsa
				XfImpNac    = RMOV.Import
				IF INLIST(LcTipOpe,'A','C') 
					XiNroItm = RMOV.NroItm
				ELSE
					*** Determinamos el NroItm ***
					Local LsLLave_Reg
					LsLlave_Reg=RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst 
					XiNroItm = gosvrcbd.cap_nroitm(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst,'RMOV','nromes+codope+nroast')
				ENDIF
				XsGloDoc = RMOV.GloDoc
				XdFchDoc = RMOV.FchDoc
				XdFchVto = RMOV.FchVto
				XsCodDoc = RMOV.CodDoc
				XsNroDoc = RMOV.NroDoc
				XsNroRef = RMOV.NroRef
			*!*		XiCodMon = VMOV.CodMon
			*!*		XfTpoCmb = VMOV.TpoCmb
				XsIniAux = RMOV.IniAux
				XdFchPed = RMOV.FchPed
				xsnivadi = rmov.tpoo_c
				XcTipoC  = RMOV.TipoC
				XsNroRuc = RMOV.NroRuc
				XsTipDoc = iif(rmov.tipdoc=space(len(rmov.tipdoc)),[NO],rmov.tipdoc)
				xstipdoc1= iif(rmov.tipdoc=space(len(rmov.tipdoc)),[NO],rmov.tipdoc)
				xscodcta1= rmov.codcta
				xsnroref1= rmov.nroref
			     =Movbveri(XsNroMes+XsCodOpe+XsNroAst+STR(RMOV.NroItm,5),0,'','')
		ENDIF
		GO LnNroRec1 IN RMOV
		WAIT WINDOW "Regenerando >>>  Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" /" nowait			
	ENDSCAN
	SELECT RMOV
	SEEK VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	DO  RenumItms WITH  1
	SEEK VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
	XnTotItm=gosvrcbd.cap_nroitm(RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst,'RMOV','nromes+codope+nroast')
	SELECT VMOV
	REPLACE VMOV.NroItm WITH XnTotItm - 1
	DO MOVF3
	UNLOCK IN VMOV
	WAIT WINDOW "Regenerando >>>  Mes:"+Nromes+"  Oper:"+CodOpe+" Ast:"+NroAst+" -" nowait
ENDSCAN 
GlRegenerAuto	= .F.
WAIT WINDOW "Proceso terminado" nowait
RETURN 



