**************************************************************************
*  Nombre    : CbdAnual.PRG                                              *
*  Autor     : Jorge Mieses 02/01/95                                     *
*  Objeto    : Inicio Anual                                              *
**************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CIERRE DE OPERACIONES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
@  7,08 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  8,08 SAY '³                     I M P O R T A N T E                     ³'
@  9,08 SAY '³                                                             ³'
@ 10,08 SAY '³    Este proceso tiene por finalidad preparar los archivos   ³'
@ 11,08 SAY '³   del  sistema para comenzar a procesar la informacion de   ³'
@ 12,08 SAY '³   un nuevo a¤o contable.                                    ³'
@ 13,08 SAY '³   Consiste en transferir los saldos contables y movimien-   ³'
@ 14,08 SAY '³   tos de cuenta corriente a otro directorio de un nuevo     ³'
@ 15,08 SAY '³   a¤o contable.                                             ³'
@ 16,08 SAY '³   SOLO deber  efectuarse al FINALIZAR UN A¥O CONTABLE.      ³'
@ 17,08 SAY '³     Antes de realizar este proceso verifique que todos      ³'
@ 18,08 SAY '³   los balances esten correctos.                             ³'
@ 19,08 SAY '³                      < C >  - Continuar                     ³'
@ 20,08 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
*
GsMsgKey = "[Esc] Cancelar Proceso        [C] Iniciar proceso"
DO LIB_Mtec WITH 99
************************************************************************
* Pide Confirmaci¢n de ingreso ******
************************************************************************
FinTecla = CHR(Escape)+"cC"
UltTecla = 0
DO WHILE ! CHR(UltTecla)$FinTecla
   UltTecla = INKEY(0)
   UltTecla = IIF(UltTecla >0 , UltTecla , 0 )
   IF UltTecla = Escape
      CLOSE DATA
      RETURN
   ENDIF
ENDDO
**** directorio del A¥O que sigue
DO GenerAper
CLOSE DATA
RETURN
RETURN
************************************************************************
PROCEDURE GenerAper
*******************
DirNew = PATHDEF+"\CIA"+GsCodCia+"\C"+STR(_Ano+1,4,0)
DirAct = SYS(2003)
**** TRATANDO DE CREAR EL DIRECTORIO *****
@ 19,10 SAY ""
!MKDIR &DirNew > NULL
***** Copiando los archivos que no existan en este nuevo directorio ****
*** Base de datos ****
@  8,09 CLEAR TO 19,69
cArcAct = sys(2000,DirAct+"\cbd*.dbf")
DO WHILE ! EMPTY(cArcAct)
   cArcNEW = DirNew+"\"+cArcAct
   IF ! FILE(cArcNEW)
      SCROLL 8,09,19,69,1
      @ 19,10 SAY "Creando el archivo "+cArcNew+"..."
      USE &cArcAct
      DO CASE
         CASE cArcAct = "CBDTOPER.DBF"
            COPY TO (cArcNEW) WITH CDX
            USE &cArcNEW
            REPLACE ALL NDOC00 WITH 1
            REPLACE ALL NDOC01 WITH 1
            REPLACE ALL NDOC02 WITH 1
            REPLACE ALL NDOC03 WITH 1
            REPLACE ALL NDOC04 WITH 1
            REPLACE ALL NDOC05 WITH 1
            REPLACE ALL NDOC06 WITH 1
            REPLACE ALL NDOC07 WITH 1
            REPLACE ALL NDOC08 WITH 1
            REPLACE ALL NDOC09 WITH 1
            REPLACE ALL NDOC10 WITH 1
            REPLACE ALL NDOC11 WITH 1
            REPLACE ALL NDOC12 WITH 1
            REPLACE ALL NDOC13 WITH 1
         CASE cArcAct = "CBDMCTAS.DBF"
            COPY TO (cArcNEW) WITH CDX
         CASE cArcAct = "CBDTCIER.DBF"
            COPY STRUCTU TO (cArcNEW) WITH CDX
            USE &cArcNEW
            DO WHILE RECCOUNT() < 14
               APPEND BLANK
            ENDDO
         OTHER
            COPY STRUCTU TO (cArcNEW) WITH CDX
      ENDCASE
      CLOSE DATA
   ENDIF
   cArcAct = sys(2000,DirAct+"\cbd*.dbf",1)
ENDDO

**** ARCHIVOS DE MEMORIA *****************************
cArcAct = sys(2000,DirAct+"\CBD*.MEM")
DO WHILE ! EMPTY(cArcAct)
   cArcNEW = DirNew+"\"+cArcAct
   IF ! FILE(cArcNEW)
      SCROLL 8,09,19,69,1
      @ 19,10 SAY "Creando el archivo "+cArcNew+"..."
      COPY FILE &cArcAct TO &cArcNEW
   ENDIF
   cArcAct = sys(2000,DirAct+"\CBD*.MEM",1)
ENDDO

cArcAct = sys(2000,DirAct+"\CJA*.MEM")
DO WHILE ! EMPTY(cArcAct)
   cArcNEW = DirNew+"\"+cArcAct
   IF ! FILE(cArcNEW)
      SCROLL 8,09,19,69,1
      @ 19,10 SAY "Creando el archivo "+cArcNew+"..."
      COPY FILE &cArcAct TO &cArcNEW
   ENDIF
   cArcAct = SYS(2000,DirAct+"\CJA*.MEM",1)
ENDDO
****** ACTUALIZANDO CONCIALIACION BANCARIA **********
* cArcAct = "CBDBANCO.DBF"
* cArcNEW = DirNew+"\"+cArcAct
* cArcTmp = PathUser+SYS(3)
* IF FILE(cArcNEW)
*    SCROLL 8,09,19,69,1
*    @ 19,10 SAY "Actualizando conciliaci¢n Bancaria...."
*    USE CBDBANCO
*    COPY TO &cArcTmp FOR NROMES =  "12" .AND. (FLGEST$"Ll" .OR. EMPTY(MesCie))
*    USE &cArcTmp
*    REPLACE ALL NROMES WITH "00"
*    USE &cArcNEW
*    DELETE ALL FOR NROMES = "00"
*    APPEND FROM &cARCTMP
*    DELETE FILE &cARCTMP
*    CLOSE DATA
* ENDIF

****** ACTUALIZANDO ARCHIVOS DE PARTIDAS PARA REI *******
cArcAct = "CBDMPART.DBF"
cArcNEW = DirNew+"\"+cArcAct
IF FILE(cArcNEW)
   SCROLL 8,09,19,69,1
   @ 19,10 SAY "Actualizando Partidas para el ajuste por Inflaci¢n ..."
   USE CBDMPART
   COPY TO &cArcTmp FOR EMPTY(FEC_CESE) .OR. YEAR(FEC_CESE) >_Ano
   **** actualizando los Importes de Inicio de A¥O
   SELE 2
   USE CBDRPART ORDER RPAR01 ALIAS RPAR
   SELE 1
   USE &cArcTmp ALIAS TMP
   DO WHILE ! EOF()
      Llave = CodCta+CodPar+"12"
      =SEEK(Llave,"RPAR")
      REPLACE Dep_ACUM   WITH RPAR->DPHISA
      REPLACE Dep_ACUMEX WITH RPAR->DPHISAEX
      REPLACE AJU_ACTI   WITH RPAR->VALAJT
      REPLACE AJU_DEPR   WITH RPAR->DPAJTA
      SELECT TMP
      SKIP
   ENDDO
   CLOSE DATA
   USE &cArcNEW
   DELETE ALL FOR YEAR(FEC_INGR) <= _Ano
   APPEND FROM &cARCTMP
   DELETE FILE &cARCTMP
   CLOSE DATA
ENDIF

****** ACTUALIZANDO SALDOS CONTABLES ********************
SCROLL 8,09,19,69,1
@ 19,10 SAY "Actualizando los Movimientos Contables ..."
SELECT 1
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
SELECT 2
USE CBDACMCT ORDER ACCT01 ALIAS ACCT
SELECT 3
USE CBDVMOVM ORDER VMOV01 ALIAS VMOV
SELECT 4
USE CBDRMOVM ORDER RMOV01 ALIAS RMOV
COPY STRU TO &cArcTmp
SELECT 5
USE &cArcTmp ALIAS TMP
SELECT 6
cArcNEW = DirNew+"\CBDTOPER"
USE &cArcNEW ORDER OPER01 ALIAS OPER

DO APERTURA

CLOSE DATA
RETURN

************************************************************************
* Generando en archivo auxiliar el asiento de apertura
************************************************************************
PROCEDURE Apertura
******************
SCROLL 8,09,19,69,1
SELECT ACCT
SET ORDER TO ACCT02
GOTO TOP
XnNroItm = 0
XsCodOpe = "000"
TnSdoNac = 0
TnSdoUsa = 0
DO WHILE ! EOF() .AND. CodCta < "60"
   LsCodCta = CodCta
   LsCodRef = CodRef
   SELECT ACCT
   SdoNac = 0.0
   SdoUsa = 0.0
   DO WHILE ! EOF() .AND. LsCodCta+LsCodRef = CodCta+CodRef
      IF NroMes < '13'
         SdoNac = SdoNac + DbeNac - HbeNac
         SdoUsa = SdoUsa + DbeExt - HbeExt
      ENDIF
      SKIP
   ENDDO
   SELECT CTAS
   SEEK LsCodCta
   IF AftMOV = 'S' .AND. !(SdoNac= 0 .AND. SdoUsa = 0)
      @ 19,10 SAY LsCodCta+" "+NomCta
     *IF CTAS->PIDAUX="S" AND LEFT(CTAS.CODCTA,2)#"10"
      if ctas->pidaux=[S] and (inlist(ctas.codcta,[10900200],[10900900],[10900901]) or left(ctas.codcta,2)#[10])
         DO CtaCte
         SELECT ACCT
         DO WHILE ! EOF() .AND. LsCodCta = CodCta
            SKIP
         ENDDO
      ELSE
         SELECT TMP
         APPEND BLANK
         XnNroItm = XnNroItm + 1
         REPLACE NroMes WITH "00"
         REPLACE CodOpe WITH XsCodOpe
         REPLACE NroAst WITH "000001"
         REPLACE NroItm WITH XnNroItm
         REPLACE CodCta WITH LsCodCta
         REPLACE CodRef WITH LsCodRef
         REPLACE CodMon WITH 1
         REPLACE TpoCmb WITH 1
         REPLACE FchDoc WITH CTOD("31/12/"+STR(_ANO,4,0))
         DO CASE
            CASE SdoNac > 0
               REPLACE TpoMov WITH "D"
               REPLACE Import WITH SdoNac
               REPLACE ImpUsa WITH SdoUsa
            CASE SdoNac < 0
               REPLACE TpoMov WITH "H"
               REPLACE Import WITH -SdoNac
               REPLACE ImpUsa WITH -SdoUsa
            CASE SdoUsa > 0
               REPLACE TpoMov WITH "D"
               REPLACE Import WITH SdoNac
               REPLACE ImpUsa WITH SdoUsa
            CASE SdoUsa < 0
               REPLACE TpoMov WITH "H"
               REPLACE Import WITH -SdoNac
               REPLACE ImpUsa WITH -SdoUsa
         ENDCASE
         TnSdoNac = TnSdoNac + SdoNac
         TnSdoUsa = TnSdoUsa + SdoUsa
      ENDIF
   ENDIF
   SELECT ACCT
ENDDO

**** Descargando en la cuenta de acumulados ***
LsCodCta = "59101"
SdoNac   = -TnSdoNac
SdoUsa   = -TnSdoUsa
SELECT TMP
APPEND BLANK
XnNroItm = XnNroItm + 1
REPLACE NroMes WITH "00"
REPLACE CodOpe WITH XsCodOpe
REPLACE NroAst WITH "000001"
REPLACE NroItm WITH XnNroItm
REPLACE CodCta WITH LsCodCta
REPLACE FchDoc WITH CTOD("31/12/"+STR(_ANO,4,0))
REPLACE CodMon WITH 1
REPLACE TpoCmb WITH 1
IF SdoNac > 0
   REPLACE TpoMov WITH "D"
   REPLACE Import WITH SdoNac
   REPLACE ImpUsa WITH SdoUsa
ELSE
   REPLACE TpoMov WITH "H"
   REPLACE Import WITH -SdoNac
   REPLACE ImpUsa WITH -SdoUsa
ENDIF
TnSdoNac = TnSdoNac + SdoNac
TnSdoUsa = TnSdoUsa + SdoUsa
SCROLL 8,09,19,69,1
@ 19,10 SAY "Grabando Movimientos de Apertura ..."

SELECT ACCT
cArcNEW = DirNew+"\CBDACMCT"
USE &cArcNEW ORDER ACCT01 ALIAS ACCT && EXCL

SELECT VMOV
cArcNEW = DirNew+"\CBDVMOVM"
USE &cArcNEW ORDER VMOV01 ALIAS VMOV && EXCL

SELECT RMOV
cArcNEW = DirNew+"\CBDRMOVM"
USE &cArcNEW ORDER RMOV01 ALIAS RMOV && EXCL

SELEC OPER
SEEK XsCodOPe
IF ! FOUND()
   APPEND BLANK
   DO WHILE !RLOCK()
   ENDDO
   REPLACE CodOpe WITH XsCodOPe
   REPLACE NDoc00 with 2
ELSE
   DO WHILE !RLOCK()
   ENDDO
ENDIF
REPLACE NomOpe WITH "Apertura Contable"
REPLACE CodMon WITH 4
unlock

SELECT VMOV
Llave = "00"+XsCodOpe+"000001"
SEEK Llave
IF ! FOUND()
   APPEND BLANK
   DO WHILE !RLOCK()
   ENDDO
   REPLACE NroMes WITH "00"
   REPLACE CodOpe WITH XsCodOpe
   REPLACE NroAst WITH"000001"
ELSE
   DO WHILE !RLOCK()
   ENDDO
ENDIF

REPLACE FchAst WITH CTOD("31/12/"+STR(_ANO,4,0))
REPLACE CodMon WITH 1
REPLACE TpoCmb WITH 0
REPLACE NotAst WITH "ASIENTO AUTOMATICO DE APERTURA"
REPLACE ChkCta WITH 0
REPLACE NroItm WITH XnNroItm
REPLACE DbeNac WITH 0
REPLACE HbeNac WITH 0
REPLACE DbeUsa WITH 0
REPLACE HbeUsa WITH 0

******* ANULANDO EL MOVIMIENTO ANTERIOR **********
SELECT RMOV
SEEK LLAVE
DO WHILE ! EOF() .AND. NroMes+CodOPe+NroAst = Llave
   DO WHILE !RLOCK()
   ENDDO
   DO CBDACTCT WITH  CodCta , CodRef , 0 , TpoMov , -Import , -ImpUsa
   DELETE
   UNLOCK
   SKIP
ENDDO
*
sele acct
set order to acct01
seek [ 0]
delete rest while nromes = [ 0]
*
**** ACTUALIZANDO LOS NUEVOS SALDOS ****
SELECT TMP
GOTO TOP
DO WHILE ! EOF()
   SCATTER MEMVAR
   SELECT RMOV
   APPEND BLANK
   DO WHILE !RLOCK()
   ENDDO
   GATHER MEMVAR
   REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(CodCta))
   DO CBDACTCT WITH  CodCta , CodRef , 0 , TpoMov , Import , ImpUsa
   IF RMOV->TpoMov = 'D'
      REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+Import
      REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+ImpUsa
   ELSE
      REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+Import
      REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+ImpUsa
   ENDIF
   UNLOCK
   SELECT TMP
   SKIP
ENDDO
CLOSE DATA

SCROLL 8,09,19,69,1
@ 19,10 SAY "Registrando el nuevo a¤o............"

USE CBDTANOS
REPLACE ALL CIERRE WITH .T.
LOCATE FOR PERIODO = _ANO+1
IF ! FOUND()
   APPEND BLANK
   REPLACE PERIODO WITH _ANO+1
ENDIF
REPLACE CIERRE WITH .F.
SCROLL 8,09,19,69,1
@ 19,10 SAY "Proceso Concluido..................."
CLOSE DATA
RETURN
************************************************************************
* Copia a un archivo auxiliar todos los movientos pendientes
************************************************************************
PROCEDURE CtaCte
****************
SELECT RMOV
*** SORTEADO POR COD. DE CUENTA *****
SET ORDER TO RMOV06
SEEK LsCodCta
DO WHILE ! EOF() .AND. CodCta = LsCodCta
	IF EMPTY(nroast)
		SKIP 
		LOOP
	ENDIF
   SdoNac   = 0
   SdoUsa   = 0
   XsGloDoc = GloDoc
   SCATTER MEMVAR
   Llave  = CodCta+CodAux+NroDoc
   *
   *if codcta = [42300200] .and. nrodoc=[090216-97B]
   *   set step on
   *endif
   *
   DO WHILE CodCta+CodAux+NroDoc = LLAVE .AND. ! EOF()
      SdoNac = SdoNac + IIF(TpoMov=[D],IMPORT,-1*Import)
      SdoUsa = SdoUsa + IIF(TpoMov=[D],IMPUSA,-1*ImpUsa)
      SKIP
   ENDDO
   IF ! (SdoNac = 0)
      SELECT TMP
      APPEND BLANK
      GATHER MEMVAR
      XnNroItm = XnNroItm + 1
      REPLACE NroMes WITH "00"
      REPLACE CodOpe WITH XsCodOpe
      REPLACE NroAst WITH "000001"
      REPLACE NroItm WITH XnNroItm
      REPLACE CodCta WITH LsCodCta
      IF SEEK(NroMes+CodOpe+NroAst,"VMOV") AND EMPTY(XsGloDoc)
         XsGloDoc = VMOV->NotAst
      ENDIF
      REPLACE GloDoc WITH XsGloDoc
      REPLACE FchDoc WITH CTOD("31/12/"+STR(_ANO,4,0))
      DO CASE
         CASE SdoNac > 0
            REPLACE TpoMov WITH "D"
            REPLACE Import WITH SdoNac
            REPLACE ImpUsa WITH SdoUsa
         CASE SdoNac < 0
            REPLACE TpoMov WITH "H"
            REPLACE Import WITH -SdoNac
            REPLACE ImpUsa WITH -SdoUsa
         CASE SdoUsa > 0
            REPLACE TpoMov WITH "D"
            REPLACE Import WITH SdoNac
            REPLACE ImpUsa WITH SdoUsa
         CASE SdoUsa < 0
            REPLACE TpoMov WITH "H"
            REPLACE Import WITH -SdoNac
            REPLACE ImpUsa WITH -SdoUsa
      ENDCASE
      TnSdoNac = TnSdoNac + SdoNac
      TnSdoUsa = TnSdoUsa + SdoUsa
   ENDIF
   SELECT RMOV
ENDDO
SELECT ACCT
RETURN
