*******************************************************************************
*  Nombre        : CBD_DiarioGeneral.PRG    
*  Sistema       : Contabilidad
*  Proposito     : Ingresos al Diario General
*  Creacion		 : VETT Enero 1994
*  Actualizacion : VETT 11/06/1999
*  Actualizacion : VETT 11/09/2002  Migracion a Visual Foxpro 6 y 7
*****************************************************************************
* Flag
* A    Anulado
* R    Registrado en el sistema
* C    Documento Cerrado
* M    Asiento generado autom ticamente
* E    Estimado (no actualiza los acumulados contables)
***************************************************************************
STORE '' TO XsHola
#include const.h 	
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
STORE "" TO XsNroAst,XdFchAst,XsNotAst,XiCodMon,XfTpoCmb,XsNroVou,XsCodDiv
********* Detalle
**OJO* Estas variables son las que se definian en la rutina que llamaba a la libreria DBROWSE o F1Browse
**OJO* Las definimos aqui para poder reutilizar la mayoria del codigo de grabacion de el detalle e 
**OJO* integrarlo con el formulario
STORE '' TO NCLAVE,VCLAVE,REGVAL
STORE '' to XsCodCta,XsClfAux,XsCodAux,XsCodPrv,XsNomPrv,XsRefPrv,XsIniAux,XsCodRef,XsCodRef ,xsglodoc,XdFchDoc
STORE '' to XdFchVto,XdFchPed ,xsnivadi,XsCodDoc,XsNroDoc,XsNroRef ,XSCODFIN,XcTpoMov,XfImport ,XfImpNac,XfImpUsa
STORE '' to XiNroitm, XcTipoC,XsNroRuc,XsTipDoc,xstipdoc1,xscodcta1,xsnroref1,xstipori,xsnumori,xsfecori,xsimpori
STORE '' to xsnumpol,xsimpnac1,xsimpnac2
STORE '' TO XsCodCco
*********

***** Calculos de importes
STORE "" TO nImpNac,nImpUsa,cTitulo

XdFchAst = GdFecha
XfTpoCmb = 1.00
*RESTORE FROM CBDCONFG ADDITIVE
*!*	DO MOVgPant

IF !MOVApert()
	MESSAGEBOX('Error en apertura de tablas de la base de datos',16 ,'Acceso a datos')
	RETURN
ENDIF
*** Buscando que operaciones puede tomar el usuario ***
SELECT OPER
*!*	IF ! Master
   SET FILTER TO CODUSR = GsUsuario .OR. EMPTY(CODUSR)
   GOTO TOP
*!*	ENDIF
IF EOF()
   GsMsgErr = "Usuario no autorizado a registrar Operaciones"
   MESSAGEBOX(GsMsgErr,16,'Acceso denegado')
   RETURN
ENDIF
XsCodOpe = SPACE(LEN(OPER.CodOpe))
*!*	@ 4,1 SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
*!*	VAROpe = .T.
*!*	IF ! EOF()
*!*	   SKIP
*!*	ENDIF
*!*	IF EOF()
*!*	   VarOpe = .F.
*!*	ENDIF
UltTecla = 0
cTitulo =" - "+Mes(VAL(XsNroMes),3)+" "+TRANS(_ANO,"9999 ")
** Y la clase de contabilidad ???
SET CLASSLIB TO dosvr additive
**
do form cbd_DiarioGeneral
*** Tratare de reutilizar todo el codigo posible de este programa llamandolo desde el formulario
*** para evitar la demora en la conversion a interface Visual, lo contrario es colocar este codigo 
*** en metodos y definir que variables deben ser propiedades en el formulario ,pero exige tiempo de codificacion y
*** ya no tengo VETT 24/08/02
*-------------------------------------------------------------------------------
** Rutina Principal **
*-------------------------------------------------------------------------------
PROCEDURE Rutina_Principal    
DO WHILE (.T.)
   DO MOVSlMov               && Pide el c¢digo de operaci¢n a ingresar
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
      *
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
      *
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
*!*	   IF ! VAROpe
*!*	      EXIT
*!*	   ENDIF
ENDDO
RETURN

************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
PROCEDURE MOVAPERT
** Abrimos areas a usar **
LOCAL LReturOk

LReturnOk=goentorno.open_dbf1('ABRIR','CBDTCIER','','')
IF lReturnOk
	SELECT CBDTCIER
	RegAct = _Mes + 1
	Modificar = ! Cierre
	IF RegAct <= RECCOUNT()
	   GOTO RegAct
	   Modificar = ! Cierre
	ENDIF
	USE
ENDIF

LReturnOk=goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LReturnOk=goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV01','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
lreturnok=goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','')
** Archivo de Control de Documentos del Proveedor **
lreturnok=goentorno.open_dbf1('ABRIR','CJADPROV','DPRO','DPRO06','')
lreturnok=goentorno.open_dbf1('ABRIR','CJATPROV','PROV','PROV02','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDDRMOV','DRMOV','DRMO01','')
lopCTA2=.f.
lopDIAF=.f.
*
lexiste=.t.
lreturnok=goentorno.open_dbf1('ABRIR','FLCJTBDF','DIAF','DIAF01','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDMCTA2','CTA2','CTA201','')
lreturnok=goentorno.open_dbf1('ABRIR','CBDTCNFG','CNFG','CNFG01','')


RETURN lReturnOk

************************************************************************* FIN
* Procedimiento Pide el codigo de movimiento
******************************************************************************
PROCEDURE MOVSlMov
** Pide Operaci¢n **
SELECT OPER
UltTecla = 0
DO WHILE ! INLIST(UltTecla,k_Esc,F10,CtrlW,Enter)
   XsCodOpe = OPER->CodOPE
   XiCodOpe = VAL(XsCodOpe)
   @ 4,1 SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
   ***> do lib_mtec WITH 1
   @ 4,14 GET XiCodOpe PICT "@LZ ###" WHEN VarOpe
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F8
      IF CBDBUSCA("OPER")
         XsCodOpe = CodOpe
      ELSE
         LOOP
      ENDIF
   ELSE
      XsCodOpe = TRANSF(XiCodOPe,"@L ###")
   ENDIF
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
         IF !  XsCodOpe  =  OPER->CodOpe .OR. UltTecla = F8
            SEEK XsCodOpe
            IF ! FOUND()
            	GsMsgErr ='Codigo no existe'		
               =MESSAGEBOX(GsMsgErr,16,'Atención')
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
   ENDCASE
ENDDO
*
* VERIFICA SI ES UNA PROVISION PARA GRABAR FCHVTO EN FCHPED
*
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
*
@ 4,1 SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
Save Screen to ScrMov
RETURN

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
	XsNroAst = NROAST()
ENDIF


*!*	RESTORE SCREEN FROM ScrMov
*!*	Crear = .T.
*!*	** Posicionamos en el ultimo registro + 1 **
*!*	SELECT VMOV
*!*	IF OPER->TPOCOR = 1
*!*	   SEEK (XsNroMes+XsCodOpe+Chr(255))
*!*	ELSE
*!*	   SEEK (XsCodOpe+Chr(255))
*!*	ENDIF
*!*	IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
*!*	   GOTO RECNO(0)
*!*	ELSE
*!*	   GOTO BOTTOM
*!*	   IF ! EOF()
*!*	      SKIP
*!*	   ENDIF
*!*	ENDIF
*!*	UltTecla = 0
*****> do lib_mtec WITH 2
*!*	GsMsgKey = "[Esc]Salir [Enter]Edit. [PgUp]Ant. [PgDn]Sgte. [F9]Borrar [F1]Recupera [F7]Reclasf."
*!*	***> do lib_mtec WITH 99


*!*	DO WHILE ! INLIST(UltTecla,Enter,Escape)
*!*	   @ 1,68 say SPACE(LEN(XsNroAst)+2) 
*!*	   @ 1,68 GET XsNroAst PICT "@R99-99-9999"
*!*	   READ
*!*	   UltTecla = LASTKEY()
*!*	   IF UltTecla = Escape
*!*	      EXIT
*!*	   ENDIF
*!*	   IF UltTecla = F8 .OR. empty(XsNroAst)
*!*	      IF CBDBUSCA("VMOV")
*!*	         XsNroAst = VMOV->NroAst
*!*	      ELSE
*!*	         LOOP
*!*	      ENDIF
*!*	      UltTecla = Enter
*!*	   ELSE
*!*	     IF OPER->ORIGEN
*!*	        IF SUBSTR(XsNroAst,3) # XsNroMes
*!*	          UltTecla = 0
*!*	          GsMsgErr = "Invalido Registro"
*!*	          =MESSAGEBOX(GsMsgErr,16,'Atención')
*!*	          LOOP
*!*	        ENDIF
*!*	     ENDIF
*!*	   ENDIF
   SELECT VMOV
   Llave = (XsNroMes+XsCodOpe+XsNroAst)
   SEEK LLave
   ** Siempre me aseguro de si ya existe o no a pesar de que sea modificar o crear VETT  25/08/02
   Crear = ! FOUND()    
   DO CASE
*!*	   		OJO : Esta es una opcion de reclasificacion de asiento revisar e implementar VETT 25/08/02
*!*	         case UltTecla = F7 .and. inlist(xscodope,[019],[069])
*!*	              pscodope = xscodope
*!*	              define window codope from 15,20 to 20,60 double
*!*	              activate window codope
*!*	              msgerr = [.]
*!*	              sele oper
*!*	              @01,02 say 'Ingrese C¢digo Operativo=>' get pscodope pict '999';
*!*	                          valid (v_codope(pscodope)) error msgerr
*!*	              read
*!*	              if (ulttecla = Escape) .or. (xscodope = pscodope)
*!*	                 release window codope
*!*	                 loop
*!*	              endif
*!*	              *
*!*	              vrpta = 'N'
*!*	              @02,05 say 'Esta Seguro <S/N> ==> ' get vrpta pict '@!';
*!*	                          valid (vrpta$[SN])
*!*	              read
*!*	              release window codope
*!*	              *
*!*	              if vrpta = 'S'
*!*	                 do act_codope with pscodope
*!*	              else
*!*	                 loop
*!*	              endif
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
                   IF ( ( ABS(VMOV->DbeUsa-VMOV->HbeUsa) >=.01 ) .AND. ( ABS(VMOV->DbeUsa-VMOV->HbeUsa) <=.03 ) );
                     .OR.  ( ( ABS(VMOV->DbeNac-VMOV->HbeNac) >=.01 ) .AND. ( ABS(VMOV->DbeNac-VMOV->HbeNac) <=.05 ) )
                     REPLACE FLGEST WITH 'X'
                   ENDIF
                   UNLOCK IN DPRO
                   CREAR=.F.
                ENDIF
             CASE FOUND() AND FlgEst$"GX"
                DO ASTPROV
                SELE DPRO
                IF !Genero
                   REPLACE DPRO->FlgEst WITH "P"
                   UNLOCK IN DPRO
                   GsMsgErr = "No pudo generar asiento de recepci¢n"
                   =MESSAGEBOX(GsMsgErr,16,'Atención')
                   UltTecla = 0
                   LOOP
                ELSE
                   DO WHILE !RLOCK("DPRO")
                   ENDDO
                   REPLACE DPRO->FLGEST WITH 'G'
                   IF ( ( ABS(VMOV->DbeUsa-VMOV->HbeUsa) >=.01 ) .AND. ( ABS(VMOV->DbeUsa-VMOV->HbeUsa) <=.03 ) );
                     .OR.  ( ( ABS(VMOV->DbeNac-VMOV->HbeNac) >=.01 ) .AND. ( ABS(VMOV->DbeNac-VMOV->HbeNac) <=.05 ) )
                     REPLACE DPRO->FLGEST WITH 'X'
                   ENDIF
                   UNLOCK
                   CREAR=.F.
                ENDIF
              CASE !FOUND()
                && Actualizamos cuando grabamos
        ENDCASE
        SELE VMOV
        UNLOCK
*!*	      CASE UltTecla = Escape
*!*	         EXIT
*!*	      CASE UltTecla = 0
*!*	         LOOP
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
*!*	         IF ALRT("Anular este Documento")
*!*	            UltTecla = F9
*!*	            EXIT
*!*	         ENDIF
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
            IF VMOV->FlgEst = "A"
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
*!*	               RESTORE SCREEN FROM ScrMov
               Crear = .t.
            ENDIF
            IF ! FOUND()
	         	GsMsgErr = "No existe el Nº de asiento "+XsNroAst
	            MESSAGEBOX(GsMsgerr,16,'ATENCION')
	            UltTecla = 0
            ELSE
               IF VMOV->FlgEst = "A"
		         	GsMsgErr = "Nº de asiento "+XsNroAst+ " esta ANULADO"
		            MESSAGEBOX(GsMsgerr,16,'ATENCION')
		            UltTecla = 0
               ENDIF
            ENDIF
         ENDIF
        *IF Crear
        *   RESTORE SCREEN FROM ScrMov
        *   Crear = .t.
        *   EXIT
        *ENDIF
        *IF VMOV->FlgEst = "A" .AND. UltTecla = Enter
        *   DO LIB_MERR WITH 14
        *   UltTecla = 0
        *ENDIF
   ENDCASE
   IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
      XsNroAst = NROAST()
*!*	      RESTORE SCREEN FROM ScrMov
*!*	      ****> do lib_mtec WITH 2
*!*	      GsMsgKey = "[Esc]Salir [Enter]Edit. [PgUp]Ant. [PgDn]Sgte. [F9]Borrar [F1]Recupera [F7]Reclasf."
*!*	      ***> do lib_mtec WITH 99
      Crear = .t.
   ELSE
      XsNroAst = VMOV->NroAst
      DO MovPinta
      Crear = .f.
   ENDIF
  *DO MovPinta
*!*	ENDDO
*!*	@ 1,68 SAY XsNroAst PICT "@R 99-99-9999"
SELECT VMOV
RETURN

************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar
XsNroVou = SPACE(LEN(VMOV->NROVOU))
XiCodMon = 1
XsNotAst = SPACE(LEN(VMOV->NOTAST))
XsDigita = GsUsuario
RETURN

************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
*!*	@ 4,1 SAY " OPERACION : "+OPER->CodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
*!*	@ 1,68 SAY VMOV->NroAst PICT "@R99-99-9999"
*!*	@ 2,1  SAY PADR(" Usuario   : "+VMOV->Digita,49)             COLOR SCHEME 7
*!*	@ 2,68 SAY VMOV->FchAst
*!*	@ 3,68 SAY IIF(VMOV->CODMON=1,"S/.","US$")
*!*	@ 4,68 SAY TpoCmb PICT "9999.9999"
*!*	@ 5,68 SAY VMOV->NroVou
*!*	@ 6,18 SAY VMOV->NOTAST
do MovMover
LinAct = 11
*!*	@ LinAct,1 CLEAR TO 22,78
IF VMOV->FlgESt = "A"
*!*	   @ LinAct,0 say []
*!*	   @ ROW()  ,11 SAY "     #    #     # #     # #          #    ######  #######  "
*!*	   @ ROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
*!*	   @ ROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
*!*	   @ ROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
*!*	   @ ROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
*!*	   @ ROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
*!*	   @ ROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ELSE
	IF XsNroast='030002'
**		SET STEP ON 
	ENDIF
	*** Calateamos al temporal
	SELECT c_rmov
	ZAP
	*** Fin del calateo
   SELECT RMOV
   LsLLave  = XsNroMes+XsCodOpe+VMOV->NroAst
   SEEK LsLLave
   DO WHILE LsLLave = (NroMes+CodOpe+NroAst) .AND. ! EOF() && AND LinAct < 20
*!*	      Contenido = ""
*!*	      DO MOVBLine WITH Contenido
*!*	 	  @ LinAct,2 SAY Contenido
		SCATTER memvar
			
	  INSERT into c_rmov from memvar	
      LinAct = LinAct + 1
      SKIP
   ENDDO
*!*		20,1 TO 20,78
   DO MovPImp
*!*	   @ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
ENDIF
SELECT VMOV
RETURN

*******************************************************************************
* NUMERO DE ASIENTO CORRELATIVO POR ORIGEN
*******************************************************************************
FUNCTION NROAST
PARAMETER XsNroAst
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = OPER->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = OPER->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = OPER->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = OPER->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = OPER->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = OPER->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = OPER->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = OPER->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = OPER->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = OPER->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = OPER->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = OPER->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = OPER->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = OPER->NDOC13
   OTHER
     iNroDoc = OPER->NRODOC
ENDCASE

IF OPER->ORIGEN
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
        REPLACE   OPER->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   OPER->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN OPER
ENDIF
RETURN  RIGHT(repli("0",len(rmov.nroast)) + LTRIM(STR(iNroDoc)), len(rmov.nroast))

************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE MOVMover
XdFchAst = VMOV->FchAst
XsNroVou = VMOV->NroVou
XiCodMon = VMOV->CodMon
XfTpoCmb = VMOV->TpoCmb
XsNotAst = VMOV->NOTAST
XsDigita = GsUsuario
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
I        = 1
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,K_esc)
   DO CASE
      CASE I = 1
         ***> do lib_mtec WITH 7
         @ 2,68 GET XdFchAst
         READ
         UltTecla = LastKey()
         @ 2,68 SAY XdFchAst
      CASE I = 2
         ***> do lib_mtec WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         DO CASE
            CASE OPER->CODMON = 1
              XiCodMon= 1
            CASE OPER->CODMON = 2
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
            XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
         ELSE
            IF XdFchAst<>VMOV.FchAst
               XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
            ENDIF
         ENDIF
         ***> do lib_mtec WITH 7
         @ 4 ,68 GET XfTpoCmb PICT "9999.9999" VALID XfTpoCmb > 0
         READ
         UltTecla = LastKey()
         @ 4 ,68 SAY XfTpoCmb PICT "9999.9999"
         IF ! OK
            APPEND BLANK
            REPLACE FCHCMB WITH XdFchast
         ENDIF
         IF OPER->TpoCmb=1
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
IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   =MESSAGEBOX(GsMsgErr,16,'Atención')
   UltTecla = K_esc
   RETURN              && No pudo bloquear registro
ENDIF
***> Enviar mensaje de estado   WITH 10
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
   Llave = (NroMes + CodOpe + NroAst )
   IF Rlock()
      SELECT RMOV
      IF ! XsCodOpe = "9"
         DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv
      ELSE
         DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv
      ENDIF
      ** Anulamos Provisi¢n del Proveedor **
     *IF RMOV->CodCta=[421] .AND. RMOV->TpoMov=[H]
         ** Buscamos documento Provisionado
         IF SEEK(XsNroMes+XsCodOpe+VMOV->NroVou,"DPRO")
            IF RLOCK("DPRO")
               SELE DPRO
               REPLACE FLGEST WITH 'A'
               UNLOCK IN "DPRO"
               SELE RMOV
            ENDIF
         ENDIF
     *ENDIF
      SELE RMOV
      DELETE
      UNLOCK
   ELSE
      ok = .f.
   ENDIF
   SKIP
ENDDO
SELECT VMOV
IF Ok
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
   DELETE
ENDIF
UNLOCK ALL
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
   IF ! F1_RLock(5)
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
*!*	   IF ! F1_RLock(5)
*!*	      UltTecla = K_esc
*!*	      RETURN              && No pudo bloquear registro
*!*	   ENDIF
   REPLACE VMOV->NROMES WITH XsNroMes
   REPLACE VMOV->CodOpe WITH XsCodOpe
   REPLACE VMOV->NroAst WITH XsNroAst
   REPLACE VMOV->FLGEST WITH "R"
   replace vmov.fchdig  with date()
   replace vmov.hordig  with time() 
   SELECT OPER
   =NROAST(XsNroAst)
   SELECT VMOV
ELSE
   *** ACTULIZA CAMBIOS DE LA CABECERA EN EL CUERPO ***
   IF VMOV->FchAst <> XdFchAst .OR. VMOV->NroVou <> XsNroVou
      SELECT RMOV
      Llave = (XsNroMes + XsCodOpe + XsNroAst )
      SEEK Llave
      DO WHILE ! EOF() .AND. Llave = (NroMes + CodOpe + NroAst )
         IF Rlock()
            REPLACE RMOV->FchAst  WITH XdFchAst
            IF VARTYPE(NroVou)='C'
	            REPLACE RMOV->NroVou  WITH XsNroVou
	        ENDIF    
            UNLOCK
         ENDIF
         SKIP
      ENDDO
   ENDIF
   SELECT VMOV
ENDIF
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XiCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->Digita  WITH GsUsuario
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
*!*		SelLin   = "MOVbcomp"
*!*		InsLin   = "MOVInser"
*!*		EscLin   = "MOVbline"
*!*		EdiLin   = "MOVbedit"
*!*		BrrLin   = "MOVbborr"
*!*		GrbLin   = "MOVbVeri"
*!*		MVprgF1  = [MOVF1]
*!*		MVprgF2  = []
*!*		MVprgF3  = [MOVF3]
*!*		MVprgF4  = []
*!*		MVprgF5  = []
*!*		MVprgF6  = [Pordcom]
*!*		MVprgF7  = []
*!*		MVprgF8  = []
*!*		MVprgF9  = "Palmacen"                 && [BORRLIN]
*!*		PrgFin   = "MovFin"
*!*		Titulo   = []
		NClave   = [NroMes+CodOpe+NroAst]
		VClave   = XsNroMes+XsCodOpe+XsNroAst
*!*		HTitle   = 1
*!*		Yo       = 10
*!*		Xo       = 0
*!*		Largo    = 21 - Yo
*!*		Ancho    = 80
*!*		TBorde   = Nulo
*!*		Titulo   = []
*!*		E1       = []
*!*		E2       = []
*!*		E3       = []
*!*		LinReg   = []
*!*		Consulta = .F.
*!*		Modifica = .T.
	Adiciona = .T.
*!*		Static   = .F.
*!*		VSombra  = .F.
*!*		DB_Pinta = .F.
	SELECT RMOV
	*** Variable a Conocer ****
	XsCodCta = SPACE(LEN(RMOV->CodCta))
	XsClfAux = SPACE(LEN(RMOV->ClfAux))
	XsCodAux = SPACE(LEN(RMOV->CodAux))
	XsCodPrv = SPACE(LEN(RMOV->CodAux))
	XsNomPrv = SPACE(LEN(AUXI->NomAux))
	XsRefPrv = SPACE(LEN(RMOV->NroRef))
	XsIniAux = SPACE(LEN(RMOV->IniAux))
	XsCodRef = SPACE(LEN(RMOV->CodRef))
	*XsGloDoc = SPACE(LEN(RMOV->GloDoc))
	XsCodDiv = SPACE(LEN(RMOV.CodDiv))
	xsglodoc = vmov->notast
	XdFchDoc = VMOV->FCHAST
	*XdFchVto = {,,}
	*XdFchPed = {,,}
	XdFchVto = {  ,  ,    }
	XdFchPed = {  ,  ,    }
	*
	xsnivadi = space(len(rmov->tpoo_c))
	*
	XsCodDoc = SPACE(LEN(RMOV->CodDoc))
	XsNroDoc = SPACE(LEN(RMOV->NroDoc))
	XsNroRef = SPACE(LEN(RMOV->NroRef))
	XSCODFIN = SPACE(LEN(RMOV->CODFIN))
	XiCodMon = VMOV->CodMon
*!*		XfTpoMon = VMOV->TpoCmb
	XcTpoMov = "D"
	XfImport = 0.00
	XfImpNac = 0.00
	XfImpUsa = 0.00
	XiNroItm = VMOV->NroItm+1
	XiNroItm = 1
*!*		TcEliItm = []
	XcTipoC  = SPACE(LEN(RMOV.TipoC))
	*
	* DATOS SUNAT
	XsNroRuc = space(len(rmov.NroRuc))
	*XsFecOri = {,,}
	XsFecOri = {  ,  ,    }
	store 0 to XsImpOri,XsImpNac1, XsImpNac2
	XsTipOri = space(len(drmov.tipori))
	XsTipDoc = space(len(drmov.tipdoc))
	XsNumOri = space(len(drmov.numori))
	XsNumPol = space(len(drmov.n_poliza))
	*
	XsTipDoc1= space(len(drmov.tipdoc))
	XsCodCta1= SPACE(LEN(RMOV->CodCta))
	XsNroRef1= SPACE(LEN(RMOV->NroRef))
	XsCodCco = SPACE(LEN(RMOV->CodCco))
	*
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
	   lDesBal = ( ABS(VMOV->HbeUsa-VMOV->DbeUsa) >.01 ) .or. ( ABS(VMOV->HbeNac-VMOV->DbeNac) >.05 )
	   LlRlock = .F.
	   LlRlock = F1_RLock(0)
	   IF lDesBal
	      REPLACE FlgEst WITH [X]
	   ELSE
	      REPLACE FlgEst WITH [G]
	   ENDIF
	   UNLOCK
	ELSE
	 **lDesBal = ( ABS(VMOV->HbeUsa-VMOV->DbeUsa) >.01 ) .or. ( ABS(VMOV->HbeNac-VMOV->DbeNac) >.05 )
	 **APPEND BLANK
	 **DO WHILE !RLOCK()
	 **ENDDO
	 **REPLACE NroMes WITH XsNroMes
	 **REPLACE CodOpe WITH XsCodOpe
	 **REPLACE NroAst WITH XsNroAst
	 **REPLACE NroDoc WITH XsNroAst
	 **REPLACE CodDoc WITH [CBD]
	 **REPLACE FchRec WITH XdFchAst
	 **REPLACE NomEnv WITH VMOV->NotAst
	 **REPLACE ObServ WITH "ASIENTO GENERADO DIRECTAMENTE EN CONTABILIDAD"
	 **IF lDesBal
	 **   REPLACE FlgEst WITH [X]
	 **ELSE
	 **   REPLACE FlgEst WITH [G]
	 **ENDIF
	 **UNLOCK
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
  *contenido = contenido + space(9)
   contenido = contenido + space(11)
else
  *xsfchvto = left(dtoc(fchvto),6)+right(dtoc(fchvto),2)
   xsfchvto = dtoc(fchvto)
   contenido = contenido + xsfchvto + " "
endif
*contenido = contenido + left(glodoc,22)+" "+tpomov+"    "
contenido = contenido + left(glodoc,TnLenGlo)+" "+tpomov+"    "
IF VMOV->CodMon <> 1
  *Contenido = Contenido + TRAN(ImpUsa,"9999999.99")
   Contenido = Contenido + TRAN(ImpUsa,"99999999.99")
ELSE
  *Contenido = Contenido + TRAN(Import,"9999999.99")
   Contenido = Contenido + TRAN(Import,"99999999.99")
ENDIF
*
if codcta=[42] or (inlist(codope,[270],[272],[280]) and inlist(codcta,[28],[42],[46]))
   =seek(clfaux+codaux,[auxi])
   xscodprv = codaux
   xsnomprv = auxi.nomaux
   xsrefprv = nroref
endif
*
RETURN

************************************************************************ FIN *
* Objeto : Complementa una linea del browse
******************************************************************************
PROCEDURE MOVbcomp
@ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
@ 21,1 clear to 22,78
=SEEK(RMOV->CodCta,"CTAS")
IF ! EMPTY(CODAUX)
   =SEEK(CLFAUX+CODAUX,"AUXI")
   @ 22,1 SAY "AUXILIAR: "+AUXI->NomAux
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
IF VMOV->CODMON = 1
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

DO CASE 
	CASE PcAccion ='A'		&& Actualizar
*!*			IF ! Crear
			  ** IF INLIST(EliItm , "ú")
			   IF INLIST(EliItm , "*")
			      GsMsgErr = " Linea no puede ser modificada, es cuenta automatica"
			      =MESSAGEBOX(GsMsgErr,16,'Acceso denegado')
			      UltTecla = K_esc
			      RETURN
			   ENDIF
			   DO Cap_Detalle_Cursor
*!*			   ENDIF
		CASE PcAccion = 'I'
		   *XsClfAux = SPACE(LEN(C_RMOV.ClfAux))
		   *XsIniAux = SPACE(LEN(C_RMOV.IniAux))
		   *XsNroRuc = SPACE(LEN(C_RMOV.NroRuc))
		   XsCodRef = SPACE(LEN(C_RMOV.CodRef))
		 **XSCODFIN = SPACE(LEN(C_RMOV.CODFIN))
		   XdFchDoc = VMOV->FCHAST
		  *XdFchVto = {,,}
		   XdFchVto = {  ,  ,    }  
		   XfImpUsa    = 0
		   XfImpNac    = 0
		   XsCodDoc = SPACE(LEN(C_RMOV.CodDoc))
		   XsNroDoc = SPACE(LEN(C_RMOV.NroDoc))
		   if !empty(vmov->notast)
		      xsglodoc = vmov->notast
		   endif
		   XiCodMon = VMOV->CodMon
		*!*	   XfTpoMon = VMOV->TpoCmb
		   XiNroItm = VMOV->NroItm+1
		   @ 21,1 CLEAR TO 22,78
		   XdFchPed = VMOV.FchAst
		   XcTipoC  = SPACE(LEN(RMOV.TipOC))
		   *
		   store [NO] to XsTipDoc, XsTipDoc1
		   XsCodCta1= SPACE(LEN(C_RMOV.CodCta))
		   XsNroRef1= SPACE(LEN(C_RMOV.NroRef))
		   *
		   store 0 to xsimpori, xsimpnac1, xsimpnac2
		   XsTipOri = space(len(drmov.tipori))
		   XsNumOri = space(len(drmov.numori))
		   XsNumPol = space(len(drmov.n_poliza))
		   *
ENDCASE
lActCta40=.f.
Td40FchRef=CTOD([01/01/]+STR(_ANO,4,0))
Td40FchVto=Td40FchRef
Ts40NroDoc=[]
Ts40CodAux=[]
TsClfAuxAc=XsClfAux
*
*!*	***> do lib_mtec WITH 7    && Teclas edicion linea

*!*	i = 1
*!*	LinRef = 0
*!*	LinDiv = 3
*!*	LinCta = LinDiv+LEN(RMOV.CodDiv) +1
*!*	LinAux = LinCta+LEN(RMOV.CODCTA) +1
*!*	LinDoc = LinAux+LEN(RMOV.CODAUX) +1
*!*	LinVto = LinDoc+LEN(RMOV.NRODOC) +1
*!*	LinGlo = LinVto+LEN(DTOC(DATE()))+1
*!*	LinTpo = LinGlo+TnLenGlo+1
*!*	LinMon = LinTpo+LEN(RMOV.TpoMov) +1
*!*	LinImp = LinMon + 3
*
UltTecla = 0
*!*	DO WHILE .NOT. INLIST(UltTecla,K_esc,CtrlW,F10)
   DO CASE
      CASE i = 2
*!*	         SELE AUXI
*!*	         @ LinAct,LinDiv GET XsCodDiv PICT "XX"
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	         IF UltTecla = K_esc
*!*	            LOOP
*!*	         ENDIF
*!*	         IF UltTecla = F8
*!*		        XsClfAux = [DV ]  && Divisionarias
*!*	            IF ! CBDBUSCA("AUXI")
*!*	               LOOP
*!*	            ENDIF
*!*	            XsCodDiv = PADR(AUXI.CodAux,LEN(RMOV.CodDiv))
*!*	            XsClfAux=TsClfAuxAc
*!*	         ENDIF
         SEEK [DV ]+XsCodDiv
         IF !FOUND()
         	GsMsgErr = [Codigo de divisionaria invalido]
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
         	UltTecla=0
*!*	         	Loop
			RETURN .F.

         ENDIF
*!*	         @ LinAct,LinDiv SAY XsCodDiv PICT "XX"
      CASE i = 3        && C¢digo de Cuenta
         SELECT CTAS
*!*	         @ LinAct,LinCta GET XsCodCta PICT REPLICATE("9",LEN(XsCodCta))
*!*	         READ
*!*	         UltTecla = LastKey()
*!*	         IF UltTecla = K_esc
*!*	            LOOP
*!*	         ENDIF
*!*	         IF UltTecla = F8
*!*	            SEEK TRIM(XsCodCta)
*!*	            IF ! CBDBUSCA("CTAS")
*!*	               LOOP
*!*	            ENDIF
*!*	            XsCodCta = CTAS->CodCta
*!*	         ENDIF
*!*	         @ LinAct,LinCta SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
            UltTecla = 0
*!*	            LOOP
			RETURN .F.
         ENDIF
         IF CTAS->AFTMOV#"S"
            GsMsgErr = "Cuenta no Afecta a movimiento"
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
         	UltTecla = 0
*!*	            LOOP
			RETURN .F.	
         ENDIF
*!*	         @ 21,1 CLEAR TO 22,78
*!*	         @ 21,1 SAY "CUENTA CONTABLE  : "+CTAS->NomCta
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
      CASE i = 4 .AND. CTAS->PidAux = [S]
         SELECT TABL
         XsTabla = "01"
         IF EMPTY(CTAS->CLFAUX)
            GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
         	UltTecla = 0
*!*	            LOOP
			RETURN .F.	
         ELSE
            XsClfAux = CTAS->ClfAux
         ENDIF
         SEEK XsTabla+XsClfAux
         IF ! FOUND()
            GsMsgErr = " Invalida Configuraci¢n de Cuenta. No registro la clasificaci¢n del auxiliar"
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
         	UltTecla = K_esc
*!*	            LOOP
			RETURN .F.	
         ENDIF
*!*	         @ 22,1 SAY "Tipo de Auxiliar : "+TABL->Nombre
         iDigitos = TABL->Digitos
         IF iDigitos < 0 .OR. iDigitos > LEN(XsCodAux)
            iDigitos = LEN(XsCodAux)
         ENDIF
         IF (EMPTY(XsCodAux) AND XsCodCta=[40]) OR (XsCodCta="40" AND Crear)
         	XsCodAux=iif(!empty(Ts40CodAux),padr(Ts40CodAux,idigitos),xscodaux)
         ENDIF
         SELECT AUXI
*!*	         @ LinAct,LinAux GET XsCodAux PICT REPLICATE("9",iDigitos)
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	         IF UltTecla = K_esc
*!*	            LOOP
*!*	         ENDIF
*!*	         IF UltTecla = F8
*!*	            IF ! CBDBUSCA("AUXI")
*!*	               LOOP
*!*	            ENDIF
*!*	            XsCodAux = AUXI->CodAux
*!*	         ELSE
*!*	            XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
*!*	         ENDIF
         XsCodAux = PADR(XsCodAux,LEN(C_RMOV.CodAUX))
*!*	         @ LinAct,LinAux SAY XsCodAux
         SEEK XsClfAux+XsCodAux
         IF ! FOUND()
         	GsMsgErr = 'Codigo de auxiliar invalido'
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
         	UltTecla = 0
*!*	            LOOP
			RETURN .F.	
         ENDIF
*!*	         @ 22,1 SAY "AUXIL. : "+AUXI->NomAux
      CASE i = 4 .AND. CTAS->PidAux # [S]
         XsClfAux = SPACE(LEN(C_RMOV.CLFAUX))
         XsCodAux = SPACE(LEN(C_RMOV.CODAUX))
      CASE i = 5 .AND. CTAS->PidDoc=[S]
         ** No modificar documento en caso de Proveedores y Modificacion **
         DO CASE
            CASE OPER->Origen .AND. Crear
               ** Generamos Numero de Documento **
                XsNroDoc = XsNroMes+RIGHT(XsNroAst,4)
                IF _ANO<2000
                	XsNroDoc = XsNroAst+"-"+RIGHT(STR(_ANO,4),2)
                ELSE
                	XsNroDoc = XsNroAst+"-"+STR(_ANO,4)
                ENDIF
                XsNroDoc = PADR(ALLTRIM(XsNroDoc),LEN(C_RMOV.NroDoc),' ')
                IF XsCodCta=[40] AND XsCodOpe#[040] AND !EMPTY(Ts40NroDoc)
                	XsNroDoc = PADR(Ts40NroDoc,LEN(RMOV.NroDoc))
                ENDIF
               ** Buscamos Datos por Defecto **
               IF SEEK(XsNroMes+XsCodOpe+XsNroDoc,"DPRO")
                  ** verificar el mes contable **
                  ** activar cuando sea necesario **
                  *IF DPRO->NroMes # XsNroMes
                  *   GsMsgErr = [Docmto del Proveedor NO corresponde al mes Contable]
                  *   =MESSAGEBOX(GsMsgErr,16,'Atención')
                  *   i = i - 1
                  *   LOOP
                  *ENDIF
                  
                  XdFchVto = DPRO->FchVto
                  IF Td40FchVto#Td40FchRef AND !EMPTY(Td40FchVto) ; 
                  	 AND XdFchVto#Td40FchVto AND XsCodOpe#[040] ;
                  	 AND XsCodCta=[40]
                  	 XdFchVto = Td40FchVto
                  	 XdFchPed = XdFchVto	
                  ENDIF		
                  XiCodMon = DPRO->CodMon
                  XfImport = DPRO->Import
                  XsNroRef = DPRO->NroDoc
                  XdFchDoc = DPRO->FchDoc
                  XsNroRuc = DPRO->RucAux
                  XsCodDoc = DPRO->CodDoc
               ENDIF
*!*	               @ LinAct,LinDoc GET XsNroDoc PICT "@!" VALID ! EMPTY(XsNroDoc)
*!*	               READ
*!*	               UltTecla = LASTKEY()
        ****CASE !(OPER->Origen .AND. LEFT(XsCodCta,4)="4211")
            OTHER
*!*	               @ LinAct,LinDoc GET XsNroDoc PICT "@!" VALID ! EMPTY(XsNroDoc)
*!*	               READ
*!*	               UltTecla = LASTKEY()
         ENDCASE
*!*	         @ LinAct,LinDoc SAY XsNroDoc
      CASE i = 5 .AND. CTAS->PidDoc # [S]
         XsNroDoc = SPACE(LEN(C_RMOV.NroDoc))
      CASE i = 6
         IF CTAS->PidDoc="S"
*!*	            @ LinAct,LinVto GET XdFchVto
*!*	            READ
*!*	            UltTecla = LastKey()
*!*	            @ LinAct,LinVto SAY XdFchVto
         ELSE
           *XdFchVto = {,,}
            XdFchVto = {  ,  ,    }           
         ENDIF
      CASE i = 7
*!*	        *@ LinAct,LinGlo GET XsGloDoc PICT "@!S22"
*!*	         @ LinAct,LinGlo GET XsGloDoc PICT "@!S"+TRAN(TnLenGlo,[99])
*!*	         READ
*!*	         UltTecla = LastKey()
*!*	        *@ LinAct,LinGlo SAY XsGloDoc PICT "@S22"
*!*	         @ LinAct,LinGlo SAY XsGloDoc PICT "@S"+TRAN(TnLenGlo,[99])
      CASE i = 8
*!*	         VecOpc(1)="D"
*!*	         VecOpc(2)="H"
*!*	         XcTpoMov= Elige(XcTpoMov,LinAct,LinTpo,2)
			 IF !INLIST(XcTpoMov,'D','H')
	         	GsMsgErr = 'Tipo de movimiento invalido'
    		     	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
		         	UltTecla = 0
					RETURN .F.	
			 ENDIF
      CASE i = 9 .AND. OPER->CodMon = 4
*!*	         VecOpc(1)="S/."
*!*	         VecOpc(2)="US$"
*!*	         XiCodMon= Elige(XiCodMon,LinAct,LinMon,2)
         IF XiCodMon = 1
            XfTpoCmb = VMOV->TPOCMB
         ENDIF
         IF LefT(XsCodcta,2)$[10,12,14,16,28,38,41,42,46,47]
            DO SALDO
         ENDIF
      CASE i = 10
*!*	         @ LinAct,LinMon SAY IIF(XiCodmon=1,"S/.","US$")
*!*	        *@ LinAct,LinImp GET XfImport PICT "9999999.99" VALID XfImport # 0
*!*	         @ LinAct,LinImp GET XfImport PICT "99999999.99" VALID XfImport # 0
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	        *@ LinAct,LinImp SAY XfImport PICT "9999999.99"
*!*	         @ LinAct,LinImp SAY XfImport PICT "99999999.99"
		 IF XfImport < 0
	       	GsMsgErr = 'Importe invalido'
         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
	       	UltTecla = 0
			RETURN .F.	
		 ENDIF	
         IF XiCodMon=1
           XfImpNac    = XfImport
           XfImpUsa    = round(XfImport/VMOV->TpoCmb,2)
         ELSE
           XfImpUsa    = XfImport
           XfImpNac    = round(XfImport*VMOV->TpoCmb,2)
         ENDIF

      CASE i = 10 .AND. OPER->CodMon = 4
*!*	         @ LinAct,LinMon SAY IIF(XiCodmon#1,"S/.","US$")
         IF XiCodMon = 2
           *@ LinAct,LinImp   GET XfImpNac PICT "9999999.99" VALID XfImpNac >= 0
*!*	            @ LinAct,LinImp   GET XfImpNac PICT "99999999.99" VALID XfImpNac >= 0
			 IF XfImpNac < 0
		       	GsMsgErr = 'Importe invalido'
	         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
		       	UltTecla = 0
				RETURN .F.	
			 ENDIF	
         ELSE
           *@ LinAct,LinImp   GET XfImpUsa PICT "9999999.99" VALID XfImpUsa >= 0
*!*	            @ LinAct,LinImp   GET XfImpUsa PICT "99999999.99" VALID XfImpUsa >= 0
			 IF XfImpUsa < 0
		       	GsMsgErr = 'Importe invalido'
	         	=MESSAGEBOX(GsMsgErr,16,'Error de ingreso de datos')
		       	UltTecla = 0
				RETURN .F.	
			 ENDIF	
         ENDIF
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	         *
*!*	         if inlist(xscodope,[016],[010]) and xscodcta=[104] and xctpomov=[D]
*!*	            defi window rubro from 14,17 to 18,61 double
*!*	            acti window rubro
*!*	            *
*!*	            vecopc(1) = [                              ]
*!*	            vecopc(2) = [CU00 = Prest. Capital de Trab.]
*!*	            vecopc(3) = [CG00 = Adelanto de Factura    ]
*!*	            vecopc(4) = [GM00 = Prest. x Refinanc.     ]
*!*	            vecopc(5) = [CV00 = Prest. Fondo Restring. ]
*!*	            *
*!*	            @01,01 say [Rubro => ]
*!*	            *@01,20 get xsnivadi pict [@!]
*!*	            *read
*!*	            XsNivAdi = Elige(XsNivAdi,1,10,5)
*!*	            XsNivAdi = Left(XsNivAdi,4)
*!*	            rele window rubro
*!*	         endif
         *
      CASE i = 11
         *
         *if xscodcta = [421] and xctpomov = [H]
         
*!*	*!*		VERIFICAR: Para integrar con flujo de caja y pagos a Sunat         
*!*	*!*	         if xctpomov=[H] and !empty(xdfchvto)
*!*	*!*	            @ 22,01 say space(78)
*!*	*!*	            @ 22,01 say [Fecha Finanzas:]
*!*	*!*	            @ 22,17 get xdfchped pict [@E] valid (xdfchped>=xdfchvto)
*!*	*!*	            read
*!*	*!*	            if !empty(xdfchped)
*!*	*!*	               xdfchped = iif(seek(dtos(xdfchped),[diaf]),diaf.fchven,xdfchped)
*!*	*!*	            endif
*!*	*!*	            @ 22,17 SAY xdfchped
*!*	*!*	         endif
*!*	*!*	         *
*!*	*!*	         do case
*!*	*!*	            case inlist(xscodope,[065],[070],[072])
*!*	*!*	                 do dat_sunat
*!*	*!*	                 UltTecla = LASTKEY()
*!*	*!*	                 if ulttecla = K_esc
*!*	*!*	                    ulttecla = 13
*!*	*!*	                    i        = 1
*!*	*!*	                    loop
*!*	*!*	                 endif
*!*	*!*	         endcase

      CASE i = 12 .AND. CTAS->PidGlo = "S"    && Documento de referencia

*!*	*!*	         @ 21,1 CLEAR TO 22,78
*!*	*!*	         @ 21,01 SAY 'N§ Doc.:'
*!*	*!*	         @ 21,50 SAY 'Fecha Documento:'
*!*	*!*	         if xstipdoc = [NO]
*!*	*!*	            @ 21,09 GET XsNroRef PICT '@R 999-999-9999999'
*!*	*!*	            @ 21,66 get XdFchDoc
*!*	*!*	            read
*!*	*!*	         else
*!*	*!*	            @ 21,09 say XsNroRef pict '@R 999-999-9999999'
*!*	*!*	            @ 21,66 say XdFchDoc
*!*	*!*	         endif
*!*	*!*	         UltTecla = LASTKEY()

      CASE I = 13
*!*	*!*	         do case
*!*	*!*	            case xscodcta = [10]
*!*	*!*	                 @ 22,01 SAY [Fecha Finanzas:]
*!*	*!*	                 @ 22,30 SAY [Marcar:]
*!*	*!*	                 @ 22,17 GET XdFchPed
*!*	*!*	                 @ 22,37 GET XcTipoC  VALID XcTipoC$[12 ]
*!*	*!*	                 READ
*!*	*!*	                 UltTecla = LASTKEY()
*!*	*!*	                 @ 22,17 SAY XdFchPed
*!*	*!*	                 @ 22,37 SAY XcTipoC
*!*	*!*	         endcase
         
      CASE i = 14 .AND. XsCodAux="09990"
*!*	         IF Crear
*!*	            XsIniAux = LEFT(XsGloDoc,8)
*!*	         ENDIF
*!*	         @ 22,01 SAY "Iniciales:"  COLOR SCHEME 11
*!*	         @ 22,12 GET XsIniAux    PICT "@!"
*!*	         @ 22,60 SAY "R.U.C. :"      COLOR SCHEME 11
*!*	         @ 22,69 GET XsNroRuc    PICT "@!"
*!*	         READ
*!*	         UltTecla = LASTKEY()
      CASE i = 15
         UltTecla = ENTER
      CASE i = 16
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
*!*	   i = IIF(UltTecla = Arriba, i-1, i+1)
*!*	   i = IIF(i>16,16, i)
*!*	   i = IIF(i<1, 1, i)
*!*	ENDDO
SELECT RMOV
*!*	GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recalculo"
*!*	***> do lib_mtec WITH 99
RETURN .t.

************************************************************************ FIN *
PROCEDURE vCodDoc
*****************
XsTabla = "02"
IF LASTKEY() = F8
   SELECT TABL
   IF ! CbdBusca("TABL")
      RETURN .F.
   ENDIF
   XsCodDoc = LEFT(TABL->Codigo,LEN(XsCodDoc))
ENDIF
RETURN SEEK(XsTabla+XsCodDoc,"TABL")

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbborr
***> Enviar mensaje de estado   WITH 10
ULTTECLA = F10
DO BORRLIN
XiNroItm = NroItm
REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
SKIP
*** anulando cuentas autom ticas siguientes ***
**DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "ú"
DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"

   DO BORRLIN
   REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
   SKIP
ENDDO
DO RenumItms WITH XiNroItm
DO MovPImp
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recalculo"
***> do lib_mtec WITH 99
RETURN

************************************************************************ FIN *
PROCEDURE BORRLIN
*****************
IF ! F1_RLock(5)
   UltTecla = K_esc
ENDIF
** Anulamos Provision del Proveedor **
*IF LEFT(RMOV->CodCta,4)=[4211] .AND. RMOV->TpoMov=[D]
   ** Buscamos documento Provisionado
   IF SEEK(RMOV->CodAux+[P]+RMOV->NroDoc,"DPRO")
      IF RLOCK("DPRO")
         REPLACE DPRO->NroAst WITH []
        *REPLACE DPRO->FchAst WITH {,,}
         REPLACE DPRO->FchAst WITH {  ,  ,    }        
         REPLACE DPRO->FlgEst WITH [R]   && Recepcionado
         UNLOCK IN "DPRO"
      ENDIF
   ENDIF
*ENDIF
SELE RMOV
DELETE
UNLOCK
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
ELSE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
ENDIF
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
DO CalImp
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
ENDIF
*
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
SET STEP ON 
*** Debo posicionarme en el registro a grabar 
LsKeyRegAct=C_RMOV.NroMes+C_RMOV.CodOPe+C_RMOV.NroAst+STR(C_RMOV.NroItm,5)
lOk=GoSvrCbd.LineaActiva('RMOV',LsKeyRegAct,C_RMOV.NroReg)

**** Grabando la linea activa ****

XcEliItm = " "
IF TYPE("YcEliItm")= "C"
	XcEliItm=YcEliItm
ENDIF
DO MOVbGrab
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   IF ! Crear
      *** anulando cuentas autom ticas anteriores ***
      SKIP
      XinroItm = NroItm
**    DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "ú"
      DO WHILE ! EOF() .AND. &RegVal .AND. EliItm = "*"
         Listar   = .T.
         Refresco = .T.
         DO BORRLIN
         REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
         SELECT RMOV
         SKIP
      ENDDO
      IF Listar
          DO RenumItms WITH XiNroItm
          ***!!!! GOTO NumRg(1)
      ELSE
         GOTO RegAct
      ENDIF
   ENDIF
   RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
**XcEliItm = "ú"
** Validar generacion de cuentas automaticas
XcEliItm = "*"
TsClfAux = []
TsCodAux = []
TsAn1Cta = CTAS->An1Cta
TsCC1Cta = CTAS->CC1Cta

*** ATENCION: EL Codigo siguiente sera redefinido como un componente de negocio, por ahora nos valdremos
*** de un case para usar el harcode que nos permita identificar claramente los casos que se dan en las empresas.
*** VETT : 18/10/2002
DO CASE
	*** CASO 1 : La cuentas automaticas no estan en predefinidas en el maestro de cuentas
	CASE EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
		*** Variante 1 : Utiliza la cuenta automatica para acumular otro auxiliar: EJEM; el tipo de gasto
	   TsClfAux = "04 "
	   TsCodAux = CTAS->TpoGto
	   TsAn1Cta = RMOV->CodAux
	   TsCC1Cta = CTAS->CC1Cta
	   TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
	   ** Verificamos su existencia **
	   IF ! SEEK("05 "+TsAn1Cta,"AUXI")
	      GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
	      =MESSAGEBOX(GsMsgErr,16,'Atención')
	      RETURN
	   ENDIF
	   
	*** CASO 2 : La cuenta automatica no esta definida pero la contracuenta si.
	CASE EMPTY(TsAn1Cta) AND !EMPTY(TsCC1Cta)
		*** VAriante 1: La cuenta automatica es en base al centro de costo 
		*** Centro de costo pertenece a una tabla
		IF CTAS->PidCco="S" AND EMPTY(CTAS->AN1CTA)
		   TsAn1Cta = ALLT(XsCodCCo) + SUBS(CTAS.CodCta,2,2) + RIGHT(ALLT(CTAS.CodCta),1)
		   TsCC1Cta = IIF(EMPTY(CTAS->CC1Cta),gocfgcbd.cc1cta,CTAS->CC1Cta)
		ENDIF
		*** VAriante 2: La cuenta automatica es segun el auxiliar de la cuenta origen
		*** Centro de costo pertenece a una tabla
		IF ! SEEK(TsAn1Cta,"ctas")
			=SEEK(RMOV.COdCta,'CTAS')
			IF CTAS.ClfAux=RMOV.ClfAux		&& vett 18/10/2002
				TsAn1Cta = PADR(RMOV.CodAux,LEN(CTAS.COdCta))
			ENDIF
			IF ! SEEK(TsAn1Cta,"ctas")
				GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
		        =MESSAGEBOX(GsMsgErr,16,'Atención')
				RETURN
			ENDIF
		ENDIF
		


ENDCASE
*** Direccionamos el auxiliar de las cuenta automatica generada por compra de existencias 60 vs clase 2
   IF SUBSTR(XSCODCTA,1,4) >= "6000" .AND. SUBSTR(XSCODCTA,1,4) <= "6069"
      IF SUBSTR(TSAN1CTA,1,2)="20" .OR. SUBSTR(TSAN1CTA,1,2)="24" .OR. SUBSTR(TSAN1CTA,1,2)="25" .OR. SUBSTR(TSAN1CTA,1,2)="26"
         TsClfAux = XSCLFAUX
         TsCodAux = XSCODAUX
      ENDIF
   ENDIF
   IF ! SEEK(TsAn1Cta,"CTAS")
      GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
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
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   =MESSAGEBOX(GsMsgErr,16,'Atención')
   RETURN
ENDIF
*****
DO CompBrows WITH .F.
SKIP
Crear = .T.
**IF EliItm = "ú" .AND. &RegVal
IF EliItm = "*" .AND. &RegVal
   Crear = .F.
ENDIF
** Grabando la primera cuenta autom tica **
IF Crear
   XiNroItm = XiNroItm + 1
ELSE
   XiNroItm = NroItm
ENDIF
IF Crear .AND. NroItm <= XiNroitm
   DO  RenumItms WITH XiNroItm + 1
ENDIF
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbGrab
DO CompBrows WITH Crear
SKIP
Crear = .T.
**IF EliItm = "ú" .AND. &RegVal
IF EliItm = "*" .AND. &RegVal
   Crear = .F.
ENDIF
** Grabando la segunda cuenta autom tica **
IF Crear
   XiNroItm = XiNroItm + 1
ELSE
   XiNroItm = NroItm
ENDIF
IF Crear .AND. NroItm <= XiNroitm
   DO  RenumItms WITH XiNroItm + 1
ENDIF
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO MOVbGrab
@ LinIni,Xo+1 FILL TO LinIni+Actual-1,X1-1 COLOR SCHEME 1
IF Crear
   SCROLL LinIni+Actual-1,Xo+1,Y1,X1-1,-1
ENDIF
RETURN

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
***> Enviar mensaje de estado   WITH 4
SELE RMOV
IF Crear
   APPEND BLANK
ENDIF
IF ! F1_RLock(5)
   RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
   ENDIF
ENDIF
IF Crear
   REPLACE RMOV->NroMes WITH XsNroMes
   REPLACE RMOV->CodOpe WITH XsCodOpe
   REPLACE RMOV->NroAst WITH XsNroAst
   REPLACE RMOV->NroItm WITH XiNroItm
   REPLACE VMOV->NroItm WITH VMOV->NroItm + 1
   replace rmov.fchdig  with date()
   replace rmov.hordig  with time()
ELSE
   IF ! XsCodOpe = "9"
      DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , CodDiv
   ELSE
      DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa , COdDiv
   ENDIF
   REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
   DO CalImp
   IF RMOV->TpoMov = 'D'
      REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
      REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
   ELSE
      REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
      REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
   ENDIF
   ** anulamos Provision del Proveedor **
  *IF LEFT(RMOV->CodCta,4)=[4211] .AND. RMOV->TpoMov=[D]
      ** Buscamos documento Provisionado
      IF SEEK(RMOV->CodAux+[P]+RMOV->NroDoc,"DPRO")
         IF RLOCK("DPRO")
            REPLACE DPRO->NroAst WITH []
           *REPLACE DPRO->FchAst WITH {,,}
            REPLACE DPRO->FchAst WITH {  ,  ,    }           
            REPLACE DPRO->FlgEst WITH [R]   && Recepcionado
            UNLOCK IN "DPRO"
         ENDIF
      ENDIF
   *ENDIF
ENDIF
*
REPLACE RMOV.CodDiv WITH XsCodDiv
*
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH XdFchAst
REPLACE RMOV->NroVou WITH XsNroVou
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta

REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
IF OPER->CodMon = 4
   REPLACE RMOV->Import WITH XfImpNac
   REPLACE RMOV->ImpUsa WITH XfImpUsa
ELSE
   IF CodMon = 1
      REPLACE RMOV->Import WITH XfImport
      IF TpoCmb = 0
         REPLACE RMOV->ImpUsa WITH 0
       ELSE
         REPLACE RMOV->ImpUsa WITH round(XfImport/TpoCmb,2)
      ENDIF
   ELSE
      REPLACE RMOV->Import WITH round(XfImport*TpoCmb,2)
      REPLACE RMOV->ImpUsa WITH XfImport
   ENDIF
ENDIF
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->CODFIN WITH XSCODFIN
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
REPLACE RMOV->IniAux WITH XsIniAux
REPLACE RMOV->NroRuc WITH XsNroRuc
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
IF CodCta=[10]
   REPLACE RMOV.FchPed   WITH XdFchPed
ENDIF
IF TYPE([GenDifCmb])=[L]
   IF GenDifCmb
      REPLACE RMOV.FchPed WITH RMOV.FchAst
   ENDIF
ENDIF
if empty(rmov.fchped)
   *
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
   *
endif
*
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
if !empty(rmov.fchped)
   repla rmov.fchped with iif(seek(dtos(rmov.fchped),[diaf]),diaf.fchven,rmov.fchped)
endif
*
replace rmov.tpoo_c with xsnivadi
*
REPLACE RMOV.TipoC  WITH XcTipoC
REPLACE RMOV.Tipdoc WITH Xstipdoc
*
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa , CodDiv
ELSE  && EXTRA CONTABLE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa , CodDiv
ENDIF
SELECT RMOV
DO CalImp

IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+nImpUsa
ENDIF
DO MovPImp
** actualizamos Provision del Proveedor **
IF LEFT(RMOV->CodCta,4)=[4211] .AND. RMOV->TpoMov=[D]
   ** Buscamos documento
   IF SEEK(RMOV->CodAux+[R]+RMOV->NroDoc,"DPRO")
      IF RLOCK("DPRO")
         REPLACE DPRO->NroAst WITH XsNroAst
         REPLACE DPRO->FchAst WITH XdFchAst
         REPLACE DPRO->FlgEst WITH [P]   && Provisionado
         UNLOCK IN "DPRO"
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
*
SELE RMOV
UNLOCK
*
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recalculo"
** Borrar los lib_mtec de el programa
***> do lib_mtec WITH 99
RETURN
******************
PROCEDURE pAlmacen
******************
IF INLIST(RMOV.CodCta,[6040],[6041],[6050],[6060],[2340])
   DO ALMPIVAL WITH XsCodPrv,XfTpoCmb,XiCodMon,[FACT],XsRefPrv,XsNomPrv
ENDIF
RETURN
**********************************************************************
* CALCULO DE IMPORTES================================================
**********************************************************************
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
RETURN

**********************************************************************
* Complemento del db_Brows para cuentas autom ticas
**********************************************************************
PROCEDURE CompBrows
*******************
PARAMETER INSERTA
return    &&& Ver como se pude hacer para reflejar cambios en el grid o si vale la pena  creo que no. 
@ LinIni,Xo+1 FILL TO LinIni+Actual-1,X1-1 COLOR SCHEME 1
IF INSERTA
   SCROLL LinIni+Actual-1,Xo+1,Y1,X1-1,-1
ENDIF
Contenido = []
IF HayEscLin
   DO &EscLin WITH Contenido
ELSE
   Contenido  = &LinReg
ENDIF
Linea(Actual)  = Contenido
NumRg(Actual)  = RECNO()
LinAct = LinIni+Actual-1
@ LinAct,Xo+2 SAY Linea(Actual) COLOR SCHEME 7
IF Actual >= MaxLin
   Actual = MaxLin
   Ultimo = MaxLin
   j =1
   DO WHILE j <MaxLin
      Linea(j)  = Linea(j+1)
      NumRg(j)  = NumRg(j+1)
      j =j +1
   ENDDO
   SCROLL Yo+1,Xo+1,Y1,X1-1,+1
   dB_Top = .F.
ELSE
   Actual   =  Actual + 1
   IF Actual > Ultimo
      Ultimo = IIF( MaxLin > Ultimo, Ultimo+1, Ultimo)
   ENDIF
ENDIF
LinAct = LinIni+Actual-1
RETURN

**********************************************************************
* Pinta Importe Totales
**********************************************************************
PROCEDURE MovPImp
******************
IF VMOV->CodMon = 1
   @  20,40    SAY "S/."                                   COLOR SCHEME 7
   @  20,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  20,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7

   @  23,40    SAY "US$"                                   COLOR SCHEME 7
   @  23,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  23,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
ELSE
   @  20,40    SAY "US$"                                   COLOR SCHEME 7
   @  20,47    SAY VMOV->DbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  20,64    SAY VMOV->HbeUsa  PICTURE "999,999,999.99"  COLOR SCHEME 7

   @  23,40    SAY "S/."                                   COLOR SCHEME 7
   @  23,47    SAY VMOV->DbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
   @  23,64    SAY VMOV->HbeNac  PICTURE "999,999,999.99"  COLOR SCHEME 7
ENDIF
RETURN

********************************************************************
* CHEQUEO DE FIN DE BROWSE ===========================================
**********************************************************************
PROCEDURE MovFin
****************
IF ( ( ABS(VMOV->DbeUsa-VMOV->HbeUsa) >=.01 ) .AND. ( ABS(VMOV->DbeUsa-VMOV->HbeUsa) <=.03 ) );
  .OR.  ( ( ABS(VMOV->DbeNac-VMOV->HbeNac) >=.01 ) .AND. ( ABS(VMOV->DbeNac-VMOV->HbeNac) <=.05 ) )
  DO MOVF3
ENDIF
lDesBal = ( ABS(VMOV->HbeUsa-VMOV->DbeUsa) >.01 ) .or. ( ABS(VMOV->HbeNac-VMOV->DbeNac) >.05 )
IF lDesBal
   IF ALRT("Asiento Desbalanceado")
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
SAVE SCREEN
***> Enviar mensaje de estado   WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
@ 11,23 SAY "³    R E C A L C U L A N D O    ³" COLOR SCHEME 7
@ 12,23 SAY "³  Espere un momento por favor  ³" COLOR SCHEME 7
@ 13,23 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7
T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
**** Recalculando Importes *************************
T_Itms =0
Chqado =0
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
   DO CalImp
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
   REPLACE VMOV->ChkCta  WITH T_Ctas
   REPLACE VMOV->DbeNac  WITH T_DbeNac
   REPLACE VMOV->DbeUsa  WITH T_DbeUsa
   REPLACE VMOV->HbeNac  WITH T_HbeNac
   REPLACE VMOV->HbeUsa  WITH T_HbeUsa
   REPLACE VMOV->NroItm  WITH T_Itms
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
RESTORE SCREEN
DO MovPImp
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
* AJUSTA DESCUADRE POR DIFERENCIAS DE CAMBIO ENTRE  [ 0.01 , 0.05 ]
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=0.05
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=0.05
**XcEliItm    = "ø"   && Marca de grabaci¢n autom tica
YcEliItm = ":" 
XXTpoCmb    = XfTpoCmb
XfImport    = 0.0000
store 0 TO XfImpNac,XfImpUsa
If TYPE("TsCodDiv1")
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
      XiNroItm = XiNroItm + 1
      Crear = .T.
      DO MOVBVERI
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
      XiNroItm = XiNroItm + 1
      Crear = .T.
      DO MovBVeri
      IF LcTpoMov = "D"
         T_DbeNac = T_DbeNac + XfImport
      ELSE
         T_HbeNac = T_HbeNac + XfImport
      ENDIF
   ENDIF
ENDIF
lDesBal1 =  ABS(T_DbeUsa-T_HbeUsa)>=0.01 .AND. ABS(T_DbeUsa-T_HbeUsa)<=0.05
lDesBal2 =  ABS(T_DbeNac-T_HbeNac)>=0.01 .AND. ABS(T_DbeNac-T_HbeNac)<=0.05
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
      XiNroItm = XiNroItm + 1
      Crear = .T.
      DO MovBVeri
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
      XiNroItm = XiNroItm + 1
      Crear = .T.
      DO MovBveri
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

*Saldo  = Saldo  + IIF(XcTpoMov = 'D' , 1 , -1)*XfImport
*SdouSA = SdouSA + IIF(XcTpoMov = 'D' , 1 , -1)*XfImpUsa

@ 22,1 SAY SPACE(77)
@ 22,2 SAY [SALDO --->]                             COLOR SCHEME 7
@ 22,19 SAY "S/."                                   COLOR SCHEME 7
@ 22,23 SAY Saldo   PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
@ 22,55 SAY "US$"                                   COLOR SCHEME 7
@ 22,59 SAY SdoUsa  PICTURE "@( ###,###,###,###.##" COLOR SCHEME 7
RETURN

******************
PROCEDURE IMPRVOUC
******************
PRIVATE Largo,Ancho,Temp
SAVE SCREEN TO Temp
REGACT=RECNO()
DO DIRPRINT &&IN ADMPRINT
IF LASTKEY() = K_esc
   RESTORE SCREEN FROM TEMP
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
En7 = "AUXI-       N§            ***************************** CONTAB               D E S C R I P C I O N                    C A R G O S         A B O N O S  "
En8 = "LIAR       REFERENCIA     Tpo   No.            VENCTO.                                                                                                 "
En9 = "********** ************** *** ************** ********** ******** ************************************************ ****************** ******************"
*      1234567890 12345678901234 123 12345678901234 1234567890 12345678 123456789012345678901234567890123456789012345678
*      0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-1
*                1         2         3         4         5         6         7         8         9         0         1         2         3
SET DEVICE TO PRINTER
PRINTJOB
   sKey = XsNroMes+XsCodOpe+XsNroAst
   =SEEK(sKey,"VMOV")
   =SEEK(VMOV.CodOpe,'OPER')
   LsNomOpe=OPER->NomOpe
   DO MovMemb
   nDbe = 0
   nHbe = 0
   SELECT RMOV
   cNroChq = []
   SEEK XsNroMes+XsCodOpe+XsNroAst
   DO WHILE  ! EOF() .AND. sKey = RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst
     **IF ELIITM#'ú'
       IF ELIITM#'*'
        IF Prow() > (Largo - 4)
          DO MovMemb
        ENDIF
        NumLin = Prow() + 1
        @ NumLin,00  SAY CodAux
        @ NumLin,11  SAY NroRef
        @ NumLin,26  SAY CodDoc
        @ NumLin,30  SAY NroDoc
        IF ! EMPTY(FchVto)
           @ NumLin,45  SAY FchVto
        ENDIF
        @ NumLin,56  SAY CodCta
        =SEEK(ClfAux+CodAux,"AUXI")
        DO CASE
           CASE ! EMPTY(RMOV->Glodoc)
              LsGlodoc = LEFT(RMOV->GloDoc,50)
           CASE ! EMPTY(VMOV->NotAst)
              LsGlodoc = LEFT(VMOV->NotAst,50)
           OTHER
              LsGlodoc = LEFT(AUXI->NOMAUX,50)
        ENDCASE
        IF RMOV->CodMon <> 1
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
   @ NumLin,80  SAY _Prn7a+"TOTALES"+_Prn7B
   @ NumLin,0  SAY [ ]
   @ NumLin,116 SAY _Prn6a
   @ NumLin,116 SAY nDbe PICT "999,999,999.99"
   @ NumLin,135 SAY nHbe PICT "999,999,999.99"
   @ NumLin,Ancho-1 SAY _Prn6b
   DO MovIPie
ENDPRINTJOB
EJECT PAGE
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
RESTORE SCREEN FROM Temp
RETURN
**********************************************************************
PROCEDURE MovMemb
*****************
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ENDIF
IF NumPag > 0
   NumLin = PROW() + 1
   @ NumLin,80  SAY "VAN ......"
   @ NumLin,116 SAY nDbe PICT "999,999,999.99"
   @ NumLin,135 SAY nHbe PICT "999,999,999.99"
ENDIF
NumPag = NumPag + 1
@ 0,0  SAY IniImp
@ 1,0  SAY _Prn7a+GsNomCia+_Prn7b
@ 2,0  SAY GsDirCia
@ 2,Ancho - 33  SAY "OPERACION  "+_Prn7a+Vmov->CodOpe+_Prn7b
@ 3,0           SAY "REGISTRO "+LsNomOpe
@ 3,Ancho - 33  SAY "ASIENTO    "+_Prn7a+XsNroAst+_Prn7b
@ 4,0           SAY cTitulo
@ 4,Ancho - 54  SAY "MONEDA     "+IIF(Vmov->CodMon=1,"S/.","US$")
@ 4,Ancho - 33  SAY "REFERENCIA "+VMOV->NroVou
@ 5,0           SAY Vmov->NotAst
@ 5,Ancho - 54  SAY "T/C   "+TRAN(VMOV->TpoCmb,"##,###.####")
@ 5,Ancho - 33  SAY "Fecha      "+DTOC(Vmov->FchAst)
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
Pn5 = PADC(VMOV->Digita,15)
@ NumLin+1,0    SAY Pn1
*@ NumLin+2,0    SAY Pn2
*@ NumLin+3,0    SAY Pn3
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
    *
    wait window [Grabando en Asiento N§: ]+tsnroast+[ CodOpe : ]+pscodope+[...] nowait
    sele vmov
    do registro
    repla codope with pscodope
    unlock
    *
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
   *
   wait window [Grabando en Asiento N§: ]+tsnroast+[ CodOpe : ]+pscodope+[...] nowait
   sele vmov
   seek llave
   replace codope with pscodope
   replace nroast with tsnroast
   *
   sele oper
   =nroast(tsnroast)
   unlock
   *
   sele rmov
   seek llave
   do while found()
      do registro
      replace codope with pscodope
      replace nroast with tsnroast
      unlock
      seek llave
   enddo
   *
endif
*
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
*******************
procedure dat_sunat
*******************
do case
   case xscodope = [070] .and. left(xscodcta,2) = '40' && Importaciones
        define   window sunat from 14,20 to 20,60
        activate window sunat
        @ 00,01 say 'N§ Poliza         =>'
        @ 01,01 say 'Total Importaci¢n =>'
        @ 02,01 say 'Total Advalorem   =>'
        @ 03,01 say 'Total IGV + IPM   =>'
        @ 04,01 say 'Fecha de Pago     =>'
        *
        xstipdoc  = '50'  && Importaciones
        xstipdoc1 = '50'  && Importaciones
        @00,22 get xsnumpol  valid (xsnumpol<>space(len(drmov.n_poliza)))
        @01,22 get xsimpori  pict '999,999,999.99' valid (xsimpori<>0)
        @02,22 get xsimpnac1 pict '999,999,999.99'
        @03,22 get xsimpnac2 pict '999,999,999.99' valid (xsimpnac2<>0)
        @04,22 get xsfecori  pict '@E' valid (xsfecori<>ctod(space(08)))
        read
   otherwise
        @ 21,01 CLEAR TO 22,78
        @ 21,01 SAY 'T.Doc.:'
        SELECT TABL
        go top
        set filter to tabla = 'SN'
        go top
        @21,08 get XsTipDoc pict '@!' valid vTipDoc()
        read
        UltTecla = LASTKEY()
        SELECT TABL
        go top
        set filter to
        go top
        if xstipdoc = [NO] OR UltTecla = K_esc
           return
        endif
        *
        define   window sunat from 11,20 to 20,75
        activate window sunat
        @ 00,01 SAY 'T.D.             ==>'
        @ 01,01 say 'N§ Ruc           ==>'
        @ 02,01 say 'Proveedor        ==>'
        @ 03,01 SAY 'N§ Doc.          ==>'
        @ 04,01 SAY 'Fecha Documento  ==>'
        @ 05,01 say 'Tipo Doc. Origen ==>'
        @ 06,01 say 'N§ Doc. Origen   ==>'
        @ 07,01 say 'Fec. Doc. Origen ==>'
        *
        if trim(xsclfaux) = [01]
           if inlist(xscodaux,[112799],[112699],[102301])
              xsiniaux = iif(xsiniaux=space(len(rmov.iniaux)),space(len(rmov.iniaux)),xsiniaux)
              xsnroruc = iif(xsnroruc=space(len(rmov.nroruc)),space(len(rmov.nroruc)),xsnroruc)
           else
              xsiniaux = iif(seek(xsclfaux+xscodaux,[auxi]),left(auxi.nomaux,20),space(len(rmov.iniaux)))
              xsnroruc = iif(seek(xsclfaux+xscodaux,[auxi]),auxi.rucaux,space(08))
           endif
        else
           xsiniaux = iif(xsiniaux=space(len(rmov.iniaux)),space(len(rmov.iniaux)),xsiniaux)
           xsnroruc = iif(xsnroruc=space(len(rmov.nroruc)),space(len(rmov.nroruc)),xsnroruc)
        endif
        *
        @00,22 say xstipdoc
        @01,22 get xsnroruc pict '99999999' valid (xsnroruc<>space(08))
        @02,22 get xsiniaux pict '@!'       valid (xsiniaux<>space(len(rmov.iniaux)))
        @03,22 get XsNroRef pict '@R 999-9999999' valid (XsnroRef<>space(len(rmov.nroref)))
        @04,22 get XdFchDoc valid (xdfchdoc<>ctod(space(08)))
        read
        if XsNroRef <> space(10)
           XsNroRef = tran(val(left(xsnroref,3)),[@L 999])+;
                      tran(val(subs(xsnroref,4)),[@L 9999999])
           @ 03,22 get XsNroRef pict '@R 999-9999999'
           clear gets
        endif
        if inlist(xstipdoc,[07],[08])
           @05,22 get xstipori  pict '999' valid (xstipori$[01^08])
           @06,22 get xsnumori  pict '@R 999-9999999' valid (xsnumori<>space(10))
           @07,22 get xsfecori  pict '@E' valid (xsfecori<>ctod(space(08)) .and. xsfecori<=xdfchdoc)
           read
           xsnumori = tran(val(left(xsnumori,3)),[@L 999]) +;
                      tran(val(subs(xsnumori,4)),[@L 9999999])
        else
           XsTipOri  = space(len(drmov.tipori))
           XsNumOri  = space(len(drmov.numori))
          *XsFecOri  = {,,}
           XsFecOri  = {  ,  ,    }          
        endif
endcase
*
release  window sunat
return
****************
FUNCTION vTipDoc
****************
UltTecla = LASTKEY()
IF UltTecla = F8
   XsTabla=[SN]
   IF ! CBDBUSCA("TABL")
      return .f.
   ENDIF
   XsTipDoc = codigo
   xstipdoc = padr(xstipdoc,len(drmov.tipdoc))
   ULTTECLA = Enter
ENDIF
SEEK 'SN' + XsTipDoc
IF ! FOUND()
   GsMsgErr = "**C¢digo Documento No Registrado **"
   =MESSAGEBOX(GsMsgErr,16,'Atención')
   UltTecla = 0
   return .f.
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
*********************************************************
PROCEDURE ASTPROV
*********************************************************
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
*
private xstipdoc
*
XsCodDoc = DPRO->CodDoc
XsNroDoc = DPRO->NroDoc
XsNroRef = DPRO->NroRef

XsCodAux = DPRO->CodAux
XsNomAux = DPRO->NomAux
XsRucAux = DPRO->RucAux
XdFchDoc = DPRO->FchDoc
XdFchVto = DPRO->FchVto
XiDiaVto = DPRO->DiaVto
XdFchPed = DPRO->FchPed
XfImport = DPRO->Import
XfImpBrt = DPRO->ImpBrt
XfImpIgv = DPRO->ImpIgv
XiCodMon = DPRO->CodMon
XfTpoCmb = DPRO->TpoCmb
XdFchRec = DPRO->FchRec
XsNomRec = DPRO->NomRec
XsNomEnv = DPRO->NomEnv
XcFlgEst = DPRO->FlgEst
XsObserv = DPRO->Observ
XsNroO_C = DPRO->NroO_C
XsNroGui = DPRO->NroGui
XsNroVou = DPRO->NroVou
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
**
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
REPLACE VMOV->NROMES WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->NroAst WITH XsNroAst
REPLACE VMOV->FLGEST WITH "R"
replace vmov.fchdig  with date()
replace vmov.hordig  with time() 

** GRABACION DEL CORRELATIVO **
SELECT OPER
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = OPER->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = OPER->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = OPER->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = OPER->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = OPER->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = OPER->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = OPER->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = OPER->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = OPER->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = OPER->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = OPER->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = OPER->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = OPER->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = OPER->NDOC13
   OTHER
     iNroDoc = OPER->NRODOC
ENDCASE
IF VAL(XsNroAst) = iNroDoc
  iNroDoc = VAL(XsNroAst) + 1
   DO CASE
      CASE XsNroMES = "00"
        REPLACE   OPER->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   OPER->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN OPER
ENDIF
* * * *
SELECT VMOV
PRIVATE XdFchAst,XsNotAst
XdFchAst = DATE()
XsNroVou = XsNroAst+[-]+RIGHT(DTOC(XdFchAst),2)
XsNotAst = DPRO->NOMAUX
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XiCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->Digita  WITH GsUsuario
** Generamos Detalles **
PRIVATE XsCodCta,XsCodAux,XsCodRef,XsGloDoc,XdFchDoc
*PRIVATE XsCodDoc,XsNroDoc,XsNroRef,XiCodMon,XcTpoMov,XfImport
PRIVATE XsNroDoc,XsNroRef,XiCodMon,XcTpoMov,XfImport
PRIVATE XiNroItm,Crear,XcEliItm
SELE DPRO
XsCodAux = CodAux
XsRucAux = RucAux
XsCodRef = SPACE(LEN(RMOV->CodRef))
XsGloDoc = XsNomAux
do case
   case inlist(codope,[065],[070]) and !empty(fchdoc)
        xdfchdoc = fchdoc
   otherwise
        xdfchdoc = vmov->fchast
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
*
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
    *IF CodDoc = [N/C]
    *   XcTpoMov = [H]
    *ENDIF
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
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
   ENDIF
ENDIF
IF Crear
   REPLACE RMOV->NroMes WITH XsNroMes
   REPLACE RMOV->CodOpe WITH XsCodOpe
   REPLACE RMOV->NroAst WITH XsNroAst
   REPLACE RMOV->NroItm WITH XiNroItm
   REPLACE VMOV->NroItm WITH VMOV->NroItm + 1
   replace rmov.fchdig  with date()
   replace rmov.hordig  with time() 
ELSE
   IF ! XsCodOpe = "9"
      DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv
   ELSE
      DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa, CodDiv
   ENDIF
   REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
   DO CalImp
   IF RMOV->TpoMov = 'D'
      REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
      REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
   ELSE
      REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
      REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
   ENDIF
ENDIF
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FCHAST WITH XDFCHAST
***REPLACE RMOV->FCHPED WITH XDFCHAST
***REPLACE RMOV->NroVou WITH XsNroVou
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->NroRuc WITH XsRucAux
REPLACE RMOV.CodDiv  WITH TsCodDiv1
IF CodMon = 1
   REPLACE RMOV->Import WITH XfImport
   IF TpoCmb = 0
      REPLACE RMOV->ImpUsa WITH 0
    ELSE
      REPLACE RMOV->ImpUsa WITH ROUND(XfImport/TpoCmb,2)
   ENDIF
ELSE
   REPLACE RMOV->Import WITH ROUND(XfImport*TpoCmb,2)
   REPLACE RMOV->ImpUsa WITH XfImport
ENDIF
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
*
replace rmov.tipdoc  with xstipdoc
*
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
*
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
*
*if rmov.codcta=[421]
if rmov.tpomov = [H]
   if empty(xdfchped)     
      repla rmov.fchped with rmov.fchvto
   else
      repla rmov.fchped with xdfchped
   endif
endif        
*
if !empty(rmov.fchped)
   repla rmov.fchped with iif(seek(dtos(rmov.fchped),[diaf]),diaf.fchven,rmov.fchped)
endif
*
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa ,CodDiv
ELSE  && EXTRA CONTABLE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa ,CodDiv
ENDIF
SELECT RMOV
DO CalImp
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+nImpUsa
ENDIF
SELE RMOV
UNLOCK
RETURN

**********************************************************************
****************************
PROCEDURE Cap_Detalle_Cursor
****************************
   XsCodDiv = C_RMOV.CodDiv
   XsCodCta = C_RMOV.CodCta
   XsClfAux = C_RMOV.ClfAux
   XsCodAux = C_RMOV.CodAux
   XsCodRef = C_RMOV.CodRef
   XcTpoMov = C_RMOV.TpoMov
   IF OPER->CodMon # 4
      XiCodMon = VMOV->CodMon
      XfTpoCmb = VMOV->TpoCmb
   ELSE
      XiCodMon = C_RMOV.CodMon
      XfTpoCmb = C_RMOV.TpoCmb
   ENDIF
   IF XiCodMon = 1
      XfImport = C_RMOV.Import
   ELSE
      XfImport = C_RMOV.ImpUsa
   ENDIF
   XfImpUsa    = C_RMOV.ImpUsa
   XfImpNac    = C_RMOV.Import

   XiNroItm = C_RMOV.NroItm
   XsGloDoc = C_RMOV.GloDoc
   XdFchDoc = C_RMOV.FchDoc
   XdFchVto = C_RMOV.FchVto
   XsNroDoc = C_RMOV.NroDoc
   XsNroRef = C_RMOV.NroRef
** XSCODFIN = C_RMOV.CODFIN
   XiCodMon = VMOV->CodMon
   XfTpoCmb = VMOV->TpoCmb
   XsIniAux = C_RMOV.IniAux
   XdFchPed = C_RMOV.FchPed
   *
   xsnivadi = C_rmov.tpoo_c
   *
   XcTipoC  = C_RMOV.TipoC
   XsNroRuc = C_RMOV.NroRuc
   XsTipDoc = iif(C_rmov.tipdoc=space(len(rmov.tipdoc)),[NO],C_rmov.tipdoc)
   *
   xstipdoc1= iif(C_rmov.tipdoc=space(len(rmov.tipdoc)),[NO],C_rmov.tipdoc)
   xscodcta1= C_rmov.codcta
   xsnroref1= C_rmov.nroref
   *
   * DATOS SUNAT
   *
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
return