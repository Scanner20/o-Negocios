*******************************************************************************
*  Nombre        : ccbnban2.prg                                               *
*  Sistema       : CUENTAS POR COBRAR                                         *
*  Autor         : VETT                                                       *
*  Proposito     : Ingreso por Notas Bancarias                                *
*  Creacion      : 28/03/94                                                   *
*  Actualizacion : VETT 22/08/95 Generar asientos contables                   *
*                  Solo se puede crear y anular documentos                    *
*                  Correcci¢n de asiento contable seg£n reestructuraci¢n de   *
*                  estado del documento                                       *
*  VETT 15/09/95 : Opci¢n de poder modificar la N/BC... algo m s ?            *
*  MAAV 20/05/00 : CODIGO DE OPERACION DIFERENTE PARA D Y C                   *
*				   VETT 02/09/2003 Adaptacion para VFP 7				      *
*******************************************************************************
PARAMETERS __cFlgSit

IF VARTYPE(__cFlgSit)<>'C'
	__cFlgSit = 'C'
ENDIF
IF !INLIST(__cFlgSit,'C','D','G')
	__cFlgSit = 'C'
ENDIF

IF !verifyvar('GsLetCob','C')
	return
ENDIF
IF !verifyvar('GsLetDes','C')
	return
ENDIF
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
Do FONDO WITH 'NOTAS BANCARIAS '+cTitulo ,goEntorno.User.Login,GsNomCia,GsFecha
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')

#INCLUDE CONST.H
STORE '' TO xpantalla
STORE 0 TO DFGastos,DFInteres
DO NOTAS_BANC

LoConTab.odatadm.close_file('CJA')
LoConTab.odatadm.close_file('CCB_CJA')
RELEASE LoContab 
CLEAR
CLEAR MACROS
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
SYS(2700,1)
********************
PROCEDURE NOTAS_BANC
********************
** Pintamos Pantalla **
DO xPanta
** abrimos bases de datos **
LoContab.oDatAdm.abrirtabla('ABRIR','CBDTCNFG','CNFG','CNFG01','')
SELECT CNFG
XsCodCfg = "01"
SEEK XsCodCfg
IF ! FOUND()
   GsMsgErr = " No Configurado la opci¢n de diferencia de Cambio "
   DO LIB_MERR WITH 99
   RETURN
ENDIF
XsCdCta1 = CodCta1
XsCdCta2 = CodCta2
XsCdCta3 = CodCta3
XsCdCta4 = CodCta4
XsCdAux1 = CodAux1
XsCdAux2 = CodAux2
XsCdAux3 = CodAux3
XsCdAux4 = CodAux4

** VETT:Tope Maximo y Minimo para aplicar Dif.Cambio  - 2015/05/04 12:26:54 ** 
XfDif_ME = IIF(Dif_ME<>0,Dif_ME,.09)
XfDif_MN = IIF(Dif_MN<>0,Dif_MN,.09)
IF Dif_ME=0 OR Dif_MN=0
	=MESSAGEBOX('Los valores máximos para la generación de ajuste por redondeo de diferencia cambio no estan completos.'+;
				 ' Modificar en la opcion "Configuración de Diferencia de Cambio" en el Menu de Configuración.',0+64,'Aviso importante')
	 
ENDIF

LoContab.oDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBNTASG','TASG','TASG01','')
LoContab.oDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')
* * * * * *
STORE 0 TO nImpNac,nImpusa
*
** relaciones a usar **
SELE TASG
SET RELA TO GsClfCli+CodCli INTO AUXI
** variables del sistema **
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XsNroPla,XiCodMon,XfTpoCmb
PRIVATE XsCodCta,XsCodBco,XfImpDoc,XsGloDoc
PRIVATE m.NroDoc,XcFlgEst,XcFlgLiq
PRIVATE XdFchIng
XsCodDoc = [N/BC]
XsNroDoc = SPACE(LEN(TASG->NroDoc))
XsNroPla = SPACE(LEN(TASG->NroRef))
m.NroDoc = []
XdFchDoc = DATE()
XdFchIng = DATE()
XiCodMon = 1
XfTpoCmb = 0.00
XsCodCta = SPACE(LEN(TASG->CodCta))
XsCtaCob = SPACE(LEN(CTAS->CodCta))
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaDe1 = SPACE(LEN(CTAS->CodCta))
XsCodBco = SPACE(LEN(TASG->CodBco))
XsCtaGas = SPACE(LEN(CTAS->CodCta))
XsCtaInt = SPACE(LEN(CTAS->CodCta))

XfImpDoc = 0.00
XsGloDoc = SPACE(LEN(TASG->GloDoc))
XcFlgEst = [E]
XcFlgLiq = [P]
Crear    = .F.

TsCodDoc = 'LETR'
TsFlgUbc = 'B'
** variables del Browse **
PRIVATE XsCodCli,XsTpoRef,XsCodRef,XsNroRef,XfImport
STORE SPACE(LEN(VTOS->CodCli)) TO XsCodCli
STORE [CARGO]                  TO XsTpoRef
STORE [LETR]                   TO XsCodRef
STORE SPACE(LEN(VTOS->NroRef)) TO XsNroRef
STORE 0.00                     TO XfImport
PRIVATE CIMAXELE,AsTpoDoc,AsCodDoc,AsNroDOc,AfImport,AiNumReg,GiTotItm
PRIVATE AfInteres,AfGastos
CIMAXELE = 20
DIMENSION AsTpoDoc(CIMAXELE)
DIMENSION AsCodDoc(CIMAXELE)
DIMENSION AsNroDoc(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)
DIMENSION AfInteres(CIMAXELE)
DIMENSION AfGastos(CIMAXELE)


STORE [CARGO]                 TO AsTpoDoc
STORE [LETR]                  TO AsCodDoc
STORE SPACE(LEN(VTOS.NroRef)) TO AsNroDoc
STORE 0                       TO AfImport,AfInteres,AfGastos
STORE 0                       TO AiNumReg
STORE 0                       TO GiTotItm
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
** Logica principal **
SELE TASG
UltTecla = 0
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99
xCodDoc = XsCodDoc
DO F1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],'xImprime',[CodDoc],xCodDoc,'CMAR'

RETURN
********************************************************************** EOP() *
* Objeto : Pintado de Pantalla
******************************************************************************
PROCEDURE xPanta

*           1         2         3         4         5         6         7
*001234567890123456789012345678901234567890123456789012345678901234567890123456789
*2    No. Ingreso    :                              Fecha de Cancel.: 99/99/99
*3    No. Referencia :                              Fecha Contable  : 99/99/99
*4    Cta. Bancaria  : 12345 1234567890123456789012345678901234567890
*5    Nro. Cuenta    : 123456789012345
*6    Banco          : 123 1234567890123456789012345678901234567890
*7    Moneda         : S/.                     Tipo de Cambio : 9,999.9999
*8    Observaciones  :
*9     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*0     ³ Docum.   Numero   Emision  Vencimto.      Saldo          Pago      ³
*1     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*2     ³  FACT  1234567890 99/99/99 99/99/99  999,999,999.99 999,999,999.99 ³
*3     ³                                                                    ³
*4     ³                                                                    ³
*5     ³                                                                    ³
*6     ³                                                                    ³
*7     ³  FACT  1234567890 99/99/99 99/99/99  999,999,999.99 999,999,999.99 ³
*8     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ T O T A L : 999,999,999.99 Ù
		   *01234567890123456789012345678901234567890123456789012345678901234567890123456789
		   *          1         2         3         4         5         6         7


CLEAR
Titulo = [ ** NOTAS BANCARIAS ]+ IIF(__cFlgSit='C','LETRAS EN COBRANZA','LETRAS EN DESCUENTO')+[  **]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  2,4  SAY "No. Ingreso    :                              Fecha de Cancel.:        "
@  3,4  SAY "No. Planilla   :                              Fecha Contable  :        "
@  4,4  SAY "Cta. Bancaria  :                                                       "
@  5,4  SAY "Nro. Cuenta    :                                                       "
@  6,4  SAY "Banco          :                                                       "
@  7,4  SAY "Moneda         :                         Tipo de Cambio :              "
@  8,4  SAY "Observaciones  :                                                       "
@  9,4  SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 10,4  SAY " ³ Docum.   Numero   Emision      Vencimiento         Saldo        Pago  ³"
@ 11,4  SAY " ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 12,4  SAY " ³                                                                       ³"
@ 13,4  SAY " ³                                                                       ³"
@ 14,4  SAY " ³                                                                       ³"
@ 15,4  SAY " ³                                                                       ³"
@ 16,4  SAY " ³                                                                       ³"
@ 17,4  SAY " ³                                                                       ³"
@ 18,4  SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ T O T A L :                   Ù"
 	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789
		*          1         2         3         4         5         6         7

@ 10,6  SAY " Docum.   Numero   Emision    Vencimiento           Saldo        Pago  " COLOR SCHEME 7
@ 18,46 SAY " T O T A L : " COLOR SCHEME 7
IF __cFlgSit='D'
	@ 19,46 SAY " GASTOS    : " COLOR SCHEME 7
	@ 20,46 SAY " INTERESES : " COLOR SCHEME 7
	@ 21,46 SAY " TOTAL NETO: " COLOR SCHEME 7
ENDIF
SAVE SCREEN TO xPantalla

RETURN
********************************************************************** FIN() *
* Objeto : Poner datos en pantalla
******************************************************************************
PROCEDURE xPoner

@  2,21 SAY NroDoc
@  2,68 SAY FchDoc PICT "@RD DD/MM/AA"
@  3,68 SAY FchIng PICT "@RD DD/MM/AA"
@  3,21 SAY NroRef
=SEEK(TASG->CodCta,"CTAS")
=SEEK("04"+TASG->CodBco,"TABLA")
@  4,21 SAY CodCta+' '+CTAS->NomCta
@  5,21 SAY CTAS->NroCta
@  6,21 SAY CodBco+' '+TABLA->Nombre
@  7,21 SAY IIF(CodMon=1,'S/.','US$')
@  8,21 SAY GloDoc
** pintado del browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
DO xBrowse
* * * * * * * * * * * * *
SELE TASG
@  18,63 SAY ImpDoc PICT "999,999,999.99"
IF __cFlgSit='D'
	@  19,63 SAY IntDoc PICT "999,999,999.99"
	@  20,63 SAY IntIgv PICT "999,999,999.99"
	@  21,63 SAY ImpDoc - IntDoc + IntIgv PICT "999,999,999.99"
ENDIF

IF FLgEst='A'
	@ 26,12 SAY "DOCUMENTO: ANULADO"  FONT "Foxfont",12 STYLE 'B'  color r+/n
ELSE
    @ 26,12 clear to 26,WCOLS()-2
ENDIF


RETURN
********************************************************************** FIN() *
* Objeto : Llave de acceso
******************************************************************************
PROCEDURE xLlave
RESTORE SCREEN FROM xpantalla
** Control Correlativo **
SELE TDOC
SEEK XsCodDoc
IF !FOUND()
   GsMsgErr = [ No existe Correlativo ]
   DO lib_merr WITH 99
   UltTecla = Escape_
   RETURN
ENDIF
XsNroDoc = PADR(RIGHT("000000"+ALLTRIM(STR(NroDoc)),6),LEN(TASG->NroDoc))
m.NroDoc = XsNroDoc
*

UltTecla = 0
i = 1
SELE TASG
DO WHILE ! INLIST(UltTecla,Escape_)
   DO CASE
      CASE i = 1
         @  2,21 GET XsNroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
            IF ! cjabusca("0001")
               LOOP
            ENDIF
            XsNroDoc = NroDoc
            KEYBOARD '{ENTER}' 
         ENDIF
         @ 2,21 SAY XsNroDoc
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
SEEK XsCodDoc+XsNroDoc

RETURN
********************************************************************** FIN() *
* Objeto : Tomar datos adicionales
******************************************************************************
PROCEDURE xTomar

* OJO > Siempre es crear *
IF cvctrl=[C]
   Crear = .T.
   DO xInvar
   
ELSE
   IF FlgEst = [A]
      GsMsgErr = [Documento anulado]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF FlgEst # [E]
      GsMsgErr = [Acceso Denegado]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF FlgLiq = [L]
      GsMsgErr = [Documento con Cierre de Caja]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   Crear = .F.
   DO xMover
ENDIF
*
@  2,68 GET XdFchDoc DISABLE PICT "@RD DD/MM/AA"
@  3,68 GET XdFchIng DISABLE PICT "@RD DD/MM/AA"
@  3,21 GET XsNroPla DISABLE
@  4,21 GET XsCodCta DISABLE
@  8,21 GET XsGloDoc DISABLE
*
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,Escape_)
   i = IIF(!Crear.AND.i<4,4,i)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1
         SELE AUXI
         @ 2,68 GET XdFchDoc PICT "@RD DD/MM/AA"
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         @ 3,68 GET XdFchIng PICT "@RD DD/MM/AA"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         ** Rutina que apertura las base contables a usar y ademas **
         ** verifica que el mes contables NO este cerrado **
         IF !ctb_aper(XdFchIng)
            i = i - 1
            UltTecla = 0
            LOOP
         ENDIF
         @ 3,21 GET XsNroPla PICT "@!"
         READ
         UltTecla = LASTKEY()
         SELE GDOC
         SET FILTER TO FlgEst='P'
         SET ORDER TO GDOC10    && CODDOC+FLGUBC+FLGSIT+NROPLA+CODCTA
         IF UltTecla = F8
         	m.CodDoc=TsCodDoc
         	m.FlgUbc=TsFlgUbc
         	m.FlgSit=__cFlgSit
            seek TsCODDOC+TsFLGUBC+__cFlgSit+TRIM(XsNROPLA)
            IF !CcbBusca("0015")
               UltTecla = 0
               LOOP
            ENDIF
            XsNroPla = GDOC.NroPla
            UltTecla = Enter
         ENDIF
         @  3,21 SAY XsNroPla PICT "@!"
         TsLlave = TsCODDOC+TsFLGUBC+__cFlgSit+TRIM(XsNROPLA)
         IF SEEK(TsLlave) AND !EMPTY(XsNroPla)
         	XsCodCta=GDOC.CODCTA
         	=muestra_Cta_Dat()
         ENDIF
         SELECT GDOC
		 SET ORDER TO GDOC01		
		 SET FILTER TO 
		 IF !EMPTY(XsCodCta) AND XsCodCta=CTAS.CodCta
		 	i=5
		 	loop
		 ENDIF
      CASE i = 4
         GsMsgKey = "[Home] [End] Posicionar   [Enter] Seleccion   [Esc] Cancelar"
         DO lib_mtec WITH 99
         SELE CTAS
         @  4,21 GET XsCodCta PICT "@ "+[104]+REPLI("9",LEN(XsCodCta)-3)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla=F8 .OR. EMPTY(XsCodCta)
            IF ! ccbbusca("MCTA")
               LOOP
            ENDIF
            XsCodCta = CodCta
         ENDIF
         SEEK XsCodCta
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         =muestra_Cta_Dat()
      CASE i = 5
         IF SEEK(DTOS(XdFchIng),"TCMB")
            XfTpoCmb = TCMB.OfiVta
         ENDIF
         @ 7,62 GET XfTpoCmb PICT "9,999.9999" VALID XfTpoCmb>0
         READ
         UltTecla = LASTKEY()
      CASE i = 6
         @  8,21 GET XsGloDoc
         READ
         UltTecla = LASTKEY()
      CASE i = 7
         IF !Crear
            DO xCarga
            ** pintado del browse **
			PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
			Consulta = .T.
			Modifica = .F.
			Adiciona = .F.
			DB_Pinta = .F.
            DO XBrowse
         ELSE
         	IF !EMPTY(XsNroPla)
				xCarga_Planilla(__cFlgSit,XsNroPla,XsCodCta)
			ENDIF
			DO xBrowse1

         
	         XfImpDoc = 0	
	         FOR K= 1 TO GiTotItm
	         	XfImpDoc = XfImpDoc + AfImport(K)			
	         ENDFOR
	         @  18,63 SAY XfImpDoc PICT "999,999,999.99"
			 IF __cFlgSit = 'D'   AND CREAR    
			 	XfImport    = XfImpDoc
			 	XfGastos 	= DfGastos
			 	XfInteres  	= DFInteres
			 	DO CcbNBan2.spr 		
			 	DfGastos 	=  XfGastos
			 	DfInteres 	= XfInteres
				@  19,59 SAY DfGastos PICT "999,999,999.99"
				@  20,59 SAY DfInteres PICT "999,999,999.99"
				@  21,59 SAY XfImpDoc - DfGastos + DfInteres PICT "999,999,999.99"
	         ENDIF
	         cResp = [S]
			 cResp = Aviso(12,[ DESEA GRABAR (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
		     IF cResp = "S"
				 UltTecla = ENTER
			 ELSE
				 UltTecla = Escape_	 			
	    	 ENDIF     
	     ENDIF	
         IF UltTecla = Escape_ AND !Crear
             **DO xGrbAnt
         ENDIF
         UltTecla = IIF(UltTecla=Escape_,Escape_,Enter)
   ENDCASE
   IF i = 7 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>7,7,i)
ENDDO
SELE TASG
IF UltTecla # Escape_ AND CREAR
	DO xGraba
ENDIF
*
DO ctb_cier
*
SELE TASG
UNLOCK ALL

RETURN
********************************************************************** FIN() *
* Objeto : Cargar Variables
******************************************************************************
PROCEDURE xMover

** datos de la cabecera **
SELE TASG
XdFchDoc = TASG->FchDoc
XdFchIng = TASG->FchIng
XsNroPla = TASG->NroRef
XiCodmon = TASG->CodMon
XfTpoCmb = TASG->TpoCmb
XsCodCta = TASG->CodCta
=SEEK(XsCodCta,"CTAS")
XsCtaDes = CTAS->CtaDes
XsCtaCob = CTAS->CtaCob
XsCodBco = TASG->CodBco
XfImpDoc = TASG->ImpDoc
XcFlgEst = TASG->FlgEst
XcFlgLiq = TASG->FlgLiq
DfGastos  = TASG.IntDoc
DfInteres = TASG.IntIgv

SELE VTOS
** variables del browse **
STORE [CARGO]                 TO AsTpoDoc
STORE [LETR]                  TO AsCodDoc
STORE SPACE(LEN(VTOS.NroRef)) TO AsNroDoc
STORE 0                       TO AfImport
STORE 0                       TO AiNumReg
STORE 0                       TO GiTotItm
SELE TASG
RETURN
********************************************************************** FIN() *
* Objeto : Inicializa variables
******************************************************************************
PROCEDURE xInvar

XdFchDoc = DATE()
XdFchIng = DATE()
XsNroPla = SPACE(LEN(TASG->NroRef))
XiCodMon = 1
XfTpoCmb = 0.00
XsCodCta = SPACE(LEN(TASG->CodCta))
XsCodBco = SPACE(LEN(TASG->CodBco))
XfImpDoc = 0.00
XsGloDoc = SPACE(LEN(TASG->GloDoc))
XcFlgEst = [E]
XcFlgLiq = [P]
STORE 0 TO DFGastos,DfInteres
** variables del browse **
STORE [CARGO]                 TO AsTpoDoc
STORE [LETR]                  TO AsCodDoc
STORE SPACE(LEN(VTOS.NroRef)) TO AsNroDoc
STORE 0                       TO AfImport,AfInteres,AfGastos
STORE 0                       TO AiNumReg
STORE 0                       TO GiTotItm

RETURN
********************************************************************** FIN() *
* Objeto : Grabar Cabecera
******************************************************************************
PROCEDURE xGraba
** OJO >> Siempre va a ser crear **

IF Crear
   SELE TASG
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   STORE RECNO() TO iRECNO
   ** control del correlativo **
   SELE TDOC
   SEEK XsCodDoc
   IF ! RLOCK()
      RETURN
   ENDIF
   IF m.NroDoc = XsNroDoc
      XsNroDoc = PADR(RIGHT("000000"+ALLTRIM(STR(NroDoc)),6),LEN(TASG->NroDoc))
      ** verificamos su existencia **
      IF SEEK(XsCodDoc+XsNroDoc,"TASG")
         GsMsgErr = [Registro creado por otro usuario]
         DO lib_merr WITH 99
         RETURN
      ENDIF
      REPLACE NroDoc WITH NroDoc+1
   ELSE
      ** verificamos su existencia **
      IF SEEK(XsCodDoc+XsNroDoc,"TASG")
         GsMsgErr = [Registro creado por otro usuario]
         DO lib_merr WITH 99
         RETURN
      ENDIF
      IF XsNroDoc>=m.NroDoc
         REPLACE NroDoc WITH VAL(XsNroDoc)+1
      ENDIF
   ENDIF
   UNLOCK
   ** fin de control de correlativo **
   SELE TASG
   GO iRECNO
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   SELE TASG
   =REC_LOCK(0)
   STORE RECNO() TO iRECNO
ENDIF
@ 2,21 SAY XsNroDoc
REPLACE FchDoc WITH XdFchDoc
REPLACE FchIng WITH XdFchIng
REPLACE NroRef WITH XsNroPla
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE CodCta WITH XsCodCta
REPLACE CodBco WITH XsCodBco
REPLACE GloDoc WITH XsGloDoc
REPLACE FlgEst WITH XcFlgEst
REPLACE FlgLiq WITH XcFlgLiq
REPLACE ImpDoc WITH XfImpDoc
REPLACE IntDoc WITH  DfGastos 
REPLACE IntIgv WITH  DfInteres


* Grabamos Detalle y Generamos asiento contable *
IF !Crear
   ** Borramos datos anteriores **
   DO xBrrAnt
ENDIF
DO xBGrab

RETURN
********************************************************************** FIN() *
* Browse
******************************************************************************
PROCEDURE xBrowse

PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = []
InsLin   = []
EscLin   = "MOVbline"
EdiLin   = []
BrrLin   = []
GrbLin   = []
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = [CodDoc+NroDoc]
VClave   = TASG->CodDoc+TASG->NroDoc
HTitle   = 1
Yo       = 11
Xo       = 5
Largo    = 8
Ancho    = 73
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = []
Static   = .F.
VSombra  = .F.
**
SELE VTOS
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Escribe la linea
******************************************************************************
PROCEDURE MOVbline
PARAMETER Cadena

SET ORDER TO GDOC01 IN GDOC
=SEEK(XsTpoRef+CodRef+NroRef,"GDOC")
iSdoDoc = GDOC->SdoDoc
SELE VTOS
IF TASG->CodMon#GDOC->CodMon
   IF TASG->CodMon = 1
      iSdoDoc = ROUND(GDOC->SdoDoc*TASG->TpoCmb,2)
   ELSE
      iSdoDoc = ROUND(GDOC->SdoDoc/TASG->TpoCmb,2)
   ENDIF
ENDIF
Cadena = ' '+CodRef+'  '+NroRef+' '+DTOC(GDOC->FchDoc)+' '+DTOC(GDOC->FchVto)
Cadena = cadena+'  '+TRANS(iSdoDoc,'999,999,999.99')+' '+TRANS(Import,'999,999,999.99')

RETURN
************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE xBrowse1

EscLin   = "xBline"
EdiLin   = "xBedit"
BrrLin   = "xBborr"
InsLin   = "xBinse"
PrgFin   = []
*
Yo       = 11
Xo       = 5
Largo    = 8
Ancho    = 73
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
DO aBrowse
GiTotItm = MaxEle

*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea
******************************************************************************
PROCEDURE xBline
PARAMETER NumEle,NumLin
SELE GDOC
iSdoDoc = 0
IF AiNumReg(NumEle)>0
   GO AiNumReg(NumEle)
   iSdoDoc = SdoDoc
ELSE
   GO BOTT
   SKIP
ENDIF
@ NumLin,8  SAY AsCodDoc(NumEle)
@ NumLin,14 SAY AsNroDoc(NumEle)
@ NumLin,25 SAY GDOC.FchDoc
@ NumLin,34 SAY GDOC.FchVto
IF XiCodMon#GDOC.CodMon
   IF XiCodMon = 1
      iSdoDoc = ROUND(GDOC->SdoDoc*XfTpoCmb,2)
   ELSE
      iSdoDoc = ROUND(GDOC->SdoDoc/XfTpoCmb,2)
   ENDIF
ENDIF
@ NumLin,44 SAY iSdoDoc PICT "999,999,999.99"
@ NumLin,59 SAY AfImport(NUmEle) PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit
PARAMETER NumEle,NumLin

XsTpoRef = AsTpoDoc(NumEle)
XsCodRef = AsCodDoc(NumEle)
XsNroRef = AsNroDoc(NumEle)
XfImport = AfImport(NumEle)
XiNumReg = AiNumReg(NumEle)
XfInteres= AfInteres(NumEle)
XfGastos = AfGastos (NumEle)
*
PRIVATE i,m.SdoDoc
STORE 0 TO m.SdoDoc     && Control de Saldo
STORE 0 to XfTotalG
*
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape_,CtrlW,F10)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         @ NumLin,8  SAY XsCodRef
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [] Anterior  [Enter] Registra"
         DO lib_mtec WITH 99
         SELE GDOC
         SET ORDER TO GDOC06
         @ NumLin,14 GET XsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroRef)
            IF ! ccbbusca("0009")
               LOOP
            ENDIF
            XsNroRef = NroDoc
         ENDIF
         SET ORDER TO GDOC05
         SEEK [P]+XsTpoRef+XsCodRef+XsNroRef
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         
       	IF INLIST(GsSigCia,'AROMAS','QUMICA') AND DTOS(FCHDOC)<='20060518' AND FlgUBC#'B'
       		IF MESSAGEBOX('Este documento pertenece al sistema anterior, posiblemente sea necesario'+CRLF+;
       		 		     'cambiar su estado para que el sistema lo pueda procesar, Desea Continuar ?',4+32,'ATENCION !!!') = 6
       				=RLOCK()
       				REPLACE FlgUbC WITH TsFlgUbc
       				unlock
       		ENDIF
       	ENDIF

         
         IF FlgUbc # [B]
            GsMsgErr = [Letra no se encuentra en el Banco]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF FlgSit $ [cdg]
            DO CASE
               CASE FlgSit = [c]
                    GsMsgErr = [Cobranza de Letra no esta aprobadado]
               CASE FlgSit = [d]
                    GsMsgErr = [Descuento de Letra no esta aprobadado]
               CASE FlgSit = [g]
                    GsMsgErr = [Letra en Garant¡a no esta aprobadado]
            ENDCASE
            DO lib_merr WITH 99
            LOOP
         ENDIF

         IF PADR(CodCta,LEN(CTAS.CODCTA)) # PADR(XsCodCta,LEN(CTAS.CodCta))
            GsMsgErr = [Letra no esta en este Banco]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         m.SdoDoc = SdoDoc
         IF XiCodMon # GDOC->CodMon
            GsMsgErr = [ La moneda del documento no coincide con la del Banco]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF FchDoc > XdFchDoc
            GsMsgErr = [ La fecha de la N/Bancaria es ANTERIOR al documento ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         XsCodCli = GDOC->CodCli
         XfImport = m.SdoDoc
         XiNumReg = RECNO()
         @ NumLin,14 SAY XsNroRef
         @ NumLin,25 SAY GDOC->FchDoc
         @ NumLin,34 SAY GDOC->FchVto
         @ NumLin,44 SAY m.SdoDoc PICT "999,999,999.99"
     CASE i = 2
        @ NumLin,59 GET XfImport PICT "999,999,999.99" VALID(XfImport<=m.SdoDoc)
        READ
        UltTecla = LASTKEY()
        IF FlgSit="C"
         	do ccbnban2.spr
         	ULTTECLA = ENTER
         endif

         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(INLIST(UltTecla,Arriba,BackTab,Izquierda), i-1, i+1)
   i = IIF(i>2, 2, i)
   i = IIF(i<2, 2, i)
ENDDO
SELECT VTOS
IF UltTecla # Escape_
   AsTpoDoc(NumEle) = XsTpoRef
   AsCodDoc(NumEle) = XsCodRef
   AsNroDoc(NumEle) = XsNroRef
   AfImport(NumEle) = XfImport
   AfInteres(NumEle) = XfInteres
   AfGastos(NumEle) = XfGastos
   AiNumReg(NumEle) = XiNumReg
   ** VETT: Calcula Importe Total  - 2015/05/04 16:01:53 ** 
   DO LETREGEN
ENDIF
DO LIB_MTEC WITH 14

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE LetRegen

PRIVATE j
j = 1
STORE 0 TO Tfimpdoc
DO WHILE j <= GiTotItm
   TfImpdoc = TfImpdoc + AfImport(j) +  AfInteres(j) - AfGastos(j)
   j = j + 1
ENDDO
@  18,63  SAY TfImpdoc PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE xBborr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
DO WHILE i <  GiTotItm
   AsTpoDoc(i) = AsTpoDoc(i+1)
   AsCodDoc(i) = AsCodDoc(i+1)
   AsNroDoc(i) = AsNroDoc(i+1)
   AfImport(i) = AfImport(i+1)
   AiNumReg(i) = AiNumReg(i+1)
   AfInteres(i)= AfInteres(i+1)
   AfGastos(i) = AfGastos(i+1)
   
   i = i + 1
ENDDO
STORE [CARGO]                 TO AsTpoDoc(i)
STORE [LETR]                  TO AsCodDoc(i)
STORE SPACE(LEN(VTOS.NroRef)) TO AsNroDoc(i)
STORE 0                       TO AfImport(i),AfInteres(i),AfGastos(i)
STORE 0                       TO AiNumReg(i)
GiTotItm = GiTotItm - 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE xBinse
PARAMETERS ElePrv, Estado

PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsTpoDoc(i) = AsTpoDoc(i-1)
   AsCodDoc(i) = AsCodDoc(i-1)
   AsNroDoc(i) = AsNroDoc(i-1)
   AfImport(i) = AfImport(i-1)
   AiNumReg(i) = AiNumReg(i-1)
   AfInteres(i)= AfInteres(i-1)
   AfGastos(i) = AfGastos(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE [CARGO]                 TO AsTpoDoc(i)
STORE [LETR]                  TO AsCodDoc(i)
STORE SPACE(LEN(VTOS.NroRef)) TO AsNroDoc(i)
STORE 0                       TO AfImport(i)
STORE 0                       TO AiNumReg(i)
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE xBgrab

FOR i = 1 TO GiTotItm
   XsTpoRef = AsTpoDoc(i)
   XsCodRef = AsCodDoc(i)
   XsNroRef = AsNroDoc(i)
   XfImport = AfImport(i)
	XfInteres= AfInteres(i)
	XfGastos = AfGastos (i)
   LlRlock = .F.
   *
   SELE GDOC
   GO AiNumReg(i)
   LlRlock = REC_LOCK(0)
   XsCodCli = GDOC.CodCli
   *
   SELE SLDO
   SEEK XsCodCli
   IF !FOUND()
      APPEND BLANK
      REPLACE CodCli WITH XsCodCli
   ELSE
      =REC_LOCK(0)
   ENDIF
   *
   SELE VTOS
   APPEND BLANK
   LlRlock = REC_LOCK(0)
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
   REPLACE FchDoc WITH XdFchDoc
   REPLACE FchIng WITH XdFchIng
   REPLACE CodCli WITH XsCodCli
   REPLACE CodMon WITH XiCodMon
   REPLACE TpoCmb WITH XfTpoCmb
   REPLACE TpoRef WITH XsTpoRef
   REPLACE CodRef WITH XsCodRef
   REPLACE NroRef WITH XsNroRef
   REPLACE Import WITH XfImport
   replace ImpInt WITH XfInteres
   replace ImpGas WITH XfGastos
   UNLOCK
   ** actualizamos documento **
   SELE GDOC
   m.Import = XfImport
   REPLACE SdoDoc WITH SdoDoc-m.Import
   IF SdoDoc <= 0.01
      REPLACE FlgEst WITH [C]
   ENDIF
   REPLACE FchAct WITH DATE()
   UNLOCK
   ** saldo del cliente **
   SELE SLDO
   IF GDOC->CodMon = 1
      REPLACE CgoNAC WITH CgoNAC - m.Import
   ELSE
      REPLACE CgoUSA WITH CgoUSA - m.Import
   ENDIF
   UNLOCK
   **
ENDFOR
** Actualizamos contabilidad **
DO xACT_CTB
*******************************
DO Imprvouc IN Ccb_Ctb
RETURN
****************
PROCEDURE xCarga
****************
PRIVATE b
IF !ctb_aper(TASG.FchIng)
   UltTecla = 0
   RETURN
ENDIF
b= 0
SELE VTOS
SEEK XsCodDoc+XsNroDoc
SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc
      b           =  b + 1
      AsTpoDoc(b) =  TpoRef
      AsCodDoc(b) =  CodRef
      AsNroDoc(b) =  NroRef
      AfImport(b) =  Import
      AfGastos(b) =  ImpGas
      AfInteres(b)=  ImpInt
*!*	      SELE GDOC
*!*	      SET ORDER TO GDOC01
*!*	      SEEK AsTpoDoc(b)+AsCodDoc(b)+AsNroDoc(b)
*!*	      AiNumreg(b) = RECNO()
*!*	      =REC_LOCK(0)
*!*	      SELE SLDO
*!*	      SEEK VTOS->CodCli
*!*	      =REC_LOCK(0)
*!*	      SELE GDOC
*!*	      m.Import = VTOS->Import
*!*	      REPLACE SdoDoc WITH SdoDoc + m.Import
*!*	      IF SdoDoc > 0
*!*	         REPLACE FlgEst WITH [P]
*!*	      ENDIF
*!*	      REPLACE FchAct WITH DATE()
*!*	      UNLOCK
*!*	      **
*!*	      SELE SLDO
*!*	      IF GDOC->CodMon = 1
*!*	         REPLACE CgoNAC WITH CgoNAC + m.Import
*!*	      ELSE
*!*	         REPLACE CgoUSA WITH CgoUSA + m.Import
*!*	      ENDIF
*!*	      UNLOCK
      SELE VTOS
ENDSCAN
GiTotItm = b
RETURN
****************
PROCEDURE xGrbAnt
****************
SELE VTOS
SEEK XsCodDoc+XsNroDoc
SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc
     XsTpoRef =  TpoRef
     XsCodRef =  CodRef
     XsNroRef =  NroRef
     XfImport =  Import
     SELE GDOC
     SET ORDER TO GDOC01
     SEEK XsTpoRef+XsCodRef+XsNroRef
     LlRlock = REC_LOCK(0)
     XsCodCli = GDOC.CodCli
     *
     SELE SLDO
     SEEK XsCodCli
     IF !FOUND()
     	APPEND BLANK
     	replace CodCli WITH XsCodCli
     	UNLOCK
     ENDIF
     LlRlock = REC_LOCK(0)
     *
     SELE GDOC
     m.Import = XfImport
     REPLACE SdoDoc WITH SdoDoc-m.Import
     IF SdoDoc <= 0.01
        REPLACE FlgEst WITH [C]
     ENDIF
     REPLACE FchAct WITH DATE()
     UNLOCK
     ** saldo del cliente **
     SELE SLDO
     IF GDOC->CodMon = 1
        REPLACE CgoNAC WITH CgoNAC - m.Import
     ELSE
        REPLACE CgoUSA WITH CgoUSA - m.Import
     ENDIF
     UNLOCK
     **
     SELE VTOS
ENDSCAN
SELE TASG
RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE xBorrar
SELE TASG
IF FlgEst = [A]
   GsMsgErr = [Documento Anulado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst#[A]
   IF FlgEst # [E]
      GsMsgErr = [Acceso Denegado]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF FlgLiq = [L]
      GsMsgErr = [Documento con Cierre de Caja]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF ! RLOCK()
      RETURN
   ENDIF
   * VEAMOS SI SE PUEDE ANULAR LA CONTABILIDAD *
   IF TASG.FlgCtb
      IF !ctb_aper(TASG.FchIng)
         SELE GDOC
         UNLOCK ALL
         RETURN
      ENDIF
   ENDIF
   * borramos detalle *
   OK = .T.
   SELE VTOS
   SEEK TASG->CodDoc+TASG->NroDoc
   DO WHILE !EOF() .AND. CodDoc+NroDoc = TASG->CodDoc+TASG->NroDoc
      IF ! RLOCK()
         LOOP
      ENDIF
      **
      SELE SLDO
      SEEK VTOS->CodCli
      IF ! RLOCK()
         SELE VTOS
         LOOP
      ENDIF
      **
      SELE GDOC
      SET ORDER TO GDOC01
      SEEK XsTpoRef+VTOS->CodRef+VTOS->NroRef
      IF ! RLOCK()
         SELE VTOS
         LOOP
      ENDIF
      **
      m.Import = VTOS->Import
      REPLACE SdoDoc WITH SdoDoc + m.Import
      IF SdoDoc > 0
         REPLACE FlgEst WITH [P]
      ENDIF
      REPLACE FchAct WITH DATE()
      UNLOCK
      **
      SELE SLDO
      IF GDOC->CodMon = 1
         REPLACE CgoNAC WITH CgoNAC + m.Import
      ELSE
         REPLACE CgoUSA WITH CgoUSA + m.Import
      ENDIF
      UNLOCK
      **
      SELE VTOS
      DELETE
      UNLOCK
      SKIP
   ENDDO
   *
   IF TASG.FlgCtb
      DO xANUL_CTB
   ENDIF
   DO ctb_cier
   *
   SELE TASG
   REPLACE FlgEst WITH [A]
   REPLACE ImpDoc WITH 0
ELSE
   =REC_LOCK(0)
   REPLACE FlgEst WITH [ ]
ENDIF
UNLOCK ALL

RETURN
*****************
PROCEDURE xBrrAnt
*****************
* borramos detalle *
OK = .T.
SELE VTOS
SEEK TASG->CodDoc+TASG->NroDoc
DO WHILE !EOF() .AND. CodDoc+NroDoc = TASG->CodDoc+TASG->NroDoc
   IF ! RLOCK()
      LOOP
   ENDIF
   SELE VTOS
   DELETE
   UNLOCK
   SKIP
ENDDO
*
IF TASG.FlgCtb
   DO xANUL_CTB
   SELE VMOV
   REPLACE FlgEst WITH [R]
   REPLACE DbeNac WITH 0
   REPLACE HbeNac WITH 0
   REPLACE DbeUsa WITH 0
   REPLACE HbeUsa WITH 0
   REPLACE ChkCta WITH 0
   REPLACE NroItm WITH 0
   UNLOCK
ENDIF
SELE TASG
RETURN
************************************************************************ FIN *
*************** RUTINAS DE ACTUALIZACION DE CONTABILIDAD *********************
******************************************************************************

******************
PROCEDURE xACT_CTB
******************
PRIVATE XdFchPed,GlInterface,XsCodDiv,TsCodDiv1,XcAfecto
PRIVATE XsCodCco ,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
PRIVATE XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = ''

dimension vcodcta(10)
STORE {} TO XdFchPed
STORE '' TO XsCodCco ,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta
** Valores variables inicializados como NUMERO
STORE 0 TO NumCta

IF GDOC.FlgSit = [D]         && Letras Descontadas
	XsCodOpe = GsLetDes
ELSE
	XsCodOpe = GsLetCob         && Letras en Cobranza
ENDIF
***************
IF CREAR
   SELE OPER
   SEEK XsCodOpe
   IF !REC_LOCK(5)
      GsMsgErr = [NO se pudo generar el asiento contable]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   XsNroMes = TRANSF(_MES,"@L ##")
   XsNroAst = LoContab.NROAST()
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
      RETURN              && No pudo bloquear registro
   ENDIF
   WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
   REPLACE VMOV->NROMES WITH XsNroMes
   REPLACE VMOV->CodOpe WITH XsCodOpe
   REPLACE VMOV->NroAst WITH XsNroAst
   REPLACE VMOV->FLGEST WITH "R"
   REPLACE VMOV.FCHDIG  WITH DATE()
   REPLACE VMOV.HORDIG  WITH TIME()

   SELECT OPER
   =LoContab.NROAST(XsNroAst)
ELSE
   XsNroMes = TASG.NroMes
   XsCodOpe = TASG.CodOpe
   XsNroAst = TASG.NroAst
   SELE VMOV
   SEEK XsNroMes+XsCodOpe+XsNroAst
   IF !FOUND()
       SELE OPER
       SEEK XsCodOpe
       IF !REC_LOCK(5)
          GsMsgErr = [NO se pudo generar el asiento contable]
          DO lib_merr WITH 99
          RETURN
       ENDIF
       XsNroMes = TRANSF(_MES,"@L ##")
       XsNroAst = LoContab.NROAST()
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
          RETURN              && No pudo bloquear registro
       ENDIF
       WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
       REPLACE VMOV->NROMES WITH XsNroMes
       REPLACE VMOV->CodOpe WITH XsCodOpe
       REPLACE VMOV->NroAst WITH XsNroAst
       REPLACE VMOV->FLGEST WITH "R"
       SELECT OPER
       LoContab.NROAST(XsNroAst)
   ELSE
      WAIT [Regrabando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
      =REC_LOCK(0)
   ENDIF
ENDIF
SELECT VMOV
REPLACE VMOV->FchAst  WITH TASG.FchIng
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH TASG.CodMon
REPLACE VMOV->TpoCmb  WITH TASG.TpoCmb
REPLACE VMOV->NotAst  WITH TASG.CodDoc+[ ]+TASG.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
** ACTUALIZAR DATOS DE CABECERA **
REPLACE TASG.NroMes WITH XsNroMes
REPLACE TASG.CodOpe WITH XsCodOpe
REPLACE TASG.NroAst WITH XsNroAst
REPLACE TASG.FlgCtb WITH .T.
* * * * * * * * * * * * * * * * * *
* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa,Z
XiNroItm = 1
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon

FOR z = 1 TO GiTotItm
   XfTpoCmb = VMOV.TpoCmb
   XsGloDoc = SPACE(LEN(RMOV.GloDoc))
   XdFchDoc = {} && XdFchAst
   XdFchVto = {} && XdFchAst
   nImpNac  = 0
   nImpUsa  = 0
   * buscamos la letra a cancelar *
   SELE GDOC
   GO AiNumReg(z)
   XsGloDoc=LEFT(TASG.CodDoc,3)+[:]+RIGHT(TASG.NroDoc,8)+'-'+LEFT(GDOC.CodCli,11)+'\'+LEFT(GDOC.CodDoc,2)+':'+GDOC.NroDoc
   IF GDOC.FlgSit = [D]         && Letras Descontadas
      DO xBody1
   ELSE
      DO xBody2                 && Letras en Cobranza
   ENDIF
ENDFOR
RELEASE Z
*** ASIENTO PARA GENERAR CUENTAS DE ORDEN NO ES NECESARIO SE PUEDE OBVIAR
IF GsSigCia='ADHESIVOS'
	DO gen_cta_ORDEN    && ADESIVOS 02/JUN/2000  VETT , MAAV
ENDIF
*** 
WAIT [Fin de Generacion] WINDOW NOWAIT
SELE RMOV
SET ORDER TO RMOV01
RETURN
************************************************************************ FIN *
* Objeto : Asiento por Letra Descontada
******************************************************************************
******************
PROCEDURE xImprime
******************
*!*	=MESSAGEBOX('Prepare la impresora para imprimir letras',0+64,'AVISO !!!' )

*!*	SET PROCEDURE TO ccb_ccbr4700 additive

*!*	DO imprime IN ccb_ccbr4700 WITH "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"

*!*	SET PROCEDURE TO 
*!*	SET PROCEDURE TO janesoft,fxgen_2

IF TASG.FlgCtb
    =MESSAGEBOX('Prepare la impresora para imprimir voucher contable',0+64,'AVISO !!!' )
	STORE 0 TO  nimpnac,nimpusa
	IF !ctb_aper(TASG.FchDoc)
		SELE TASG
		UNLOCK ALL
		RETURN
	ENDIF
	XsNroMes = TASG.NroMes
	XsCodOpe = TASG.CodOpe
	XsNroAst = TASG.NroAst
	SELE VMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	DO Imprvouc IN Ccb_Ctb
	DO ctb_cier
ENDIF
SELECT tasg
****************
PROCEDURE xBody1
****************
** NOTA : Cabe notar que los importes van a ser ajustados a los importes
**        originales de las letras asi como su tipo de cambio, segun sea
**        el caso
**************************************
* Asiento por Letra descontada (124) *
**************************************
XsCodCta = [124]+SUBST(TASG.CodCta,4,2)
XsCodCta = XsCtaDes
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
IF CTAS.PidAux=[S]
   XsClfAux = CTAS.ClfAux
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [D]          && << OJO <<
XfImport = GDOC.ImpTot  && << OJO <<
XfTpoCmb = GDOC.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
XdFchDoc = {} 
XdFchVto = {} 

IF CTAS.PidDoc=[S]
   XsCodDoc = GDOC.CodDoc
   XsNroDoc = GDOC.NroDoc
   XsNroRef = GDOC.NroDoc
	** VETT:Grabar Fecha de emision y vencimiento de letra segun ctas. x cobrar - 2015/05/04 13:53:16 **    
	XdFchDoc	= GDOC.FchDoc
	XdFchVto	= GDOC.FchVto
ENDIF
* Buscamos monto original *
SELE RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK LLave
IF FOUND() .AND. TpoMov = [H]   && << OJO <<
   XfTpoCmb = TpoCmb
   XfImport = Import
   XfImpUsa = ImpUsa
ENDIF
* * * * * * * * * * * * * *
DO MovbVeri IN ccb_ctb
************************************
* Asiento por Letra original (123) *
************************************
=SEEK(GDOC.CodDoc,"TDOC")
*XsCodCta = LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
IF CTAS.PidAux=[S]
   XsClfAux = CTAS.ClfAux
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [H]    && << OJO <<
XfImport = GDOC.ImpTot
XfTpoCmb = GDOC.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
    ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
XdFchDoc = {} 
XdFchVto = {} 

IF CTAS.PidDoc=[S]
   XsCodDoc = GDOC.CodDoc
   XsNroDoc = GDOC.NroDoc
   XsNroRef = GDOC.NroDoc
	** VETT:Grabar Fecha de emision y vencimiento de letra segun ctas. x cobrar - 2015/05/04 13:53:16 **    
	XdFchDoc	= GDOC.FchDoc
	XdFchVto	= GDOC.FchVto
ENDIF
* Buscamos monto original *
SELE RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK LLave
IF FOUND() .AND. TpoMov = [D]   && << OJO <<
   XfTpoCmb = TpoCmb
   XfImport = Import
   XfImpUsa = ImpUsa
ENDIF
* * * * * * * * * * * * * *
DO MovbVeri IN ccb_ctb
************************************
* RUTINA EN CASO DE LETRA RENOVADA *
************************************
* Posicionamos puntero en la letra renovada *
SELE VTOS
SET ORDER TO VTOS03
SEEK GDOC.CodDoc+GDOC.NroDoc
OK = .F.
SCAN WHILE CodRef+NroRef = GDOC.CodDoc+GDOC.NroDoc
   IF CodDoc = [RENV]
      OK = .T.
      EXIT
   ENDIF
ENDSCAN
SET ORDER TO VTOS01
IF OK
   * Posicionamos puntero en la letra renovada *
   SELE GDOC
   SET ORDER TO GDOC03
   SEEK [Renov]+VTOS.CodDoc+VTOS.NroDoc
   IF FOUND()
      ************************************
      * Asiento por Letra renovada (123) *
      ************************************
      =SEEK(GDOC.CodDoc,"TDOC")
*      XsCodCta = LEFT(TDOC.CodCta,LEN(CTAS.CodCta))
		XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
      XsCodRef = SPACE(LEN(RMOV.CodRef))
      =SEEK(XsCodCta,"CTAS")
      XsCodAux = SPACE(LEN(RMOV.CodAux))
      XsClfAux = SPACE(LEN(RMOV.ClfAux))
      IF CTAS.PidAux=[S]
         XsClfAux = CTAS.ClfAux
         XsCodAux = GDOC.CodCli
      ENDIF
      XcTpoMov = [D]    && << OJO <<
      XfImport = GDOC.ImpTot
      XfTpoCmb = GDOC.TpoCmb
      IF XiCodMon = 1
	      XfImpNac = XfImport
         IF XfTpoCmb>0
            XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
         ELSE
            XfImpUsa = 0
          ENDIF
      ELSE
         XfImpUsa = XfImport
         XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
      ENDIF
      XsCodDoc = SPACE(LEN(RMOV.CodDoc))
      XsNroDoc = SPACE(LEN(RMOV.NroDoc))
      XsNroRef = SPACE(LEN(RMOV.NroDoc))
		XdFchDoc = {} 
		XdFchVto = {} 
      IF CTAS.PidDoc=[S]
         XsCodDoc = GDOC.CodDoc
         XsNroDoc = GDOC.NroDoc
         XsNroRef = GDOC.NroDoc
		** VETT:Grabar Fecha de emision y vencimiento de letra segun ctas. x cobrar - 2015/05/04 13:53:16 **    
		XdFchDoc	= GDOC.FchDoc
		XdFchVto	= GDOC.FchVto

      ENDIF
      DO MovbVeri IN ccb_ctb
      ***********************************************
      * Asiento por Letra renovada/decsontada (124) *
      ***********************************************
      XsCodCta = [124]+SUBST(TASG.CodCta,4,2)
      XsCodCta = XsCtaDes
      XsCodRef = SPACE(LEN(RMOV.CodRef))
      =SEEK(XsCodCta,"CTAS")
      XsCodAux = SPACE(LEN(RMOV.CodAux))
      XsClfAux = SPACE(LEN(RMOV.ClfAux))
      IF CTAS.PidAux=[S]
         XsClfAux = CTAS.ClfAux
         XsCodAux = GDOC.CodCli
      ENDIF
      XcTpoMov = [H]    && << OJO <<
      XfImport = GDOC.ImpTot
      XfTpoCmb = GDOC.TpoCmb
      IF XiCodMon = 1
			XfImpNac = XfImport      		
         IF XfTpoCmb>0
            XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
         ELSE
            XfImpUsa = 0
          ENDIF
      ELSE
         XfImpUsa = XfImport
         XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
      ENDIF
      XsCodDoc = SPACE(LEN(RMOV.CodDoc))
      XsNroDoc = SPACE(LEN(RMOV.NroDoc))
      XsNroRef = SPACE(LEN(RMOV.NroDoc))
	  XdFchDoc = {} 
	  XdFchVto = {} 
      IF CTAS.PidDoc=[S]
         XsCodDoc = GDOC.CodDoc
         XsNroDoc = GDOC.NroDoc
         XsNroRef = GDOC.NroDoc
		** VETT:Grabar Fecha de emision y vencimiento de letra segun ctas. x cobrar - 2015/05/04 13:53:16 **    
		XdFchDoc	= GDOC.FchDoc
		XdFchVto	= GDOC.FchVto
      ENDIF
      DO MovbVeri IN ccb_ctb
   ENDIF
   SELE GDOC
   SET ORDER TO GDOC01
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Asiento por Letra en Cobranza
******************************************************************************
PROCEDURE xBody2

********************************
* Asiento por Ingreso al Banco *
********************************
XsCodCta = TASG.CodCta
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XcTpoMov = [D]    && << OJO <<
XfImport = AfImport(z)+AfInteres(z)-AfGastos(z)
XfTpoCmb = VMOV.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
XdFchDoc = XdFchASt
XdFchVto = {} 

DO MovbVeri IN ccb_ctb
************************************
* Asiento por Letra original (127) *
************************************
XsCodCta = [127]+SUBST(TASG.CodCta,4,2)
XsCodCta = XsCtaCob
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
IF CTAS.PidAux=[S]
   XsClfAux = CTAS.ClfAux
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [H]    && << OJO <<
XfImport = AfImport(z)
iImport  = XfImport     && OJO
XfTpoCmb = VMOV.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
XdFchDoc = {} 
XdFchVto = {} 
IF CTAS.PidDoc=[S]
   XsCodDoc = GDOC.CodDoc
   XsNroDoc = GDOC.NroDoc
   XsNroRef = GDOC.NroDoc
	** VETT:Grabar Fecha de emision y vencimiento de letra segun ctas. x cobrar - 2015/05/04 13:53:16 **    
   XdFchDoc	= GDOC.FchDoc
   XdFchVto	= GDOC.FchVto
ENDIF
XsChkTpoDoc = XsCodDoc  && Revisar esto
IF CTAS.AftDcb = [S]
   DO DifCmb   IN ccb_ctb
ELSE
   DO MovbVeri IN ccb_ctb
ENDIF
************************************
* RUTINA EN CASO DE LETRA RENOVADA *
************************************
* Posicionamos puntero en la letra renovada *
SELE VTOS
SET ORDER TO VTOS03
SEEK GDOC.CodDoc+GDOC.NroDoc
OK = .F.
SCAN WHILE CodRef+NroRef = GDOC.CodDoc+GDOC.NroDoc
   IF CodDoc = [RENV]
      OK = .T.
      EXIT
   ENDIF
ENDSCAN
SET ORDER TO VTOS01
IF OK
   * Posicionamos puntero en la letra renovada *
   SELE GDOC
   SET ORDER TO GDOC03
   SEEK [Renov]+VTOS.CodDoc+VTOS.NroDoc
   IF FOUND()
      ************************************
      * Asiento por Letra renovada (127) *
      ************************************
      XsCodCta = [127]+SUBST(TASG.CodCta,4,2)
      XsCodCta = XsCtaCob
      XsCodRef = SPACE(LEN(RMOV.CodRef))
      =SEEK(XsCodCta,"CTAS")
      XsCodAux = SPACE(LEN(RMOV.CodAux))
      XsClfAux = SPACE(LEN(RMOV.ClfAux))
      IF CTAS.PidAux=[S]
         XsClfAux = CTAS.ClfAux
         XsCodAux = GDOC.CodCli
      ENDIF
      XcTpoMov = [D]    && << OJO <<
      XfImport = GDOC.ImpTot
     *XfTpoCmb = GDOC.TpoCmb
      XfTpoCmb = VMOV.TpoCmb    && << OJITO <<
      IF XiCodMon = 1
      		XfImpNac = XfImport
         IF XfTpoCmb>0
            XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
         ELSE
            XfImpUsa = 0
          ENDIF
      ELSE
         XfImpUsa = XfImport
         XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
      ENDIF
      XsCodDoc = SPACE(LEN(RMOV.CodDoc))
      XsNroDoc = SPACE(LEN(RMOV.NroDoc))
      XsNroRef = SPACE(LEN(RMOV.NroDoc))
	  XdFchDoc = {} 
	  XdFchVto = {} 
      IF CTAS.PidDoc=[S]
         XsCodDoc = GDOC.CodDoc
         XsNroDoc = GDOC.NroDoc
         XsNroRef = GDOC.NroDoc
		** VETT:Grabar Fecha de emision y vencimiento de letra segun ctas. x cobrar - 2015/05/04 13:53:16 **    
		XdFchDoc	= GDOC.FchDoc
		XdFchVto	= GDOC.FchVto
      ENDIF
      DO MovbVeri IN ccb_ctb
   ENDIF
   SELE GDOC
   SET ORDER TO GDOC01
ENDIF

********************************
*** Gastos a la 67           ***
********************************
XsCodCta = XsCtaGas
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XcTpoMov = [D]    && << OJO <<
XfImport = AfGastos(z)
XfTpoCmb = VMOV.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
XdFchDoc = {} 
XdFchVto = {} 

DO MovbVeri IN ccb_ctb
********************************
*** Intereses a 77           ***
********************************
XsCodCta = XsCtaInt
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XcTpoMov = [H]    && << OJO <<
XfImport = AfInteres(z)
XfTpoCmb = VMOV.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
DO MovbVeri IN ccb_ctb

RETURN
************************************************************************ FIN *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB

XsNroMes = TASG.NroMes
XsCodOpe = TASG.CodOpe
XsNroAst = TASG.NroAst
IF EMPTY(XsNroMes) OR EMPTY(XsCodOpe) OR EMPTY(XsNroAst)
	=MESSAGEBOX('Datos del asiento contable no estan completos',0+64,'AVISO !!!')
	RETURN 
ENDIF
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !REC_LOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
   DO lib_merr WITH 99
   DO ctb_cier
   RETURN
ENDIF
DO MOVBorra IN ccb_ctb
IF GsSigCia='ADHESIVOS'
	*** PARA CUENTAS DE ORDEN *** && MAAV
	XsNroMes = TASG.NroMes1
	XsCodOpe = TASG.CodOpe1
	XsNroAst = TASG.NroAst1
	IF EMPTY(XsNroMes) OR EMPTY(XsCodOpe) OR EMPTY(XsNroAst)
		=MESSAGEBOX('Datos del asiento contable no estan completos',0+64,'AVISO !!!')
		RETURN 
	ENDIF

	SELE VMOV
	SEEK XsNroMes+XsCodOpe+XsNroAst
	IF !REC_LOCK(5)
	   GsMsgErr = [No se pudo anular el asiento contable]
	   DO lib_merr WITH 99
	   DO ctb_cier
	   RETURN
	ENDIF
	DO MOVBorra IN ccb_ctb
ENDIF
RETURN
************************
PROCEDURE GEN_CTA_ORDEN
************************
PRIVATE XSCODOPE,XsNroAst
XSCODOP1 = [021]
XsNroAst = ""
XsCodOpe = XsCodOp1
LPrimera = .t.
* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa,Z
XiNroItm = 1
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
FOR z = 1 TO GiTotItm
   * buscamos la letra a cancelar *
   SELE GDOC
   GO AiNumReg(z)
   IF GDOC.FlgSit = [D]         && Letras Descontadas
	   if lprimera
	   		do head_orden
	   endif
	   XfTpoCmb = VMOV.TpoCmb
	   XsGloDoc = SPACE(LEN(RMOV.GloDoc))
	   XdFchDoc = XdFchAst
	   XdFchVto = XdFchAst
	   nImpNac  = 0
	   nImpUsa  = 0
       DO CTAS_ORDEN
    ENDIF
ENDFOR
RETURN
********************
PROCEDURE HEAD_ORDEN
********************
IF Crear
   SELE OPER
   SEEK XsCodOpe
   IF !REC_LOCK(5)
      GsMsgErr = [NO se pudo generar el asiento contable]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   XsNroMes = TRANSF(_MES,"@L ##")
   XsNroAst = LoContab.NROAST()
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
      RETURN              && No pudo bloquear registro
   ENDIF
   WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
   REPLACE VMOV->NROMES WITH XsNroMes
   REPLACE VMOV->CodOpe WITH XsCodOpe
   REPLACE VMOV->NroAst WITH XsNroAst
   REPLACE VMOV->FLGEST WITH "R"
   REPLACE VMOV.FCHDIG  WITH DATE()
   REPLACE VMOV.HORDIG  WITH TIME()

   SELECT OPER
   LoContab.NROAST(XsNroAst)
ELSE
   XsNroMes = TASG.NroMes1
   XsCodOpe = TASG.CodOpe2
   XsNroAst = TASG.NroAst2
   SELE VMOV
   SEEK XsNroMes+XsCodOpe+XsNroAst
   IF !FOUND()
       SELE OPER
       SEEK XsCodOpe
       IF !REC_LOCK(5)
          GsMsgErr = [NO se pudo generar el asiento contable]
          DO lib_merr WITH 99
          RETURN
       ENDIF
       XsNroMes = TRANSF(_MES,"@L ##")
       XsNroAst = LoContab.NROAST()
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
          RETURN              && No pudo bloquear registro
       ENDIF
       WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
       REPLACE VMOV->NROMES WITH XsNroMes
       REPLACE VMOV->CodOpe WITH XsCodOpe
       REPLACE VMOV->NroAst WITH XsNroAst
       REPLACE VMOV->FLGEST WITH "R"
       SELECT OPER
       LoContab.NROAST(XsNroAst)
   ELSE
      WAIT [Regrabando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
      =REC_LOCK(0)
   ENDIF
ENDIF
SELECT VMOV
REPLACE VMOV->FchAst  WITH TASG.FchIng
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH TASG.CodMon
REPLACE VMOV->TpoCmb  WITH TASG.TpoCmb
REPLACE VMOV->NotAst  WITH [Cuentas de Orden]+[ ]+TASG.CodDoc+[ ]+TASG.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
** ACTUALIZAR DATOS DE CABECERA **
REPLACE TASG.NroMes1 WITH XsNroMes
REPLACE TASG.CodOpe1 WITH XsCodOpe
REPLACE TASG.NroAst1 WITH XsNroAst
REPLACE TASG.FlgCtb1 WITH .T.
Lprimera=.f.
RETURN
************************************************************************ FIN *
* Objeto : Asiento por Letra Descontada por Cuentas de Orden
******************************************************************************
PROCEDURE CTAS_ORDEN
IF GsNomCia<>'ADHESIVOS'
	RETURN
ENDIF
** NOTA : Caso aplicable en Adhesivos S.A. MAAV
*********
* (011) *
*********
XsCodCta = XsCtaDe1
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
IF CTAS.PidAux=[S]
   XsClfAux = CTAS.ClfAux
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [D]          && << OJO <<
XfImport = GDOC.ImpTot  && << OJO <<
XfTpoCmb = GDOC.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
   ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
IF CTAS.PidDoc=[S]
   XsCodDoc = GDOC.CodDoc
   XsNroDoc = GDOC.NroDoc
   XsNroRef = GDOC.NroDoc
ENDIF
* Buscamos monto original *
SELE RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK LLave
IF FOUND() .AND. TpoMov = [H]   && << OJO <<
   XfTpoCmb = TpoCmb
   XfImport = Import
   XfImpUsa = ImpUsa
ENDIF
* * * * * * * * * * * * * *
DO MovbVeri IN ccb_ctb
*********
* (021) *
*********
=SEEK(GDOC.CodDoc,"TDOC")
XsCodCta = LEFT(TDOC.CodCta2,LEN(CTAS.CodCta))
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
IF CTAS.PidAux=[S]
   XsClfAux = CTAS.ClfAux
   XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [H]    && << OJO <<
XfImport = GDOC.ImpTot
XfTpoCmb = GDOC.TpoCmb
IF XiCodMon = 1
	XfImpNac = XfImport
   IF XfTpoCmb>0
      XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
   ELSE
      XfImpUsa = 0
    ENDIF
ELSE
   XfImpUsa = XfImport
   XfImpNac = ROUND(XfImpUsa*XfTpoCmb,2)
ENDIF
XsCodDoc = SPACE(LEN(RMOV.CodDoc))
XsNroDoc = SPACE(LEN(RMOV.NroDoc))
XsNroRef = SPACE(LEN(RMOV.NroDoc))
IF CTAS.PidDoc=[S]
   XsCodDoc = GDOC.CodDoc
   XsNroDoc = GDOC.NroDoc
   XsNroRef = GDOC.NroDoc
ENDIF
* Buscamos monto original *
SELE RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+XsCodAux+XsNroDoc
SEEK LLave
IF FOUND() .AND. TpoMov = [D]   && << OJO <<
   XfTpoCmb = TpoCmb
   XfImport = Import
   XfImpUsa = ImpUsa
ENDIF
* * * * * * * * * * * * * *
DO MovbVeri IN ccb_ctb
RETURN
*************************
PROCEDURE xCarga_Planilla
*************************
PARAMETERS LcFlgSit,LsNroPla,LsCtaBco
IF VARTYPE(LcFlgSit)<>'C'
	LcFlgSit =' '
ENDIF

IF VARTYPE(LsNroPla)<>'C'
	LsNroPla =SPACE(LEN(GDOC.NroPla))
ENDIF
IF VARTYPE(LsCtaBco)<>'C'
	LsCtaBco =SPACE(LEN(GDOC.CodCta))
ENDIF
IF EMPTY(LsCtaBco) AND EMPTY(LsNroPla) AND EMPTY(LcFlgSit) 
		=MESSAGEBOX('Ingrese al menos la cuenta del banco',0+64,'ATENCION !!!')
		UltTecla = 0
		RETURN 

ENDIF
DO CASE
	CASE EMPTY(LsNroPla) AND EMPTY(LsCtaBco)
		=MESSAGEBOX('Ingrese numero de Planilla o Cuenta de Banco',0+64,'ATENCION !!!')
		UltTecla = 0
		RETURN 
	OTHER 	
ENDCASE

IF !ctb_aper(XdFchIng)
   UltTecla = 0
   RETURN
ENDIF
LsAlias= SELECT()
LsTagAct=ORDER()
LsFor= '.T.'
LsWhile = '.T.'
LsTpoDoc='CARGO'
LsCodDoc='LETR'
LcFlgEst = 'P'
LcFlgUbc = 'B'
LsCodCta = PADR(LsCtaBco,LEN(GDOC.CodCta))
DO CASE
	CASE LcFlgSit$'CD' AND !EMPTY(LsNroPla)
		LsOrder = 'GDOC10'	 && CODDOC+FLGUBC+FLGSIT+NROPLA+CODCTA
		LsWhile = [CODDOC+FLGUBC+FLGSIT+NROPLA+CODCTA=LsCodDoc+LcFlgUBC+LcFlgSit+LsNroPla+LsCodCta]
		LsFor = [FlgEst=LcFlgEst]
		LsLlave = LsCodDoc+LcFlgUBC+LcFlgSit+LsNroPla+LsCodCta
		
	CASE LcFlgSit$'CD' AND EMPTY(LsNroPla)
		LsOrder = 'GDOC06'	&& CODCTA+TPODOC+CODDOC+FLGEST+FLGUBC+FLGSIT+NRODOC
		LsWhile = [CODCTA+TPODOC+CODDOC+FLGEST+FLGUBC+FLGSIT=LsCodCta+LsTpoDoc+LsCodDoc+LcFlgEst+LcFlgUBC+LcFlgSit]
		LsFor = [NroPla=LsNroPla]
		LsLlave = LsCodCta+LsTpoDoc+LsCodDoc+LcFlgEst+LcFlgUBC+LcFlgSit
		
	CASE EMPTY(LcFlgSit) AND !EMPTY(LsNroPla)
		LsOrder = 'GDOC06'	&& CODCTA+TPODOC+CODDOC+FLGEST+FLGUBC+FLGSIT+NRODOC
		LsWhile = [CODCTA+TPODOC+CODDOC+FLGEST+FLGUBC=LsCodCta+LsTpoDoc+LsCodDoc+LcFlgEst+LcFlgUBC]
		LsFor = [NroPla=LsNroPla AND FlgSit$'CD']
		LsLlave = LsCodCta+LsTpoDoc+LsCodDoc+LcFlgEst+LcFlgUBC
	OTHERWISE && Solo por cuenta de banco
	 	LsOrder = 'GDOC06'	&& CODCTA+TPODOC+CODDOC+FLGEST+FLGUBC+FLGSIT+NRODOC
ENDCASE
PRIVATE b
b= 0
SELE GDOC
SET ORDER TO (LsOrder)
SEEK LsLlave
SCAN WHILE &LsWhile. FOR &LsFor.
	
      b           =  b + 1
      AsTpoDoc(b) =  TpoDoc
      AsCodDoc(b) =  CodDoc
      AsNroDoc(b) =  NroDoc
      AfImport(b) =  SdoDoc
      AfGastos(b) =  0  &&ImpGas 
      AfInteres(b)=  0  &&ImpInt
*!*	      SELE GDOC
*!*	      SET ORDER TO GDOC01
*!*	      SEEK AsTpoDoc(b)+AsCodDoc(b)+AsNroDoc(b)
      AiNumreg(b) = RECNO()
*!*	      =REC_LOCK(0)
*!*	      SELE SLDO
*!*	      SEEK VTOS->CodCli
*!*	      =REC_LOCK(0)
*!*	      m.Import = VTOS->Import
*!*	      SELE GDOC
*!*	      REPLACE SdoDoc WITH SdoDoc + m.Import
*!*	      IF SdoDoc > 0
*!*	         REPLACE FlgEst WITH [P]
*!*	      ENDIF
*!*	      REPLACE FchAct WITH DATE()
*!*	      UNLOCK
*!*	      **
*!*	      SELE SLDO
*!*	      IF GDOC->CodMon = 1
*!*	         REPLACE CgoNAC WITH CgoNAC + m.Import
*!*	      ELSE
*!*	         REPLACE CgoUSA WITH CgoUSA + m.Import
*!*	      ENDIF
*!*	      UNLOCK
*!*	      SELE VTOS
		SELECT GDOC	
ENDSCAN
GiTotItm = b
IF !EMPTY(LsAlias)
	SELECT (LsAlias)
ENDIF
IF !EMPTY(LsTagAct)
	SET ORDER TO (LsTagAct)
ENDIF
RETURN

FUNCTION Muestra_Cta_Dat
	SELECT ctas 
	SEEK XsCodCta
 XiCodMon = CodMon
 XsCodBco = CodBco
 =SEEK("04"+XsCodBco,"TABLA")
 @  4,21 SAY XsCodCta+' '+CTAS->NomCta
 @  5,21 SAY CTAS->NroCta
 @  6,21 SAY XsCodBco+' '+TABLA->Nombre
 @  7,21 SAY IIF(XiCodMon=1,'S/.','US$')
 IF EMPTY(CTAS.Ctades)
	GsMsgErr = "Cuenta de descuento no definida. Avisar a contabilidad"
	DO LIB_MERR WITH 99
   *LOOP
 ENDIF
 IF EMPTY(CTAS.CtaCob)
	GsMsgErr = "Cuenta de Cobranza  no definida. Avisar a contabilidad"
	DO LIB_MERR WITH 99
   *LOOP
 ENDIF
 IF EMPTY(CTAS.CtaCob) .OR. EMPTY(CTAS.CtaDes)
	GsMsgErr = "Actualizar en la opci¢n de Cuentas Bancarias"
	DO LIB_MERR WITH 99
 ENDIF
 XsCtaDes = CTAS.CtaDes
 *!*     XsCtaDe1 = IIF(VARTYPE(CTAS.CtaDe1)='C',CTAS.CtaDe1,'') 	  && para Adhesivos S.A.
 XsCtaCob = CTAS.CtaCob
 XSCTAGAS = CTAS.CTAGAS
 XSCTAINT = CTAS.CTAINT
