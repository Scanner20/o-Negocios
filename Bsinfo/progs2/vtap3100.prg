* G U I A S  D E  R E M I S I O N *

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
SELE 13
USE almtuvta ORDER UVTA01 ALIAS UVTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 14
USE almtabla ORDER TABL01 ALIAS TABL
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
RESTORE FROM VTACONFG ADDITIVE
* Archivo temporal de trabajo *
Arch = PathUser+SYS(3)
**SELE rmov
**copy stru to (Arch)  
**sele 0
**use (arch) exclu alias tempo
**IF !USED()
**   CLOSE DATA
**   RETURN
**ENDIF
**INDEX ON TipMov+CodMov+NroDoc+CodMat Tag tempo01
**set order to tempo01
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
PRIVATE XmGloDoc,XcFlgEst,XiFmaPgo,XsCodRef,XsNroRef,XsTpoGui,XiMotivo
PRIVATE XsNroO_C,XdFchO_C,XnCodMon
PRIVATE XsCodCli,XsNomCli,XsDirCli,XsRucCli,XsDirEnt
STORE [] TO XsPtoVta,XsNroDoc,XdFchDoc,XsCodCli,XsNroPed
STORE [] TO XmGloDoc,XcFlgEst,XiFmaPgo,XsCodRef,XsNroRef,XsTpoGui
STORE [] TO XsNroO_C,XdFchO_C
STORE [] TO XsCodCli,XsNomCli,XsDirCli,XsRucCli,XsDirEnt
STORE 2  TO XnCodMon
XiMotivo = 1
** datos del chofer **
PRIVATE XsRUCTra,XsNomTra,XsNomCho,XsPlaTra,XsNroBre
STORE [] TO XsRUCTra,XsNomTra,XsNomCho,XsPlaTra,XsNroBre
** Variables del Browse **
PRIVATE AsCodMat,AsUndVta,AfFacEqu,AfCanDes,AiNumReg,GiTotItm,AsSubAlm,AfPunit
PRIVATE AnD1,AnD2,AnD3
PRIVATE AiRegDel,GiTotDel

***** MAXIMO ELEMENTOS EN LA GUIA *****
CIMAXELE = 16     && OJO : no sobrepasar este valor
DIMENSION AsSubAlm(CIMAXELE)
DIMENSION AsCodMat(CIMAXELE)
DIMENSION AsDesMat(CIMAXELE)
DIMENSION AsUndVta(CIMAXELE)
DIMENSION AfFacEqu(CIMAXELE)
DIMENSION AfCanDes(CIMAXELE)
DIMENSION AnD1    (CIMAXELE)
DIMENSION AnD2    (CIMAXELE)
DIMENSION AnD3    (CIMAXELE)
DIMENSION AfPunit (CIMAXELE)
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
GOTO BOTTOM
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'Ximprime',;
              [],[],'CMAR',[]
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
@  8,0  SAY "³        RUC :                                      Tipo Guia :                ³"
@  9,0  SAY "³ Oficina en :                                      No. Fact. :                ³"
@ 10,0  SAY "³Entregar en :                                                                 ³"
@ 11,0  SAY "ÃÄÄGlosa :ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
            *          1         2         3         4         5         6         7
            *01234567890123456789012345678901234567890123456789012345678901234567890123456789
            *  ########## ### ###################### ##.## ##.## 9,999.999
@ 14,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 15,0  SAY "³   C¢digo   Alm        Descripci¢n     %Dct1 %Dct2  Pre.Uni.  Und    Cantidad ³" COLOR SCHEME 7
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
               UltTecla = Enter
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
cCrear = .T.
IF &RegVal
   IF ! Clave(CFGPasswD)
      UltTecla = Escape
      RETURN
   ENDIF
   IF FlgEst = [F]
      GsMsgErr = [Guia de Remision YA Facturada]
      DO lib_merr WITH 99
      UltTecla = Escape
      RETURN
   ENDIF
   IF ! RLOCK()
      UltTecla = Escape
      RETURN
   ENDIF
   DO xMover
   cCrear = .F.
   cTecla = [Escape,F10,CtrlW]
ELSE
   DO xInvar
   cTecla = [Escape]
ENDIF
*
@  5,63 GET XdFchDoc
@  6,17 GET XsNroPed
@ 12,1  EDIT XmGloDoc SIZE 2,78 COLOR SCHEME 7 DISABLE
CLEAR GETS
UltTecla = 0
PRIVATE i
i = 1
DO WHILE ! INLIST(UltTecla,&cTecla.)
   i = IIF(!cCrear.AND.i<6,6,i)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         ** Seleccion de Tipos De Guias Remision **
         SAVE SCREEN TO LsPanToma
         @ 1,49 CLEAR TO 9,76
         @ 2,50,8,75 BOX "±±±±±±±±"
         @ 1,49 TO 9,76 DOUBLE
         @  2,50 PROMPT "  1.- V E N T A           "
         @  3,50 PROMPT "  2.- TRANSFORMACION      "
         @  4,50 PROMPT "  3.- TRASLADO INTERNO    "
         @  5,50 PROMPT "  4.- CONSIGNACION        "
         @  6,50 PROMPT "  5.- TRASLADO TEMPORAL   "
         @  7,50 PROMPT "  6.- OTROS               "
         @  8,50 PROMPT "  7.- VENTAS SIN PEDIDO   "
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
            XsTpoGui = [VTAS]
            XcTipMov = [S]
            XiMotivo = 1
         CASE LiOpcion = 2
            XsTpoGui = [TRAN]
            XcTipMov = [S]
            XiMotivo = 2
         CASE LiOpcion = 3
            XsTpoGui = [INTE]
            XcTipMov = [T]
            XiMotivo = 3
         CASE LiOpcion = 4
            XsTpoGui = [CONS]
            XcTipMov = [T]
            XiMotivo = 4
         CASE LiOpcion = 5
            XsTpoGui = [TEMP]
            XcTipMov = [T]
            XiMotivo = 5
         CASE LiOpcion = 6
            XsTpoGui = [OTRO]
            XcTipMov = [S]
            XiMotivo = 6
         CASE LiOpcion = 7
            XsTpoGui = [VENT]
            XcTipMov = [S]
            XiMotivo = 1
            
         ENDCASE
         @ 8,63 SAY XiMotivo
         @ 8,65 SAY XsTpoGui PICT "@!"

      CASE i = 4 .AND. XsTpoGui # [VTAS]
         XsNroPed = SPACE(LEN(XsNroPed))
         XsCodRef = [FREE]    && << OJO <<
         @ 6,17 SAY XsNroPed PICT "@!"

      CASE i = 4 .AND. XsTpoGui = [VTAS]
         GsMsgErr = "[Esc] Cancelar  [Enter] Aceptar  [F8] Consulta  [F6] Guia Libre  [] Anterior"
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
            XsCodRef = [PEDI]    && << OJO <<
            XsNroRef = XsNroPed
            XdFchO_C = FchO_C
            XsNroO_C = NroO_C
            XmGloDoc = GloDoc
            XnCodmon = codmon
            IF !(XsCodCli=[99999])
               =SEEK(GsClfAux+XsCodCli,"CLIE")
               XsNomCli = CLIE->NomAux
               XsDirCli = CLIE->DirAux
               XsDirEnt = CLIE->DirEnt
               XsRucCli = CLIE->RucAux
            ENDIF
         ELSE
            XsCodCli = SPACE(LEN(VMOV->CodCli))
            XsNomCli = SPACE(LEN(VMOV->NomCli))
            XsDirCli = SPACE(LEN(VMOV->DirCli))
            XsDirEnt = SPACE(LEN(VMOV->DirCli))
            XsRucCli = SPACE(LEN(VMOV->RucCli))
            XiFmaPgo = 1
            XsCodRef = [FREE]    && << OJO <<
            XsNroRef = SPACE(LEN(VMOV->NroRef))
            XdFchO_C = {,,}
            XsNroO_C = SPACE(LEN(VMOV->NroO_C))
            XmGloDoc = []
         ENDIF
         @ 7,17 SAY XsCodCli+' '+TRANS(XsNomCli,'@S50')
         @ 8,17 SAY XsRucCli
         @ 9,17 SAY XsDirCli  PICT "@S32"
         @ 10,17 SAY XsDirEnt
         @ 6,63 SAY vta_pgo(XiFmaPgo)

      CASE i = 5 .AND. EMPTY(XsCodCli)
         DO xTomar1

      CASE i = 6
         @ 10,17 GET XsDirEnt PICT "@!"
         READ
         @ 10,17 SAY XsDirEnt PICT "@!"
         UltTecla = LASTKEY()

      CASE i = 7
         GsMsgKey = "[Shift+Tab] Anterior   [Tab] Siguiente   [Esc] Cancelar"
         DO lib_mtec WITH 99
         @ 12,1  EDIT XmGloDoc SIZE 2,78 COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
         @ 12,1  EDIT XmGloDoc SIZE 2,78 DISABLE
         IF INLIST(UltTecla,BackTab,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF XcFlgEst=[A]
            UltTecla = Enter
            EXIT
         ENDIF
      CASE i = 8
         DO xBrowse

      CASE i = 9
         DO xTomar2

      CASE i = 10
         cResp = [N]
         cResp = aviso(12,[Datos Correctos (S-N)?],[],[],3,[SN],0,.T.,.F.,.T.)
         IF cResp = [N]
            i = i - 1
            LOOP
         ENDIF
         UltTecla = Enter
   ENDCASE
   IF i = 10 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>10,10,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
   ** IMPRESION DE LA GUIA **
   SELE RMOV
   LsLlave  = XcTipMov+XsCodMov+SUBSTR(XsNroDoc,4)
   SEEK LsLlave
   * test de impresion *
   xFOR = []
   xWHILE = [TipMov+CodMov+NroDoc=LsLlave]
   DO xImprimE
   UltTecla = Escape
ENDIF
SELE VMOV
UNLOCK ALL
DO LIB_MTEC WITH 3

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar1

@  7,17 GET XsCodCli
@  7,23 GET XsNomCli PICT '@S50'
@  8,17 GET XsRucCli
@  8,63 SAY XiMotivo
@  8,65 SAY XsTpoGui PICT "@!"
@  9,17 GET XsDirCli PICT "@S32"
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
         IF XsCodCli=[99999]   && Codigo Libre
            @  7,23 GET XsNomCli PICT '@!S50'
            @  8,17 GET XsRucCli PICT "@!"
            @  9,17 GET XsDirCli PICT "@S32"
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
         @  9,17 SAY XsDirCli PICT "@S32"
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
@ 12,18 SAY "º     Direcci¢n :                                          º" COLOR SCHEME 7
@ 13,18 SAY "º   Vehiculo No.:                                          º" COLOR SCHEME 7
@ 14,18 SAY "º    Brevete No.:                                          º" COLOR SCHEME 7
@ 15,18 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼" COLOR SCHEME 7

UltTecla = 0
PRIVATE i
i = 1
GsMsgKey = " [] [] Seleccionar  [Enter] Aceptar [Esc] Anterior [F10] Aceptar Todo [F9] En Blanco"
DO LIB_MTEC WITH 99
DO WHILE .T.
   @ 10,36 GET XsNomTra PICT "XXXXXXXXXXXXXXXXXXXX"
   @ 11,36 GET XsRUCTra
   @ 12,36 GET XsNomCho PICT "XXXXXXXXXXXXXXXXXX"
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
XsTpoGui = TpoGui
XsMotivo = Motivo
XsNroRef = NroRef
XsNroO_C = NroO_C
XdFchO_C = FchO_C
XmGloDoc = GLODOC
xncodmon = codmon
* * * *
XsPtoVta = LEFT(XsNroDoc,3)
XsCodMov = [G]+RIGHT(XsPtoVta,2)
**
XsRUCTra = RUCTra
XsNomTra = NomTra
XsNomCho = NomCho
XsPlaTra = PlaTra
XsNroBre = NroBre
** VERIFICAMOS TIPO GUIA **
   DO CASE
   CASE XsTpoGui = [VTAS]
      XcTipMov = [S]
      XiMotivo = 1
   CASE XsTpoGui = [TRAN]
      XcTipMov = [S]
      XiMotivo = 2
   CASE XsTpoGui = [INTE]
      XcTipMov = [T]
      XiMotivo = 3
   CASE XsTpoGui = [CONS]
      XcTipMov = [T]
      XiMotivo = 4
   CASE XsTpoGui = [TEMP]
      XcTipMov = [T]
      XiMotivo = 5
   CASE XsTpoGui = [OTRO]
      XcTipMov = [S]
      XiMotivo = 6
   ENDCASE
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
XcFlgEst = [E]    && Emitido, Cerrado, Anulado,Facturado
XiFmaPgo = 0
XsCodRef = [PEDI]
XsTpoGui = [VTAS]
XiMotivo = 1
XnCodMon = 2
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
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat
STORE SPACE(LEN(RPED->UndVta)) TO AsUndVta
STORE 1                        TO AfFacEqu
STORE 0                        TO AfCanDes
STORE 0.00                     TO AnD1,AnD2,AnD3
STORE 0                        TO AfPunit
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
@  8,63 SAY Motivo
@  8,65 SAY TpoGui PICT "@!"
@  9,17 SAY DirCli PICT "@S32"
@  9,65 SAY LEFT(Codfac,1)+NroFac PICT "@!"
@ 10,17 SAY DirEnt
@  6,63 SAY vta_pgo(FmaPgo)
@ 12,1  EDIT GloDoc SIZE 2,78 DISABLE
* * * *
XsCodMov = [G]+SUBSTR(NroDoc,2,2)


 IF VMOV.TPOGUI$[VTAS,TRAN,OTRO,VENT]
    KTIPMOV = "S"
 ELSE
    KTIPMOV = "T"
 ENDIF

LsLlave  = KTipMov+XsCodMov+SUBSTR(NroDoc,4)
SELE RMOV
SEEK LsLlave
NumLin = 17
@ 17,2 CLEAR TO 20,76
SCAN WHILE TipMov+CodMov+NroDoc=LsLlave .AND. NumLin <= 20

*          1         2         3         4         5         6         7         8
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
*  12345678 123 999999 1234567890123456789012345678901234567890 123 999,999.999
*
   =SEEK(RMOV->CodMat,'MATG')
   =SEEK(VMOV->NroPed+RMOV->CodMat,'RPED')
   ****9,999.999*****
   @ NumLin,2  SAY CodMat
   @ NumLin,13 SAY SubAlm PICT "999"
   @ NumLin,17 SAY DesMat PICT "@S22"
   @ NumLin,40 SAY D1 pict "99.99"
   @ NumLin,46 SAY D2 pict "99.99"
   @ NumLin,52 SAY Preuni PICT "9,999.999"
   @ NumLin,63 SAY UndVta
   @ NumLin,67 SAY CanGui PICT "9999,999.99"
   NumLin = NumLin + 1
ENDSCAN
IF VMOV->FlgESt = "A"
   @ 17,11 SAY "     #    #     # #     # #          #    ######  #######   "
   @ 18,11 SAY "    # #   ##    # #     # #         # #   #     # #     #   "
   @ 19,11 SAY "  ####### #   # # #     # #       ####### #     # #     #   "
   @ 20,11 SAY "  #     # #     #  #####  ####### #     # ######  #######   "
ENDIF
* *
SELE VMOV

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

SELE VMOV
IF cCrear
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
   DO CASE
   CASE INLIST(XsTpoGui,[VTAS],[VENT])
        REPLACE FlgEst WITH XcFlgEst
   CASE XsTpoGui $ [INTE|CONS|TEMP|TRAN|OTRO]
        REPLACE FlgEst WITH 'T'
   ENDCASE
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
REPLACE GloDoc WITH XmGloDoc
REPLACE FmaPgo WITH XiFmaPgo
REPLACE CodRef WITH XsCodRef
REPLACE TpoGui WITH XsTpoGui
REPLACE Motivo WITH XiMotivo
REPLACE NroRef WITH XsNroRef
*** TODOS NO SE FACTURAN
IF INLIST(XsTpoGui,[VTAS],[VENT])
   REPLACE FlgEst WITH XcFlgEst
ENDIF
*
REPLACE NroO_C WITH XsNroO_C
REPLACE FchO_C WITH XdFchO_C
*
REPLACE RUCTra WITH XsRUCTra
REPLACE NomTra WITH XsNomTra
REPLACE NomCho WITH XsNomCho
REPLACE PlaTra WITH XsPlaTra
REPLACE NroBre WITH XsNroBre
REPLACE CODMON WITH XNCODMON
** Grabamos Browse **
DO CASE
CASE XsTpoGui $ [VTAS|TRAN|OTRO|VENT]
   XcTipMov = "S"
   ** Grabamos Browse **
   DO CASE
   CASE XsCodRef = [PEDI]
      DO xBgrab1
   CASE XsCodRef = [FREE]
      DO xBgrab2
   ENDCASE
CASE XsTpoGui $ [INTE|CONS|TEMP] && ES TRANSFERENCIA
   XcTipMov = "T"
   DO xBgrab4
ENDCASE
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

DO CASE
CASE VMOV->TpoGui $ [VTAS|TRAN|OTRO|VENT]
   XcTipMov = "S"
   DO CASE
   CASE VMOV->CodRef = [PEDI]
      DO xBorra1
   CASE VMOV->CodRef = [FREE]
      DO xBorra2
   ENDCASE
CASE VMOV->TpoGui $ [INTE|CONS|TEMP]  && NO SE HACEN DE PEDIDO
   XcTipMov = "T"
   DO xBorra4
ENDCASE
**
SELE VMOV
IF FlgEst=[A]
   DELETE
ELSE
   REPLACE FlgEst WITH [A]
ENDIF
UNLOCK ALL
SKIP

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorra1

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
   DO xDes_Ped  && Des-actualizamos pedidos **
   **DO xBor_Ser  && OJO : Borramos Venta de SERI **
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

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorra2

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
   =SEEK(RMOV->CodMat,"MATG")
   IF !RLOCK("MATG")
      LOOP
   ENDIF
   =SEEK(GsSubAlm+RMOV->CodMat,"MATE")
   IF !RLOCK("MATE")
      LOOP
   ENDIF
   ** OJO : Borramos Venta de SERI **
   **DO xBor_ser
   ** actualizamos almacenes **
   SELE RMOV
   DELETE
   DO AlmCgStk WITH .T.
   SKIP
ENDDO

RETURN
************************************************************************ FIN()
* Borrar Informacion DE GUIAS DE TRASLADO TEMPORAL
******************************************************************************
PROCEDURE xBorra4

PRIVATE GsSubAlm,XcTransf,XcNroD
XsDestin = '002'
XcTransf = 'R'
XcNroD   = NroDoc
XsCodMov = [G]+SUBSTR(XcNroD,2,2)
LsLlave  = XcTipMov+XsCodMov+SUBSTR(XcNroD,4)
SELE RMOV
SEEK LsLlave
ok = .T.
DO WHILE TipMov+CodMov+NroDoc=LsLlave .AND. ! EOF()
   IF RLOCK()
      GsSubAlm = SubAlm
      ** Posicionamos punteros
      =SEEK(RMOV->CodMat,"MATG")
      IF !RLOCK("MATG")
         LOOP
      ENDIF
      =SEEK(GsSubAlm+RMOV->CodMat,"MATE")
      IF RLOCK("MATE")
         REPLACE MATE->StkAct WITH MATE->StkAct + RMOV->CanDes
         UNLOCK IN "MATE"
         ** OJO : Borramos Venta de SERI **
         **DO xBor_Ser
         ** actualizamos almacenes **
         SELE RMOV
         DELETE
         DO AlmaCpre       && DO AlmCgStk WITH .T.
         SELE RMOV
         UNLOCK
      ENDIF
   ENDIF
   SELE RMOV
   SKIP
ENDDO
**** Buscando el equivalente en el receptor **
SELE RMOV
XcTipMov=XcTransf
Llav1 = XcTipMov+XsCodMov+SUBSTR(XcNroD,4)
SEEK Llav1
DO WHILE TipMov+CodMov+NroDoc=Llav1 .and.! EOF()
   IF REC_LOCK(5)
      GsSubAlm = SubAlm
      SELE MATE
      SEEK GsSubAlm+RMOV->CodMat
      IF REC_LOCK(5)
         REPLACE MATE->StkAct WITH MATE->StkAct - RMOV->CanDes
         UNLOCK
         SELE RMOV
         DELETE
         DO AlmaCPre
         SELE RMOV
         UNLOCK
      ENDIF
   ENDIF
   SELECT RMOV
   SKIP
ENDDO
SELE RMOV
RETURN
************************************************************************ FIN()
* Browse de Datos
****************************************************************************
PROCEDURE xBrowse

** OJO > El browse se configura de acuerdo a las necesidades
EscLin   = "xBline"
BrrLin   = "xBborr"
InsLin   = "xBinse"
IF XsCodRef = [PEDI]    && G/R por Pedido
   EdiLin   = "xBedit1"
   IF cCrear
      DO xBCarga     && Carga arreglo con saldos del Pedido
   ENDIF
   IF GiTotItm = 0
      GsMsgErr = "No existe Items para la emisi¢n de la GUIA"
      DO LIB_MERR WITH 99
      ULtTecla = Escape
      RETURN
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
@ NumLin,13 SAY AsSubAlm(NumEle) PICT "999"
@ NumLin,17 SAY AsDesMat(NumEle) PICT "@S22"
@ NumLin,40 SAY AnD1    (NumEle) PICT "99.99"
@ NumLin,46 SAY AnD2    (NumEle) PICT "99.99"
@ NumLin,52 SAY AfPunit (NumEle) PICT "9,999.999"
@ NumLin,63 SAY AsUndVta(NumEle)
@ NumLin,67 SAY AfCanDes(NumEle) PICT "9999,999.99"

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
LsDesMat = AsDesMat(NumEle)
LsUndVta = AsUndVta(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LfCanDes = AfCanDes(NumEle)
LnD1     = AnD1    (NumELe)
LnD2     = AnD2    (NumELe)
LnD3     = AnD3    (NumELe)
LfPunit  = AfPunit (NumEle)
LiNumReg = AiNumReg(NumEle)
LlCrear  = IIF(!EMPTY(LsCodMat),.F.,.T.)
DO WHILE !INLIST(UltTecla,Escape)
   GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1 .AND. LlCrear
         GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE RPED
         @ NumLin,2 GET LsCodMat
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
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
         ** control de maximo despacho **
         LfCanLim = RPED->CanPed-RPED->CanDes
         LfCanDes = LfCanLim
         ** pintamos datos **
         @ NumLin,17 SAY LsDesMat PICT "@S22"
         @ NumLin,63 SAY LsUndVta

      CASE i = 1 .AND. !LlCrear
         SELECT RPED
         SEEK XsNroPed+LsCodMat
         LfCanLim = 0
         UltTecla = Enter
         DO WHILE NroDoc+CodMat = XsNroPed+LsCodMat  .AND. ! EOF()
            DO CASE
               CASE CanPed-CanDes<=0
               OTHER
                  LfDirDes = (CanPed-CanDes)
                  IF UndVta <> LsUndVta
                     LfDirDes = (CanPed-CanDes)*FacEqu/LfFacEqu
                  ENDIF
                  LfCanLim = LfCanLim + LfDirDes
            ENDCASE
            SKIP
         ENDDO
         IF LlCrear
            LfCanDes = LfCanLim
         ENDIF

      CASE i = 2 .AND. ! (LsCodMat=[9])
         SELE SALM
         @ NumLin,13 GET LsSubAlm PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(LsSubAlm) .OR. UltTecla = F8
            IF !vtabusca("0006")
               LOOP
            ENDIF
            LsSubAlm = SubAlm
         ENDIF
         @ NumLin,13 SAY LsSubAlm
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

      CASE i = 3
         @ NumLin,40 GET LnD1 PICT "99.99" RANGE 0,
         @ NumLin,46 GET LnD2 PICT "99.99" RANGE 0,
     *   @ NumLin,49 GET LnD3 PICT "99" RANGE 0,
         @ NumLin,52 GET LfPunit PICT "9,999.999"
         @ NumLin,67 GET LfCanDes PICT "9999,999.99" VALID(LfCanDes>0)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
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
         IF LfCanDes  > LfCanLim
            cResp = [N]
            cResp = Aviso(18,[Excede a la Cantidad Pedida],[Continuamos],;
                    [<S>i   o  <N>o ?],3,[SN],0,.T.,.F.,.T.)
            IF cResp = [N]
               UltTecla = 0
               LOOP
            ENDIF
            UltTecla = Enter
         ENDIF
      CASE i = 4
         ** Browse de datos de # de series **
       **DO xBrowseE
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
   AsDesMat(NumEle) = LsDesMat
   AsUndVta(NumEle) = LsUndVta
   AfFacEqu(NumEle) = LfFacEqu
   AfCanDes(NumEle) = LfCanDes
   AnD1    (NumEle) = LnD1
   AnD2    (NumEle) = LnD2
   AnD3    (NumEle) = LnD3
   AfPunit (NumEle) = LfPunit
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
LsDesMat = AsDesMat(NumEle)
LsUndVta = AsUndVta(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LfCanDes = AfCanDes(NumEle)
LnD1     = AnD1    (NumELe)
LnD2     = AnD2    (NumELe)
LnD3     = AnD3    (NumELe)
LfPunit  = AfPunit (NumEle)
LiNumReg = AiNumReg(NumEle)

*LlCrear  = IIF(!EMPTY(LsCodMat),.F.,.T.)
* No permite modificar
* IF !LlCrear
*    UltTecla = Arriba
*    RETURN
* ENDIF

=SEEK(LsCodMat,"MATG")
XsUndStk = MATG->UndStk
DO WHILE !INLIST(UltTecla,Escape)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   i = IIF(LiNumReg>0.AND.i<6,6,i)
   DO CASE
      CASE i = 1
         GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE MATG
         @ NumLin,2 GET LsCodMat
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
            IF !vtabusca("MATG")
               LOOP
            ENDIF
            LsCodMat = MATG->CodMat
         ENDIF
         @ NumLin,2 SAY LsCodMat
         SEEK LsCodMat
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF
       * IF !(LsCodMat=[9])
            IF xRepite()
               GsMsgErr = [Dato ya Registrado]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            LsDesMat = MATG->DesMat
            LsUndVta = MATG->UndStk
            LfPunit  = MATG->PREVE1
            LfFacEqu = 1
            XsUndStk = MATG->UndStk
            @ NumLin,17 SAY LsDesMat PICT "@S22"
            @ NumLin,52 SAY LfPunit  PICT "9,999.999"
            @ NumLin,63 SAY LsUndVta
       * ELSE
       *    LsSubAlm = SPACE(LEN(RMOV->SubAlm))
       *    @ NumLin,13 GET LsSubAlm PICT "@!"
       * ENDIF

      CASE i = 2 .AND. LsCodMat = [9]   && Codigo Libre
         @ NumLin,17 GET LsDesMat PICT "@S22"
         READ
         UltTecla = LASTKEY()
         @ NumLin,17 SAY LsDesMat PICT "@S22"

      CASE i = 3 .AND. LsCodMat = [9]   && Codigo Libre
         SELE TABL
         XsTabla = [UD]
         @ NumLin,63 GET LsUndVta
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba,BackTab)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndVta)
            IF !vtabusca("TUND")
               LOOP
            ENDIF
            LsUndVta = LEFT(TABL->Codigo,3)
         ENDIF
         @ NumLin,63 SAY LsUndVta
         LfFacEqu = 1
         SEEK XsTabla+LsUndVta
         IF !FOUND()
            GsMsgErr = [Unidad no definida]
            DO lib_merr WITH 99
            LOOP
         ENDIF

*     CASE i = 4 .AND. !(LsCodMat=[9]) .AND. XcTipMov # [T]
      CASE i = 4 .AND.  XcTipMov # [T]
         SELE SALM
         @ NumLin,13 GET LsSubAlm PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(LsSubAlm) .OR. UltTecla = F8
            IF !vtabusca("0006")
               LOOP
            ENDIF
            LsSubAlm = SubAlm
         ENDIF
         @ NumLin,13 SAY LsSubAlm
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

   *  CASE i = 5 .AND. !(LsCodMat=[9]) .AND. XcTipMov # [T]
      CASE i = 5 .AND.  XcTipMov # [T]
         SELE UVTA
         @ NumLin,40 GET LnD1     PICT "99.99" RANGE 0,
         @ NumLin,46 GET LnD2     PICT "99.99" RANGE 0,
     *    @ NumLin,49 GET LnD3     PICT "99" RANGE 0,
         @ NumLin,52 GET LfPunit  PICT "9,999.999"
         @ NumLin,63 GET LsUndVta PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba,BackTab)
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

      CASE i = 6 .AND. LsCodMat=[9]
         @ NumLin,67 GET LfCanDes PICT "9999,999.99" VALID(LfCanDes>0)
         READ
         UltTecla = LASTKEY()

      CASE i = 6 .AND. !LsCodMat=[9]
         @ NumLin,67 GET LfCanDes PICT "9999,999.99" VALID(LfCanDes>0)
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
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
      CASE i = 7
         ** Browse de datos de # de series **
       **DO xBrowseE
   ENDCASE
   IF i = 7 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Izquierda,BackTab),i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>7,7,i)
ENDDO
IF !INLIST(UltTecla,Escape,Arriba,Abajo)
   AsSubAlm(NumEle) = LsSubAlm
   AsCodMat(NumEle) = LsCodMat
   AsDesMat(NumEle) = LsDesMat
   AsUndVta(NumEle) = LsUndVta
   AfFacEqu(NumEle) = LfFacEqu
   AfCanDes(NumEle) = LfCanDes
   AnD1    (NumEle) = LnD1
   AnD2    (NumEle) = LnD2
   AnD3    (NumEle) = LnD3
   AfPunit (NumEle) = LfPunit
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
** Borramos las series que fueron registradas en el temporal **
cCodMat = AsCodMat(i)
**SELE TEMPO
**SEEK XcTipMov+XsCodMov+SUBS(XsNroDoc,4)+cCodMat
**DO WHILE TipMov+CodMov+NroDoc+CodMat=XcTipMov+XsCodMov+SUBS(XsNroDoc,4)+cCodMat .AND. !EOF()
**   DELETE
**   SKIP
**ENDDO
* * * *
DO WHILE i <  GiTotItm
   AsSubAlm(i) = AsSubAlm(i+1)
   AsCodMat(i) = AsCodMat(i+1)
   AsDesMat(i) = AsDesMat(i+1)
   AsUndVta(i) = AsUndVta(i+1)
   AfFacEqu(i) = AfFacEqu(i+1)
   AfCanDes(i) = AfCanDes(i+1)
   AnD1    (i) = AnD1    (i+1)
   AnD2    (i) = AnD2    (i+1)
   AnD3    (i) = AnD3    (i+1)
   AfPunit (i) = AfPunit (i+1)
   AiNumReg(i) = AiNumReg(i+1)
   i = i + 1
ENDDO
STORE [001]                    TO AsSubAlm(i)
STORE SPACE(LEN(RMOV->CodMat)) TO AsCodMat(i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(RMOV->UndVta)) TO AsUndVta(i)
STORE 0                        TO AfCanDes(i)
STORE 0                        TO AnD1(i),AnD2(i),AnD3(i)
STORE 0                        TO AfPunit(i)
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
   AsDesMat(i) = AsDesMat(i-1)
   AsUndVta(i) = AsUndVta(i-1)
   AfFacEqu(i) = AfFacEqu(i-1)
   AfCanDes(i) = AfCanDes(i-1)
   AnD1    (i) = AnD1    (i-1)
   AnD2    (i) = AnD2    (i-1)
   AnD3    (i) = AnD3    (i-1)
   AfPunit (i) = AfPunit (i-1)
   AiNumReg(i) = AiNumReg(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE [001]                    TO AsSubAlm(i)
STORE SPACE(LEN(RMOV->CodMat)) TO AsCodMat(i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(RMOV->UndVta)) TO AsUndVta(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AfCanDes(i)
STORE 0                        TO AnD1(i),AnD2(i),AnD3(i)
STORE 0                        TO AfPunit(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE xBmove

**SELE TEMPO   && no funciona
**DELE ALL     && borra todo
*
SELE RMOV
*
PRIVATE  i
i = 1
LsLlave = XcTipMov+XsCodMov+SUBST(XsNroDoc,4)
SEEK LsLlave
SCAN WHILE TipMov+CodMov+NroDoc=LsLlave .AND. i<=CIMAXELE
   AsSubAlm(i) = SubAlm
   AsCodMat(i) = CodMat
   AsDesMat(i) = DesMat
   AsUndVta(i) = UndVta
   AfFacEqu(i) = Factor
   AfCanDes(i) = CanGui
   AnD1    (i) = D1
   AnD2    (i) = D2
   AnD3    (i) = D3
   AfPunit (i) = PreUni
   AiNumReg(i) = RECNO()
   ** Trasladamos # de series al temporal **
  ** SELE SERI
  ** cLlave = XcTipMov+XsCodMov+SUBSTR(XsNroDoc,4)+AsCodMat(i)
  ** SEEK cLlave
  ** SCAN WHILE TipMov+CodMov+NroDoc+CodMat=cLlave
  **    SELE TEMPO
  **    APPEND BLANK
  **    REPLACE TEMPO->SubAlm WITH SERI->SubAlm
  **    REPLACE TEMPO->TipMov WITH SERI->TipMov
  **    REPLACE TEMPO->CodMov WITH SERI->CodMov
  **    REPLACE TEMPO->NroDoc WITH SERI->NroDoc
  **    REPLACE TEMPO->FchDoc WITH SERI->FchDoc
  **    REPLACE TEMPO->CodMat WITH SERI->CodMat
  **    REPLACE TEMPO->CodEle WITH SERI->CodEle
  **    REPLACE TEMPO->CodAux WITH SERI->CodAux
  **    REPLACE TEMPO->NomAux WITH SERI->NomAux
  **    SELE SERI
  ** ENDSCAN
   * * * * *
  SELE RMOV
  i = i + 1
ENDSCAN
GiTotItm = i - 1

RETURN
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab1

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
      ** OJO : Borramos # de serie del SERI **
      **DO xBor_Ser
      ** actualizamos almacenes **
      SELE RMOV
      DELETE
      DO AlmCgStk WITH .T.
     *REPLACE VMOV->NroItm WITH VMOV->NroItm-1
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
   XfCanDes = AfCanDes(i)
   LnD1     = AnD1    (i)
   LnD2     = AnD2    (i)
   LnD3     = AnD3    (i)
   LfPunit  = AfPunit (i)
   XfFactor = AfFacEqu(i)
   XsUndVta = AsUndVta(i)
   ** punteros en posicion (mismo micro) **
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
      IF CANDES = CANGUI
          XfCanOk = XfCanDes
      ELSE
          XfCanOk = CanDes
      ENDIF
      DO xDes_Ped
      ** desactualizamos almacenes **
      DO AlmCgStk WITH .F.
   ELSE
      XfCanOk = XfCanDes
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
   REPLACE RMOV->CanGui WITH XfCanDes
   REPLACE RMOV->Factor WITH XfFactor
   REPLACE RMOV->UndVta WITH XsUndVta
   REPLACE RMOV->CodAjt WITH " "
   REPLACE RMOV->CanDes WITH XfCanOk    && OJO
   REPLACE RMOV->CanDev WITH 0          && OJO
   REPLACE RMOV->D1     WITH LnD1
   REPLACE RMOV->D2     WITH LnD2
   REPLACE RMOV->D3     WITH LnD3
   REPLACE RMOV->PreUni WITH LfPunit
   ** actualizamos control de saldos **
   DO xAct_Ped
   ** actualizamos almacenes **
   DO AlmDgStk
   SELE RMOV
   i = i + 1
ENDDO
** Ahora si , grabamos los # de series del TEMPO al SERI **
** VERIFICAMOS QUE NO HAYA NADA NO PASA ARRIBA x GITOTDEL**
**DO xAct_Ser
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
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab2

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
      =SEEK(RMOV->CodMat,"MATG")
      IF !RLOCK("MATG")
         LOOP
      ENDIF
      =SEEK(GsSubAlm+RMOV->CodMat,"MATE")
      IF !RLOCK("MATE")
         LOOP
      ENDIF
      ** OJO : Borramos # de serie del SERI **
      **DO xBor_Ser
      ** actualizamos almacenes **
      SELE RMOV
      DELETE
      DO AlmCgStk WITH .T.
     *REPLACE VMOV->NroItm WITH VMOV->NroItm-1
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
   XfCanDes = AfCanDes(i)
   LnD1     = AnD1    (i)
   LnD2     = AnD2    (i)
   LnD3     = AnD3    (i)
   LfPunit  = AfPunit (i)
   XfFactor = AfFacEqu(i)
   XsUndVta = AsUndVta(i)
   ** punteros en posicion (mismo micro) **
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
   REPLACE RMOV->CanGui WITH XfCanDes
   REPLACE RMOV->Factor WITH XfFactor
   REPLACE RMOV->UndVta WITH XsUndVta
   REPLACE RMOV->CodAjt WITH " "
   REPLACE RMOV->CanDes WITH XfCanDes   && OJO
   REPLACE RMOV->CanDev WITH 0          && OJO
   REPLACE RMOV->D1     WITH LnD1
   REPLACE RMOV->D2     WITH LnD2
   REPLACE RMOV->D3     WITH LnD3
   REPLACE RMOV->PreUni WITH LfPunit
   ** actualizamos almacenes **
   DO AlmDgStk
   SELE RMOV
   i = i + 1
ENDDO
** Ahora si , grabamos los # de series del TEMPO al SERI **
** VERIFICAMOS QUE NO HAYA NADA NO PASA ARRIBA x GITOTDEL**
**DO xAct_Ser
SELE RMOV
RETURN
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab4

PRIVATE GsSubAlm,XsCodMat,XfCanDes,XfFactor,XsDestin,XcTransf
*
XsDestin = '002'  && ALMACEN DESTINO
XcTransf = 'R'    && Recepci¢n
SELE RMOV
PRIVATE i
i = 1
IF GiTotDel > 0
   DO WHILE i<=GiTotDel
      SELE RMOV
      GO AiRegDel(i)
      Llave = (XcTransf+RMOV->CodMov+RMOV->NroDoc+RMOV->CodMat)
      IF ! RLOCK()
         LOOP
      ENDIF
      **
      GsSubAlm = SubAlm
      XsDestin = AlmOri    && << OJO <<
      XsCodMat = CodMat
      =SEEK(RMOV->CodMat,"MATG")
      IF !RLOCK("MATG")
         LOOP
      ENDIF
      =SEEK(GsSubAlm+RMOV->CodMat,"MATE")
      IF !RLOCK("MATE")
         LOOP
      ENDIF
      REPLACE MATE->StkAct WITH MATE->StkAct + RMOV->CanDes
      ** OJO : Borramos # de serie del SERI **
     *DO xBor_Ser
      ** actualizamos almacenes **
      SELE RMOV
      DELETE
      DO AlmaCPre    && DO AlmCgStk WITH .T.
      **** Buscando el equivalente en el receptor **
      SELE RMOV
      SEEK Llave
      IF FOUND()
         * forzamos los bloqueos *
         LlRlock = .F.
         LlRlock = REC_LOCK(0)
         SELE MATE
         SEEK (XsDestin+XsCodMat)
         LlRlock = REC_LOCK(0)
         REPLACE MATE->StkAct WITH MATE->StkAct - RMOV->CanDes
         UNLOCK
         ** OJO >> Trampa **
         GsSubAlm = XsDestin
         **
         SELE RMOV
         DELETE
         UNLOCK
         DO AlmaCPre
         SELE RMOV
         UNLOCK
      ENDIF
      i = i + 1
   ENDDO
ENDIF
** NOTA >> No existe modificacion del Sub-Almacen ni del Codigo del Material **
i = 1
DO WHILE i <= GiTotItm
   GsSubAlm = AsSubAlm(i)
   XsCodMat = AsCodMat(i)
   XsDesMat = AsDesMat(i)
   XfCanDes = AfCanDes(i)
   LnD1     = AnD1    (i)
   LnD2     = AnD2    (i)
   LnD3     = AnD3    (i)
   LfPunit  = AfPunit (i)
   XfFactor = AfFacEqu(i)
   XsUndVta = AsUndVta(i)
   ** punteros en posicion  **
   =SEEK(XsCodMat,"MATG")
   IF !RLOCK("MATG")
      LOOP
   ENDIF
   SELE MATE
   SEEK (GsSubAlm+XsCodMat)
   IF !RLOCK()
      LOOP
   ENDIF
   REPLACE MATE.StkAct WITH MATE.StkAct - XfCanDes
   * * * * * * * * * * * * * *
   SELE RMOV
   IF AiNumReg(i) > 0
      GO AiNumReg(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      *** desactualizamos almacenes **
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
      REPLACE Almori WITH '002'
   ENDIF
   REPLACE RMOV->FchDoc WITH XdFchDoc
   REPLACE RMOV->CodCli WITH XsCodCli
   REPLACE RMOV->CodMat WITH XsCodMat
   REPLACE RMOV->DesMat WITH XsDesMat
   REPLACE RMOV->CanGui WITH XfCanDes
   REPLACE RMOV->Factor WITH XfFactor
   REPLACE RMOV->UndVta WITH XsUndVta
   REPLACE RMOV->CodAjt WITH " "
   REPLACE RMOV->CanDes WITH XfCanDes   && OJO
   REPLACE RMOV->CanDev WITH 0          && OJO
   REPLACE RMOV->D1     WITH LnD1
   REPLACE RMOV->D2     WITH LnD2
   REPLACE RMOV->D3     WITH LnD3
   REPLACE RMOV->PreUni WITH LfPunit
   ** actualizamos almacenes **
   DO AlmacPre  && 1ra. vuelta DO AlmDgStk
   SELE RMOV
   i = i + 1
ENDDO
* * * GRABA RECEPCION
i = 1
DO WHILE i <= GiTotItm
   GsSubAlm = XsDestin
   XsCodMat = AsCodMat(i)
   XsDesMat = AsDesMat(i)
   XfCanDes = AfCanDes(i)
   LnD1     = AnD1    (i)
   LnD2     = AnD2    (i)
   LnD3     = AnD3    (i)
   LfPunit  = AfPunit (i)
   XfFactor = AfFacEqu(i)
   XsUndVta = AsUndVta(i)
   ** punteros en posicion  **
   =SEEK(XsCodMat,"MATG")
   IF !RLOCK("MATG")
      LOOP
   ENDIF
   SELE MATE
   SEEK (GsSubAlm+XsCodMat)
   IF !RLOCK()
      LOOP
   ENDIF
   REPLACE MATE.StkAct WITH MATE.StkAct + XfCanDes
   * * * * * * * * * * * * * *
   SELE RMOV
   IF AiNumReg(i) > 0
      ** Ojito > se debe ir al almacen reflejo *
      SEEK XcTransf+XsCodMov+SUBSTR(XsNroDoc,4)+XsCodMat
      IF ! RLOCK()
         LOOP
      ENDIF
      ** desactualizamos almacenes **
      DO AlmDcStk WITH .F.
   ELSE
      APPEND BLANK
      IF ! RLOCK()
         LOOP
      ENDIF
      REPLACE RMOV->SubAlm WITH GsSubAlm
      REPLACE RMOV->TipMov WITH XcTransf
      REPLACE RMOV->CodMov WITH XsCodMov
      REPLACE RMOV->NroDoc WITH SUBST(XsNroDoc,4)
      REPLACE RMOV->Almori WITH AsSubAlm(i)
   ENDIF
   REPLACE RMOV->FchDoc WITH XdFchDoc
   REPLACE RMOV->CodCli WITH XsCodCli
   REPLACE RMOV->CodMat WITH XsCodMat
   REPLACE RMOV->DesMat WITH XsDesMat
   REPLACE RMOV->CanGui WITH XfCanDes
   REPLACE RMOV->Factor WITH XfFactor
   REPLACE RMOV->UndVta WITH XsUndVta
   REPLACE RMOV->CodAjt WITH " "
   REPLACE RMOV->CanDes WITH XfCanDes   && OJO
   REPLACE RMOV->CanDev WITH 0          && OJO
   DO AlmaCPre    && 2da. vuelta
   SELE RMOV
   UNLOCK
   i = i + 1
ENDDO
** Ahora si , grabamos los # de series del TEMPO al SERI **
** VERIFICAMOS QUE NO HAYA NADA NO PASA ARRIBA x GITOTDEL**
**DO xAct_Ser
SELE RMOV
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
DO WHILE  NroDoc=XsNroPed .AND. ! EOF() .AND. i <= CIMAXELE  && << OJO <<
   LsSubAlm = IIF(!(Codmat=[9]),[001],[  ])
   LsCodMat = CodMat
   LsDesMat = DesMat
   LsUndVta = UndVta
   LfFacEqu = FacEqu
   LfCanDes = 0
   LnD1     = D1
   LnD2     = D2
   LnD3     = D3
   LfPunit  = PreUni
   DO WHILE  NroDoc+CodMat=XsNroPed+LsCodMat .AND. !EOF()
      LfDirDes = (CanPed-CanDes)
      IF UndVta <> LsUndVta
         LfDirDes = (CanPed-CanDes)*FacEqu/LfFacEqu
      ENDIF
      IF LfDirDes > 0
         IF FchEnt <= XdFchDoc
            LfCanDes = LfCandes + LfDirDes
         ENDIF
      ENDIF
      SKIP
   ENDDO
   IF LfCanDes > 0
      AsSubAlm(i) = LsSubAlm
      AsCodMat(i) = LsCodMat
      AsDesMat(i) = LsDesMat
      AsUndVta(i) = LsUndVta
      AfFacEqu(i) = LfFacEqu
      AfCanDes(i) = LfCandes
      AnD1    (i) = LnD1
      AnD2    (i) = LnD2
      AnD3    (i) = LnD3
      AfPunit (i) = LfPunit
      i = i + 1
   ENDIF
ENDDO
GiTotItm = i - 1

RETURN
************************************************************************ FIN *
* Objeto : Emisi¢n de Gu¡a Remisi¢n
******************************************************************************
PROCEDURE xImprime

SAVE SCREEN TO TEMPO1
SELE VMOV
IF VMOV.TPOGUI$[VTAS,TRAN,OTRO,VENT]
   KTIPMOV = "S"
ELSE
   KTIPMOV = "T"
ENDIF
LsLla_I  = KTipMov+XsCodMov+SUBSTR(VMOV->NroDoc,4)
SELE RMOV
SEEK LsLla_I
IF !FOUND()
 wait  "No hallada la Guia " + LsLla_I nowait window
ENDIF
XWHILE = "! EOF() .AND. TipMov+CodMov+Nrodoc = LsLla_I"
xFOR = [VMOV.FLGEST#"A"]
Largo  = 37       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "NEWGUIA"
DO admprint WITH "REPORTS"
SELE VMOV
RESTORE SCREEN FROM TEMPO1
RETURN

************************************************************************ FIN *
* Objeto : Impresion de la Guia
******************************************************************************
*PROCEDURE xImprimir
*SELE RMOV
*SET RELA TO CodMat INTO MATG
*SET RELA TO VMOV->NroPed+CodMat INTO RPED ADDITIVE
*Largo  = 65       && Largo de pagina
*IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2+_PRN9A+_PRN6A]
*sNomRep = "vtar3100"
*SET MEMOWIDTH TO 95  && Tama¤o de la glosa
*DO DIRPRINT  WITH "REPORTS" IN admprint
*SET RELA TO
*SET MEMOWIDTH TO 50  && Valor por Defecto
*RETURN
*********************************************************************** FIN() *
* Objeto : Desactualiza Pedidos
******************************************************************************
PROCEDURE xDes_Ped

PRIVATE Llave,LfCanDes,RegAct1,RegAct2,XfFacEqu
SELE RPED
Llave = VMOV->NroPed+RMOV->CodMat
SEEK Llave
* 1ro. vamos al ultimo registro *
SCAN WHILE NroDoc+CodMat=Llave
ENDSCAN
SKIP -1
* 2do. desactualizamos desde el ultimo registro *
LfCanDes  = RMOV->CanDes
XfFacEqu  = RMOV->FACTOR
DO WHILE !BOF() .AND. NroDoc+CodMat=Llave
   LfCanEqu = LfCanDes
   IF UndVta <> RMOV->UndVta
      LfCanEqu = LfCanDes*XfFacEqu/FacEqu
   ENDIF
   IF LfCanEqu >= CanDes
      LfCanEqu = LfCanEqu - CanDes
      REPLACE CanDes WITH 0
   ELSE
      REPLACE CanDes WITH CanDes - LfCanEqu
      LfCanEqu = 0
   ENDIF
   LfCanDes = LfCanEqu
   IF UndVta <> RMOV->UndVta
      IF LfCanEqu <= 0
         LfCanDes = 0
      ELSE
         LfCanDes = LfCanEqu*FacEqu/XfFacEqu
      ENDIF
   ENDIF
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
   SKIP -1
   IF LfCanDes <= 0
      EXIT
   ENDIF
ENDDO
SELECT RMOV

RETURN
*********************************************************************** FIN() *
* Objeto : Actualiza Pedidos
******************************************************************************
PROCEDURE xAct_Ped

PRIVATE Llave,LfCanDes,RegAct1,RegAct2
SELE RPED
Llave = VMOV->NroPed+XsCodMat
SEEK Llave
LfCanDes  = XfCanDes
RegAct1   = 0
RegAct2   = 0
DO WHILE NroDoc+CodMat = Llave .AND. ! EOF()
   DO CASE
      CASE CanPed-CanDes<=0
         REPLACE FlgEst WITH [C]
         RegAct2   = RECNO()
      OTHER
         LfDirDes = (CanPed-CanDes)
         IF UndVta <> XsUndVta
            LfDirDes = (CanPed-CanDes)*FacEqu/XfFactor
         ENDIF
         IF LfCandes > LfDirDes
            LfCandes = LfCanDes - LfDirDes
            REPLACE CanDes WITH CanPed
         ELSE
            REPLACE CanDes WITH CanDes + LfCanDes
            LfCanDes = 0
         ENDIF
         RegAct1   = RECNO()
         IF CanPed-CanDes<=0
            REPLACE FlgEst WITH [C]
         ELSE
            IF CanDes > 0
               REPLACE FlgEst WITH [P]    && Atencion Parcial
            ELSE
               REPLACE FlgEst WITH []
            ENDIF
         ENDIF
   ENDCASE
   UNLOCK
   SKIP
   IF LfCanDes <= 0
      EXIT
   ENDIF
ENDDO
IF LfCanDes > 0
   IF RegAct1 > 0
      GOTO RegAct1
      REPLACE CanDes WITH CanDes + LfCanDes
   ELSE
      IF RegAct2 > 0
         GOTO RegAct2
         REPLACE CanDes WITH CanDes + LfCanDes
      ENDIF
   ENDIF
ENDIF
SELECT RMOV
RETURN
************************************************************************ FIN()
* ACTUALIZA LA VENTA DE No. DE SERIES
************************************************************************
PROCEDURE xAct_Ser

SELE SERI
vLlave = XcTipMov+XsCodMov+SUBST(XsNroDoc,4)
SEEK vLlave
DO WHILE !EOF() .AND. TipMov+CodMov+NroDoc=vLlave
   IF !REC_LOCK(5)
      LOOP
   ENDIF
   DELETE
   UNLOCK
   SKIP
ENDDO
SELE TEMPO
SEEK XcTipMov+XsCodMov+SUBST(XsNroDoc,4)
DO WHILE !EOF() .AND. XcTipMov+XsCodMov+SUBST(XsNroDoc,4)= TipMov+CodMov+NroDoc
   SELE SERI
   APPEND BLANK
   IF !REC_LOCK(5)
      SELE TEMPO
      LOOP
   ENDIF
   REPLACE SERI->CodEle WITH TEMPO->CodEle
   REPLACE SERI->SubAlm WITH TEMPO->SubAlm
   REPLACE SERI->CodMat WITH TEMPO->CodMat
   REPLACE SERI->TipMov WITH TEMPO->TipMov
   REPLACE SERI->CodMov WITH TEMPO->CodMov
   REPLACE SERI->NroDoc WITH TEMPO->NroDoc
   REPLACE SERI->FchDoc WITH TEMPO->FchDoc
   REPLACE SERI->CodAux WITH TEMPO->CodAux
   REPLACE SERI->NomAux WITH TEMPO->NomAux
  *REPLACE SERI->Status WITH 'N'
   * * * *
   SELE TEMPO
   SKIP
ENDDO
SELE SERI
RETURN
************************************************************************ FIN()
* BORRA LA VENTA DE LOS No. DE SERIES
************************************************************************
PROCEDURE xBOR_SER
SELE SERI
cLlave = RMOV->TipMov+RMOV->CodMov+RMOV->NroDoc+RMOV->CodMat
SEEK cLlave
DO WHILE !EOF() .AND. TipMov+CodMov+NroDoc+CodMat=cLlave
   IF REC_LOCK(5)
      DELETE
      UNLOCK
   ENDIF
   SKIP
ENDDO
RETURN
*********************************************************************** FIN() *
*  Proposito   : Procedimientos de browse (Ingresos de Nuemros de Serie)
************************************************************************
PROCEDURE xBrowseE

PRIVATE Consulta,Modifica,Adiciona,DB_Pinta,Set_Escape
PRIVATE SelLin,insLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder,E1,E2,E3
PRIVATE Static,VSombra,d
Set_Escape = .T.  && OJITO
SelLin   = []
InsLin   = []
EscLin   = []
EdiLin   = "MOVbedi1"
BrrLin   = "MOVbbor1"
GrbLin   = "MOVbGra1"
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
NClave   = [TipMov+CodMov+NroDoc+CodMat]
VClave   = XcTipMov+XsCodMov+SUBST(XsNroDoc,4)+LsCodMat
HTitle   = 3
LinReg   = "CodEle"
Yo       = 11
Xo       = 48
Largo    = 12
Ancho    = 20
TBorde   = Doble
E1       = "Nro. Serie      "
*           1234567890123456
E2       = []
E3       = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
BBVerti  = .T.
Static   = .T.
VSombra  = .F.
DB_Pinta = .F.
*** Variable a Conocer ****
DO WHILE .T.
   UltTecla = 0
   SELE TEMPO
   XsCodEle = SPACE(LEN(CodEle))
   XsCodMat = LsCodMat
   DO LIB_MTEC WITH 14
   DO dbrowse
   IF UltTecla = Escape
      EXIT
   ENDIF
   SELE TEMPO
   d = 0
   SEEK XcTipMov+XsCodMov+SUBS(XsNroDoc,4)+XsCodMat
   DO WHILE !EOF() .AND. TipMov+CodMov+NroDoc+CodMat = XcTipMov+XsCodMov+SUBS(XsNroDoc,4)+XsCodMat
      d = d + 1
      skip
   ENDDO
   IF d # LfCanDes
      IF d>LfCanDes
         GsMsgErr = "Se excedi¢ en "+TRANS(d-LfCanDes,'999')+" de nros. serie"
         DO LIB_MERR WITH 99
      ELSE
         GsMsgErr = "Faltan ingresar "+TRANS(LfCanDes-d,'999')+" de nros. serie"
         DO LIB_MERR WITH 99
      ENDIF
     *LOOP  && hay algunos que no tienen serie
   ENDIF
   EXIT
ENDDO
*UltTecla = IIF(UltTecla=Escape,Izquierda,Enter)
UltTecla = IIF(UltTecla=Escape,0,Enter)
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
************************************************************************
PROCEDURE MOVbedi1

IF ! Set_Append
   XsCodEle = CodEle
ELSE
   XsCodEle = SPACE(LEN(CodEle))
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
d = 1
UltTecla = 0
DO WHILE UltTecla # Escape
   DO CASE
   CASE d = 1        && Codigo de material
     *SELE SERI
     *SET ORDER TO MSER05
      @ LinAct,50 GET XsCodEle  PICT "@!"
      READ
      UltTecla = LASTKEY()
      IF INLIST(UltTecla,Escape,Arriba,Abajo)
         SELE TEMPO
         EXIT
      ENDIF
     *IF UltTecla = F8 .AND. EMPTY(XsCodEle)
     *   IF !vtabusca("SER1")
     *      LOOP
     *   ENDIF
     *   XsCodEle = SERI->CodEle
     *   UltTecla = Enter
     *ENDIF
      @ LinAct,50 SAY XsCodEle  PICT "@!"
     *SEEK 'D'+XsCodMat+XsCodEle
     *IF !FOUND()
     *   GsMsgErr = "Serie no Disponible para Ventas"
     *   DO lib_merr WITH 99
     *ENDIF
      @ LinAct,50 SAY XsCodEle
     *SET ORDER TO MSER02
     *SELE TEMPO
      IF UltTecla = Enter
         EXIT
      ENDIF
   ENDCASE
   d = IIF(UltTecla = Arriba, d-1, d+1)
   d = IIF(d>1, 1, d)
   d = IIF(d<1, 1, d)
ENDDO
DO LIB_MTEC WITH 14
SELE TEMPO
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
************************************************************************
PROCEDURE MOVbbor1
DELETE
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
************************************************************************
PROCEDURE MOVbgra1
DO LIB_MSGS WITH 4
IF Set_Append
   APPEND BLANK
   REPLACE TipMov WITH XcTipMov
   REPLACE CodMov WITH XsCodMov
   REPLACE NroDoc WITH SUBST(XsNroDoc,4)
   REPLACE CodMat WITH XsCodMat
ENDIF
REPLACE SubAlm WITH LsSubAlm
REPLACE CodEle WITH XsCodEle
REPLACE FchDoc WITH XdFchDoc
REPLACE CodAux WITH XsCodCli
REPLACE NomAux WITH XsNomCli
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
PROCEDURE vista_reporte
SELECT Vtavguia.nrodoc, Vtavguia.fchdoc, Cctclien.razsoc,;
  Cctclien.nroruc, Cctcdire.desdire, Distritos.desdist, Vtavguia.nomtra,;
  Vtavguia.dirtra, Vtavguia.ructra, Vtavguia.platra, Almdtran.codmat,;
  Almdtran.candes, Almcatge.desmat;
 FROM  cia001!vtavguia INNER JOIN p0012003!almdtran;
    INNER JOIN p0012003!almcatge;
    INNER JOIN cia001!cctclien;
    INNER JOIN cia001!cctcdire;
    INNER JOIN cia001!distritos ;
   ON  Cctcdire.coddist = Distritos.coddist ;
   ON  Cctclien.codcli = Cctcdire.codcli ;
   ON  Vtavguia.codcli = Cctclien.codaux ;
   ON  Almdtran.codmat = Almcatge.codmat ;
   ON  Vtavguia.nrodoc = Almdtran.nrodoc


