PARAMETER _CodDoc
PRIVATE XsTpoDoc,XsCodDoc

IF !_CodDoc $ [FACT|BOLE]
   RETURN
ENDIF
RESTORE FROM VTACONFG ADDITIVE
XsTpoDoc = [Cargo]
XsCodDoc = _CodDoc
** Pantalla de Datos **
DO xPanta
** base de datos **
CLOSE DATA
*
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
USE vtarpedi ORDER RPED02 ALIAS RPED
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 4
USE almmmatg ORDER MATG01 ALIAS MATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 5
USE vtatdocm ORDER DOCM01 ALIAS DOCM
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 6
USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 7
USE vtaritem ORDER ITEM01 ALIAS DETA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 8
USE vtavguia ORDER VGUI01 ALIAS GUIA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 9
USE almrmovm ORDER RMOV06 ALIAS RMOV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 10
USE admmtcmb ORDER TCMB01 ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 11
USE almtabla ORDER TABL01 ALIAS TABL
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 12
USE almtuvta ORDER UVTA01 ALIAS UVTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELECT 13
USE ccbtbdoc ORDER BDOC01 ALIAS TDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELECT 14
USE almtfami ORDER FAMI01 ALIAS FAMI
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** Archivo Auxiliar **
Arch = PathUser+SYS(3)
SELE 0
CREATE TABLE &Arch. ( CodDoc C(4), NroDoc C(9), FchDoc D, FlgEst C(1), NroPed C(6) )
USE &Arch. ALIAS AUXI EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** relaciones a usar **
SELECT GDOC
*SET RELATION TO GsClfAux+CodCli INTO CLIE
** variables a usar **
** variables de cabecera **
PRIVATE XsPtoVta,XsNroDoc,XdFchDoc,XsCodCli,XsNroO_C,XdFchO_C,XiFmaPgo,XiDiaVto
PRIVATE XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfTpoCmb,XfPorIgv,XfPorDto
PRIVATE XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpTot,XfImpFlt
PRIVATE XcFlgEst,XdFchVto,XcFlgUbc
PRIVATE XsGlosa1,XsGlosa2,XsGlosa3,XsGloDoc
PRIVATE XsCodRef,XsNroRef,XsNroPed
PRIVATE XsNomCli,XsDirCli,XsRucCli,XsDirEnt
PRIVATE XlModif
STORE [] TO XsPtoVta,XsNroDoc,XdFchDoc,XsCodCli,XsNroO_C,XdFchO_C,XiFmaPgo,XiDiaVto
STORE [] TO XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfTpoCmb,XfPorIgv,XfPorDto
STORE [] TO XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpTot,XfImpFlt
STORE [] TO XcFlgEst,XdFchVto,XcFlgUbc
STORE [] TO XsGlosa1,XsGlosa2,XsGlosa3,XsGloDoc
STORE [] TO XsCodRef,XsNroRef,XsNroPed
STORE [] TO XsNomCli,XsDirCli,XsRucCli,XsDirEnt
XlModif  = .T.
XsCodRef = [FREE]
XiCodMon = 1
** Variables del Browse **
PRIVATE AsCodMat,AsUndVta,AfPreUni,AfCanFac,AfImpLin,GiTotItm
PRIVATE AnD1,AnD2,AnD3
***** MAXIMO ELEMENTOS DE LA FACTURA *****
CIMAXELE = 16     && NO sobrepasar este valor
DIMENSION AsNroG_R(CIMAXELE)
DIMENSION AsCodMat(CIMAXELE)
DIMENSION AsDesMat(CIMAXELE)
DIMENSION AsUndVta(CIMAXELE)
DIMENSION AfPreUni(CIMAXELE)
DIMENSION AfCanFac(CIMAXELE)
DIMENSION AfFacEqu(CIMAXELE)
DIMENSION AfImpLin(CIMAXELE)
DIMENSION AnD1    (CIMAXELE)
DIMENSION AnD2    (CIMAXELE)
DIMENSION AnD3    (CIMAXELE)

GiTotItm = 0
** control correlativo multiusuario **
PRIVATE m.NroDoc
m.NroDoc = []
XsCodDoc = PADR(XsCodDoc,LEN(GDOC->CodDoc))
** Logica Principal **
SELE GDOC
DO LIB_MTEC WITH 3
UltTecla = 0
cCodDoc = XsCodDoc
cTpoDoc = XsTpoDoc
SEEK cTpoDoc+cCodDoc+CHR(255)
IF RECNO(0) > 0 .AND. RECNO(0)<=RECCOUNT()
   GOTO RECNO(0)
   SKIP -1
   IF BOF()
      GO TOP
   ENDIF
ELSE
   GOTO BOTTOM
ENDIF
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'Ximprime',;
              [TpoDoc+CodDoc],cTpoDoc+cCodDoc,'CMAR',[]
CLOSE DATA
DELETE FILE &Arch..dbf

RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta
CLEAR

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*0ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
*1³ Factura No.:                                           Fecha :               ³"
*2ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
*3³     Pedido No. :                     Fecha del Pedido :                      ³"
*4³      Solicitud :                      Condic. de Venta:                      ³"
*5³    O/C Cliente :                        Forma de Pago :                      ³"
*6³Fecha de la O/C :                       Dias de Vencto.:                      ³"
*7ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
*8³ Cliente    :                                             RUC :               ³"
*9³ Nombre     :                                                                 ³"
*0³ Oficina en :                                                                 ³"
*1³ Entregar en: 1234567890123456789012345678901234567890 Moneda :               ³"
*2³ Nro. de G/R:                                  Tipo de Cambio :               ³"
*3Ã[Guia/Rem.] [Codigo] [  Descripcion     ] Und [Cantidad] P.Unitario [  Total ]´"
*4³                                                                              ³"
*5³                                                                              ³"
*6³                                                                              ³"
*7³999-9999999 12345678 12345678901234567890 123 999,999.99 999,999.99 999,999.99³"
*8ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
*9³Venta Bruta:                   % Dscto:                Descuento:             ³"
*0³                                                       Valor Vta:             ³"
*1³      % IGV:                       IGV:               Precio Vta:             ³"
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*           1         2         3         4         5         6         7         8


@  0,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  1,0  SAY "³ Factura No.:                                           Fecha :               ³"
@  2,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  3,0  SAY "³ Cliente    :                                             RUC :               ³"
@  4,0  SAY "³ Nombre     :                                                                 ³"
@  5,0  SAY "³ Direcci¢n  :                                                                 ³"
@  6,0  SAY "³ Vendedor   :                                                                 ³"
@  7,0  SAY "³ Forma Pago :                                                                 ³"

            *          1         2         3         4         5         6         7         8
            *012345678901234567890123456789012345678901234567890123456789012345678901234567890
                         *############# ###### ### #########  ########## ## ## ## ##########
*@  8,0  SAY "Ã[  Codigo   ] Descripci¢n     Und [Cantidad] P.Unitario             [  Total ]´"
@  9,0  SAY "³                                                                              ³"
@ 10,0  SAY "³                                                                              ³"
@ 11,0  SAY "³                                                                              ³"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
@ 14,0  SAY "³                                                                              ³"
@ 15,0  SAY "³                                                                              ³"
@ 16,0  SAY "³                                                                              ³"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 19,0  SAY "³Venta Bruta:                   % Dscto:                Descuento:             ³"
@ 20,0  SAY "³                                                       Valor Vta:             ³"
@ 21,0  SAY "³      % IGV:                       IGV:               Precio Vta:             ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
*
@ 19,1 FILL TO 21,78 COLOR SCHEME 7
*
Titulo = [** FACTURA DE VENTAS **]
IF XsCodDoc = [BOLE]
   @  1,0  SAY "³  Boleta No.:                                           Fecha :               ³"
   Titulo = [** BOLETA DE VENTA **]
ENDIF
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7



            *          1         2         3         4         5         6         7         8
            *012345678901234567890123456789012345678901234567890123456789012345678901234567890
                         *############# ###### ### #########  ########## ## ## ## ##########
*@  8,0  SAY "Ã[  Codigo   ] Descripci¢n     Und [Cantidad] P.Unitario             [  Total ]´"


@  8,01 SAY PADC("C¢digo",13)      COLOR SCHEME 7
@  8,15 SAY "Descripci¢n"          COLOR SCHEME 7
@  8,36 SAY "Und"                  COLOR SCHEME 7
@  8,40 SAY " Cantidad "           COLOR SCHEME 7
@  8,51 SAY "P.Unitario"           COLOR SCHEME 7
@  8,62 SAY "Dscto"                COLOR SCHEME 7
@  8,69 SAY "   Total  "           COLOR SCHEME 7

RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave

****** Buscando Los puntos de Ventas Activos **********
SELE DOCM
SEEK XsCodDoc
IF !FOUND()
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
@ 1,15 SAY XsPtoVta
*
SELE GDOC
i = 1
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1 .AND. XiPidPto
         SELE DOCM
         @ 1,15 GET XsPtoVta PICT "999"
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
         @ 1,15 SAY XsPtoVta
         SEEK XsCodDoc+XsPtoVta
         IF !FOUND()
            GsMsgErr = "No existe correlativo"
            DO lib_merr WITH 99
            LOOP
         ENDIF
      CASE i = 1 .AND. !XiPidPto
         UltTecla = Enter
      CASE i = 2

         XiNroDoc  = DOCM->NroDoc
         XsNroDoc = XsPtoVta + TRANSF(XiNroDoc,"@L 999999")
         SELE GDOC
         IF CHRVAL # "C"
            @ 1,19 GET XiNroDoc PICT "@L 999999"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,Escape)
               LOOP
            ENDIF
            IF UltTecla = F8
               IF ! vtabusca("0013")
                  UltTecla = 0
                  LOOP
               ENDIF
               XiNroDoc  = VAL(SUBSTR(GDOC->NroDoc,4))
            ENDIF
         ELSE
            UltTecla = Enter
            @ 1,15 SAY XsNroDoc PICT "@R 999-999999"
            SEEK XsTpoDoc+XsCodDoc+XsNroDoc
            IF FOUND()
               GsMsgErr = "Error en el Registro de Correlativos"
               DO LIB_MERR WITH 99
               UltTecla = Escape
            ENDIF
         ENDIF
         XsNroDoc = XsPtoVta + TRANSF(XiNroDoc,"@L 999999")
         @ 1,15 SAY XsNroDoc PICT "@R 999-999999"
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
IF FOUND()   && para reimprimir factura
   SELE DETA
   LsLlave  = XsCodDoc+XsNroDoc
   SEEK LsLlave
   * test de impresion *
   xFOR = []
   xWHILE = [CodDoc+NroDoc=LsLlave]
   cResp = []
   cResp = AVISO(10,[>>>>>>>>>>>>************<<<<<<<<<<<<<<],;
                 [>>>>  coloque nuevamente formato de FACTURA en su impresora  <<<<],[Presione barra espaciadora para continuar],;
                 3,[ ],0,.T.,.F.,.T.)
   DO xImprime
   SELE GDOC
   UltTecla = Escape
   Xlmodif=.T.
ELSE
   Xlmodif=.F.
ENDIF
**
RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

IF XlModif
   RETURN
ENDIF
** SOLO ES CREAR **
SELE GDOC
Crear = .T.
DO xInvar
LiOpcion = 1 && Variable de Control de Seleccion
* Logica Principal *
@  1,65 GET XdFchDoc
@  3,15 GET XsCodCli PICT "@!"
@  6,15 GET XsCodVen PICT "!!!!"

CLEAR GETS
UltTecla = 0
PRIVATE i
i = 1
DO WHILE UltTecla # Escape
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         UltTecla = Enter
         LiOpcion = 4
      CASE i = 2
         @ 1,65 GET XdFchDoc
         READ
         UltTecla = LASTKEY()
         @ 1,65 SAY XdFchDoc
         IF !INLIST(UltTecla,BackTab,Escape,Arriba)
            IF ! Modificar()
               GsMsgErr = "Mes Cerrado, acceso denegado"
               DO LIB_MERR WITH 99
               LOOP
            ENDIF
         ENDIF

      CASE i = 3
         DO xTomar4
      CASE i = 7
         DO LIB_MTEC WITH 16
         VecOpc(1)="Contado"
         VecOpc(2)="Credito"
         VecOpc(3)="Consignacion"
         XiFmaPgo= Elige(XiFmaPgo,7,15,3)
      CASE i = 5

      CASE i = 6

      CASE i = 4
         SELECT TABL
         XsTabla = "09"
         @ 06,15 GET XsCodVen PICT "!!!!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8  or XsCodVen = ""
            IF !vtabusca("TABL")
               UltTecla = 0
               LOOP
            ENDIF
            XsCodVen = TABL->Codigo
         ENDIF
         @ 06,15 SAY XsCodVen PICT "!!!!"
         @ 06,20 SAY TABL.Nombre PICT "@S15"
      CASE i = 8
       * DO LIB_MTEC WITH 16
       * VecOpc(1)="S/."
       * VecOpc(2)="US$"
       * XiCodMon= Elige(XiCodMon,11,65,2)

      CASE i = 9
         IF SEEK(DTOS(XdFchDoc),"TCMB")
            XfTpoCmb = TCMB->OfiVta
         ELSE
            XfTpoCmb = 1
         ENDIF

       * @ 12,65 GET XfTpoCmb PICT "99,999.9999" RANGE 0,
       * READ
       * UltTecla = LASTKEY()
       * @ 12,65 SAY XfTpoCmb PICT "99,999.9999"

      CASE i = 10
         DO xBrowse2

      CASE i = 11
         DO xTomarx

      CASE i = 12
         cResp = [N]
         cResp = aviso(12,[Datos Correctos (S-N)?],[],[],3,[SN],0,.F.,.F.,.T.)
         IF cResp = [N]
             UltTecla = Escape
         ELSE
             UltTecla = Enter
         ENDIF
   ENDCASE
   IF i = 12 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIS(UltTecla,BackTab,Arriba),i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>12,12,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
ENDIF
SELE GDOC
UNLOCK ALL
DO LIB_MTEC WITH 3

RETURN
************************************************************************ FIN()
* Factura LIBRE
******************************************************************************
PROCEDURE xTomar4

** Pedimos cliente a trabajar **
SELE CLIE
@ 3,15 GET XsCodCli PICT "@!"
READ
UltTecla = LASTKEY()
IF INLIST(UltTecla,Arriba,BackTab,Escape)
   RETURN
ENDIF
IF EMPTY(XsCodCli) .OR. UltTecla = F8
   IF ! vtabusca("CLIE")
      RETURN
   ENDIF
   XsCodCli = CLIE->CodAux
ENDIF
@ 3,15 SAY XsCodCli
** Codigo libre pide datos **
IF XsCodCli=[99999]
   IF _coddoc  = "BOLE"
      XsRuccli = ""
   ENDIF
   @  3,65 GET XsRucCli PICT "@!"
   @  4,15 GET XsNomCli PICT "@!"
   @  5,15 GET XsDirCli PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF INLIST(UltTecla,Arriba,Escape)
      RETURN
   ENDIF
ELSE
   SEEK GsClfAux+XsCodCli
   IF !FOUND()
      DO lib_merr WITH 6
      RETRY
   ENDIF
   XsNomCli = CLIE->NomAux
   XsDirCli = CLIE->DirAux
   XsDirEnt = CLIE->DirEnt
   XsRucCli = CLIE->RucAux
ENDIF
@  3,65 SAY XsRucCli
@  4,15 SAY XsNomCli
@  5,15 SAY XsDirCli
* Verificar RUC para facturas *
IF XsCodDoc = [FACT] .AND. EMPTY(XsRucCli)
   GsMsgErr = [ El Cliente NO tiene RUC ]
   DO lib_merr WITH 99
   RETRY
ENDIF

RETURN
************************************************************************ FIN()
* Pedir Informacion Final
******************************************************************************
PROCEDURE xTomarx
UltTecla = Enter
PRIVATE i
GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
DO lib_mtec WITH 99
RETURN
************************************************************************ FIN()
* Cargar variables
******************************************************************************
PROCEDURE xMover

SELE GDOC
XsNroDoc = NroDoc
XdFchDoc = FchDoc
XdFchVto = FchVto
XsCodCli = CodCli
XsCodVen = CodVen
XsNomCli = NomCli
XsDirCli = DirCli
XsRucCli = RucCli
XsDirEnt = DirEnt
XsNroO_C = NroO_C
XdFchO_C = FchO_C
XiFmaPgo = FmaPgo
XsFmaSol = FmaSol
XiDiaVto = DiaVto
XsCndPgo = CndPgo
XiCodMon = CodMon
XfTpoCmb = TpoCmb
XfPorIgv = PorIgv
XfPorDto = PorDto
XfImpBto = ImpBto
XfImpDto = ImpDto
*XfImpInt = ImpInt
*XfImpAdm = ImpAdm
XfImpIgv = ImpIgv
XfImpTot = ImpTot
XsGloDoc = GloDoc
XcFlgEst = FlgEst
XcFlgUbc = FlgUbc
XsCodRef = CodRef
XsNroRef = NroRef
XsNroPed = NroPed
** cargamos arreglos **
DO xBmove2
***********************
SELE GDOC

RETURN
************************************************************************ FIN()
* Inicializamos Variables
******************************************************************************
PROCEDURE xInvar

XdFchDoc = GdFecha
XdFchVto = GdFecha
XsCodCli = "99999"
XsCodVen = SPACE(LEN(CodVen))
XsNomCli = SPACE(LEN(NomCli))
XsDirCli = SPACE(LEN(DirCli))
XsRucCli = SPACE(LEN(RucCli))
XsNroO_C = SPACE(LEN(NroO_C))
XdFchO_C = {,,}
XiFmaPgo = 1
XsFmaSol = SPACE(LEN(FmaSol))
XiDiaVto = 0
XsCndPgo = SPACE(LEN(CndPgo))
XiCodMon = 1
XfTpoCmb = 0
XfPorIgv = CFGADMIGV
XfPorDto = 0
XfImpBto = 0
XfImpDto = 0
XfImpInt = 0
XfImpAdm = 0
XfImpIgv = 0
XfImpTot = 0
XsGloDoc = []
XcFlgEst = [P]
XcFlgUbi = [C]
XsCodRef = [FREE]
XsNroRef = SPACE(LEN(NroRef))
XsNroPed = SPACE(LEN(NroPed))
** Variables del Browse **
STORE SPACE(LEN(GUIA->NroDoc)) TO AsNroG_R
STORE SPACE(LEN(DETA->CodMat)) TO AsCodMat
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat
STORE SPACE(LEN(DETA->UndVta)) TO AsUndVta
STORE 0                        TO AfPreUni
STORE 0                        TO AnD1,AnD2,AnD3
STORE 0                        TO AfCanFac
STORE 1                        TO AfFacEqu
STORE 0                        TO AfImpLin
GiTotItm = 0

RETURN
************************************************************************ FIN()
* Pintar Informacion en Pantalla
******************************************************************************
PROCEDURE xPoner

=SEEK(GDOC->NroPed,"VPED")
SELE GDOC
@  1,15 SAY NroDoc PICT "@R 999-999999"
@  1,65 SAY FchDoc
@  3,15 SAY CodCli PICT "@!"
@  3,65 SAY RucCli
@  4,15 SAY NomCli
@  5,15 SAY DirCli
@  6,15 SAY CodVen PICT "!!!!"
@  6,20 SAY IIF(SEEK("09" + TRIM(CODVEN) , "TABL" ), TABL.NOMBRE , SPACE(30) )
@  7,15 SAY IIF(FMAPgo= 1, "Contado" , IIF(FMAPGO = 2 , "Cr‚dito","") )   PICT "@S20"
@ 20,03 SAY SPACE(30) COLOR SCHEME 7
NumLin = 09
@ 09,1 CLEAR TO 17,78
IF FlgEst = [A]
   @ NumLin ,15 SAY "  ##    ##   #  #    #  #        ##    #####   ######"
   @ ROW()+1,15 SAY " #  #   # #  #  #    #  #       #  #   #    #  #    #"
   @ ROW()+1,15 SAY "######  #  # #  #    #  #      ######  #    #  #    #"
   @ ROW()+1,15 SAY "#    #  #   ##  ######  #####  #    #  #####   ######"
ENDIF
SELE DETA
SEEK GDOC->CodDoc+GDOC->NroDoc
SCAN WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. NumLin <= 17
   @ NumLin,01 SAY CodMat
   @ NumLin,15 SAY DesMat PICT "@S20"
   @ NumLin,36 SAY UndVta
   @ NumLin,40 SAY CanFac PICT "9999999.99"
   @ NumLin,51 SAY PreUni PICT "99,999.999"
   @ NumLin,62 SAY d1     PICT "99.99"
   @ NumLin,69 SAY ImpLin PICT "9999999.99"
   NumLin = NumLin + 1
ENDSCAN
* *
SELE GDOC
@ 19,14 SAY ImpBto PICT "99999,999.99"   COLOR SCHEME 7
@ 19,41 SAY PorDto PICT "99999,999.99"   COLOR SCHEME 7
@ 19,67 SAY ImpDto PICT "99999,999.99"   COLOR SCHEME 7
*@ 20,14 SAY ImpInt PICT "99999,999.99"   COLOR SCHEME 7
*@ 20,41 SAY ImpAdm PICT "99999,999.99"   COLOR SCHEME 7
XfImpVta = ImpBto-ImpDto   &&+ImpInt+ImpAdm
@ 20,67 SAY XfImpVta PICT "99999,999.99" COLOR SCHEME 7
@ 21,14 SAY PorIgv PICT "99999,999.99"   COLOR SCHEME 7
@ 21,41 SAY ImpIgv PICT "99999,999.99"   COLOR SCHEME 7
@ 21,67 SAY ImpTot PICT "99999,999.99"   COLOR SCHEME 7

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

** NOTA > Solo es crear y genera SIEMPRE correlativos **
**
SELE GDOC
IF !(&RegVal.)
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
   XsNroDoc1 = PADL(ALLTRIM(STR(DOCM->NroDoc)),LEN(GDOC->NroDoc)-4,'0')
   REPLACE DOCM->NroDoc WITH DOCM->NroDoc+1
   UNLOCK
   XsNroDoc = XsPtoVta+XsNroDoc1
   @ 1,15 SAY XsNroDoc PICT "@R 999-9999999"
   SELE GDOC
   REPLACE TpoDoc WITH XsTpoDoc
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
ELSE
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
**************
SELE GDOC
REPLACE FchDoc WITH XdFchDoc
REPLACE FchVto WITH XdFchVto
REPLACE CodCli WITH XsCodCli
REPLACE CodVen WITH XsCodVen
REPLACE NomCli WITH XsNomCli
REPLACE DirCli WITH XsDirCli
REPLACE RucCli WITH XsRucCli
REPLACE NroPed WITH XsNroPed
REPLACE NroO_C WITH XsNroO_C
REPLACE FchO_C WITH XdFchO_C
REPLACE FmaPgo WITH XiFmaPgo
REPLACE FmaSol WITH XsFmaSol
REPLACE DiaVto WITH XiDiaVto
REPLACE CndPgo WITH XsCndPgo
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE PorIgv WITH XfPorIgv
REPLACE PorDto WITH XfPorDto
REPLACE ImpBto WITH XfImpBto
REPLACE ImpDto WITH XfImpDto
*REPLACE ImpInt WITH XfImpInt
*REPLACE ImpAdm WITH XfImpAdm
REPLACE ImpIgv WITH XfImpIgv
REPLACE ImpTot WITH XfImpTot
REPLACE ImpNet WITH XfImpTot
REPLACE SdoDoc WITH XfImpTot
REPLACE GloDoc WITH XsGloDoc
REPLACE FlgEst WITH XcFlgEst
REPLACE FlgUbc WITH XcFlgUbc
REPLACE CodRef WITH XsCodRef
REPLACE NroRef WITH XsNroRef
DO CASE
   CASE XsCodRef = [G/R ]
      DO xGraba1
   CASE XsCodRef = [PEDI]
      DO xGraba2
   CASE XsCodRef = [FREE]
      DO xGraba3
ENDCASE
** ACTUALIZAMOS CONTABILIDAD **
DO xAct_Ctb
** IMPRESION DE LA FACTURA **
SELE DETA
LsLlave  = XsCodDoc+XsNroDoc
SEEK LsLlave
* test de impresion *
xFOR = []
xWHILE = [CodDoc+NroDoc=LsLlave]
cResp = []
cResp = AVISO(10,[>>>>>>>>>>>>************<<<<<<<<<<<<<<],;
              [>>>>  coloque formato de FACTURA en su impresora  <<<<],[Presione barra espaciadora para continuar],;
              3,[ ],0,.T.,.F.,.T.)
DO xImprime
* * *
SELE GDOC

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba1

** Actualizamos G/R **
SELE AUXI
GO TOP
DO WHILE !EOF()
   IF !FlgEst = [*]
      SKIP
      LOOP
   ENDIF
   SELE GUIA
   SET ORDER TO VGUI01
   SEEK AUXI->CodDoc+AUXI->NroDoc
   IF !RLOCK()
      SELE AUXI
      LOOP
   ENDIF
   REPLACE CodFac WITH XsCodDoc     && << OJO <<
   REPLACE NroFac WITH XsNroDoc
   REPLACE FlgEst WITH [F]          && Facturado
   UNLOCK
   SELE AUXI
   SKIP
ENDDO
** Grabamos Browse **
SELE DETA
PRIVATE i
i = 1
DO WHILE i <= GiTotItm
   APPEND BLANK
   IF ! RLOCK()
      LOOP
   ENDIF
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
   REPLACE FchDoc WITH XdFchDoc
   REPLACE NroRef WITH AsNroG_R(i)
   REPLACE CodMat WITH AsCodMat(i)
   REPLACE DesMat WITH AsDesMat(i)
   REPLACE UndVta WITH AsUndVta(i)
   REPLACE PreUni WITH AfPreUni(i)
   REPLACE D1     WITH AnD1    (i)
   REPLACE D2     WITH AnD2    (i)
   REPLACE D3     WITH AnD3    (i)
   REPLACE CanFac WITH AfCanFac(i)
   REPLACE FacEqu WITH AfFacEqu(i)
   REPLACE ImpLin WITH AfImpLin(i)
   UNLOCK
   i = i + 1
ENDDO

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba2

** Primero Verificamos si el Pedido tiene G/R **
SELE AUXI
IF RECCOUNT() # 0
   ** AJA!!! => marcamos las G/R como facturadas **
   DO xGraba1
   RETURN
ENDIF
** Actualizamos PEDIDO **
SELE VPED
REPLACE FlgFac WITH [F]    && Marcamos el Pedido como FACTURADO
UNLOCK
** Grabamos Browse **
SELE DETA
PRIVATE i
i = 1
DO WHILE i <= GiTotItm
   APPEND BLANK
   IF ! RLOCK()
      LOOP
   ENDIF
   ** Actualizamos Saldo del Pedido **
   SELE RPED
   SEEK XsNroPed+AsCodMat(i)
   XfCanFac = AfCanFac(i)
   IF !RLOCK()
      SELE VPED
      LOOP
   ENDIF
   DO xAct_Ped
   **
   SELE DETA
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
   REPLACE FchDoc WITH XdFchDoc
   REPLACE NroRef WITH AsNroG_R(i)
   REPLACE CodMat WITH AsCodMat(i)
   REPLACE DesMat WITH AsDesMat(i)
   REPLACE UndVta WITH AsUndVta(i)
   REPLACE PreUni WITH AfPreUni(i)
   REPLACE D1     WITH AnD1    (i)
   REPLACE D2     WITH AnD2    (i)
   REPLACE D3     WITH AnD3    (i)
   REPLACE CanFac WITH AfCanFac(i)
   REPLACE FacEqu WITH AfFacEqu(i)
   REPLACE ImpLin WITH AfImpLin(i)
   UNLOCK
   i = i + 1
ENDDO

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba3

** Grabamos Browse **
SELE DETA
PRIVATE i
i = 1
DO WHILE i <= GiTotItm
   APPEND BLANK
   IF ! RLOCK()
      LOOP
   ENDIF
   SELE DETA
   REPLACE CodDoc WITH XsCodDoc
   REPLACE NroDoc WITH XsNroDoc
   REPLACE FchDoc WITH XdFchDoc
   REPLACE NroRef WITH AsNroG_R(i)
   REPLACE CodMat WITH AsCodMat(i)
   REPLACE DesMat WITH AsDesMat(i)
   REPLACE UndVta WITH AsUndVta(i)
   REPLACE PreUni WITH AfPreUni(i)
   REPLACE D1     WITH AnD1    (i)
   REPLACE D2     WITH AnD2    (i)
   REPLACE D3     WITH AnD3    (i)
   REPLACE CanFac WITH AfCanFac(i)
   REPLACE FacEqu WITH AfFacEqu(i)
   REPLACE ImpLin WITH AfImpLin(i)
   i = i + 1
ENDDO

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE GDOC
IF FlgEst#"P" .AND. FlgEst# "A"
   WAIT "INVALIDO REGISTRO A ANULAR" NOWAIT WINDOW
   RETURN
ENDIF
IF SdoDoc#ImpTot
   WAIT "DOCUMENTO TIENE AMORTIZACIONES" NOWAIT WINDOW
   RETURN
ENDIF
IF GDOC->FlgCtb   && Ya paso a Contabilidad
   XdFchDoc = GDOC->FchDoc
   IF !Modificar()
      GsMsgErr = "Mes Cerrado, acceso denegado"
      DO LIB_MERR WITH 99
      SELE GDOC
      RETURN
   ENDIF
   SELE GDOC
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
IF CodRef = [PEDI]
   SELE VPED
   SEEK GDOC->NroPed
   IF !REC_LOCK(5)
      SELE GDOC
      UNLOCK
      RETURN
   ENDIF
ENDIF
** Anulamos de Acuerdo al Tipo de Factura
SELE GDOC
DO CASE
   CASE CodRef = [G/R]
      DO xBorra1
   CASE CodRef = [PEDI]
      DO xBorra2
   CASE CodRef = [FREE]
      DO xBorra3
ENDCASE
* * * * *
IF GDOC->FlgCtb
   DO xDes_Ctb
ENDIF
* * * * *
* anulado total
* * * * *
SELE GDOC
IF FlgEst = "A"  && PARA QUE DESAPARESCA
   DELETE
ELSE
   REPLACE FlgEst WITH [A]
ENDIF
UNLOCK
SKIP

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorra1

* Buscamos G/R *
SELE GUIA
SET ORDER TO VGUI03
SEEK GDOC->CodDoc+GDOC->NroDoc
DO WHILE !EOF() .AND. CodFac+Nrofac = GDOC->CodDoc+GDOC->NroDoc
   IF !RLOCK()
      LOOP
   ENDIF
   REPLACE CodFac WITH []     && OJITO
   REPLACE NroFac WITH []
   REPLACE FlgEst WITH [E]
   UNLOCK
   SEEK GDOC->CodDoc+GDOC->NroDoc
ENDDO
SET ORDER TO VGUI01
** anulamos detalles **
SELE DETA
SEEK GDOC->CodDoc+GDOC->NroDoc
DO WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. ! EOF()
   IF ! RLOCK()
      LOOP
   ENDIF
   DELETE
   UNLOCK
   SKIP
ENDDO

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorra2

* Verificamos Status del Pedido *
SELE VPED
IF FlgFac = [F]      && OJO : Todo el Pedido fue Facturado
   ** anulamos detalles **
   SELE DETA
   SEEK GDOC->CodDoc+GDOC->NroDoc
   DO WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. ! EOF()
      IF ! RLOCK()
         LOOP
      ENDIF
      =SEEK(VPED->NroDoc+DETA->CodMat,"RPED")
      IF !RLOCK("RPED")
         LOOP
      ENDIF
      DO xDes_Ped
      SELE DETA
      DELETE
      UNLOCK
      SKIP
   ENDDO
   SELE VPED
   REPLACE FlgFac WITH []
   UNLOCK
ELSE
   ** Desmarcamos G/R **
   DO xBorra1
ENDIF

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorra3

** anulamos detalles **
SELE DETA
SEEK GDOC->CodDoc+GDOC->NroDoc
DO WHILE CodDoc+NroDoc=GDOC->CodDoc+GDOC->NroDoc .AND. ! EOF()
   IF ! RLOCK()
      LOOP
   ENDIF
   DELETE
   UNLOCK
   SKIP
ENDDO

RETURN
************************************************************************ FIN()
* Browse de Items
****************************************************************************
PROCEDURE xBrowse2

**
PrgFin   = []
*
Yo       = 08
Xo       = 0
Largo    = 11
Ancho    = 80
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""

EscLin   = "xBline2"
EdiLin = "xBedit2d"
InsLin = "xBinse2d"
BrrLin = "xBborr2d"
*
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
GsMsgKey = "[Enter] Modificar   [F10] Continuar   [Esc] Regresar"
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
* Objeto : Carga el Arreglo
******************************************************************************
PROCEDURE xBiniv2a

=SEEK(XsCodRef+XsNroRef,"GUIA")
SELE AUXI
ZAP
APPEND BLANK
REPLACE CodDoc WITH GUIA->CodDoc
REPLACE NroDoc WITH GUIA->NroDoc
REPLACE FchDoc WITH GUIA->FchDoc
REPLACE FlgEst WITH [*]
DO xBiniv2b

RETURN
************************************************************************ FIN *
* Objeto : Carga el Arreglo
******************************************************************************
PROCEDURE xBiniv2b

**
STORE SPACE(LEN(GUIA->NroDoc)) TO AsNroG_R
STORE SPACE(LEN(DETA->CodMat)) TO AsCodMat
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat
STORE SPACE(LEN(DETA->UndVta)) TO AsUndVta
STORE 0                        TO AfPreUni
STORE 0                        TO AnD1,AnD2,AnD3
STORE 0                        TO AfCanFac
STORE 1                        TO AfFacEqu
STORE 0                        TO AfImpLin
** OJO : Antes que nada debemos contar la cantidad de items a generar
**       para que no sobrepase la capacidad del CIMAXELE.
PRIVATE i,j
STORE 0 TO i,j    && i : cantidad de items aceptados
                  && j : cantidad de items por guia
PRIVATE XcTipMov,XsCodMov,XsNroDoc,XsNroRef
XcTipMov = [S]
STORE [] TO XsCodMov,XsNroDoc,XsNroRef
SELE AUXI
DELETE FOR !(FlgEst=[*])   && borramos los no seleccionados
GO TOP
DO WHILE !EOF()
   * barremos la 1ra. guia *
   XsCodMov = [G]+SUBSTR(NroDoc,2,2)
   XsNroDoc = SUBSTR(NroDoc,4)
  *XsGloDoc = XsGloDoc+NroDoc+','
   XsNroRef = NroDoc
   SELE RMOV
   LsLlave = XcTipMov+XsCodMov+XsNroDoc
   j = 0
   SEEK LsLLave
   SCAN WHILE TipMov+CodMov+NroDoc = LsLlave FOR CanDes>0
      j = j + 1
   ENDSCAN
   IF i+j > CIMAXELE    && Sobrepaso el limite
      GsMsgErr = [A partir de la Guia ]+AUXI->NroDoc+[ no van a ser Facturados]
      DO lib_merr WITH 99
      * desmarcamos el resto de las guias *
      SELE AUXI
      REPLACE REST FlgEst WITH []
      EXIT
   ELSE
      * Los Items de la guia son aceptados *
      i = i + j
   ENDIF
   SELE AUXI
   SKIP
ENDDO
**************** FIN DEL CONTROL DE ITEMS POR FACTURA *****************
SELE GUIA
SET ORDER TO VGUI01
SELE RPED
SET ORDER TO RPED02
SELE AUXI
GO TOP
i = 1
SCAN FOR FlgEst = [*]
   XsCodMov = [G]+SUBSTR(NroDoc,2,2)
   XsNroDoc = SUBSTR(NroDoc,4)
   XsGloDoc = XsGloDoc+NroDoc+','
   XsNroRef = NroDoc
   SELE RMOV
   LsLlave = XcTipMov+XsCodMov+XsNroDoc
   SEEK LsLLave
   SCAN WHILE TipMov+CodMov+NroDoc = LsLlave FOR CanDes>0
      AsNroG_R(i) = AUXI->NroDoc
      AsCodMat(i) = CodMat
      =SEEK(AUXI->CodDoc+AUXI->NroDoc,"GUIA")      && Guia de Remision
      =SEEK(AsCodMat(i),"MATG")                && Catalogo de Materiales
      IF SEEK(GUIA->NroPed+AsCodMat(i),"RPED")   && Materiales por Pedido
         AsDesMat(i) = RPED->DesMat
      ELSE
         AsDesMat(i) = IIF(EMPTY(RMOV->DesMat),MATG->DesMat,RMOV->DesMat)
      ENDIF
      AsUndVta(i) = RMOV->UndVta
      * Definimos la moneda y el precio unitario *
      IF !EMPTY(GUIA->NroPed) .AND. SEEK(GUIA->NroPed,"VPED")
         IF XiCodMon = VPED->CodMon
            *CFGADMIGV
            AfPreUni(i) = RPED->PreUni
            IF _CODDOC=[BOLE]
               AfPreUni(i) = ROUND(RPED->PreUni*(1+XfPorIgv/100),3)
            ENDIF
            AnD1    (i) = RPED->D1
            AnD2    (i) = RPED->D2
            AnD3    (i) = RPED->D3
         ELSE
            IF XiCodMon = 1
               AfPreUni(i) = ROUND(RPED->PreUni*XfTpoCmb,2)
               IF _CODDOC=[BOLE]
                  AfPreUni(i) = ROUND(RPED->PreUni*(1+XfPorIgv/100),3)
               ENDIF
            ELSE
               IF XfTpoCmb<>0
                  AfPreUni(i) = ROUND(RPED->PreUni/XfTpoCmb,2)
                  IF _CODDOC=[BOLE]
                     AfPreUni(i) = ROUND(RPED->PreUni*(1+XfPorIgv/100),3)
                  ENDIF
               ELSE
                  AfPreUni(i) = RPED->PreUni
                  IF _CODDOC=[BOLE]
                     AfPreUni(i) = ROUND(RPED->PreUni*(1+XfPorIgv/100),3)
                  ENDIF
                  AnD1    (i) = RPED->D1
                  AnD2    (i) = RPED->D2
                  AnD3    (i) = RPED->D3
               ENDIF
            ENDIF
         ENDIF
      ELSE
          AnD1    (i) = RMOV->D1
          AnD2    (i) = RMOV->D2
          AnD3    (i) = RMOV->D3
        ** * * * * * * *
         IF XiCodMon = 1
            IF EMPTY(RMOV->PREUNI)
               AfPreUni(i) = IIF(MATG->CodMon=1,MATG->PreVe1,ROUND(MATG->PreVe1*XfTpoCmb,2))
            ELSE
               AfPreUni(i) = RMOV->PREUNI
            ENDIF
            IF _CODDOC=[BOLE]
            AfPreUni(i) = ROUND(AfPreUni(i)*(1+XfPorIgv/100),3)
            ENDIF
         ELSE
            IF XfTpoCmb<>0
               IF EMPTY(RMOV->PREUNI)
                  AfPreUni(i) = IIF(MATG->CodMon=2,MATG->Preve1,ROUND(MATG->PreVe1/XfTpoCmb,2))
               ELSE
                  AfPreUni(i) = RMOV->PREUNI
               ENDIF
               IF _CODDOC=[BOLE]
                  AfPreUni(i) = ROUND(AfPreUni(i)*(1+XfPorIgv/100),3)
               ENDIF
            ELSE
               IF EMPTY(RMOV->PREUNI)
                  AfPreUni(i) = MATG->Preve1
               ELSE
                  AfPreUni(i) = RMOV->PREUNI
               ENDIF
               IF _CODDOC=[BOLE]
                  AfPreUni(i) = ROUND(AfPreUni(i)*(1+XfPorIgv/100),3)
               ENDIF
            ENDIF
         ENDIF
        ** * * * * * * *
      ENDIF
      AfCanFac(i) = CanDes
      AfFacEqu(i) = Factor
      AfImpLin(i) = ROUND(AfCanFac(i)*AfPreUni(i)*(1-AnD1(i)/100)*(1-AnD2(i)/100)*(1-AnD3(i)/100),2)
      i = i + 1
   ENDSCAN
ENDSCAN
GiTotItm = i - 1
XsGloDoc = LEFT(XsGloDoc,LEN(GDOC->GloDoc))
DO xRegenera

RETURN
************************************************************************ FIN *
* Objeto : Carga el Arreglo
******************************************************************************
PROCEDURE xBiniv2c

** Verificamos si el Pedido tiene G/R SIN FACTURAR **
SELE AUXI
ZAP
SELE VPED
SEEK XsNroPed
SELE GUIA
SET ORDER TO VGUI02
SEEK XsNroPed
SCAN WHILE NroPed=XsNroPed FOR FlgEst = [E] .AND. CodDoc=[G/R]
   SELE AUXI
   APPEND BLANK
   REPLACE CodDoc WITH GUIA->CodDoc
   REPLACE NroDoc WITH GUIA->NroDoc
   REPLACE FchDoc WITH GUIA->FchDoc
   REPLACE FlgEst WITH [*]
   SELE GUIA
ENDSCAN
SET ORDER TO VGUI01
* Veamos si tiene G/R *
SELE AUXI
IF RECCOUNT() = 0
   ** SOLO SE PUEDE FACTURAR EL PEDIDO SI NO TIENE GUIAS EMITIDAS **
   ** ES DECIR : O TODO O NADA (PITO) **
   OK = .T.
   SELE GUIA
   SET ORDER TO VGUI02
   SEEK XsNroPed
   SCAN WHILE NroPed=XsNroPed FOR FlgEst # [A] .AND. CodDoc=[G/R]
      IF FlgEst # [E]   && Facturado o que se yo
         OK = .F.
         EXIT
      ENDIF
   ENDSCAN
   IF !OK
      GsMsgErr = [ Pedido ya ha tenido G/R ]
      DO lib_merr WITH 99
      GiTotItm = 0
      RETURN
   ENDIF
   * Contemos si los items del pedido sobrepasan los items de la factura *
   PRIVATE i
   i = 0
   SELE RPED
   SEEK XsNroPed
   SCAN WHILE NroDoc = XsNroPed
      i = i + 1
   ENDSCAN
   IF i > CIMAXELE
      GsMsgErr = [ Los Items del Pedido sobrepasan el limite de la Factura ]
      DO lib_merr WITH 99
      GiTotItm = 0
      RETURN
   ENDIF
   * cargamos los datos del Pedido *
   i = 1
   SELE RPED
   SEEK XsNroPed
   SCAN WHILE NroDoc = XsNroPed
      AsNroG_R(i) = []
      AsCodMat(i) = CodMat
      AsDesMat(i) = DesMat
      AsUndVta(i) = UndVta
      * Definimos la moneda y el precio unitario *
      IF XiCodMon = VPED->CodMon
         AfPreUni(i) = RPED->PreUni
         AnD1    (i) = RPED->D1
         AnD2    (i) = RPED->D2
         AnD3    (i) = RPED->D3
      ELSE
         IF XiCodMon = 1
            AfPreUni(i) = ROUND(RPED->PreUni*XfTpoCmb,2)
         ELSE
            AfPreUni(i) = ROUND(RPED->PreUni/XfTpoCmb,2)
         ENDIF
      ENDIF
      IF _CODDOC = [BOLE]
         AfPreUni(i) = ROUND(AfPreUni(i)*(1+XfPorIgv/100),3)
      ENDIF
      AnD1    (i) = RPED->D1
      AnD2    (i) = RPED->D2
      AnD3    (i) = RPED->D3
      AfCanFac(i) = CanPed
      AfFacEqu(i) = FacEqu
      AfImpLin(i) = ROUND(AfCanFac(i)*AfPreUni(i)*(1-AnD1(i)/100)*(1-AnD2(i)/100)*(1-AnD3(i)/100),2)
      i = i + 1
   ENDSCAN
   GiTotItm = i - 1
ELSE
   DO xBiniv2b
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Carga el Arreglo
******************************************************************************
PROCEDURE xBiniv2d
SELE AUXI
ZAP
STORE SPACE(LEN(GUIA->NroDoc)) TO AsNroG_R
STORE SPACE(LEN(DETA->CodMat)) TO AsCodMat
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat
STORE SPACE(LEN(DETA->UndVta)) TO AsUndVta
STORE 0                        TO AfPreUni
STORE 0                        TO AnD1,AnD2,AnD3
STORE 0                        TO AfCanFac
STORE 1                        TO AfFacEqu
STORE 0                        TO AfImpLin
GiTotItm = 0

RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE xBline2
PARAMETERS NumEle, NumLin
*@ NumLin,1  SAY AsNroG_R(NumEle) PICT "@R 999-9999999"

@ NumLin,1  SAY AsCodMat(NumEle)
@ NumLin,15 SAY AsDesMat(NumEle) PICT "@S20"
@ 20,2      SAY AsDesMat(NumEle)
@ NumLin,36 SAY AsUndVta(NumEle)
@ NumLin,40 SAY AfCanFac(NumEle) PICT "9999999.99"
@ NumLin,51 SAY AfPreUni(NumEle) PICT "99,999.999"
@ NumLin,62 SAY AnD1    (NumEle) PICT "99.99"
@ NumLin,69 SAY AfImpLin(NumEle) PICT "9999999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
************************************************************************ FIN *
* Objeto : Edita una linea FREE
******************************************************************************
PROCEDURE xBedit2d
PARAMETERS NumEle, NumLin

PRIVATE i
i        = 1
UltTecla = 0
*
LsNroG_R = AsNroG_R(NumEle)
LsCodMat = AsCodMat(NumEle)
LsDesMat = AsDesMat(NumEle)
LsUndVta = AsUndVta(NumEle)
LfPreUni = AfPreUni(NumEle)
LnD1     = AnD1(NumEle)
LnD2     = AnD2(NumEle)
LnD3     = AnD3(NumEle)
LfCanFac = AfCanFac(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LfImpLin = AfImpLin(NumEle)
=SEEK(LsCodMat,"MATG")
XsUndStk = MATG->UndStk
DO WHILE !INLIST(UltTecla,Escape)
   GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         GsMsgKey = "[] [ ] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE MATG
         @ NumLin,01 GET LsCodMat PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba,Abajo)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
            ** SET FILTER TO LEFT(CodMat,3)$[002|004] .OR. LEFT(CodMat,1)=[9]
            GO TOP
            IF !vtabusca("MATG")
              *SET FILTER TO
               LOOP
            ENDIF
            LsCodMat = MATG->CodMat
            SET FILTER TO
         ENDIF
         @ NumLin,01 SAY LsCodMat
         SEEK LsCodMat
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF
         IF LsCodMat = [9]    && Codigo Libre
            * Pedimos datos adicionales
            @ NumLin,15 GET LsDesMat PICT "@S20"
            READ
            UltTecla = LASTKEY()
         ELSE
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
            ** Definimos Precio Unitario *
            IF XiCodMon = MATG->CodMon
               LfPreUni = MATG->PREFIVEIGV
            ELSE
               IF XiCodMon = 1   && en soles
                  LfPreUni = ROUND(MATG->PREFIVEIGV*XfTpoCmb,2)
               ELSE
                  IF XfTpoCmb<>0
                     LfPreUni = ROUND(MATG->PREFIVIGV/XfTpoCmb,2)
                  ELSE
                     LfPreUni = MATG->PREFIVIGV
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
    *    IF _CODDOC = [BOLE]
    *       LfPreuni = ROUND(LfPreUni*(1+XfPorIgv/100),3)
    *    ENDIF
         @ NumLin,15 SAY LsDesMat PICT "@S20"
         @ NumLin,36 SAY LsUndVta
         @ NumLin,51 SAY LfPreUni PICT "99,999.999"
         @ 20    ,2  SAY LsDesMat
      CASE i = 2 .AND. !(LsCodMat=[9])
         SELE UVTA
         @ NumLin,36 GET LsUndVta
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
         ENDIF
         @ NumLin,36 SAY LsUndVta
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

      CASE i = 2 .AND. LsCodMat=[9]
         SELE TABL
         XsTabla = [UD]
         @ NumLin,36 GET LsUndVta
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Izquierda,BackTab)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndVta)
            IF !vtabusca("TUND")
               LOOP
            ENDIF
            LsUndVta = LEFT(TABL->Codigo,3)
         ENDIF
         @ NumLin,36 SAY LsUndVta
         LfFacEqu = 1
         SEEK XsTabla+LsUndVta
         IF !FOUND()
            GsMsgErr = [Unidad no definida]
            DO lib_merr WITH 99
            LOOP
         ENDIF

      CASE i = 3
         @ NumLin,40 GET LfCanFac PICT "9999999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()

      CASE i = 4
         @ NumLin,51 GET LfPreUni PICT "99,999.999" RANGE 0,
         @ NumLin,62 GET LnD1     PICT "99.99"
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 4 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Izquierda,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>4,4,i)
ENDDO
IF !INLIST(UltTecla,Escape,Arriba,Abajo)
   LfImpLin = ROUND(LfCanFac*LfPreUni*(1-LnD1/100)*(1-LnD2/100)*(1-LnD3/100),2)
   AsNroG_R(NumEle) = LsNroG_R
   AsCodMat(NumEle) = LsCodMat
   AsDesMat(NumEle) = LsDesMat
   AsUndVta(NumEle) = LsUndVta
   AfPreUni(NumEle) = LfPreUni
   AnD1(    NumEle) = LnD1
   AnD2(    NumEle) = LnD2
   AnD3(    NumEle) = LnD3
   AfCanFac(NumEle) = LfCanFac
   AfFacEqu(NumEle) = LfFacEqu
   AfImpLin(NumEle) = LfImpLin
   DO xRegenera
ENDIF
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE xBborr2d
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1
DO WHILE i <  GiTotItm
   AsNroG_R(i) = AsNroG_R(i+1)
   AsCodMat(i) = AsCodMat(i+1)
   AsDesMat(i) = AsDesMat(i+1)
   AsUndVta(i) = AsUndVta(i+1)
   AfPreUni(i) = AfPreUni(i+1)
   AnD1    (i) = AnD1    (i+1)
   AnD2    (i) = AnD2    (i+1)
   AnD3    (i) = AnD3    (i+1)
   AfCanFac(i) = AfCanFac(i+1)
   AfFacEqu(i) = AfFacEqu(i+1)
   AfImpLin(i) = AfImpLin(i+1)
   i = i + 1
ENDDO
STORE SPACE(LEN(GUIA->NroDoc)) TO AsNroG_R(i)
STORE SPACE(LEN(DETA->CodMat)) TO AsCodMat(i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(DETA->UndVta)) TO AsUndVta(i)
STORE 0                        TO AfPreUni(i)
STORE 0                        TO AnD1(i),AnD2(i),AnD3(i)
STORE 0                        TO AfCanFac(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AfImpLin(i)
GiTotItm = GiTotItm - 1
Estado = .T.

RETURN

************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE xBinse2d
PARAMETERS ElePrv, Estado

PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsNroG_R(i) = AsNroG_R(i-1)
   AsCodMat(i) = AsCodMat(i-1)
   AsDesMat(i) = AsDesMat(i-1)
   AsUndVta(i) = AsUndVta(i-1)
   AfPreUni(i) = AfPreUni(i-1)
   AnD1    (i) = AnD1    (i-1)
   AnD2    (i) = AnD2    (i-1)
   AnD3    (i) = AnD3    (i-1)
   AfCanFac(i) = AfCanFac(i-1)
   AfFacEqu(i) = AfFacEqu(i-1)
   AfImpLin(i) = AfImpLin(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(GUIA->NroDoc)) TO AsNroG_R(i)
STORE SPACE(LEN(DETA->CodMat)) TO AsCodMat(i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(DETA->UndVta)) TO AsUndVta(i)
STORE 0                        TO AfPreUni(i)
STORE 0                        TO AnD1(i),AnD2(i),AnD3(i)
STORE 0                        TO AfCanFac(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AfImpLin(i)
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE xBmove2

SELE DETA
*
PRIVATE  i
i = 1
SEEK XsCodDoc+XsNroDoc
SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroDoc .AND. i<=CIMAXELE
   AsNroG_R(i) = NroRef
   AsCodMat(i) = CodMat
   AsDesMat(i) = DesMat
   AsUndVta(i) = UndVta
   AfPreUni(i) = PreUni
   AnD1(i)     = D1
   AnD2(i)     = D2
   AnD3(i)     = D3
   AfCanFac(i) = CanFac
   AfFacEqu(i) = FacEqu
   AfImpLin(i) = ImpLin
   i = i + 1
ENDSCAN
GiTotItm = i - 1
DO xRegenera

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE xRegenera

PRIVATE j
j = 1
STORE 0 TO XfImpBto,XfImpDto,XfImpIgv,XfImpTot
FOR j = 1 TO GiTotItm
   XfImpTot = XfImpTot + AfImpLin(j)
ENDFOR
XfImpVta =  round( xfImpTot / ( 1 + xfporigv / 100 ) , 2)
XfImpIgv =  XfImpTot - XfImpVta
XfImpBto =  XfImpVta

@ 19,14 SAY XfImpBto PICT "99999,999.99" COLOR SCHEME 7
@ 19,41 SAY XfPorDto PICT "99999,999.99" COLOR SCHEME 7
@ 19,67 SAY XfImpDto PICT "99999,999.99" COLOR SCHEME 7
@ 20,67 SAY XfImpVta PICT "99999,999.99" COLOR SCHEME 7
@ 21,14 SAY XfPorIgv PICT "99999,999.99" COLOR SCHEME 7
@ 21,41 SAY XfImpIgv PICT "99999,999.99" COLOR SCHEME 7
@ 21,67 SAY XfImpTot PICT "99999,999.99" COLOR SCHEME 7

RETURN
************************************************************************ FIN *
* Objeto : Veirifica si el codigo fue registrado
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
* Browse de Seleccion de Guias a Facturar
******************************************************************************
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab1

REPLACE FlgEst WITH IIF(EMPTY(FlgEst),[*],[])
IF FlgEst = [*]
   * Cargamos datos por defecto *
   IF SEEK(AUXI->CodDoc+AUXI->NroDoc,"GUIA")
      XiFmaPgo = GUIA->FmaPgo
      XsNroO_C = GUIA->NroO_C
      XdFchO_C = GUIA->FchO_C
   ENDIF
ENDIF
UNLOCK

RETURN
************************************************************************ FIN *
* Objeto : Emisi¢n de Gu¡a Remisi¢n
******************************************************************************
PROCEDURE xImprime
SAVE SCREEN TO TEMPO
LsLla_I  = GDOC->CodDoc+GDOC->NroDoc
SELE DETA
SEEK LsLla_I
XWHILE = "! EOF() .AND. DETA.CodDoc+DETA.NroDoc = LsLla_I"
xFOR = [GDOC.FLGEST#"A"]
Largo  = 37       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]

IF _CodDoc = [FACT]
   sNomRep = "NEWFACT1"
ELSE
   sNomRep = "NEWFACT2"
ENDIF

DO admprint WITH "REPORTS"
SELE GDOC
RESTORE SCREEN FROM TEMPO
RETURN


************************************************************************ FIN *
* Objeto : Emisi¢n de Gu¡a Remisi¢n
******************************************************************************
PROCEDURE xImprbol
SAVE SCREEN TO XTemp
*** Configuraci¢n de las Impresiones ***
DO ADMPRINT
UltTecla = LastKey()
IF UltTecla = Escape
   RETURN
ENDIF
IniImp   = _Prn2
Largo    = 33
LinFin   = Largo - 2
Ancho    = 95
SET DEVICE TO PRINTER
SET MARGIN TO 0
PRINTJOB
NumPag   = 0
LsLla_I  = GDOC->CodDoc+GDOC->NroDoc
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ENDIF
@ 0,0  SAY IniImp
@ 10,08 SAY GDOC->FchDoc
@ 11,09 SAY TRIM(GDOC->NomCli)+" ("+GDOC->CodCli+")"
@ 13,09 SAY GDOC->DirCli
@ 14,72 SAY GDOC->NroDoc
@ 17,18 SAY []
NumLin   = PROW()
NumPag = NumPag + 1
SELECT DETA
SEEK LsLla_I
IF GDOC->FlgEst <> "A"
   XfNro1 = 0
   DO WHILE  ! EOF() .AND. CodDoc+NroDoc = LsLla_I
      SELECT DETA
      IF LEFT(CodMat,1)$GsCodMat
         XfNro1 = XfNro1 + 1
         IF XfNro1 = 1
            LfPreU = PreUni*(1+Gdoc.PorIgv/100)
            LfPreL = ImpLin*(1+Gdoc.PorIgv/100)
            @ NumLin ,03  SAY CanFac    PICT "@Z 9999"
            @ NumLin ,10  SAY CodMat
            @ NumLin ,25  SAY DesMat    PICT "@S40"
            @ NumLin ,66  SAY LfPreU    PICT "@Z 9999,999.99"
            @ NumLin ,80  SAY LfPreL    PICT "@Z 9999,999.99"
         ELSE
            @ NumLin ,24  SAY DesMat    PICT "@S40"
            XfNro1 = 0
         ENDIF
      ELSE
         LfPreU = PreUni*(1+Gdoc.PorIgv/100)
         LfPreL = ImpLin*(1+Gdoc.PorIgv/100)
         NumCol = 0
         @ NumLin ,03  SAY CanFac   PICT "99999"
         @ NumLin ,10  SAY CodMat
         =SEEK(CodMat,"MATG")
         @ NumLin,25   SAY MATG->DesMat PICT "@S40"
         @ NumLin,66   SAY LfPreU    PICT "@Z 9999,999.99"
         @ NumLin,80   SAY LfPreL    PICT "@Z 9999,999.99"
         SELE DETA
      ENDIF
      NumLin   = PROW() + 1
      SKIP
   ENDDO
ELSE
   @ PROW()+1,11 SAY "     #    #     # #     # #          #    ######  #######  "
   @ PROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
   @ PROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
   @ PROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ENDIF
***** NUEVO CAMPO DE OTROS
LfImpNet = GDOC->ImpTot
LfTotIgv = GDOC->ImpIgv
LfTotDst = GDOC->ImpDto
LETRAS = " "
LETRAS = NUMERO(LfImpNet,2,1)+IIF(GDOC->CodMon=1," NUEVOS SOLES"," DOLARES AMERICANOS")
LETRAS = NUMERO(LfImpNet,2,1)
@ Largo-04,10  SAY Letras
@ Largo-04,76  SAY IIF(GDOC->CodMon=1,"S/.","US$")
@ Largo-04,80  SAY LfImpNet   PICT "@Z 9999,999.99"
ENDPRINTJOB
EJECT PAGE
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
SELECT GDOC
RESTORE SCREEN FROM xTemp
RETURN
*********************************************************************** FIN() *
* Objeto : Desactualiza Pedidos
******************************************************************************
PROCEDURE xDes_Ped

SELE RPED
REPLACE RPED->CanFac WITH RPED->CanFac - DETA->CanFac
IF RPED->CanPed-RPED->CanFac<=0
   REPLACE RPED->FlgFac WITH [C]
ELSE
   IF RPED->CanFac > 0
      REPLACE RPED->FlgFac WITH [P]    && Atencion Parcial
   ELSE
      REPLACE RPED->FlgFac WITH []
   ENDIF
ENDIF
UNLOCK
RETURN
*********************************************************************** FIN() *
* Objeto : Actualiza Pedidos
******************************************************************************
PROCEDURE xAct_Ped

SELE RPED
REPLACE CanFac WITH CanFac + XfCanFac
IF CanPed-CanFac<=0
   REPLACE FlgFac WITH [C]
ELSE
   IF CanFac > 0
      REPLACE FlgFac WITH [P]    && Atencion Parcial
   ELSE
      REPLACE FlgFac WITH []
   ENDIF
ENDIF
UNLOCK
RETURN
*********************************************************************** FIN() *
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
XsCodOpe = [002]
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
* Cuenta de Factura
=SEEK(GDOC->CodDoc,"TDOC")
XiNroItm = 1
XcEliItm = [ ]
XsCodCta = TDOC->CodCta
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
* Cuenta de Impuestos
XcEliItm = [ ]
XsCodCta = [401101]      && Del plan de cuentas
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
XfImport = GDOC->ImpIgv
IF XiCodMon = 1
   XfImpNac = XfImport
   XfImpUsa = XfImport/XfTpoCmb
ELSE
   XfImpUsa = XfImport
   XfImpNac = XfImport*XfTpoCmb
ENDIF
XsGloDoc = []
XsCodDoc = GDOC->CodDoc
XsNroDoc = GDOC->NroDoc
XsNroRef = GDOC->NroDoc
XdFchDoc = {,,}
XdFchVto = {,,}
DO MovbVeri IN vtammovm
* Cuenta 7
=SEEK(GDOC->CodDoc+GDOC->NroDoc,"DETA")
=SEEK(LEFT(DETA->CodMat,LEN(FAMI->CodFam)),"FAMI")
XcEliItm = [ ]
XsCodCta = FAMI->Ctac70

* OJO >> por ahora fijamos la cuenta a usar * (si no te gusta lo cambias)
XsCodCta = [701101]
* * * * * * * * * * *

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
XfImport = GDOC->ImpBto-GDOC->ImpDto &&-GDOC->ImpInt-GDOC->ImpAdm
IF XiCodMon = 1
   XfImpNac = XfImport
   XfImpUsa = XfImport/XfTpoCmb
ELSE
   XfImpUsa = XfImport
   XfImpNac = XfImport*XfTpoCmb
ENDIF
XsGloDoc = []
XsCodDoc = GDOC->CodDoc
XsNroDoc = GDOC->NroDoc
XsNroRef = GDOC->NroDoc
XdFchDoc = {,,}
XdFchVto = {,,}
DO MovbVeri IN vtammovm
* * * *
SELE Head
*cResp = []
*cResp = AVISO(10,[>>>>>>>>>>>>************<<<<<<<<<<<<<<],;
*              [>>>>  coloque formato de VOUCHER en su impresora  <<<<],[Presione barra espaciadora para continuar],;
*              3,[ ],0,.T.,.F.,.T.)
*DO ImprVouc IN VTAMMOVM
DO Close_File

RETURN
*********************************************************************** FIN() *
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
* Objeto : Des-Actualiza Contabilidad
******************************************************************************
PROCEDURE xDes_Ctb

* Abrimos Base de Datos *
PRIVATE _MES,_ANO,DirCtb
_MES = VAL(GDOC->NroMes)
_ANO = YEAR(GDOC->FchDoc)
DirCtb = PathDef+"\cia"+GsCodCia+"\C"+STR(_ANO,4)+"\"
IF !Open_File()
   GsMsgErr = [NO se pudo anular el asiento contable]
   DO lib_merr WITH 99
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
SELECT Item
XsLlave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK XsLlave
OK = .T.
DO WHILE ! EOF() .AND.  ok .AND. (NroMes + CodOpe + NroAst) = XsLlave
   SELECT Item
   IF Rlock()
      IF ! XsCodOpe = "9"
         DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
      ELSE
         DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
      ENDIF
      DELETE
      UNLOCK
   ELSE
      OK = .f.
   ENDIF
   SKIP
ENDDO
SELECT Head
IF Ok
   IF FlgEst = "A"
      DELETE
   ELSE
      REPLACE FlgEst WITH "A"    && Marca de anulado
      GsMsgErr = "Colocar formato de Voucher"
      DO LIB_MERR WITH 99
      DO ImprVouc IN VTAMMOVM
   ENDIF
ELSE
   GsMsgErr = [NO se pudo anular el asiento contable]
   DO lib_merr WITH 99
ENDIF
DO Close_File

RETURN
************************************************************************* FIN


