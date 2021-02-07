**********************************************************************
*  Nombre        : CJAEXTRA.prg
*  Sistema       : Caja Bancos
*  Autor         : Jorge Mieses
*  Proposito     : INGRESO DEL EXTRACTO BANCARIO
*  Creaci¢n      : 17/06/93
*  Actualizaci¢n :
***************************************************************************
CLEAR
@  1,0 TO  3,79
@  4,0 TO 20,79
@  5,1  SAY "                      N§         TIPO                                         " COLOR SCHEME 7
@  6,1  SAY "       FECHA      DOCUMENTO      MOV.     ***  CARGOS  ***   ***  ABONOS  *** " COLOR SCHEME 7
@  7,0  SAY "Ã"
@  7,1  TO  7,78
@  7,79 SAY "´"
@  8,45 SAY "SALDO INICIAL"
@  9,1  TO  9,78
@ 21,0 TO 23,79
@  2,3 SAY "Cuenta : "
XsNroMes = TRANSF(_MES,"@L ##")
@ 0,1  SAY MES(_MES,3)+" "+TRANS(_ANO,"9999") COLOR SCHEME 7
@ 0,62 SAY "EXTRACTO BANCARIO" COLOR SCHEME 7
@ 22,20 SAY "*** T O T A L E S ***"
@ 23,45 SAY " SALDO FINAL "
************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
** Abrimos areas a usar **
SELE 1
USE cbdmctas ORDER ctas01   ALIAS CTAS
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE cbdbanco ORDER banc01   ALIAS BANC
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
UltTecla = 0
**********************
** Rutina Principal **
**********************
SELECT BANC
SEEK XsNroMes
XsCodCta = CodCta
XfSdoIni = 0
LfCargos = 0
LfAbonos = 0
Llave    = ""
DO WHILE .T.
   DO MOVNoDoc
   IF LASTKEY() = Escape
      CLOSE DATA
      RETURN
   ENDIF
   DO MOVBrows
   UNLOCK ALL
ENDDO
CLOSE DATA
CLOSE PROCEDURE
RETURN
************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
SELECT BANC
SEEK XsNroMes
UltTecla = 0
DO LIB_MTEC WITH 2
DO WHILE ! INLIST(UltTecla,Enter,Escape)
   cCodCta = "104"
   SELECT CTAS
   @ 2,12 GET XsCodCta PICT "1049999999"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape
      EXIT
   ENDIF
   IF UltTecla = F8
      IF CBDBUSCA("CTAX")
         XsCodCta = CTAS->CodCta
      ELSE
         LOOP
      ENDIF
      UltTecla = Enter
   ENDIF
   @ 2,12 SAY XsCodCta
   SEEK XsCodCta
   IF ! FOUND()
      GsMsgErr = "Cuenta no Registrada"
      DO LIB_MERR WITH 99
      LOOP
   ENDIF
   @ 2,26 SAY NomCta
   SELECT BANC
   Llave = (XsNroMes+XsCodCta+"B")
   DO CASE
      CASE UltTecla = 0
         LOOP
      CASE UltTecla = F9
         SEEK Llave
         IF ! FOUND()
            DO LIB_MERR WITH 9
            UltTecla = 0
         ELSE
            EXIT
         ENDIF
      OTHER
   ENDCASE
   XfSdoIni = 0
   LfCargos = 0
   LfAbonos = 0
   SEEK Llave
   @ 10,1 clear TO 19,78
   IF FOUND()
      NumLin = 10
      XfSdoIni = SdoIni
      DO WHILE Llave = NroMes+CodCta+FlgEst .AND. ! EOF()
         IF NumLin < 20
            Contenido = ""
            DO MOVbline with Contenido
            @ NumLin,2 SAY Contenido
            NumLin = NumLin + 1
         ENDIF
         IF TpoMov = "H"
            LfAbonos = LfAbonos + Import
         ELSE
            LfCargos = LfCargos + Import
         ENDIF
         SKIP
      ENDDO
   ENDIF
   @ 08,64 SAY XfSdoIni PICT "999,999,999.99"
   @ 22,45 SAY LfCargos PICT "999,999,999.99" COLOR SCHEME 7
   @ 22,64 SAY LfAbonos PICT "999,999,999.99" COLOR SCHEME 7
   XfSdoFin = XfSdoIni + LfCargos - LfAbonos
   @ 23,64 SAY XfSdoFin PICT "999,999,999.99"
ENDDO
RETURN
******************************************************************************
*  Proposito     : Procedimientos de browse (Ingresos de almacen)
******************************************************************************
PROCEDURE MOVBrows
SELECT BANC
@ 08,64 GET XfSdoIni PICT "999,999,999.99"
READ
IF LASTKEY()=Escape
   RETURN
ENDIF

SEEK Llave
IF FOUND() .AND. SDOINI <> XfSdoIni
   DO WHILE Llave = NroMes+CodCta+FlgEst .AND. ! EOF()
      IF Rec_Lock(5)
         REPLACE SdoIni WITH XfSdoIni
      ENDIF
      SKIP
   ENDDO
ENDIF
XfSdoFin = XfSdoIni + LfCargos - LfAbonos
@ 23,64 SAY XfSdoFin PICT "999,999,999.99"

UltTecla = 0
SET_ESCAPE = .T.
SelLin   = []
InsLin   = "MOVBGrab"
EscLin   = "MOVbline"
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
NClave   = [NroMes+CodCta+FlgEst]
VClave   = XsNroMes+XsCodCta+"B"
HTitle   = 1
Yo       = 9
Xo       = 0
Largo    = 21 - Yo
Ancho    = 80
TBorde   = Nulo
Titulo   = []
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.
*XdFchRef = {,,}
XdFchRef = FchRef
XsNroRef = ""
XcTpoMov = "H"
XfImport = 0.00
XiNroItm = 1
DO LIB_MTEC WITH 14
DO DBrowse
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVbline
PARAMETERS Contenido
Contenido = "    "+DTOC(FchRef)+"     "+NroRef+"     "+IIF(TpoMov='D','Debe ','Haber')+'      '
Contenido = Contenido + IIF(TpoMov='D',TRAN(Import,"999,999,999.99")+SPACE(19),;
            SPACE(19)+TRAN(Import,"999,999,999.99"))
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit
IF ! Crear
   XdFchRef = FchRef
   XsNroRef = NroRef
   XcTpoMov = TpoMov
   XfImport = Import
ELSE
  *XdFchRef = {,,}
   XdFchRef = FchRef
   XsNroRef = SPACE(LEN(NroRef))
   XcTpoMov = "H"
   XfImport = 0.00
ENDIF
DO Lib_MTec WITH 7    && Teclas edicion linea
I = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
         @ LinAct,6  GET XdFchRef
         READ
         UltTecla = LASTKEY()
         @ LinAct,6  SAY XdFchRef

      CASE i = 2
         @ LinAct,19 GET XsNroRef
         READ
         UltTecla = LASTKEY()
         @ LinAct,19 SAY XsNroRef

      CASE i = 3
         DO LIB_MTEC WITH 16
         VecOpc(1)="Debe"
         VecOpc(2)="Haber"
         XcTpoMov= Elige(XcTpoMov,LinAct,34,2)
      CASE i = 4  .and. XcTpoMov = "D"
         @ LinAct,64 SAY SPACE(15)
         @ LinAct,45 GET XfImport PICT "999,999,999.99" VALID XfImport > 0
         READ
         UltTecla = LASTKEY()
         @ LinAct,45 SAY XfImport PICT "999,999,999.99"
      CASE i = 5  .and. XcTpoMov = "H"
         @ LinAct,45 SAY SPACE(15)
         @ LinAct,64 GET XfImport PICT "999,999,999.99" VALID XfImport > 0
         READ
         UltTecla = LASTKEY()
         @ LinAct,64 SAY XfImport PICT "999,999,999.99"
      CASE i = 6
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>6, 6, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT BANC
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbborr
DO LIB_MSGS WITH 10
IF Rec_LOCK(5)
   DELETE
   IF TpoMov = "H"
      LfAbonos = LfAbonos - Import
   ELSE
      LfCargos = LfCargos - Import
   ENDIF
   @ 22,45 SAY LfCargos PICT "999,999,999.99" COLOR SCHEME 7
   @ 22,64 SAY LfAbonos PICT "999,999,999.99" COLOR SCHEME 7
   XfSdoFin = XfSdoIni + LfCargos - LfAbonos
   @ 23,64 SAY XfSdoFin PICT "999,999,999.99"
   UNLOCK
   SKIP
   ULTTECLA = F10
ELSE
   ULTTECLA = Escape
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab
DO LIB_MSGS WITH 4
IF Crear
   APPEND BLANK
ENDIF
IF ! Rec_Lock(5)
   RETURN
ENDIF
IF Crear
   REPLACE NroMes WITH XsNroMes
   REPLACE CodCta WITH XsCodCta
ELSE
   IF TpoMov = "H"
      LfAbonos = LfAbonos - Import
   ELSE
      LfCargos = LfCargos - Import
   ENDIF
ENDIF
REPLACE FchRef WITH XdFchRef
REPLACE NroRef WITH XsNroRef
REPLACE TpoMov WITH XcTpoMov
REPLACE Import WITH XfImport
REPLACE SdoIni WITH XfSdoIni
REPLACE FlgEst WITH "B"
IF TpoMov = "H"
   LfAbonos = LfAbonos + Import
ELSE
   LfCargos = LfCargos + Import
ENDIF
@ 22,45 SAY LfCargos PICT "999,999,999.99" COLOR SCHEME 7
@ 22,64 SAY LfAbonos PICT "999,999,999.99" COLOR SCHEME 7
XfSdoFin = XfSdoIni + LfCargos - LfAbonos
@ 23,64 SAY XfSdoFin PICT "999,999,999.99"
UNLOCK
DO LIB_MTEC WITH 14
RETURN
