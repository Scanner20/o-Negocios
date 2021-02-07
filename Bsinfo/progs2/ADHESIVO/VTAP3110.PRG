****************************************************************************
* Programa     : vtap3100.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Ingreso de Guias de Remision
* Creacion     : 15/06/94
* Parametros   :
* Actualizacion: RHC 22/08/94 Disgregar el ingreso de guias
*                RHC 01/10/94 Guia Libre (Sin Pedido)
****************************************************************************


** Pantalla de Datos **
DO xPanta
** base de datos **
CLOSE DATA
* ARCHIVOS DE VENTAS *
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 2
USE vtavpedi ORDER VPED01 ALIAS VPED
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 3
USE vtarpedi ORDER RPED02  ALIAS RPED
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 4
USE vtatdocm ORDER DOCM01 ALIAS DOCM
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 5
USE vtavguia ORDER VGUI01 ALIAS VMOV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
* ARCHIVOS DE ALMACEN *
SELE 6
USE almmmatg ORDER MATG01 ALIAS MATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 7
USE almmmate ORDER MATE01 ALIAS MATE
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 8
USE almrmovm ORDER RMOV06 ALIAS RMOV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 9
USE almtsalm ORDER SALM01 ALIAS SALM
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
*
SELE 11
USE almvlote ORDER LOTE02 ALIAS LOTE
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 12
USE vtacrono ORDER CRON01 ALIAS CRONO
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 13
USE almtuvta ORDER UVTA01 ALIAS UVTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
RESTORE FROM VTACONFG ADDITIVE
** relaciones a usar **
SELECT VMOV
SET RELATION TO GsClfAux+CodCli INTO CLIE
** variables a usar **
** variables de movimientos del almacen **
PRIVATE XcTipMov,XsCodMov,XlModCsm
XcTipMov = [S]    && Salida
XsCodMov = [G01]   && Depende del punto de venta
XlModCsm = .T.
** variables de cabecera **
PRIVATE XsPtoVta,XsNroDoc,XdFchDoc,XsNroPed
PRIVATE XsGloDoc,XcFlgEst,XiFmaPgo,XsCodRef,XsNroRef
PRIVATE XsNroO_C,XdFchO_C
PRIVATE XsCodCli,XsNomCli,XsDirCli,XsRucCli,XsDirEnt
STORE [] TO XsPtoVta,XsNroDoc,XdFchDoc,XsCodCli,XsNroPed
STORE [] TO XsGloDoc,XcFlgEst,XiFmaPgo,XsCodRef,XsNroRef
STORE [] TO XsNroO_C,XdFchO_C
STORE [] TO XsCodCli,XsNomCli,XsDirCli,XsRucCli,XsDirEnt
** datos del chofer **
PRIVATE XsRUCTra,XsNomTra,XsNomCho,XsPlaTra,XsNroBre
STORE [] TO XsRUCTra,XsNomTra,XsNomCho,XsPlaTra,XsNroBre
** Variables del Browse **
PRIVATE AsCodMat,AsUndVta,AfFacEqu,AfCanDes,AiNumReg,GiTotItm,AiLote  ,AsSubAlm
PRIVATE AiRegDel,GiTotDel
CIMAXELE = 10
DIMENSION AsSubAlm(CIMAXELE)
DIMENSION AsCodMat(CIMAXELE)
DIMENSION AiLote  (CIMAXELE)
DIMENSION AsDesMat(CIMAXELE)
DIMENSION AsUndVta(CIMAXELE)
DIMENSION AfFacEqu(CIMAXELE)
DIMENSION AfCanDes(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)
DIMENSION AiRegDel(CIMAXELE)
GiTotItm = 0
GiTotDel = 0
** control correlativo multiusuario **
PRIVATE m.NroDoc,XsCodDoc
m.NroDoc = []
XsCodDoc = [G/R ]
** Logica Principal **
SELE VMOV
DO LIB_MTEC WITH 3
UltTecla = 0
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [],[],'CMA',[]
CLOSE DATA
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> GUIAS DE REMISION <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  4,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  5,0  SAY "³   Guia No. :                                          Fecha :                ³"
@  6,0  SAY "³ Pedido No. :                                        Venta a :                ³"
@  7,0  SAY "³    Cliente :                                                                 ³"
@  8,0  SAY "³        RUC :                                                                 ³"
@  9,0  SAY "³ Oficina en :                                                                 ³"
@ 10,0  SAY "³Entregar en :                                                                 ³"
@ 11,0  SAY "ÃÄÄGlosa :ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
@ 14,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 15,0  SAY "³ C¢digo  Alm. Lote        Descripci¢n                           Und  Cantidad ³" COLOR SCHEME 7
@ 16,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "³                                                                              ³"
@ 19,0  SAY "³                                                                              ³"
@ 20,0  SAY "³                                                                              ³"
@ 21,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
*
RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave
****** Buscando Los puntos de Ventas Activos **********
SELE DOCM
SEEK XsCodDoc
IF !FOUND()
   SELECT VMOV
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
@ 5,17 SAY XsPtoVta
i = 1
SELE VMOV
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1 .AND. XiPidPto
         SELE DOCM
         @ 5,17 GET XsPtoVta PICT "@9"
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
         @ 5,17 SAY XsPtoVta
         SEEK XsCodDoc+XsPtoVta
         IF !FOUND()
            GsMsgErr = "No existe correlativo"
            DO lib_merr WITH 99
            LOOP
         ENDIF
      CASE i = 2
         XiNroDoc  = DOCM->NroDoc
         XsNroDoc = XsPtoVta + TRANSF(XiNroDoc,"@L 999999")
         SELE VMOV
         IF CHRVAL # "C"
            @ 5,21 GET XiNroDoc PICT "@L 999999"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,Escape)
               LOOP
            ENDIF
            IF UltTecla = F8
               IF ! vtabusca("0005")
                  UltTecla = 0
                  LOOP
               ENDIF
               XiNroDoc  = VAL(SUBSTR(VMOV->NroDoc,4))
            ENDIF
         ELSE
            SEEK XsCodDoc+XsNroDoc
            UltTecla = Enter
            @ 5,17 SAY XsNroDoc PICT "@R 999-999999"
            IF FOUND()
               GsMsgErr = "Error en el Registro de Correlativos"
               DO LIB_MERR WITH 99
               UltTecla = Escape
            ENDIF
         ENDIF
         XsNroDoc = XsPtoVta + TRANSF(XiNroDoc,"@L 999999")
         @ 5,17 SAY XsNroDoc PICT "@R 999-999999"
   ENDCASE
   IF UltTecla=Enter .AND. i = 2
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE VMOV
SEEK XsCodDoc+XsNroDoc
RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

SELE VMOV
Crear = .T.
IF &RegVal
   Crear = .F.
   IF FlgEst = 'A'
      UltTecla = Escape
      GsMsgErr = [ Guia Anulada ]
      DO lib_merr WITH 99
      UNLOCK
      RETURN
   ENDIF
   IF FlgEst = 'F'
      UltTecla = Escape
      GsMsgErr = [ Guia Facturada ]
      DO lib_merr WITH 99
      UNLOCK
      RETURN
   ENDIF
   IF ! Clave(CFGPasswD)
      UltTecla = Escape
      RETURN
   ENDIF
   IF ! RLOCK()
      UltTecla = Escape
      RETURN
   ENDIF
   DO xMover
   cTecla = [Escape,F10,CtrlW]
ELSE
   DO xInvar
   cTecla = [Escape]
ENDIF
*
@  5,63 GET XdFchDoc
@  6,17 GET XsNroPed
@ 12,1  EDIT XsGloDoc SIZE 2,78 COLOR SCHEME 7 DISABLE
CLEAR GETS
UltTecla = 0
PRIVATE i
i = 1
DO WHILE ! INLIST(UltTecla,&cTecla.)
   i = IIF(!Crear.AND.i<4,4,i)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         ** Seleccion de forma de facturar **
         SAVE SCREEN TO LsPanToma
         @ 1,48 CLEAR TO 5,69
         @ 2,49,6,70 BOX "±±±±±±±±"
         @ 1,48 TO 6,69 DOUBLE
         @  2,49 PROMPT "  1.- UN PEDIDO     "
         @  3,49 PROMPT "  2.- UNA FACTURA   "
         @  4,49 PROMPT "  3.- LIBRE         "
         MENU TO LiOpcion
         RESTORE SCREEN FROM LsPanToma
         IF LiOpcion = 0
            UltTecla = Escape
            EXIT
         ENDIF
         UltTecla = Enter

      CASE i = 2
         @ 5,63 GET XdFchDoc
         READ
         UltTecla = LASTKEY()
         @ 5,63 SAY XdFchDoc

      CASE i = 3
         * Separamos la toma de datos adicionales *
         DO CASE
            CASE LiOpcion = 1
               XsCodRef = [PEDI]
               DO xTomar1
            CASE LiOpcion = 2
               XsCodRef = [FACT]
               DO xTomar2
            CASE LiOpcion = 3
               XsCodRef = [FREE]
               DO xTomar3
         ENDCASE


      CASE i = 3 .AND. EMPTY(XsCodCli)
         DO xTomar1

      CASE i = 4
         GsMsgKey = "[Shift+Tab] Anterior   [Tab] Siguiente   [Esc] Cancelar"
         DO lib_mtec WITH 99
         @ 12,1  EDIT XsGloDoc SIZE 2,78 COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
         @ 12,1  EDIT XsGloDoc SIZE 2,78 DISABLE
         IF INLIST(UltTecla,BackTab,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
      CASE i = 5
         DO xBrowse
      CASE i = 6
         DO xTomar2
      CASE i = 7
         cResp = [N]
         cResp = aviso(12,[Datos Correctos (S-N)?],[],[],3,[SN],0,.T.,.F.,.T.)
         IF cResp = [N]
            i = i - 1
            LOOP
         ENDIF
         UltTecla = Enter
   ENDCASE
   IF i = 7  .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>7 , 7,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
ENDIF
SELE VMOV
UNLOCK ALL
DO LIB_MTEC WITH 3

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar1


GsMsgErr = "[Esc] Cancelar   [Enter] Aceptar   [F8] Consulta   [] Anterior"
DO lib_mtec WITH 99
SELE VPED
@ 6,17 GET XsNroPed PICT "@!"
READ
UltTecla = LASTKEY()
IF INLIST(UltTecla,Escape,Arriba,BackTab)
   i = i - 1
   LOOP
ENDIF
IF UltTecla = F8
   IF ! vtabusca("0002")
      LOOP
   ENDIF
   XsNroPed = VPED->NroDoc
ENDIF
@ 6,17 SAY XsNroPed
IF EMPTY(XsNroPed) .AND. UltTecla # F6
   UltTecla = 0
   LOOP
ENDIF
IF !EMPTY(XsNroPed)
   SEEK XsNroPed
   IF !FOUND()
      DO lib_merr WITH 6
      LOOP
   ENDIF
   IF FlgEst = [A]
      GsMsgErr = [Pedido Anulado]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   IF FlgEst = [C]
      GsMsgErr = [Pedido Cerrado]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   ** Verificamos si Existen despachos por Realizar **
   IF !vta_item()
      GsMsgErr = [No hay saldos por despachar]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   ** Cargamos Datos **
   SELE VPED
   IF !RLOCK()
      LOOP
   ENDIF
   XsCodCli = CodCli
   XsNomCli = NomCli
   XsDirCli = DirCli
   XsDirEnt = DirCli
   XsRucCli = RucCli
   XiFmaPgo = FmaPgo
   XsNroRef = XsNroPed
   XdFchO_C = FchO_C
   XsNroO_C = NroO_C
   XsGloDoc = GloDoc
   IF !(XsCodCli=[9999])
      =SEEK(GsClfAux+XsCodCli,"CLIE")
      XsNomCli = CLIE->NomAux
      XsDirCli = CLIE->DirAux
      XsDirEnt = CLIE->DirEnt
      XsRucCli = CLIE->RucAux
   ENDIF
   @ 7,17 SAY XsCodCli+' '+TRANS(XsNomCli,'@S50')
   @ 8,17 SAY XsRucCli
   @ 9,17 SAY XsDirCli
   @ 10,17 SAY XsDirEnt
   @ 6,63 SAY vta_pgo(XiFmaPgo)
ENDIF




* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar1
@  7,17 GET XsCodCli
@  7,23 GET XsNomCli PICT '@S50'
@  8,17 GET XsRucCli
@  9,17 GET XsDirCli
@ 10,17 GET XsDirEnt
CLEAR GETS
UltTecla = 0
PRIVATE i
i = 1
DO WHILE ! INLIST(UltTecla,Escape)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         SELE CLIE
         @  7,17 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Arriba,Escape)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodCli)
            IF !vtabusca("CLIE")
               LOOP
            ENDIF
            XsCodCli = CodAux
         ENDIF
         @  7,17 SAY XsCodCli PICT "@!"
         IF XsCodCli=[9999]   && Codigo Libre
            @  7,23 GET XsNomCli PICT '@!S50'
            @  8,17 GET XsRucCli PICT "@!"
            @  9,17 GET XsDirCli PICT "@!"
            @ 10,17 GET XsDirEnt PICT "@!"
            READ
            UltTecla = LASTKEY()
         ELSE
            SEEK GsClfAux+XsCodCli
            IF !FOUND()
               DO lib_merr WITH 9
               LOOP
            ENDIF
            XsNomCli = NomAux
            XsDirCli = DirAux
            XsDirEnt = DirEnt
            XsRucCli = RucAux
         ENDIF
         @  7,23 SAY XsNomCli PICT '@!S50'
         @  8,17 SAY XsRucCli PICT "@!"
         @  9,17 SAY XsDirCli PICT "@!"
         @ 10,17 SAY XsDirEnt PICT "@!"
      CASE i = 2
         DO LIB_MTEC WITH 16
         VecOpc(1)="Contado"
         VecOpc(2)="Credito"
         VecOpc(3)="Consignacion"
         XiFmaPgo= Elige(XiFmaPgo,6,63,3)
   ENDCASE
   IF i = 1 .AND. INLIST(UltTecla,BackTab,Arriba)
      EXIT
   ENDIF
   IF i = 2  .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>2 , 2,i)
ENDDO
IF UltTecla = Escape
   UltTecla = Arriba
ENDIF

RETURN
************************************************************************ FIN()
* Pedir Informacion del Transportista
******************************************************************************
PROCEDURE xTomar2
SAVE SCREEN TO LsPan01
@  9,18 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»" COLOR SCHEME 7
@ 10,18 SAY "º Transportista :                                          º" COLOR SCHEME 7
@ 11,18 SAY "º           RUC :                                          º" COLOR SCHEME 7
@ 12,18 SAY "º        Chofer :                                          º" COLOR SCHEME 7
@ 13,18 SAY "º   Vehiculo No.:                                          º" COLOR SCHEME 7
@ 14,18 SAY "º    Brevete No.:                                          º" COLOR SCHEME 7
@ 15,18 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7

UltTecla = 0
PRIVATE i
i = 1
GsMsgKey = " [] [] Seleccionar  [Enter] Aceptar [Esc] Anterior [F10] Aceptar Todo [F9] En Blanco"
DO LIB_MTEC WITH 99
DO WHILE .T.
   @ 10,36 GET XsNomTra PICT "@!"
   @ 11,36 GET XsRUCTra
   @ 12,36 GET XsNomCho PICT "@!"
   @ 13,36 GET XsPlaTra PICT "@!"
   @ 14,36 GET XsNroBre PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF UltTecla = F9
      XsNomTra = SPACE(LEN(XsNomTra))
      XsRUCTra = SPACE(LEN(XsRUCTra))
      XsNomCho = SPACE(LEN(XsNomCho))
      XsPlaTra = SPACE(LEN(XsPlaTra))
      XsNroBre = SPACE(LEN(XsNroBre))

      @ 10,36 SAY XsNomTra PICT "@!"
      @ 11,36 SAY XsRUCTra
      @ 12,36 SAY XsNomCho PICT "@!"
      @ 13,36 SAY XsPlaTra PICT "@!"
      @ 14,36 SAY XsNroBre PICT "@!"
      UltTecla = F10
   ENDIF
   IF INLIST(UltTecla,Arriba,F10,Enter,BackTab,Escape)
      EXIT
   ENDIF
ENDDO
RESTORE SCREEN FROM LsPan01
IF INLIST(UltTecla,Arriba,Escape,BackTab)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF

RETURN
************************************************************************ FIN()
* Cargar variables
******************************************************************************
PROCEDURE xMover

SELE VMOV
XsNroDoc = NroDoc
XdFchDoc = FchDoc
XsCodCli = CodCli
XsNomCli = NomCli
XsDirCli = DirCli
XsDirEnt = DirEnt
XsRucCli = RucCli
XsNroPed = NroPed
XcFlgEst = FlgEst
XiFmaPgo = FmaPgo
XsCodRef = CodRef
XsNroRef = NroRef
XsNroO_C = NroO_C
XdFchO_C = FchO_C
XsGloDoc = GLODOC
* * * *
XsPtoVta = LEFT(XsNroDoc,3)
XsCodMov = [G]+RIGHT(XsPtoVta,2)
**
XsRUCTra = RUCTra
XsNomTra = NomTra
XsNomCho = NomCho
XsPlaTra = PlaTra
XsNroBre = NroBre
** cargamos arreglos **
DO xBmove
***********************
SELE VMOV

RETURN
************************************************************************ FIN()
* Inicializamos Variables
******************************************************************************
PROCEDURE xInvar

XsCodMov = [G]+RIGHT(XsPtoVta,2)
XdFchDoc = GdFecha
XsCodCli = SPACE(LEN(CodCli))
XsNomCli = SPACE(LEN(NomCli))
XsDirCli = SPACE(LEN(DirCli))
XsDirEnt = SPACE(LEN(DirEnt))
XsRucCli = SPACE(LEN(RucCli))
XsNroPed = SPACE(LEN(NroPed))
XcFlgEst = [E]    && Emitido, Cerrado, Anulado
XiFmaPgo = 0
XsCodRef = [PEDI]
XsNroRef = SPACE(LEN(NroRef))
** variables del transportista **
STORE [] TO XsRUCTra,XsNomTra,XsNomCho,XsPlaTra,XsNroBre
XsRUCTra = CFGRUCTra
XsNomTra = CFGNomTra
XsNomCho = CFGNomCho
XsPlaTra = CFGPlaTra
XsNroBre = CFGNroBre
XsNroO_C = SPACE(LEN(NroO_C))
XdFchO_C = {,,}
** Variables del Browse **
STORE [001]                    TO AsSubAlm
STORE SPACE(LEN(RMOV->CodMat)) TO AsCodMat
STORE 0                        TO AiLote
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat
STORE SPACE(LEN(RPED->UndVta)) TO AsUndVta
STORE 1                        TO AfFacEqu
STORE 0                        TO AfCanDes
STORE 0                        TO AiNumReg
STORE 0                        TO AiRegDel
GiTotItm = 0
GiTotDel = 0

RETURN
************************************************************************ FIN()
* Pintar Informacion en Pantalla
******************************************************************************
PROCEDURE xPoner

@  5,17 SAY NroDoc PICT "@R 999-999999"
@  5,63 SAY FchDoc
@  6,17 SAY NroPed
@  7,17 SAY CodCli+' '+TRANS(NomCli,'@S50')
@  8,17 SAY RucCli
@  9,17 SAY DirCli
@ 10,17 SAY DirEnt
@  6,63 SAY vta_pgo(FmaPgo)
@ 12,1  EDIT GloDoc SIZE 2,78 DISABLE
* * * *
XsCodMov = [G]+SUBSTR(NroDoc,2,2)
LsLlave  = XcTipMov+XsCodMov+SUBSTR(NroDoc,4)
SELE RMOV
SEEK LsLlave
NumLin = 17
@ 17,2 CLEAR TO 20,76
SCAN WHILE TipMov+CodMov+NroDoc=LsLlave .AND. NumLin <= 20
   =SEEK(RMOV->CodMat,'MATG')
   =SEEK(VMOV->NroPed+RMOV->CodMat,'RPED')
   @ NumLin,2  SAY CodMat
   @ NumLin,11 SAY SubAlm
   @ NumLin,15 SAY Lote   PICT "@Z 999999"
   @ NumLin,22 SAY DesMat PICT "@S40"
   @ NumLin,63 SAY UndVta
   @ NumLin,67 SAY CanDes PICT "999,999.99"
   NumLin = NumLin + 1
ENDSCAN
IF VMOV->FlgESt = "A"
   @ 17,11 SAY "     #    #     # #     # #          #    ######  #######  "
   @ 18,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
   @ 19,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
   @ 20,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ENDIF
* *
SELE VMOV

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

SELE VMOV
IF Crear
   ** NOTA > En crear se genera SIEMPRE correlativos **
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   * control de correlativo *
   SELE DOCM
   SEEK XsCodDoc+XsPtoVta
   IF ! RLOCK()
      RETURN
   ENDIF
   * tomamos el correlativo de la base *
   XsNroDoc1 = PADL(ALLTRIM(STR(DOCM->NroDoc)),LEN(VMOV->NroDoc)-3,'0')
   REPLACE DOCM->NroDoc WITH DOCM->NroDoc+1
   UNLOCK
   XsNroDoc = XsPtoVta+XsNroDoc1
   @ 5,17 SAY XsNroDoc PICT "@R 999-9999999"
   SELE VMOV
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
REPLACE FchDoc WITH XdFchDoc
REPLACE CodCli WITH XsCodCli
REPLACE NomCli WITH XsNomCli
REPLACE DirCli WITH XsDirCli
REPLACE DirEnt WITH XsDirEnt
REPLACE RucCli WITH XsRucCli
REPLACE NroPed WITH XsNroPed
REPLACE GloDoc WITH XsGloDoc
REPLACE FlgEst WITH XcFlgEst
REPLACE FmaPgo WITH XiFmaPgo
REPLACE CodRef WITH XsCodRef
REPLACE NroRef WITH XsNroRef
*
REPLACE NroO_C WITH XsNroO_C
REPLACE FchO_C WITH XdFchO_C
*
REPLACE RUCTra WITH XsRUCTra
REPLACE NomTra WITH XsNomTra
REPLACE NomCho WITH XsNomCho
REPLACE PlaTra WITH XsPlaTra
REPLACE NroBre WITH XsNroBre
** Grabamos Browse **
DO xBgrab
*********************
** IMPRESION DE LA GUIA **
SELE RMOV
LsLlave  = XcTipMov+XsCodMov+SUBSTR(XsNroDoc,4)
SEEK LsLlave
* test de impresion *
xFOR = []
xWHILE = [TipMov+CodMov+NroDoc=LsLlave]
DO xImprimir
* * *
SELE VMOV

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

=SEEK(VMOV->NroPed,"VPED")
IF !RLOCK("VPED")
   RETURN
ENDIF
**
SELE VMOV
IF ! RLOCK()
   RETURN
ENDIF
** anulamos detalles **
PRIVATE GsSubAlm
XsCodMov = [G]+SUBSTR(NroDoc,2,2)
LsLlave  = XcTipMov+XsCodMov+SUBSTR(NroDoc,4)
SELE RMOV
SEEK LsLlave
DO WHILE TipMov+CodMov+NroDoc=LsLlave .AND. ! EOF()
   IF ! RLOCK()
      LOOP
   ENDIF
   **
   GsSubAlm = SubAlm
   ** Posicionamos punteros
   =SEEK(VMOV->NroPed+RMOV->CodMat,"RPED")
   IF !RLOCK("RPED")
      LOOP
   ENDIF
   =SEEK(RMOV->CodMat,"MATG")
   IF !RLOCK("MATG")
      LOOP
   ENDIF
   =SEEK(GsSubAlm+RMOV->CodMat,"MATE")
   IF !RLOCK("MATE")
      LOOP
   ENDIF
   ** Des-actualizamos pedidos **
   DO xDes_Ped
   ** actualizamos almacenes **
   SELE RMOV
   DELETE
   DO AlmCgStk WITH .T.
   SKIP
ENDDO
** actualiza cabecera de pedidos **
SELE RPED
SEEK VMOV->NroPed
LcFlgEst = [C]
SCAN WHILE NroDoc=VMOV->NroPed
   IF FlgEst # [C]      && Atencion Parcial
      LcFlgEst = [E]
      EXIT
   ENDIF
ENDSCAN
SELE VPED
REPLACE VPED->FlgEst WITH LcFlgEst
UNLOCK
**
SELE VMOV
REPLACE FlgEst WITH [A]
UNLOCK ALL
SKIP

RETURN
************************************************************************ FIN()
* Browse de Datos
****************************************************************************
PROCEDURE xBrowse

** OJO > El browse se configura de acuerdo a las necesidades
EscLin   = "xBline"
BrrLin   = "xBborr"
InsLin   = "xBinse"
IF !EMPTY(XsNroPed)     && G/R por Pedido
   EdiLin   = "xBedit1"
   IF Crear
      DO xBCarga     && Carga arreglo con saldos del Pedido
   ENDIF
ELSE
   EdiLin   = "xBedit2" && G/R Libre
ENDIF
PrgFin   = []
*
Yo       = 16
Xo       = 1
Largo    = 6
Ancho    = 79
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99
DO aBrowse
*
IF INLIST(UltTecla,Escape)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE xBline
PARAMETERS NumEle, NumLin

@ NumLin,2  SAY AsCodMat(NumEle)
@ NumLin,11 SAY AsSubAlm(NumEle)
@ NumLin,15 SAY AiLote  (NumEle) PICT "@Z 999999"
@ NumLin,22 SAY AsDesMat(NumEle) PICT "@S40"
@ NumLin,63 SAY AsUndVta(NumEle)
@ NumLin,67 SAY AfCanDes(NumEle) PICT "999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit1
PARAMETERS NumEle, NumLin

PRIVATE i,LfCanLim,LlCrear
i        = 1
UltTecla = 0
LfCanLim = 0      && Control de maxima cantidad a despachar
LlCrear  = .T.    && Control Interno de Modificacion
*
LsSubAlm = AsSubAlm(NumEle)
LsCodMat = AsCodMat(NumEle)
LiLote   = AiLote  (NumEle)
LsDesMat = AsDesMat(NumEle)
LsUndVta = AsUndVta(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LfCanDes = AfCanDes(NumEle)
LiNumReg = AiNumReg(NumEle)
LlCrear  = IIF(!EMPTY(LsCodMat),.F.,.T.)
DO WHILE !INLIST(UltTecla,Escape)
   GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1 .AND. LlCrear
         GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE RPED
         @ NumLin,2 GET LsCodMat PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba,Abajo)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
            SET RELA TO CodMat INTO MATG
            IF !vtabusca("0007")
               SET RELA TO
               LOOP
            ENDIF
            SET RELA TO
            LsCodMat = RPED->CodMat
         ENDIF
         @ NumLin,2 SAY LsCodMat
         SEEK XsNroPed+LsCodMat
         IF !FOUND()
            GsMsgErr = [Material no Pertenece al Pedido]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF CanDes>=CanPed
            GsMsgErr = [Material ya esta totalmente despachado]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF xRepite()
            GsMsgErr = [Dato ya Registrado]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         =SEEK(LsCodMat,"MATG")
         LsDesMat = RPED->DesMat
         LsUndVta = RPED->UndVta
         LfFacEqu = RPED->FacEqu
         LiLote   = MATG->Lote
         ** control de maximo despacho **
         LfCanLim = RPED->CanPed-RPED->CanDes
         LfCanDes = LfCanLim
         ** pintamos datos **
         @ NumLin,22 SAY LsDesMat PICT "@S40"
         @ NumLin,63 SAY LsUndVta

      CASE i = 1 .AND. !LlCrear
         =SEEK(LsCodMat,"MATG")
         =SEEK(XsNroPed+LsCodMat,"RPED")
         LfCanLim = (RPED->CanPed-RPED->CanDes)+LfCanDes
         UltTecla = Enter

      CASE i = 2 .AND. ! (LsCodMat=[9])
         SELE SALM
         @ NumLin,11 GET LsSubAlm PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(LsSubAlm) .OR. UltTecla = F8
            IF !vtabusca("0006")
               LOOP
            ENDIF
            LsSubAlm = SubAlm
         ENDIF
         @ NumLin,11 SAY LsSubAlm
         SEEK LsSubAlm
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         ** Verificamos si se puede despachar de este almacen **
         SELE MATE
         SEEK LsSubAlm+LsCodMat
         IF !FOUND()
            GsMsgErr = [Material no registrado en el Almacen]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         =SEEK(LsCodMat,"MATG")

      CASE i = 3 .AND. MATG->PidLot
         SELE LOTE
         @ NumLin,15 GET LiLote   PICT "999999"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Izquierda,Escape)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LiLote)
            XsCodMat = LsCodMat
            IF !vtabusca("0011")
               LOOP
            ENDIF
            LiLote = Lote
         ENDIF
         @ NumLin,15 SAY LiLote PICT "@Z 999999"
         SEEK [E]+LsCodMat+STR(LiLote,6,0)
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF

      CASE i = 3 .AND. !MATG->PidLot
         LiLote = 0
         @ NumLin,15 SAY LiLote PICT "@Z 999999"

      CASE i = 4
         @ NumLin,67 GET LfCanDes PICT "999,999.99" VALID(LfCanDes>0.AND.LfCanDes<=LfCanLim)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         ** verificamos stock por subalmacen **
         =SEEK(LsSubAlm+LsCodMat,"MATE")
         IF LfCanDes*LfFacEqu > MATE->StkAct
            cResp = [N]
            cResp = Aviso(18,[No existe stock suficiente],[Continuamos],;
                    [<S>i   o  <N>o ?],3,[SN],0,.T.,.F.,.T.)
            IF cResp = [N]
               UltTecla = 0
               LOOP
            ENDIF
            UltTecla = Enter
         ENDIF
   ENDCASE
   IF i = 4 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Izquierda,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>4,4,i)
ENDDO
IF !INLIST(UltTecla,Escape,Arriba,Abajo)
   AsSubAlm(NumEle) = LsSubAlm
   AsCodMat(NumEle) = LsCodMat
   AiLote  (NumEle) = LiLote
   AsDesMat(NumEle) = LsDesMat
   AsUndVta(NumEle) = LsUndVta
   AfFacEqu(NumEle) = LfFacEqu
   AfCanDes(NumEle) = LfCanDes
   AiNumReg(NumEle) = LiNumReg
ENDIF
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit2
PARAMETERS NumEle, NumLin

PRIVATE i,LfCanLim,LlCrear
i        = 1
UltTecla = 0
LfCanLim = 0      && Control de maxima cantidad a despachar
LlCrear  = .T.    && Control Interno de Modificacion
*
LsSubAlm = AsSubAlm(NumEle)
LsCodMat = AsCodMat(NumEle)
LiLote   = AiLote  (NumEle)
LsDesMat = AsDesMat(NumEle)
LsUndVta = AsUndVta(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LfCanDes = AfCanDes(NumEle)
LiNumReg = AiNumReg(NumEle)
LlCrear  = IIF(!EMPTY(LsCodMat),.F.,.T.)
=SEEK(LsCodMat,"MATG")
XsUndStk = MATG->UndStk
DO WHILE !INLIST(UltTecla,Escape)
   GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1 .AND. LlCrear
         GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE MATG
         @ NumLin,2 GET LsCodMat PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba,Abajo)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
            SET FILTER TO LEFT(CodMat,3)$[002|801]
            GO TOP
            IF !vtabusca("MATG")
               SET FILTER TO
               LOOP
            ENDIF
            LsCodMat = MATG->CodMat
            SET FILTER TO
         ENDIF
         @ NumLin,2 SAY LsCodMat
         IF LsCodMat = [9]    && C¢digo Libre
            LfFacEqu = 1
            * Pedimos datos adicionales
            @ NumLin,22 GET LsDesMat PICT "@!S40"
            @ NumLin,63 GET LsUndVta PICT "@!"
            READ
            UltTecla = LASTKEY()
         ELSE
            SEEK LsCodMat
            IF !FOUND()
               GsMsgErr = [Producto no Existe]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            IF xRepite()
               GsMsgErr = [Dato ya Registrado]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            LsDesMat = MATG->DesMat
            IF EMPTY(LsUndVta)
               LsUndVta = MATG->UndStk
               LfFacEqu = 1
            ENDIF
            XsUndStk = MATG->UndStk
         ENDIF
         @ NumLin,22 SAY LsDesMat PICT "@!S40"
         @ NumLin,63 SAY LsUndVta PICT "@!"

      CASE i = 1 .AND. !LlCrear
         UltTecla = Enter

      CASE i = 2 .AND. !(LsCodMat=[9])
         SELE SALM
         @ NumLin,11 GET LsSubAlm PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(LsSubAlm) .OR. UltTecla = F8
            IF !vtabusca("0006")
               LOOP
            ENDIF
            LsSubAlm = SubAlm
         ENDIF
         @ NumLin,11 SAY LsSubAlm
         SEEK LsSubAlm
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         ** Verificamos si se puede despachar de este almacen **
         SELE MATE
         SEEK LsSubAlm+LsCodMat
         IF !FOUND()
            GsMsgErr = [Material no registrado en el Almacen]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         =SEEK(LsCodMat,"MATG")
         IF MATG->PidLot
            SELE LOTE
            @ NumLin,15 GET LiLote   PICT "999999"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,Izquierda,Escape)
               LOOP
            ENDIF
            IF UltTecla = F8 .OR. EMPTY(LiLote)
               XsCodMat = LsCodMat
               IF !vtabusca("0011")
                  LOOP
               ENDIF
               LiLote = Lote
            ENDIF
            @ NumLin,15 SAY LiLote PICT "@Z 999999"
            SEEK [E]+LsCodMat+STR(LiLote,6,0)
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
         ELSE
            LiLote = 0
            @ NumLin,15 SAY LiLote PICT "@Z 999999"
         ENDIF

      CASE i = 2 .AND. ! LsCodMat=[9]
         LiLote = 0
         @ NumLin,15 SAY LiLote PICT "@Z 999999"

      CASE i = 3 .AND. !(LsCodMat=[9])
         SELE UVTA
         @ NumLin,63 GET LsUndVta PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Izquierda,BackTab)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndVta)
            IF !vtabusca("UVTA")
               LOOP
            ENDIF
            LsUndVta = UVTA->UndVta
            LfFacEqu = UVTA->FacEqu
         ENDIF
         @ NumLin,63 SAY LsUndVta
         IF LsUndVta = XsUndStk
            LfFacEqu = 1
         ELSE
            SEEK XsUndStk+LsUndVta
            IF !FOUND()
               GsMsgErr = [Unidad no definida]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            LfFacEqu = FacEqu
         ENDIF

      CASE i = 4 .AND. LsCodMat=[9]
         @ NumLin,67 GET LfCanDes PICT "999,999.99" VALID(LfCanDes>0)
         READ
         UltTecla = LASTKEY()

      CASE i = 4 .AND. !LsCodMat=[9]
         @ NumLin,67 GET LfCanDes PICT "999,999.99" VALID(LfCanDes>0)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         ** verificamos stock por subalmacen **
         =SEEK(LsSubAlm+LsCodMat,"MATE")
         IF LfCanDes*LfFacEqu > MATE->StkAct
            cResp = [N]
            cResp = Aviso(18,[No existe stock suficiente],[Continuamos],;
                    [<S>i   o  <N>o ?],3,[SN],0,.T.,.F.,.T.)
            IF cResp = [N]
               UltTecla = 0
               LOOP
            ENDIF
            UltTecla = Enter
         ENDIF
   ENDCASE
   IF i = 4 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Izquierda,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>4,4,i)
ENDDO
IF !INLIST(UltTecla,Escape,Arriba,Abajo)
   AsSubAlm(NumEle) = LsSubAlm
   AsCodMat(NumEle) = LsCodMat
   AiLote  (NumEle) = LiLote
   AsDesMat(NumEle) = LsDesMat
   AsUndVta(NumEle) = LsUndVta
   AfFacEqu(NumEle) = LfFacEqu
   AfCanDes(NumEle) = LfCanDes
   AiNumReg(NumEle) = LiNumReg
ENDIF
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE xBborr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
IF AiNumReg(i) > 0
   GiTotDel = GiTotDel + 1
   AiRegDel(GiTotDel) = AiNumReg(i)
ENDIF
DO WHILE i <  GiTotItm
   AsSubAlm(i) = AsSubAlm(i+1)
   AsCodMat(i) = AsCodMat(i+1)
   AiLote  (i) = AiLote  (i+1)
   AsDesMat(i) = AsDesMat(i+1)
   AsUndVta(i) = AsUndVta(i+1)
   AfFacEqu(i) = AfFacEqu(i+1)
   AfCanDes(i) = AfCanDes(i+1)
   AiNumReg(i) = AiNumReg(i+1)
   i = i + 1
ENDDO
STORE [001]                    TO AsSubAlm(i)
STORE SPACE(LEN(RMOV->CodMat)) TO AsCodMat(i)
STORE 0                        TO AiLote  (i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(RMOV->UndVta)) TO AsUndVta(i)
STORE 0                        TO AfCanDes(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm - 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE XBinse

PARAMETERS ElePrv, Estado
PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsSubAlm(i) = AsSubAlm(i-1)
   AsCodMat(i) = AsCodMat(i-1)
   AiLote  (i) = AiLote  (i-1)
   AsDesMat(i) = AsDesMat(i-1)
   AsUndVta(i) = AsUndVta(i-1)
   AfFacEqu(i) = AfFacEqu(i-1)
   AfCanDes(i) = AfCanDes(i-1)
   AiNumReg(i) = AiNumReg(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE [001]                    TO AsSubAlm(i)
STORE SPACE(LEN(RMOV->CodMat)) TO AsCodMat(i)
STORE 0                        TO AiLote  (i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(RMOV->UndVta)) TO AsUndVta(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AfCanDes(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE xBmove

SELE RMOV
*
PRIVATE  i
i = 1
LsLlave = XcTipMov+XsCodMov+SUBST(XsNroDoc,4)
SEEK LsLlave
SCAN WHILE TipMov+CodMov+NroDoc=LsLlave .AND. i<=CIMAXELE
   =SEEK(RMOV->CodMat,"MATG")
   =SEEK(VMOV->NroPed+RMOV->CodMat,"RPED")
   AsSubAlm(i) = SubAlm
   AsCodMat(i) = CodMat
   AiLote  (i) = Lote
   AsDesMat(i) = DesMat
   AsUndVta(i) = UndVta
   AfFacEqu(i) = Factor
   AfCanDes(i) = CanDes
   AiNumReg(i) = RECNO()
   i = i + 1
ENDSCAN
GiTotItm = i - 1

RETURN
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab

PRIVATE GsSubAlm,XsCodMat,XfCanDes,XfFactor
*
SELE RMOV
PRIVATE i
i = 1
IF GiTotDel > 0
   DO WHILE i<=GiTotDel
      GO AiRegDel(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      **
      GsSubAlm = SubAlm
      ** punteros en posicion (mismo micro) **
      =SEEK(VMOV->NroPed+RMOV->CodMat,"RPED")
      IF !RLOCK("RPED")
         LOOP
      ENDIF
      =SEEK(RMOV->CodMat,"MATG")
      IF !RLOCK("MATG")
         LOOP
      ENDIF
      =SEEK(GsSubAlm+RMOV->CodMat,"MATE")
      IF !RLOCK("MATE")
         LOOP
      ENDIF
      ** des-actualizamos pedidos **
      DO xDes_Ped
      ** actualizamos almacenes **
      SELE RMOV
      DELETE
      DO AlmCgStk WITH .T.
      REPLACE VMOV->NroItm WITH VMOV->NroItm-1
      SELE RMOV
      UNLOCK
      SKIP
      i = i + 1
   ENDDO
ENDIF
** NOTA >> No existe modificacion del Sub-Almacen ni del Codigo del Material **
i = 1
DO WHILE i <= GiTotItm
   GsSubAlm = AsSubAlm(i)
   XsCodMat = AsCodMat(i)
   XsDesMat = AsDesMat(i)
   XiLote   = AiLote  (i)
   XfCanDes = AfCanDes(i)
   XfFactor = AfFacEqu(i)
   XsUndVta = AsUndVta(i)
   ** punteros en posicion (mismo micro) **
   =SEEK(VMOV->NroPed+XsCodMat,"RPED")
   IF !RLOCK("RPED")
      LOOP
   ENDIF
   =SEEK(XsCodMat,"MATG")
   IF !RLOCK("MATG")
      LOOP
   ENDIF
   =SEEK(GsSubAlm+XsCodMat,"MATE")
   IF !RLOCK("MATE")
      LOOP
   ENDIF
   IF AiNumReg(i) > 0
      GO AiNumReg(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      ** des-actualizamos pedido **
      DO xDes_Ped
      ** desactualizamos almacenes **
      DO AlmCgStk WITH .F.
   ELSE
      APPEND BLANK
      IF ! RLOCK()
         LOOP
      ENDIF
      REPLACE SubAlm WITH GsSubAlm
      REPLACE TipMov WITH XcTipMov
      REPLACE CodMov WITH XsCodMov
      REPLACE NroDoc WITH SUBST(XsNroDoc,4)
   ENDIF
   REPLACE RMOV->FchDoc WITH XdFchDoc
   REPLACE RMOV->CodCli WITH XsCodCli
   REPLACE RMOV->CodMat WITH XsCodMat
   REPLACE RMOV->DesMat WITH XsDesMat
   REPLACE RMOV->Lote   WITH XiLote
   REPLACE RMOV->CanDes WITH XfCanDes
   REPLACE RMOV->Factor WITH XfFactor
   REPLACE RMOV->UndVta WITH XsUndVta
   REPLACE RMOV->CodAjt WITH " "
   REPLACE RMOV->CanRec WITH XfCanDes   && OJO
   REPLACE RMOV->CanDev WITH 0          && OJO
   ** actualizamos control de saldos **
   DO xAct_Ped
   ** actualizamos almacenes **
   DO AlmDgStk
   SELE RMOV
   i = i + 1
ENDDO
** actualiza cabecera de pedidos **
SELE RPED
SEEK VMOV->NroPed
LcFlgEst = [C]
SCAN WHILE NroDoc=VMOV->NroPed
   IF FlgEst # [C]      && Atencion Parcial
      LcFlgEst = [E]
      EXIT
   ENDIF
ENDSCAN
SELE VPED
REPLACE VPED->FlgEst WITH LcFlgEst

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE xRegenera

PRIVATE j
j = 1
STORE 0 TO XfImpBto,XfImpDto,XfImpIgv,XfImpNet
FOR j = 1 TO GiTotItm
   XfImpBto = XfImpBto + AfImpLin(j)
ENDFOR
XfImpDto = ROUND(XfImpBto*XfPorDto/100,2)
XfImpVta = XfImpBto - XfImpDto + XfImpInt + XfImpAdm
XfImpIgv = ROUND(XfImpVta*XfPorIgv/100,2)
XfImpNet = XfImpVta + XfImpIgv
@ 19,14 SAY XfImpBto PICT "99999,999.99"
@ 19,41 SAY XfPorDto PICT "999.99"
@ 19,67 SAY XfImpDto PICT "99999,999.99"
@ 20,14 SAY XfImpInt PICT "99999,999.99"
@ 20,41 SAY XfImpAdm PICT "99999,999.99"
@ 20,67 SAY XfImpVta PICT "99999,999.99"
@ 21,14 SAY XfPorIgv PICT "999.99"
@ 21,41 SAY XfImpIgv PICT "99999,999.99"
@ 21,67 SAY XfImpNet PICT "99999,999.99"

RETURN
************************************************************************ FIN *
* Objeto : Verifica si el codigo fue registrado
******************************************************************************
FUNCTION xRepite
PRIVATE k
FOR k = 1 TO GiTotItm
   IF AsCodMat(k)=LsCodMat .AND. k#NumEle
      RETURN .T.
   ENDIF
ENDFOR
RETURN .F.
************************************************************************ FIN *
* Objeto : Cargar el arreglo con saldos por pedido
******************************************************************************
PROCEDURE xBCarga

PRIVATE i
i = 1
SELE RPED
SEEK XsNroPed
SCAN WHILE NroDoc=XsNroPed FOR CanPed-CanDes>0
   =SEEK(CodMat,"MATG")
   AsSubAlm(i) = IIF(!(Codmat=[9]),[001],[  ])
   AsCodMat(i) = CodMat
   AiLote  (i) = IIF(MATG->PidLot,MATG->Lote,0)
   AsDesMat(i) = DesMat
   AsUndVta(i) = UndVta
   AfFacEqu(i) = FacEqu
   AfCanDes(i) = CanPed-CanDes
   i = i + 1
ENDSCAN
GiTotItm = i - 1

RETURN
************************************************************************ FIN *
* Objeto : Impresion de la Guia
******************************************************************************
PROCEDURE xListar

RETURN
************************************************************************ FIN *
* Objeto : Impresion de la Guia
******************************************************************************
PROCEDURE xImprimir

SELE RMOV
SET RELA TO CodMat INTO MATG
SET RELA TO VMOV->NroPed+CodMat INTO RPED ADDITIVE
Largo  = 42       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2+_PRN9A+_PRN6A]
sNomRep = "vtar3100"
DO DIRPRINT  WITH "REPORTS" IN admprint
SET RELA TO
RETURN
*********************************************************************** FIN() *
* Objeto : Desactualiza Pedidos
******************************************************************************
PROCEDURE xDes_Ped

SELE RPED
REPLACE RPED->CanDes WITH RPED->CanDes - RMOV->CanDes
IF RPED->CanPed-RPED->CanDes<=0
   REPLACE RPED->FlgEst WITH [C]
ELSE
   IF RPED->CanDes > 0
      REPLACE RPED->FlgEst WITH [P]    && Atencion Parcial
   ELSE
      REPLACE RPED->FlgEst WITH []
   ENDIF
ENDIF
UNLOCK
** Des-actualizamos control de despachos **
* comenzamos por el final
SELE CRONO
SEEK RPED->NroDoc+RPED->CodMat
DO WHILE !EOF() .AND. NroDoc+CodMat = RPED->NroDoc+RPED->CodMat
   SKIP
ENDDO
SKIP -1
LfCanDes = RMOV->CanDes
DO WHILE NroDoc+CodMat = RPED->NroDoc+RPED->CodMat .AND. !BOF()
   IF !RLOCK()
      LOOP
   ENDIF
   LfReduce = MIN(CanDes,LfCanDes)
   REPLACE CanDes WITH CanDes - LfReduce
   IF CanDes = CanPed
      REPLACE FlgEst WITH [C]
   ELSE
      IF CanDes > 0
         REPLACE FlgEst WITH [P]
      ELSE
         REPLACE FlgEst WITH []
      ENDIF
   ENDIF
   LfCanDes = LfCanDes - LfReduce
   UNLOCK
   SKIP -1
ENDDO

RETURN
*********************************************************************** FIN() *
* Objeto : Actualiza Pedidos
******************************************************************************
PROCEDURE xAct_Ped

SELE RPED
REPLACE CanDes WITH CanDes + XfCanDes
IF CanPed-CanDes<=0
   REPLACE FlgEst WITH [C]
ELSE
   IF CanDes > 0
      REPLACE FlgEst WITH [P]    && Atencion Parcial
   ELSE
      REPLACE FlgEst WITH []
   ENDIF
ENDIF
UNLOCK
** actualizamos control de despachos **
SELE CRONO
SEEK RPED->NroDoc+RPED->CodMat
LfCanDes = XfCanDes
DO WHILE NroDoc+CodMat = RPED->NroDoc+RPED->CodMat .AND. !EOF()
   IF !RLOCK()
      LOOP
   ENDIF
   LfReduce = CanPed-CanDes
   IF LfReduce > 0
      LfReduce = MIN(LfReduce,LfCanDes)
   ELSE
      LfReduce = 0
   ENDIF
   REPLACE CanDes WITH CanDes+LfReduce
   IF CanDes = CanPed
      REPLACE FlgEst WITH [C]
   ELSE
      IF CanDes > 0
         REPLACE FlgEst WITH [P]
      ELSE
         REPLACE FlgEst WITH []
      ENDIF
   ENDIF
   LfCanDes = LfCanDes - LfReduce
   UNLOCK
   SKIP
ENDDO

RETURN
*********************************************************************** FIN() *
