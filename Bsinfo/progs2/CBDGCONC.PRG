*** Proceso de Conciliaci¢n Bancaria ***
IF _Mes < 1 .or. _Mes > 12
   GsMsgErr = " Invalido mes de proceso "
   DO LIB_MERR WITH 99
   RETURN
ENDIF
CLEAR
@  1,0 TO  3,79
@  4,0 TO 20,79
@  5,1  SAY "              N§                                    _ORIGEN  CONTABLE_       "  COLOR SCHEME 7
@  6,1  SAY "   FECHA   DOCUMENTO          CARGOS         ABONOS M. LB. CMPTE  ITEM Origen"  COLOR SCHEME 7

@  7,0  SAY "Ã"
@  7,1  TO  7,78
@  7,79 SAY "´"
@  8,45 SAY "SALDO INICIAL"
@  9,1  TO  9,78
@ 21,0 TO 23,79
@  2,3 SAY "Cuenta : "
XsNroMes = TRANSF(_MES,"@L ##")
@ 0,1  SAY MES(_MES,3)+" "+TRANS(_ANO,"9999") COLOR SCHEME 7
@ 0,58 SAY "CONCILIACION BANCARIA" COLOR SCHEME 7
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
USE cbdrmovm ORDER RMOV01   ALIAS RMOV
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
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
   SELECT BANC
   SET ORDER TO BANC01
   DO MOVNoDoc
   IF LASTKEY() = Escape
      CLOSE DATA
      RETURN
   ENDIF
   DO CONCILIA
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
      UltTecla = 0
      LOOP
   ENDIF
   @ 2,26 SAY NomCta
   SELECT BANC
   XfSdoIni = 0
   LfCargos = 0
   LfAbonos = 0
   SET ORDER TO BANC01
   SEEK XsNroMes + XsCodCta
   IF ! FOUND()
      GsmsgErr = "Cuenta no Registrado su extracto bancario"
      DO LIB_MERR WITH 99
      UltTecla = 0
      LOOP
   ENDIF
   SET ORDER TO BANC02
   SEEK "B"+XsNroMes + XsCodCta
   IF FOUND()
      If ! ALRT("Conciliaci¢n ya Realizada")
         UltTecla = 0
         LOOP
      ENDIF
   ENDIF
   @ 10,1 clear TO 19,78
   NumLin = 10
   XfSdoIni = SdoIni
ENDDO
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVbline
PARAMETERS Contenido
Contenido = DTOC(FchRef)+" "+NroRef+" "
Contenido = Contenido + IIF(TpoMov='D',TRAN(Import,"999,999,999.99")+SPACE(15),;
            SPACE(15)+TRAN(Import,"999,999,999.99"))+" "
Contenido = Contenido+MesCon+" "+CodOpe+" "+NroAst+" "+TRANSF(NroItm,"@Z ####")
Contenido = Contenido+" "+IIF(FlgEst="B","BANCO","LIBRO")
RETURN
******************
PROCEDURE CONCILIA
******************

SET ESCAPE ON
ON ESCAPE SUSPEND

DIMENSION AA(4)
*** Borramos los movimientos en libros no conciliados ***
? CHR(7)
WAIT "ANULANDO MOVIMIENTOS ANTERIORES .." NOWAIT WINDOW
II  =  0
AA(1) = "-"
AA(2) = "\"
AA(3) = "|"
AA(4) = "/"


SET ORDER TO BANC01
Llave =  XsNroMes+XsCodCta+"L"
SEEK LLAVE
DO WHILE Llave =  NroMes+CodCta+FLGEST .AND. ! EOF()
   II = II + 1
   IF II > 4
      II = 1
   ENDIF
   @ 22,75 SAY AA(II)
   SKIP
   EOFACT = EOF()
   REGACT = RECNO()
   SKIP -1
   IF RLOCK()
      DELETE
   ENDIF
   IF EOFACT
      EXIT
   ENDIF
   GOTO REGACT
ENDDO
Llave =  XsNroMes+XsCodCta+"l"
SEEK LLAVE
DO WHILE Llave =  NroMes+CodCta+FLGEST .AND. ! EOF()
   II = II + 1
   IF II > 4
      II = 1
   ENDIF
   @ 22,75 SAY AA(II)
   SKIP
   EOFACT = EOF()
   REGACT = RECNO()
   SKIP -1
   IF RLOCK()
      DELETE
   ENDIF
   IF EOFACT
      EXIT
   ENDIF
   GOTO REGACT
ENDDO
*** Anulamos todo conciliaci¢n anterior **
? CHR(7)
WAIT "DESMARCANDO CONCILIACIONES ANTERIORES .." NOWAIT WINDOW
Llave =  XsNroMes+XsCodCta
SEEK LLAVE
DO WHILE Llave =  NroMes+CodCta .AND. ! EOF()
   II = II + 1
   IF II > 4
      II = 1
   ENDIF
   @ 22,75 SAY AA(II)
   IF REC_LOCK(5)
      REPLACE MesCie WITH ""
      REPLACE MesCon WITH ""
      REPLACE CodOpe WITH ""
      REPLACE NroAst WITH ""
      REPLACE Glodoc WITH ""
      REPLACE NroItm WITH 0
   ENDIF
   SKIP
ENDDO

SET ORDER TO BANC02
FOR zMes = _MES TO 13
   ZsNroMes = TRANSF(zMES,"@L ##")
   Llave =  "B"+ZsNroMes+XsCodCta
   SEEK LLAVE
   DO WHILE FOUND()
      II = II + 1
      IF II > 4
         II = 1
      ENDIF
      @ 22,75 SAY AA(II)
      IF REC_LOCK(5)
         REPLACE MesCie WITH ""
         REPLACE MesCon WITH ""
         REPLACE CodOpe WITH ""
         REPLACE NroAst WITH ""
         REPLACE Glodoc WITH ""
         REPLACE NroItm WITH 0
      ENDIF
      SEEK LLAVE
   ENDDO
NEXT


? CHR(7)
WAIT "CONCILIANDO CON MOVIMIENTOS ANTERIORES .." NOWAIT WINDOW
*** Buscamos movimiento no conciliados en meses pasados ***
@ 10,1 clear TO 19,78
NumLin = 10
MesAnt = _Mes - 1
IF MesAnt < 1
   MesAnt = 0
ENDIF
MesAnt = TRANSF(MesAnt,"@L ##")
Llave =  MesAnt+XsCodCta+"L"
*** buscar si lo no conciliado en el mes anterior
*** se puede conciliar con el reg. bancario de este mes
SELECT BANC
SET ORDER TO BANC01
SEEK Llave
DO WHILE Llave =  NroMes+CodCta+FlgEst .AND. ! EOF()
   II = II + 1
   IF II > 4
      II = 1
   ENDIF
   @ 22,75 SAY AA(II)
   LsMesCon = MesCon
   LsCodOpe = CodOpe
   LsNroAst = NroAst
   LiNroItm = NroItm
   LdFchRef = FchRef
   LsNroRef = NroRef
   LcTpoMov = TpoMov
   LfImport = IIF(TpoMov="D",Import,-Import)
   LsGloDoc = GloDoc
   RegAct1  = RECNO()
   EOFACT1  = EOF()
   IF ! FORMAS()
      SELECT BANC
      APPEND BLANK
      IF REC_LOCK(5)
         REPLACE MesCie WITH XsNroMes
         REPLACE NroMes WITH XsNroMes
         REPLACE CodCta WITH XsCodCta
         REPLACE FlgEst WITH "L"
         REPLACE FchRef WITH LdFchRef
         REPLACE NroRef WITH LsNroRef
         REPLACE TpoMov WITH LcTpoMov
         REPLACE Import WITH ABS(LfImport)
         REPLACE MesCon WITH LsMesCon
         REPLACE CodOpe WITH LsCodOpe
         REPLACE NroAst WITH LsNroAst
         REPLACE NroItm WITH LiNroItm
      ENDIF
   ENDIF
   IF NumLin >= 20
      SCROLL 10,1,19,78,1
      NumLin = NumLin - 1
   ENDIF
   Contenido = ""
   DO MOVbline with Contenido
   @ NumLin,2 SAY Contenido
   NumLin = NumLin + 1
   SET ORDER TO BANC01
   IF EOFACT1
      EXIT
   ENDIF
   GOTO REGACT1
   SKIP
ENDDO

**** Conciliando con los Movimientos Contables del mes ***
? CHR(7)
WAIT "CONCILIANDO CON MOVIMIENTOS DEL MES .." NOWAIT WINDOW
SELECT RMOV
SET ORDER TO RMOV03
Llave =  XsNroMes+XsCodCta
SEEK Llave
DO WHILE Llave =  NroMes+CodCta .and. ! EOF()
   II = II + 1
   IF II > 4
      II = 1
   ENDIF
   @ 22,75 SAY AA(II)
   LsMesCon = NroMes
   LsCodOpe = CodOpe
   LsNroAst = NroAst
   LiNroItm = NroItm
   LdFchRef = FchDOC
   LsNroRef = NroDoc
   LcTpoMov = TpoMov
   LsGlodoc = GloDoc
   IF CTAS->CodMon = 1
      LfImport = Import
   ELSE
      LfImport = ImpUsa
   ENDIF
   IF LfImport = 0
      SKIP
      LOOP
   ENDIF
   LfImport = IIF(TpoMov="D",LfImport,-LfImport)
   IF ! FORMAS()
      SELECT BANC
      APPEND BLANK
      IF REC_LOCK(5)
         REPLACE MesCie WITH XsNroMes
         REPLACE CodCta WITH XsCodCta
         REPLACE NroMes WITH XsNroMes
         REPLACE FlgEst WITH "L"
         REPLACE FchRef WITH LdFchRef
         REPLACE NroRef WITH LsNroRef
         REPLACE TpoMov WITH LcTpoMov
         REPLACE Import WITH ABS(LfImport)
         REPLACE MesCon WITH LsMesCon
         REPLACE CodOpe WITH LsCodOpe
         REPLACE Glodoc WITH LsGlodoc
         REPLACE NroAst WITH LsNroAst
         REPLACE NroItm WITH LiNroItm
      ENDIF
   ENDIF
   IF NumLin >= 20
      SCROLL 10,1,19,78,1
      NumLin = NumLin - 1
   ENDIF
   Contenido = ""
   DO MOVbline with Contenido
   @ NumLin,2 SAY Contenido
   NumLin = NumLin + 1
   SELECT RMOV
   SKIP
ENDDO

********************************************
*** buscar si lo no conciliado en bancos ***
*** no este en otro movimiento de bancos ***
********************************************
WAIT "CONCILIANDO ENTRE BANCOS .." NOWAIT WINDOW
Llave =  "B"+"  "+XsCodCta
SELECT BANC
SET ORDER TO BANC02
SEEK Llave
DO WHILE Llave =  FLGEST+MesCie+CodCta .AND. ! EOF()
   II = II + 1
   IF II > 4
      II = 1
   ENDIF
   @ 22,75 SAY AA(II)
   IF EMPTY(NroRef)
      SKIP
      LOOP
   ENDIF
   IF VAL(NROMES)>VAL(XsNroMes)
      SKIP
      LOOP
   ENDIF
   LsMesCon = NroMes
   LsCodOpe = "BCO"
   LsNroAst = "------"
   LiNroItm = NroItm
   LsNroRef = NroRef
   LdFchRef = FchRef
   LcTpoMov = "D"
   LsGloDoc = ""
   LfIMPORT = 0
   RegAct   = RECNO()
   EOFACT   = EOF()
   IF FORMAS()
      IF NumLin >= 20
         SCROLL 10,1,19,78,1
         NumLin = NumLin - 1
      ENDIF
      Contenido = ""
      DO MOVbline with Contenido
      @ NumLin,2 SAY Contenido
      NumLin = NumLin + 1
      IF EOFACT
         EXIT
      ENDIF
   ENDIF
   SET ORDER TO BANC02
   IF REGACT = 0
      SEEK LLAVE
   ELSE
      GOTO REGACT
   ENDIF
   REGANT = RECNO()
   SKIP
ENDDO

********************************************
*** Varios de Bancos contra varios de    ***
*** Libros                               ***
********************************************
WAIT "CONCILIANDO ENTRE MOVIMIENTOS MULTIPLES .." NOWAIT WINDOW
Llave =  "L"+XsNroMes+XsCodCta
SELECT BANC
SET ORDER TO BANC02
SEEK Llave
DO WHILE Llave =  FlgEst+MesCie+CodCta .AND. ! EOF()
   LsMesCon = MesCon
   LsCodOpe = CodOpe
   LsNroAst = NroAst
   LiNroItm = NroItm
   LdFchRef = FchRef
   LsNroRef = NroRef
   LcTpoMov = TpoMov
   LsGlodoc = GloDoc
   LfImport = 0
   RegAct   = RECNO()
   *** Buscando en libros ***
   xLLave   = LLave+LsNroRef
   DO WHILE xLlave = FlgEst+MesCie+CodCta+NroRef .AND. ! EOF()
      LfImport = LfImport + IIF(TPOMOV="D",IMPORT,-IMPORT)
      SKIP
   ENDDO
   IF ! EMPTY(LsNroREF)
      RegActfin = recno()
      EOFFIN = EOF()
      zLlave =  "B  "+XsCodCta+LsNroRef
      SEEK zLLave
      DO WHILE zLlave =  FlgEst+MesCie+CodCta+NroRef .AND. ! EOF()
         IF VAL(NROMES)<=VAL(XsNroMes)
            LfImport = LfImport - IIF(TPOMOV="D",IMPORT,-IMPORT)
         ENDIF
         SKIP
      ENDDO
      IF ABS(LfImport) < .01
         DO ACTUALIZA
      ENDIF
      IF EOFFIN
         EXIT
      ELSE
         GOTO REGACTFIN
      ENDIF
      IF NumLin >= 20
         SCROLL 10,1,19,78,1
         NumLin = NumLin - 1
      ENDIF
      Contenido = ""
      DO MOVbline with Contenido
      @ NumLin,2 SAY Contenido
      NumLin = NumLin + 1
   ENDIF
ENDDO
GsMsgErr = " Proceso Completado "
DO LIB_MERR WITH 99
RETURN
*******************
PROCEDURE ACTUALIZA
********************
SEEK xllave
DO WHILE FOUND()
   IF RLOCK()
      REPLACE FLGEST WITH "l"
   ENDIF
   SEEK xLLAVE
ENDDO
SEEK ZLLAVE
OK = .T.
DO WHILE OK .AND. FOUND()
   IF VAL(NROMES)<=VAL(XsNroMes)
      IF RLOCK()
         REPLACE MesCie WITH XsNroMes
         REPLACE MesCon WITH LsMesCon
         REPLACE CodOpe WITH LsCodOpe
         REPLACE NroAst WITH LsNroAst
         REPLACE Glodoc WITH LsGlodoc
         REPLACE NroItm WITH LiNroItm
      ENDIF
    ELSE
       OK = .F.
       DO WHILE zLlave = FLGEST+MesCie+CodCta+NroRef .AND. ! EOF()
          IF VAL(NROMES)<=VAL(XsNroMes)
             OK = .T.
             EXIT
          ENDIF
          SKIP
       ENDDO
    ENDIF
   SEEK ZLLAVE
ENDDO
RETURN

****************
PROCEDURE FORMAS
****************
ULTREG = RECNO()
SELECT BANC
SET ORDER TO BANC02
IF ! EMPTY(LsNroRef)
   zLlave = "B"+SPACE(2)+XsCodCta+LsNroRef
   SEEK zllave
   ULTREG = RECNO()
   EOFREG = EOF()
   ZfIMPORT = 0
   DO WHILE zLlave = FLGEST+MesCie+CodCta+NroRef .AND. ! EOF()
      IF VAL(NROMES)<=VAL(XsNroMes)
         ZfImport = ZfImport + IIF(TPOMOV="D",Import,-Import )
      ENDIF
      SKIP
   ENDDO
   REGACT = RECNO()
   EOFACT = EOF()
   IF ABS( ZfImport - LfImport ) > 0.01
      RETURN .F.
    ENDIF
    SEEK zllave
    ZfIMPORT = 0
    OK = FOUND()
    DO WHILE OK
       IF VAL(NROMES)<=VAL(XsNroMes)
          IF RLOCK()
             REPLACE MesCie WITH XsNroMes
             REPLACE MesCon WITH LsMesCon
             REPLACE CodOpe WITH LsCodOpe
             REPLACE NroAst WITH LsNroAst
             REPLACE Glodoc WITH LsGlodoc
             REPLACE NroItm WITH LiNroItm
          ENDIF
          SEEK zLLave
          OK = FOUND()
       ELSE
          OK = .F.
          DO WHILE zLlave = FLGEST+MesCie+CodCta+NroRef .AND. ! EOF()
             IF VAL(NROMES)<=VAL(XsNroMes)
                OK = .T.
                EXIT
             ENDIF
             SKIP
          ENDDO
          IF OK
             LOOP
          ENDIF
       ENDIF
    ENDDO
    IF ! EOFREG
       GOTO ULTREG
    ENDIF
    RETURN .T.
ENDIF
***** Buscamos igual fecha ****
zLlave = "B"+SPACE(2)+XsCodCta
SEEK zLlave
DO WHILE FLGEST+MESCIE+CODCTA+TpoMov = zLlave .AND. ! EOF()
   IF Import = LfImport .AND. VAL(NROMES)<=VAL(XsNroMes)
      IF FchRef = LdFchRef .AND. TPOMOV=LCTPOMOV
         IF RLOCK()
            REPLACE MesCie WITH XsNroMes
            REPLACE MesCon WITH LsMesCon
            REPLACE CodOpe WITH LsCodOpe
            REPLACE NroAst WITH LsNroAst
            REPLACE Glodoc WITH LsGlodoc
            REPLACE NroItm WITH LiNroItm
         ENDIF
         RETURN .T.
      ENDIF
   ENDIF
   SKIP
ENDDO
RETURN .F.
