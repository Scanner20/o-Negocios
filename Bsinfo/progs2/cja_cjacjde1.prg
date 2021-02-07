*-------------------------------------------------------------------------------
*  Nombre       : CjaCjDeu.PRG                                                 *
*  Objeto       : Canje de Deuda Cliente-Proveedor                             *
*  Par metros   : Ninguno                                                      *
*  Autor        : Eduardo Tapia  Castillo                                      *
*  Creaci¢n     : 05/08/94                                                     *
*  Actualizaci¢n:                                                              *
*                                                                              *
*-------------------------------------------------------------------------------
*!*	WAIT WINDOW 'En implementacion' nowait
#include const.h 	
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
SYS(2700,0)           

cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")

Do FONDO WITH 'CANJE DE DEUDA CLIENTE-PROVEEDOR '+cTitulo + '    USUARIO: '+ goEntorno.User.Login +'   '+' EMPRESA: '+TRIM(GsNomCia),'','',''

DO xPanta
SAVE SCREEN TO LsScreen

PUBLIC LoContab as Contabilidad OF SYS(5)+"\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')

RESTORE FROM LoContab.oentorno.tspathcia+'CJACONFG.MEM' ADDITIVE

*** Constantes para dibujar la pantalla ***
STORE 0 TO LinImpChq ,LinConcep,YoBrow1 ,YoBrow2 ,RowsBrow1,RowsBrow2,AnchoBrow1,AnchoBrow2

STORE 0 TO XoParFin,XoDesFin

WAIT WINDOW "Aperturando archivos..." NOWAIT 
IF !LoContab.MOVApert()
	RELEASE LoContab 
	CLEAR
	CLEAR MACROS
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF
	SYS(2700,1)  
   RETURN
ENDIF
LoContab.odatadm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBRRDOC','RDOC','RDOC01','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')
LoContab.oDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
WAIT WINDOW "Listo" Nowait
**********************************
* Aperturando Archivos a usar    *
**********************************
*!*	CLOSE DATA
*!*	USE CCBMVTOS IN 1 ORDER VTOS01 ALIAS VTOS
*!*	IF !USED(1)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	**
*!*	USE CCBRGDOC IN 2 ORDER GDOC04 ALIAS GDOC
*!*	IF !USED(2)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	**
*!*	USE CCBTBDOC IN 3 ORDER BDOC01 ALIAS TDOC
*!*	IF !USED(3)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	**
*!*	USE CBDMAUXI IN 4 ORDER AUXI01 ALIAS CLIE
*!*	IF !USED(4)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	**
*!*	USE CCBSALDO IN 5 ORDER SLDO01 ALIAS SLDO
*!*	IF !USED(5)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF

*!*	** ARCHIVOS DE CONTABILIDAD **
*!*	USE CBDMCTAS IN 6 ORDER CTAS01 ALIAS CTAS
*!*	IF ! USED(6)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	USE CBDVMOVM IN 7 ORDER VMOV01 ALIAS VMOV
*!*	IF ! USED(7)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	USE CBDRMOVM IN 8 ORDER RMOV01 ALIAS RMOV
*!*	IF ! USED(8)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	USE CBDMTABL IN 9 ORDER TABL01 ALIAS TABL
*!*	IF ! USED(9)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	USE CBDTOPER IN 10 ORDER OPER01 ALIAS OPER
*!*	IF ! USED(10)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	USE CBDACMCT IN 11 ORDER ACCT01 ALIAS ACCT
*!*	IF ! USED(11)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*!*	*
*!*	USE CJADPROV IN 12 ORDER DPRO01 ALIAS DPRO
*!*	IF ! USED(12)
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*

** Variables Contables **
XsClfAux	=	GsClfCli
XsCodOpe2= '025'     && Aplicaci¢n Cliente - Proveedor
XsCodOpe = "003"     && Egresos de Caja
XsCodOp1 = "005"     && Proveedores
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = SPACE(6)
** RELACIONES A USAR **
SELE RMOV
SET RELA TO XsClfAux+CodAux INTO AUXI
SELE VMOV

********************************************************************************
* Inicializando Variables a usar                                               *
********************************************************************************
** VARIABLES DE LA CABECERA **

SELECT VMOV
XsNroAst = SPACE(LEN(NroAst))
XdFchAst = DATE()
XdFchCje = DATE()

XsNotAst = SPACE(LEN(NotAst))
XnCodMon = 1
XfTpoCmb = 0.00

M.ImpDoc = 0
M.FlgEst = [E]
M.FchDoc = DATE()
M.CodDoc = "C/D "
M.NroDoc = SPACE(10)

IF ! SEEK(M.CodDoc,"TDOC")
   WAIT "No existe correlativo" NOWAIT WINDOW
   UltTecla = escape_
   RETURN
ENDIF
M.NroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),9,'0'),LEN(m.NroDoc))
cCodDoc = M.CodDoc

** variables de control de datos intermedios **
M.Import  = 0.00     && importe de documentos
M.ImpDoc  = 0.00     && importe de letras (= importe del canje)
M.ImpInt  = 0.00
M.Crear   = .T.

** Datos del Browse de Documentos **
CIMAXELE = 10
DIMENSION AsCodRef(CIMAXELE)
DIMENSION AsCtaRef(CIMAXELE)
DIMENSION AsNroRef(CIMAXELE)
DIMENSION AfSdoDoc(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
DIMENSION AfImptot(CIMAXELE)
GiTotDoc = 0
GiTotItm = 0
GiTotLet = 0
** Definimos Codigo de Operacion de Compras **
SELECT OPER
*!*	LOCA FOR Origen
SEEK XsCodOp1
IF ! FOUND()
   GsMsgErr = "Operaci¢n de Compras no definida"
   DO LIB_MERR WITH 99
*!*	   CLOSE DATA
   RETURN
ENDIF
XsCodOp1 = CodOpe    && Actualmente [016]
SEEK XsCodOpe
IF ! FOUND()
   GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
   DO LIB_MERR WITH 99
*!*	   CLOSE DATA
   RETURN
ENDIF
SEEK XsCodOpe2
IF ! FOUND()
   GsMsgErr = "Operaci¢n "+XsCodOpe+" no registrada"
   DO LIB_MERR WITH 99
*!*	   CLOSE DATA
   RETURN
ENDIF
SEEK XsCodOpe2                         && APLICACI¢N CLIENTE PROVEEDOR

* * * *
MaxEle1  = 0
Crear    = .T.
Modificar= .T.
STORE "" TO XsNroAst,XsNotAst,XsNroVou,XsGloAst
STORE "" TO XsCtaCja,XfImpChq,XsNroChq,XsGirado,XsCodAux,YsCodAux
STORE 0  TO XfImpCh1,XfImpCh2,XfPorcen,XnCodMon,XfTpoCmb,nImpNac,nImpUsa
** Variables del Browse 1 **
DIMENSION vCodDoc(10)
DIMENSION vNroDoc(10)
DIMENSION vNroRef(10)
DIMENSION vNroAst(10)
DIMENSION vImport(10)
DIMENSION vNotAst(10)
DIMENSION vCodCt1(10)                        && Datos del Documento Original
DIMENSION vCodAu1(10)                        && Datos del Documento Original
DIMENSION vClfAu1(10)                        && Datos del Documento Original
DIMENSION vCodMon(10)                        && Datos del Documento Original
DIMENSION vTpoCmb(10)                        && Datos del Documento Original
DIMENSION vImpNAC(10)                        && Datos del Documento Original
DIMENSION vImpUSA(10)                        && Datos del Documento Original
STORE SPACE(LEN(RMOV->CodDoc)) TO vCodDoc
STORE SPACE(LEN(RMOV->NroDoc)) TO vNroDoc
STORE SPACE(LEN(RMOV->NroRef)) TO vNroRef
STORE SPACE(LEN(RMOV->NroAst)) TO vNroAst
STORE SPACE(LEN(RMOV->GloDoc)) TO vNotAst
STORE SPACE(LEN(RMOV->CodCta)) TO vCodCt1
STORE SPACE(LEN(RMOV->CodAux)) TO vCodAu1
STORE SPACE(LEN(RMOV->ClfAux)) TO vClfAu1
STORE 0 TO vImport,vCodMon,vImpNAC,vImpUSA,vTpoCmb

** Logica Principal **
*************************************************
** OJO >> Solo de va a permitir CREAR y ANULAR **
*************************************************
SELE VMOV
*SEEK XsNroMes+XsCodOpe2
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99
cLlave = XsNroMes+XsCodOpe2
DO F1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],'[xLista]',[NROMES+CODOPE],cLlave,'CAR'
CLEAR 
CLEAR MACROS
LoConTab.odatadm.close_file('CJA')
LoConTab.odatadm.close_file('CCB_CJA')
RELEASE LoContab 
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN


******************
PROCEDURE xLista
******************
SELE RMOV
SET ORDER TO RMOV01
SEEK VMOV->NroMes+VMOV->CodOPe+VMOV->NroAst
xFOR = []
xWHILE = [NroMes+CodOpe+NroAst=VMOV->NroMes+VMOV->CodOpe+VMOV->NroAst]
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "cjacjdeu"
SAVE SCREEN
DO admprint WITH "REPORTS"
REST SCREEN
RETURN


************************************************************************ EOP()
* Pintado de Pantalla
***************************************************************************
PROCEDURE xPanta

*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678
*1    Canje #      :                                     Fecha : 99/99/99
*2    Cod.Cliente  : 123456789012345678901234567890123
*3    Observaciones:
*4    Moneda       :                               Tipo Cambio : 99,999.9999
*5              ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6              ³ Doc. Nro.Documento       Saldo       Importe     ³
*7              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*8              ³ 1234  1234567890   999,999,999.99 999,999,999.99 ³
*9              ³                                                  ³
*0              ³                                                  ³
*1              ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*2                                                ³ 999,999,999.99 ³
*3                                                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*4      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*5      ³Asiento-A¤o      C o n c e p t o               Importe    ³
*6      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*7      ³ 123456-94  123456789012345678901234567890 999,999,999.99 ³
*8      ³                                                          ³
*9      ³                                                          ³
*0      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1                                                ³ 999,999,999.99 ³
*2                                                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678

CLEAR
Titulo = "** CANJE CLIENTE/PROVEEDOR **"
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "Canje #      :                                     Fecha :    "
@  2,5  SAY "Cod.Cliente  :                                                "
@  3,5  SAY "Observaciones:                                                "
@  4,5  SAY "Moneda       :                               Tipo Cambio :    "
@  5,5  SAY "          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,5  SAY "          ³ Doc. Nro.Documento       Saldo       Importe     ³"
@  7,5  SAY "          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  8,5  SAY "          ³                                                  ³"
@  9,5  SAY "          ³                                                  ³"
@ 10,5  SAY "          ³                                                  ³"
@ 11,5  SAY "          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 12,5  SAY "                                            ³                ³"
@ 13,5  SAY "                                            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 14,5  SAY "  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,5  SAY "  ³Asiento-A¤o      C o n c e p t o               Importe    ³"
@ 16,5  SAY "  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 17,5  SAY "  ³                                                          ³"
@ 18,5  SAY "  ³                                                          ³"
@ 19,5  SAY "  ³                                                          ³"
@ 20,5  SAY "  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,5  SAY "                                            ³                ³"
@ 22,5  SAY "                                            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@  6,16 SAY " Doc. Nro.Documento       Saldo       Importe     "         COLOR SCHEME 7
@ 15,8  SAY "Asiento-A¤o      C o n c e p t o               Importe    " COLOR SCHEME 7
RETURN

*-------------------------------------------------------------------------------
* Llave de Acceso
*-------------------------------------------------------------------------------
PROCEDURE xLlave
i = 1
XsNroAst = NROAST()
Crear = .T.
** Posicionamos en el ultimo registro + 1 **
SELECT VMOV
UltTecla = 0
DO LIB_MTEC WITH 2
DO WHILE ! INLIST(UltTecla,Enter,escape_)
   @ 1,20 GET XsNroAst PICT "999999"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = escape_
      EXIT
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsNroAst)
      IF !CBDBUSCA("VMOV")
         LOOP
      ENDIF
      XsNroAst = VMOV->NroAst
   ENDIF
   @ 1,20 SAY XsNroAst
ENDDO
SELECT VMOV
Llave = (XsNroMes+XsCodOpe2+XsNroAst)
SEEK Llave
RETURN

*-------------------------------------------------------------------------------
* Poner Datos en Pantalla
*-------------------------------------------------------------------------------
PROCEDURE xPoner
SELE VMOV
@ 1,20 SAY NroAst                      && datos de cabecera de movimiento
@ 1,64 SAY FchAst
@ 3,20 SAY NotAst
@ 4,20 SAY IIF(CodMon=1,'S/.','US$')
@ 4,64 SAY TpoCmb PICT "99,999.9999"

@  8,16 CLEAR TO 10,65               && uuuuu
@ 17,8  CLEAR TO 19,65
IF VMOV->FlgESt = "A"
   @ 7,21 SAY "  #   #   # #  # #      #   ####  #####"
   @ 8,21 SAY " # #  # # # #  # #     # #  #   # #   #"
   @ 9,21 SAY "##### # # # #  # #    ##### #   # #   #"
   @10,21 SAY "#   # #   # #### #### #   # ####  #####"
   RETURN
ENDIF
@7,15 SAY 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
Llave=NroMes+XsCodOpe2+NroAst
** Pintamos el Browse de Documentos origen **
NumEle = 8
SELE RMOV             && rrrrrr
SEEK Llave
@ 2,20 SAY CodAux
@ 2,30 SAY AUXI->NomAux
DO WHILE NroMes+CodOpe+NroAst=Llave .AND. NumEle <= 10
  IF CODCTA='12'
     @ NumEle,17 SAY CodDoc
     @ NumEle,23 SAY NroDoc
     *@ NumEle,36 SAY SdoDoc PICT "999,999,999.99"
     @ NumEle,51 SAY Import PICT "999,999,999.99"
     NumEle = NumEle + 1
  ENDIF
  SKIP
ENDDO

*** Pintamos el Browse de Proveedores **
SEEK Llave
NumEle = 17
DO WHILE NroMes+CodOpe+NroAst=Llave .AND. NumEle <= 19
  IF CODCTA='42'
     @ NumEle,9  SAY NroDoc
     @ NumEle,20 SAY SUBS(Glodoc,1,30)
     @ NumEle,51 SAY Import PICT "999,999,999.99"
     NumEle = NumEle + 1
  ENDIF
  SKIP
ENDDO

SELE VMOV
RETURN


*-------------------------------------------------------------------------------
* Editar Datos de Cabecera
*-------------------------------------------------------------------------------
PROCEDURE xTomar

** OJO >> Siempre es Crear **
SELE VMOV
M.Crear  = .T.
DO xInvar
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1
         @ 1,64 GET XdFchAst
         READ
         UltTecla = LASTKEY()
         @ 1,64 SAY XdFchAst
         XdFchCje=XdFchAst
      CASE i = 2
         SELE AUXI
         @ 2,20 GET XsCodAux PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("CLIE")
               LOOP
            ENDIF
            XsCodAux = AUXI->CodAux
         ENDIF
         @ 2,20 SAY XsCodAux
         SEEK XsClfAux+XsCodAux
         IF ! FOUND()
            GsMsgErr = [ Cliente no Registrado ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         @ 2,30 SAY AUXI->NomAux
         YsCodAux=XsCodAux

      CASE i = 3
         @ 3,20 EDIT XsNotAst SIZE 1,40
         READ
         UltTecla = LASTKEY()
         @ 3,20 EDIT XsNotAst SIZE 1,40 DISABLE

      CASE i = 4
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XnCodMon= Elige(XnCodMon,4,20,2)

      CASE i = 5
         @ 4,64 GET XfTpoCmb PICT "99,999.9999" VALID XfTpoCmb>0
         READ
         UltTecla = LASTKEY()
         @ 4,64 SAY XfTpoCmb PICT "99,999.9999"

      CASE i = 6
         DO DocBrows    && Browse de Documentos de Cargo

      CASE i = 7
         DO LetBrows    && Browse de Proveedores

   ENDCASE
   IF i = 7 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>7,7,i)
ENDDO
IF UltTecla # escape_
   DO xGraba
ENDIF
SELE VMOV
UNLOCK ALL
RETURN

*-------------------------------------------------------------------------------
* Inicializa valores de las variables
*-------------------------------------------------------------------------------
PROCEDURE xInvar

** Datos de cabecera de movimiento **
XsNroAst=SPACE(6)
XsCodAux=SPACE(5)
XsFchAst={  /  /  }
XsGloAst=SPACE(40)
XsCodMon=1
XsTpoCmb=2.00

** Variables de control de datos intermedios **
M.Import  = 0.00     && importe de documentos
M.Impdoc  = 0.00     && importe de letras (= importe del canje)
M.Crear   = .T.

** Datos del Browse de Documentos **
STORE SPACE(LEN(GDOC->coddoc)) TO AsCodRef
STORE SPACE(LEN(GDOC->codcta)) TO AsCtaRef
STORE SPACE(LEN(GDOC->nrodoc)) TO AsNroRef
STORE 0.00                     TO AfSdoDoc
STORE 0.00                     TO AfImport
STORE 0.00                     TO AfImptot
GiTotDoc = 0

** Datos del Browse de Proveedores ** ARCHIVO DE CONTABILIDAD VMOV, RMOV
STORE SPACE(LEN(RMOV->CodDoc)) TO vCodDoc
STORE SPACE(LEN(RMOV->NroDoc)) TO vNroDoc
STORE SPACE(LEN(RMOV->NroRef)) TO vNroRef
STORE SPACE(LEN(RMOV->NroAst)) TO vNroAst
STORE SPACE(LEN(RMOV->GloDoc)) TO vNotAst
STORE SPACE(LEN(RMOV->CodCta)) TO vCodCt1
STORE SPACE(LEN(RMOV->CodAux)) TO vCodAu1
STORE SPACE(LEN(RMOV->ClfAux)) TO vClfAu1
STORE 0 TO vImport,vCodMon,vImpNAC,vImpUSA,vTpoCmb
RETURN

************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE DocBrows

GiTotItm = GiTotDoc
**
EscLin   = "Docbline"
EdiLin   = "Docbedit"
BrrLin   = "Docbborr"
InsLin   = "Docbinse"
PrgFin   = []
*
Yo       = 7
Xo       = 15
Largo    = 5
Ancho    = 52
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
DO aBrowse
*
GiTotDoc = GiTotItm
*
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ENDIF
*
RETURN

************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE DocBLine
PARAMETERS NumEle, NumLin
@ NumLin,17 SAY AsCodRef(NumEle)
@ NumLin,22 SAY AsNroRef(NumEle)
@ NumLin,36 SAY AfSdoDoc(NumEle) PICT "999,999,999.99"
@ NumLin,51 SAY AfImport(NumEle) PICT "999,999,999.99"
RETURN

************************************************************************ FIN *
* Objeto : Edita una linea (edlin)
******************************************************************************
PROCEDURE DocBEdit
PARAMETERS NumEle, NumLin

i        = 1
UltTecla = 0
*
LsCodRef = AsCodRef(NumEle)
LsCtaRef = AsCtaRef(NumEle)
LsNroRef = AsNroRef(NumEle)
LfSdoDoc = AfSdoDoc(NumEle)
LfImport = AfImport(NumEle)
m.sdodoc = 0   && Control del saldo
DO WHILE !INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1
         SELE TDOC
         @ NumLin,17 GET LsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_)
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("TDOC")
               LOOP
            ENDIF
            LsCodRef = TDOC->CodDoc
         ENDIF
         @ NumLin,17 SAY LsCodRef
         SEEK LsCodRef
         IF !FOUND()
            GsMsgErr = [Documento no Existe]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF TpoDoc # "CARGO"
            GsMsgErr = "No es un documento de Cargo"
            DO lib_merr WITH 99
            LOOP
         ENDIF
         LsCtaRef=CodCta

      CASE i = 2
         SELE GDOC
         @ NumLin,22 GET LsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            PRIVATE XsCodCli,XsTpoRef,XsCodRef
            XsCodCli = XsCodAux
            XsTpoRef = "CARGO"
            XsCodRef = LsCodRef
            IF ! CCBBUSCA("ASIG")
               LOOP
            ENDIF
            LsNroRef = GDOC->NroDoc
         ENDIF
         @ NumLin,22 SAY LsNroRef
         SEEK XsCodAux+"P"+"CARGO"+LsCodRef+LsNroRef
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         ** verificamos que no se repita **
         PRIVATE j
         j = 1
         DO WHILE j <= GiTotItm
            IF j <> NumEle
               IF AsCodRef(j)+AsNroRef(j) = LsCodRef+LsNroRef
                  WAIT "Dato ya Registrado" NOWAIT WINDOW
                  LOOP
               ENDIF
            ENDIF
            j = j + 1
         ENDDO
         IF !RLOCK()
            LOOP
         ENDIF
         LfImport = GDOC->SdoDoc
         IF GDOC->CodMon # XnCodMon
            IF GDOC->CodMon = 1
               LfImport = LfImport/Xftpocmb
            ELSE
               LfImport = LfImport*Xftpocmb
            ENDIF
         ENDIF
         LfSdoDoc = LfImport
         @ NumLin,36 SAY LfSdoDoc PICT "999,999,999.99"

      CASE i = 3
         @ NumLin,51 GET LfImport PICT "999,999,999.99" VALID LfImport>0 .AND. LfImport <= LfSdoDoc
         READ
         @ NumLin,51 SAY LfImport PICT "999,999,999.99"
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 3 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>3,3,i)
ENDDO
IF UltTecla # escape_
   AsCodRef(NumEle) = LsCodRef  &&   ** FACTURA COMO CLIENTE **
   AsCtaRef(NumEle) = LsCtaRef
   AsNroRef(NumEle) = LsNroRef
   AfSdoDoc(NumEle) = LfSdoDoc
   AfImport(NumEle) = LfImport
   DO DocRegen
ELSE
   UNLOCK IN GDOC
ENDIF
RETURN

************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE DocRegen

PRIVATE j
j = 1
STORE 0 TO m.import
DO WHILE j <= GiTotItm
   M.Import = M.Import + AfImport(j)
   j = j + 1
ENDDO
@ 12,49 SAY M.Import PICT "999,999,999.99"
RETURN

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE DocbBorr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1

DO WHILE i <  GiTotItm
   AsCodRef(i) = AsCodRef(i+1)
   AsNroRef(i) = AsNroRef(i+1)
   AfSdoDoc(i) = AfSdoDoc(i+1)
   AfImport(i) = AfImport(i+1)
   i = i + 1
ENDDO
AsCodRef(i) = SPACE(LEN(GDOC->coddoc))
AsNroRef(i) = SPACE(LEN(GDOC->nrodoc))
AfSdoDoc(i) = 0.00
AfImport(i) = 0.00
GiTotItm = GiTotItm - 1
Estado = .T.
DO DocRegen    && recalcula importe
RETURN
************************************************************************ FIN *
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE DocbInse

PARAMETERS ElePrv, Estado
PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsCodRef(i) = AsCodRef(i-1)
   AsNroRef(i) = AsNroRef(i-1)
   AfSdoDoc(i) = AfSdoDoc(i-1)
   AfImport(i) = AfImport(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
AsCodRef(i) = SPACE(LEN(GDOC->coddoc))
AsNroRef(i) = SPACE(LEN(GDOC->nrodoc))
AfSdoDoc(i) = 0.00
AfImport(i) = 0.00
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN


************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE LetBrows
**
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,TotEle
EscLin   = "GENbline"
EdiLin   = "GENbedit"
BrrLin   = "GENbborr"
InsLin   = "GENbinse"
Yo       = 16
Largo    = 5
Ancho    = 55
Xo       = INT((80 - Ancho)/2)
Tborde   = Nulo
Titulo   = ""
En1      = ""
En2      = ""
En3      = ""
MaxEle   = MaxEle1
TotEle   = 10     && M ximos elementos a usar
*
DO WHILE .T.
   DO aBrowse
   IF INLIST(UltTecla,escape_) .OR. (m.ImpDoc = m.Import)
      EXIT
   ELSE
      GsMsgErr = [ Los montos deben ser exactos ]
      DO lib_merr WITH 99
   ENDIF
ENDDO
*
GiTotLet = GiTotItm
*
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN

************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE LetRegen
PRIVATE j
j = 1
STORE 0 TO m.impdoc
*DO WHILE j <= GiTotItm
DO WHILE j <= MaxEle
   m.impdoc = m.impdoc + vImport(j)
   j = j + 1
ENDDO
@ 21,51 SAY M.Impdoc PICT "999,999,999.99"
RETURN

********************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin

*          1         2         3         4
*012345678901234567890123456789012345678901234567890123456789012345678901234567890
*   +ASIENTO-A¥O        CONCEPTO              IMPORTE     COD.ESTAD.         +
*     123456789 12345678901234567890123456 999,999,999.99 12345 1234567890123
@ NumLin,9     SAY vNroDoc(NumEle)
@ NumLin,20    SAY vNotAst(NumEle) PICT "@S30"
@ NumLin,51    SAY vImport(NumEle) PICT "999,999,999.99"

RETURN

************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedit
PARAMETERS NumEle, NumLin, LiUtecla

LsCoddoc = vCodDoc(NumEle)  &&  ** FACTURAS COMO PROVEEDOR
LsNroDoc = vNroDoc(NumEle)
LsNroRef = vNroRef(NumEle)
LsNroAst = vNroAst(NumEle)
LsNotAst = vNotAst(NumEle)
LsCodCta = vCodCt1(NumEle)
LsCodAux = vCodAu1(NumEle)
LsClfAux = vClfAu1(NumEle)
LfImport = vImport(NumEle)
LiCodMon = vCodMon(NumEle)
LfTpoCmb = vTpoCmb(NumEle)
LfImpNAC = vImpNAC(NumEle)
LfImpUSA = vImpUSA(NumEle)
UltTecla = 0
i = 1
DO WHILE  .NOT. INLIST(UltTecla,escape_,Arriba)
   DO CASE
      CASE i = 1
         @ NumLin,9  GET LsNroDoc PICT "999999-99"
         READ
         UltTecla = LASTKEY()
         IF ULTTECLA = Arriba
            EXIT
         ENDIF
         IF ULTTECLA = escape_
            EXIT
         ENDIF
         IF MaxEle = 1 .AND. EMPTY(LsNroDoc)
            UltTecla = CtrlW
            EXIT
         ENDIF
         IF ! CHKNROAST()
            LOOP
         ENDIF
         @ NumLin,9  SAY LsNroDoc PICT "999999-99"
         @ NumLin,20 SAY LsNotAst PICT "@S30"
         @ NumLin,51 SAY LfImport PICT "999,999,999.99"

      CASE i = 2
      ** Agregar glosa
         @ NumLin,20 GET LsNotAst PICT "@S30"
         READ
         @ NumLin,20 SAY LsNotAst PICT "@S30"

      CASE i = 3
         @ NumLin,51 GET LfImport PICT "999,999,999.99"
         READ
         UltTecla = LASTKEY()
         @ NumLin,51 SAY LfImport PICT "999,999,999.99"

      CASE i = 4
         IF UltTecla = Enter
            EXIT
         ENDIF
         IF INLIST(UltTecla,F10,CTRLw)
            UltTecla = CtrlW
            EXIT
         ENDIF
         i = 1
   ENDCASE
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF( i > 4 , 4, i)
   i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla <> escape_
   vNroAst(NumEle) = LsNroAst
   vCodDoc(NumEle) = LsCodDoc
   vNroDoc(NumEle) = LsNroDoc
   vNroRef(NumEle) = LsNroRef
   vNroAst(NumEle) = LsNroAst
   vNotAst(NumEle) = LsNotAst
   vCodCt1(NumEle) = LsCodCta
   vCodAu1(NumEle) = LsCodAux
   vClfAu1(NumEle) = LsClfAux
   vImport(NumEle) = LfImport
   vCodMon(NumEle) = LiCodMon
   vTpoCmb(NumEle) = LfTpoCmb
   vImpNAC(NumEle) = LfImpNAC
   vImpUSA(NumEle) = LfImpUSA
   DO LetRegen
ENDIF
XfImpCh1 = 0
FOR ii = 1 to MaxEle
    XfImpCh1 = XfImpCh1 + vImport(ii)
ENDFOR
XfImpChq = XfImpCh1 + XfImpCh2
*@ 21 ,51 SAY XfImpChq PICT "999,999,999.99"
LiUTecla = UltTecla
RETURN
************************************************************************ FIN *
* Objeto : Chequeando la existencia de la provisi¢n
*******************
PROCEDURE CHKNROAST
*******************
** Ahora Verificamos con el a¤o **
LsNroMes = LEFT(LsNroDoc,2)
LsAno    = SUBST(LsNroDoc,8,2)
SELECT VMOV
LsNroAst = LEFT(LsNroDoc,6)
*IF LsAno # RIGHT(STR(YEAR(XdFchAst),4),2)
*   LLAVE =  "00"+"011"+"000001"
*ELSE
    LLAVE =  LsNroMes+XsCodOp1+LsNroAst    && Facturas Proveedores
*ENDIF
SEEK LLAVE
IF ! FOUND()
   GsMsgErr = "Comprobante de provisi¢n no existe"
   DO LIB_MERR WITH 99
   RETURN .F.
ENDIF
LsNotAst = NotAst
LiCodMon = CodMon
XdFchAst = FchAst

LfImport = 0
** Determinamos SALDO del documento **
LLAVE = NroMes+CodOpe+NroAst
SELECT RMOV
SEEK LLAVE

DO WHILE NROMES+CODOPE+NROAST = LLAVE .AND. ! EOF()
   DO CALIMP
   DO CASE
      CASE LsAno # RIGHT(STR(YEAR(XdFchAst),4),2) .AND. CodCta = "421" .AND. NroDoc = LsNroDoc .AND. TpoMov = [H]
         =SEEK(CODCTA,"CTAS")
         IF XnCodMon = LiCodMon
            IF XnCodMon = 1
               LfImport = LfImport + nImpNac
            ELSE
               LfImport = LfImport + nImpUsa
            ENDIF
         ELSE
            IF XnCodMon = 1
               LfImport = LfImport + ROUND(nImpUsa*XfTpoCmb,2)
            ELSE
               LfImport = LfImport + ROUND(nImport/XfTpoCmb,2)
            ENDIF
         ENDIF
         LsCodCta = RMOV->CodCta
         LsClfAux = RMOV->ClfAux
         LsCodAux = RMOV->CodAux
      CASE CodCta = "421" .AND. LsAno = RIGHT(STR(YEAR(XdFchAst),4),2)
         =SEEK(CODCTA,"CTAS")
         IF XnCodMon = CodMon
            IF XnCodMon = 1
               LfImport = LfImport + nImpNac
            ELSE
               LfImport = LfImport + nImpUsa
            ENDIF
         ELSE
            IF XnCodMon = 1
               LfImport = LfImport + ROUND(nImpUsa*XfTpoCmb,2)
            ELSE
               LfImport = LfImport + ROUND(nImpNac/XfTpoCmb,2)
            ENDIF
         ENDIF
         LsCodCta = RMOV->CodCta
         LsClfAux = RMOV->ClfAux
         LsCodAux = RMOV->CodAux
   ENDCASE
   SKIP
ENDDO
IF LfImport <= 0
   GsMsgErr = "Comprobante no tiene movimiento en cuenta 421"
   DO LIB_MERR WITH 99
   RETURN .F.
ENDIF
** Buscamos si tiene Saldo **
SET ORDER TO RMOV06
LsLlave = LsCodCta+LsCodAux+LsNroDoc
SEEK LsLlave
STORE 0 TO LfSdoNAC,LfSdoUSA
LsCodDoc = CodDoc
LsNroRef = NroRef
LsCodAux = CodAux
LsClfAux = ClfAux
LiCodMon = CodMon
LfTpoCmb = TpoCmb
LfImpUSA = ImpUSA
LfImpNAC = Import
SCAN WHILE CodCta+CodAux+NroDoc = LsLlave
   LfSdoNAC = LfSdoNAC + IIF(TpoMov=[H],Import,-1*Import)
   LfSdoUSA = LfSdoUSA + IIF(TpoMov=[H],ImpUSA,-1*ImpUSA)
ENDSCAN
SET ORDER TO RMOV01
*IF LfSdoNAC <= 0 .OR. LfSdoUSA <= 0
*   GsMsgErr = [Documento ya esta cancelado]
*   DO lib_merr WITH 99
*   RETURN .F.
*ENDIF
IF XnCodMon = 1
   LfImport = LfSdoNAC
ELSE
   LfImport = LfSdoUSA
ENDIF
IF XnCodMon = LiCodMon
   IF XnCodMon = 1
      LfImport = LfSdoNAC
   ELSE
      LfImport = LfSdoUSA
   ENDIF
ELSE
   IF XnCodMon = 1
      LfImport = LfSdoUSA*XfTpoCmb
   ELSE
      LfImport = LfSdoNAC/XfTpoCmb
   ENDIF
ENDIF
SELECT VMOV
SET ORDER TO VMOV01
RETURN .T.

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbborr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   vCodDoc(i) = vCodDoc(i+1)
   vNroDoc(i) = vNroDoc(i+1)
   vNroRef(i) = vNroRef(i+1)
   vNroAst(i) = vNroAst(i+1)
   vImport(i) = vImport(i+1)
   vNotAst(i) = vNotAst(i+1)
   vCodCt1(i) = vCodCt1(i+1)
   vCodAu1(i) = vCodAu1(i+1)
   vCodMon(i) = vCodMon(i+1)
   vTpoCmb(i) = vTpoCmb(i+1)
   vImpNAC(i) = vImpNAC(i+1)
   vImpUSA(i) = vImpUSA(i+1)
   i = i + 1
ENDDO
STORE SPACE(LEN(RMOV->CodDoc)) TO vCodDoc(i)
STORE SPACE(LEN(RMOV->NroDoc)) TO vNroDoc(i)
STORE SPACE(LEN(RMOV->NroRef)) TO vNroRef(i)
STORE SPACE(LEN(RMOV->NroAst)) TO vNroAst(i)
STORE SPACE(LEN(RMOV->GloDoc)) TO vNotAst(i)
STORE SPACE(LEN(RMOV->CodCta)) TO vCodCt1(i)
STORE SPACE(LEN(RMOV->CodAux)) TO vCodAu1(i)
STORE SPACE(LEN(RMOV->ClfAux)) TO vClfAu1(i)
STORE 0 TO vImport(i),vCodMon(i),vImpNAC(i),vImpUSA(i),vTpoCmb(i)
Estado = .T.
DO LetRegen
RETURN

******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbinse
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   vCodDoc(i) = vCodDoc(i-1)
   vNroDoc(i) = vNroDoc(i-1)
   vNroRef(i) = vNroRef(i-1)
   vNroAst(i) = vNroAst(i-1)
   vImport(i) = vImport(i-1)
   vNotAst(i) = vNotAst(i-1)
   vCodCt1(i) = vCodCt1(i-1)
   vCodAu1(i) = vCodAu1(i-1)
   vClfAu1(i) = vClfAu1(i-1)
   vCodMon(i) = vCodMon(i-1)
   vTpoCmb(i) = vTpoCmb(i-1)
   vImpNAC(i) = vImpNAC(i-1)
   vImpUSA(i) = vImpUSA(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(RMOV->CodDoc)) TO vCodDoc(i)
STORE SPACE(LEN(RMOV->NroDoc)) TO vNroDoc(i)
STORE SPACE(LEN(RMOV->NroRef)) TO vNroRef(i)
STORE SPACE(LEN(RMOV->NroAst)) TO vNroAst(i)
STORE SPACE(LEN(RMOV->GloDoc)) TO vNotAst(i)
STORE SPACE(LEN(RMOV->CodCta)) TO vCodCt1(i)
STORE SPACE(LEN(RMOV->CodAux)) TO vCodAu1(i)
STORE SPACE(LEN(RMOV->ClfAux)) TO vClfAu1(i)
STORE 0 TO vImport(i),vCodMon(i),vImpNAC(i),vImpUSA(i),vTpoCmb(i)
Estado = .T.
DO LetRegen
RETURN

**********************************************************************
* Procedimiento de Grabaci¢n de informaci¢n
**********************************************************************
PROCEDURE xGraba

** PREGUNTAR GRABACION **
cResp = [S]
cResp = Aviso(12,[ Datos Correctos (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
IF cResp = "N"
   RETURN
ENDIF
WAIT "GRABANDO" NOWAIT WINDOW

** GRABAMOS CABECERA **
SELECT SLDO
SEEK XsCodAux
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TDOC
SEEK M.CodDoc
IF !RLOCK()
   RETURN
ENDIF

UNLOCK
**

** GENERAMOS DETALLES **
** ACTUALIZA DOCUMENTOS DE ORIGEN **
j = 1
FOR j = 1 TO GiTotDoc
   ** ACTUALIZA NRO DE DOCUMENTO **
   SELECT TDOC
   IF VAL(m.nrodoc)>= NroDoc
      REPLACE NroDoc WITH VAL(m.nrodoc)+1
   ENDIF
   Do CjLActDoc WITH AsCodRef(j),AsNroRef(j),AfImport(j)
   M.NroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(m.NroDoc))
   j = j + 1
ENDFOR

** GENERAMOS ASIENTO CONTABLE **
DO MOVGraba
UltTecla = escape_
RETURN

************************************************************************** FIN
* Cancelando Documentos
***************************************************************************
PROCEDURE CjLActDoc
PARAMETER cCodDoc,cNroDoc,nImpTot
PRIVATE LfImpDoc
XsGlodoc=[GENERACION AUTOMATICA APLIC.CLIE.PROV.]
SELECT GDOC
SEEK XsCodAux+"P"+"CARGO"+cCodDoc+cNroDoc
IF !RLOCK()
   RETURN
ENDIF
SELECT VTOS
APPEND BLANK
IF ! RLOCK()
   RETURN
ENDIF
** actualizamos documento origen **
SELECT GDOC
LfImpDoc = nImpTot
IF CodMon <> XnCodMon
   IF XnCodMon = 1
      LfImpDoc = nImpTot / Xftpocmb
   ELSE
      LfImpDoc = nImpTot * Xftpocmb
   ENDIF
ENDIF
REPLACE SdoDoc WITH SdoDoc - LfImpDoc
IF SdoDoc <= 0.01
   REPLACE FlgEst WITH 'C'
   REPLACE FchAct WITH m.fchdoc
ELSE
   REPLACE FlgEst WITH 'P'
ENDIF
REPLACE FchAct WITH DATE()
REPLACE FlgSit WITH 'X'
UNLOCK
** actualizamos saldo del cliente **
SELECT SLDO
IF GDOC->CodMon = 2
   REPLACE CgoUSA WITH CgoUSA - LfImpDoc
ELSE
   REPLACE CgoNAC WITH CgoNAC - LfImpDoc
ENDIF
**** Actualiza el movimiento realizado ****
SELECT VTOS
REPLACE CodDoc WITH M.coddoc
REPLACE NroDoc WITH M.nrodoc
REPLACE TpoDoc WITH "Canje"
REPLACE FchDoc WITH M.fchdoc
REPLACE CodCli WITH XsCodAux
REPLACE CodMon WITH XnCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE TpoRef WITH [CARGO]
REPLACE CodRef WITH cCodDoc
REPLACE NroRef WITH cNroDoc
*REPLACE Import WITH nImpTot
REPLACE Import WITH m.ImpDoc
REPLACE GloDoc WITH XsGloDoc
UNLOCK
RETURN
******* EOF()

************************************************************************** FIN
* Procedimiento de Grabar las variables de cabecera    CONT*
******************************************************************************
PROCEDURE MOVGraba

** Solo es Crear **

XsGloAst = [GENERACION AUTOMATICA APLIC.CLIE.PROV.]
XsCtaCja = []
XsNroChq = []
XsGirado = []
XfImpChq = 0

DO LIB_MSGS WITH 3
SELECT VMOV
UltTecla = 0
LLAVE = (XsNroMes + XsCodOpe2 + XsNroAst)

** BUSCAMOS ORIGEN 070 **
SEEK XsCodOpe2
SELE OPER
IF ! Rec_Lock(5)
   RETURN              && No pudo bloquear registro
ENDIF
SELECT VMOV
SEEK LLAVE
IF FOUND()
   OldNro=XsNroAst
   XsNroAst = NROAST()
   XsNroAst=OldNro
   LLAVE = (XsNroMes + XsCodOpe2 + XsNroAst)
   SEEK LLAVE
   IF FOUND()
      DO LIB_MERR WITH 11
      RETURN
   ENDIF
ENDIF
APPEND BLANK
IF ! Rec_Lock(5)
   RETURN              && No pudo bloquear registro
ENDIF

** GRABA EN VMOV **
REPLACE VMOV->NROMES WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe2
REPLACE VMOV->NroAst WITH XsNroAst
SELECT OPER
=NROAST(XsNroAst)
SELECT VMOV
REPLACE VMOV->FchAst  WITH XdFchCje && ojo
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XnCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->GloAst  WITH XsGloAst
REPLACE VMOV->CtaCja  WITH XsCtaCja
REPLACE VMOV->NroChq  WITH XsNroChq
REPLACE VMOV->Girado  WITH XsGirado
REPLACE VMOV->ImpChq  WITH XfImpChq
REPLACE VMOV->Digita  WITH GsUsuario
REPLACE VMOV->FLGEST  WITH "R"
REPLACE VMOV->ChkCta  WITH 0
REPLACE VMOV->DbeNac  WITH 0
REPLACE VMOV->DbeUsa  WITH 0
REPLACE VMOV->HbeNac  WITH 0
REPLACE VMOV->HbeUsa  WITH 0

*****************************************
**** Actualizando movimientos en RMOV **
*****************************************
** Grabar en el orden de la generacion **
XiNroItm = 1
*FOR j = 1 TO MaxEle1
FOR j = 1 TO GiTotLet                          &&  vNroAst(NumEle) = LsNroAst
   XsCodCta = vCodCt1(j)     && CTAS 42        &&  vCodDoc(NumEle) = LsCodDoc
   XsCodOpe = '070'                            &&  vNroDoc(NumEle) = LsNroDoc
   XsCodRef = ''                               &&  vNroRef(NumEle) = LsNroRef
   XsNroRef = vNroRef(j)                       &&  vNroAst(NumEle) = LsNroAst
   XsClfAux = vClfAu1(j)                       &&  vNotAst(NumEle) = LsNotAst
   XsCodAux = vCodAu1(j)                       &&  vCodCt1(NumEle) = LsCodCta
   XcTpoMov = [D]                              &&  vCodAu1(NumEle) = LsCodAux
   IF XnCodMon = 1                             &&  vClfAu1(NumEle) = LsClfAux
      XfImport = vImport(j)                    &&  vImport(NumEle) = LfImport
      XfImpUsa = vImport(j)/XfTpoCmb           &&  vCodMon(NumEle) = LiCodMon
   ELSE                                        &&  vTpoCmb(NumEle) = LfTpoCmb
      XfImpUsa = vImport(j)                    &&  vImpNAC(NumEle) = LfImpNAC
      XfImport = vImport(j)*XfTpoCmb           &&  vImpUSA(NumEle) = LfImpUSA
   ENDIF
   XsGloDoc = vNotAst(j)
   *XsCodDoc = vCodDoc(j)
*  XsCodDoc = M.CodDoc
   XsCodDoc = ''
*  XsNroDoc = M.NroDoc
   XsNroDoc = vNroAst(j)
   XcEliItm = []
   XsCodAdd = []
   XdFchDoc = XdFchAst
   XdFchAst = XdFchCje
   XdFchVto = {}
   DO MovbVeri
ENDFOR

*XiNroItm = 1
**** Actualizando Cta de Facturas ****  CTAS 12
FOR j = 1 TO GiTotDoc
* =SEEK(AsCodRef(j),"TDOC")
*  XsCodCta = TDOC->CodCta
*  =SEEK(XsCodCta,"CTAS")
   XsCodCta = AsCtaRef(j)
   XsCodRef = []
   XsNroRef = []
   XsClfAux = CTAS->ClfAux
   XsCodAux = YsCodAux
   XcTpoMov = [H]
   IF XnCodMon = 1
      XfImport = AfImport(j)
      XfImpUsa = AfImport(j)/XfTpoCmb
   ELSE
      XfImpUsa = AfImport(j)
      XfImport = AfImport(j)*XfTpoCmb
   ENDIF
   XsCodOpe = [070]
   XsGloDoc = [GENERACION AUTOMATICA CLIE.PROV.]
   XsCodDoc = AsCodRef(j)
   XsNroDoc = AsNroRef(j)
   XcEliItm = []
   XsCodAdd = []
*  XdFchDoc = XdFchAst
   XdFchVto = {}
   DO MovbVeri
ENDFOR
*SELE VMOV
*PUNTERO=RECNO()

*** GRABA CTA 42 EN ASIENTO DE ORIGEN 16 **
*
*XsNroDoc = XsNroAst
*FOR j = 1 TO GiTotLet
*   SELE VMOV
*   SEEK XsNroMes+'016'+SUBS(vNroDoc(j),1,6)
*   XiNroItm = NROITM+1
*
*   XsNroAst = vNroDoc(j)
*   XsCodCta = vCodCt1(j)     && CTAS 42
*   XsCodOpe = '016'
*   XsCodRef = ''
*   XsNroRef = vNroRef(j)
*   XsClfAux = vClfAu1(j)
*   XsCodAux = vCodAu1(j)
*   XcTpoMov = [D]
*   IF XnCodMon = 1
*      XfImport = vImport(j)
*      XfImpUsa = vImport(j)/XfTpoCmb
*   ELSE
*      XfImpUsa = vImport(j)
*      XfImport = vImport(j)*XfTpoCmb
*   ENDIF
*   XsGloDoc = vNotAst(j)
**  XsCodDoc = vCodDoc(j)
**  XsNroDoc = vNroDoc(j)
*   XsCodDoc = 'C/D'
*   XcEliItm = []
*   XsCodAdd = []
*   XdFchDoc = XdFchAst
*   XdFchVto = {}
*   DO MovbVeri
*ENDFOR
******* EOF()
SELE VMOV
*GO PUNTERO
RETURN

******************************************************************************
* Objeto : Verificar si debe generar cuentas autom ticas
******************************************************************************
PROCEDURE MovbVeri
**** Grabando la linea activa ****
*XcEliItm = " "
DO MOVbGrab
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
XcEliItm = "ú"
TsClfAux = "04 "
TsCodAux = CTAS->TpoGto
TsAn1Cta = RMOV->CodAux
TsCC1Cta = CTAS->CC1Cta
  ** Verificamos su existencia **
IF ! SEEK(TsAn1Cta,"CTAS")
   RETURN
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   RETURN
ENDIF
*****
XiNroItm = XiNroItm + 1
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbGrab
** Grabando la segunda cuenta autom tica **
XiNroItm = XiNroItm + 1
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO MOVbGrab
RETURN

*******************************************************************************
* Objeto : Grabar los registros
*******************************************************************************
PROCEDURE MOVbgrab
SELE RMOV
APPEND BLANK
IF ! Rec_Lock(5)
   RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
   ENDIF
ENDIF

REPLACE RMOV->NroMes WITH XsNroMes
REPLACE RMOV->CodOpe WITH XsCodOpe
REPLACE RMOV->NroAst WITH XsNroAst
REPLACE RMOV->NroItm WITH XiNroItm
REPLACE VMOV->NroItm WITH VMOV->NroItm + 1

REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH XdFchAst
REPLACE RMOV->NroVou WITH XsNroVou
REPLACE RMOV->CodMon WITH XnCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->Import WITH XfImport
REPLACE RMOV->ImpUsa WITH XfImpUsa
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ELSE  && EXTRA CONTABLE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ENDIF
SELECT RMOV
nImpNac = Import
nImpUsa = ImpUsa
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
********************************************************************************


*-------------------------------------------------------------------------------
* CALCULO DE IMPORTES
*-------------------------------------------------------------------------------
PROCEDURE CalImp
****************
nImpNac = Import
nImpUsa = ImpUsa
RETURN

*-------------------------------------------------------------------------------
* Borrando Informacion
*-------------------------------------------------------------------------------
PROCEDURE xBorrar
*****************
IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   DO LIB_MERR WITH 99
   RETURN              && No pudo bloquear registro
ENDIF
XsNroMes = VMOV->NroMes
XsCodOpe2= VMOV->CodOpe
XsNroAst = VMOV->NroAst
DO LIB_MSGS WITH 10
Llave = (XsNroMes + XsCodOpe2 + XsNroAst )

** BORRAR GDOC Y VTOS **
DO MOVDEL

SELECT RMOV
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
   Llave = (NroMes + XsCodOpe2 + NroAst )
   IF Rlock()
      SELECT RMOV
      IF EliItm = "@"
         REPLACE IMPORT WITH 0
         REPLACE IMPUSA WITH 0
         REPLACE GLODOC WITH "**** ANULADO ***"
      ELSE
         ** desactualiza control de documentos **
         IF RMOV->CodCta = [421]
            SELE DPRO
            SEEK RMOV->CodAux+RMOV->CodDoc+RMOV->NroRef
            IF REC_LOCK(5)
               IF CodMon = 1
                  REPLACE SdoDoc WITH SdoDoc + RMOV->Import
               ELSE
                  REPLACE SdoDoc WITH SdoDoc + RMOV->ImpUSA
               ENDIF
               IF SdoDoc >= 0
                  REPLACE FlgEst WITH [P]
                  REPLACE FchCan WITH {}
               ENDIF
               UNLOCK
            ENDIF
         ENDIF
         ****************************************
         SELE RMOV
         DELETE
      ENDIF
      UNLOCK
   ELSE
      ok = .f.
   ENDIF
   SKIP
ENDDO
* * * *
*DO xDEL_ESTD
* * * *
SELECT VMOV
REPLACE IMPCHQ WITH 0
REPLACE DBENAC WITH 0
REPLACE HBENAC WITH 0
REPLACE DBEUSA WITH 0
REPLACE HBEUSA WITH 0
IF Ok
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
   DELETE
ENDIF
UNLOCK ALL
RETURN
*********************************************************************** FIN() *

*-------------------------------------------------------------------------------
* EXTORNA SALDO DE DOCUMENTOS
*-------------------------------------------------------------------------------
PROCEDURE MOVDEL

M.ImpInt  = 0.00

SELE RMOV
SEEK LLAVE
DO WHILE NroMes+CodOpe+NroAst=Llave .AND. .NOT. EOF()
  IF CODCTA='12'
    XsCodAux=CodAux
    XsCodDoc=CodDoc
    XsNroDoc=NroDoc
    XnImport=Import
    SELE GDOC
    SEEK XsCodAux+'P'+'Cargo'+XsCodDoc+XsNroDoc
    XnSaldo=SdoDoc+XnImport
    REPLACE SDODOC WITH XnSaldo
  ENDIF
  SELE RMOV
  M.ImpInt  = M.ImpInt + Import
  SKIP
ENDDO
SELE RMOV
SEEK LLAVE

DO WHILE NroMes+CodOpe+NroAst=Llave .AND. .NOT. EOF()
  IF CODCTA='42'
    XsCodAux=CodAux
    XsCodDoc=CodDoc
    XsNroDoc=NroDoc
    SELE VTOS
    SEEK XsCodDoc+XsNroDoc
    DELE
    EXIT
  ENDIF
  SELE RMOV
  SKIP
ENDDO

SELE SLDO              && XXXXXXXXX
SEEK XsCodAux
IF VMOV->CodMon = 2
   REPLACE CgoUSA WITH CgoUSA - M.ImpInt
ELSE
   REPLACE CgoNAC WITH CgoNAC - M.ImpInt
ENDIF
RETURN


****************
FUNCTION NROAST
****************
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
RETURN  RIGHT("000000" + LTRIM(STR(iNroDoc)), 6)









************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra

IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   DO LIB_MERR WITH 99
   RETURN              && No pudo bloquear registro
ENDIF
XsNroMes = VMOV->NroMes
XsCodOpe = VMOV->CodOpe
XsNroAst = VMOV->NroAst
DO LIB_MSGS WITH 10
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
   Llave = (NroMes + CodOpe + NroAst )
   IF Rlock()
      SELECT RMOV
      IF EliItm = "@"
         REPLACE IMPORT WITH 0
         REPLACE IMPUSA WITH 0
         REPLACE GLODOC WITH "**** ANULADO ***"
      ELSE
         ** desactualiza control de documentos **
         IF LEFT(RMOV->CodCta,3) = [421]
            SELE DPRO
            SEEK RMOV->CodAux+RMOV->CodDoc+RMOV->NroRef
            IF REC_LOCK(5)
               IF CodMon = 1
                  REPLACE SdoDoc WITH SdoDoc + RMOV->Import
               ELSE
                  REPLACE SdoDoc WITH SdoDoc + RMOV->ImpUSA
               ENDIF
               IF SdoDoc >= 0
                  REPLACE FlgEst WITH [P]
                  REPLACE FchCan WITH {}
               ENDIF
               UNLOCK
            ENDIF
         ENDIF
         ****************************************
         SELE RMOV
         DELETE
      ENDIF
      UNLOCK
   ELSE
      ok = .f.
   ENDIF
   SKIP
ENDDO
* * * *
DO xDEL_ESTD
* * * *
SELECT VMOV
REPLACE IMPCHQ WITH 0
REPLACE DBENAC WITH 0
REPLACE HBENAC WITH 0
REPLACE DBEUSA WITH 0
REPLACE HBEUSA WITH 0
IF Ok
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
IF UltTecla = F1
   DELETE
ENDIF
UNLOCK ALL
RETURN

*-------------------------------------------------------------------------------
* Objeto : Extornar estadisticas
*-------------------------------------------------------------------------------
PROCEDURE xDEL_ESTD
SELE VTOS
LsLlave = [C/D ]+VMOV->NroAst+[-]+RIGHT(DTOC(VMOV->FchAst),2)
SEEK LsLlave
DO WHILE !EOF() .AND. CodDoc+NroDoc = LsLlave
   IF !RLOCK()
      LOOP
   ENDIF
   DELETE
   UNLOCK
   SKIP
ENDDO

LsLlave = [I/CH]+VMOV->NroAst+[-]+RIGHT(DTOC(VMOV->FchAst),2)
SEEK LsLlave
DO WHILE !EOF() .AND. CodDoc+NroDoc = LsLlave
   IF !RLOCK()
      LOOP
   ENDIF
   DELETE
   UNLOCK
   SKIP
ENDDO
RETURN


**************************** (ANULADO) Tacho
* BUSCAMOS CORRELATIVO
*IF ! SEEK(M.CODDOC,"TDOC")
*  WAIT "No existe correlativo" NOWAIT WINDOW
*  UltTecla = escape_
*  RETURN
*ENDIF
*m.NroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(m.NroDoc))
*
M.Crear  = .T.
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,escape_,Enter)
   DO CASE
      CASE i = 1
         @ 1,20 GET m.NroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            xCodDoc = m.CodDoc
            IF !ccbbusca("0002")
               LOOP
            ENDIF
            m.NroDoc = vtos->NroDoc
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
SEEK m.CodDoc+m.Nrodoc
RETURN

*************** basura
** Pintamos el Browse de Documentos origen **
SELE GDOC
SET ORDER TO GDOC01
SEEK VTOS->TpoRef+VTOS->CodRef+VTOS->NroRef
NumEle = 8
@ 8,16 CLEAR TO 10,65
SCAN WHILE CodDoc+NroDoc = VTOS->CodRef+VTOS->NroRef  .AND. NumEle <= 10
   @ NumEle,17 SAY CodDoc
   @ NumEle,23 SAY NroDoc
   @ NumEle,36 SAY SdoDoc PICT "999,999,999.99"
   @ NumEle,51 SAY ImpTot PICT "999,999,999.99"
  NumEle = NumEle + 1
ENDSCAN
SET ORDER TO GDOC04
*** Pintamos el Browse de Proveedores **
*SELE GDOC
*SEEK TASG->CodDoc+TASG->NroDoc
*NumEle = 17
*@ 17,8 CLEAR TO 19,65
*SCAN WHILE CodDoc+NroDoc = TASG->CodDoc+TASG->NroDoc .AND. NumEle <= 19
*   @ NumEle,9  SAY NroRef
*   @ NumEle,20 EDIT GloDoc SIZE 1,30 DISABLE
*   @ NumEle,51 SAY Import PICT "999,999,999.99
*   NumLin = NumLin + 1
*ENDSCAN
*SELE TASG
*@ 12,51 SAY ImpDoc PICT "999,999,999.99"
*RETURN

********

SELECT VTOS
m.CodDoc = "C/D "
m.NroDoc = SPACE(LEN(NroDoc))
m.FchDoc = DATE()
m.CodCli = SPACE(LEN(CodCli))
m.GloDoc = SPACE(LEN(GloDoc))
XnCodMon = 1
m.TpoCmb = 0.00   && basura
m.ImpDoc = 0
m.FlgEst = [E]
** variables de control de datos intermedios **
m.Import  = 0.00     && importe de documentos
m.ImpDoc  = 0.00     && importe de letras (= importe del canje)
m.Crear   = .T.

******
*m.fchdoc = DATE()
*m.codcli = SPACE(LEN(CodCli))
*m.glodoc = SPACE(LEN(GloDoc))
*XnCodMon = 1
*m.tpocmb = 0.00
*m.impdoc = 0
*m.flgest = 'E'

****

*SELECT GDOC  && ERA TASG
*APPEND BLANK
*IF !RLOCK()
*   RETURN
*ENDIF
**

*SELECT GDOC
*REPLACE CodDoc WITH m.coddoc
*REPLACE NroDoc WITH m.nrodoc
*REPLACE FchDoc WITH m.fchdoc
*REPLACE CodCli WITH m.codcli
*REPLACE GloDoc WITH m.glodoc
*REPLACE CodMon WITH XnCodMon
*REPLACE TpoCmb WITH m.tpocmb
*REPLACE ImpTot WITH m.impdoc
*REPLACE FlgEst WITH m.flgest


*j = 1
*FOR j = 1 TO MaxEle1
*   Do CjLActLet
*   j = j + 1
*ENDFOR

************************************************************************** FIN
* Grabando Letras
***************************************************************************
PROCEDURE CjLActLet

SELE RASG
APPEND BLANK
DO WHILE !RLOCK()
ENDDO
REPLACE CodDoc WITH m.CodDoc
REPLACE NroDoc WITH m.NroDoc
REPLACE FchDoc WITH m.FchDoc
REPLACE CodCli WITH m.CodCli
REPLACE CodMon WITH XnCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE CodRef WITH vCodDoc(j)
REPLACE NroRef WITH vNroDoc(j)
REPLACE Import WITH vImport(j)
REPLACE GloDoc WITH vNotAst(j)
RETURN

** ARCHIVOS DE CUENTAS POR COBRAR **
*USE CCBNTASG IN 13 ORDER TASG01 ALIAS TASG
*IF !USED(13)
*   CLOSE DATA
*   RETURN
*ENDIF
***
*USE CCBNRASG IN 14 ORDER RASG01 ALIAS RASG
*IF !USED(14)
*   CLOSE DATA
*   RETURN
*ENDIF
**
** MAS BASURA

******************************************************************************
* Objeto : Extornar Estad¡sticas
******************************************************************************

**** BORRAR****
** Verificamos si alguna LETRA presenta problemas al anularla **
OK = .T.
SELECT GDOC
SET ORDER TO GDOC03
SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
   IF FlgEst # [T]   && Letras fuera de transito
       IF ! (FlgEst=[P] .AND. ImpTot=SdoDoc)
         GsMsgErr = [La Letra : ]+NroDoc+[ NO puede ser anulada]
         DO lib_merr WITH 99
         OK = .F.
         EXIT
      ENDIF
   ENDIF
ENDSCAN
SET ORDER TO GDOC04

** FIN DE VERIFICACION DE CONSISTENCIA DE LETRAS **
IF ! OK
   RETURN
ENDIF

WAIT "BORRANDO" NOWAIT WINDOW
XsCodDoc=VTOS->CodDoc
XsNroDoc=VTOS->NroDoc

** grabamos cabecera **
SELECT SLDO
SEEK VTOS->CodCli
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TASG
IF !RLOCK()
   RETURN
ENDIF
** DIVIDIMOS LA ANULACION DE ACUERDO A SI HA SIDO APROBADO O NO LOS DOCUMENTOS **
IF TASG->FlgEst = [P]   && Aun no estan aprobadas
   SELECT GDOC
   SEEK TASG->coddoc+TASG->nrodoc
   DO WHILE CodDoc+NroDoc = TASG->coddoc+TASG->nrodoc .AND. !EOF()
      IF !RLOCK()
         LOOP
      ENDIF
      DELETE
      UNLOCK
      SKIP
   ENDDO
ELSE
   SELECT VTOS
   SEEK TASG->coddoc+TASG->nrodoc
   DO WHILE CodDoc+NroDoc = TASG->coddoc+TASG->nrodoc .AND. ! EOF()
      IF !RLOCK()
         LOOP
      ENDIF
      SELECT GDOC
      SET ORDER TO GDOC01
      SEEK "CARGO"+VTOS->codref+VTOS->nroref
      IF !RLOCK()
         SELE VTOS
         LOOP
      ENDIF
      LfImpDoc = VTOS->Import
      IF CodMon <> TASG->codmon
         IF TASG->codmon = 1
            LfImpDoc = LfImpDoc / TASG->tpocmb
         ELSE
            LfImpDoc = LfImpDoc * TASG->tpocmb
         ENDIF
      ENDIF
      REPLACE SdoDoc WITH SdoDoc + LfImpDoc
      IF SdoDoc <= 0.01
         REPLACE FlgEst WITH 'C'
      ELSE
         REPLACE FlgEst WITH 'P'
      ENDIF
      REPLACE FlgSit WITH ' '
      UNLOCK
      ** actualizamos saldo del cliente **
      SELECT SLDO
      IF GDOC->CodMon = 2
         REPLACE CgoUSA WITH CgoUSA + LfImpDoc
      ELSE
         REPLACE CgoNAC WITH CgoNAC + LfImpDoc
      ENDIF
      SELECT GDOC
      SET ORDER TO GDOC04
      * * * *
      SELECT VTOS
      DELETE
      UNLOCK
      SKIP
   ENDDO
ENDIF
**
SELECT GDOC
SET ORDER TO GDOC03
SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
DO WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = ;
         "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR" .AND. !EOF()
   ** borramos informacion **
   IF !RLOCK()
      LOOP
   ENDIF
   IF FlgEst # [T]    && Letras NO en transito
      SELECT SLDO                   && es decir APROBADAS
      IF GDOC->CodMon = 2
         REPLACE CgoUSA WITH CgoUSA - GDOC->ImpTot
      ELSE
         REPLACE CgoNAC WITH CgoNAC - GDOC->ImpTot
      ENDIF
   ENDIF
   SELECT GDOC
   DELETE
   UNLOCK
   SKIP
ENDDO
SET ORDER TO GDOC04
**
UNLOCK ALL
RETURN


