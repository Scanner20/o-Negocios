*****************************************************************************
*  Nombre       : ccbcargo.prg												*	
*  Proposito    : Registro de Documentos de Cargo							*
*  Autor        : VETT														*
*  Creaci¢n     : 13/04/93													*
*  Actualizaci¢n: VETT 06/JUN/2000											*
*				  VETT 02/09/2003 Adaptacion para VFP 7					 	*
*****************************************************************************
** Abrimos areas a usar **
IF !verifyvar('GsLetCje','C')
	return
ENDIF
IF !verifyvar('GsChqDev','C')
	return
ENDIF
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
RELEASE LoDatAdm

DO fondo WITH 'Documentos de cargo',Goentorno.user.login,GsNomCia,GsFecha

*---------------*
SELE CTAS
** Relaciones a usar **
SELECT GDOC
SET RELATION TO GsClfCli+CodCli INTO CLIE,CODDOC INTO TDOC
*** Pintamos pantalla *************
CLEAR
***** Variables a usar *****
m.crear  = .T.
XsTpodoc = "CARGO"
Xscoddoc = SPACE(LEN(coddoc))
Xsnrodoc = SPACE(LEN(NroDoc))
XdFchdoc = Fchdoc
XdFchVto = FchVto
XdFchEmi = FchEmi
M.CodCta = CodCta
XsCodBco = CodBco
XsCodCli = CodCli
XsGlodoc = Glodoc
XiCodMon = CodMon
XfTpoCmb = TpoCmb
XfImpnet = Impnet
XfImpflt = Impflt
XfImpInt = ImpInt
XfImptot = Imptot
XcFlgEst = [P]
XcFlgUbc = [C]
XcFlgSit = [ ]
XsCodOpe = SPACE(3)
*
XsGlosa1 = Glosa1
XsGlosa2 = Glosa2
XsGlosa3 = Glosa3
XsCodRef = CodRef
XsNroRef = NroRef
*
@ 0,28 SAY " REGISTRO DE DOCUMENTOS " COLOR SCHEME 7
@ 1,28 SAY "   DOCUMENTO DE CARGO   " COLOR SCHEME 7
IF _windows OR _mac
	@  3,0 TO 22,100  PANEL
ELSE
	@  3,0 TO 22,79  PANEL
endif
@  4,5  SAY "Documento :                                      Fecha :                  "
@  5,5  SAY "Numero    :                                    Emision :                  "
DO CASE
	CASE CodDoc="CH-D"
		@  6,5  SAY "Cta. Cja  :                                Vencimiento :                  "
	CASE CodDoc="LETR"
		@  6,5  SAY "Cta. Pre  :                                Vencimiento :                  "
	OTHER
		@  6,5  SAY "                                           Vencimiento :                  "
ENDCASE
@  7,5  SAY "Cliente   :                                                               "
@  8,5  SAY "Glosa     :                                                               "
@  9,5  SAY "                                                                          "
@ 10,5  SAY "                                                                          "
@ 11,5  SAY "Moneda    :                      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ "
@ 12,5  SAY "Tip.Cambio:                      ³       Importe Neto  :                ³ "
@ 13,5  SAY "Referencia:                      ³       Otros Cargos  :                ³ "
@ 14,5  SAY "Numero    :                      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ "
@ 15,5  SAY "                                 ³       Importe Total :                ³ "
@ 16,5  SAY "                                 ³       Saldo  Actual :                ³ "
@ 17,5  SAY "Contabilidad  :                  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ "
@ 18,5  SAY "Fecha Ult.Act.:                                                           "
@ 19,5  SAY "Sit. Actual   :                                                           "
@ 20,5  SAY "Banco         :                                                           "
*          1         2         3         4         5         6         7
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*4    Documento :                                      Fecha :
*5    Numero    :                                    Emision :
*6    Cta. Cja. :                                Vencimiento :
*7    Cliente   :                                      Banco :
*8    Glosa     :
*9
*0
*1    Moneda    :                      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*2    Tip.Cambio:                      ³       Importe Neto  :                ³
*3    Referencia:                      ³       Otros Cargos  :                ³
*4    Numero    :                      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*5                                     ³       Importe Total :                ³
*6                                     ³       Saldo  Actual :                ³
*7                                     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*8    Fecha Ult.Act.:
*9    Sit. Actual   :
*0    Banco         :
*1
*2
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*          1         2         3         4         5         6         7
**********************************************************************
** Rutina principal *****
**********************************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99
xTpoDoc = XsTpoDoc
DO F1_EDIT WITH [xLlave],[xMuestra],[xEdita],[xElimina],'',[TpoDoc],xTpoDoc,'CMA'

CLEAR
CLEAR MACROS
DO close_file IN CCB_Ccbasign
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
**********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE xLlave
******************
GsMsgKey = "[Esc] Cancela         [Enter] [F10] Acepta         [F8] Consulta "
DO LIB_MTEC WITH 99
XsCodDoc   = CodDoc
XsNroDoc   = NroDoc
UltTecla = 0
i        = 1
DO WHILE .T.
   SELECT TDOC
   SET FILTER TO TpoDoc = XsTpoDoc
   @ 04,17 GET XsCodDoc   PICTURE "@!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = escape_
      SET FILTER TO
      EXIT
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
      IF ! ccbbusca("TDOC")
         SET FILTER TO
         LOOP
      ENDIF
      XsCodDoc = CodDoc
   ENDIF
   SET FILTER TO
   @ 04,17 SAY XsCodDoc   PICTURE "@!"
   SEEK XsCodDoc
   @  4,25 SAY TDOC->DesDoc
   IF ! FOUND()
      WAIT "C¢digo de Documento no registrado" NOWAIT WINDOW
      LOOP
   ENDIF
   IF XsTpoDoc <> TpoDoc
      WAIT "No es un Documento de cargo" NOWAIT WINDOW
      LOOP
   ENDIF
   SELECT GDOC
   @ 05,17 GET XsNroDoc   PICTURE "@!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = escape_
      EXIT
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
      IF ! ccbbusca("GDOC")
         LOOP
      ENDIF
      XsNroDoc = NroDoc
      UltTecla = Enter
   ENDIF
   @ 05,17 SAY XsNroDoc   PICTURE "@!"
   IF INLIST(UltTecla,Enter,escape_,F10,CtrlW)
      EXIT
   ENDIF
ENDDO
SELECT GDOC
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
IF UltTecla = escape_
   GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
   DO LIB_MTEC WITH 99
ENDIF
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE xMuestra
******************
SELE GDOC
M.DESEST = _FLGEST(FLGEST)
@  4,17 SAY CodDoc
@  4,25 SAY TDOC->DesDoc
@  4,62 SAY Fchdoc
@  5,17 SAY Nrodoc
@  5,62 SAY FchEmi
@  6,62 SAY FchVto
DO CASE
	CASE gdoc.coddoc="CH-D"
		@  6,5  SAY "Cta. Cja  :                                Vencimiento :                  "
		@  6,17 SAY CodCta
		=seek("04"+CodBco,"tabl")
		@  20,21 SAY padr(CodBco+" "+tabl.nombre,35)
	CASE gdoc.coddoc="CH-D"
		@  6,5  SAY "Cta. Pre  :                                Vencimiento :                  "
		@  6,17 SAY CodCta
	OTHER
		@  6,5  SAY "                                           Vencimiento :                  "
		@  20,21 
ENDCASE
@  7,17 SAY CodCli+' '+CLIE->NomAux
@  8,17 SAY Glosa1 PICT "@S55"
@  9,17 SAY Glosa2 PICT "@S55"
@ 10,17 SAY Glosa3 PICT "@S55"
@ 11,17 SAY IIF(CodMon=1,'S/.','US$')
@ 12,17 SAY TpoCmb    PICT "9,999.9999"
@ 12,62 SAY ImpNet    PICT "999,999,999.99"
if GDOC.CodDoc="CH-D"
	@ 13,62 SAY ImpInt    PICT "999,999,999.99"
ELSE
	@ 13,62 SAY ImpFlt    PICT "999,999,999.99"
ENDIF
@ 15,62 SAY ImpTot    PICT "999,999,999.99"
@ 16,62 SAY SdoDoc    PICT "999,999,999.99"
@ 13,17 SAY CodRef
@ 14,17 SAY NroRef
@ 17,21 SAY CODOPE+"-"+NROAST
@ 18,21 SAY FchAct
@ 19,21 SAY m.DesEst
CLEAR GETS
RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE xEdita

SELE GDOC
m.Crear = .T.
*IF &RegVal
IF &sEsRgv
   IF FLGEST#"P"
      WAIT "INVALIDO REGISTRO A MODIFICAR" NOWAIT WINDOW
      ULTTECLA = escape_
      RETURN
   ENDIF
   IF SDODOC#IMPTOT
      WAIT "DOCUMENTO TIENE AMORTIZACIONES" NOWAIT WINDOW
      ULTTECLA = escape_
      RETURN
   ENDIF
   m.Crear = .F.
   DO xMover
ELSE
   DO xInvar
ENDIF
GsMsgKey = "[] [] [Enter] Registra [F10] Graba [Esc] Cancela"
Mensaje  = ""
DO LIB_MTEC WITH 99
**
@  4,62 GET XdFchdoc
@  5,62 GET XdFchEmi
@  6,62 GET XdFchVto
DO CASE
	CASE XScoddoc="CH-D"
		@  6,5  SAY "Cta. Cja  :                                Vencimiento :                  "
		@  6,17 GET m.codcta
	CASE XScoddoc="LETR"
		@  6,5  SAY "Cta. Pre  :                                Vencimiento :                  "
		@  6,17 GET m.codcta
ENDCASE		
@  7,17 GET XsCodCli
@  8,17 GET XsGlosa1 PICT "@S55"
@  9,17 GET XsGlosa2 PICT "@S55"
@ 10,17 GET XsGlosa3 PICT "@S55"
@ 12,17 SAY XfTpoCmb PICT "9,999.9999"
@ 12,62 GET XfImpNet PICT "999,999,999.99"
IF XsCodDoc="CH-D"
	@ 13,62 GET XfImpInt PICT "999,999,999.99"
ELSE
	@ 13,62 GET XfImpFlt PICT "999,999,999.99"
ENDIF
@ 15,62 GET XfImpTot PICT "999,999,999.99"
@ 13,17 GET XsCodRef
@ 14,17 GET XsNroRef
CLEAR GETS
*** PROPIEDAD ADESIVOS *** MAAV
DO CASE
	CASE XSCODDOC=[CH-D]
		XSCODOPE=  GsChqDev  && [006]
	CASE XSCODDOC=[LETR]
		XSCODOPE=  GsLetCje && [012]
ENDCASE
*******************************
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_,F10,CtrlW)
   GsMsgKey = "[] [] [Enter] Registra [F10] Graba [Esc] Cancela"
   DO LIB_MTEC WITH 99
   DO CASE
      CASE i = 1
         @  4,62 GET XdFchdoc
         READ
         UltTecla = LASTKEY()
      CASE I = 2
         IF Crear
            XdFchEmi = XdFchDoc
         ENDIF
         @  5,62 GET XdFchEmi
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @  6,62 GET XdFchVto
         READ
         UltTecla = LASTKEY()
      CASE i = 4 and INLIST(XsCodDoc,[CH-D],[LETR])
         @  6,17 GET m.codcta
         READ
         UltTecla = LASTKEY()

         IF UltTecla = F8 && OR EMPTY(M.CODCTA)
         	SELE CTAS
         	DO CASE
         		CASE XSCODDOC=[CH-D]
         			LSBUSCA=[CTA2]
         		CASE XSCODDOC=[LETR]
         			LSBUSCA=[CPRE]
         	ENDCASE
            IF ! CBDBUSCA(LSBUSCA)
               LOOP
            ENDIF
            m.codcta = CTAS->CodCta
            XsCodBco = CTAS.CodBco
         ENDIF
		 IF !EMPTY(M.CODCTA)	         	
         	SEEK M.CODCTA
         	if ! found()
	            GsMsgErr = [ Cuenta no Registrado ]
	            DO lib_merr WITH 99
	            LOOP
	            Ulttecla = 0
         	endif
 	        @  6,17 SAY m.codcta
         ELSE
         	IF XsCodDoc="CH-D"
	           GsMsgErr = [ Ingrese Cuenta de Caja ]
	           DO lib_merr WITH 99
	           LOOP
	           Ulttecla = 0
         	ENDIF
	        @  6,17 SAY "No usa   cuenta de prestamo"
         ENDIF
         IF XSCODDOC=[CH-D]
	         =SEEK("04"+XsCodBco,"tabl")
	        @ 20,21 SAY padr(XsCodbco+" "+tabl.nombre,35)
	     ENDIF
         SELE GDOC
         UltTecla = LASTKEY()
      CASE i = 5
         XsClfAux=GsClfCli
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancelar"
         DO LIB_MTEC WITH 99
         SELE CLIE
         @  7,17 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodCli)
            IF !ccbbusca("CLIE")
               LOOP
            ENDIF
            XsCodCli = CLIE->CodAux
         ENDIF
         @ 7,17 SAY XsCodCli
         SEEK XsClfAux+XsCodCli
         IF !FOUND()
            GsMsgErr = [ Cliente no Regsitrado ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         @  7,17 SAY XsCodCli+' '+CLIE->NomAux
      CASE i = 6
         @  8,17 GET XsGlosa1 PICT "@S55"
         @  9,17 GET XsGlosa2 PICT "@S55"
         @ 10,17 GET XsGlosa3 PICT "@S55"
         READ
         UltTecla = LASTKEY()
      CASE i = 7
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,11,17,2)
      CASE i = 8
         IF SEEK(DTOS(XdFchDoc),"TCMB")
            XfTpoCmb = TCMB->OfiVta
         ENDIF
         @ 12,17 GET XfTpoCmb PICT "9,999.9999" VALID(XfTpoCmb>=0)
         READ
         UltTecla = LASTKEY()
         _CMB = XFTPOCMB

      CASE i = 9
         @ 12,62 GET XfImpNet PICT "999,999,999.99" VALID(XfImpNet> 0)
         READ
         UltTecla = LASTKEY()
      CASE i = 10
      	 if XsCodDoc="CH-D"	
	         @ 13,62 GET XfImpINT PICT "999,999,999.99" VALID(XfimpInt>=0)
         ELSE
	         @ 13,62 GET XfImpFlt PICT "999,999,999.99" VALID(Xfimpflt>=0)
         ENDIF
         READ
         UltTecla = LASTKEY()
      CASE i = 11
      	 if XsCodDoc="CH-D"	
	         @ 15,62 GET XfImptot PICT "999,999,999.99" WHEN _Verifica() VALID(Xfimptot> 0 .AND. Xfimptot=Xfimpnet+Xfimpint)
      	 else	
	         @ 15,62 GET XfImptot PICT "999,999,999.99" WHEN _Verifica() VALID(Xfimptot> 0 .AND. Xfimptot=Xfimpnet+Xfimpflt)
	     endif    
         READ
      CASE i = 12
         SELE TDOC
         SET FILTER TO TpoDoc = XsTpoDoc
         @ 13,17 GET XsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            SET FILTER TO
            LOOP
         ENDIF
         DO CASE
            CASE UltTecla = F8
               IF ! ccbbusca("TDOC")
                  SET FILTER TO
                  LOOP
               ENDIF
               XsCodRef = CodDoc
            CASE !TRIM(XsCodRef)==[]
               SEEK XsCodRef
               IF ! FOUND()
                  WAIT "C¢digo de Documento no registrado" NOWAIT WINDOW
                  LOOP
               ENDIF
         ENDCASE
         SET FILTER TO
         @ 13,17 SAY XsCodRef
      CASE i = 13 .AND. !TRIM(XsCodRef)==[]
         @ 14,17 GET XsNroRef
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 11 .AND. ! INLIST(UltTecla,Arriba,escape_) .AND. ;
      INLIST(XsCodRef,[CANJ],[PROF],[RENV])
      UltTecla = CtrlW
      EXIT
   ENDIF
   IF i = 12 .AND. !INLIST(UltTecla,escape_,Arriba) .AND. TRIM(XsCodRef)==[]
      XsNroRef = []
      UltTecla = CtrlW
      EXIT
   ENDIF
   IF i = 13 .AND. UltTecla = Enter
      UltTecla = CtrlW
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>13,13,i)
ENDDO
SELECT GDOC
IF UltTecla <> escape_
   DO GRABA
ENDIF
SELE GDOC
UNLOCK ALL
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Comit‚"
DO LIB_MTEC WITH 99
RETURN
**********************************************************************
* ELIMINA REGISTRO                                                   *
**********************************************************************
PROCEDURE xElimina
******************

IF !ctb_aper(XdFchDoc)
	RETURN
ENDIF
***
sele gdoc
IF FLGEST#"P"
   IF MESSAGEBOX("INVALIDO REGISTRO A ANULAR, DESEA CONTINUAR?",4+16,'Aviso') = 7
	   RETURN
   ENDIF
ENDIF
IF SDODOC#IMPTOT
   IF MESSAGEBOX("DOCUMENTO TIENE AMORTIZACIONES, DESEA CONTINUAR?",4+16,'Aviso') = 7
	   RETURN
   ENDIF
ENDIF
IF ! RLock()
   RETURN
ENDIF
** bloqueamos saldos **
SELECT SLDO
LlRlock=.t.
SEEK GDOC->codcli
IF !FOUND()
  	APPEND BLANK
	REPLACE CodCli WITH GDOC->codcli
ELSE
	LlRlock  =REC_LOCK(0)
ENDIF
IF ! LlRlock
   SELE GDOC
   UNLOCK ALL
   RETURN
ENDIF
** auditamos la anulacion **
*SELE VTOS
*APPEND BLANK
*IF ! RLOCK()
*   SELE GDOC
*   UNLOCK ALL
*   RETURN
*ENDIF
** actualizamo saldo del cliente **
SELE SLDO
IF GDOC->CodMon = 1
   REPLACE CgoNac WITH CgoNac - GDOC->imptot
ELSE
   REPLACE CgoUsa WITH CgoUsa - GDOC->imptot
ENDIF
UNLOCK
** auditamos anulacion **
*SELE VTOS
*REPLACE CodDoc WITH [ANUL]
*REPLACE TpoDOc WITH [Cargo]
*REPLACE FchDoc WITH DATE()
*REPLACE CodCli WITH GDOC->CodCli
*REPLACE CodMon WITH GDOC->CodMon
*REPLACE TpoCmb WITH GDOC->TpoCmb
*REPLACE TpoRef WITH GDOC->TpoDoc
*REPLACE CodRef WITH GDOC->CodDoc
*REPLACE NroRef WITH GDOC->NroDoc
*REPLACE Import WITH GDOC->ImpTot
*UNLOCK
** marcamos el documento **
SELECT GDOC
REPLACE FlgEst WITH [A]
REPLACE FchAct WITH DATE()
REPLACE SdoDoc WITH 0
IF INLIST(CODDOC,[CH-D],[LETR])
	DO xAct_Ctb WITH .t.
ENDIF
UNLOCK
DELETE   && << OJO <<
SKIP
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99
RETURN
*************************************************************************** FIN
* Procedimiento de CARGA A VARIABLES
******************************************************************************
PROCEDURE xMover

XsCodDoc = CodDoc
XsNroDoc = NroDoc
XdFchdoc = Fchdoc
XdFchEmi = FchEmi
XdFchVto = FchVto
XsCodCli = CodCli
XsGlodoc = Glodoc
XiCodMon = CodMon
XfTpoCmb = TpoCmb
XfImpnet = Impnet
XfImpflt = Impflt
XfImptot = Imptot
XfIMpInt = IMpInt
XsGlosa1 = Glosa1
XsGlosa2 = Glosa2
XsGlosa3 = Glosa3
XsCodRef = CodRef
XsNroRef = NroRef
XcFlgEst = FlgEst
XcFlgUbc = FlgUbc
XcFlgSit = FlgSit
IF XsCodDoc="LETR" AND EMPTY(FLGSIT) 
	XcFlgSit="A"     && Letra Aceptada
endif
XsNroMes = GDOC.MesCtb 
XsCodOpe = GDOC.OpeCtb 
XsNroAst = GDOC.AstCtb 


RETURN
*************************************************************************** FIN
* Procedimiento de INICIALIZAR VARIABLES
******************************************************************************
PROCEDURE xInvar

SELE GDOC
XdFchdoc = DATE()
XdFchEmi = DATE()
XdFchVto = DATE()
XsCodCli = SPACE(LEN(CodCli))
XsGlodoc = SPACE(LEN(Glodoc))
XiCodMon = 1
XfTpoCmb = 0.00
XfImpnet = 0.00
XfImpflt = 0.00
XfImptot = 0.00
XfImpInt = 0.00
XsGlosa1 = SPACE(LEN(Glosa1))
XsGlosa2 = SPACE(LEN(Glosa2))
XsGlosa3 = SPACE(LEN(Glosa3))
XsCodRef = SPACE(LEN(CodRef))
XsNroRef = SPACE(LEN(NroRef))
XcFlgEst = [P]
XcFlgUbc = [C]
XcFlgSit = [ ]
IF XsCodDoc="LETR"
	XcFlgSit="A"     && Letra Aceptada
endif
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabacion
******************************************************************************
PROCEDURE GRABA

SELE GDOC
IF m.Crear
   SEEK XsTpoDoc+XsCodDoc+XsNroDoc
   IF FOUND()
      GsMsgErr = [Registro creado por otro usuario]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   SELE SLDO
   SEEK XsCodCli
   IF ! FOUND()
      APPEND BLANK
   ENDIF
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE CodCli WITH XsCodCli
   **
   SELE GDOC
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   REPLACE TpoDoc    WITH XsTpoDoc
   REPLACE CodDoc    WITH XsCodDoc
   REPLACE NroDoc    WITH XsNroDoc
ELSE
   IF !RLOCK()
      RETURN
   ENDIF
   ** extorno del saldo del cliente **
   SELECT SLDO
   SEEK GDOC->CodCli
   IF FOUND()
      IF RLOCK()
         IF GDOC->CodMon = 1
            REPLACE CgoNac WITH CgoNac - GDOC->impTot
         ELSE
            REPLACE CgoUsa WITH CgoUsa - GDOC->impTot
         ENDIF
      ENDIF
   ENDIF
   ** verificamos si es nuevo **
   SEEK XsCodCli
   IF !FOUND()
      APPEND BLANK
      =RLOCK()
      REPLACE CodCli WITH XsCodCli
   ELSE
      =RLOCK()
   ENDIF
ENDIF
SELECT GDOC
REPLACE Fchdoc  WITH XdFchdoc
REPLACE FchEmi  WITH XdFchEmi
REPLACE FchVto  WITH XdFchVto
REPLACE CodCli  WITH XsCodCli
REPLACE Glosa1  WITH XsGlosa1
REPLACE Glosa2  WITH XsGlosa2
REPLACE Glosa3  WITH XsGlosa3
REPLACE CodMon  WITH XiCodMon
REPLACE TpoCmb  WITH XfTpoCmb
REPLACE ImpNet  WITH XfImpNet
REPLACE ImpFlt  WITH XfImpFlt
REPLACE ImpInt  WITH XfImpInt
REPLACE ImpTot  WITH XfImpTot
REPLACE SdoDoc  WITH XfImptot
REPLACE FlgEst  WITH XcFlgEst
REPLACE FlgUbc  WITH XcFlgUbc
REPLACE FlgSit  WITH XcFlgSit
REPLACE CodRef  WITH XsCodRef
REPLACE NroRef  WITH XsNroRef
IF CODDOC=[CH-D]
	REPLA CODCTA WITH M.CODCTA
	REPLA CODBCO WITH XSCODBCO
ENDIF
**
SELECT SLDO
IF GDOC->CodMon = 1
   REPLACE CgoNac WITH CgoNac + GDOC->imptot
ELSE
   REPLACE CgoUsa WITH CgoUsa + GDOC->imptot
ENDIF
UNLOCK
**
LsGloAst = ""
DO CASE
	case XsCodDoc="LETR"
		LsGloAst = "Letra aceptada en cartera:"
	CASE XsCodDoc="CH-D"
		LsGloAst = "Cheque devuelto:"
ENDCASE
SELECT GDOC
IF INLIST(CODDOC,[CH-D],[LETR])
	cResp = [S]
	cResp = Aviso(12,[ Genera Asiento (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
	IF cResp = "N"
		RETURN
	ELSE
		IF !ctb_aper(XdFchDoc)
			RETURN
		ENDIF
		DO xAct_Ctb WITH .F.
	ENDIF
ENDIF
SELE GDOC
UNLOCK
RETURN


******************
FUNCTION _verifica
******************
if XsCodDoc="CH-D"
	Xfimptot = Xfimpnet+XfimpInt
ELSE
	Xfimptot = Xfimpnet+Xfimpflt
ENDIF
RETURN .T.
******************
FUNCTION _flgest
****************
PARAMETER cFlgEst
LsSitua=" "
IF XsCodDoc="LETR"
	DO CASE
		case FlgSit="a"
			LsSitua=" Por Aceptar"
		case FlgSit="A"
			LsSitua=" Aceptada"
		case FlgSit="d"
			LsSitua=" Por entrar a descuento"
		case FlgSit="c"
			LsSitua=" Por entrar a cobranza"
		case FlgSit="C"
			LsSitua=" En cobranza"
		case FlgSit="D"
			LsSitua=" En descuento"
		case FlgSit="P"
			LsSitua=" Protestada"
		OTHER
			LsSitua=" Desconocida"
	ENDCASE
	LsSitua=LsSitua+" Planilla:"+Gdoc.NroPla
ENDIF
DO CASE
   CASE cFlgEst = "P"
      RETURN PADR("Pendiente"+LsSitua,50)
   CASE cFlgEst = "A"
      RETURN padr("Anulado  "+LsSitua,50)
   CASE cFlgEst = "C"
      RETURN padr("Cancelado"+LsSitua,50)
   CASE cFlgEst = "T"
      RETURN padr("Transito "+LsSitua,50)
ENDCASE

RETURN "         "

************************************************************************** FIN
* Objeto : Generacion del asiento contable
**************************************************************************
PROCEDURE xACT_CTB
******************
PARAMETER Anular
IF EMPTY(XsCodOpe)
	RETURN
ENDIF
SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
	GsMsgErr = [NO se pudo generar el asiento contable]
	DO lib_merr WITH 99
	RETURN
ENDIF
_MES = MONTH(XDFCHDOC)
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = NROAST()
IF CREAR
	SELECT VMOV
	SEEK (XsNroMes + XsCodOpe + XsNroAst)
	IF FOUND()
		DO LIB_MERR WITH 11
		RETURN
	ENDIF
	APPEND BLANK
	IF ! Rec_Lock(5)
		GsMsgErr = [NO se pudo generar el asiento contable]
		DO lib_merr WITH 99
		RETURN
	ENDIF
	SELECT OPER
	=NROAST(XsNroAst)
	UNLOCK
	SELECT VMOV
ELSE
	XsNroMes = GDOC->MESCTB
	XsCodOpe = GDOC->OPECTB
	XsNroAst = GDOC->AstCtb
	IF Anular
		WAIT WINDOW [Anulando Asiento:]+XsCodOpe+[ ]+XsNroAst NOWAIT
	ENDIF
	Llave = XsNroMes+XsCodOpe+XsNroAst
	SELE VMOV
	SEEK LLave
	IF !REC_LOCK(5)
		RETURN
	ENDIF
	REPLACE DbeNac  WITH 0
	REPLACE DbeUsa  WITH 0
	REPLACE HbeNac  WITH 0
	REPLACE HbeUsa  WITH 0
	SELE RMOV
	SEEK Llave
	DO WHILE !EOF() .AND. NroMes+CodOpe+NroAst = LLAVE
		DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
		SELE RMOV
		IF REC_LOCK(5)
			DELETE
		ENDIF
		SKIP
	ENDDO
	IF Anular
		SELE VMOV
		REPLACE FlgEst WITH [A]
		UNLOCK
		SELE RMOV
		UNLOCK
		DO ctb_cier
		SELE GDOC
		WAIT WINDOW [Registro anulado en contabilidad] NOWAIT
		RETURN
	ENDIF
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
REPLACE VMOV->NroMes WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->NroAst WITH XsNroAst
REPLACE VMOV->FlgEst WITH "R"
REPLACE VMOV->FchAst  WITH XdFchDoc
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH XiCodMon
REPLACE VMOV->TpoCmb  WITH _Cmb
REPLACE VMOV->NotAst  WITH LsGloAst+GDOC.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
replace vmov.fchdig  with date()
replace vmov.hordig  with time() 

* * * * * * * * * * * * * * * * * *

* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa
XsCodDoc = GDOC.CodDoc
XsCodRef = GDOC.CodRef
DO CASE
CASE GDOC.CodDoc="CH-D"
	XiNroItm = 1
	XcEliItm = SPACE(LEN(RMOV.EliItm))
	XdFchAst = VMOV.FchAst
	XsNroVou = VMOV.NroVou
	XiCodMon = VMOV.CodMon
	XfTpoCmb = _Cmb
	XsGloDoc = LsGloAst+GDOC.Nrodoc
	XdFchDoc = XdFchAst
	XdFchVto = XdFchAst
	nImpNac  = 0
	nImpUsa  = 0
	XTImport = 0
	XTImpUsa = 0
	L10Import= 0
	L10ImpUsa= 0
	** Asiento por la cuenta 12 **
	XsCodCta = LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
	SELE CTAS
	SEEK XsCodCta
	XsClfAux = CTAS->ClfAux
	XsCodAux = []
	XsCodRef = []
	XsGloDoc = []
	IF CTAS.PIDAUX=[S]
		XsClfAux = CTAS.ClfAux
		XsCodAux = GDOC.CodCli
		=SEEK(XsClfAux+XsCodAux,"CLIE")
		XsGloDoc = CLIE.NomAux
	ENDIF
	SELE RMOV
	XcTpoMov = [D]
	XdFchDoc = XdFchAst
	XdFchVto = XdFchAst
	XsCodDoc = TDOC.CODDOC
	XfImport = GDOC.ImpNet  && GDOC.Import
	XsNroDoc = GDOC.NroDoc
	XiCodMon = XiCodMon
	XsCodRef = []
	XsNroRef = []
	XcTpoMov = [D]
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	DO movbveri IN ccb_ctb
	*--------------------*
	*-- Graba Cuenta 104 --*
	XsCodCta = m.CodCta
	=SEEK(XsCodCta,[CTAS])
	XsGloDoc = LsGloAst+GDOC.NroDoc
	XdFchDoc = XdFchAst
	XdFchVto = XdFchAst
	XsCodDoc = TDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsCodRef = []
	XsNroRef = []
	XsClfAux = []
	XsCodAux = []
	XiCodMon = XiCodMon
	XfTpoCmb = XfTpoCmb
	XcTpoMov = [H]
	XfImport = ROUND(GDOC.ImpTot,2) && ROUND(GDOC.Import,2)
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	DO movbveri IN ccb_ctb
*--------------------*
CASE GDOC.CodDoc="LETR"
	XiNroItm = 1
	XcEliItm = SPACE(LEN(RMOV.EliItm))
	XdFchAst = VMOV.FchAst
	XsNroVou = VMOV.NroVou
	XiCodMon = VMOV.CodMon
	XfTpoCmb = _Cmb
	XsGloDoc = LsGloAst+GDOC.Nrodoc
	XdFchDoc = XdFchAst
	XdFchVto = XdFchAst
	nImpNac  = 0
	nImpUsa  = 0
	XTImport = 0
	XTImpUsa = 0
	L10Import= 0
	L10ImpUsa= 0
	*******************************
	** Asiento por la cuenta 12 **
	*******************************
	=SEEK(XsCodDoc,"TDOC")
	XsCodCta = LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
	SELE CTAS
	SEEK XsCodCta
	XsClfAux = CTAS->ClfAux
	XsCodAux = []
	XsCodRef = GDOC.CodRef
	XsGloDoc = []
	IF CTAS.PIDAUX=[S]
		XsClfAux = CTAS.ClfAux
		XsCodAux = GDOC.CodCli
		=SEEK(XsClfAux+XsCodAux,"CLIE")
		XsGloDoc = CLIE.NomAux
	ENDIF
	SELE RMOV
	XcTpoMov = [D]
	XdFchDoc = XdFchAst
	XdFchVto = XdFchAst
	XsCodDoc = TDOC.CODDOC
	XfImport = GDOC.ImpTot  && GDOC.Import
	XsNroDoc = GDOC.NroDoc
	XiCodMon = XiCodMon
	**XsCodRef = []
	XsNroRef = []
	XcTpoMov = [D]
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	DO movbveri IN ccb_ctb
	**-----------------------------**
	** Cuenta del Documento CodRef **
	**-----------------------------**
	XsCodRef = GDOC.CodRef
	IF EMPTY(XsCodRef)
		XsCodRef="FACT"
	ENDIF
	=SEEK(XsCodRef,"TDOC")
	IF !EMPTY(M.CODCTA)
		XsCodCta = M.CODCTA && LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
	ELSE
		XsCodCta = LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
	ENDIF
	SELE CTAS
	SEEK XsCodCta
	XsClfAux = CTAS->ClfAux
	XsCodAux = []
	XsGloDoc = []
	XsClfAux = ""
	XsCodAux = ""
	XsGloDoc = "Documento referencia:"+GDOC.CodRef+" "+Gdoc.NroDoc
	XsCtaRef = ""
	IF CTAS.PIDAUX=[S]
		XsClfAux = CTAS.ClfAux
		XsCodAux = GDOC.CodCli
		=SEEK(XsClfAux+XsCodAux,"CLIE")
		XsGloDoc = CLIE.NomAux
	ENDIF
	SELE RMOV
	XcTpoMov = [H]
	XdFchDoc = {  ,  ,    }
	XdFchVto = {  ,  ,    }
	XdFchVto = GDOC.FCHVTO
	XsCodDoc = Gdoc.CodRef
	XfImport = GDOC.ImpNet  && GDOC.Import
	XsNroDoc = GDOC.NroDoc
**	XsNroDoc = GDOC.NroRef
	XiCodMon = XiCodMon
	**XsCodRef = []
	XsNroRef = []
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	DO movbveri IN ccb_ctb
	=SEEK(XsCodDoc,"TDOC")   && Volvemos al Documento Principal CodDoc="LETR"
	*--------------------*
ENDCASE
IF INLIST(XsCodDoc,"LETR","CH-D")
	**--------------------**
	** Cuenta de Gastos **
	XsCodCta = LEFT(TDOC.CodCta2,LEN(CTAS.CodCta))
	IF XsCodDoc="CH-D" AND GsNomCia = 'ADHESIVOS'
		*** Parche para Adhesivos **
		do case
			CASE INLIST(M.CODCTA,"10411")
				XsCodCta = LEFT(TDOC.CodCta2,LEN(CTAS.CodCta))
			CASE INLIST(M.CODCTA,"10414")
				XsCodCta = LEFT(TDOC.CodCta3,LEN(CTAS.CodCta))
		endcase
		*** Ojo este es un parche ***
	ENDIF
	SELE CTAS
	SEEK XsCodCta
	XsClfAux = CTAS->ClfAux
	XsCodAux = []
	XsCodRef = []
	XsGloDoc = []
	XsClfAux = ""
	XsCodAux = ""
	XsGloDoc = "Gastos por"+XsCodDoc+":"+Gdoc.NroDoc
	SELE RMOV
	XcTpoMov = [D]
	XdFchDoc = {  ,  ,    }
	XdFchVto = {  ,  ,    }
	XsCodDoc = []
	XfImport = IIF(XsCodDoc="CH-D",GDOC.ImpInt,GDOC.ImpFlt)  && GDOC.Import
	XsNroDoc = ""
	XiCodMon = XiCodMon
	XsCodRef = []
	XsNroRef = []
	XcTpoMov = [D]
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	DO movbveri IN ccb_ctb
ENDIF
SELE GDOC
DO WHILE !RLOCK()
ENDDO
** Datos para la anulacion **
replace GDOC.MesCtb WITH XsNroMes
REPLACE GDOC.OpeCtb WITH XsCodOpe
REPLACE GDOC.AstCtb WITH XsNroAst
UNLOCK
** Cerramos bases de datos **
WAIT [Fin de Generacion] WINDOW NOWAIT
DO Imprvouc IN Ccb_Ctb
DO ctb_cier
RETURN
