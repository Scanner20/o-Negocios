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
* M    Asiento generado autom�ticamente
* E    Estimado (no actualiza los acumulados contables)
***************************************************************************
PUSH KEY clear
#include const.h 	
STORE '' TO XsHola
GlInterface = .F.
GlModTpoCmb	= .F.
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
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XiCodMon,XfTpoCmb,XsNroVou,XsCodDiv,XsCtaPre,XnCodAst
********* Detalle
**OJO* Estas variables son las que se definian en la rutina que llamaba a la libreria DBROWSE o F1Browse
**OJO* Las definimos aqui para poder reutilizar la mayoria del codigo de grabacion de el detalle e 
**OJO* integrarlo con el formulario
STORE '' TO NCLAVE,VCLAVE,REGVAL
STORE '' to XsCodCta,XsClfAux,XsCodAux,XsCodPrv,XsNomPrv,XsRefPrv,XsIniAux,XsCodRef,XsCodRef ,xsglodoc,XdFchDoc
STORE '' to XdFchVto,XdFchPed ,xsnivadi,XsCodDoc,XsNroDoc,XsNroRef ,XSCODFIN,XcTpoMov,XfImport ,XfImpNac,XfImpUsa
STORE '' to XiNroitm, XcTipoC,XsNroRuc,XsTipDoc,xstipdoc1,xscodcta1,xsnroref1,xstipori,xsnumori,xsfecori,xsimpori
STORE '' to xsnumpol,xsimpnac1,xsimpnac2,XsNroDtr,XdFchDtr
STORE '' TO XsCodCco,XsAn1Cta,XsCC1Cta,XsChkCta,XsTipOri1,XsNumOri1,XsNroRec
STORE SPACE(1) TO XcAfecto
*********

***** Calculos de importes
STORE "" TO nImpNac,nImpUsa,cTitulo

XdFchAst = GdFecha
XfTpoCmb = 1.00
XnCodAst = 1
XlAstAut = .F.
IF !MOVApert()
	MESSAGEBOX('Error en apertura de tablas de la base de datos',16 ,'Acceso a datos')
	RETURN
ENDIF
** **
SELE CNFG
SEEK "01" 
XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.08)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.06)
** ** 
*STORE .f. TO oSn 

*** Buscando que operaciones puede tomar el usuario ***
SELECT OPER
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
DO FORM cbd_DiarioGeneral
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
	DO MOVSlMov               && Pide el c�digo de operaci�n a ingresar
	IF UltTecla = K_Esc
		EXIT
		RETURN
	ENDIF
	IF XsCodOpe = "9"
		GsMsgErr = "SOLO PARA MOVIMIENTOS EXTRA CONTABLES DE CAJA"
		=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
					LOOP
				ENDIF
				IF FlgEst = "C"
					GsMsgErr = "Asiento Cerrado, no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
					IF ! Clave(CFGPasswD)
						LOOP
					ENDIF
				ENDIF
				IF ! INLIST(FlgEst,"C"," ","R","G")
					GsMsgErr = "Asiento, no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
					LOOP
				ENDIF
				DO MOVBorra
			CASE UltTecla = F1  .AND. FlgEst = "A"   && Borrado Definitivo
				IF ! Modificar
					GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
					LOOP
				ENDIF
				IF ! Clave(CFGPasswD)
					LOOP
				ENDIF
				DO MovBorra
			OTHER
				IF ! Modificar
					GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
					LOOP
				ENDIF
				IF Crear
					DO MovInVar
				ELSE
					IF FlgEst = "C"
						GsMsgErr = "Asiento Cerrado, no puede ser alterado"
						=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
						IF ! Clave(CFGPasswD)
							LOOP
						ENDIF
					ENDIF
					IF ! INLIST(FlgEst,"M","C"," ","R")
						GsMsgErr = "Asiento, no puede ser alterado"
						=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
LOCAL LReturOk

Modificar  = gosvrcbd.mescerrado(_mes)

LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LReturnOk=LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
lreturnok=LoDatAdm.abrirtabla('ABRIR','CBDRECEP','RECE','RECE01','')
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
** Pide Operaci�n **
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
				=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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

@ 5,0  SAY "�"
@ 5,1  TO  5,49
@ 5,79 SAY "�"

@ 0,50 SAY "�"
@ 1,50 TO 5,50
@ 5,50 SAY "�"

@ 3,0 SAY "�"
@ 3,1 TO  3,49 COLOR SCHEME 7
@ 3,50 SAY "�"


@ 20,0  SAY "�"
@ 20,1 TO 20,78
@ 20,79 SAY "�"

@ 1,1 SAY PADR(" COMPA�IA  : "+GsCodCia+" "+GsNomCia,49) COLOR SCHEME 7
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

@ 7,0  SAY "�"
@ 7,1  TO  7,78
@ 7,79 SAY "�"
@ 8,1  SAY "       CUENTA                             FECHA                T                " COLOR SCHEME 7
@ 9,1  SAY "   DV CONTABLE AUXILIAR  PROVISION        VCMTO.  GLOSA        M        IMPORTE " COLOR SCHEME 7

@ 10,0  SAY "�"
@ 10,1  TO  10,78
@ 10,79 SAY "�"
RETURN

*-------------------------------------------------------------------------------
* Procedimiento de Lectura de llave
*-------------------------------------------------------------------------------
PROCEDURE MovNoDoc
i = 1
IF Crear
	XsNroAst = NROAST()
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
					GsMsgErr = "No pudo generar asiento de recepci�n"
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
					GsMsgErr = "No pudo generar asiento de recepci�n"
					=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
			GsMsgErr = "No existe el N� de asiento "+XsNroAst
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
			GsMsgErr = "No existe el N� de asiento "+XsNroAst
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
		IF XsNroAst < NROAST()
			SEEK LLave
			IF ! FOUND() .AND. INLIST(UltTecla,CtrlW,Enter)
				Crear = .t.
			ENDIF
			IF ! FOUND()
				GsMsgErr = "No existe el N� de asiento "+XsNroAst
				MESSAGEBOX(GsMsgerr,16,'ATENCION')
				UltTecla = 0
			ELSE
				IF VMOV.FlgEst = "A"
					GsMsgErr = "N� de asiento "+XsNroAst+ " esta ANULADO"
					MESSAGEBOX(GsMsgerr,16,'ATENCION')
					UltTecla = 0
				ENDIF
			ENDIF
		ENDIF
ENDCASE
IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
	XsNroAst = NROAST()
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
RETURN

************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
do MovMover
LinAct = 11
IF VMOV.FlgESt = "A"

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
		SCATTER memvar
		m.NroReg = RECNO()	
		m.Nomcta = Ctas.NomCta
		m.NomAux = AUXI.NomAux
		m.PidAux = CTAS.PidAux
		m.PidDoc = Ctas.PidDoc
		m.PidGlo = Ctas.PidGlo
		m.GenAut = CTAS.GenAut
		m.DesDoc = TABL.NomBre		
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
XsNroRec = VMOV.NroRec
XsDigita = VMOV.Digita
RETURN

************************************************************************** FIN
* Procedimiento de edita las variables de cabecera
******************************************************************************
PROCEDURE MOVEdita
UltTecla = 0
IF ! Crear
	IF .NOT. RLock()
		GsMsgErr = "Asiento usado por otro usuario"
		=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
		=MESSAGEBOX(cDesErr,16,'Error de creaci�n')
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
	=NROAST(XsNroAst)
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
REPLACE VMOV.NroRec  WITH XsNroRec
REPLACE VMOV.CodMon  WITH XiCodMon
REPLACE VMOV.TpoCmb  WITH XfTpoCmb
REPLACE VMOV.NotAst  WITH XsNotAst
REPLACE VMOV.Digita  WITH GsUsuario
Crear = .F.
RETURN

******************************************************************************
*  Prop�sito     : Procedimientos de browse (Ingresos de Cuentas)
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
		* - Todos los registros son v�lidos.
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
	CASE i = 'CTAPRE' AND gocfgcbd.tipo_empre = 3	
		SELECT PPRE
	CASE i = 'CODDIV' AND gocfgcbd.tipo_conso = 2
		SELECT AUXI	
        SEEK [DV ]+XsCodDiv
        IF !FOUND()
			GsMsgErr = [Codigo de divisionaria invalido]
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla=0
			RETURN .F.
		ENDIF
	CASE i = 'CODCTA'        && C�digo de Cuenta
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
		IF CTAS.AFTMOV#"S"
			GsMsgErr = "Cuenta no Afecta a movimiento"
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ENDIF
		IF Ctas.PidAux='S'	
			SELECT TABL
			XsTabla = "01"
			IF EMPTY(CTAS.CLFAUX) 
				GsMsgErr = " Invalida Configuraci�n de Cuenta. No registro la clasificaci�n del auxiliar"
				=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
				UltTecla = 0
				RETURN .F.	
			ELSE
				XsClfAux = CTAS.ClfAux
			ENDIF
			SEEK XsTabla+XsClfAux
			IF ! FOUND()
				GsMsgErr = " Invalida Configuraci�n de Cuenta. No registro la clasificaci�n del auxiliar"
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
	CASE i = 'CODAUX' .AND. CTAS.PidAux = [S]
		SELECT TABL
		XsTabla = "01"
		IF EMPTY(CTAS.CLFAUX)
			GsMsgErr = " Invalida Configuraci�n de Cuenta. No registro la clasificaci�n del auxiliar"
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ELSE
			XsClfAux = CTAS.ClfAux
		ENDIF
		SEEK XsTabla+XsClfAux
		IF ! FOUND()
			GsMsgErr = " Invalida Configuraci�n de Cuenta. No registro la clasificaci�n del auxiliar"
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
			GsMsgErr = 'C�digo de auxiliar invalido'
			=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN .F.	
		ENDIF
		replace c_RMOV.NomClf WITH TABL.Nombre	
		replace c_rmov.Nomaux WITH Auxi.NomAux
	CASE i = 'CODAUX' .AND. CTAS.PidAux # [S]
		XsClfAux = SPACE(LEN(C_RMOV.CLFAUX))
		XsCodAux = SPACE(LEN(C_RMOV.CODAUX))
		replace c_RMOV.NomClf WITH ''
		replace c_rmov.Nomaux WITH ''
	CASE i = 'CODDOC' 	 
		LlFound= SEEK('SN'+XsCodDoc,'TABL','TABL01')
		IF !LlFound  && AND !EMPTY(XsCodDoc)
			GsMsgErr = 'Codigo de documento inv�lido'
	        =MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
			UltTecla = 0
			RETURN LlFound
		ENDIF
		REPLACE C_Rmov.DesDoc WITH TABL.NomBre
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
		XfTpoCmb = ROUND(XfImpNac/XfImpUsa,4)	
		replace c_rmov.TpoCmb WITH  XfTpoCmb
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
		IF C_rmov.tip_Afe_RC='A' OR C_rmov.tip_Afe_RV='A'
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
* Objeto : Verificar si debe generar cuentas autom�ticas
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
LlAfe_REG_CMP_VTA_RET = (CTAS.TIP_AFE_RC='A') OR (CTAS.TIP_AFE_RV='A') OR (CTAS.TIP_AFE_RT='A')
IF CTAS.GenAut <> "S" 
	IF ! LlCreaDeta
		*** anulando cuentas autom�ticas anteriores ***
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

*** VETT : 04/07/2005
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
	*** CASO 1 : La cuentas automaticas no estan en predefinidas en el maestro de cuentas
	***   Con regla para generar la contrcuenta
	CASE EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)  AND !(ctas.CodCta>='60' AND ctas.CodCta<='99' AND CTAS.TpoCta=3) AND !CTAS.TIP_AFE_RC='A'
		*** Variante 1 : Utiliza la cuenta automatica para acumular otro auxiliar: EJEM; el tipo de gasto
		TsClfAux = GsClfTgt   && Tipo de gasto
		TsCodAux = CTAS.TpoGto
		TsAn1Cta = RMOV.CodAux
		TsCC1Cta = CTAS.CC1Cta
		TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
		** Verificamos su existencia **
		IF ! SEEK(GsClfCct+TsAn1Cta,"AUXI")
			GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
			RETURN 2
		ENDIF
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
				GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
		        =MESSAGEBOX(GsMsgErr,16,'Atenci�n')
				RETURN 2
			ENDIF
		ENDIF
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
		GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
		=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
		GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
		=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
		RETURN 2
	ENDIF
ENDIF
*****
IF !EMPTY(TsAn1Cta) 
	DO CompBrows WITH .F.
	SKIP
	LlCrearDeta = .T.
	IF RMOV.ChkCta==LsChkCta .AND. &RegVal
		LlCrearDeta  = .F.
	ENDIF
	** Grabando la primera cuenta autom�tica **
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
	IF RMOV.ChkCta==LsChkCta .AND. &RegVal
		LlCrearDeta  = .F.
	ENDIF
	** Grabando la segunda cuenta autom�tica **
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
=SEEK(LsCodCta_ORI,'CTAS')
DO CASE
	CASE CTAS.TIP_AFE_RC='A'
		XsCodCta=LsCodCta_ORI
		XcTpoMov=LcTpoMov_ORI		
		TsAn1Cta=CTAS.AN2CTA
		TsCC1Cta=CTAS.CC2CTA
		IF ! SEEK(TsAn1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
			RETURN
		ENDIF
		IF ! SEEK(TsCC1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
			RETURN 2
		ENDIF
		SKIP
		LlCrearDeta  = .T.
		IF RMOV.ChkCta==LsChkCta .AND. &RegVal
			LlCrearDeta  = .F.
		ENDIF
		** Grabando la segunda cuenta autom�tica **
		IF LlCrearDeta 
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsCC1Cta
		XcEliItm = ''
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = SPACE(LEN(RMOV.ClfAux))
		XsCodAux = SPACE(LEN(RMOV.CodAux))
		XfImport = ROUND(XfImport_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		XfImpNac = ROUND(XfImpNac_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		XfImpUsa = ROUND(XfImpUsa_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		=MOVbGrab(LlCrearDeta)
		SKIP
		LlCrearDeta = .T.
		IF RMOV.ChkCta==LsChkCta .AND. &RegVal
			LlCrearDeta  = .F.
		ENDIF
		** Grabando la primera cuenta autom�tica **
		IF LlCrearDeta 
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsAn1Cta
		IF XiCodMon=1
			LsforMon='CTAS.CODMON<>0' 
		ELSE
			LsforMon='.T.' 			
		ENDIF	
		=SEEK(XsCodCta,'CTAS')
		IF CTAS.PidAux='S'	AND CTAS.ClfAux=GsClfPro AND XiCodMon<>CTAS.CodMon AND EVALUATE(LsForMon)
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
		ENDIF
		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux
		XfImport = ROUND(XfImport_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
		XfImpNac = ROUND(XfImpNac_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
		XfImpUsa = ROUND(XfImpUsa_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
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
			XsTipOri1 = oSn.TipOri
			XsNumOri1 = oSn.NumOri
		ENDIF	
		=MOVbGrab(LlCrearDeta)
	CASE CTAS.TIP_AFE_RV='A'
		XsCodCta=LsCodCta_ORI
		XcTpoMov=LcTpoMov_ORI		
		TsAn1Cta=CTAS.AN2CTA
		TsCC1Cta=CTAS.CC2CTA
		IF ! SEEK(TsAn1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
			RETURN
		ENDIF
		IF ! SEEK(TsCC1Cta,"CTAS")
			GsMsgErr = "Cuenta Autom�tica no existe. Actualizaci�n queda pendiente"
			=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
			RETURN 2
		ENDIF
		SKIP
		LlCrearDeta  = .T.
		IF RMOV.ChkCta==LsChkCta .AND. &RegVal
			LlCrearDeta  = .F.
		ENDIF
		** Grabando la segunda cuenta autom�tica **
		IF LlCrearDeta 
			XiNroItm = XiNroItm + 1
		ELSE
			XiNroItm = NroItm
		ENDIF
		IF LlCrearDeta  .AND. NroItm <= XiNroitm
			DO  RenumItms WITH XiNroItm + 1
		ENDIF
		XsCodCta = TsCC1Cta
		XcEliItm = ''
		XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
		XsClfAux = SPACE(LEN(RMOV.ClfAux))
		XsCodAux = SPACE(LEN(RMOV.CodAux))
		XfImport = ROUND(XfImport_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		XfImpNac = ROUND(XfImpNac_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		XfImpUsa = ROUND(XfImpUsa_ORI * IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100),2) 
		=MOVbGrab(LlCrearDeta)
		SKIP
		LlCrearDeta = .T.
		IF RMOV.ChkCta==LsChkCta .AND. &RegVal
			LlCrearDeta  = .F.
		ENDIF
		** Grabando la primera cuenta autom�tica **
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
		IF CTAS.PidAux='S'	AND CTAS.ClfAux=GsClfCli AND XiCodMon<>CTAS.CodMon AND EVALUATE(LsForMon)
			LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
			LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
			LsWhere = "LEFT('"+XsCodCta+"',3)"
			LoDatAdm.gencursor('c_ctaCmp','cbdmctas','CTAS01','','',"pidaux='S' AND codmon>1 AND CodCta="+LsWhere)
			IF _TALLy>0
				TsCC1Cta = c_CtaCmp.CodCta
				XsCodCta = TsCC1Cta
			ENDIF
			USE IN c_CtaCmp
			RELEASE LoDatAdm
		ENDIF
		XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
		XsClfAux = TsClfAux
		XsCodAux = TsCodAux
		XfImport = ROUND(XfImport_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
		XfImpNac = ROUND(XfImpNac_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
		XfImpUsa = ROUND(XfImpUsa_ORI * (1 + IIF(INLIST(XcAfecto,'N','I'),0,GoSvrCbd.XfPorIgv/100)),2) 
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
			XsTipOri1 = oSn.TipOri
			XsNumOri1 = oSn.NumOri
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
REPLACE RMOV.NroRef WITH XsNroRef
REPLACE RMOV.CODFIN WITH XSCODFIN
REPLACE RMOV.FchDoc WITH XdFchDoc
REPLACE RMOV.FchVto WITH XdFchVto
REPLACE RMOV.IniAux WITH XsIniAux
REPLACE RMOV.NroRuc WITH XsNroRuc
REPLACE VMOV.ChkCta WITH VMOV.ChkCta+VAL(TRIM(XsCodCta))
REPLACE VMOV.ChkCta WITH XnCodAst
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
if !empty(rmov.fchped) AND USED('DIAF')
	repla rmov.fchped with iif(seek(dtos(rmov.fchped),[diaf]),diaf.fchven,rmov.fchped)
endif
replace rmov.tpoo_c with xsnivadi
REPLACE RMOV.TipoC  WITH XcTipoC
REPLACE RMOV.Tipdoc WITH Xstipdoc
REPLACE RMOV.An1Cta WITH XsAn1Cta
REPLACE RMOV.CC1Cta WITH XsCc1Cta
REPLACE RMOV.ChkCta WITH XsChkCta
REPLACE RMOV.CodAst WITH XnCodAst
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
* Complemento del db_Brows para cuentas autom�ticas
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
IF ( ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) >=.01 ) .AND. ( ABS(VMOV.DbeUsa-VMOV.HbeUsa) <=XfDif_MN ) );
  .OR.  ( ( ABS(VMOV.DbeNac-VMOV.HbeNac) >=.01 ) .AND. ( ABS(VMOV.DbeNac-VMOV.HbeNac) <=XfDif_ME ) )
	DO MOVF3
ENDIF
lDesBal = ( ABS(VMOV.HbeUsa-VMOV.DbeUsa) >.01 ) .or. ( ABS(VMOV.HbeNac-VMOV.DbeNac) >.05 )
IF lDesBal
	IF messageBox("Asiento Desbalanceado",4+32+256)=7 
		Fin = No
		Sigue = Si
	ENDIF
ENDIF

IF Sigue = No .AND. ! lDesBal
	DO IMPRVOUC
ENDIF
RETURN

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
@  3,14 SAY  'Teclas de Selecci�n :                              ' COLOR SCHEME 7
@  4,14 SAY  '   Cursor Arriba ....... Retroceder un Registro    ' COLOR SCHEME 7
@  5,14 SAY  '   Cursor Abajo  ....... Adelentar un Registro     ' COLOR SCHEME 7
@  6,14 SAY  '   Home          ....... Primer Registro           ' COLOR SCHEME 7
@  7,14 SAY  '   End           ....... Ultimo Registro           ' COLOR SCHEME 7
@  8,14 SAY  '   PgUp          ....... Retroceder en Bloque      ' COLOR SCHEME 7
@  9,14 SAY  '   PgDn          ....... Adelantar en Bloque       ' COLOR SCHEME 7
@ 10,14 SAY  'Teclas de Edici�n :                                ' COLOR SCHEME 7
@ 11,14 SAY  '   Enter         ....... Modificar el Registro     ' COLOR SCHEME 7
@ 12,14 SAY  '   Del  (Ctrl G) ....... Anular el Registro        ' COLOR SCHEME 7
@ 13,14 SAY  '   Ins  (Ctrl V) ....... Insertar un  Registro     ' COLOR SCHEME 7
@ 14,14 SAY  '                                                   ' COLOR SCHEME 7
@ 15,14 SAY  '   F1            ....... Pantalla Actual de Ayuda  ' COLOR SCHEME 7
@ 16,14 SAY  '   F3            ....... Renumerar Items           ' COLOR SCHEME 7
@ 17,14 SAY  '   F5            ....... Impresi�n del Asiento     ' COLOR SCHEME 7
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
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
**** Recalculando Importes ****
T_Itms =0
Chqado =0
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
endif
SELE CNFG
SEEK "01" 
XsCodCta1=CodCta1
XsCodCta2=Codcta2
XsCodaux1=CodAux1
XsCodAux2=CodAux2
XfDif_ME = Dif_ME
XfDif_MN = Dif_MN
* AJUSTA DESCUADRE POR DIFERENCIAS DE CAMBIO ENTRE  [ 0.01 , 0.05 ]
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=XfDif_ME
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=XfDif_MN
**XcEliItm    = "�"   && Marca de grabaci�n autom�tica
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
_Fontsize = 6
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
Largo    = 66
LinFin   = Largo - 5
Ancho    = 153
numpag  = 0
En1 =[]
En2 =[]
En3 =[]
En4 =[]
En5 = "********** ************** ***************************** ******** ************************************************ ****************** ******************"
En6 = "COD.                             D O C U M E N T O      CUENTA                                                                                         "
En7 = "AUXI-       N�            ***************************** CONTAB               D E S C R I P C I O N                    C A R G O S         A B O N O S  "
En8 = "LIAR       REFERENCIA     Tpo   No.            VENCTO.                                                                                                 "
En9 = "********** ************** *** ************** ********** ******** ************************************************ ****************** ******************"
*      1234567890 12345678901234 123 12345678901234 1234567890 12345678 123456789012345678901234567890123456789012345678
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-1234567890
*                1         2         3         4         5         6         7         8         9         0         1         2         3
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
			@ NumLin,12  SAY NroRef
			@ NumLin,26  SAY CodDoc
			@ NumLin,30  SAY NroDoc
			IF ! EMPTY(FchVto)
				@ NumLin,45  SAY FchVto
			ENDIF
			@ NumLin,56  SAY CodCta
			=SEEK(ClfAux+CodAux,"AUXI")
			DO CASE
				CASE ! EMPTY(RMOV.Glodoc)
					LsGlodoc = LEFT(RMOV.GloDoc,50)
				CASE ! EMPTY(VMOV.NotAst)
					LsGlodoc = LEFT(VMOV.NotAst,50)
				OTHER
					LsGlodoc = LEFT(AUXI.NOMAUX,50)
			ENDCASE
			IF RMOV.CodMon <> 1
				LsImport = 'US$' + ALLTRIM(STR(ImpUsa,14,2))
				IF RIGHT(LsImport,3)=".00"
					LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
				ENDIF
				LsGloDoc = LEFT(LsGloDoc,50-LEN(LsImport))+LsImport
			ENDIF
			@ NumLin,65  SAY LsGloDoc PICT "@S50"
			DO CalImp
			IF TpoMov='D'
				@ NumLin,116 SAY nImpNac PICT "999,999,999.99"
				nDbe = nDbe + nImpNac
			ELSE
				@ NumLin,135 SAY nImpNac PICT "999,999,999.99"
				nHbe = nHbe + nImpNac
			ENDIF
		ENDIF
		SKIP
	ENDDO
	IF Prow() > (Largo - 10)
		DO MovMemb
	ENDIF
	NumLin = PROW() + 2
	@ NumLin,80  SAY _Prn7a+"TOTALES"+_Prn7B font _FontName,_FOntSize Style 'B'  
	@ NumLin,0  SAY [ ]
	@ NumLin,116 SAY _Prn6a
	@ NumLin,116 SAY nDbe PICT "999,999,999.99" font _FontName,_FontSize style 'B'
	@ NumLin,135 SAY nHbe PICT "999,999,999.99" font _FontName,_FontSize style 'B'
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
	@ NumLin,80  SAY "VAN ......"
	@ NumLin,116 SAY nDbe PICT "999,999,999.99"
	@ NumLin,135 SAY nHbe PICT "999,999,999.99"
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
	@ NumLin,80  SAY "VIENEN ..."
	@ NumLin,116 SAY nDbe PICT "999,999,999.99"
	@ NumLin,135 SAY nHbe PICT "999,999,999.99"
ENDIF
RETURN
**********************************************************************
PROCEDURE MovIPie
*****************
NumLin = Largo - 7
Pn1 = "   PREPARADO        REVISADO        GERENCIA                                             _________________________________________________________________"
Pn2 = "                                                                                                                  Recibi Conforme                         "
Pn3 = "                                                                                                                                                          "
Pn4 = "_______________ _______________ _______________                                          L.E. /L.T. No : _________________________________________________"
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
wait window [Actualizando Informaci�n .....] nowait
sele vmov
llave = xsnromes+xscodope+xsnroast
seek llave
if !found()
	tsnroast = xsnroast
	wait window [Grabando en Asiento N�: ]+tsnroast+[ CodOpe : ]+pscodope+[...] nowait
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
	wait window [Grabando en Asiento N�: ]+tsnroast+[ CodOpe : ]+pscodope+[...] nowait
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
	MsgErr = [C�digo de Operaci�n No Existe....]
	return .f.
endif
return .t.

******************
procedure registro
******************
do while !rlock()
enddo
return

*******************
procedure dat_sunat
*******************
RESTORE MACROS FROM ADMCONFG
IF VARTYPE(oSn)<>'O'
	PUBLIC oSn as Object 
	SELECT DRMOV
	SCATTER name oSn blank
ENDIF
IF VARTYPE(oSn2)<>'O'
	PUBLIC oSn2 as Object 
	SELECT RMOV 
	SCATTER name oSn2 blank
ENDIF	
SELECT c_rmov
LnCurRec = RECNO()
LsCurChk = ChkCta
LOCATE FOR INLIST(CodCta,'12','42') AND ChkCta=LsCurChk
IF FOUND()
	oSn2.ClfAux	= IIF(EMPTY(c_rmov.ClfAux),oSn2.ClfAux,c_rmov.ClfAux)
	oSn2.NroRuc = IIF(EMPTY(c_rmov.CodAux),oSn2.NroRuc,c_rmov.CodAux)
	oSn2.IniAux = IIF(EMPTY(c_rmov.CodAux),oSn2.IniAux,c_rmov.IniAux)
	oSn2.NroDoc	= IIF(EMPTY(c_rmov.NroDoc),oSn2.NroDoc,c_rmov.NroDoc)
	oSn2.FchDoc	= IIF(EMPTY(c_rmov.FchDoc),oSn2.FchDoc,c_rmov.FchDoc)
	oSn2.FchVto	= IIF(EMPTY(c_rmov.FchVto),oSn2.FchVto,c_rmov.FchVto)
	oSn2.NroMes	= IIF(EMPTY(c_rmov.NroMes),oSn2.NroMes,c_rmov.NroMes)
	oSn2.CodOpe	= IIF(EMPTY(c_rmov.CodOpe),oSn2.CodOpe,c_rmov.CodOpe)
	oSn2.NroAst	= IIF(EMPTY(c_rmov.NroAst),oSn2.NroAst,c_rmov.NroAst)
	oSn.TipDoc	= IIF(EMPTY(c_rmov.TipDoc),oSn.TipDoc,c_rmov.TipDoc)
	oSn2.NroRef	= IIF(EMPTY(c_rmov.NroDoc),oSn2.NroDoc,c_rmov.NroDoc)
	oSn2.NroDtr = IIF(EMPTY(c_rmov.NroDtr),oSn2.NroDtr,c_rmov.NroDtr)
	oSn2.FchDtr = IIF(EMPTY(c_rmov.FchDtr),oSn2.FchDtr,c_rmov.FchDtr)
	oSn.TipOri	= IIF(EMPTY(c_rmov.TipOri),oSn.TipOri,c_rmov.TipOri)
	oSn.NumOri	= IIF(EMPTY(c_rmov.NumOri),oSn.NumOri,c_rmov.NumOri)
ELSE
	IF EMPTY(XsNroRec)
		IF Oper.Siglas='RV'
			oSn2.ClfAux	= IIF(EMPTY(oSn2.ClfAux),GsClfCli,oSn2.ClfAux)
		ENDIF
		IF Oper.Siglas='RC'
			oSn2.ClfAux	= IIF(EMPTY(oSn2.ClfAux),GsClfPro,oSn2.ClfAux)
		ENDIF
	ELSE
		oSn.TipDoc = RECE.TpoDoc
		oSn2.ClfAux = RECE.ClfAux
		oSn2.NroRuc = RECE.CodAux
		oSn2.NroDoc = RECE.NroDoc
		oSn2.FchDoc = RECE.FchDoc
		oSn2.FchVto = RECE.FchVto
	ENDIF
ENDIF
IF LnCurRec>0
	GO LnCurRec
ENDIF
sErr = ''
DO CASE
	CASE xscodope = [070] .and. left(xscodcta,2) = '40' && Importaciones
		cTit1 = 'Datos de importaci�n'   
		DEFINE WINDOW sunat FROM 14,20 to 20,60 FLOAT GROW ;
			TITLE (cTit1) COLOR SCHEME 16
		ACTIVATE WINDOW sunat
		@ 00,01 say 'N� Poliza         =>'
		@ 01,01 say 'Total Importaci�n =>'
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
		read
	OTHERWISE
		cTit1 = 'Datos Adicionales'   
		DEFINE WINDOW sunat FROM 11,20 to 22,100 FLOAT GROW ;
			TITLE (cTit1) COLOR SCHEME 16
		ACTIVATE WINDOW sunat
		@ 00,01 SAY 'T.D.             ==>'
		@ 01,01 SAY 'Clasificaci�n    ==>'
		@ 02,01 say 'N� Ruc           ==>'
		@ 03,01 say 'Razon Social     ==>'
		@ 04,01 SAY 'N� Doc.          ==>'
		@ 05,01 SAY 'Fecha Documento  ==>'
		@ 06,01 SAY 'Fecha Vencimiento==>'
		@ 07,01 say 'Tipo Doc. Origen ==>'
		@ 08,01 say 'N� Doc. Detra.   ==>'
		@ 09,01 say 'Fec. Doc. Detra. ==>'
        *
		IF trim(xsclfaux) = GsClfCli
			oSn2.iniaux = iif(seek(xsclfaux+xscodaux,[auxi]),left(auxi.nomaux,20),space(len(rmov.IniAux)))
			oSn2.nroruc = iif(seek(xsclfaux+xscodaux,[auxi]),auxi.rucaux,space(11))
		ELSE
			oSn2.iniaux = iif(oSn2.iniaux=space(len(rmov.iniaux)),space(len(AUXI.NomAux)),oSn2.iniaux)
			oSn2.nroruc = iif(oSn2.nroruc=space(len(rmov.nroruc)),space(len(rmov.nroruc)),oSn2.nroruc)
		ENDIF
		@00,22 get oSn.tipdoc  valid vTipDoc()  ERROR serr
		@01,22 get oSn2.ClfAux  valid vClfAux() ERROR serr
		@02,22 get oSn2.nroruc pict '99999999999' valid  vNroRuc()  ERROR serr
		@03,22 get oSn2.iniaux pict '@!'
		@04,22 get oSn2.NroDoc pict '@R 999-99999999' valid vNroDoc() &&(oSn2.nroDoc<>space(len(rmov.nroDoc)))
		** Verificamos N�mero de documento existente **
		@05,22 get oSn2.FchDoc && valid (oSn2.fchdoc<>ctod(space(08)))
		@06,22 get oSn2.FchVto && valid (oSn2.fchVto<>ctod(space(08)))
		@08,22 get oSn2.NroDtr
		@09,22 get oSn2.FchDtr
		READ
		lvalidado=SEEK(oSn2.ClfAux+oSn2.nroruc,"auxi")
		IF lvalidado = .f.
			DO Nuevo_Ruc && PARA INGRESAR ruc POR SI NO EXISTE
		ENDIF
		IF oSn.NroRef <> space(10)
			oSn.NroRef = tran(val(left(oSn.nroref,3)),[@L 999])+;
                      tran(val(subs(oSn.nroref,4)),[@L 9999999])
			@ 04,22 get oSn.NroRef pict '@R 999-99999999'
			clear gets
		ENDIF
		IF INLIST(oSn.tipdoc,[07],[08])
			@07,22 get oSn.tipori  pict '99' && valid (xstipori$[01^08])
			@08,22 get oSn.numori  pict '@R 999-9999999' && valid (oSn.numori<>space(10))
			READ
			oSn.numori = TRANSFORM(val(left(oSn.numori,3)),[@L 999]) +;
                      TRANSFORM(val(subs(oSn.numori,4)),[@L 9999999])
		ELSE
			oSn.TipOri  = SPACE(LEN(drmov.tipori))
			oSn.NumOri  = SPACE(LEN(drmov.numori))
		ENDIF
ENDCASE
CLEAR macros
RELEASE WINDOW sunat
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
LsVar = oSn2.NroRuc
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
	@01,02 say [Ingrese N� O/C => ]
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

* ��������������������������������������������������������͸
* � Objetivo : Generaci�n del asiento contable Automatico  �
* ��������������������������������������������������������;
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
	=MESSAGEBOX(GsMsgErr,16,'Atenci�n')
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
Replace VMOV.NroRec WITH XsNroRec
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
PRIVATE XdFchAst,XsNotAst
XdFchAst = DATE()
XsNroVou = XsNroAst+[-]+RIGHT(DTOC(XdFchAst),2)
XsNotAst = DPRO.NOMAUX
REPLACE VMOV.FchAst  WITH XdFchAst
REPLACE VMOV.NroVou  WITH XsNroVou
REPLACE VMOV.NroRec  WITH XsNroRec
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
	ELSE
		XsChkCta = C_RMOV.ChkCta
	    XsAn1Cta = IIF(EMPTY(C_RMOV.An1Cta) AND CTAS.GENAUT='S' , CTAS.An1Cta,C_RMOV.An1Cta)
		XsCC1Cta = IIF(EMPTY(C_RMOV.CC1Cta) AND CTAS.GENAUT='S' , CTAS.CC1Cta,C_RMOV.CC1Cta)
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
Private Llave,RegAct1,Eof1,Saldo,SdoUsa,Order1,LcArcTmp
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
STORE 0 TO Saldo1,SdoUsa1
SEEK LLave
DO WHILE CodCta+CodAux+NroDoc = LLave AND !EOF()
	LsNroDoc =NroDoc
	Llave2 = CodCta+CodAux+NroDoc
	Saldo  = 0
	SdoUsa = 0
	m.TpoMovProv = IIF(INLIST(CodCta,'42','46'),'H',IIF(CodCta='12','D','H'))
	SCAN WHILE (CodCta+CodAux+NroDoc = Llave2) 
		=SEEK(CodCta,'CTAS')
		DO CASE 
			CASE Ctas.ClfAux = RMOV.ClfAux AND Ctas.PidDoc='S' AND CTAS.PidAux='S'
				IF Check_OpeProv(CodOpe)
					scatter memvar
					m.nrocta = iif(CodMon=1,'S/. '+tran(Import,'99,999,999.99'),'US$ '+tran(ImpUsa,'99,999,999.99'))
					m.TpoMovProv=TpoMov
				ENDIF
				Saldo  = Saldo  + IIF(TpoMov = m.TpoMovProv , 1 , -1)*Import
				SdouSA = SdouSA + IIF(TpoMov = m.TpoMovProv , 1 , -1)*ImpUsa
		endCase
	ENDSCAN
	IF abs(Saldo)>.01 OR abs(SdoUsa)>.01   && Esta pendiente
		m.Import = Saldo 
		m.ImpUsa = SdoUsa
		INSERT into CTACTE From MemVar
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
GlModTpoCmb = .T.
SELECT vmov
SEEK XsNroMes+XsCodOpe
SCAN WHILE NroMes+CodOpe=XsNroMes+XsCodOpe
	WAIT WINDOW "Mes:"+Nromes+"Operacion:"+CodOpe nowait
	XsNroAst = NroAst
	NClave   = [NroMes+CodOpe+NroAst]
	VClave   = XsNroMes+XsCodOpe+XsNroAst
	XiCodMon = VMOV.CodMon
	=SEEK(DTOS(FchAst),"TCMB")
	XfTpoCmb = iif(OPER.TpoCmb=1,TCMB.OFICMP,TCMB.OFIVTA)
	replace VMOV.TpoCmb WITH XfTpoCmb
	DO movf3
	SELECT VMOV
ENDSCAN 
GlModTpoCmb = .F.
RETURN 

****************
PROCEDURE CalImp
****************
PARAMETERS _ChkTpoCmb
IF _ChkTpoCmb
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

*******************
FUNCTION GenRegAuto
*******************
PARAMETERS _Siglas
LOCAL LsCtas1,LsCtas2,LsCursor
IF !SEEK(_Siglas,'CNFG')
	=MessageBox('No existe configuraci�n de asiento automatico para esta operaci�n ')
	RETURN .F.
ENDIF
LsCtas1 = CtaTota
LsCtas2 = CtaImpu
LsCursor = SYS(2015)
LcSql = "SELECT CodCta,ClfAux,Pidaux,TpoMov FROM ctas.aftmov='S' AND ctas.PidAux='S' AND Tip_Afe_rc='A' AND CTAS WHERE CodCta IN ("+LsCtas1+")"
LcSql = LcSql + " INTO CURSOR "+LsCursor

*******************
PROCEDURE Nuevo_Ruc
*******************
INSERT INTO auxi   (clfaux,codaux,nomaux,rucaux) ;
			VALUES (oSn2.ClfAux,oSn2.NroRuc,oSn2.IniAux,oSn2.NroRuc)
			
****************
FUNCTION vNroDoc
****************
*!* solo verificamos si documento existe solo para crear
SELECT rmov
SET ORDER TO rmov10
SEEK XsCodOpe + oSn2.NroDoc
IF FOUND()
	MESSAGEBOX("Este documento ya fue ingresado en: " + SUBSTR(Rmov.NroAst,3,2)+"-"+SUBSTR(Rmov.NroAst,5,4))
	RETURN .F.
ENDIF
SET ORDER TO rmov01
RETURN
