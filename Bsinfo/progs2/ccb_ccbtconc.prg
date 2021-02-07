****************************************************************************
* Programa     : ccbtconc.prg
* Sistema      : Cuentas por Cobrar
* Parametros   : cTabla => NA Conceptos de Abono
*                          NC conceptos de Cargo
*                          IC conceptos de I/Caja
*                          EC conceptos de E/Caja
*                          CJ conceptos para Estadisticas de Caja
* Actualizacion:
****************************************************************************
PARAMETER cTabla
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABLA','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')

RELEASE LoDatAdm
DO fondo WITH 'Tabla de Conceptos',Goentorno.user.login,GsNomCia,GsFecha


SELECT CTAS
SET FILTER TO AftMov = [S]
* relaciones a usar *
SELE TABLA
SET RELA TO CodCta INTO CTAS
** pantalla de datos **
CLEAR
** variables del browse **
UltTecla = 0
SelLin   = ""
InsLin   = []
EscLin   = ""
EdiLin   = "TABbedit"
BrrLin   = "TABbborr"
GrbLin   = "TABbgrab"
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
Titulo   = []
NClave   = [Tabla]
VClave   = cTabla
HTitle   = 1
Yo       = 3
Xo       = 0
Largo    = 21 - Yo
Ancho    = 80
TBorde   = Doble
Titulo   = []
DO CASE
   CASE cTabla = 'NA'
      Titulo = [CONCEPTOS DE ABONO]
   CASE cTabla = 'NC'
      Titulo = [CONCEPTOS DE CARGO]
   CASE cTabla = 'IC'
      Titulo = [CONCEPTOS DE OTROS INGRESOS A CAJA]
   CASE cTabla = 'EC'
      Titulo = [CONCEPTOS DE EGRESOS DE CAJA]
   CASE cTabla = 'CJ'
      Titulo = [CONCEPTOS PARA ESTADISTICAS DE CAJA]
ENDCASE
E1       = [ CODIGO      D E S C R I P C I O N             CUENTA  D E S C R I P C I O N  ]
E2       = []
E3       = []


*           1         2         3         4         5         6         7
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5| CODIGO      D E S C R I P C I O N             CUENTA  D E S C R I P C I O N |
* |*12345 12345678901234567890123456789012345678901234567 123456789012345678901234|
*



LinReg   = [Codigo+' '+Nombre+CodCta+' '+LEFT(CTAS->NomCta,22)]
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.
Set_Escape = .T.
*** Variable a Conocer ****
XsCodigo = ""
XsNombre = ""
XsCodCta = []
DO LIB_MTEC WITH 14
DO DBrowse
CLEAR
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
DO Close_File IN CCB_CcbAsign
RETURN
*********************************************************************** EOP()
* Pedir datos
*****************************************************************************
PROCEDURE TABbedit

IF ! Crear
   XsCodigo = Codigo
   XsNombre = Nombre
   XsCodCta = CodCta
ELSE
   XsCodigo = SPACE(LEN(Codigo))
   XsNombre = SPACE(LEN(Nombre))
   XsCodCta = SPACE(LEN(CodCta))
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,escape_,CtrlW,F10)
   i = IIF(!Crear .AND. i < 2 ,2,i)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         @ LinAct,2  GET XsCodigo PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = escape_
            LOOP
         ENDIF
         @ LinAct,2  SAY XsCodigo
         SEEK XsCodigo
         IF FOUND()
            GsMsgErr = "Concepto YA registrado"
            DO lib_merr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
      CASE i = 2
         @ LinAct,8  GET XsNombre PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = escape_
            LOOP
         ENDIF
         @ LinAct,8  SAY XsNombre
      CASE i = 3
         SELE CTAS
         @ LinAct,48 GET XsCodCta PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Arriba,escape_)
            i = i - 1
            LOOP
         ENDIF

         IF UltTecla = F8
            IF ! cbdbusca("CTAS")
               LOOP
            ENDIF
            XsCodCta = CodCta
         ENDIF
         IF !EMPTY(XsCodCta)
            SEEK XsCodCta
            IF ! FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            @ LinAct,48 SAY LEFT(XsCodCta+' '+CTAS->NomCta,22)
         ENDIF
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3, 3, i)
   i = IIF(i<1, 1, i)
ENDDO
SELE TABLA
DO LIB_MTEC WITH 14
RETURN
*********************************************************************** FIN()
* Grabar Informacion
*****************************************************************************
PROCEDURE TABbgrab

IF Crear
   APPEND BLANK
ENDIF
IF !RLOCK()
   RETURN
ENDIF
REPLACE Tabla  WITH cTabla
REPLACE Codigo WITH XsCodigo
REPLACE Nombre WITH XsNombre
REPLACE CodCta WITH XsCodCta
UNLOCK
RETURN
*********************************************************************** FIN()
* Borrar Informacion
*****************************************************************************
PROCEDURE TABbborr

IF !RLOCK()
   RETURN
ENDIF
REPLACE Tabla  WITH []
REPLACE Codigo WITH []
DELETE
UNLOCK
RETURN
*********************************************************************** FIN()
