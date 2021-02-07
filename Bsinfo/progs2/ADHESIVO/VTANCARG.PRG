****************************************************************************
* Programa     : VTAncarg.prg
* Sistema      : Cuentas por Cobrar
* Autor        : RHC
* Proposito    : Ingreso de Notas de Cargo
* Creacion     : 28/02/94
* Parametros   :
* Actualizaci¢n:
****************************************************************************

XsClfAux = GsClfAux
** base de datos **
CLOSE DATA
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 2
USE vtatdocm ORDER DOCM01 ALIAS DOCM
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 3
USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 4
USE ccbrrdoc ORDER RDOC01 ALIAS RDOC
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
*
SELE 5
USE cbdmtabl ORDER TABL01 ALIAS TABLA
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF
**
SELE 7
USE admmtcmb ORDER TCMB01 ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** relaciones a usar **
SELECT RDOC
SET RELA TO 'NC'+Codigo INTO TABLA
SELECT GDOC
SET RELATION TO XsClfAux+CodCli INTO CLIE
** pantalla de datos **
RESTORE FROM VTACONFG ADDITIVE
CLEAR
Titulo = [ ** NOTAS DE DEBITO ** ]
@  0,(79-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "Documento :                                          Fecha :  "
@  2,5  SAY "Cliente   :                                            RUC :  "
@  3,5  SAY "Nombre    :                                                   "
@  4,5  SAY "Direcci¢n :                                                   "
@  5,0 TO 5,79
@  5,5  SAY "Detalle   : " COLOR SCHEME 7
@ 10,5  SAY "Moneda    : S/.                                Tpo. Cambio :  "
@ 11,10 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 12,10 SAY "³ C¢digo       D e s c r i p c i ¢ n                 Importe    ³" COLOR SCHEME 7
@ 13,10 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 14,10 SAY "³                                                               ³"
@ 15,10 SAY "³                                                               ³"
@ 16,10 SAY "³                                                               ³"
@ 17,10 SAY "³                                                               ³"
@ 18,10 SAY "³                                                               ³"
@ 19,10 SAY "³                                                               ³"
@ 20,10 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,10 SAY "³                                   TOTAL                       ³"
@ 22,10 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 21,46 SAY "TOTAL       " COLOR SCHEME 7
** variables del sistema **
PRIVATE XsTpoDoc,XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli,XiCodMon,XfTpoCmb
PRIVATE XfImpNet,XfImpTot,XsGlosa1,XsGlosa2,XsGlosa3,XfSdoDoc,XfImpBto
PRIVATE XsGlosa4
PRIVATE XcFlgEst,XcFlgSit,XcFlgUbc
PRIVATE XsNomCli,XsDirCli,XsRucCli
PRIVATE XsPtoVta
STORE [] TO XsTpoDoc,XsCodDoc,XsNroDoc,XdFchDoc,XsCodCli
STORE [] TO XsGlosa1,XsGlosa2,XsGlosa3,XsGlosa4
STORE [] TO XsNomCli,XsDirCli,XsRucCli
STORE [] TO XsPtoVta
STORE 0 TO XfTpoCmb,XfImpNet,XfImpTot,XfSdoDoc,XfImpBto
XsTpoDoc = [Cargo]
XsCodDoc = [N/C ]
XiCodMon = 1   && SOLES
XcFlgEst = [P]
XcFlgUbc = [C]
XcFlgSit = [ ]
** Control de Correlativo **
PRIVATE m.NroDoc
m.NroDoc = []
** Logica Principal **
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99
xTpoDoc = XsTpoDoc
xCodDoc = XsCodDoc
UltTecla = 0
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [TpoDoc+CodDoc],xTpoDoc+XCodDoc,'CMA'
CLOSE DATA
RETURN
************************************************************************ EOP()
* Pedir LLave de Busqueda
******************************************************************************
PROCEDURE xLLave

SELE DOCM
SEEK XsCodDoc
IF !FOUND()
   SELECT GDOC
   WAIT "No existe correlativo" NOWAIT WINDOW
   UltTecla = Escape
   RETURN
ENDIF
XiPidPto  = .F.
XsPtoVta  = DOCM->PtoVta
RegAct    = RECNO()
XsPtoVta  = DOCM->PtoVta
SKIP
IF CodDoc = XsCodDoc
   XiPidPto  = .T.
ENDIF
GOTO RegAct
@ 1,17 SAY XsPtoVta
i = 1
SELE GDOC
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1 .AND. XiPidPto
         SELE DOCM
         @ 1,17 GET XsPtoVta PICT "@9"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !vtabusca("0004")
               LOOP
            ENDIF
            XsPtoVta = PtoVta
         ENDIF
         @ 1,17 SAY XsPtoVta
         SEEK XsCodDoc+XsPtoVta
         IF !FOUND()
            GsMsgErr = "No existe correlativo"
            DO lib_merr WITH 99
            LOOP
         ENDIF
      CASE i = 2
         XiNroDoc  = DOCM->NroDoc
         XsNroDoc = XsPtoVta + TRANSF(XiNroDoc,"@L 999999")
         SELE GDOC
         IF CHRVAL # "C"
            @ 1,21 GET XiNroDoc PICT "@L 999999"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,Escape)
               LOOP
            ENDIF
         ELSE
            SEEK XsTpoDoc+XsCodDoc+XsNroDoc
            UltTecla = Enter
            @ 1,17 SAY XsNroDoc PICT "@R 999-999999"
            IF FOUND()
               GsMsgErr = "Error en el Registro de Correlativos"
               DO LIB_MERR WITH 99
               UltTecla = Escape
            ENDIF
         ENDIF
         XsNroDoc = XsPtoVta + TRANSF(XiNroDoc,"@L 999999")
         @ 1,17 SAY XsNroDoc PICT "@R 999-999999"
   ENDCASE
   IF UltTecla=Enter .AND. i = 2
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE GDOC
SEEK XsTpoDoc+XsCodDoc+XsNroDoc
RETURN
************************************************************************ FIN()
* Pintar Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

SELE GDOC
@  1,17 SAY NroDoc PICT "@R 999-"+REPLI("9",LEN(NroDoc)-3)
@  1,68 SAY FchDoc
@  2,17 SAY CodCli
@  2,68 SAY RucCli
@  3,17 SAY NomCli
@  4,17 SAY DirCli
@  6,00 SAY Glosa1
@  7,00 SAY Glosa2
@  8,00 SAY Glosa3
@  9,00 SAY Glosa4
@ 10,17 SAY IIF(CodMon=2,'US$','S./')
@ 10,68 SAY TpoCmb PICT "9,999.9999"
m.DesEst = _FLGEST(FlgEst)
@ 21,31 SAY m.DesEst
@ 21,60 SAY ImpTot PICT "999,999,999.99"
** datos del browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .T.
DO xBrowse
**
SELE GDOC
IF FlgEst = [A]
   @ 14,11 SAY "                                                               "
   @ 15,11 SAY "        ###   ##  #  #   #  #       ###   ####   #####         "
   @ 16,11 SAY "       #   #  # # #  #   #  #      #   #  #   #  #   #         "
   @ 17,11 SAY "       #####  #  ##  #   #  #      #####  #   #  #   #         "
   @ 18,11 SAY "       #   #  #   #  #####  #####  #   #  ####   #####         "
   @ 19,11 SAY "                                                               "
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99

RETURN
************************************************************************ FIN()
* Pedir Datos
******************************************************************************
PROCEDURE xTomar

SELE GDOC
Crear = .T.
IF &RegVal.
   IF FlgEst # 'P' .AND. FlgEst # "A"
      GsMsgErr = [ Acceso Denegado ]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF ImpTot # SdoDoc
      GsMsgErr = [ Tiene Aplicaciones Realizadas ]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   IF ! Clave(CFGPasswD)
      UltTecla = Escape
      RETURN
   ENDIF
   Crear = .F.
   IF !RLOCK()
      RETURN
   ENDIF
ENDIF
IF Crear
   DO xInvar
ELSE
   DO xMover
ENDIF
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,Escape)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1
         @ 1,68 GET XdFchDoc
         READ
         UltTecla = LASTKEY()
         IF !INLIST(UltTecla,BackTab,Escape,Arriba)
            IF ! Modificar()
               GsMsgErr = "Mes Cerrado, acceso denegado"
               DO LIB_MERR WITH 99
               LOOP
            ENDIF
         ENDIF
      CASE i = 2
         SELE CLIE
         @ 2,17 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape .OR. UltTecla = Arriba
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodCli)
            IF !VTAbusca("CLIE")
               SET ORDER TO AUXI01
               LOOP
            ENDIF
            XsCodCli = CLIE->CodAux
            SET ORDER TO AUXI01
         ENDIF
         @ 2,17 SAY XsCodCli
         IF TRIM(XsCodCli)=[99999]  && Clientes Varios
            * no pasa nada *
         ELSE
            SEEK XsClfAux+XsCodCli
            IF !FOUND()
               GsMsgErr = [ Cliente no Existe ]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            XsNomCli = CLIE->NomAux
            XsDirCli = CLIE->DirAux
            XsRucCli = CLIE->RucAux
            @  2,68 SAY XsRucCli
            @  3,17 SAY XsNomCli PICT "@S40"
            @  4,17 SAY XsDirCli
         ENDIF
      CASE i = 3 .AND. TRIM(XsCodCli)=[99999]
         @  2,68 GET XsRucCli PICT "@!"
         @  3,17 GET XsNomCli PICT "@!S40"
         @  4,17 GET XsDirCli PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         @  6,00 GET XsGlosa1 PICT "@!"
         @  7,00 GET XsGlosa2 PICT "@!"
         @  8,00 GET XsGlosa3 PICT "@!"
         @  9,00 GET XsGlosa4 PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 5
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,17,2)
      CASE i = 6
         IF SEEK(DTOS(XdFchDoc),"TCMB")
            XfTpoCmb = TCMB->OfiVta
         ENDIF
         @ 10,68 GET XfTpoCmb PICT "9,999.9999" RANGE 0,
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 6 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>6,6,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
   DO xListar
ENDIF
SELE GDOC
UNLOCK ALL

RETURN
************************************************************************ FIN()
* Inicializa variables
******************************************************************************
PROCEDURE xInvar

SELE GDOC
XdFchDoc = DATE()
XsCodCli = PADR([99999],LEN(GDOC->CodCli))
XsNomCli = SPACE(LEN(GDOC->NomCli))
XsDirCli = SPACE(LEN(GDOC->DirCli))
XsRucCli = SPACE(LEN(GDOC->RucCli))
XsGlosa1 = SPACE(LEN(GDOC->Glosa1))
XsGlosa2 = SPACE(LEN(GDOC->Glosa2))
XsGlosa3 = SPACE(LEN(GDOC->Glosa3))
XsGlosa4 = SPACE(LEN(GDOC->Glosa4))
XcFlgEst = [P]
XcFlgUbc = [C]
XcFlgSit = [ ]
STORE 0 TO XfTpoCmb,XfImpNet,XfImpTot,XfSdoDoc,XfImpBto
XiCodMon = 1   && SOLES

RETURN
************************************************************************ FIN()
* Carga variables
******************************************************************************
PROCEDURE xMover

XsNroDoc = GDOC->NroDoc
XdFchDoc = GDOC->FchDoc
XsCodCli = GDOC->CodCli
XsNomCli = GDOC->NomCli
XsDirCli = GDOC->DirCli
XsRucCli = GDOC->RucCli
XsGlosa1 = GDOC->Glosa1
XsGlosa2 = GDOC->Glosa2
XsGlosa3 = GDOC->Glosa3
XsGlosa4 = GDOC->Glosa4
XcFlgEst = GDOC->FlgEst
XcFlgUbc = GDOC->FlgUbc
XcFlgSit = GDOC->FlgSit
XfTpoCmb = GDOC->TpoCmb
XfImpNet = GDOC->ImpNet
XfImpTot = GDOC->ImpTot
XfSdoDoc = GDOC->SdoDoc
XfImpBto = GDOC->ImpBto
XiCodMon = GDOC->CodMon

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

** NOTA > Se puede Modificar
SELE GDOC
IF Crear
   ** control del correlativo **
   SELE GDOC
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   STORE RECNO() TO iNumReg
   ** Control de Correlativos **
   SELE DOCM
   SEEK XsCodDoc+XsPtoVta
   IF ! RLOCK()
      RETURN
   ENDIF
   XsNroDoc1 = SUBST(XsNroDoc,4)
   IF m.NroDoc # XsNroDoc1
      IF SEEK(XsTpoDoc+XsCodDoc+XsNroDoc,"GDOC")
         GsMsgErr = [ Registro Creado por Otro Usuario ]
         DO lib_merr WITH 99
         RETURN
      ENDIF
   ELSE
      * tomamos el correlativo de la base *
      XsNroDoc1 = PADL(ALLTRIM(STR(DOCM->NroDoc)),LEN(GDOC->NroDoc)-3,'0')
      REPLACE DOCM->NroDoc WITH DOCM->NroDoc+1
   ENDIF
   IF XsNroDoc1>=m.NroDoc
      REPLACE DOCM->NroDoc WITH VAL(XsNroDoc1)+1
   ENDIF
   UNLOCK
   XsNroDoc = XsPtoVta+XsNroDoc1
   @  1,17 SAY XsNroDoc PICT "@R 999-"+REPLI("9",LEN(XsNroDoc)-3)
   *
   SELE GDOC
   GO iNumReg
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   IF GDOC->FlgCtb
      DO xDes_Ctb
   ENDIF
ENDIF
SELE GDOC
REPLACE FchDoc WITH XdFchDoc
REPLACE CodCli WITH XsCodCli
REPLACE NomCli WITH XsNomCli
REPLACE DirCli WITH XsDirCli
REPLACE RucCli WITH XsRucCli
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE Glosa1 WITH XsGlosa1
REPLACE Glosa2 WITH XsGlosa2
REPLACE Glosa3 WITH XsGlosa3
REPLACE Glosa4 WITH XsGlosa4
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
Consulta = .F.
Modifica = .T.
Adiciona = .T.
DB_Pinta = .F.
** recalculamos el importe total **
SELE RDOC
STORE 0 TO XfImpTot
SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc=GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
   XfImpTot = XfImpTot + Import
ENDSCAN
@ 21,60 SAY XfImpTot PICT "999,999,999.99"
DO LIB_MTEC WITH 14
DO xBrowse
**********************
SELE GDOC
REPLACE ImpNet WITH XfImpTot
REPLACE ImpTot WITH XfImpTot
REPLACE FchVto WITH XdFchDoc
REPLACE SdoDoc WITH XfImpTot
REPLACE FlgEst WITH XcFlgEst
REPLACE FlgUbc WITH XcFlgUbc
REPLACE FlgSit WITH XcFlgSit
* * * * *
DO xAct_Ctb
* * * * *

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE GDOC
IF FlgEst = [A] .AND. RLOCK()
   SELE VTOS
   SET ORDER TO VTOS03
   SEEK GDOC->CodDoc+GDOC->NroDoc
   IF !RLOCK()
      SET ORDER TO VTOS01
      SELE GDOC
      UNLOCK ALL
      RETURN
   ENDIF
   DELETE
   UNLOCK
   * * * *
   SELE GDOC
   DELETE
   UNLOCK
   SKIP
   RETURN
ENDIF
IF FlgEst # 'P'
   GsMsgErr = [ Acceso Denegado ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF ImpTot # SdoDoc
   GsMsgErr = [ Tiene Aplicaciones Realizadas ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF GDOC->FLgCtb
   XdFchDoc = GDOC->FchDoc
   IF !Modificar()
      GsMsgErr = "Mes Cerrado, acceso denegado"
      DO LIB_MERR WITH 99
      SELE GDOC
      RETURN
   ENDIF
   SELE GDOC
ENDIF
IF !RLOCK()
   RETURN
ENDIF
* borramos detalles *
OK = .T.
SELE RDOC
SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
   IF !RLOCK()
      OK = .F.
      EXIT
   ENDIF
   DELETE
   UNLOCK
ENDSCAN
IF OK
   * * * * *
   DO xDes_Ctb
   * * * * *
   SELE GDOC
   REPLACE FlgEst WITH [A]
   REPLACE FchAct WITH DATE()
   REPLACE SdoDoc WITH 0
  *DELETE      && Por ahora
   SKIP
ENDIF
SELE GDOC
UNLOCK ALL
RETURN
************************************************************************ FIN()
* Browse
******************************************************************************
PROCEDURE xBrowse

PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = []
InsLin   = []
EscLin   = []
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
NClave   = [TpoDoc+CodDoc+NroDoc]
VClave   = GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
HTitle   = 1
Yo       = 13
Xo       = 10
Largo    = 8
Ancho    = 65
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = [Codigo+'  '+LEFT(TABLA->Nombre,40)+' '+TRANS(Import,'999,999,999.99')]
Static   = .F.
VSombra  = .F.
SELECT RDOC
*** Variable a Conocer ****
PRIVATE XsCodigo,XfImport
STORE [] TO XsCodigo,XfImport
**
DO DBrowse
SELECT GDOC
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit

IF ! Crear
   IF !RLOCK()
      RETURN
   ENDIF
   XsCodigo = RDOC->Codigo
   XfImport = RDOC->Import
ELSE
   XsCodigo = SPACE(LEN(RDOC->Codigo))
   XfImport = 0.00
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1        && C¢digo de Cuenta
         SELE TABLA
         @ LinAct,12 GET XsCodigo PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodigo)
            SEEK 'NC'
            IF ! ccbbusca("0005")
               LOOP
            ENDIF
            XsCodigo = TABLA->Codigo
         ENDIF
         @ LinAct,12 SAY XsCodigo
         SEEK 'NC'+XsCodigo
         IF ! FOUND()
            GsMsgErr = "Concepto no Registrado"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ LinAct,19 SAY LEFT(TABLA->Nombre,40)
         IF XsCodigo = "IGV"
            XfImport = ROUND(XfImpTot*CfgADMIgv/100,2)
         ENDIF
      CASE i = 2
         @ LinAct,60 GET XfImport PICT "999,999,999.99" RANGE 0,
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2, 2, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT RDOC
IF UltTecla = Escape
   UNLOCK
ENDIF
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Grabar informacion
******************************************************************************
PROCEDURE MOVbgrab

IF Crear
   APPEND BLANK
   IF !RLOCK()
      RETURN
   ENDIF
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   XfImpTot = XfImpTot - RDOC->Import
ENDIF
REPLACE Codigo WITH XsCodigo
REPLACE Import WITH XfImport
UNLOCK
XfImpTot = XfImpTot + XfImport
@ 21,60 SAY XfImpTot PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Borrar informacion
******************************************************************************
PROCEDURE MOVbborr

IF !RLOCK()
   RETURN
ENDIF
XfImpTot = XfImpTot - RDOC->Import
DELETE
UNLOCK
@ 21,60 SAY XfImpTot PICT "999,999,999.99"

RETURN
************************************************************************ FIN *
FUNCTION _flgest
****************
PARAMETER cFlgEst
DO CASE
   CASE cFlgEst = "P"
      RETURN "Pendiente"
   CASE cFlgEst = "A"
      RETURN "Anulado  "
   CASE cFlgEst = "C"
      RETURN "Cancelado"
   CASE cFlgEst = "T"
      RETURN "Transito "
ENDCASE
RETURN "         "
************************************************************************ FIN *
* Objeto : Impresion en Formato Continuo
************************************************************************ FIN *
PROCEDURE xListar

* posicionamos punteros *
=SEEK(XsClfAux+GDOC->CodCli,"CLIE")
=SEEK(GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc,"RDOC")
XFOR   = ".T."
XWHILE = "TpoDoc+CodDoc+NroDoc=GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc"
SELE RDOC
Largo  = 42       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1+_PRN6A]
sNomRep = "VTAncarg"
*DO DIRPRINT WITH "REPORTS" IN ADMPRINT
DO ADMPRINT  WITH "REPORTS"
RETURN
************************************************************************ FIN *
* Objeto : Modificacion en el mes activo
**********************************************************************
FUNCTION Modificar

PRIVATE _MES,_ANO,DirCtb
_MES = MONTH(XdFchDoc)
_ANO = YEAR(XdFchDoc)
DirCtb = PathDef+"\cia"+GsCodCia+"\c"+STR(_ANO,4)+"\"
SELECT 0
USE &DirCtb.CBDTCIER ALIAS TCIE
IF !USED()
   RETURN .T.
ENDIF
*
SELE TCIE
RegAct = MONTH(XdFchDoc) + 1
IF RegAct <= RECCOUNT()
   GO RegAct
ENDIF
lCierre = !Cierre
USE

RETURN lCierre
**********************************************************************
* Objeto : Actualiza de Contabilidad
******************************************************************************
PROCEDURE xAct_Ctb

* Abrimos Base de Datos *
PRIVATE _MES,_ANO,DirCtb
_MES = MONTH(GDOC->FchDoc)
_ANO = YEAR(GDOC->FchDoc)
DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
IF !Open_File()
   RETURN
ENDIF
* Grabamos Cabecera *
PRIVATE XsNroMes,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsNotAst,XsCodOpe,XsNroAst
XsNroMes = TRANS(_MES,"@L ##")
XdFchAst = GDOC->FchDoc
XsNroVou = []
XiCodMon = GDOC->CodMon
XfTpoCmb = GDOC->TpoCmb
XsNotAst = [PROV. ]+GDOC->CodDoc+[. ]+GDOC->NomCli
XsCodOpe = [006]
=SEEK(XsCodOpe,"OPER")
IF !RLOCK("OPER")
   DO Close_File
   RETURN
ENDIF
XsNroAst = NROAST()
WAIT "Generando Asiento "+XsNroAst WINDOW NOWAIT
SELE Head
APPEND BLANK
IF !REC_LOCK(5)
   DO Close_File
   RETURN
ENDIF
REPLACE NroMes WITH XsNroMes
REPLACE CodOpe WITH XsCodOpe
REPLACE NroAst WITH XsNroAst
REPLACE FlgEst WITH "R"
*
REPLACE GDOC->NroMes WITH XsNroMes
REPLACE GDOC->CodOpe WITH XsCodOpe
REPLACE GDOC->NroAst WITH XsNroAst
REPLACE GDOC->FlgCtb WITH .T.
*
SELECT OPER
=NROAST(XsNroAst)
SELECT Head
REPLACE FchAst WITH XdFchAst
REPLACE NroVou WITH XsNroVou
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE NotAst WITH XsNotAst
REPLACE Digita WITH GsUsuario
* Grabamos Detalle *
PRIVATE XiNroItm,XcEliItm,XsCodCta,XsCodRef,XsClfAux,XsCodAux,XcTpoMov
PRIVATE XsNroRuc,XfImpNac,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XfImport,XdFchDoc,XdFchVto
* Cuenta de N/C
XiNroItm = 1
SELE RDOC
SEEK GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc=GDOC->TpoDoc+GDOC->CodDoc+GDOC->NroDoc
   =SEEK([NC]+Codigo,"TABLA")
   IF Codigo = [IGV]
      XcEliItm = [ ]
      XsCodCta = TABLA->CtrCta
      XsCodRef = GDOC->CodDoc
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = GsClfAux
         XsCodAux = GDOC->CodCli
         XsNroRuc = GDOC->RucCli
      ELSE
         XsClfAux = SPACE(LEN(Item->ClfAux))
         XsCodAux = SPACE(LEN(Item->CodAux))
         XsNroRuc = SPACE(LEN(Item->NroRuc))
      ENDIF
      XcTpoMov = [H]
      XfImport = RDOC->Import
      IF XiCodMon = 1
         XfImpNac = XfImport
         XfImpUsa = XfImport/XfTpoCmb
      ELSE
         XfImpUsa = XfImport
         XfImpNac = XfImport*XfTpoCmb
      ENDIF
      XsGloDoc = GDOC->NomCli
      XsCodDoc = GDOC->CodDoc
      XsNroDoc = GDOC->NroDoc
      XsNroRef = GDOC->NroDoc
      XdFchDoc = GDOC->FchDoc
      XdFchVto = GDOC->FchVto
      DO MovbVeri IN vtammovm
   ELSE
      * Cuenta
      XcEliItm = [ ]
      XsCodCta = TABLA->CodCta
      XsCodRef = GDOC->CodDoc
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = GsClfAux
         XsCodAux = GDOC->CodCli
         XsNroRuc = GDOC->RucCli
      ELSE
         XsClfAux = SPACE(LEN(Item->ClfAux))
         XsCodAux = SPACE(LEN(Item->CodAux))
         XsNroRuc = SPACE(LEN(Item->NroRuc))
      ENDIF
      XcTpoMov = [D]
      XfImport = GDOC->ImpTot
      IF XiCodMon = 1
         XfImpNac = XfImport
         XfImpUsa = XfImport/XfTpoCmb
      ELSE
         XfImpUsa = XfImport
         XfImpNac = XfImport*XfTpoCmb
      ENDIF
      XsGloDoc = GDOC->NomCli
      XsCodDoc = GDOC->CodDoc
      XsNroDoc = GDOC->NroDoc
      XsNroRef = GDOC->NroDoc
      XdFchDoc = GDOC->FchDoc
      XdFchVto = GDOC->FchVto
      DO MovbVeri IN vtammovm
      * Contracuenta
      XcEliItm = [ ]
      XsCodCta = TABLA->CtrCta
      XsCodRef = GDOC->CodDoc
      =SEEK(XsCodCta,"CTAS")
      IF CTAS->PIDAUX="S"
         XsClfAux = GsClfAux
         XsCodAux = GDOC->CodCli
         XsNroRuc = GDOC->RucCli
      ELSE
         XsClfAux = SPACE(LEN(Item->ClfAux))
         XsCodAux = SPACE(LEN(Item->CodAux))
         XsNroRuc = SPACE(LEN(Item->NroRuc))
      ENDIF
      XcTpoMov = [H]
      XfImport = RDOC->Import
      IF XiCodMon = 1
         XfImpNac = XfImport
         XfImpUsa = XfImport/XfTpoCmb
      ELSE
         XfImpUsa = XfImport
         XfImpNac = XfImport*XfTpoCmb
      ENDIF
      XsGloDoc = GDOC->NomCli
      XsCodDoc = GDOC->CodDoc
      XsNroDoc = GDOC->NroDoc
      XsNroRef = GDOC->NroDoc
      XdFchDoc = GDOC->FchDoc
      XdFchVto = GDOC->FchVto
      DO MovbVeri IN vtammovm
   ENDIF
   SELE RDOC
ENDSCAN
* * * *
SELE HEAD
*DO ImprVouc IN VTAMMOVM
* * * *
DO Close_File

RETURN
*********************************************************************** FIN() *
* Objeto : Des-Actualiza Contabilidad
******************************************************************************
PROCEDURE xDes_Ctb

* Abrimos Base de Datos *
PRIVATE _MES,_ANO,DirCtb
_MES = VAL(GDOC->NroMes)
_ANO = YEAR(GDOC->FchDoc)
DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
IF !Open_File()
   RETURN
ENDIF
XsNroMes = GDOC->NroMes
XsCodOpe = GDOC->CodOpe
XsNroAst = GDOC->NroAst
SELE Head
SEEK XsNroMes+XsCodOpe+XsNroAst
IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   DO LIB_MERR WITH 99
   DO Close_File
   RETURN              && No pudo bloquear registro
ENDIF
SELECT Head
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
Ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
   Llave = (NroMes + CodOpe + NroAst )
   IF Rlock()
      SELECT Item
      IF ! XsCodOpe = "9"
         DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
      ELSE
         DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
      ENDIF
      DELETE
      UNLOCK
   ELSE
      Ok = .f.
   ENDIF
   SKIP
ENDDO
SELECT Head
IF Ok
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
*DO ImprVouc IN VTAMMOVM
DO Close_File

RETURN
************************************************************************** FIN
* Objeto : Abrir Base de Contabilidad
******************************************************************************
PROCEDURE Open_File

USE cbdmctas IN 0 ORDER ctas01 ALIAS CTAS
IF !USED()
   RETURN 0
ENDIF
*
USE &DirCtb.cbdvmovm IN 0 ORDER vmov01 ALIAS Head
IF !USED()
   SELE CTAS
   USE
   RETURN 0
ENDIF
*
USE &DirCtb.cbdrmovm IN 0 ORDER rmov01 ALIAS Item
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   RETURN 0
ENDIF
*
USE &DirCtb.cbdtoper IN 0 ORDER oper01 ALIAS OPER
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   SELE Item
   USE
   RETURN 0
ENDIF
*
USE &DirCtb.cbdacmct IN 0 ORDER acct01 ALIAS ACCT
IF !USED()
   SELE CTAS
   USE
   SELE Head
   USE
   SELE Item
   USE
   SELE OPER
   USE
   RETURN 0
ENDIF
*

RETURN .T.
*********************************************************************** FIN() *
* Objeto : Cerrar Base de Contabilidad
******************************************************************************
PROCEDURE Close_File

SELE CTAS
USE
SELE Head
USE
SELE Item
USE
SELE OPER
USE
SELE ACCT
USE

RETURN
*********************************************************************** FIN() *
