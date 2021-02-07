********************************************************************************
* Progrma       : CBDRB018.PRG                                                 *
* Objeto        : Analisis Clase 9 Por Tipo Gasto (ENTRE 2 FECHAS)             *
* Autor         : ROGER MORI TUESTA                                            *
* Creaci¢n      : 12/07/95                                                     *
********************************************************************************
*** Abrimos Bases ****
sele 4
use cbdvmovm order VMOV01 alias VMOV
if !used(4)
    close data
    return
endif

sele 3
use cbdmctas order CTAS01 alias CTAS
if !used(3)
    close data
    return
endif

sele 2
use cbdrmovm order rmov03 alias RMOV
if !used(2)
    close data
    return
endif

sele 1
use cbdmauxi order AUXI01 alias AUXI
if !used(1)
    close data
    return
endif

TMP1 = PATHUSER+SYS(3)
CREATE TABLE &TMP1 (CODCTA C(8)   , ;
                      NOM C(40)  ,;
                    NOMCTA C(40), ;
                    CODREF C(8)   , ;
                    FCHAST D      , ;
                    CODOPE C(3)   , ;
                    NROAST C(6)   , ;
                    GLODOC C(40)  , ;
                    TPOMOV C(1)   , ;
                    IMPORT N(14,2), ;
                    IMPUSA N(14,2)  )
USE

SELE 0
USE &TMP1 ALIAS BDA01 EXCLU
INDEX ON CODCTA+CODREF+NROAST TAG T01

TMP2 = PATHUSER+SYS(3)
CREATE TABLE &TMP2 (CODREF C(8) , G   C(1)   ,;
                                  NOM C(25)  ,;
                                  C90 N(14,2),;
                                  C91 N(14,2),;
                                  C92 N(14,2),;
                                  C93 N(14,2),;
                                  C94 N(14,2),;
                                  C95 N(14,2),;
                                  C96 N(14,2),;
                                  C97 N(14,2),;
                                  C98 N(14,2),;
                                  C99 N(14,2)  )
USE

SELE 0
USE &TMP2 ALIAS BDA02 EXCLU
INDEX ON G+CODREF TAG T02

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANALISIS CLASE 9 POR TIPO DE GASTO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
XiMesIni={}
XiMesFin={}
XiNroDig=1
XiNroDec=2

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE EL   : "
@ 12,24 SAY "HASTA EL   : "
*@ 13,24 SAY "DIGITOS    : "
*@ 14,24 SAY "DECIMALES  : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,38,2)
      CASE i = 2
         @ 11,38 GET XiMesIni  VALID (MONT(XiMesIni)=_MES) ;
                 ERROR "FECHA DEBE PERTENECER AL MES CONTABLE: "+TRANS(_MES,"@L ##")
         READ
         UltTecla = LASTKEY()
         XiMesFin = XiMesIni
      CASE i = 3
         @ 12,38 GET XiMesFin VALID (MONT(XiMesFin)=_MES AND XiMesFin>=XiMesIni) ;
                 ERROR "FECHA DEBE PERTENECER AL MES CONTABLE: "+TRANS(_MES,"@L ##")
         READ
         UltTecla = LASTKEY()
      CASE i = 4
      *  VecOpc(1)="2"
      *  VecOpc(2)="4"
      *  VecOpc(3)="8"
      *  VecOpc(4)="8 (S¢lo Totales)"
      *  XiNroDig= Elige(1,13,38,4)
      CASE i = 5
      *  @ 14,38 GET XiNroDec   PICTURE "9" RANGE 0,2
      *  READ
      *  UltTecla = LASTKEY()
      *  @ 14,38 SAY XiNroDec   PICTURE "9"
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 5 , i + 1, 5 )

      CASE UltTecla = Enter
         IF  i < 5
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   DELETE FILE &TMP1..dbf
   DELETE FILE &TMP1..CDX
   DELETE FILE &TMP2..dbf
   DELETE FILE &TMP2..CDX
   RETURN
ENDIF
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
*** Pantalla de datos  ***
SELE RMOV
SET RELATION TO NROMES+CODOPE+NROAST INTO VMOV
LLAVE = TRANS(_MES,"@L ##")+[9]
SEEK LLAVE
IF !FOUND()
   GSMSGERR = [NO EXISTEN REGISTROS A LISTAR]
   DO LIB_MERR WITH 99
   CLOSE DATA
   DELETE FILE &TMP1..dbf
   DELETE FILE &TMP1..CDX
   DELETE FILE &TMP2..dbf
   DELETE FILE &TMP2..CDX
   RETURN
ENDIF

@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
DO WHILE NROMES+CODCTA = LLAVE AND !EOF()
  IF  (XiMesIni<=VMOV->FCHAST AND VMOV->FCHAST <=XiMesFin)
       =SEEK([04 ]+TRIM(RMOV->CODREF),"AUXI")
      *=SEEK(NROMES+CODOPE+NROAST,    "VMOV")
       =SEEK(CODCTA,"CTAS")
       SELE BDA01
       ****DETALLES*******
       APPEND BLANK
       REPLACE CODCTA WITH RMOV->CODCTA
       REPLACE CODREF WITH RMOV->CODREF
       REPLACE NOM    WITH LEFT(AUXI->NOMAUX,40)
       REPLACE NOMCTA WITH LEFT(CTAS->NOMCTA,40)
       REPLACE TPOMOV WITH RMOV->TPOMOV
       REPLACE IMPORT WITH RMOV->IMPORT
       REPLACE IMPUSA WITH RMOV->IMPUSA
       REPLACE CODOPE WITH RMOV->CODOPE
       REPLACE NROAST WITH RMOV->NROAST
       REPLACE GLODOC WITH RMOV->GLODOC
       REPLACE FCHAST WITH VMOV->FCHAST
       SELE BDA02
       *****CONSOLIDADO*******
       APPEND BLANK
       REPLACE CODREF WITH RMOV->CODREF
       REPLACE G      WITH STR(VAL(LEFT(CODREF,1)),1)
       REPLACE NOM    WITH LEFT(AUXI->NOMAUX,25)
       DO CASE
          CASE RMOV->CODCTA = [90]
            REPLACE C90 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [91]
            REPLACE C91 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [92]
            REPLACE C92 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [93]
            REPLACE C93 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [94]
            REPLACE C94 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [95]
            REPLACE C95 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [96]
            REPLACE C96 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [97]
            REPLACE C97 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [98]
            REPLACE C98 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
          CASE RMOV->CODCTA = [99]
            REPLACE C99 WITH IIF(RMOV->TPOMOV=[D],RMOV->IMPORT,-RMOV->IMPORT)
       ENDCASE
       SELE RMOV
   ENDIF
   SKIP
ENDDO
SELE BDA02
GO TOP

SAVE SCREEN TO TMP
sNomRep = "cbdrb018"
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn3]
xWhile = []
xFor   = []
DO ADMPRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
DEFINE POPUP SIGUE FROM 18,24 TITLE "  SUSTENTO DEL ANALISIS   "
ON SELE POPUP SIGUE DEACTIVATE POPUP SIGUE
DEFINE BAR 1 OF SIGUE PROMPT "IMPRIMIR SUSTENTO"
DEFINE BAR 2 OF SIGUE PROMPT "SALIR"
ACTIVATE POPUP SIGUE
IF BAR() = 1
   CLOSE DATA
   SELE 0
   USE &TMP1 ALIAS BDA01 ORDER T01
   sNomRep = "cbdrb18A"
   SELE BDA01
   GO TOP
   DO ADMPRINT WITH "REPORTS"
ENDIF
CLOSE DATA
DELETE FILE &TMP1..dbf
DELETE FILE &TMP1..CDX
DELETE FILE &TMP2..dbf
DELETE FILE &TMP2..CDX

