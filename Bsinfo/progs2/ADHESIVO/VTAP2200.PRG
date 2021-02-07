*****************************************************************************
* Programa     : vtap2200.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Revisi¢n de Pedidos
* Creacion     : 31/10/94
* Parametros   :
* Actualizaci¢n:
*****************************************************************************
IF FILE("VTACONFG.MEM")
   RESTORE FROM VTACONFG ADDITIVE
ENDIF
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
USE vtarpedi ORDER RPED01  ALIAS RPED
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
USE almtabla ORDER TABL01 ALIAS TABL
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 7
USE almtuvta ORDER UVTA01 ALIAS UVTA
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 9
USE admmtcmb ORDER TCMB01 ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** relaciones a usar **
SELECT VPED
SET RELATION TO GsClfAux+CodCli INTO CLIE
** variables a usar **
** variables de cabecera **
PRIVATE XsNroDoc,XdFchDoc,XsNroO_C,XdFchO_C,XiFmaPgo,XiDiaVto
PRIVATE XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfPorIgv,XfPorDto
PRIVATE XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpNet,XfImpOtr
PRIVATE XsGloDoc,XcFlgEst,LsFmaPgo
PRIVATE XsCodCli,XsNomCli,XsDirCli,XsRucCli
PRIVATE XfTpoCmb
STORE [] TO XsNroDoc,XdFchDoc,XsCodCli,XsNroO_C,XdFchO_C,XiFmaPgo,XiDiaVto
STORE [] TO XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfPorIgv,XfPorDto
STORE [] TO XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpNet,XfImpOtr
STORE [] TO XsGloDoc,XcFlgEst,LsFmaPgo
STORE [] TO XsCodCli,XsNomCli,XsDirCli,XsRucCli
STORE [] TO XfTpoCmb
** Variables del Browse **
PRIVATE AsCodMat,AsUndVta,AfFacEqu,AfPreUni,AfCanPed,AfImpLin,AiNumReg,GiTotItm
PRIVATE AdFchEnt,AiRegDel,GiTotDel
CIMAXELE = 40
DIMENSION AsCodMat(CIMAXELE)
DIMENSION AsDesMat(CIMAXELE)
DIMENSION AsUndVta(CIMAXELE)
DIMENSION AdFchEnt(CIMAXELE)
DIMENSION AfFacEqu(CIMAXELE)
DIMENSION AfPreUni(CIMAXELE)
DIMENSION AcFlgEst(CIMAXELE)
DIMENSION AfCanPed(CIMAXELE)
DIMENSION AdFchEnt(CIMAXELE)
DIMENSION AfImpLin(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)
DIMENSION AiRegDel(CIMAXELE)
GiTotItm = 0
GiTotDel = 0
** control correlativo multiusuario **
PRIVATE m.NroDoc,XsCodDoc
m.NroDoc = []
XsCodDoc = [PEDI]
** Logica Principal **
SELE VPED
GOTO BOTTOM
DO LIB_MTEC WITH 3
UltTecla = 0
DO EDITA WITH [],[xPoner],[],[],[xListar],;
              [],[],'R',[]
CLOSE DATA
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta
CLEAR
@  0,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  1,0  SAY "³ Pedido No. :                                           Fecha :               ³"
@  2,0  SAY "³ Cliente    :                                             RUC :               ³"
@  3,0  SAY "³ Nombre     :                                                                 ³"
@  4,0  SAY "³ Direcci¢n  :                                                                 ³"
@  5,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  6,0  SAY "³ Tipo Solicitud :                     ³Condic. de Venta:                      ³"
@  7,0  SAY "³    O/C Cliente :                     ³  Forma de Pago :                      ³"
@  8,0  SAY "³Fecha de la O/C :                     ³ Dias de Vencto.:                      ³"
@  9,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 10,0  SAY "³     Moneda :                           Tipo de Cambio :                      ³"
@ 11,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 12,0  SAY "³                                                                              ³"
@ 13,0  SAY "³                                                                              ³"
@ 14,0  SAY "³                                                                              ³"
@ 15,0  SAY "³                                                                              ³"
@ 16,0  SAY "³                                                                              ³"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "³                                                                              ³"
@ 19,0  SAY "³                                                                              ³"
@ 20,0  SAY "³                                                                              ³"
@ 21,0  SAY "³                                                                              ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
*
Titulo = [ >>> NOTA DE PEDIDO <<< ]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
*           1         2         3         4         5         6         7        8
@ 11,1  SAY "C¢digo"                           COLOR SCHEME 7
@ 11,08 SAY "      Descripci¢n             "   COLOR SCHEME 7
@ 11,39 SAY "Und"                              COLOR SCHEME 7
@ 11,43 SAY " Cantidad "                       COLOR SCHEME 7
@ 11,54 SAY "Ent"                              COLOR SCHEME 7
@ 11,58 SAY "P.Unitario"                       COLOR SCHEME 7
@ 11,69 SAY "   Total  "                       COLOR SCHEME 7
RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave

SELE VPED
IF CHRVAL#"C"
   XsNroDoc = VPED->NroDoc
ELSE
   * buscamos correlativo
   IF !SEEK(XsCodDoc,"DOCM")
      WAIT "No existe correlativo" NOWAIT WINDOW
      UltTecla = Escape
      RETURN
   ENDIF
   XsNroDoc = SPACE(LEN(VPED->NroDoc))
   XsNroDoc = PADL(ALLTRIM(STR(DOCM->NroDoc)),LEN(XsNroDoc),'0')
   m.NroDoc = XsNroDoc
   @ 1,15 SAY XsNroDoc PICT "@!"
   UltTecla = Enter
   RETURN
ENDIF
*
GsMsgKey = "[Esc] Salir   [F8] Consulta  [ENter] Aceptar"
DO lib_mtec WITH 99
SELE VPED
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape,Enter)
   @ 1,15 GET XsNroDoc PICT "@!"
   READ
   UltTecla = LASTKEY()
   IF INLIST(UltTecla,Escape)
      LOOP
   ENDIF
   IF UltTecla = F8
      IF ! vtabusca("0015")
         UltTecla = 0
         LOOP
      ENDIF
      XsNroDoc = VPED->NroDoc
      UltTecla = Enter
   ENDIF
   @ 1,15 SAY XsNroDoc
   IF EMPTY(XsNroDoc)
      UltTecla = 0
      LOOP
   ENDIF
ENDDO
SEEK XsNroDoc

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xListar

UltTecla = 0
SAVE SCREEN
DO xLlave
IF UltTecla = Escape
   RESTORE SCREEN
   RETURN
ENDIF
DO xMover
DO xPoner
DO xTomar
RESTORE SCREEN
DO LIB_MTEC WITH 3

RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

SELE VPED
IF EOF()
   GsMsgErr = [Dato no Registrado]
   DO LIB_merr WITH 99
   RETURN
ENDIF
LlCrear = .F.
IF FlgEst = 'A'
   GsMsgErr = [** Registro Anulado **]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = 'c'
   GsMsgErr = [** Pedido Cerrado **]
   DO lib_merr WITH 99
ENDIF
IF FlgEst = 'C'
   GsMsgErr = [ Pedido Completo ]
   DO lib_merr WITH 99
ENDIF
SELE RPED
SEEK VPED->NroDoc
SCAN WHILE NroDoc = VPED->NroDoc
   IF FlgEst = 'P'
      GsMsgErr = [ Pedido Parcialmente Atendido ]
      DO lib_merr WITH 99
      EXIT
   ENDIF
ENDSCAN
DO xBrowse
SELE VPED

RETURN
************************************************************************ FIN()
* Cargar variables
******************************************************************************
PROCEDURE xMover

SELE VPED
** cargamos arreglos **
DO xBmove
SELE VPED

RETURN
************************************************************************ FIN()
* Pintar Informacion en Pantalla
******************************************************************************
PROCEDURE xPoner

@  1,15 SAY NroDoc
@  1,65 SAY FchDoc
@  2,15 SAY CodCli
@  3,15 SAY NomCli
@  4,15 SAY DirCli
@  2,65 SAY RucCli
@  6,19 SAY FmaSol PICT "@!S20"
@  7,19 SAY NroO_C PICT "@!"
@  8,19 SAY FchO_C
@  6,58 SAY vta_pgo(FmaPgo)
@  7,58 SAY CndPgo PICT "@!S20"
@  8,58 SAY DiaVto PICT "999"
@ 10,15 SAY IIF(CodMon=1,'S/.','US$')
@ 10,58 SAY XfTpoCmb PICT "9999.99"
SELE RPED
SEEK VPED->NroDoc
NumLin = 12
@ 12,1 CLEAR TO 21,78
IF VPED->FlgEst<>"A"
   SCAN WHILE NroDoc=VPED->NroDoc .AND. NumLin <= 21
      IF EMPTY(FchEnt)
         LsFchEnt = SPACE(3)
      ELSE
         LsFchEnt = SUBSTR("EFMAmJjaSOND",MONTH(FchEnt),1)+;
                    TRANSF(DAY(FchEnt),"@L ##")
      ENDIF
      @ NumLin,1  SAY CodMat
      @ NumLin,08 SAY DesMat PICT "@S30"
      @ NumLin,39 SAY UndVta
      @ NumLin,43 SAY FlgEst
      @ NumLin,44 SAY CanPed PICT "99,999.99"
      @ NumLin,54 SAY LsFchEnt
      @ NumLin,58 SAY PreUni PICT "999,999.99"
      @ NumLin,69 SAY ImpLin PICT "9999999.99"
      NumLin = NumLin + 1
   ENDSCAN
ELSE
   @ Numlin ,02 SAY []
   @ ROW()  ,02 SAY "          #      #    #    #   #    #          #      #####     ######  "
   @ ROW()+1,02 SAY "        #   #    # #  #    #   #    #        #   #    #    #    #    #  "
   @ ROW()+1,02 SAY "        #####    #  # #    #   #    #        #####    #    #    #    #  "
   @ ROW()+1,02 SAY "        #   #    #    #    #####    #####    #   #    #####     ######  "
ENDIF
* *
SELE VPED

RETURN
************************************************************************ FIN()
* Browse de Datos
****************************************************************************
PROCEDURE xBrowse

**
EscLin   = "xBline"
EdiLin   = "xBedit"
BrrLin   = "xBborr"
InsLin   = "xBinse"
PrgFin   = []
*
Yo       = 11
Xo       = 0
Largo    = 12
Ancho    = 80
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
GsMsgKey = "[PgUp] [PgDw] [Home] [End] Mover     [Esc] Salir"
DO lib_mtec WITH 99
DO aBrowse
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE xBline
PARAMETERS NumEle, NumLin
IF EMPTY(AdFchEnt(NumEle))
   LsFchEnt = SPACE(3)
ELSE
   LsFchEnt = SUBSTR("EFMAmJjaSOND",MONTH(AdFchEnt(NumEle)),1)+;
              TRANSF(DAY(AdFchEnt(NumEle)),"@L ##")
ENDIF
@ NumLin,1  SAY TRIM(AsCodMat(NumEle))
@ NumLin,08 SAY AsDesMat(NumEle) PICT "@S30"
@ NumLin,39 SAY AsUndVta(NumEle)
@ NumLin,43 SAY AcFlgEst(NumEle)
@ NumLin,44 SAY AfCanPed(NumEle) PICT "99,999.99"
@ NumLin,54 SAY LsFchEnt
@ NumLin,58 SAY AfPreUni(NumEle) PICT "999,999.99"
@ NumLin,69 SAY AfImpLin(NumEle) PICT "9999999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit
PARAMETERS NumEle, NumLin
* No se puede editar
UltTecla = Arriba
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE xBborr
PARAMETERS ElePrv, Estado

Estado = .F.

RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE XBinse
PARAMETERS ElePrv, Estado

Estado = .F.
RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE xBmove

SELE RPED
*
PRIVATE  i
i = 1
SEEK XsNroDoc
SCAN WHILE NroDoc=XsNroDoc .AND. i<=CIMAXELE
   =SEEK(RPED->CodMat,"MATG")
   AsCodMat(i) = CodMat
   AdFchEnt(i) = FchEnt
   AsDesMat(i) = DesMat
   AsUndVta(i) = UndVta
   AfFacEqu(i) = FacEqu
   AfPreUni(i) = PreUni
   AcFlgEst(i) = FlgEst
   AfCanPed(i) = CanPed
   AfImpLin(i) = ImpLin
   AiNumReg(i) = RECNO()
   i = i + 1
ENDSCAN
GiTotItm = i - 1

RETURN
************************************************************************ FIN *
