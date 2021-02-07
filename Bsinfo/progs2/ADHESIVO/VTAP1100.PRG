****************************************************************************
* Programa     : VTAP1100.prg
* Sistema      : VENTAS
* Autor        : RHC
* Proposito    : Maestro de Clientes
* Parametros   :
* Actualizacion: RHC 31/10/94 Forzar al Codigo del Cliente a 4 caracteres
*                RHC 09/12/94 Verificar RUC y Nombre cuando se crea
*                EMI 16/03/95 Adicionar Limite Credito S/. y US$
****************************************************************************

** Pantalla de Datos **
DO xPanta
** aperturamos bases de datos **
CLOSE DATA
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF


SELE 2
USE ALMtabla ORDER tabl01 ALIAS TABL
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF

SELE CLIE
SET RELATION TO [CP]+CLIE->CODPOS INTO TABL

** variables a usar **
PRIVATE XsCodAux,XsNomAux,XsDirAux,XsTlfAux,XsRucAux
PRIVATE XsCodPos,XsDirEnt,XsIniAux,XsNomC_V,XsNomEnt
PRIVATE XfLCreMn,XfLCreUs
STORE [] TO XsCodAux,XsNomAux,XsDirAux,XsTlfAux,XsRucAux
STORE [] TO XsCodPos,XsDirEnt,XsIniAux,XsNomC_V,XsNomEnt
STORE 0  TO XfLCreMn,XfLCreUs
** logica principal **
cClfAux = GsClfAux
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],[xListar],;
              [ClfAux],cClfAux,'CMAR'

CLOSE DATA
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta
cTit1=GsNomCia
cTit2="FECHA : "+GsFecha
cTit3=""
cTit4="MAESTRO DE CLIENTES"
DO FONDO WITH cTit1,cTit2,cTit3,cTit4

@  7,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  8,0  SAY "³                 Codigo :                                                     ³"
@  9,0  SAY "³    Nombre/Razon Social :                                                     ³"
@ 10,0  SAY "³              Iniciales :                                                     ³"
@ 11,0  SAY "³        Domicilio Legal :                                                     ³"
@ 12,0  SAY "³          N£mero de RUC :                                                     ³"
@ 13,0  SAY "³          C¢digo Postal :                                                     ³"
@ 14,0  SAY "³              Telefonos :                                                     ³"
@ 15,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 17,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 18,0  SAY "³  Contacto Compra/Venta :                                                     ³"
@ 19,0  SAY "³    Contacto de Entrega :                                                     ³"
@ 20,0  SAY "³   Direccion de Entrega :                                                     ³"
@ 21,0  SAY "³   L¡mite de Cr‚dito    :                                                     ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN
************************************************************************ FIN *
* Llave de Acceso
******************************************************************************
PROCEDURE xLlave

IF &RegVal.
   XsCodAux = CodAux
ELSE
   XsCodAux = SPACE(LEN(CodAux))
   iLargo   = 5
   LiCodAux = VAL(XsCodAux)+1
   LsCodAux = PADR(PADL(ALLTRIM(STR(LiCodAux)),iLargo,'0'),LEN(XsCodAux))
   SEEK GsClfAux
   SCAN WHILE ClfAux = GsClfAux FOR CodAux#[99999]
      XsCodAux = CodAux
      LiCodAux = VAL(XsCodAux)+1
      XsCodAux = PADR(PADL(ALLTRIM(STR(LiCodAux)),iLargo,'0'),LEN(XsCodAux))
   ENDSCAN
ENDIF
UltTecla = 0
DO WHILE !INLIST(UltTecla,Escape,Enter)
   @  8,27 GET XsCodAux PICT "!!!!!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F8
      IF !vtabusca("CLIE")
         LOOP
      ENDIF
      XsCodAux = CodAux
   ENDIF
   @ 8,27 SAY XsCodAux
ENDDO
SEEK GsClfAux+XsCodAux

RETURN
************************************************************************ FIN *
* Pintar Informacion
******************************************************************************
PROCEDURE xPoner

@  8,27 SAY CodAux PICT "!!!!!"
@  9,27 SAY NomAux
@ 10,27 SAY IniAux
@ 11,27 SAY DirAux PICT "@S50"
@ 12,27 SAY RucAux
@ 13,27 SAY CodPos
@ 14,27 SAY TlfAux
@ 18,27 SAY NomC_V
@ 19,27 SAY NomEnt
@ 20,27 SAY DirEnt PICT "@S50"
@ 21,27 SAY "S/."
@ 21,30 SAY LCreMn PICT "99999,999.99"
@ 21,60 SAY "US$"
@ 21,64 SAY LCreUs PICT "99999,999.99"

RETURN
************************************************************************ FIN *
* Pedir datos
******************************************************************************
PROCEDURE xTomar

UltTecla = 0
Crear = .T.
IF &RegVal.
   IF !RLOCK()
      RETURN
   ENDIF
   Crear = .F.
   XsCodAux = CodAux
   XsNomAux = NomAux
   XsIniAux = IniAux
   XsDirAux = DirAux
   XsRucAux = RucAux
   XsCodPos = CodPos
   XsTlfAux = TlfAux
   XsNomC_V = NomC_V
   XsNomEnt = NomEnt
   XsDirEnt = DirEnt
   XfLCreMn = LCreMn
   XfLCreUs = LCreUs
ELSE
   XsNomAux = SPACE(LEN(NomAux))
   XsIniAux = SPACE(LEN(IniAux))
   XsDirAux = SPACE(LEN(DirAux))
   XsRucAux = SPACE(LEN(RucAux))
   XsCodPos = SPACE(LEN(CodPos))
   XsTlfAux = SPACE(LEN(TlfAux))
   XsNomC_V = SPACE(LEN(NomC_V))
   XsNomEnt = SPACE(LEN(NomEnt))
   XsDirEnt = SPACE(LEN(DirEnt))
   XfLCreMn = 0
   XfLCreUs = 0
ENDIF
GsMsgKey = "[Esc] Cancelar   [Enter] Aceptar   [F10] Grabar"
DO lib_mtec WITH 99

@  9,27 GET XsNomAux  VALID _NomAux()
@ 10,27 GET XsIniAux
@ 11,27 GET XsDirAux PICT "@S50"
@ 12,27 GET XsRucAux PICT "@!" VALID _RucAux()
@ 13,27 GET XsCodPos PICT "999" VALID _CodPos()
@ 14,27 GET XsTlfAux
@ 18,27 GET XsNomC_V
@ 19,27 GET XsNomEnt
@ 20,27 GET XsDirEnt PICT "@S50" WHEN _DirEnt()
@ 21,27 SAY "S/."
@ 21,30 GET XfLCreMn PICT "99999,999.99"
@ 21,60 SAY "US$"
@ 21,64 GET XfLCreUs PICT "99999,999.99"
READ CYCLE
UltTecla = LASTKEY()
IF UltTecla # Escape
   DO xGraba
ENDIF
UNLOCK ALL

RETURN

FUNCTION _CodPos
SELE TABL
SEEK [CP]+XsCodPos
IF FOUND()
   SELE CLIE
   RETURN .T.
ENDIF
XsTabla = [CP]
IF !VTABUSCA("CP")
   SELE CLIE
   RETURN .F.
ENDIF
XsCodPos = CODIGO
SELE CLIE
RETURN .T.
************************************************************************ FIN *
* Verificar que no exista el mismo nombre
******************************************************************************
FUNCTION _NomAux

IF !Crear
   RETURN .T.
ENDIF
SET ORDER TO AUXI02
SEEK GsClfAux+XsNomAux
IF FOUND()
   SET ORDER TO AUXI01
   GsMsgErr = [Existe un Cliente con el mismo nombre : ]+CodAux
   DO lib_merr WITH 99
   RETURN 0
ENDIF
SET ORDER TO AUXI01

RETURN .T.
************************************************************************ FIN *
* Verificar que no exista el mismo RUC
******************************************************************************
FUNCTION _RucAux

IF !Crear .OR. EMPTY(XsRucAux)
   RETURN .T.
ENDIF
SET ORDER TO AUXI03
SEEK GsClfAux+XsRucAux
IF FOUND()
   SET ORDER TO AUXI01
   GsMsgErr = [Existe un Cliente con el mismo RUC : ]+CodAux
   DO lib_merr WITH 99
   RETURN 0
ENDIF
SET ORDER TO AUXI01

RETURN .T.
************************************************************************ FIN *
* Solo para definir por defecto la direccion de entrega
******************************************************************************
FUNCTION _DirEnt

IF Crear .OR. EMPTY(XsDirEnt)
   XsDirEnt = XsDirAux
ENDIF
RETURN .T.
************************************************************************ FIN *
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

IF Crear
   SEEK GsClfAux+XsCodAux
   IF FOUND()
      GsMsgErr = [ Cliente fue creado por otro usuario ]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE ClfAux WITH GsClfAux
   REPLACE CodAux WITH XsCodAux
ENDIF
REPLACE NomAux WITH XsNomAux
REPLACE IniAux WITH XsIniAux
REPLACE DirAux WITH XsDirAux
REPLACE RucAux WITH XsRucAux
REPLACE CodPos WITH XsCodPos
REPLACE TlfAux WITH XsTlfAux
REPLACE NomC_V WITH XsNomC_V
REPLACE NomEnt WITH XsNomEnt
REPLACE DirEnt WITH XsDirEnt
REPLACE LCreUs WITH XfLCreUs
REPLACE LCreMn WITH XfLCreMn

RETURN
************************************************************************ FIN *
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar
* Borrar Informacion

IF !RLOCK()
   RETURN
ENDIF
REPLACE CodAux WITH []
DELETE
SKIP
UNLOCK
RETURN
************************************************************************ FIN *
* Reporte de Clientes
******************************************************************************
PROCEDURE xListar

SAVE SCREEN TO sPanDat
iOpcion = 1
Titulo = [ ** MAESTRO DE CLIENTES ** ]
@  4,11,16,70 BOX "ÉÍ»º¼ÍÈº "
@  4,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  6,15 SAY "Ordenado por : "
@  6,30 PROMPT "Codigo"
@  6,40 PROMPT "Nombre"
@  6,50 PROMPT "Distrito"

MENU TO iOpcion
IF iOpcion = 0
   RESTORE SCREEN FROM sPanDat
   RETURN
ENDIF
DO CASE
   CASE iOpcion = 1
      sDesde = SPACE(LEN(CLIE->CodAux))
      sHasta = SPACE(LEN(CLIE->CodAux))
      @  8,15 SAY "Desde Codigo : "
      @ 10,15 SAY "Hasta Codigo : "
      sPIC = "@!"
   CASE iOpcion = 2
      sDesde = SPACE(LEN(CLIE->NomAux))
      sHasta = SPACE(LEN(CLIE->NomAux))
      @  8,15 SAY "Desde Nombre : "
      @ 10,15 SAY "Hasta Nombre : "
      sPIC = "@!S20"
    CASE iOpcion = 3
      sDesde = SPACE(LEN(CLIE->CODPOS))
      sHasta = SPACE(LEN(CLIE->CODPOS))
      @  8,15 SAY "Desde CodPos : "
      @ 10,15 SAY "Hasta CodPos : "
      sPIC = "999"
ENDCASE
UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1
         @  8,30 GET sDesde PICT sPIC
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         @ 10,30 GET sHasta PICT sPIC
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 2 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
IF UltTecla = Escape
   RESTORE SCREEN FROM sPanDat
   RETURN
ENDIF
** test de impresion **
SELE CLIE
sDesde = TRIM(sDesde)
sHasta = TRIM(sHasta)+CHR(255)
DO CASE
   CASE iOpcion = 1       && Por Codigo
      SET ORDER TO AUXI01
      IF EMPTY(sDesde)
         SEEK GsClfAux
         sDesde = CodAux
      ELSE
         SEEK GsClfAux+sDesde
         IF !FOUND()
            IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
               GO RECNO(0)
               IF DELETED()
                  SKIP
               ENDIF
            ENDIF
            sDesde = CodAux
         ENDIF
      ENDIF
      xWHILE = "sHasta>=CodAux.AND.ClfAux=GsClfAux"
      sNomRep = "vtap1100"
   CASE iOpcion = 2
      SET ORDER TO AUXI02
      IF EMPTY(sDesde)
         SEEK GsClfAux
         sDesde = NomAux
      ELSE
         SEEK GsClfAux+sDesde
         IF !FOUND()
            IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
               GO RECNO(0)
               IF DELETED()
                  SKIP
               ENDIF
            ENDIF
            sDesde = NomAux
         ENDIF
      ENDIF
      xWHILE = "sHasta>=NomAux.AND.ClfAux=GsClfAux"
      sNomRep = "vtap1100"
   CASE iOpcion = 3       && Por Codigo
      SET ORDER TO AUXI04
      IF EMPTY(sDesde)
         SEEK GsClfAux
         sDesde = NomAux
      ELSE
         SEEK GsClfAux+sDesde
         IF !FOUND()
            IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
               GO RECNO(0)
               IF DELETED()
                  SKIP
               ENDIF
            ENDIF
            sDesde = NomAux
         ENDIF
      ENDIF
      xWHILE = "sHasta>=CodPos.AND.ClfAux=GsClfAux"
      sNomRep = "vtap1101"
ENDCASE
SEEK GsClfAux+sDesde
IF !FOUND()
   GsMsgErr = [ Fin de Archivo ]
   DO lib_merr WITH 99
   RESTORE SCREEN FROM sPanDat
   RETURN
ENDIF
xFOR = ".T."
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
DO admprint WITH "REPORTS"
SELE CLIE
SET ORDER TO AUXI01
RESTORE SCREEN FROM sPanDat
RETURN
************************************************************************ FIN *
