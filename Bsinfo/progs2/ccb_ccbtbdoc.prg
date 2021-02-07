**************************************************************************
*  Nombre       : ccbtbdoc.prg
*  Proposito    : Maestro de Documentos
*  Creaci¢n     : 21/05/93
*  Actualizaci¢n: 13/06/00 MAAV
**************************************************************************
#INCLUDE CONST.H
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
=SYS(2700,0)
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
RELEASE LoDatAdm
DO def_teclas IN fxgen_2
DO fondo WITH 'Tabla de documentos de cobranza',Goentorno.user.login,GsNomCia,GsFecha
*
SELECT CTAS 
SET FILTER TO AftMov==[S]
**
STORE "" TO XsTpodoc,XsCoddoc,XsDesdoc,Xsnrodoc,XsCodCta,XsCodCta2,XsCodCta3,XsCodCta4,XsCta12_MN,XsCta12_ME,XsCta70,XsCta40
*** Pintamos pantalla *************
CLEAR
*!*	FOR i = 0 TO SROW()-3
*!*		@ i,0 SAY REPLICATE("°",SCOL()) COLOR SCHEME 11
*!*	ENDFOR

@ 5,1 CLEAR TO 21,78
@ 5,1       TO 21,78
*@ 5,30 SAY "TABLA DE DOCUMENTOS" COLOR SCHEME 7

@  7,10  SAY "C¢digo de Documento:"
@  8,10  SAY "        Descripci¢n:"
@ 11,10  SAY "  Tipo de Documento:"
@ 13,10  SAY "Cuenta 12 Mon.Nac. :"
@ 14,10  SAY "Cuenta 12 Mon.Ext. :"
@ 15,10  SAY "Cuenta Ventas      :"
@ 16,10  SAY "Cuenta Impuestos   :"
*@ 17,10  SAY "Cuentas Asignadas 3:"
@ 18,10  SAY "Operación contable :"
@ 19,10  SAY "        Correlativo:"

**********************************************************************
** Rutina principal *****
**********************************************************************
SELE TDOC
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
GsMsgKey = ""
DO LIB_MTEC WITH 99
DO f1_EDIT WITH [xLlave],[xMuestra],[xEdita],[xElimina],'','','','CMA'
CLEAR
=SYS(2700,0)
CLEAR macros
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
DO Close_File IN CCB_CCBAsign
RETURN
**********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE xLlave
******************
GsMsgKey = "[Esc] Cancela         [Enter] [F10] Acepta         [F8] Consulta "

DO LIB_MTEC WITH 99
XsCodDoc   = CodDoc
UltTecla = 0
i        = 1
DO WHILE .T.
   @  7,32 GET XsCodDoc   PICTURE "@!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F8
      IF CCBBUSCA("TDOC")
         XsCodDoc = CodDoc
         UltTecla = Enter
      ENDIF
   ENDIF
   IF INLIST(UltTecla,Enter,escape_,F10,CtrlW)
      EXIT
   ENDIF
ENDDO
SEEK XsCodDoc
*IF UltTecla = escape_
   GsMSgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
   GsMsgKey = ""
   DO LIB_MTEC WITH 99
*ENDIF
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE xMuestra
******************

@  7,32  SAY  Coddoc   pict "@!"
@  8,32  SAY  desdoc   pict "@S!25"
@ 10,32  GET  TpoDoc   PICTURE "@^ CARGO;ABONO"
@ 13,32  SAY  Cta12_MN   PICT "@S40"
@ 14,32  SAY  Cta12_ME   PICT "@S40"
@ 15,32  SAY  Cta70    PICT "@S40"
@ 16,32  SAY  Cta40    PICT "@S40"
*!*	@ 17,32  SAY  CodCta3  PICT "@S40"
@ 18,32  SAY  CodOpe  PICT "@S3"
@ 19,32  SAY  nrodoc   pict "9999999999"
CLEAR GETS
RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE xEdita
Xsdesdoc   = Desdoc
XsTpodoc   = Tpodoc
XsNrodoc   = Nrodoc
XsCta12_MN	= Cta12_MN
XsCta12_ME	= Cta12_ME
XsCta70    = Cta70
XsCta40    = Cta40
XsCodCta3  = CodCta3
XsCodCta4  = CodCta4
XsCodOpe	= CodOpe	
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,escape_)
    GsMsgKey = "[TAB] Sig. Campo  [] [] [Enter] Registra [F10] Graba [Esc] Cancela"
    DO LIB_MTEC WITH 99
   DO CASE
      CASE i = 1
         @  8,32  GET XsDesdoc   pict "@S!25"
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         @ 10,32  GET XsTpoDoc   PICTURE "@^ CARGO;ABONO"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancela"
         DO LIB_MTEC WITH 99
         SELE CTAS
         @ 13,32  GET XsCta12_MN PICT "@S40!" VALID _CodCta(XsCta12_MN)
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! cbdbusca("CTAS")
               LOOP
            ENDIF
            XsCta12_MN = CodCta
         ENDIF
         @ 13,32 SAY XsCta12_MN PICT "@S40"

      CASE i = 4
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancela"
         DO LIB_MTEC WITH 99
         SELE CTAS
         @ 14,32  GET XsCta12_ME PICT "@S40!" VALID _CodCta(XsCta12_ME)
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! cbdbusca("CTAS")
               LOOP
            ENDIF
            XsCta12_ME = CodCta
         ENDIF
         @ 14,32 SAY XsCta12_ME PICT "@S40"
         
      CASE i = 5
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancela"
         DO LIB_MTEC WITH 99
         SELE CTAS
         @ 15,32  GET XsCta70 PICT "@S40!" VALID _CodCta()
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! cbdbusca("CTAS")
               LOOP
            ENDIF
            XsCta70 = CodCta
         ENDIF
         @ 15,32 SAY XsCta70 PICT "@S40"
      CASE i = 6
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancela"
         DO LIB_MTEC WITH 99
         SELE CTAS
         @ 16,32  GET XsCta40 PICT "@S40!" VALID _CodCta()
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! cbdbusca("CTAS")
               LOOP
            ENDIF
            XsCta40 = CodCta
         ENDIF
         @ 16,32 SAY XsCta40 PICT "@S40"
      CASE i = 7 AND .F.
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancela"
         DO LIB_MTEC WITH 99
         SELE CTAS
         @ 17,32  GET XsCodCta3 PICT "@S40!" VALID _CodCta()
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! cbdbusca("CTAS")
               LOOP
            ENDIF
            XsCodCta3 = CodCta
         ENDIF
         @ 17,32 SAY XsCodCta3 PICT "@S40"
      CASE i = 8
         GsMsgKey = "[] [] [Enter] Registra [F8] Consulta [Esc] Cancela"
         DO LIB_MTEC WITH 99
         SELE OPER
         @ 18,32  GET XsCodOpe PICT "@S3" 
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! cbdbusca("OPER")
               LOOP
            ENDIF
            XsCodOpe = CodOpe
         ENDIF
         @ 18,32 SAY XsCodOpe PICT "@S3"
      CASE i = 9
         @ 19,32  GET Xsnrodoc   pict "9999999999"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>9,9,i)
ENDDO
SELE TDOC
IF UltTecla <> escape_
   DO GRABA
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Comit‚"
GsMsgKey = ""
DO LIB_MTEC WITH 99
RETURN
**********************************************************************
* ELIMINA REGISTRO                                                   *
**********************************************************************
PROCEDURE xElimina
******************
IF RLock()
   DELETE
   SKIP
   UNLOCK
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
GsMsgKey = ""
DO LIB_MTEC WITH 99
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabacion
******************************************************************************
PROCEDURE GRABA
Crear=EOF()
IF Crear
	APPEND BLANK
ENDIF
IF ! RLOCK()
	RETURN
ENDIF
IF Crear
	REPLACE Coddoc    WITH XsCoddoc
ENDIF
REPLACE Desdoc    WITH XsDesdoc
REPLACE Tpodoc    WITH XsTpodoc
REPLACE Nrodoc    WITH XsNrodoc
replace Cta12_MN  WITH XsCta12_MN
replace Cta12_ME  WITH XsCta12_ME
REPLACE Cta70     WITH XsCta70
REPLACE Cta40     WITH XsCta40
REPLACE CodCta3   WITH XsCodCta3
REPLACE CodCta4   WITH XsCodCta4
REPLACE CodOpe		WITH XsCodOpe
UNLOCK ALL

RETURN
*************************************************************************** FIN
* Verificacion de los codigos de cuenta asignados
******************************************************************************
FUNCTION _CodCta
****************
PARAMETERS _XsCodCta
IF LASTKEY()=escape_ OR EMPTY(_XsCodCta)
	RETURN .T.
ENDIF
PRIVATE j,m,n
m = 1
n = LEN(CTAS.CodCta)
DO WHILE m+n-1 <= LEN(TRIM(_XsCodCta))
	cCodCta = SUBSTR(_XsCodCta,m,n)
	IF !SEEK(cCodCta,"CTAS")
		GsMsgErr = [ C¢digo de cuenta ]+cCodCta+[ no registrada]
		DO lib_merr WITH 99
		RETURN 0
	ENDIF
	m = m + n + 1
ENDDO
RETURN .T.
*************************************************************************** FIN
