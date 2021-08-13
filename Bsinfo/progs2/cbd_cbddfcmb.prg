SET DISPLAY TO VGA25
SYS(2700,0)           

**************************************************************************
* AJUSTE POR DIFERENCIA DE CAMBIO                                        *
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

**DO MOVgPant IN CBDMMOVM
SET PROCEDURE TO CBD_DiarioGeneral ADDITIVE

IF !MOVApert()
	MESSAGEBOX('Error en apertura de tablas de la base de datos',16 ,'Acceso a datos')
	GoSvrCbd.oDatAdm.Close_File('CTB')
	RETURN
ENDIF

IF ! Modificar
   GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
   MESSAGEBOX(GsMsgErr,16,'Atención')
   GoSvrCbd.oDatAdm.Close_File('CTB')
   RETURN
ENDIF


SELECT CNFG
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n dentro del sistema "
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

PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
TsCodDiv1="01"
TsCodDiv2 = ''
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv

SELECT TCMB
SEEK DTOC(GdFecha,1)
XfTC_Vta = OFIVTA
XfTC_Cmp = OFICMP



DO FORM CBD_CbdDfCmb 


RELEASE LoDatAdm
RETURN
PROCEDURE Reg_TCMB


*!*	*!*	SAVE SCREEN
*!*	*!*	GsMsgKey = "[F10] Inicia Proceso   [Esc] Cancela Proceso    [F7] Configuramos"
*!*	*!*	DO LIB_MTEC WITH 99
*!*	@ 09,20 CLEAR TO 16,120
*!*	@ 09,20       TO 16,120
*!*	@ 10,25 SAY "Generación de asiento por Diferencia de Cambio para mes de "+MES(_MEs,1)

*!*	@ 12,25 SAY "T/Cambio Compra   : " GET XfTC_Cmp  PICT "###,###.####"
*!*	@ 14,25 SAY "T/Cambio Venta    : " GET XfTC_Vta  PICT "###,###.####"
*!*	READ
*!*	IF LASTKEY() = K_Esc
*!*		GoSvrCbd.oDatAdm.Close_File('CTB')	
*!*	   	MESSAGEBOX('Proceso Interrumpido',16,'@_@')
*!*		clear

*!*	   RETURN
*!*	ENDIF
*!*	IF ! FOUND()
*!*	   APPEND BLANK
*!*	ENDIF
*!*	IF F1_RLOCK(5)
*!*	   REPLACE FCHCMB WITH GdFecha
*!*	   REPLACE OFIVTA WITH XfTC_Vta
*!*	   REPLACE OFICMP WITH XfTC_Cmp
*!*	ENDIF
*!*	IF LASTKEY() = K_F7
*!*	   SELECT CNFG
*!*	   EDIT
*!*		GoSvrCbd.oDatAdm.Close_File('CTB')
*!*	   	MESSAGEBOX('Proceso Interrumpido',16,'@_@')
*!*		clear
*!*	   RETURN
*!*	ENDIF

*******************
PROCEDURE GenDifCMB
*******************
** VETT: 2015/03/25 16:54:33 ** 
*** Controlamos la divisionaria ***
LcFiltro = '.T.'
LcFiltroMov='.T.'
IF XnCodDiv=0
	TsCodDiv1='00'
	LcFiltro = '.T.'
	LcFiltroMov='.T.'
	TsCodDiv2 = ''
ELSE
	IF XsCodDiv='**'
		TsCodDiv1='00'
		LcFiltro = '.T.'
		LcFiltroMov='.T.'
		TsCodDiv2 = ''
	ELSE
		TsCodDiv1=XsCodDiv
		LcFiltro = 'Codcta_b=XsCodDiv'
		LcFiltroMov='CodDiv=XsCodDiv'
		TsCodDiv2 = XsCodDiv
	ENDIF	
ENDIF	
** VETT: 2015/03/25 16:54:40 **


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
** VETT  05/04/2018 09:42 AM : Correlativo antepone mes + division + '0001'  Siempre sera el asiento 1 
*!*	IF XnCodDiv>0
	XsNroAst = XsNromes+TsCodDiv1+repli("0",len(rmov.nroast)-5)+'1'
				
*!*	ELSE
*!*		XsNroAst = XsNroMes+right(repli("0",len(rmov.nroast))+"1",len(rmov.nroast))
*!*	ENDIF
IF NROAST() < XsNroAst
   = NROAST(XsNroAst)
ENDIF


**SET PROCEDURE TO
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
XsGloDoc = "AJUSTE X DIF. CAMBIO"
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
** VETT  16/03/2018 04:24 PM : Tipo y fecha de referencia 
XsTipRef = []
XdFchRef = {}
** VETT  16/03/2018 04:24 PM

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
XsAuxil	= XsCodDiv
REPLACE VMOV.Auxil		WITH	XsCodDiv

DO MOVGraba IN CBD_DiarioGeneral
IF zOK
   @ WROWS()-2,1 SAY PADC("** ANULANDO MOVIMIENTO ANTERIOR **",WCOLS()-40) COLOR RGB(255,128,64,0,0,0) FONT 'Lucida Console',9 STYLE 'N'  
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
@ WROWS()-2,1 SAY PADC("** GRABANDO ASIENTO **",WCOLS()-40) COLOR RGB(255,128,64,0,0,0) FONT 'Lucida Console',9 STYLE 'N'  

Crear = .T.
SELECT CTAS
SEEK cCodCta
DO WHILE CodCta = TRIM(cCodCta) .AND. ! EOF()
	LiNroReg = LiNroReg + 1
	LiRegAct = RECNO()
	WAIT WINDOW STR((LiNroReg / RECCOUNT())*100,8,0)+' %'   NOWAIT
	IF codcta='10102'  && AND '69'$Nrodoc
	ENDIF 
	   
	IF AftDcb = "S" .AND. AftMov = "S" AND EVALUATE(LcFiltro) && Si es por divisionaria solo filtra las que coinciden con CodCta_B
		DO Actualiza
	ENDIF
	SELECT CTAS
	GOTO LiRegAct
	SKIP
ENDDO


WAIT WINDOW STR(99,8,0)+' %'    NOWAIT
* Grabando la contra cuenta ***********
XfImpUsa = 0
XsCodCta = CodCta
XfTpoCmb = 0
XsClfAux = []
XsCodAux = []
XsCodRef = []
XsNroDoc = []
XsNroRef = []
IF XiNroItm > 0
   IF SdoPas <> 0
      XfImport = ABS(SdoPas)
      XfImpNac = XfImport
      XfImpUsa = 0
      XsCodCta = XsCdCta1
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = CTAS->CLFAUX
         XsCodAux = XsCdAux1
      ELSE
         XsClfAux = ""
         XsCodAux = ""
      ENDIF
      IF SdoPas > 0
         XcTpoMov = "H"
      ELSE
         XcTpoMov = "D"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
   IF SdoAct <> 0
      XfImport = ABS(SdoAct)
      XfImpNac = XfImport
      XfImpUsa = 0
      XsCodCta = XsCdCta2
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = CTAS->CLFAUX
         XsCodAux = XsCdAux2
      ELSE
         XsClfAux = ""
         XsCodAux = ""
      ENDIF
      IF SdoAct > 0
         XcTpoMov = "H"
      ELSE
         XcTpoMov = "D"
      ENDIF
      XiNroItm = XiNroItm + 1
      DO GRABA
   ENDIF
ENDIF
 WAIT WINDOW STR(100,8,0)+' %'    NOWAIT
GoSvrCbd.oDatAdm.Close_File('CTB')
SYS(2700,1)           
@ WROWS()-2,1 SAY PADC("",WCOLS()-1) COLOR RGB(223,223,223) FONT 'Lucida Console',9 STYLE 'N'  
*!*	MESSAGEBOX('Proceso terminó correctamente',0,' :) ')

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

	IF INLIST(CodCta,'10410701','10410601','10100200')
*!*			SET STEP ON 
	ENDIF
	
   GoSvrCbd.CBDAcumd(XsCodCta , 0 , _Mes)
	IF XsCodDiv=[**]  && Consolidado
		SdoNac  =  XvCalc(6 )
		SdoExt  =  XvCalc(12)
	ELSE
		SdoNac  =  XvCalc_D(XnCodDiv,6 )
		SdoExt  =  XvCalc_D(XnCodDiv,12)
	ENDIF	   
   IF CTAS->TpoCmb = 3
      IF SdoExt > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   SdoAjte = IIF(SdoExt<>0,ROUND(SdoExt*fTpoCmb - SdoNac,2),0)
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
DO WHILE CodCta = XsCodCta .AND. !EOF()
	IF !EVALUATE(LcFiltroMov)  && Para Filtrar solo la divisionaria seleccionada VETT 2009-06-23
		SELECT RMOV
		SKIP 
		LOOP
	ENDIF
   XsClfAux = ClfAux
   XsCodAux = CodAux
   XsNroDoc = NroDoc
   XsNroRef = NroRef
   IF CiCodMon = 2
      LiCodMon = 2
   ELSE
      LiCodMon = CodMon
   ENDIF
   IF xscodcta='10102'  && AND '69'$Nrodoc

   ENDIF 
** VETT:La divisionaria ya no se busca en la operacion de provision,
** debe estar grabada previamente y solo se procesan segun la que se haya elegido en el filtro 2015/03/27 13:03:22 ** 
*!*		XsCodDiv = SPACE(LEN(RMOV.CodDiv))	
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
 ** VETT:La divisionaria ya no se busca en la operacion de provision,
 ** debe estar grabada previamente y solo se procesan segun la que se haya elegido en el filtro 2015/03/27 13:03:22 ** 
*!*	         IF CodOpe == PROV->CodOpe	OR (nromes=[00] and codope=[000])
*!*				XsCodDiv=CodDiv         
*!*	         ENDIF
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
   IF CiTpoCmb = 3
      IF LfSdoNac > 0
         fTpoCmb = XfTC_Cmp
      ELSE
         fTpoCmb = XfTC_Vta
      ENDIF
   ENDIF
   XsGloDoc = "AJUSTE x D.C./"+ALLTRIM(STR(fTpoCmb,10,3))
   XfSaldo   = LfSdoExt*fTpoCmb
   SdoAjte = ROUND(XfSaldo - LfSdoNac , 2)
   IF ABS(SdoAjte) > 0 .AND. LiCodMon = 2 AND LfSdoNac<>0
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
      RegAct1  = Recno()
      SET ORDER TO RMOV01
      DO GRABA
      SELECT RMOV
      SET ORDER TO RMOV06
      GOTO RegAct1
   ENDIF
   SELECT RMOV
ENDDO
RETURN


******************
PROCEDURE PINTALIN
******************
IF LinAct > 19
   LinAct = 19
   SCROLL LinIni+1,Xo+1,LinAct,WCOLS()-1,1
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
********************
PROCEDURE P_TERMINAR
********************
lodatadm.closetable('TABL')
lodatadm.closetable('AUXI')
lodatadm.closetable('TCMB')
lodatadm.closetable('DPRO')
lodatadm.closetable('PROV')
lodatadm.closetable('DRMOV')
lodatadm.closetable('DIAF')
lodatadm.closetable('CTA2')
lodatadm.closetable('CNFG')
lodatadm.closetable('PPRE')
lodatadm.closetable('CNFG2')
lodatadm.closetable('RMOV')
lodatadm.closetable('VMOV')
lodatadm.closetable('ACCT')
lodatadm.closetable('OPER')
lodatadm.closetable('CTAS')
