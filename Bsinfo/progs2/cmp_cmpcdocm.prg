*------------------------------------------------------------------------------
*  Nombre    : Cmpcdocm.PRG
*  Autor     : VETT
*  Proposito : Correlativos de documentos de Compras
*  Creaci¢n  : 27/02/96
*------------------------------------------------------------------------------
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')

** Abrimos areas a usar **
LoDatAdm.AbrirTabla('ABRIR','cmptdocm','DOCM','DOCM01','')
SELE DOCM
** Definimos variables publicas **
PRIVATE XnNroDoc1,XnNroDoc,XsCodDoc,XsMes01,XsMes02,XsMes03,XsMes04,XsMes05,XsMes06,;
        XsMes07,XsMes08,XsMes09,XsMes10,XsMes11,XsMes12
STORE "" TO XnNroDoc1,XnNroDoc,XsCodDoc,XsMes01,XsMes02,XsMes03,XsMes04,XsMes05,XsMes06,;
            XsMes07,XsMes08,XsMes09,XsMes10,XsMes11,XsMes12
Temp = 1

*** Pintamos pantalla ***
CLEAR
Titulo = "CORRELATIVO DE DOCUMENTOS"
cTit1=GsNomCia
cTit2="FECHA : "+GsFecha
cTit3=""
cTit4=Titulo
DO FONDO WITH cTit1,cTit2,cTit3,cTit4
@ 7,6 FILL  TO 22,73 COLOR W/N
@ 6,7 CLEAR TO 21,72
@ 6,7 TO 21,72
@  8,12  SAY "           DOCUMENTO  :"
@ 10,12  SAY "Nro. de Documento - 1 :"
@ 12,12  SAY "Nro. de Documento - 2 :"
@ 14,12  SAY "   Mes  de Enero   :            Julio     :"
@ 15,12  SAY "           Febrero :            Agosto    :"
@ 16,12  SAY "           Marzo   :            Setiembre :"
@ 17,12  SAY "           Abril   :            Octubre   :"
@ 18,12  SAY "           Mayo    :            Noviembre :"
@ 19,12  SAY "           Junio   :            Diciembre :"

** Logica Principal **
DO Lib_MTEC with 0
DO F1_EDIT WITH 'DOCLeerK','DOCPoner','DOCTomar','DOCBorra','',;
                 [],[],'CMA'

CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF

SYS(2700,0)
USE IN DOCM
RETURN
************************************************************************* EOF
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE DOCLeerK
DO Lib_MTEC WITH 11
XsCodDoc = DOCM->CodDoc
UltTecla = 0
DO LIB_MTEC WITH 12
@  8,37 GET XsCodDoc PICT "@!"
READ
UltTecla = Lastkey()
SELE DOCM
IF UltTecla <> Escape_
   SEEK (XsCodDoc)
ENDIF
RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE DOCInvar
XnNroDoc = 1
XnNroDoc1= 1
STORE 1 TO XsMes01,XsMes02,XsMes03,XsMes04,XsMes05,XsMes06
STORE 1 TO XsMes07,XsMes08,XsMes09,XsMes10,XsMes11,XsMes12

RETURN
************************************************************************** FIN
* Procedimiento pone datos en pantalla
******************************************************************************
PROCEDURE DOCPoner
@  8,37 SAY CODDOC
@ 10,37 SAY RIGHT(REPLICATE("0", 7)+LTRIM(STR(DOCM->NroDoc)), 7 )
@ 12,37 SAY RIGHT(REPLICATE("0", 7)+LTRIM(STR(DOCM->NroDo1)), 7 )
@ 14,34 SAY Mes01
@ 15,34 SAY Mes02
@ 16,34 SAY Mes03
@ 17,34 SAY Mes04
@ 18,34 SAY Mes05
@ 19,34 SAY Mes06
@ 14,57 SAY Mes07
@ 15,57 SAY Mes08
@ 16,57 SAY Mes09
@ 17,57 SAY Mes10
@ 18,57 SAY Mes11
@ 19,57 SAY Mes12

RETURN
************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE DOCMover
XnNroDoc = DOCM->NroDoc
XnNroDoc1= DOCM->NroDo1
XsMes01  = DOCM->Mes01
XsMes02  = DOCM->Mes02
XsMes03  = DOCM->Mes03
XsMes04  = DOCM->Mes04
XsMes05  = DOCM->Mes05
XsMes06  = DOCM->Mes06
XsMes07  = DOCM->Mes07
XsMes08  = DOCM->Mes08
XsMes09  = DOCM->Mes09
XsMes10  = DOCM->Mes10
XsMes11  = DOCM->Mes11
XsMes12  = DOCM->Mes12
RETURN
************************************************************************** FIN
* Procedimiento de tomar datos
******************************************************************************
PROCEDURE DOCTomar
IF EOF()
   DO DOCInvar
ELSE
   DO DOCMover
   IF .NOT. Rec_Lock(5)
      RETURN                 && No pudo bloquear registro
   ENDIF
ENDIF
i=1
DO LIB_MTEC WITH 7
DO WHILE !INLIST(UltTecla,Escape_,CtrlW,PgUp,PgDn)
   DO CASE
      CASE i = 1
           @ 10,37 GET XnNroDoc PICT "9999999"
           READ
           UltTecla = LASTKEY()
           IF UltTecla = Escape_
              EXIT
           ENDI
           @ 10,37 SAY RIGHT(REPLICATE("0", 6)+LTRIM(STR(XnNroDoc)), 7 )
      CASE i = 2
           @ 12,37 GET XnNroDoc1 PICT "9999999"
           READ
           UltTecla = Lastkey()
           IF UltTecla = Escape_
              LOOP
           ENDI
           @ 12,37 SAY RIGHT(REPLICATE("0", 6)+LTRIM(STR(XnNroDoc1)), 7 )
      CASE i = 3
           @ 14,34 GET XsMes01 PICT "9999"
           @ 15,34 GET XsMes02 PICT "9999"
           @ 16,34 GET XsMes03 PICT "9999"
           @ 17,34 GET XsMes04 PICT "9999"
           @ 18,34 GET XsMes05 PICT "9999"
           @ 19,34 GET XsMes06 PICT "9999"
           @ 14,57 GET XsMes07 PICT "9999"
           @ 15,57 GET XsMes08 PICT "9999"
           @ 16,57 GET XsMes09 PICT "9999"
           @ 17,57 GET XsMes10 PICT "9999"
           @ 18,57 GET XsMes11 PICT "9999"
           @ 19,57 GET XsMes12 PICT "9999"
           READ
           UltTecla = Lastkey()

      CASE i = 4
           IF UltTecla = Enter
              UltTecla = CtrlW
           ENDIF
    ENDC
    i = IIF(UltTecla = Arriba, i-1, i+1)
    i = IIF(i < 1, 1, i)
    i = IIF(i > 4, 4, i)
ENDDO
IF UltTecla <> Escape_
   DO DOCGraba
ENDIF
UNLOCK ALL
DO Lib_MTEC with 0
RETURN
************************************************************************** FIN
* Procedimiento de Grabacion de informacion
******************************************************************************
PROCEDURE DOCGraba
DO LIB_MSGS WITH 4
IF EOF()                  && Creando
   SEEK (XsCodDoc)
   IF FOUND()
      DO LIB_MERR WITH 11
      RETURN
   ENDIF
   APPEND BLANK
   IF .NOT. Rec_Lock(5)
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE DOCM->CodDoc  WITH XsCodDoc
ENDIF
REPLACE DOCM->NroDo1  WITH XnNroDoc1
REPLACE DOCM->NroDoc  WITH XnNroDoc
REPLACE DOCM->Mes01   WITH XsMes01
REPLACE DOCM->Mes02   WITH XsMes02
REPLACE DOCM->Mes03   WITH XsMes03
REPLACE DOCM->Mes04   WITH XsMes04
REPLACE DOCM->Mes05   WITH XsMes05
REPLACE DOCM->Mes06   WITH XsMes06
REPLACE DOCM->Mes07   WITH XsMes07
REPLACE DOCM->Mes08   WITH XsMes08
REPLACE DOCM->Mes09   WITH XsMes09
REPLACE DOCM->Mes10   WITH XsMes10
REPLACE DOCM->Mes11   WITH XsMes11
REPLACE DOCM->Mes12   WITH XsMes12

RETURN
************************************************************************** FIN
* Procedimiento de borrado de un registro
******************************************************************************
PROCEDURE DOCBorra
DO Lib_MSGS with 10
IF Rec_Lock(5)
   DELETE
   SKIP
   UNLOCK
ENDIF
DO Lib_MSGS with 0
RETURN
************************************************************************** FIN
