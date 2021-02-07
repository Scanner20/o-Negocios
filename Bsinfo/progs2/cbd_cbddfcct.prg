**************************************************************************
* AJUSTE POR DIFERENCIA DE SALDOS CANCELADOS CUENTA CORRIENTE   12 y 42  *
**************************************************************************
#INCLUDE CONST.H
XsNivAdi  = []
NroDec    = 4
XsNroMes  = TRANSF(_MES,"@L ##")
Modificar = .T.
GenDifCmb = .T.
TnLenGlo  = 16
TsCodDiv1 = [01]
XsCodDiv  = [01]
Modificar  = gosvrcbd.mescerrado(_mes)
IF ! Modificar
    GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
    RETURN
ENDIF

**DO MOVgPant IN CBDMMOVM
SET PROCEDURE TO CBD_DiarioGeneral ADDITIVE

IF !MOVApert()
	MESSAGEBOX('Error en apertura de tablas de la base de datos',16 ,'Acceso a datos')
	GoSvrCbd.oDatAdm.Close_File('CTB')
	RETURN
ENDIF

SELECT CNFG
XsCodCfg = "03"
SEEK XsCodCfg
IF ! FOUND()
    GsMsgErr = " No esta configurado la opci¢n dentro del sistema "
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
    RETURN
ENDIF
UltTecla = 0
XsCodOpe = CodOpe
XsNotAst = GloCfg
XdFchAst = GdFecha
XsNroVou = ""
XfTpoCmb = 0
XsDigita = GsUsuario
EscLin   = "MOVbLine"
XsNroRuc = ""

XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4
XfDif_ME = Dif_ME
XfDif_MN = Dif_MN
XsCuentas1 = Cuentas1
IF EMPTY(XsCdCta1)
    GsMsgErr = " No estan ingresada el codigo de cuenta de perdida/ganancia "
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
    RETURN
ENDIF

IF EMPTY(XsCdCta2)
    GsMsgErr = " No estan ingresada el codigo de cuenta de perdida/ganancia "
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
    RETURN
ENDIF

IF EMPTY(Cuentas1)
    GsMsgErr = " No estan ingresadas los codigos de cuentas corrientes que seran procesadas "
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
	RETURN 
ENDIF
SELECT TCMB
SEEK DTOC(GdFecha,1)
XfTC_Vta = OFIVTA
XfTC_Cmp = OFICMP
IF ! Modificar
    GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
    RETURN
ENDIF
*!*	SAVE SCREEN
*!*	GsMsgKey = "[F10] Inicia Proceso   [Esc] Cancela Proceso    [F7] Configuramos"
*!*	DO LIB_MTEC WITH 99
@ 09,20 CLEAR TO 16,120
@ 09,20       TO 16,120
@ 10,25 SAY "Generación de asiento cancelacion de saldos de la cuenta corriente para el mes de "+MES(_MEs,1)

@ 12,25 SAY "T/Cambio Compra   : " GET XfTC_Cmp  PICT "###,###.####"
@ 14,25 SAY "T/Cambio Venta    : " GET XfTC_Vta  PICT "###,###.####"
READ
IF LASTKEY() = K_Esc
	GoSvrCbd.oDatAdm.Close_File('CTB')	
   	MESSAGEBOX('Proceso Interrumpido',16,'@_@')
	clear
    RETURN
ENDIF
IF ! FOUND()
    APPEND BLANK
ENDIF
IF F1_RLOCK(5)
    REPLACE FCHCMB WITH GdFecha
    REPLACE OFIVTA WITH XfTC_Vta
    REPLACE OFICMP WITH XfTC_Cmp
ENDIF
IF LASTKEY() = K_F7
    SELECT CNFG
    EDIT
	GoSvrCbd.oDatAdm.Close_File('CTB')
   	MESSAGEBOX('Proceso Interrumpido',16,'@_@')
	clear
    RETURN
ENDIF

SELECT OPER
SEEK XsCodOpe
IF ! FOUND()
    GsMsgErr = " Operaci¢n no registrada "
    MESSAGEBOX(GsMsgErr,16,'Atención')
    GoSvrCbd.oDatAdm.Close_File('CTB')
   	MESSAGEBOX('Proceso Interrumpido',16,'@_@')
	clear
    RETURN
ENDIF
IF CODMON <> 4
    REPLACE CODMON WITH 4
ENDIF
*!*	SET PROCEDURE TO CBDMMOVM


XsNroAst = right(repli("0",len(rmov.nroast))+"2",len(rmov.nroast))
IF NROAST () < XsNroAst
    = NROAST(XsNroAst)
ENDIF


**SET PROCEDURE TO
XsCodCta1 = ''
cCodCta = ""
SdoAct  = 0
SdoPas  = 0
nImpNac = 0
nImpUsa = 0
**** Variables a Grabar *****
XcEliItm = " "
XsCodCta = ""
XsClfAux = ""
XsCodAux = ""
XsIniAux = ""
XsRucAux = ""
XsCodRef = ""
XcTpoMov = "D"
XfImport = 0
XfImpNac = XfImport
XfImpUsa = 0
XiNroItm = 0
XsGloDoc = "CANC. AUTOM. CTA. CORRIENTE"
XdFchDoc = GdFecha
*XdFchVto = {,,}
XdFchVto = {  ,  ,    }
XsCodDoc = ""
XsNroDoc = ""
XsNroRef = ""
XiCodMon = 1
XfTpoCmb = 0
xScODfIN = []
XdFchPed =XdFchAst
XsTipDoc =[]
XcTipoC  =[]
XsCodCco = []
XsCtaPre = []
XcAfecto = []
GlInterface = .f.
XsCc1Cta = []
XsAn1Cta = []
XsChkCta = []
*** VETT 2007-02-14 ***  Ini
XsNroDtr = []
XdFchDtr = {}
XsNumOri1 = []
XsTipOri1 = []
*** VETT 2007-02-14 ***  Fin

Yo       = 10
Xo       = 0
LinIni   = Yo
LinAct   = LinIni + 1
LiNroREG = 0

**** Borrando movimientos anteriores ***
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SELECT VMOV
SEEK LLave
zOK       = FOUND()
Crear    = .F.
IF ! FOUND()
    APPEND BLANK
    IF ! F1_RLOCK(5)
       RETURN              && No pudo bloquear registro
    ENDIF
    REPLACE VMOV->NROMES WITH XsNroMes
    REPLACE VMOV->CodOpe WITH XsCodOpe
    REPLACE VMOV->NroAst WITH XsNroAst
    replace vmov.fchdig  with date()
    replace vmov.hordig  with time()
ELSE
    IF !F1_RLOCK(5)
        GsMsgErr = "Asiento usado por otro usuario"
        MESSAGEBOX(GsMsgErr,16,'Atención')
        RETURN              && No pudo bloquear registro
    ENDIF
ENDIF
REPLACE VMOV->FLGEST  WITH "R"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0
REPLACE VMOV->NroItm  WITH 0
DO MOVGraba IN CBD_DiarioGeneral
IF zOK
    @ 16,1 SAY PADC("** ANULANDO MOVIMIENTO ANTERIOR **",78) COLOR R+,B+ FONT 'Lucida Console',12 STYLE 'N'  
 *   DO LIB_MSGS WITH 10
    SELECT RMOV
    XsCodFIN = CodFIN
    SEEK Llave
    ok     = .T.
    DO WHILE ! EOF() .AND.  ok .AND. Llave = (NroMes + CodOpe + NroAst )
        IF Rlock()
            SELECT RMOV
            IF ! XsCodOpe = "9"
               DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
            ELSE
               DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
            ENDIF
            DELETE
            UNLOCK
        ELSE
            ok = .f.
        ENDIF
        SKIP
    ENDDO
ENDIF
*!*	DO MOVPINTA IN CBDMMOVM
*XiCodMon = 2
@ 16,1 SAY PADC("** GRABANDO ASIENTO **",78) COLOR BG+* FONT 'Lucida Console',12 STYLE 'N'  
*** Cargamos cuentas a procesar
DIMENSION XaCuentas(1)
LlOkCtas=gosvrcbd.odatadm.chrtoarray(XsCuentas1,",",@XaCuentas)
LnTotProc= ALEN(XaCuentas)
Crear = .T.
SELECT CTAS
FOR K= 1 TO ALEN(XaCuentas)
	LsCodCta = TRIM(XaCuentas(K))
    SEEK LsCodCta
    DO WHILE CodCta = LsCodCta AND ! EOF()
        LiNroReg = LiNroReg + 1
        LiRegAct = RECNO()
        IF AftMov = "S"
     *!*	      DO Actualiza
     		XsCodCta1= CodCta  && Usamos esta variable para recordar la cuenta del plan de cuentas mas tarde
            XfImpUsa = 0
            XsCodCta = CodCta
            XfTpoCmb = 0
            XsClfAux = []
            XsCodAux = []
            XsCodRef = []
            XsNroDoc = []
            XsNroRef = []
            DO ActCtCte
        ENDIF
        WAIT WINDOW STR((LiNroReg /LnTotProc)*100,8,0)+' %'   NOWAIT
        SELECT CTAS
        GOTO LiRegAct
        SKIP
    ENDDO
ENDFOR
*!*	WAIT WINDOW STR(99,8,0)+' %'    NOWAIT
*!*	* Grabando la contra cuenta ***********
*!*	XfImpUsa = 0
*!*	XsCodCta = CodCta
*!*	XfTpoCmb = 0
*!*	XsClfAux = []
*!*	XsCodAux = []
*!*	XsCodRef = []
*!*	XsNroDoc = []
*!*	XsNroRef = []
*!*	IF XiNroItm > 0
*!*	   IF SdoPas <> 0
*!*	      XfImport = ABS(SdoPas)
*!*	      XfImpNac = XfImport
*!*	      XfImpUsa = 0
*!*	      XsCodCta = XsCdCta1
*!*	      =SEEK(XsCodCta,"CTAS")
*!*	      IF CTAS->PIDAUX="S"
*!*	         XsClfAux = CTAS->CLFAUX
*!*	         XsCodAux = XsCdAux1
*!*	      ELSE
*!*	         XsClfAux = ""
*!*	         XsCodAux = ""
*!*	      ENDIF
*!*	      IF SdoPas > 0
*!*	         XcTpoMov = "H"
*!*	      ELSE
*!*	         XcTpoMov = "D"
*!*	      ENDIF
*!*	      XiNroItm = XiNroItm + 1
*!*	      DO GRABA
*!*	   ENDIF
*!*	   IF SdoAct <> 0
*!*	      XfImport = ABS(SdoAct)
*!*	      XfImpNac = XfImport
*!*	      XfImpUsa = 0
*!*	      XsCodCta = XsCdCta2
*!*	      =SEEK(XsCodCta,"CTAS")
*!*	      IF CTAS->PIDAUX="S"
*!*	         XsClfAux = CTAS->CLFAUX
*!*	         XsCodAux = XsCdAux2
*!*	      ELSE
*!*	         XsClfAux = ""
*!*	         XsCodAux = ""
*!*	      ENDIF
*!*	      IF SdoAct > 0
*!*	         XcTpoMov = "H"
*!*	      ELSE
*!*	         XcTpoMov = "D"
*!*	      ENDIF
*!*	      XiNroItm = XiNroItm + 1
*!*	      DO GRABA
*!*	   ENDIF
*!*	ENDIF
 WAIT WINDOW STR(100,8,0)+' %'    NOWAIT
GoSvrCbd.oDatAdm.Close_File('CTB')
CLEAR 
MESSAGEBOX('Proceso terminó correctamente',0,' :) ')

RETURN

**********************************************************************
* Genera el Item por Diferencia de Cambio
**********************************************************************
PROCEDURE Actualiza
*******************
IF CTAS->CodMon = 1
   RETURN
ENDIF
XfImpUsa = 0
XsCodCta = CodCta
XfTpoCmb = 0
XsClfAux = []
XsCodAux = []
XsCodRef = []
XsNroDoc = []
XsNroRef = []
IF CTAS->TpoCmb = 1
   fTpoCmb = XfTC_Cmp
ELSE
   fTpoCmb = XfTC_Vta
ENDIF
IF CTAS->CodMon = 2   .AND. INLIST(XsCodCta,"10")
   GoSvrCbd.CBDAcumd(XsCodCta , 0 , _Mes)
   SdoNac  =  XvCalc(6 )
   SdoExt  =  XvCalc(12)
   IF CTAS->TpoCmb = 3
      IF SdoExt > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   SdoAjte = ROUND(SdoExt*fTpoCmb - SdoNac,2)
   IF SdoAjte <> 0
      DO CASE
         CASE SdoAjte > 0
            SdoAct = SdoAct + SdoAjte
         OTHER
            SdoPas = SdoPas + SdoAjte
      ENDCASE
      IF SdoAjte > 0
         XfImport = SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "D"
      ELSE
         XfImport = -SdoAjte
         XfImpNac = XfImport
         XfImpUsa = 0
         XcTpoMov = "H"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
ELSE
   DO ActCtCte
ENDIF
RETURN
**********************************************************************
* GRABA AUTOMATICAS
**********************************************************************
PROCEDURE GRABA
**** Grabando la linea activa ****
XcEliItm = " "
DO MOVbgrab WITH .t. in CBD_DiarioGeneral
*!*	DO PINTALIN
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
*XcEliItm = "ú"
XcEliItm = "*"
TsClfAux = RMOV.CLFAUX
TsCodAux = RMOV.CODAUX
TsAn1Cta = CTAS->AN1CTA
TsCC1Cta = CTAS->CC1Cta
  ** Verificamos su existencia **
IF ! SEEK(TsAn1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe o esta en blanco ["+TsAn1Cta+"] generado por ["+XsCodCta+"]. Actualizaci¢n queda pendiente, verifique el Maestro de Cuentas"
    =MESSAGEBOX(GsMsgErr,16,'Atención')
    RETURN 2
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe o esta en blanco ["+TsCc1Cta+"] generado por ["+XsCodCta+"]. Actualizaci¢n queda pendiente, verifique el Maestro de Cuentas"
    =MESSAGEBOX(GsMsgErr,16,'Atención')
    RETURN 2
ENDIF
XiNroItm = XiNroItm + 1
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbgrab WITH .t. in CBD_DiarioGeneral
*!*	DO PINTALIN
XiNroItm = XiNroItm + 1
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = ""
XsCodAux = ""
DO MOVbgrab WITH .t. in CBD_DiarioGeneral
*!*	DO PINTALIN
RETURN
**********************************************************************
* Genera el Item por Diferencia de Cambio cuando existe Cta.Cte.
**********************************************************************
PROCEDURE ActCtCte
******************
**** Buscamos si existe la cuenta en TPRO ***

SELECT PROV
GOTO TOP
DO WHILE ! EOF()
    IF XsCodCta$CodCta
       EXIT
    ENDIF
    SKIP
ENDDO
SELECT RMOV
SET ORDER TO RMOV06
SEEK XsCodCta
CiCodMon = CTAS->CodMon
CiTpoCmb = CTAS->TpoCmb
DO WHILE CodCta = XsCodCta1 .AND. !EOF()  && Aqui usamos XsCodCta1 por que XsCodCta varia en la grabación

	XsCodCta = CodCta   && Tenemos que volver a tomar la cuenta 
    XsClfAux = ClfAux
    XsCodAux = CodAux
    XsNroDoc = NroDoc
    XsNroRef = NroRef
    IF CiCodMon = 2
       LiCodMon = 2
    ELSE
       LiCodMon = CodMon
    ENDIF
    IF xscodcta='42102' AND '69'$Nrodoc
 *!*			SET STEP on
    ENDIF 
	XsCodDiv = SPACE(LEN(RMOV.CodDiv))	
    Llave  = XsCodCta+XsCodAux+XsNroDoc
    LfSdoNac = 0
    LfSdoExt = 0
    DO WHILE LLave = ( CodCta+CodAux+Nrodoc ) .AND. ! EOF()
       IF VAL(NroMes) <= _Mes
          IF CodOpe == PROV->CodOpe
             IF CiCodMon # 2
                LiCodMon = CodMon
             ENDIF
          ENDIF
          IF CodOpe == PROV->CodOpe	OR (nromes=[00] and codope=[000])
 			XsCodDiv=CodDiv         
          ENDIF
          IF TpoMov = "H"
             LfSdoNac = LfSdoNac - Import
             LfSdoExt = LfSdoExt - ImpUsa
          ELSE
             LfSdoNac = LfSdoNac + Import
             LfSdoExt = LfSdoExt + ImpUsa
          ENDIF
       ENDIF
       SKIP
    ENDDO
*!*	   IF CiTpoCmb = 3
*!*	      IF LfSdoNac > 0
*!*	         fTpoCmb = XfTC_Cmp
*!*	      ELSE
*!*	         fTpoCmb = XfTC_Vta
*!*	      ENDIF
*!*	   ENDIF
*!*	   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
*!*	   XfSaldo   = LfSdoExt*fTpoCmb
    RegAct1  = Recno('RMOV')
	*** Primero con el saldo en Moneda Nacional 
    SdoAjte = LfSdoNac 
    IF ABS(SdoAjte) > 0  AND ABS(SdoAjte)<=XfDif_MN

 *!*        DO CASE
 *!*           CASE SdoAjte > 0
 *!*              SdoAct = SdoAct + SdoAjte
 *!*           OTHER
 *!*              SdoPas = SdoPas + SdoAjte
 *!*        ENDCASE
        IF SdoAjte > 0
           XfImport = SdoAjte
           XfImpNac = XfImport
           XfImpUsa = 0
           XcTpoMov = "H"
        ELSE
           XfImport = -SdoAjte
           XfImpNac = XfImport
           XfImpUsa = 0
           XcTpoMov = "D"
        ENDIF
        XiNroItm = XiNroItm + 1
        SET ORDER TO RMOV01
        DO GRABA
        ****************************
        IF SdoAjte > 0
           XsCodCta = XsCdCta1
           XfImport = SdoAjte
           XfImpNac = XfImport
           XfImpUsa = 0
           XcTpoMov = "D"
        ELSE
           XsCodCta = XsCdCta2
           XfImport = -SdoAjte
           XfImpNac = XfImport
           XfImpUsa = 0
           XcTpoMov = "H"
        ENDIF
        =SEEK(XsCodCta,"CTAS")
        IF CTAS->PIDAUX="S"
        ELSE
           XsClfAux = ""
           XsCodAux = ""
        ENDIF
        XiNroItm = XiNroItm + 1
        DO GRABA
    ENDIF   
       ****************************
	*** 2do. con el saldo en Moneda Extranjera
    SdoAjte = LfSdoExt 
    IF ABS(SdoAjte) > 0 AND ABS(SdoAjte)<=XfDif_ME
		XsCodCta=XsCodCta1
*!*        DO CASE
*!*           CASE SdoAjte > 0
*!*              SdoAct = SdoAct + SdoAjte
*!*           OTHER
*!*              SdoPas = SdoPas + SdoAjte
*!*        ENDCASE
        IF SdoAjte > 0
           XfImport = SdoAjte
           XfImpNac = 0
           XfImpUsa = XfImport
           XcTpoMov = "H"
        ELSE
           XfImport = -SdoAjte
           XfImpNac = 0
           XfImpUsa = XfImport
           XcTpoMov = "D"
        ENDIF
        XiNroItm = XiNroItm + 1
        SET ORDER TO RMOV01
        DO GRABA
        ****************************
        IF SdoAjte > 0
           XsCodCta = XsCdCta1
           XfImport = SdoAjte
           XfImpNac = 0
           XfImpUsa = XfImport
           XcTpoMov = "D"
        ELSE
           XsCodCta = XsCdCta2
           XfImport = -SdoAjte
           XfImpNac = 0
           XfImpUsa = XfImport
           XcTpoMov = "H"
        ENDIF
        =SEEK(XsCodCta,"CTAS")
        IF CTAS->PIDAUX="S"
        ELSE
           XsClfAux = ""
           XsCodAux = ""
        ENDIF
        XiNroItm = XiNroItm + 1
        DO GRABA
    ENDIF
    SELECT RMOV
    SET ORDER TO RMOV06
    GOTO RegAct1 
ENDDO
RETURN


******************
PROCEDURE PINTALIN
******************
IF LinAct > 19
   LinAct = 19
   SCROLL LinIni+1,Xo+1,LinAct,78,1
ENDIF
Contenido = ""
DO MOVBLine WITH Contenido IN CBD_DiarioGeneral
@ LinAct,2 SAY Contenido
LinAct = LinAct + 1
@ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
RETURN
****************
function chkcta
****************
parameter _cta
return .t.
