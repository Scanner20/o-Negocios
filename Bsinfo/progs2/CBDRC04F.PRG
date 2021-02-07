********************************************************************************
* Progrma       : CBDRC04f.PRG                                                 *
* Objeto        : BALANCE DE CUENTA CORRIENTE                                  *
* Actualizaci¢n :   /  /                                                       *
********************************************************************************
cTit1 = GsNomCia
cTit2 = MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "Reporte de Cuentas por Proyecto"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
@  9,10 FILL  TO 22,68      COLOR W/N
@  8,11 CLEAR TO 21,69
@  8,11       TO 21,69


SELECT 6
USE TEMPOR    ALIAS TEMPO   EXCLU
IF ! USED(6)
   CLOSE DATA
   RETURN
ENDIF
ZAP
INDEX ON CodRef+CodCta+NroMes+CodOpe+NroAst  TAG TEMPO

SELECT 5
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF ! USED(5)
   CLOSE DATA
   RETURN
ENDIF

SELECT 4
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF

SELECT 3
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF

SELECT 2
USE CBDVMOVM ORDER VMOV05 ALIAS VMOV
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF

SELECT 1
USE CBDRMOVM ORDER RMOV01 ALIAS RMOV
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF

*** EXCLUIMOS LOS MOVMIENTOS EXTRA-CONTABLES ****
SELECT RMOV
SET FILTER TO LEFT(CODOPE,1)<>"9"
**********************************************************************
XiCodMon = 1
XsNroMes = TRANSF(_MES,"@L ##")
XsClfAux = SPACE(LEN(ClfAux))
XsCodAux = SPACE(LEN(CodAux))
XsCodCt1 = SPACE(LEN(CodCta))
XsCodCt2 = SPACE(LEN(CodCta))
XiTpoMov = 1
XsCodRe1 = SPACE(LEN(CTAS->CodRef))
XsCodRe2 = SPACE(LEN(CTAS->CodRef))
XsNomAu1 = SPACE(LEN(AUXI->NomAux))
XsNomAu2 = SPACE(LEN(AUXI->NomAux))
XdFecha1 = DATE()
XdFecha2 = DATE()
XdFchAs1 = DATE()
XdFchAs2 = DATE()
UltTecla = 0
i        = 1
TAux     = ''

@ 10,13 SAY "Del Proyecto  : "
@ 12,13 SAY "De Cuenta     : "
@ 13,13 SAY " A Cuenta     : "
@ 14,13 SAY "De Fecha      : "
@ 15,13 SAY " A Fecha      : "

DO LIB_MTEC WITH 7
DO WHILE ! INLIST(UltTecla,Escape,F10,CtrlW)
   DO CASE
      CASE i = 1
         XsClfAux = "DIV"
         SELE AUXI
         @ 10,30 GET XsCodRe1 PICTURE "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !CbdBusca("AUXI")
             * XsCodRe1 = LEFT(AUXI->CodAux,LEN(XsCodRe1))
               CLOSE DATA
               RETURN
            ENDIF
         ENDIF
        *IF !SEEK(XsClfAux+XsCodRe1,"AUXI") .AND. !EMPTY(XsCodRe1)
        *   UltTecla = 0
        *   CLOSE DATA
        *   RETURN
        *ENDIF
         XsCodRe1 = LEFT(AUXI->CodAux,LEN(XsCodRe1))
         XsNomAu1=LEFT(AUXI.NomAux,30)
         @ 10,30 SAY XsCodRe1
         @ 10,35 SAY LEFT(AUXI.NomAux,30)
      CASE I = 2
         SELECT CTAS
         @ 12,30 GET XsCodCt1 PICT REPLICATE("9",LEN(XsCodCt1))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCt1)
            IF ! CBDBUSCA("CTAS")
               I = 1
               LOOP
            ENDIF
            XsCodCt1 = CTAS->CodCta
         ENDIF
         @ 12,30 SAY XsCodCt1
         SEEK XsCodCt1
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 12,30 SAY CTAS->NomCta    PICT "@S25"
      CASE I = 3
         SELECT CTAS
         @ 13,30 GET XsCodCt2 PICT REPLICATE("9",LEN(XsCodCt2))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCt2)
            IF ! CBDBUSCA("CTAS")
               I = 1
               LOOP
            ENDIF
            XsCodCt2 = CTAS->CodCta
         ENDIF
         @ 13,30 SAY XsCodCt2
         SEEK XsCodCt2
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 13,30 SAY CTAS->NomCta    PICT "@S25"
      CASE I = 4
         SELECT CTAS
         @ 14,30 GET XdFchAs1 PICT "@E"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @ 14,30 SAY XdFchAs1 PICT "@E"
      CASE I = 5
         SELECT CTAS
         @ 15,30 GET XdFchAs2 PICT "@E"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            EXIT
         ENDIF
         @ 15,30 SAY XdFchAs2 PICT "@E"
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5,5,i)
   i = IIF(i<1,1,i)
ENDDO
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF

*-------*
DO CARGA
*-------*
SELE VMOV
SET ORDE TO VMOV01
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
SELE TEMPO
go top
xWhile = .T.
xFor   = .T.
sNomRep = "CBDRC04F"
Largo  = 66
IniPrn = [_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3]
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
RETURN

***************
PROCEDURE CARGA
***************
SELECT RMOV
Cancelar  = .F.
IF EMPTY(XsCodCt1)
   XsCodCt1 = [10401]
ENDIF
LdFecha = DTOS(CTOD('  /  /  '))
DO CASE
   CASE DTOS(XdFchAs1)=LdFecha .and. DTOS(XdFchAs2)#LdFecha
       TstLin = "DTOS(FchDoc)<=DTOS(XdFchAs2)"
   CASE DTOS(XdFchAs1)#LdFecha .and. DTOS(XdFchAs1)=LdFecha
       TstLin = "DTOS(FchDoc)>=DTOS(XdFchAs1)"
   CASE DTOS(XdFchAs1)=LdFecha .and. DTOS(XdFchAs1)=LdFecha
       TstLin = ".T."
   CASE DTOS(XdFchAs1)#LdFecha .and. DTOS(XdFchAs1)#LdFecha
       TstLin = "DTOS(FchDoc)>=DTOS(XdFchAs1).AND.DTOS(FchDoc)<=DTOS(XdFchAs2)"
ENDCASE

IF !EMPTY(XsCodRe1)
   TstLin1 =[RMOV.CodRef=XsCodRe1]
ELSE
   TstLin1 = [.T.]
ENDIF

* Llave = XsCodCt1
* SEEK Llave
* IF ! FOUND()
*    IF RECNO(0) > 0 AND RECNO(0) < RECCO()
*       GOTO RECNO(0)
*       IF DELETED()
*          SKIP
*       ENDIF
*    ELSE
*       GsMsgErr = "No existen registros a Listar"
*       DO LIB_MERR WITH 99
*       CLOSE DATA
*       RETURN
*    ENDIF
* ENDIF
* DO WHILE CodCta <= XsCodCt2 .AND. !EOF() .AND. !Cancelar
*    IF !(&TstLin.)
*       SKIP
*       LOOP
*    ENDIF
*    IF !(&TstLin1.)
*       SKIP
*       LOOP
*    ENDIF
*    SELE TEMPO
*    APPEND BLANK
*    IF RLOCK()
*       REPLACE CodRef WITH RMOV.CodRef
*       REPLACE CodCta WITH RMOV.CodCta
*       REPLACE NroMes WITH RMOV.NroMes
*       REPLACE CodOpe WITH RMOV.CodOpe
*       REPLACE NroAst WITH RMOV.NroAst
*       REPLACE FchDoc WITH RMOV.FchDoc
*       REPLACE NroDoc WITH RMOV.NroDoc
*       REPLACE ClfAux WITH RMOV.ClfAux
*       REPLACE CodAux WITH RMOV.CodAux
*       REPLACE CodMon WITH RMOV.CodMon
*       REPLACE Import WITH RMOV.Import
*       REPLACE Impusa WITH RMOV.Impusa
*       REPLACE GloDoc WITH RMOV.GloDoc
*       REPLACE GloDoc WITH RMOV.GloDoc
*       REPLACE TpoMov WITH RMOV.TpoMov
*       UNLOCK
*    ENDIF
*    SELE RMOV
*    SKIP
*    Cancelar = ( INKEY() = Escape )
* ENDDO
* RETURN

  SELE VMOV
  Llave = XsCodCt1
  SEEK Llave
  IF ! FOUND()
     IF RECNO(0) > 0 AND RECNO(0) < RECCO()
        GOTO RECNO(0)
        IF DELETED()
           SKIP
        ENDIF
     ELSE
        GsMsgErr = "No existen registros a Listar"
        DO LIB_MERR WITH 99
        CLOSE DATA
        RETURN
     ENDIF
  ENDIF
  DO WHILE VMOV.CtaCja <= XsCodCt2 .AND. !EOF() .AND. !Cancelar
     SELE RMOV
     SEEK VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst
     IF FOUND()
        DO WHILE !EOF() .AND. (RMOV.NroMes+RMOV.CodOpe+RMOV.NroAst)=(VMOV.NroMes+VMOV.CodOpe+VMOV.NroAst)
           IF !(&TstLin.)
              SKIP
              LOOP
           ENDIF
           IF !(&TstLin1.)
              SKIP
              LOOP
           ENDIF
           SELE TEMPO
           APPEND BLANK
           IF RLOCK()
              REPLACE CodRef WITH RMOV.CodRef
              REPLACE CodCta WITH VMOV.CtaCja
              REPLACE NroMes WITH RMOV.NroMes
              REPLACE CodOpe WITH RMOV.CodOpe
              REPLACE NroAst WITH RMOV.NroAst
              REPLACE FchDoc WITH RMOV.FchDoc
              REPLACE NroDoc WITH RMOV.NroDoc
              REPLACE ClfAux WITH RMOV.ClfAux
              REPLACE CodAux WITH RMOV.CodAux
              REPLACE CodMon WITH RMOV.CodMon
              REPLACE Import WITH RMOV.Import
              REPLACE Impusa WITH RMOV.Impusa
              REPLACE GloDoc WITH RMOV.GloDoc
              REPLACE GloDoc WITH RMOV.GloDoc
              REPLACE TpoMov WITH RMOV.TpoMov
              UNLOCK
           ENDIF
           SELE RMOV
           SKIP
           Cancelar = ( INKEY() = Escape )
        ENDDO
     ENDIF
     SELE VMOV
     SKIP
     Cancelar = ( INKEY() = Escape )
  ENDDO
  RETURN
