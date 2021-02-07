**********************************************************************
*  Nombre        : ccbr4500.prg
*  Sistema       : Cuentas por Cobrar
*  Autor         : VETT
*  Proposito     : Analisis de Cuentas
*  Creacion      : 05/02/93
*  Actualizado   : 08/07/93  VETT
*  Actualizado   : 23/11/03  VETT
***************************************************************************
SYS(2700,0)
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
DO fondo WITH 'Análisis de Cuentas Totalizadas',Goentorno.user.login,GsNomCia,GsFecha
DO ANALista

IF USED('GDOC')
	USE IN GDOC
ENDIF
IF USED('CLIE')
	USE IN CLIE
ENDIF
IF USED('TDOC')
	USE IN TDOC
ENDIF
IF USED('VTOS')
	USE IN VTOS
ENDIF

IF USED('SLDO')
	USE IN SLDO
ENDIF
CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN


PROCEDURE ANALista
******************
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','CLIE','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC02','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS05','')
RELEASE LoDatAdm

** variables a usar **
m.coddoc=space(4)
xstpodoc='CARGO'
LsCodAuxD= SPACE(LEN(CLIE.CodAux))
LsCodAuxH= SPACE(LEN(CLIE.CodAux))
LdFecha  = DATE()
LiDuda   = 1
NUmItm = 0
** variables del browse **
CIMAXELE = 20
DIMENSION AsCodAux(CIMAXELE)
DIMENSION AsNomAux(CIMAXELE)
GiTotItm = 0
**************************
UltTecla = 0
@ 7,8 to 18,71 panel
@ 7,24 say  "An lisis de Cuentas Totalizadas"
@  9,10 SAY "Documento            :"
@ 11,10 SAY "Condici¢n            :"
@ 13,10 SAY "Desde    Cliente     :"
@ 15,10 SAY "Hasta    Cliente     :"
@ 17,10 SAY "A la fecha           :"
DO LIB_MTEC WITH 13
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1
        @ 9,35 GET m.coddoc PICT '@!'
        READ
        SELECT TDOC
        UltTecla = LASTKEY()
        IF UltTecla = escape_
           EXIT
        ENDIF
        IF LASTKEY() = F8
           IF ! ccbbusca("TDOC")
              LOOP
           ENDIF
           m.CodDoc = CodDoc
        ENDIF
        @ 09,35 SAY m.CodDoc   PICTURE "@!"
        SEEK m.CodDoc
        IF ! FOUND() .AND.!EMPTY(M.CODDOC)
           WAIT "C¢digo de Documento no registrado" NOWAIT WINDOW
           LOOP
        ENDIF

      CASE i = 2
         @ 11,35 GET LiDuda PICT "@*RTH Por \<Rangos;\<Selectivo"
         READ
         UltTecla = LASTKEY()

      CASE i = 3 .AND. LiDuda = 2     && Selectivo
         SAVE SCREEN
         DO GENBrows
         RESTORE SCREEN

      CASE i = 3 .AND. LiDuda = 1     && Rangos
         @ 13,35 GET LsCodAuxD PICTURE "@!"  VALID _vLook(@LsCodAuxD,"CODAUX")
         @ 15,35 GET LsCodAuxH PICTURE "@!"  VALID _vLook(@LsCodAuxH,"CODAUX") when _wCliente()
         READ
         UltTecla = LASTKEY()
         @ 13,35 SAY LsCodAuxD
         @ 15,35 SAY LsCodAuxH

      CASE i = 4
         @ 17,35 GET LdFecha PICT "@RD mm/dd/aa"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i < 1, 1, i)
   i = IIF(i > 4, 4, i)
ENDDO
IF UltTecla = escape_
   RETURN
ENDIF
SELE CLIE
******** CONDICIONES DE FIN DE IMPRESION
IF LiDuda = 1         && Rangos
   LsCodAuxD = TRIM(LsCodAuxD)
   LsCodAuxH = TRIM(LsCodAuxH)+CHR(255)
   IF TRIM(LsCodAuxD) == []
      SEEK GsClfCli
      LsCodAuxD = CodAux
   ELSE
      SEEK GsClfCli+LsCodAuxD
      IF FOUND()
         LsCodAuxD = CodAux
      ENDIF
   ENDIF
   SEEK GsClfCli+LsCodAuxD
   IF !FOUND()
      WAIT 'Auxiliar sin Movimientos' NOWAIT WINDOW
      UltTecla = 0
      RETURN
   ENDIF
   **
   LsTstImp = "CodAux<=LsCodAuxH.AND.ClfAux=GsClfCli"
ELSE
   LsTstImp = "CodAux<=LsCodAuxH.AND.ClfAux=GsClfCli"
ENDIF
DO ANALImpr
RETURN


************************************************************************ FIN
PROCEDURE GENBrows
***************************************************************************
* Browse de datos selectivos **

SELE  CLIE

GiTotItm = 0
UltTecla = 0
**
EscLin   = "GENbline"
EdiLin   = "GENbedit"
BrrLin   = "GENbborr"
InsLin   = "GENbinse"
PrgFin   = []
*
yo       = 10
xo       = 24
Largo    = 10
Ancho    = 54
Tborde   = Simple
Titulo   = []
En1 = "CLIENTE    NOMBRE                                  "
En2 = ""
En3 = ""

*2     3         4         5         6         7
*45678901234567890123456789012345678901234567890123456
* CLIENTE    NOMBRE                                  "
* 1234567890 1234567890123456789012345678901234567890

DO GENbiniv            && Inicializa el arreglo
*
MaxEle = GiTotItm
TotEle = CIMAXELE
*
DO aBrowse
*
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ENDIF
*
RETURN
************************************************************************ FIN *

********* SEGUNDO NIVEL : PROCEDIMIENTOS REQUERIDOS POR DL_BROWS *************

******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin
*
@ NumLin,25 SAY AsCodAux(NumEle)
@ NumLin,35 SAY AsNomAux(NumEle)

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedit
PARAMETERS NumEle, NumLin
*
PRIVATE i
UltTecla = 0
i = 1
LsCodAux = AsCodAux(NumEle)
LsNomAux = AsNomAux(NumEle)
**
DO WHILE  ! INLIST(UltTecla,escape_,Arriba,Abajo)
   DO CASE
      CASE i = 1        && Codigo de material
         @ NumLin,25 GET LsCodAux PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba,Abajo)
            LOOP
         ENDIF
         SEEK GsClfCli+LsCodAux
         IF .NOT. FOUND()
            DO lib_merr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
         **
         j = 1
         LlRepite = .F.
         DO WHILE j <= GiTotItm
            IF LsCodAux=AsCodAux(j) .AND. j <> NumEle
               LlRepite = .T.
               DO lib_merr WITH 8   && ya registrado
               EXIT
            ENDIF
            j = j + 1
         ENDDO
         IF LlRepite
            UltTecla = 0
            LOOP
         ENDIF
         LsNomAux = NomAux
         @ NumLin,35 SAY LsNomAux
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF( i > 1 , 1, i)
   i = IIF( i < 1 , 1, i)
ENDDO
IF UltTecla # escape_
   AsCodAux(NumEle) = LsCodAux
   AsNomAux(NumEle) = LsNomAux
ENDIF
**
RETURN
************************************************************************ FIN *
******************************************************************************
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbborr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
DO WHILE i <  GiTotItm
   AsCodAux(i) = AsCodAux(i+1)
   AsNomAux(i) = AsNomAux(i+1)
   i = i + 1
ENDDO
AsCodAux(i) = SPACE(LEN(clie.CodAux))
AsNomAux(i) = SPACE(LEN(clie.NomAux))
GiTotItm = GiTotItm - 1
Estado = .T.
RETURN
************************************************************************ FIN *
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbinse

PARAMETERS ElePrv, Estado
*
PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsCodAux(i) = AsCodAux(i-1)
   AsNomAux(i) = AsNomAux(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
AsCodAux(i) = SPACE(LEN(clie.CodAux))
AsNomAux(i) = SPACE(LEN(clie.NomAux))
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
******************************************************************************
* Objeto : Inicializar el arreglo
******************************************************************************
PROCEDURE GENbiniv

STORE SPACE(LEN(CLIE.CodAux)) TO AsCodAux
STORE SPACE(LEN(CLIE.NomAux)) TO AsNomAux
RETURN
************************************************************************ FIN *


PROCEDURE ANALImpr
******************
Ancho    = 139
Tit_SIzq = GsNomCia
Tit_IIzq = [ccbr4500]
Titulo   = "ANALISIS DE CUENTAS POR COBRAR TOTALIZADAS AL "+DTOC(LdFecha)
SubTitulo = []
En1 = []
En2 = []
En3 = "**** *********** **** **********  ******** ******** ***** ************************* ************************* *****************************"
En4 = "Cod.    No.      Cod. Documento    Fecha    Fecha   Dias  ---- C  A  R  G  O  S --- --- A  B  O  N  O  S ---- ----- S  A  L  D  O  S ------"
En5 = "Doc. Documento   Ref. Referencia   Docmto.  Vcmto.  Atra       S/.          US$         S/.           US$           S/.              US$   "
En6 = "**** *********** **** *********** ******** ******** ***** ************************* ************************* *****************************"
*          1         2         3         4         5          6        7         8         9         0        11        12        13        14
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
***** *********** **** **********  ******** ******** ***** ************************* ************************* *****************************"
*Cod.    No.      Cod. Documento    Fecha    Fecha   Dias  ---- C  A  R  G  O  S --- --- A  B  O  N  O  S ---- ----- S  A  L  D  O  S ------"
*Doc. Documento   Ref. Referencia   Docmto.  Vcmto.  Atra       S/.          US$         S/.           US$           S/.              US$   "
***** *********** **** *********** ******** ******** ***** ************************* ************************* *****************************"
*1234 12345678901 1234 12345678901 99/99/99 99/99/99 (123) 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99 (9,999,999.99) (9,999,999.99)
*          SUB TOTAL GENERAL                               9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99 (9,999,999.99) (9,999,999.99)
*          TOTAL GENERAL PAGOS A CUENTA                                                                        (9,999,999.99) (9,999,999.99)
*          TOTAL GENERAL                                                                                       (9,999,999.99) (9,999,999.99)
*          1         2         3         4         5          6        7         8         9         0        11        12        13        14
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234


_PLENGTH = 66
_PEJECT  = "NONE"
_PAGENO  = 1
**
DO F0PRINT
IF LASTKEY() = 27
   RETURN
ENDIF
**
Largo  = 66       && Largo de pagina
IniPrn = _PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4
SELE CLIE
RegIni = RECNO()
Cancelar = .F.
Inicio   = .T.
SET DEVICE TO PRINT
PRINTJOB
   SELE CLIE
   GOTO RegIni
   NumLin  = 0
   TSdoNac = 0
   TSdoExt = 0
   TCarNac = 0
   TCarExt = 0
   TAboNac = 0
   TAboExt = 0
   Inicio  = .T.
   DO MEMBRETE WITH Inicio
   IF LiDuda = 1         && Rangos
      Cancelar = .f.
      DO WHILE &LsTstImp .AND. ! EOF() .AND. ! Cancelar
         DO IMPDeta
         SELE CLIE
         SKIP
      ENDDO
   ELSE
      k = 1
      DO WHILE k <= GiTotItm
         SELE CLIE
         SEEK GsClfCli+AsCodAux(k)
         IF FOUND()
            DO IMPDeta
         ENDIF
         k = k + 1
      ENDDO
   ENDIF
   NumLin = NumLin + 1
   @ NumLin,0 SAY REPLI("=",Ancho)
   NumLin = NumLin + 1
   @ NumLin , 10 SAY "T O T A L     G E N E R A L     >>>"
  *TSdoNac = TCarNac - TAboNac
  *TSdoExt = TCarExt - TAboExt
   @ NumLin , 58 SAY TCarNac     PICT '99999,999.99'
   @ NumLin , 71 SAY TCarExt     PICT '99999,999.99'
   @ NumLin , 84 SAY TAboNac     PICT '99999,999.99'
   @ NumLin , 97 SAY TAboExt     PICT '99999,999.99'
   @ NumLin ,110 SAY TSdoNac     PICT '@( 9,999,999.99'
   @ NumLin ,125 SAY TSdoExt     PICT '@( 9,999,999.99'
   NumLin = NumLin + 1
   @ NumLin,0 SAY REPLI("=",Ancho)
   EJECT PAGE
ENDPRINTJOB
DO f0PRFIN &&IN ADMPRINT
RETURN
************************************************************************** FIN
PROCEDURE MEMBRETE
******************
PARAMETER Inicio
IF Type("Inicio") # "L"
   Inicio = .f.
ENDIF
IF ! inicio
   EJECT PAGE
ENDIF
@  0,0  SAY IniPrn
@  1,0  SAY Tit_SIzq
@  1,(Ancho-LEN(Titulo))/2 SAY Titulo
@  1,Ancho-20 SAY "Pagina : "+STR(_PAGENO,8)
@  2,0 SAY Tit_IIzq
@  2,(Ancho-LEN(SubTitulo))/2 SAY SubTitulo
@  2,Ancho-20 SAY "Fecha  : "+DTOC(DATE())
@  3,(Ancho-LEN(En1))/2 SAY En1
@  4,(Ancho-LEN(En2))/2 SAY En2
@  5,(Ancho-LEN(En3))/2 SAY En3
@  6,(Ancho-LEN(En4))/2 SAY En4
@  7,(Ancho-LEN(En5))/2 SAY En5
@  8,(Ancho-LEN(En6))/2 SAY En6
NumLin = PROW()+1
Inicio = .F.
RETURN

**********************************************************************
PROCEDURE IMPDeta
****************
XsCodCli = CLIE.codaux
ENCABEZADO = .T.
LSdoNac = 0
LSdoExt = 0
LCarNac = 0
LCarExt = 0
LAboNac = 0
LAboExt = 0
NumLin  = PROW() +  1
NumItm  = 0
SELE GDOC
SET FILTER TO tpovta<>3
SET ORDER TO GDOC02
SEEK XsCodCli
IF EMPTY(m.coddoc)
   Xwhile1 = ".T."
Else
   Xwhile1 = "GDOC.CodDoc=m.CodDoc"
Endif
SCAN WHILE CODCLI=XsCodcli FOR &Xwhile1.
     IF FCHDOC >  LdFecha
     ELSE
        NumItm   = NumItm+1
        LiCodMon = CodMon
        DCarNac  = 0
        DCarExt  = 0
        DAboNac  = 0
        DAboExt  = 0
        NumItm2 = 0
        DO LinImp
        DO TRANSAC1
		IF NumItm2 > 0
		   IF PROW() > 58
		      DO MEMBRETE
		   ENDIF
		   NumLin = NumLin + 1
		   @ NumLin ,0   SAY REPLI(".",Ancho)
*!*			   NumLin = PROW() + 1
		ENDIF        
     ENDIF
ENDSCAN
*DO TRANSAC2  &&TODOS LOS ABONOS PENDIENTES DEL CLIENTE
IF NumItm > 0
   IF PROW() > 58
      DO MEMBRETE
   ENDIF
   NumLin = NumLin + 1
   @ NumLin ,0   SAY REPLI("-",Ancho)
   NumLin = PROW() + 1
   @ NumLin ,40  SAY "TOTAL -->"
  *LSdoNac = LCarNac - LAboNac
  *LSdoExt = LCarExt - LAboExt
   @ NumLin , 58 SAY LCarNac           PICT "@Z "+'99999,999.99'
   @ NumLin , 71 SAY LCarExt           PICT "@Z "+'99999,999.99'
   @ NumLin , 84 SAY LAboNac           PICT "@Z "+'99999,999.99'
   @ NumLin , 97 SAY LAboExt           PICT "@Z "+'99999,999.99'
   @ NumLin ,110 SAY LSdoNac           PICT "@( "+'99999,999.99'
   @ NumLin ,125 SAY LSdoExt           PICT "@( "+'99999,999.99'
   * * * *
   TCarNac = TCarNac + LCarNac
   TCarExt = TCarExt + LCarExt
   TAboNac = TAboNac + LAboNac
   TAboExt = TAboExt + LAboExt
   TSdoNac = TSdoNac + LSdoNac
   TSdoExt = TSdoExt + LSdoExt
   * * * *
   Numlin = Numlin + 1
ENDIF
SELE CLIE
RETURN
****************
PROCEDURE LinImp
****************
IF PROW() > 58
   DO MEMBRETE
ENDIF
IF ENCABEZADO
   ENCABEZADO = .F.
   @ Numlin, 1  SAY "CLIENTE : "+CLIE.codaux+" "+CLIE.nomaux
ENDIF
NumLin = PROW() + 1
@ NumLin , 0  SAY CodDoc
@ NumLin , 5  SAY NroDoc
@ NumLin ,17  SAY CodRef
@ NumLin ,22  SAY NroRef
@ NumLin ,34  SAY STRT(DTOC(FchDoc),'/20','/') && FchDoc
DO CASE
   CASE FlgEst="A"    && Anulado Completamente
        @ NumLin , 58 SAY "        A      N      U      L      A      D      O"
   CASE FlgEst="T"
   OTHER
        @ NumLin , 43 SAY STRT(DTOC(FchVto),'/20','/') && FchVto
        IF LdFecha > FchVto
           @ NumLin , 52 SAY LdFecha-FchVto PICT "@( 999"
        ENDIF
        IF TpoDoc="CARGO"
           IF CodMon=1
              @ NumLin , 58 SAY ImpTot     PICT '9,999,999.99'
              LCarNac = LCarNac + ImpTot
              DCarNac = DCarNac + ImpTot
           ELSE
              @ NumLin , 71 SAY ImpTot     PICT '9,999,999.99'
              LCarExt = LCarExt + ImpTot
              DCarExt = DCarExt + ImpTot
           ENDIF
        ELSE
           IF CodMon=1
              @ NumLin , 84 SAY ImpTot     PICT '9,999,999.99'
              LAboNac = LAboNac + ImpTot
              DAboNac = DAboNac + ImpTot
           ELSE
              @ NumLin , 97 SAY ImpTot     PICT '9,999,999.99'
              LAboExt = LAboExt + ImpTot
              DAboExt = DAboExt + ImpTot
           ENDIF
        ENDIF
ENDCASE
NumItm2 = NumItm2 + 1
RETURN

*******************
PROCEDURE  TRANSAC1
*******************
IF GDOC->TpoDoc=[CARGO]
   NsClave = [CodCli+CodRef+NroRef]
   LsLlave = GDOC.CodCli+GDOC.CodDoc+GDOC.NroDoc
   SELE VTOS
   SET ORDER TO VTOS05
   SEEK LsLlave
ELSE
   NsClave = [CodDoc+NroDoc]
   LsLlave = GDOC.CodDoc+GDOC.NroDoc
   SELE VTOS
   SET ORDER TO VTOS01
   SEEK Lsllave
ENDIF
DO WHILE &NsClave=LsLLave .AND. !EOF()
   IF FCHDOC >  LdFecha
      SKIP
      LOOP
   ENDIF
   IF LiCodMon=1
      IF CodMon=1
         LImport = Import
      ELSE
         LImport = Import*TpoCmb
      ENDIF
      LAboNac =LAboNac + LImport*IIF(GDOC.TpoDoc=[CARGO],1,-1)
      DAboNac =DAboNac + LImport*IIF(GDOC.TpoDoc=[CARGO],1,-1)
   ELSE
      IF CodMon=2
         LImport = Import
      ELSE
         LImport = Import/TpoCmb
      ENDIF
      LAboExt =LAboExt + LImport*IIF(GDOC.TpoDoc=[CARGO],1,-1)
      DAboExt =DAboExt + LImport*IIF(GDOC.TpoDoc=[CARGO],1,-1)
   ENDIF
   IF PROW()>58
      DO MEMBRETE
   ENDIF
   NumLin = PROW() + 1
   IF GDOC->TpoDoc=[CARGO]
      @ NumLin,17 SAY CodDoc
      @ NumLin,22 SAY NroDoc
   ELSE
      @ NumLin,17 SAY CodRef
      @ NumLin,22 SAY NroRef
   ENDIF
   @ NumLin,34 SAY STRT(DTOC(FchDoc),'/20','/') && FchDoc
   IF GDOC->TpoDoc=[CARGO]
      IF LiCodMon=1
         @ NumLin , 84 SAY LImport      PICT '9,999,999.99'
      ELSE
         @ NumLin , 97 SAY LImport      PICT '9,999,999.99'
      ENDIF
   ELSE
      IF LiCodMon=1
         @ NumLin , 58 SAY LImport      PICT '9,999,999.99'
      ELSE
         @ NumLin , 71 SAY LImport      PICT '9,999,999.99'
      ENDIF
   ENDIF
   SKIP
ENDDO
DSdoNac = DCarNac - DAboNac
DSdoExt = DCarExt - DAboExt
** PARCHE PARA ELIMINAR LOS MENORES A 0.01 **
DSdoNac = IIF(ABS(DSdoNac)<=0.01,0,DSdoNac)
DSdoExt = IIF(ABS(DSdoExt)<=0.01,0,DSdoExt)
*********************************************
@ NumLin ,110 SAY DSdoNac     PICT "@( "+'9,999,999.99'
@ NumLin ,125 SAY DSdoExt     PICT "@( "+'9,999,999.99'
* * * *
LSdoNac = LSdoNac + DSdoNac
LSdoExt = LSdoExt + DSdoExt
* * * *
SELE GDOC
NumItm2 = NumItm2 + 1
RETURN
****************************
procedure _vlook
****************************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
   select CLIE
   IF ! ccbbusca("CLIE")
      SELECT GDOC
      return .T.
   ENDIF
   var1    = &campo1
   ulttecla= Enter
   SELECT GDOC
ENDIF
IF UltTecla = escape_ .OR. UltTecla = ENTER
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
IF !SEEK(VAR1,"CLIE")
   RETURN .F.
ENDIF
RETURN .T.

FUNCTION _wCliente
IF VARTYPE(LsCodAuxD)='C' AND VARTYPE(LsCodAuxH)='C' AND !EMPTY(LsCodAuxD)  AND EMPTY(LsCodAuxH)
	LsCodAuxH = LsCodAuxD
ENDIF
