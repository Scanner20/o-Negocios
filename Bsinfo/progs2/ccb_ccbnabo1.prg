*****************************************************************************
* Programa     : ccbnabo1.prg												*
* Sistema      : Cuentas por Cobrar											*
* Autor        : VETT														*
* Creaci¢n     : 13/03/95													*
* Proposito    : Ingreso de Notas de Credito y Otros Abonos					*
*				  VETT 02/09/2003 Adaptacion para VFP 7					 	*
* Actualizacion: VETT 23/11/2003											*
*****************************************************************************
IF !verifyvar('GsRegirV','C')
	return
ENDIF
SYS(2700,0)
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
LoDatAdm.abrirtabla('ABRIR','VTATDOCM','DOCM','DOCM01','')
RELEASE LoDatAdm

RESTORE FROM GoCfgVta.oentorno.tspathcia+'vtaCONFG.MEM' ADDITIVE

** relaciones a usar **
SELECT RDOC
SET RELA TO 'NA'+Codigo INTO TABLA
SELECT GDOC
SET RELATION TO GsClfCli+CodCli INTO AUXI
** pantalla de datos **

*          1         2         3         4         5         6         7
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*1    Codigo :       Numero :            Ref.CTB:1234-1234567890    Fecha : 99/99/99       
*2 Cliente   : 12345678901 123456789012345678901234567890         Emision : 99/99/99
*3 Direccion : 1234567890123456789012345678901234567890               RUC : 123456789012
*4 Detalle   : 1234567890123456789012345678901234567890            Moneda : S/.
*5             1234567890123456789012345678901234567890       Tpo. Cambio : 9,999.9999
*6             1234567890123456789012345678901234567890
*7         ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*8         ³ Codigo       D e s c r i p c i o n                 Importe    ³
*9         ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*0         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*1         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*2         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*3         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*4         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*5         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*6         Ú Documento a Asignar ÄÄÄÄÄ¿      ³ TOTAL         999,999,999.99³
*7         ³ C¢digo : FACT            ³      ³ SALDO ACTUAL  999,999,999.99³
*8         ³ N£mero : 1234567890      ³      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*9         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*0
*1
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*          1         2         3         4         5         6         7         8
DO fondo WITH 'NOTAS DE CREDITO',Goentorno.user.login,GsNomCia,GsFecha
CLEAR
IF _windows OR _mac
	@  0,0 TO 22,100  PANEL
ELSE
	@  0,0 TO 22,79  PANEL
endif

Titulo = [ ** NOTAS DE CREDITO ** ]
@  0,(79-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,2  SAY "   Codigo :       Numero :                                     Fecha :        "
@  2,2  SAY "Cliente   :                                                  Emisión :        "
@  3,2  SAY "Dirección :                                                      RUC :        "
@  4,2  SAY "Detalle   :                                                                   "
@  5,2  SAY "                                                              Moneda :        "
@  6,2  SAY "                                                         Tpo. Cambio :        "
@  7,2  SAY "        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿    "
@  8,2  SAY "        ³ Codigo       D e s c r i p c i ó n                 Importe     ³    "
@  9,2  SAY "        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    "
@ 10,2  SAY "        ³                                                                ³    "
@ 11,2  SAY "        ³                                                                ³    "
@ 12,2  SAY "        ³                                                                ³    "
@ 13,2  SAY "        ³                                                                ³    "
@ 14,2  SAY "        ³                                                                ³    "
@ 15,2  SAY "        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    " 
@ 16,2  SAY "        Ú Documento a Asignar ÄÄÄÄÄ¿      ³ TOTAL                        ³    "
@ 17,2  SAY "        ³ C¢digo :                 ³      ³ SALDO ACTUAL                 ³    "
@ 18,2  SAY "        ³ N£mero :                 ³      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    "
@ 19,2  SAY "        ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                                          "
@ 20,2  SAY "        ³ Asiento:                 ³                                          "	
@ 21,2  SAY "        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                          " 	

@  8,11 SAY " Codigo       D e s c r i p c i o n                 Importe    " COLOR SCHEME 7
@ 16,46 SAY "TOTAL       " COLOR SCHEME 7
@ 17,46 SAY "SALDO ACTUAL" COLOR SCHEME 7
@ 16,11 SAY " Documento a Asignar " COLOR SCHEME 7
SAVE SCREEN TO wPanIni
** variables del sistema **
PRIVATE XsTpoDoc,XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XiCodMon,XfTpoCmb,XsNumero
PRIVATE XfImpNet,XfImpTot,XsGlosa1,XsGlosa2,XsGlosa3,XfSdoDoc,XfImpIgv
PRIVATE XcFlgEst,XdFchEmi
PRIVATE XsNomCli,XsDirCli,XsRucCli
STORE [] TO XsTpoDoc,XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XdFchEmi,XsNumero
STORE [] TO XsGlosa1,XsGlosa2,XsGlosa3
STORE [] TO XcFlgEst
STORE [] TO XsNomCli,XsDirCli,XsRucCli,XsNomBreDoc
STORE 0 TO XfTpoCmb,XfImpNet,XfImpTot,XfSdoDoc,XFIMPIGV
XsTpoDoc = [ABONO]
XsCodDoc = [N/C ]
XiCodMon = 1   && SOLES
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
** Control de Correlativo **
PRIVATE m.NroDoc
m.NroDoc = []
** variables del documento a asignar **
PRIVATE XsTpoRef,XsCodRef,XsNroRef
XsTpoRef = [CARGO]
XsCodRef = SPACE(LEN(GDOC->CodRef))
XsNroRef = SPACE(LEN(GDOC->NroRef))
** VETT  12/03/2018 10:05 PM : Numero de referencia para almacenar # retencion original del cliente 
XsNumero = SPACE(LEN(GDOC->Numero))
** Logica Principal **
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
GsMsgKey = ''
DO LIB_MTEC WITH 99
xTpoDoc = XsTpoDoc
xCodDoc = XsCodDoc
DO f1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],[xListar],;
              [TpoDoc],xTpoDoc,'CMAR'

CLEAR 
CLEAR MACROS
DO close_file IN CCB_Ccbasign
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
************************************************************************ EOP()
* Pedir LLave de Busqueda
******************************************************************************
PROCEDURE xLLave
RESTORE SCREEN FROM wPanIni
SELE GDOC
Crear = .T.
IF &sesrgv.
   XsCodDoc = GDOC->CodDoc
   XsNroDoc = GDOC->NroDoc
   Crear = .F.
ELSE
   XsCodDoc = SPACE(LEN(GDOC->CodDoc))
   XsNroDoc = SPACE(LEN(GDOC->NroDoc))
ENDIF
UltTecla = 0
i = 1
GsMsgKey = "[Esc] Salir   [F8] Ayuda   [Enter] Registrar"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1
         SELE TDOC
         SET FILTER TO TpoDoc=XsTpoDoc
         LOCATE
         
         @ 1,14 GET XsCodDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
            IF !ccbbusca("TDOC")
               SET FILTER TO
               LOOP
            ENDIF
            XsCodDoc = TDOC->CodDoc
         ENDIF
         @ 1,14 SAY XsCodDoc
         IF !SEEK(XsCodDoc,"TDOC")
            DO lib_merr WITH 6
            SET FILTER TO
            LOOP
         ENDIF
         * definimos # del documento *

         XsNroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),10,'0'),LEN(GDOC->NroDoc))
         m.NroDoc = XsNroDoc
         XsNomBreDoc=TDOC.DesDoc
         SET FILTER TO

      CASE i = 2
         SELE GDOC
         @ 1,29 GET XsNroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
            IF !ccbbusca("GDOC")
               LOOP
            ENDIF
            XsNroDoc = GDOC->NroDoc
            KEYBOARD '{ENTER}' 
         ENDIF
         @ 1,29 SAY XsNroDoc
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE GDOC
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
RETURN
************************************************************************ FIN()
* Pintar Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

SELE GDOC
@  1,14 SAY CodDoc
@  1,29 SAY NroDoc
*!*	@  1,48 SAY Numero PICT "@S15"
@  1,75 SAY FchDoc pict '@d dd/mm/aa'
@  2,75 SAY FchEmi pict '@d dd/mm/aa'
@  2,14 SAY CodCli+' '+LEFT(NomCli,30)
*@  2,14 SAY CodCli+' '+AUXI->NomAux
@  3,14 SAY LEFT(DirCli,30) 
@  3,75 SAY RucCli
*@  3,14 SAY AUXI->DirAux
*@  3,66 SAY AUXI->RucAux
@  4,14 SAY Glosa1 PICT "@S40"
@  5,14 SAY Glosa2 PICT "@S40"
@  6,14 SAY Glosa3 PICT "@S40"
@  5,75 SAY IIF(CodMon=2,'US$','S./')
@  6,75 SAY TpoCmb PICT "9,999.9999"
@ 16,60 SAY ImpTot PICT "999,999,999.99"
@ 17,60 SAY SdoDoc PICT "999,999,999.99"
@ 17,21 SAY CodRef
@ 18,21 SAY NroRef
@ 20,21 SAY NroMes+'-'+CodOpe+'-'+NroAst
IF FLgEst='A'
	@ 26,12 SAY "DOCUMENTO: ANULADO"  FONT "Foxfont",12 STYLE 'B'  color r+/n
ELSE
    @ 26,12 clear to 26,WCOLS()-2
ENDIF

** datos del browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
DO xBrowse
**
SELE GDOC
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
GsMsgKey = ""
*DO LIB_MTEC WITH 99

RETURN
************************************************************************ FIN()
* Pedir Datos
******************************************************************************
PROCEDURE xTomar

SELE GDOC
IF &sesrgv
	IF F1_Alert('Desea volver a generar asiento contable??','SI_O_NO') = 1
		IF ctb_aper(GDOC.FchEmi)
			DO xAct_ctb
			SELECT GDOC
			UNLOCK ALL
			return 
		ENDIF	
	ELSE
		SELECT GDOC
		RETURN			
	ENDIF
	
ELSE
	DO xInvar
ENDIF
*!*	@  1,48 GET XsNumero PICT "@S15"
@  1,75 GET XdFchDoc PICT '@D dd/mm/aa'
@  2,75 GET XdFchEmi PICT '@D dd/mm/aa'
@  2,14 GET XsCodCli
@  4,14 GET XsGlosa1 PICT "@!S40"
@  5,14 GET XsGlosa2 PICT "@!S40"
@  6,14 GET XsGlosa3 PICT "@!S40"
@  6,75 GET XfTpoCmb PICT "9,999.9999"
@ 17,21 GET XsCodRef
@ 18,21 GET XsNroRef
CLEAR GETS
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1 AND .F.
         @ 1,48 GET XsNumero PICT "@S15"
         READ
         UltTecla = LASTKEY()
   
      CASE i = 2
         @ 1,75 GET XdFchDoc PICT '@D dd/mm/aa'
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         ** Rutina que apertura las base contables a usar y ademas **
         ** verifica que el mes contables NO este cerrado **

         XdFchEmi = XdFchDoc
         @ 2,75 GET XdFchEmi PICT '@D dd/mm/aa'
         READ
         IF !ctb_aper(XdFchEmi)
            UltTecla = 0
            LOOP
         ENDIF
         UltTecla = LASTKEY()
      CASE i = 4
         SELE AUXI
         @ 2,14 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = escape_ .OR. UltTecla = Arriba
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodCli)
            IF !ccbbusca("CLIE")
               SET ORDER TO AUXI01
               LOOP
            ENDIF
            XsCodCli = AUXI->CodAux
            SET ORDER TO AUXI01
         ENDIF
         @ 2,14 SAY XsCodCli
         IF XsCodCli=[9999]
         ELSE
            SEEK GsClfCli+XsCodCli
            IF !FOUND()
               GsMsgErr = [ Cliente no Existe ]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            XsNomCli = NomAux
            XsDirCli = DirAux
            XsRucCli = RucAux
            @  2,14 SAY XsCodCli+' '+LEFT(XsNomCli,35)
            @  3,14 SAY XsDirCli PICT "@S40"
            @  3,75 SAY XsRucCli
         ENDIF
      CASE i = 5 .AND. XsCodCli=[9999]
         @  2,14+LEN(XsCodCli)+1 GET XsNomCli PICT "@!S35"
         @  3,14                 GET XsDirCli PICT "@!S40"
         @  3,75                 GET XsRucCli PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 6
         @  4,14 GET XsGlosa1 PICT "@!S40"
         READ
         UltTecla = LASTKEY()
      CASE i = 7
         @  5,14 GET XsGlosa2 PICT "@!S40"
         READ
         UltTecla = LASTKEY()
      CASE i = 8
         @  6,14 GET XsGlosa3 PICT "@!S40"
         READ
         UltTecla = LASTKEY()
      CASE i = 9
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,5,75,2)
      CASE i = 10
         SELE TCMB
         SEEK DTOS(XdFchDoc)
         =SEEK(XsCodOpe,"OPER")
         XfTpoCmb = IIF(OPER.TpoCmb=1,OfiCmp,OfiVta)
         @  6,75 GET XfTpoCmb PICT "9,999.9999" RANGE 0,
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 10 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>10,10,i)
ENDDO
IF UltTecla # escape_
   DO xGraba
   DO xListar
ELSE
   DO ctb_cier
ENDIF
SELE GDOC
UNLOCK ALL

RETURN
************************************************************************ FIN()
* Inicializa variables
******************************************************************************
PROCEDURE xInvar

SELE GDOC
XdFchDoc = DATE()
XdFchEmi = DATE()
XsCodCli = PADL([99999],LEN(GDOC->CodCli))
XsNomCli = SPACE(LEN(GDOC->NomCli))
XsDirCli = SPACE(LEN(GDOC->DirCli))
XsRucCli = SPACE(LEN(GDOC->RucCli))
XsGlosa1 = SPACE(LEN(GDOC->Glosa1))
XsGlosa2 = SPACE(LEN(GDOC->Glosa2))
XsGlosa3 = SPACE(LEN(GDOC->Glosa3))
XcFlgEst = [P]
STORE 0 TO XfTpoCmb,XfImpNet,XfImpTot,XfSdoDoc
XsTpoDoc = [ABONO]

XiCodMon = 1   && SOLES
XsTpoRef = [CARGO]
XsCodRef = SPACE(LEN(GDOC->CodRef))
XsNroRef = SPACE(LEN(GDOC->NroRef))
XsNumero = SPACE(LEN(GDOC->Numero))
* Variables Contables *
_MES     = 0
XsNroMes = SPACE(LEN(GDOC.NroMes))
XsNroAst = SPACE(LEN(GDOC.NroAst))
XsCodOpe = GsRegirV && [002]  && << OJO <<

RETURN
************************************************************************ FIN()
* Carga variables
******************************************************************************
PROCEDURE xMover

XsNroDoc = GDOC->NroDoc
XdFchDoc = GDOC->FchDoc
XdFchEmi = GDOC->FchEmi
XsCodCli = GDOC->CodCli
XsNomCli = GDOC->NomCli
XsDirCli = GDOC->DirCli
XsRucCli = GDOC->RucCli
XsGlosa1 = GDOC->Glosa1
XsGlosa2 = GDOC->Glosa2
XsGlosa3 = GDOC->Glosa3
XcFlgEst = GDOC->FlgEst
XfTpoCmb = GDOC->TpoCmb
XfImpNet = GDOC->ImpNet
XfImpTot = GDOC->ImpTot
XfSdoDoc = GDOC->SdoDoc
XiCodMon = GDOC->CodMon
*XsTpoRef = GDOC->TpoRef
XsCodRef = GDOC->CodRef
XsNroRef = GDOC->NroRef
XsNumero = GDOC->Numero
* Variables contables
XsNroMes = GDOC.NroMes
XsNroAst = GDOC.NroAst
XsCodOpe = GDOC.CodOpe
_MES     = VAL(XsNroMes)

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

** SOLO SE PUEDE CREAR EL DOCUMENTO, NO SE PUEDE MODIFICAR **
** control del correlativo **
SELE GDOC
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
STORE RECNO() TO iNumReg
** aperturamos nuevo cliente **
SELE SLDO
SEEK XsCodCli
IF !FOUND()
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE CodCli WITH XsCodCli
ELSE
   IF !RLOCK()
      RETURN
   ENDIF
ENDIF
** Control de Correlativos **
SELE TDOC
SEEK XsCodDoc
IF ! RLOCK()
   RETURN
ENDIF
IF m.NroDoc # XsNroDoc
   IF SEEK(XsTpoDoc+XsCodDoc+XsNroDoc,"GDOC")
      GsMsgErr = [ Registro Creado por Otro Usuario ]
      DO lib_merr WITH 99
      RETURN
   ENDIF
ELSE
   XsNroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),10,'0'),LEN(GDOC->NroDoc))
ENDIF
IF VAL(XsNroDoc)>=TDOC->NroDoc
   REPLACE TDOC->NroDoc WITH VAL(XsNroDoc)+1
ENDIF
UNLOCK
@  1,29 SAY XsNroDoc
*

SELE GDOC
GO iNumReg
REPLACE TpoDoc WITH XsTpoDoc
REPLACE CodDoc WITH XsCodDoc
REPLACE NroDoc WITH XsNroDoc
** VETT:Numero de retencion original del emisor se graba en rmov.nrodoc 2018/03/12 16:31:41 ** 
REPLACE Numero WITH XsNumero
** VETT:Fin 2018/03/12 16:31:41 ** 
REPLACE FchDoc WITH XdFchDoc
REPLACE FchEmi WITH XdFchEmi
REPLACE CodCli WITH XsCodCli
REPLACE NomCli WITH XsNomCli
REPLACE DirCli WITH XsDirCli
REPLACE RucCli WITH XsRucCli
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE Glosa1 WITH XsGlosa1
REPLACE Glosa2 WITH XsGlosa2
REPLACE Glosa3 WITH XsGlosa3
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
DO LIB_MTEC WITH 14
DO xBrowse
* * * * * * * * * * * * * * * *
* ASIGNACION DE NOTA DE ABONO *
* * * * * * * * * * * * * * * *
*          1         2         3         4         5         6         7
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*0         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*1         ³ 12345  1234567890123456789012345678901234567890 999,999,999.99³
*2         ³ 12345  1234567890123456789ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*3         ³ 12345  1234567890123456789³     Saldo Actual : 999,999,999.99   ³
*4         ³ 12345  1234567890123456789³  Monto a Asignar : 999,999,999.99   ³
*5         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³                   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ³
*6         Ú Documento a Asignar ÄÄÄÄÄ¿³  Saldo Final S/. : 999,999,999.99   ³
*7         ³ C¢digo : FACT            ³³                                     ³
*8         ³ N£mero : 1234567890      ³³      Correcto (S-N) ? : 1           ³
*9         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*          1         2         3         4         5         6         7
*
SELE GDOC
STORE RECNO() TO iNumReg   && Guardamos Puntero
XfSdoDoc = XfImpTot        && << POR DEFECTO <<
*
******* VARIABLES DE CALCULO ********
PRIVATE m.SdoDoc,m.Import,m.SdoAct
STORE 0 TO m.SdoDoc,m.Import,m.SdoAct
*************************************
** INI ----------------VETT 2008-05-28 -------------------------**
** Variable para actualizar el T/Cambio en caso el documento 
** a asignar sea de un periodo anterior al actual 
XlActTpoCmb = .F.
** FIN ----------------VETT 2008-05-28 -------------------------**
PRIVATE i
i = 1
DO WHILE .T.
   DO CASE
      CASE i = 1
         ** OJO >> Se puede superar la asignacion **
         SELE TDOC
         SET FILTER TO TpoDoc = [CARGO]
         @ 17,21 GET XsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! ccbbusca("TDOC")
               SET FILTER TO
               LOOP
            ENDIF
            XsCodRef = CodDoc
         ENDIF
         SET FILTER TO
         @ 17,21 SAY XsCodRef
         IF ! EMPTY(XsCodRef)
            SEEK XsCodRef
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
         ELSE
            ** salimos sin asignar **
             cResp = [N]
	         cResp = aviso(12,[Salir sin asignar documento (S-N)?],[],[],3,[SN],0,.F.,.F.,.T.)
    	     IF cResp = [N]
        	    **i = i - 1
	            LOOP
	         ENDIF
	         UltTecla = 0
            XsNroRef = []
            EXIT
         ENDIF
      CASE i = 2
         SELE GDOC
         SET ORDER TO GDOC04
         @ 18,21 GET XsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            SET ORDER TO GDOC01
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroRef)
            IF ! ccbbusca("ASIG")
               SET ORDER TO GDOC01
               LOOP
            ENDIF
            XsNroRef = NroDoc
         ENDIF
         @ 18,21 SAY XsNroRef
         SET ORDER TO GDOC01
         SEEK XsTpoRef+XsCodRef+XsNroRef
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         IF CodCli # XsCodCli
            GsMsgErr = [El documento no es del Cliente]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF FlgEst = [C]
            GsMsgErr = [ Documento Cancelado ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF FlgEst = [A]
            GsMsgErr = [ Documento Anulado ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         SAVE SCREEN TO LsPanAsg
         @ 12,38 CLEAR TO 19,76
         @ 12,38 TO 19,76
         @ 13,41 SAY "   Saldo Actual :                "
         @ 14,41 SAY "Monto a Asignar :                "
         @ 15,41 SAY "                 ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
         @ 16,41 SAY "Saldo Final     :                "
         @ 17,41 SAY "                                 "
         @ 18,41 SAY "    Correcto (S-N) ? :           "
         * variables de calculo *
         PRIVATE m.SdoDoc,m.Import,m.SdoAct
         m.SdoDoc = GDOC->SdoDoc
         m.Import = XfImpTot

         ** INI ----------------VETT 2008-05-28 -------------------------**
*!*	         IF XiCodMon=2 AND LEFT(DTOS(GDOC.FchDoc),6)<LEFT(DTOS(XdFchDoc),6)
			** VETT:Tipo de cambio de documento origen  no afecta retenciones RETC 2021/02/03 21:49:06 ** 
         	** IF XiCodMon=2 AND GDOC.FchDoc<XdFchDoc AND XsCodDoc<>"RETC"
			** VETT:Eliminar el filtro de moneda, todas las N/C son emtidas con el T/C del documento de origen si es de una fecha menor 2021/04/13 15:43:33 ** 
			IF GDOC.FchDoc<XdFchDoc AND XsCodDoc<>"RETC"
				XfTpoCmb= GDOC.TpoCmb
				@  6,75 GET XfTpoCmb PICT "9,999.9999"
				CLEAR GETS												         	
				XlActTpoCmb = .t.
         	ENDIF
		 ** FIN ----------------VETT 2008-05-28 -------------------------**
         IF GDOC->CodMon # XiCodMon
            IF GDOC->CodMon = 1
               m.Import = ROUND(XfImpTot*XfTpoCmb,2)
            ELSE
               m.Import = ROUND(XfImpTot/XfTpoCmb,2)
            ENDIF
         ENDIF
         
         m.SdoAct = m.SdoDoc-m.Import
         @ 13,59 SAY m.SdoDoc PICT "999,999,999.99"
         @ 14,59 SAY m.Import PICT "999,999,999.99"
         @ 16,53 SAY IIF(GDOC->CodMon=1,'S/.','US$')
         @ 16,59 SAY m.SdoAct PICT "999,999,999.99"
         IF m.SdoAct < 0
            cResp = []
            cResp = Aviso(12,[El Importe de la N/C supera],;
                    [el saldo del documento a asignar],;
                    [presione SPACE para continuar],1,' ',0,.F.,.F.,.T.)
            RESTORE SCREEN FROM LsPanAsg
            LOOP
         ENDIF
         cResp = [N]
         @ 18,64 GET cResp PICT "!" VALID(cResp$'SN')
         READ
         UltTecla = LASTKEY()
         IF UltTecla # Enter
            RESTORE SCREEN FROM LsPanAsg
            LOOP
         ENDIF
         RESTORE SCREEN FROM LsPanAsg
         IF cResp = [S]
            XcFlgEst = [C]    && << OJO CON EL CAMBIO <<
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
** TERMINAMOS LA GRABACION **
IF XcFlgEst = [P]
   SELE SLDO
   IF XiCodMon = 1
      REPLACE AbnNAC WITH AbnNAC + XfImpTot
   ELSE
      REPLACE AbnUSA WITH AbnUSA + XfImpTot
   ENDIF
   UNLOCK
   *
   SELE GDOC
   GO iNumReg
   REPLACE TpoRef WITH XsTpoRef
   REPLACE CodRef WITH XsCodRef
   REPLACE NroRef WITH XsNroRef
   REPLACE ImpNet WITH XfImpTot
   REPLACE ImpTot WITH XfImpTot
   REPLACE ImpIgv WITH XfImpIgv
   REPLACE ImpBto WITH XfImpTot-XfImpIgv
   REPLACE FchVto WITH XdFchDoc
   REPLACE SdoDoc WITH XfSdoDoc
   REPLACE FlgEst WITH XcFlgEst
   ** INI ----------------VETT 2008-05-28 -------------------------**
   ** Actualizamos el tipo de cambio si el documento asignado es de un mes anterior a _ANO y _MES
   IF XlActTpoCmb
   		REPLACE TpoCmb WITH XfTpoCmb
   ENDIF
   ** FIN ----------------VETT 2008-05-28 -------------------------**
ELSE
   ** bloqueamos documento a asignar **
   SELE GDOC
   SEEK XsTpoRef+XsCodRef+XsNroRef
   DO WHILE ! RLOCK()
   ENDDO
   REPLACE SdoDoc WITH SdoDoc - m.Import
   IF SdoDoc <= 0.01
      REPLACE FlgEst WITH [C]
      REPLACE FchAct WITH XdFchDoc
   ENDIF
   UNLOCK
   SELE SLDO
   IF GDOC->CodMon = 1
      REPLACE CgoNAC WITH CgoNAC - m.Import
   ELSE
      REPLACE CgoUSA WITH CgoUSA - m.Import
   ENDIF
   ** generamos movimiento de cancelacion **
   SELE VTOS
   APPEND BLANK
   DO WHILE ! RLOCK()
   ENDDO
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE FchDoc WITH XdFchDoc
   REPLACE CodCli WITH XsCodCli
   REPLACE CodMon WITH XiCodMon
   REPLACE TpoCmb WITH XfTpoCmb
   REPLACE TpoRef WITH XsTpoRef
   REPLACE CodRef WITH XsCodRef
   REPLACE NroRef WITH XsNroRef
   REPLACE Import WITH XfImpTot
   UNLOCK
   ** actualizamos saldo del documento **
   SELE GDOC
   GO iNumReg
   REPLACE TpoRef WITH XsTpoRef
   REPLACE CodRef WITH XsCodRef
   REPLACE NroRef WITH XsNroRef
   REPLACE ImpNet WITH XfImpTot
   REPLACE ImpTot WITH XfImpTot
   REPLACE ImpIgv WITH XfImpIgv
   REPLACE ImpBto WITH XfImpTot-XfImpIgv
   REPLACE FchVto WITH XdFchDoc
   REPLACE FchAct WITH XdFchDoc
   REPLACE SdoDoc WITH 0
   REPLACE FlgEst WITH XcFlgEst
   ** INI ----------------VETT 2008-05-28 -------------------------**
   ** Actualizamos el tipo de cambio si el documento asignado es de un mes anterior a _ANO y _MES
   IF XlActTpoCmb
   		REPLACE TpoCmb WITH XfTpoCmb
   ENDIF
   ** FIN ----------------VETT 2008-05-28 -------------------------**
ENDIF
IF XfImpTot > 0   && << OJO << Caso error u omisi¢n (burrada)
   DO xACT_CTB
   SELECT GDOC
   GO iNumReg
ENDIF

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE GDOC
IF FlgEst = [A] .AND. RLOCK()
   DELETE
   UNLOCK
   SKIP
   RETURN
ENDIF

IF FlgEst # 'P'
   GsMsgErr = [ Acceso Denegado ]+IIF(Flgest='C','Documento esta cancelado','')
   DO lib_merr WITH 99
   RETURN
ENDIF
IF ImpTot # SdoDoc
   GsMsgErr = [ Tiene Aplicaciones Realizadas ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF !RLOCK()
   RETURN
ENDIF
if flgest="A"
	DELETE
    UNLOCK ALL
   	SKIP
    RETURN
endif
* bloqueamos clientes *
SELE SLDO
SEEK GDOC->CodCli
IF !RLOCK()
   RETURN
ENDIF
* VEAMOS SI SE PUEDE ANULAR LA CONTABILIDAD *

IF GDOC.FlgCtb
   IF !ctb_aper(GDOC.FchEmi)
      SELE GDOC
      UNLOCK ALL
      RETURN
   ENDIF
ENDIF
* borramos detalles *
OK = .T.
SELE RDOC
SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
   IF !REC_LOCK(5)
      OK = .F.
      EXIT
   ENDIF
   DELETE
   UNLOCK
ENDSCAN
IF OK
   * actualizamos clientes *
   SELE SLDO
   IF GDOC->CodMon = 1
      REPLACE AbnNAC WITH AbnNAC - GDOC->ImpTot
   ELSE
      REPLACE AbnUSA WITH AbnUSA - GDOC->ImpTot
   ENDIF
   UNLOCK
   *
   IF GDOC.FlgCtb
      DO xANUL_CTB
   ENDIF
   *
   SELE GDOC
   REPLACE FchAct WITH DATE()
   REPLACE SdoDoc WITH 0
   repla   flgest with "A"
ENDIF

UNLOCK ALL
RETURN
************************************************************************ FIN()
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
EscLin   = []
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbGrab"
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
NClave   = [TpoDoc+CodDoc+NroDoc]
VClave   = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
HTitle   = 1
Yo       = 9
Xo       = 10
Largo    = 7
Ancho    = 66
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = [Codigo+'  '+PADR(GLOSA,40)+' '+TRANS(Import,'999,999,999.99')]
Static   = .F.
VSombra  = .F.
SELECT RDOC
*** Variable a Conocer ****
PRIVATE XsCodigo,XfImport,XSGLOSA
STORE [] TO XsCodigo,XfImport,XSGLOSA
**
DO DBrowse
SELECT GDOC
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit

IF ! Crear
   IF !RLOCK()
      RETURN
   ENDIF
   XsCodigo = RDOC->Codigo
   XfImport = RDOC->Import
   XsGlosa  = RDOC.Glosa
ELSE
   XsCodigo = SPACE(LEN(RDOC->Codigo))
   XfImport = 0.00
   XsGlosa  = SPACE(LEN(RDOC.Glosa  ))

ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,escape_,CtrlW,F10)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         SELE TABLA
         @ LinAct,12 GET XsCodigo PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = escape_
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodigo)
            SEEK 'NA'
            IF ! ccbbusca("0001")
               LOOP
            ENDIF
            XsCodigo = TABLA->Codigo
         ENDIF
         @ LinAct,12 SAY XsCodigo
         SEEK 'NA'+XsCodigo
         IF ! FOUND()
            GsMsgErr = "Concepto no Registrado"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ LinAct,19 SAY LEFT(TABLA->Nombre,40)
         XsGlosa=LEFT(TABLA->Nombre,40) 
         IF XsCodigo = "IGV"
            XfImpIgv = ROUND(XfImpTot*CfgADMIgv/100,2)
            XfImport = ROUND(XfImpTot*CfgADMIgv/100,2)
         ENDIF
     CASE i = 2
         @ LinAct,19 GET XsGlosa PICT "@S40"
         READ
         UltTecla = LastKey()
         IF UltTecla = escape_
            LOOP
         ENDIF
      CASE i = 3
         @ LinAct,60 GET XfImport PICT "999,999,999.99" RANGE 0,
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3, 3, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT RDOC
IF UltTecla = escape_
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE MOVbgrab

IF Crear
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   XfImpTot = XfImpTot - RDOC->Import
ENDIF
REPLACE Codigo WITH XsCodigo
REPLACE Import WITH XfImport
REPLACE Glosa  WITH XsGlosa
UNLOCK
XfImpTot = XfImpTot + XfImport
@ 16,60 SAY XfImpTot PICT "999,999,999.99"
@ 17,60 SAY XfImpTot PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE MOVbborr

IF !RLOCK()
   RETURN
ENDIF
XfImpTot = XfImpTot - RDOC->Import
DELETE
UNLOCK
@ 16,60 SAY XfImpTot PICT "999,999,999.99"
@ 17,60 SAY XfImpTot PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Impresion en Formato Continuo
************************************************************************ FIN *
PROCEDURE xListar
SAVE SCREEN TO xListarScr
* posicionamos punteros *
=SEEK(GsClfCli+GDOC->CodCli,"AUXI")
=SEEK(GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc,"RDOC")
XFOR   = ".T."
XWHILE = "TpoDoc+CodDoc+NroDoc=GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc"
SELE RDOC
Largo  = 42       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]

*!*	sNomRep = ICASE(XsCodDoc='N/C',"ccbabon1_NC_"+GsSigCia,XsCodDoc='ANTI',"ccbabon1_ANTI_"+GsSigCia,XsCodDoc='RETC',"ccbabon1_RETC_"+GsSigCia,"ccbabon1")
*!*	sNomRep2=	ICASE(XsCodDoc='N/C',"ccbabon1_NC-TM_"+GsSigCia,XsCodDoc='ANTI',"ccbabon1_ANTI-TM_"+GsSigCia,XsCodDoc='RETC',"ccbabon1_RETC-TM_"+GsSigCia,"ccbabon1")
_Fontsize = 8
*!*	DO f0print WITH "REPORTS"
lcRptTxt	= TRIM(ICASE(GDOC.CodDoc='N/C',"ccbabon1_NC_"+GsSigCia,GDOC.CodDoc='ANTI',"ccbabon1_ANTI_"+GsSigCia,GDOC.CodDoc='RETC',"ccbabon1_RETC_"+GsSigCia,"ccbabon1") )
lcRptGraph	= TRIM(ICASE(GDOC.CodDoc='N/C',"ccbabon1_NC-TM_"+GsSigCia,GDOC.CodDoc='ANTI',"ccbabon1_ANTI-TM_"+GsSigCia,GDOC.CodDoc='RETC',"ccbabon1_RETC-TM_"+GsSigCia,"ccbabon1") )
lcRptDesc	= XsNomBreDoc
CurSession  = SET("Datasession")
DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , CurSession && THISFORM.DATASESSIONID

IF ctb_aper(GDOC.FchEmi)
	STORE 0 TO nImpNac,nImpUSa
	XsNroMes = GDOC.NroMes
	XsCodOpe = GDOC.CodOpe
	XsNroAst = GDOC.NroAst
	DO Imprvouc IN Cbd_DiarioGeneral
	DO ctb_cier
	SELECT GDOC
ENDIF
RESTORE SCREEN FROM xListarScr
RETURN
************************************************************************ FIN *
*************** RUTINAS DE ACTUALIZACION DE CONTABILIDAD *********************
******************************************************************************
PROCEDURE xACT_CTB
PRIVATE DirCtb,UltTecla && _MES,_ANO,
PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef,XsTipRef,XdFchDtr,XsNroDtr
PRIVATE XfImport,XdFchDoc,XdFchVto
PRIVATE XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,TsCodDiv1  &&XsCodOpe,XsNroMes,XsNroAst,
PRIVATE XiNroItm,XsCodDiv,XsCtaPre,XcAfecto,XsCodCco,GlInterface,XsCodDoc,XsNroDoc 
PRIVATE XsNroRef,XsCodFin,XdFchdoc,XdFchVto,XsIniAux,XdFchPed,NumCta,XsNivAdi
PRIVATE XcTipoC,XsTipDoc,XsAn1Cta,XsCc1Cta,XsChkCta, nImpUsa, nImpNac,vCodCta
** Valores Fijos
GlInterface = .f.
TsCodDiv1= '01'
XsCodDiv=TsCodDiv1
XcAfecto = 'A'
** Valores variables inicializados como STRING
dimension vcodcta(10)
STORE {} TO XdFchDoc,XdFchVto,XdFchPed
STORE '' TO XsCodCco ,XsCodDoc,XsNroDoc,XsNroRef,XsCtaPre,XsIniAux,XsNivAdi,XcTipoC,XsCodFin
STORE '' TO XsChkCta,XsTipDoc,XsCC1Cta,XsAn1Cta,vCodCta,XsNroRuc
** Valores variables inicializados como NUMERO
STORE 0 TO nImpNac,nImpUsa,NumCta

=SEEK(GDOC.CodDoc,"TDOC")
IF EMPTY(TDOC.CodCta) AND EMPTY(TDOC.CTA12_MN) AND EMPTY(TDOC.CTA12_ME)
	=f1_alert('Actualización contable queda pendiente.;'+;
			'Revise en Cuentas por cobrar/Maestros/Tipo de documentos;'+;
			'y configure las cuentas contables',[MENSAJE])
   RETURN
ENDIF
*********
XsCodOpe = TDOC.CodOpe
SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
   GsMsgErr = [NO se pudo generar el asiento contable]
   DO lib_merr WITH 99
   RETURN
ENDIF
SELECT GDOC
IF &sesrgv. AND !EMPTY(GDOC.CodOpe) AND !EMPTY(NroAst) AND !EMPTY(NroMes)
	XsNroMes = GDOC.NroMes
	XsCodOpe = GDOC.CodOpe
	XsNroAst = GDOC.NroAst
	SELECT VMOV
	SEEK (XsNroMes + XsCodOpe + XsNroAst)
	IF FOUND()
		GOSVRCBD.Crear = .f.
		GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst,.T.)
	ELSE
		GOSVRCBD.Crear = .T.
	ENDIF
ELSE
	SELECT OPER
	XsNroMes = TRANSF(_MES,"@L ##")
	XsNroAst = GOSVRCBD.NROAST()
	GOSVRCBD.Crear = .T.
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
XdFchAst = GDOC.FchEmi  && GDOC.FchDOC  
XsNroVou = ''
XiCodMon = GDOC.CodMon
XfTpoCmb = GDOC.TpoCmb
XsNotAst = GDOC.CodDoc+[ ]+GDOC.NroDoc+[ ]+GDOC.NomCli
m.Err= GOSVRCBD.MovGraba(XsNroMes,XsCodOpe,@XsNroAst)
IF m.Err>=0
** ACTUALIZAR DATOS DE CABECERA **
	REPLACE GDOC.NroMes WITH XsNroMes
	REPLACE GDOC.CodOpe WITH XsCodOpe
	REPLACE GDOC.NroAst WITH XsNroAst
	REPLACE GDOC.FlgCtb WITH .T.
ELSE
	REPLACE GDOC.FlgCtb WITH .F.
	GoSvrCbd.MensajeErr(m.Err)
	RETURN
ENDIF
LiRecActGDOC_Act = RECNO('GDOC')
* * * * * * * * * * * * * * * * * *

* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef,XsTipRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa,LsLLaveRef1,LiRecActGDOC
STORE [] TO XsTipRef,XsNroDtr,LsLLaveRef1
STORE {} TO XdFchRef,XdFchDtr
XiNroItm = 1
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsGloDoc = VMOV.NotAst &&SPACE(LEN(RMOV.GloDoc))
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
nImpNac  = 0
nImpUsa  = 0
** Grabamos las cuentas de detalle **

SELE RDOC
SEEK GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
DO WHILE !EOF() .AND. TpoDoc+CodDoc+NroDoc = GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
	IF EMPTY(RDOC.Codigo)
		SKIP 
		LOOP
	ENDIF
   =SEEK([NA]+RDOC.Codigo,"TABLA")
   XsCodCta = TABLA.CodCta
   XsGloDoc = TABLA.Nombre
   XsCodRef = SPACE(LEN(RMOV.CodRef))
   =SEEK(XsCodCta,"CTAS")
   XsCodAux = SPACE(LEN(RMOV.CodAux))
   IF CTAS.PidAux=[S]
		XsClfAux = 	CTAS.ClfAux
	    XsCodAux = GDOC.CodCli
   ENDIF
   XcTpoMov = [D]    && << OJO <<
   XfImport = RDOC.Import
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
   XsTipRef = SPACE(LEN(RMOV.TipRef))
   XsNroRef = SPACE(LEN(RMOV.NroRef))
   XsClfAux = SPACE(LEN(RMOV.ClfAux))
   XdFchDoc = {}
   XdFchRef = {}
   IF CTAS.PidDoc=[S]
	*!*	   		XsClfAux = CTAS.ClfAux
	*!*	      XsCodDoc = IIF(SEEK(GsCodSed+GDOC.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'')   && GDOC.CodDoc
	** VETT  14/03/18 23:32 : Cambiamos de tabla de documentos para que detecte la CFG de retenciones 
      XsCodDoc = IIF(SEEK(GDOC.CodDoc,'TDOC'),TDOC.TpoDocSN,'')   && GDOC.CodDoc
      XsNroDoc = GDOC.NroDoc
      XdFchDoc = GDOC.FchDoc
	*!*	      XsNroRef = []  && GDOC.NroDoc
   ENDIF
	IF CTAS.PidGlo=[S]
		XsTipRef = 	IIF(SEEK(GDOC.CodRef,'TDOC'),TDOC.TpoDocSN,'')	
		XsNroRef =   GDOC.NroRef
		** VETT  15/03/2018 05:06 PM : Obtenemos fecha de documento de referencia 
		LiRecActGDOC = RECNO('GDOC')
		LsLLaveRef1=GDOC.TpoRef+GDOC.CodRef+GDOC.NroRef
	    IF SEEK(LsLLaveRef1,'GDOC')
	    	XdFchRef = GDOC.FchDOc
	    ENDIF
	    GO LiRecActGDOC  IN GDOC
	ENDIF
   
	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
	XiNroItm = XiNroItm + 1
   *
   SELE RDOC
   SKIP
ENDDO
** Grabamos la cuenta de Cargo **
=SEEK(GDOC.CodDoc,"TDOC")
XsCodCta = PADR(IIF(Gdoc.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
XsCodRef = SPACE(LEN(RMOV.CodRef))
=SEEK(XsCodCta,"CTAS")
XsCodAux = SPACE(LEN(RMOV.CodAux))
XsClfAux = ''
IF CTAS.PidAux=[S]
	XsClfAux = CTAS.ClfAux
	XsCodAux = GDOC.CodCli
ENDIF
XcTpoMov = [H]    && << OJO <<
XfImport = GDOC.ImpTot
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
XsTipRef = SPACE(LEN(RMOV.TipRef))
XsNroRef = SPACE(LEN(RMOV.NroRef))
XsClfAux = SPACE(LEN(RMOV.ClfAux))
XdFchDoc = {}
XdFchRef = {}
IF CTAS.PidDoc=[S]
	XsClfAux = CTAS.ClfAux
	*!*	    XsCodDoc = IIF(SEEK(GsCodSed+GDOC.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'')   && GDOC.CodDoc
	** VETT  14/03/18 23:32 : Cambiamos de tabla de documentos para que detecte la CFG de retenciones 
	XsCodDoc = IIF(SEEK(GDOC.CodDoc,'TDOC'),TDOC.TpoDocSN,'')   && GDOC.CodDoc
    XsNroDoc = GDOC.NroDoc
    XdFchDoc = GDOC.FchDoc
*!*	    XsNroRef = []  && GDOC.NroDoc
ENDIF
IF CTAS.PidGlo=[S]
	XsTipRef = 	IIF(SEEK(GDOC.CodRef,'TDOC'),TDOC.TpoDocSN,'')	
	XsNroRef =  GDOC.NroRef
	LiRecActGDOC = RECNO('GDOC')
	LsLLaveRef1=GDOC.TpoRef+GDOC.CodRef+GDOC.NroRef
    IF SEEK(LsLLaveRef1,'GDOC')
    	XdFchRef = GDOC.FchDOc
    ENDIF
    GO LiRecActGDOC IN GDOC
ENDIF
GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
** ACTUALIZAMOS SI ESTA ASIGNADO EN FORMA DIRECTA **

IF GDOC.FlgEst = [C] 
    ** VETT 2007-08-17 14:22 pm ** 
	XcAfecto = ''
    ** VETT 2007-08-17 14:22 pm **
    
    SELE VTOS
    SEEK GDOC.CodRef+GDOC.NroRef
    OK = .F.
    DO WHILE !EOF() .AND. CodRef+NroRef=GDOC.CodRef+GDOC.NroRef
       IF CodDoc+NroDoc=GDOC.CodDoc+GDOC.NroDoc
          OK = .T.
          EXIT
       ENDIF
       SKIP
    ENDDO
    IF !OK
       RETURN
    ENDIF
    IF !REC_LOCK(5)
		GsMsgErr =[No se puede generar asiento de cancelacion]
        DO lib_merr WITH 99
        RETURN
    ENDIF
   * * * *
*!*	   XsCodOpe = [021]  && Provisiones varias 29/04/2000 vett provisional - ojo
*!*	   SELE OPER
*!*	   SEEK XsCodOpe
*!*	   IF !REC_LOCK(5)
*!*	      GsMsgErr = [NO se pudo generar el asiento contable]
*!*	      DO lib_merr WITH 99
*!*	      RETURN
*!*	   ENDIF
*!*	   XsNroMes = TRANSF(_MES,"@L ##")
*!*	   XsNroAst = GOSVRCBD.NROAST()
*!*	   SELECT VMOV
*!*	   SEEK (XsNroMes + XsCodOpe + XsNroAst)
*!*	   IF FOUND()
*!*	      DO LIB_MERR WITH 11
*!*	      RETURN
*!*	   ENDIF
*!*	   APPEND BLANK
*!*	   IF ! Rec_Lock(5)
*!*	      GsMsgErr = [NO se pudo generar el asiento contable]
*!*	      DO lib_merr WITH 99
*!*	      RETURN              && No pudo bloquear registro
*!*	   ENDIF
*!*	   WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
*!*	   REPLACE VMOV->NROMES WITH XsNroMes
*!*	   REPLACE VMOV->CodOpe WITH XsCodOpe
*!*	   REPLACE VMOV->NroAst WITH XsNroAst
*!*	   REPLACE VMOV->FLGEST WITH "R"
*!*	   SELECT OPER
*!*	   GOSVRCBD.NROAST(XsNroAst)
*!*	   SELECT VMOV
*!*	   REPLACE VMOV->FchAst  WITH GDOC.FchDoc
*!*	   REPLACE VMOV->NroVou  WITH []
*!*	   REPLACE VMOV->CodMon  WITH GDOC.CodMon
*!*	   REPLACE VMOV->TpoCmb  WITH GDOC.TpoCmb
*!*	   REPLACE VMOV->NotAst  WITH GDOC.CodDoc+[ ]+GDOC.NroDoc+[ ]+GDOC.NomCli
*!*	   REPLACE VMOV->Digita  WITH GsUsuario
   ** ACTUALIZAR DATOS DE CABECERA **
    REPLACE VTOS.NroMes WITH XsNroMes
    REPLACE VTOS.CodOpe WITH XsCodOpe
    REPLACE VTOS.NroAst WITH XsNroAst
    REPLACE VTOS.FlgCtb WITH .T.
    * * * * * * * * * * * * * * * * * *
    * Barremos el detalle *
    XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
    XcEliItm = SPACE(LEN(RMOV.EliItm))
    XdFchAst = VMOV.FchAst
    XsNroVou = VMOV.NroVou
    XiCodMon = VMOV.CodMon
    XfTpoCmb = VMOV.TpoCmb
    XsGloDoc = VMOV.NotAst && SPACE(LEN(RMOV.GloDoc))
    XdFchDoc = XdFchAst
    XdFchVto = XdFchAst
    nImpNac  = 0
    nImpUsa  = 0
     
    ** Generamos Detalle **
    * 1er. REGISTRO
    SELE VTOS
    =SEEK(CodDoc,"TDOC")
    XsCodCta = PADR(IIF(VTOS.CodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
    XsCodRef = SPACE(LEN(RMOV.CodRef))
    =SEEK(XsCodCta,"CTAS")
    XsCodAux = SPACE(LEN(RMOV.CodAux))
    XsClfAux = ''
    IF CTAS.PidAux=[S]
   		XsClfAux = CTAS.ClfAux
        XsCodAux = VTOS.CodCli
    ENDIF
    XcTpoMov = [D]    && << OJO <<
    XfImport = VTOS.Import
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
    XsTipRef = SPACE(LEN(RMOV.TipRef))
    XsNroRef = SPACE(LEN(RMOV.NroRef))
    XdFchDoc = {}
    XdFchRef = {}
    IF CTAS.PidDoc=[S]
 		*!*	      XsCodDoc = IIF(SEEK(GsCodSed+VTOS.CodDoc+'001','DOCM'),DOCM.TpoDocSN,'')   && VTOS.CodDoc
 		** VETT  14/03/18 23:32 : Cambiamos de tabla de documentos para que detecte la CFG de retenciones 
 		XsCodDoc = IIF(SEEK(VTOS.CodDoc,'TDOC'),TDOC.TpoDocSN,'')   && GDOC.CodDoc
 		XsNroDoc = VTOS.NroDoc
        XdFchDoc = VTOS.FchDoc
 *!*	      XsNroRef = VTOS.NroDoc
    ENDIF
	IF CTAS.PidGlo=[S]
		XsTipRef = 	IIF(SEEK(VTOS.CodRef,'TDOC'),TDOC.TpoDocSN,'')	
		XsNroRef =   VTOS.NroRef
		** VETT  15/03/2018 05:06 PM : Obtenemos fecha de documento de referencia 
		LiRecActGDOC = RECNO('GDOC')
		LsLLaveRef1=VTOS.TpoRef+VTOS.CodRef+VTOS.NroRef
	    IF SEEK(LsLLaveRef1,'GDOC')
	    	XdFchRef = GDOC.FchDOc
	    ENDIF
	    GO LiRecActGDOC IN GDOC 
			
	ENDIF


	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
   * 2do. REGISTRO
   
    SELE VTOS
    =SEEK(CodRef,"TDOC")
    ** Utilizamos la moneda del documento de referencia **
    LnCodMon=VTOS.CodMon
	IF VTOS.CodDoc='RETC'
   		IF SEEK(VTOS.TpoRef+VTOS.CodRef+VTOS.NroRef,'GDOC','GDOC01')
   			LnCodMon = GDOC.CodMon
   		ENDIF	
	ENDIF
	XsCodCta = PADR(IIF(LnCodMon=1,TDOC.CTA12_MN,TDOC.CTA12_ME),LEN(CTAS.CodCta))
	XsCodRef = SPACE(LEN(RMOV.CodRef))
	=SEEK(XsCodCta,"CTAS")
	XsClfAux = SPACE(LEN(RMOV.ClfAux))
	XsCodAux = SPACE(LEN(RMOV.CodAux))
	IF CTAS.PidAux=[S]
   		XsClfAux = CTAS.ClfAux
   		XsCodAux = VTOS.CodCli
	ENDIF
	XcTpoMov = [H]    && << OJO <<
	XfImport = VTOS.Import
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
	XsTipRef = SPACE(LEN(RMOV.TipRef))	
	XsNroRef = SPACE(LEN(RMOV.NroRef))
    XdFchDoc = {}
    XdFchRef = {}
	XdFchVto = {}
	IF CTAS.PidDoc=[S]
	*!*	XsClfAux = CTAS.ClfAux
	*!*	XsCodDoc = IIF(SEEK(GsCodSed+VTOS.CodRef+'001','DOCM'),DOCM.TpoDocSN,'')   && VTOS.CodDoc
	** VETT  14/03/18 23:32 : Cambiamos de tabla de documentos para que detecte la CFG de retenciones 
		XsCodDoc = IIF(SEEK(VTOS.CodRef,'TDOC'),TDOC.TpoDocSN,'')
		XsNroDoc = VTOS.NroRef
		** VETT  15/03/2018 05:06 PM : Obtenemos fecha de documento de referencia 
		LiRecActGDOC = RECNO('GDOC')
		LsLLaveRef1=VTOS.TpoRef+VTOS.CodRef+VTOS.NroRef
	    IF SEEK(LsLLaveRef1,'GDOC')
	    	XdFchDoc	=	GDOC.FchDOc
	    	XdFchVto	=	GDOC.FchVto
	    ENDIF
	    GO LiRecActGDOC IN GDOC
	*!*	XsNroRef = VTOS.NroDoc
	ENDIF
	IF CTAS.PidGlo=[S]
		XsTipRef = 	IIF(SEEK(VTOS.CodDoc,'TDOC'),TDOC.TpoDocSN,'')	
		XsNroRef =  VTOS.NroDoc
		XdFchRef =	VTOS.FchDoc	  
	ENDIF
	XiNroItm = goSvrCbd.Cap_NroItm(XsNroMes+XsCodOpe+XsNroAst,'RMOV','NroMes+CodOpe+NroAst')
	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
ENDIF
** Cerramos bases de datos **
WAIT [Fin de Generacion] WINDOW NOWAIT
IF cVCtrl <> 'C'
	DO Imprvouc IN Cbd_DiarioGeneral
ENDIF	
DO ctb_cier

RETURN
************************************************************************ FIN *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB

XsNroMes = GDOC.NroMes
XsCodOpe = GDOC.CodOpe
XsNroAst = GDOC.NroAst
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !REC_LOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
   DO lib_merr WITH 99
   DO ctb_cier
   RETURN
ENDIF
IF FlgEst = [A]
   DELETE   && Por Ahora
else
	GOSVRCBD.MovBorra(XsNroMes,XsCodOpe,XsNroAst)
endif
SELE VMOV
DO ctb_cier
RETURN
************************************************************************ FIN *
