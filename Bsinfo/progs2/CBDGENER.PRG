**********************************************************************
*  Nombre        : cbdgener.prg
*  Sistema       : Contabilidad
*  Autor         : Jorge Mieses
*  Proposito     : Regenera Acumulados
*  Creacion      : 17/06/93
*  Actualizacion :
***************************************************************************
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "REGENERAR ACUMULADOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
NroDec   = 2
XsNroMes = TRANSF(_MES,"@L ##")
STORE 0 TO nImpNac,nImpUsa
** Abrimos areas a usar **
@  7,09 SAY 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@  8,09 SAY '³                    I M P O R T A N T E                    ³'
@  9,09 SAY '³                                                           ³'
@ 10,09 SAY '³   Este proceso tiene por finalidad de recalcular los   -  ³'
@ 11,09 SAY '³  importes acumulados por cuentas.                         ³'
@ 12,09 SAY '³                                                           ³'
@ 13,09 SAY '³   La apertura de archivos sera en forma exclusiva y   -   ³'
@ 14,09 SAY '³  deber  ser la unica TAREA que se efectue en el sistema   ³'
@ 15,09 SAY '³                                                           ³'
@ 16,09 SAY '³          Presione <<Enter>> para Continuar                ³'
@ 17,09 SAY '³                                                           ³'
@ 18,09 SAY '³            Presione <<Esc>> para Cancelar                 ³'
@ 19,09 SAY 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
@ 16,31 SAY 'Enter' COLOR SCHEME 7
@ 18,33 SAY 'Esc'   COLOR SCHEME 7
* Pide respuesta
UltTecla = 0
DO WHILE ! (UltTecla=Enter .OR. UltTecla=Escape)
   UltTecla=INKEY(0)
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
@ 9,10 CLEAR TO 18,67
GsMsgKey = "[Aperturando archivos]"
DO LIB_MTEC WITH 99
SELE 1
USE cbdmctas ORDER ctas01   ALIAS CTAS
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE cbdvmovm ORDER vmov01   ALIAS VMOV
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE cbdrmovm ALIAS RMOV
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 4
USE cbdacmct ALIAS ACCT
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF
DO LIB_MTEC WITH 11
VecOpc(1) = "Acumulado de todo el A¤o"
VecOpc(2) = "SOLO movimientos del mes"
VecOpc(3) = "Acumulado por cuenta de todo el A¤o"
VecOpc(4) = "SOLO movimientos del mes de una cuenta"
xElige1 = ELIGE(2,13,13,4)
IF LASTKEY()=Escape
   close data
   RETURN
ENDIF
SELECT CTAS
DO LIB_MSGS WITH 3
*** Anulando Movimientos del acumulado de cuentas *****
SELECT RMOV
SET TALK ON
SET TALK WINDOW
xCodCta = SPACE(2)
IF xElige1 > 2
   @ 13,13 say space(30)
   xCodCta = "10"
   @ 13,13 say "Cuenta a procesar  : " GET xCodCta pict "99"
   READ
   IF LASTKEY()=Escape
      close data
      RETURN
   ENDIF
   @ 13,13 say "                                   "
ENDIF

RESP = "S"
@ 13,13 say "Reconstruye indices (S/N) : " GET RESP pict "!"
READ
IF LASTKEY()=Escape
   close data
   RETURN
ENDIF
@ 13,13 say "                                   "
IF RESP = "S"
   SELE ACCT
   USE CBDACMCT ALIAS ACCT EXCLU
   SELE RMOV
   USE CBDRMOVM ALIAS RMOV EXCLU
   IF xElige1 = 1
      PACK
   ENDIF
   INDEX ON NROMES+CODCTA+CODREF+CODOPE+NROAST TAG RMOV03
ENDIF
SET ORDER TO RMOV03
SELECT ACCT
SET ORDER TO ACCT01
SET TALK OFF
cNroMes = STR(_MES,2,0)
WAIT "Anulando acumulandos anteriores" NOWAIT WINDOW
DO CASE
   CASE  xElige1=1
      SELE ACCT
      USE CBDACMCT ORDER ACCT01 ALIAS ACCT EXCLU


      nMesIni = 0
      nMesFin = 13
      ZAP
   CASE  xElige1=2
      nMesIni = _Mes
      nMesFin = _Mes
      SEEK cNroMes
      SCAN WHILE NroMes=cNroMes
         DO WHILE !RLOCK()
         ENDDO
         REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
         UNLOCK
      ENDSCAN
   CASE  xElige1=3
      nMesIni = 0
      nMesFin = 13
      FOR I= nMesIni TO nMesFin
          cNroMes = str(i,2,0)
          SEEK cNroMes+xCodCta
          SCAN WHILE NroMes=cNroMes .AND. CodCta = xCodCta
             DO WHILE !RLOCK()
             ENDDO
             REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
             UNLOCK
          ENDSCAN
      NEXT
   CASE  xElige1=4
      nMesIni = _Mes
      nMesFin = _Mes
      SEEK cNroMes+xCodCta
      SCAN WHILE NroMes=cNroMes .AND. CodCta = xCodCta
         DO WHILE !RLOCK()
         ENDDO
         REPLACE DbeNac WITH 0,DbeExt WITH 0,HbeNac WITH 0,HbeExt WITH 0
         UNLOCK
      ENDSCAN
ENDCASE
IF RESP = "S" .OR. xElige1=1
   INDEX ON NROMES+CODCTA+CODREF TAG ACCT01
ENDIF
WAIT "Acumulandos Saldos" NOWAIT WINDOW
SELECT RMOV
@ 17,18 CLEAR TO 21,63
@ 17,18       TO 21,63 PANEL
FOR I= nMesIni TO nMesFin
    cNroMes = TRANSF(i,"@L ##")
    @ 18,19 SAY PADC(MES(i,1),43)
    SEEK cNroMes+TRIM(xCodCta)
    DO WHILE ! EOF() .AND. NroMes = cNroMes .AND. CodCta = TRIM(xCodCta)
       LsCodCta = CodCta
       =SEEK(LsCodCta,"CTAS")
       @ 19,28 SAY "PROCESANDO CUENTA : "+LsCodCta
       @ 20,21 SAY PADC(TRIM(CTAS->NomCta),40)
       XX = " "
       DO WHILE ! EOF() .AND. NroMes+CodCta = cNroMes+LsCodCta
          @ 19,46 SAY XX
          XX = IIF(XX=" ",":"," ")
          IF ! CodOpe = "9"
             DO cbdactct with CodCta, CodRef, i, TpoMov , Import, ImpUsa
          ELSE
             DO cbdactec with CodCta, CodRef, i, TpoMov , Import, ImpUsa
          ENDIF
          SELECT RMOV
          SKIP
       ENDDO
    ENDDO
ENDFOR
CLOSE DATA
RETURN
