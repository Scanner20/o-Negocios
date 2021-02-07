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
XiCodMon = 2
** Variables del Browse **
PRIVATE AsCodMat,AsUndVta,AfFacEqu,AfPreUni,AfCanPed,AfImpLin,AiNumReg,GiTotItm
PRIVATE AnD1,AnD2,AnD3
PRIVATE AdFchEnt,AiRegDel,GiTotDel
CIMAXELE = 40
**************************************
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
DIMENSION AnD1    (CIMAXELE)
DIMENSION AnD2    (CIMAXELE)
DIMENSION AnD3    (CIMAXELE)
**************************************
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
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],[Ximprime],;
              [],[],'CMAR',[]
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
@ 11,0  SAY "³                                                                              ³"
@ 12,0  SAY "³                                                                              ³"
            *          1         2         3         4         5         6         7         8
            *012345678901234567890123456789012345678901234567890123456789012345678901234567890
            * ############# ###############  ### #9,999.999 ### 99,999.99 ## ## ## 999999.99
@ 13,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³"
@ 14,0  SAY "³                                                                              ³"
@ 15,0  SAY "³                                                                              ³"
@ 16,0  SAY "³                                                                              ³"
@ 17,0  SAY "³                                                                              ³"
@ 18,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 19,0  SAY "³Venta Bruta:                   % Dscto:                Descuento:             ³"
@ 20,0  SAY "³  Intereses:                Gto. Admin:                Valor Vta:             ³"
@ 21,0  SAY "³      % IGV:                       IGV:               Precio Vta:             ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
*

@ 19,1 FILL TO 21,78 COLOR SCHEME 7
Titulo = [ >>> NOTA DE PEDIDO <<< ]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
*           1         2         3         4         5         6         7        8
@ 13,1  SAY PADC("C¢digo",13)                  COLOR SCHEME 7
@ 13,15 SAY PADC("Descripci¢n",12)             COLOR SCHEME 7
@ 13,29 SAY "Und"                              COLOR SCHEME 7
@ 13,34 SAY PADC("Cantidad",9)                  COLOR SCHEME 7
@ 13,44 SAY "Ent"                              COLOR SCHEME 7
@ 13,48 SAY PADC("P. Unit",9)                  COLOR SCHEME 7
@ 13,58 SAY "%dsc1"                            COLOR SCHEME 7
@ 13,64 SAY "%dsc2"                            COLOR SCHEME 7
@ 13,70 SAY PADC("Total",9)                    COLOR SCHEME 7
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
      IF ! vtabusca("0002")
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
PROCEDURE xTomar

SELE VPED
LlCrear = .T.
IF (&RegVal.)
   IF FlgEst = 'A'
      UltTecla = Escape
      GsMsgErr = [** Registro Anulado **]
      DO lib_merr WITH 99
      UNLOCK
      RETURN
   ENDIF
   IF FlgEst = 'c'   && Manual
      GsMsgErr = [** Pedido Cerrado **]
      DO lib_merr WITH 99
      UltTecla = Escape
      RETURN
   ENDIF
   IF FlgEst = 'C'   && Automatico
      GsMsgErr = [ Pedido Completo ]
      DO lib_merr WITH 99
      UltTecla = Escape
      RETURN
   ENDIF
   IF FlgEst = 'P'
      GsMsgErr = [ Pedido Parcialmente Atendido ]
      DO lib_merr WITH 99
   ENDIF
   IF ! RLOCK()
      RETURN
   ENDIF
   DO xMover
   cTecla = [Escape,F10,CtrlW]
   LlCrear = .F.
ELSE
   DO xInvar
   cTecla = [Escape]
ENDIF
*
@  1,65 GET XdFchDoc
@  2,15 GET XsCodCli PICT "@!"
@  3,15 GET XsNomCli PICT "@!"
@  4,15 GET XsDirCli PICT "@!"
@  2,65 GET XsRucCli PICT "@!"
@  6,19 GET XsFmaSol PICT "@!S20"
@  7,19 GET XsNroO_C PICT "@!"
@  8,19 GET XdFchO_C
@  7,58 GET XsCndPgo PICT "@S20"
@  8,58 GET XiDiaVto PICT "999"
@ 10,58 GET XfTpoCmb PICT "999.999"
@ 11,1  EDIT XsGloDoc SIZE 2,78 COLOR SCHEME 7 DISABLE
CLEAR GETS
UltTecla = 0
PRIVATE i
i = 1
DO WHILE ! INLIST(UltTecla,&cTecla.)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1
         @ 1,65 GET XdFchDoc
         READ
         UltTecla = LASTKEY()
         @ 1,65 SAY XdFchDoc
      CASE i = 2 &&.AND. LlCrear
         GsMsgErr = "[Esc] Cancelar   [Enter] Aceptar   [F8] Consulta   [] Anterior"
         DO lib_mtec WITH 99
         SELE CLIE
         @ 2,15 GET XsCodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(XsCodCli) .OR. UltTecla = F8
            IF ! vtabusca("CLIE")
               LOOP
            ENDIF
            XsCodCli = PADR(CODAUX,LEN(VPED->CODCLI))
         ENDIF
         @ 2,15 SAY XsCodCli PICT "@!"
         IF XsCodCli = [9999]    && Codigo Libre
            @  3,15 GET XsNomCli PICT "@!"
            @  4,15 GET XsDirCli PICT "@!"
            @  2,65 GET XsRucCli PICT "@!"
            READ
            UltTecla = LASTKEY()
         ELSE
            SEEK GsClfAux+XsCodCli
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            XsCodCli = CLIE->CodAux
            XsNomCli = CLIE->NomAux
            XsDirCli = CLIE->DirAux
            XsRucCli = CLIE->RucAux
         ENDIF
         @  3,15 SAY XsNomCli PICT "@!"
         @  4,15 SAY XsDirCli PICT "@!"
         @  2,65 SAY XsRucCli PICT "@!"

      CASE i = 3
         @  6,19 GET XsFmaSol PICT "@!S20"
         READ
         UltTecla = LASTKEY()
         @  6,19 SAY XsFmaSol PICT "@!S20"
      CASE i = 4
         @  7,19 GET XsNroO_C PICT "@!"
         READ
         UltTecla = LASTKEY()
         @  7,19 SAY XsNroO_C PICT "@!"
      CASE i = 5
         @  8,19 GET XdFchO_C
         READ
         UltTecla = LASTKEY()
         @  8,19 SAY XdFchO_C
      CASE i = 6
         DO LIB_MTEC WITH 16
         VecOpc(1)="Contado"
         VecOpc(2)="Credito"
         VecOpc(3)="Consignacion"
         XiFmaPgo= Elige(XiFmaPgo,6,58,3)
      CASE i = 7
         SELE TABL
         XsTabla = "01"
         @  7,58 GET XsCndPgo PICT "@!S20"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF !vtabusca("TABL")
               UltTecla = 0
               LOOP
            ENDIF
            XsCndPgo = TABL->Nombre
            XiDiaVto = VAL(SUBSTR(TABL->CODIGO,2,2))
         ENDIF
         @ 7,58 SAY XsCndPgo PICT "@S20"
      CASE i = 8
         @  8,58 GET XiDiaVto PICT "999"
         READ
         UltTecla = LASTKEY()
         @  8,58 SAY XiDiaVto PICT "999"
      CASE i = 9
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,15,2)
      CASE i = 10
         IF SEEK(DTOS(XdFchDoc),"TCMB")
            XfTpoCmb = TCMB->OfiVta
         ENDIF
         @ 10,58 GET XfTpoCmb PICT "999.999" VALID XfTpoCmb>0
         READ
         UltTecla = LASTKEY()
      CASE i = 11
         GsMsgKey = "[Shift+Tab] Anterior   [Tab] Siguiente   [Esc] Cancelar"
         DO lib_mtec WITH 99
         @ 11,1  EDIT XsGloDoc SIZE 2,78 COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
         @ 11,1  EDIT XsGloDoc SIZE 2,78 DISABLE
         IF INLIST(UltTecla,BackTab,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
      CASE i = 12
         DO xBrowse
      CASE i = 13
         ** Parte final del Calculo **
         @ 19,41 GET XfPorDto PICT "99999,999.99" VALID(XfPorDto>=0)
         READ
         UltTecla = LASTKEY()
         DO xRegenera
      CASE i = 14
         ** Parte final del Calculo **
         @ 20,14 GET XfImpInt PICT "99999,999.99" VALID(XfImpInt>=0)
         READ
         UltTecla = LASTKEY()
         DO xRegenera
      CASE i = 15
         ** Parte final del Calculo **
         @ 20,41 GET XfImpAdm PICT "99999,999.99" VALID(XfImpAdm>=0)
         READ
         UltTecla = LASTKEY()
         DO xRegenera
      CASE i = 16
         cResp = [N]
         cResp = aviso(12,[Datos Correctos (S-N)?],[],[],3,[SN],0,.F.,.F.,.T.)
         IF cResp = [N]
            i = 13
            LOOP
         ENDIF
         UltTecla = Enter
   ENDCASE
   IF UltTecla = F10 .AND. I < 12 .AND. I > 2
      I = 12
      LOOP
   ENDIF
   IF UltTecla = F10 .AND. I > 12
      I = 16
      LOOP
   ENDIF
   IF i = 16 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>16,16,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
ENDIF
SELE VPED
UNLOCK ALL
DO LIB_MTEC WITH 3

RETURN
************************************************************************ FIN()
* Cargar variables
******************************************************************************
PROCEDURE xMover

SELE VPED
XsNroDoc = NroDoc
XdFchDoc = FchDoc
XsCodCli = CodCli
XsNomCli = NomCli
XsDirCli = DirCli
XsRucCli = RucCli
XsNroO_C = NroO_C
XdFchO_C = FchO_C
XiFmaPgo = FmaPgo
XsFmaSol = FmaSol
XiDiaVto = DiaVto
XsCndPgo = CndPgo
XsCodVen = CodVen
XiCodMon = CodMon
XfTpoCmb = TpoCmb
XfPorIgv = PorIgv
XfPorDto = PorDto
XfImpBto = ImpBto
XfImpDto = ImpDto
XfImpInt = ImpInt
XfImpAdm = ImpAdm
XfImpIgv = ImpIgv
XfImpNet = ImpNet
XsGloDoc = GloDoc
XcFlgEst = FlgEst
** cargamos arreglos **
DO xBmove
SELE VPED

RETURN
************************************************************************ FIN()
* Inicializamos Variables
******************************************************************************
PROCEDURE xInvar

XdFchDoc = GdFecha
XsCodCli = SPACE(LEN(CodCli))
XsNomCli = SPACE(LEN(NomCli))
XsDirCli = SPACE(LEN(DirCli))
XsRucCli = SPACE(LEN(RucCli))
XsNroO_C = SPACE(LEN(NroO_C))
XdFchO_C = {,,}
XiFmaPgo = 1
LsFmaPgo = SPACE(2)
XsFmaSol = SPACE(LEN(FmaSol))
XiDiaVto = 0
XsCndPgo = SPACE(LEN(CndPgo))
XsCodVen = SPACE(LEN(CodVen))
XiCodMon = 2
XfTpoCmb = 0
XfPorIgv = CFGADMIGV
XfPorDto = 0
XfImpBto = 0
XfImpDto = 0
XfImpInt = 0
XfImpAdm = 0
XfImpIgv = 0
XfImpNet = 0
XsGloDoc = []
XcFlgEst = [E]    && Emitido, Cerrado, Anulado
** Variables del Browse **
STORE SPACE(LEN(RPED->CodMat)) TO AsCodMat
STORE 0 TO AnD1,AnD2,AnD3
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat
STORE SPACE(LEN(RPED->UndVta)) TO AsUndVta
STORE {,,}                     TO AdFchEnt
STORE 1                        TO AfFacEqu
STORE 0                        TO AfPreUni
STORE [ ]                      TO AcFlgEst
STORE 0                        TO AfCanPed
STORE 0                        TO AfImpLin
STORE 0                        TO AiNumReg
STORE 0                        TO AiRegDel
GiTotItm = 0
GiTotDel = 0

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
@ 10,58 SAY XfTpoCmb PICT "999.999"
@ 11,1  EDIT GloDoc SIZE 2,78 DISABLE
SELE RPED
SEEK VPED->NroDoc
NumLin = 14
@ 14,1 CLEAR TO 17,78
IF VPED->FlgEst<>"A"

*          1         2         3         4         5         6         7         8
*01234567890123456789012345678901234567890123456789012345678901234567890123456789
* 1234567123456789012345678901234567890 123 X9,999.999 123 999,999.99 9999999.99
   SCAN WHILE NroDoc=VPED->NroDoc .AND. NumLin <= 17
      IF EMPTY(FchEnt)
         LsFchEnt = SPACE(3)
      ELSE
         LsFchEnt = SUBSTR("EFMAmJjaSOND",MONTH(FchEnt),1)+;
                    TRANSF(DAY(FchEnt),"@L ##")
      ENDIF
      @ NumLin,1  SAY CodMat
      @ NumLin,15 SAY DesMat PICT "@S12"

      @ NumLin,29 SAY UndVta
      @ NumLin,33 SAY FlgEst
      @ NumLin,34 SAY CanPed PICT "99,999.99"
      @ NumLin,44 SAY LsFchEnt
      @ NumLin,48 SAY PreUni PICT "9,999.999"
      @ NumLin,58 SAY d1 PICT "99.99"
      @ NumLin,64 SAY d2 PICT "99.99"
      @ NumLin,70 SAY ImpLin PICT "999999.99"
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
@ 19,14 SAY ImpBto   PICT "99999,999.99" COLOR SCHEME 7
@ 19,41 SAY PorDto   PICT "99999,999.99" COLOR SCHEME 7
@ 19,67 SAY ImpDto   PICT "99999,999.99" COLOR SCHEME 7
@ 20,14 SAY ImpInt   PICT "99999,999.99" COLOR SCHEME 7
@ 20,41 SAY ImpAdm   PICT "99999,999.99" COLOR SCHEME 7
XfImpVta = ImpBto-ImpDto+ImpInt+ImpAdm
@ 20,67 SAY XfImpVta PICT "99999,999.99" COLOR SCHEME 7
@ 21,14 SAY PorIgv   PICT "99999,999.99" COLOR SCHEME 7
@ 21,41 SAY ImpIgv   PICT "99999,999.99" COLOR SCHEME 7
@ 21,67 SAY ImpNet   PICT "99999,999.99" COLOR SCHEME 7

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

SELE VPED
IF LlCrear
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   STORE RECNO() TO iNumReg
   * control de correlativo *
   SELE DOCM
   SEEK XsCodDoc
   IF ! RLOCK()
      RETURN
   ENDIF
   IF m.NroDoc = XsNroDoc
      * tomamos el correlativo de la base *
      XsNroDoc = PADL(ALLTRIM(STR(DOCM->NroDoc)),LEN(XsNroDoc),'0')
      REPLACE DOCM->NroDoc WITH DOCM->NroDoc+1
   ELSE
      * veamos si ya fue registrado *
      SELE VPED
      SEEK XsNroDoc
      IF FOUND()
         GsMsgErr = [ Registro Creado por otro Usuario ]
         DO lib_merr WITH 99
         RETURN
      ENDIF
      SELE DOCM
      IF XsNroDoc>m.NroDoc
         * actualizamos el correlativo *
         REPLACE DOCM->NroDoc WITH VAL(XsNroDoc)+1
      ENDIF
   ENDIF
   SELE DOCM
   UNLOCK
   @ 1,15 SAY XsNroDoc
   SELE VPED
   GO iNumReg
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
REPLACE RucCli WITH XsRucCli
REPLACE NroO_C WITH XsNroO_C
REPLACE FchO_C WITH XdFchO_C
REPLACE FmaPgo WITH XiFmaPgo
REPLACE FmaSol WITH XsFmaSol
REPLACE DiaVto WITH XiDiaVto
REPLACE CndPgo WITH XsCndPgo
REPLACE CodVen WITH XsCodVen
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE PorIgv WITH XfPorIgv
REPLACE PorDto WITH XfPorDto
REPLACE ImpBto WITH XfImpBto
REPLACE ImpDto WITH XfImpDto
REPLACE ImpInt WITH XfImpInt
REPLACE ImpAdm WITH XfImpAdm
REPLACE ImpIgv WITH XfImpIgv
REPLACE ImpNet WITH XfImpNet
REPLACE GloDoc WITH XsGloDoc
REPLACE FlgEst WITH XcFlgEst
** Grabamos Browse **
Attend = 0
Totale = 0
Pendie = 0
DO xBgrab

SELE VPED
DO CASE
   CASE Attend = 0 .AND. Totale = 0 .AND. Pendie > 0
      REPLACE FlgEst WITH "E"
   CASE Attend = 0 .AND. Totale > 0 .AND. Pendie = 0
      REPLACE FlgEst WITH "C"
   OTHER
      REPLACE FlgEst WITH "E"
ENDCASE

UNLOCK ALL
*************************
**IMPRESION DE PEDIDOS **
IF UltTecla <> Escape
   DO XImprime
ENDIF
*************************

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE VPED
BORTOT = .T.
IF FlgEst = 'A'
   IF !RLOCK()
      RETURN
   ENDIF
   SELE RPED
   SEEK VPED->NroDoc
   DO WHILE NroDoc=VPED->NroDoc .AND. ! EOF()
      IF RLOCK()
         DELETE
      ENDIF
      UNLOCK
      SKIP
   ENDDO
   SELE VPED
   DELETE
   SKIP
   RETURN
ENDIF
IF FlgEst = 'C'
   GsMsgErr = [ Pedido Completo ]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = 'P'
   IF ! ALRT(" Pedido Parcialmente Atendido ")
      RETURN
   ENDIF
   BORTOT = .F.
ENDIF
* Verificamos Flags
SELE RPED
SEEK VPED->NroDoc
SCAN WHILE NroDoc = VPED->NroDoc
   IF !EMPTY(FlgEst)    && Atencion Parcial o Total
      IF ! ALRT(" Pedido Parcialmente Atendido ")
         SELE VPED
         RETURN
      ENDIF
      BORTOT = .F.
      WAIT "SE PROCEDE AL CIERRE DEL PEDIDO" WINDOW NOWAIT
      EXIT
   ENDIF
ENDSCAN
SELE VPED
IF ! RLOCK()
   RETURN
ENDIF
** anulamos detalles **
SELE RPED
SEEK VPED->NroDoc
DO WHILE NroDoc=VPED->NroDoc .AND. ! EOF()
   IF ! RLOCK()
      LOOP
   ENDIF
   IF INLIST(FlgEst,[ ],[P])
      REPLACE FLGEST WITH "N"    && NO atendido
   ENDIF
   IF BorTot
      DELETE
   ENDIF
   UNLOCK
   SKIP
ENDDO
SELE VPED

IF BorTot
   REPLACE FlgEst WITH [A]
ELSE
   *** Cierra el pedido en forma manual ***
   REPLACE FlgEst WITH [c]
ENDIF
UNLOCK
SKIP

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
Yo       = 13
Xo       = 0
Largo    = 6
Ancho    = 80
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
IF EMPTY(AdFchEnt(NumEle))
   LsFchEnt = SPACE(3)
ELSE
   LsFchEnt = SUBSTR("EFMAmJjaSOND",MONTH(AdFchEnt(NumEle)),1)+;
              TRANSF(DAY(AdFchEnt(NumEle)),"@L ##")
ENDIF
@ NumLin,1  SAY TRIM(AsCodMat(NumEle))
@ NumLin,15 SAY AsDesMat(NumEle) PICT "@S12"
@ NumLin,29 SAY AsUndVta(NumEle)
@ NumLin,33 SAY AcFlgEst(NumEle)
@ NumLin,34 SAY AfCanPed(NumEle) PICT "99,999.99"
@ NumLin,44 SAY LsFchEnt
@ NumLin,48 SAY AfPreUni(NumEle) PICT "9,999.999"
@ NumLin,58 SAY AnD1(NumEle)     PICT "99.99"
@ NumLin,64 SAY AnD2(NumEle)     PICT "99.99"
@ NumLin,70 SAY AfImpLin(NumEle) PICT "999999.99"

RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit
PARAMETERS NumEle, NumLin

* Verificamos si tiene atenciones *
LlModif = 0
IF AiNumReg(NumEle)>0
   SELE RPED
   GO AiNumReg(NumEle)
   IF CanDes>0
      GsMsgErr = [ Item tiene atenci¢n parcial ]
      DO lib_merr WITH 99
      LlModif = 1
      IF CanDes >= CanPed
         LlModif = 2
      ENDIF
   ENDIF
ENDIF
** Solo se Permite cambiar codigo si es una linea nueva **
PRIVATE i,LlNuevo
i        = 1
LlNuevo  = .T.
UltTecla = 0
*
LsCodMat = AsCodMat(NumEle)
LnD1     = AnD1(NumEle)
LnD2     = AnD2(NumEle)
LnD3     = AnD3(NumEle)
LdFchEnt = AdFchEnt(NumEle)
LsDesMat = AsDesMat(NumEle)
LsUndVta = AsUndVta(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LfPreUni = AfPreUni(NumEle)
LfCanPed = AfCanPed(NumEle)
LfImpLin = AfImpLin(NumEle)
LiNumReg = AiNumReg(NumEle)
IF EMPTY(LsCodMat) .AND. MaxEle > 1
   LsCodMat = AsCodMat(MaxEle-1)
ENDIF
=SEEK(LsCodMat,"MATG")
XsUndStk = MATG->UndStk
LlNuevo  = LiNumReg=0   && << OJO <<
LRepite  = .F.
DO WHILE !INLIST(UltTecla,Escape)
   i = IIF(!LlNuevo.AND.i<3,3,i)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1   .AND. LlModif = 0
         GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE MATG
         @ NumLin,1 GET LsCodMat PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
            XsCodFam = ""
            GO TOP
            XFILTRO = []   &&"INLIST(CodMat,'002','004','9')"
            IF !ALMbusca("MATG")
               LOOP
            ENDIF
            LsCodMat = MATG->CodMat
            XFILTRO = ""
         ENDIF
         @ NumLin,1 SAY LsCodMat
         SEEK LsCodMat
         IF !FOUND()
            GsMsgErr = [Producto no Existe]
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
            LfPreUni = MATG->PreVe1
         ELSE
            IF XiCodMon = 1   && en soles
               LfPreUni = ROUND(MATG->PreVe1*XfTpoCmb,3)
            ELSE
               LfPreUni = ROUND(MATG->PreVe1/XfTpoCmb,3)
            ENDIF
         ENDIF
         LRepite  = xRepite()
         IF LsCodMat = [9]    && C¢digo Libre
            * Pedimos datos adicionales
            @ NumLin,09 GET LsDesMat PICT "@!S29"
            READ
            UltTecla = LASTKEY()
         ENDIF
         @ NumLin,15 SAY LsDesMat PICT "@S12"
         @ NumLin,29 SAY LsUndVta
         @ NumLin,48 SAY LfPreUni PICT "9,999.999"
         @ 20    ,02 SAY SPACE(40)
         @ 20    ,02 SAY LsDesMat PICT "@S40"
      CASE i = 2 .AND. !(LsCodMat = [9]) .AND. LlModif = 0 .AND. ! LRepite
         GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         if LlModif # 0
            SELE MATG
            SEEK LsCodMat
            IF FOUND()
               @ 20    ,02 SAY MATG.DesMat PICT "@S40"
            ENDIF
         endif
         SELE UVTA
         @ NumLin,29 GET LsUndVta PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape)
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndVta)
            IF !vtabusca("UVTA")
               LOOP
            ENDIF
            LsUndVta = UVTA->UndVta
            LfFacEqu = UVTA->FacEqu
         ENDIF
         @ NumLin,29 SAY LsUndVta
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
      CASE i = 2 .AND. LsCodMat = [9] .AND. LlModif = 0
         @ NumLin,29 GET LsUndVta PICT "@!"
         READ
         UltTecla = LASTKEY()
         @ NumLin,29 SAY LsUndVta
         LfFacEqu = 1
      CASE i = 3 .AND. LlModif < 2
            SELE MATG
            SEEK LsCodMat
            IF FOUND()
               @ 20    ,02 SAY MATG.DesMat PICT "@S40"
            ENDIF
         @ NumLin,34 GET LfCanPed PICT "99,999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape)
            EXIT
         ENDIF
         IF LlModif = 1
            IF LfCanPed < CanDes
               GsMsgErr = "La Cantidad debe  superar a la cantidad despachada "+TRANSF(CanDes,"###,###.###")
               DO LIB_MERR WITH 99
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
      CASE i = 4 .AND. LlModif < 2
         IF EMPTY(LdFchEnt)
            LdFchEnt = DATE()
         ENDIF
         SAVE SCREEN
         @ NumLin-1,33 TO NumLin+1,62
         @ NumLin,34 SAY "Fecha de Entrega : "
         @ NumLin,54 GET LdFchEnt
         READ
         UltTecla = LASTKEY()
         RESTORE SCREEN
         IF EMPTY(LdFchEnt)
            LsFchEnt = SPACE(3)
         ELSE
            LsFchEnt = SUBSTR("EFMAmJjaSOND",MONTH(LdFchEnt),1)+;
                       TRANSF(DAY(LdFchEnt),"@L ##")
         ENDIF
         @ NumLin,44 SAY LsFchEnt
      CASE i = 5 .AND. (! LRepite .OR. LSCODMAT="9")
         IF LlModif = 0
            IF LfFacEqu <= 0
               LfFacEqu = 1
            Endif
            LfPreUni = LfPreUni * LfFacEqu
         ENDIF
         @ NumLin,48 GET LfPreUni PICT "9,999.999" RANGE 0,
         @ NumLin,58 GET LnD1 PICT "99.99"
         @ NumLin,64 GET LnD2 PICT "99.99"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Arriba)
            I = 1
            ULTTECLA = 0
            LOOP
         ENDIF
   ENDCASE
   IF i = 5 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>5,5,i)
ENDDO
@ 20,0  SAY "³  Intereses:                Gto. Admin:                Valor Vta:             ³" COLOR SCHEME 7
IF !INLIST(UltTecla,Escape,Arriba,Abajo)
   LfImpLin = ROUND(LfCanPed*LfPreUni*(1-LnD1/100)*(1-LnD2/100)*(1-LnD3/100),2)
   AsCodMat(NumEle) = LsCodMat
   AnD1    (NumEle) = LnD1
   AnD2    (NumEle) = LnD2
   AnD3    (NumEle) = LnD3
   AdFchEnt(NumEle) = LdFchEnt
   AsDesMat(NumEle) = LsDesMat
   AsUndVta(NumEle) = LsUndVta
   AfFacEqu(NumEle) = LfFacEqu
   AfPreUni(NumEle) = LfPreUni
   AfCanPed(NumEle) = LfCanPed
   AfImpLin(NumEle) = LfImpLin
   AiNumReg(NumEle) = LiNumReg
   ***** SI EL ITEM SE REPITE SE GARBA TODOS LOS PARAMETROS A LOS DEMAS **
   FOR k = 1 TO GiTotItm
      IF AsCodMat(k)=LsCodMat .AND. k#NumEle
         AsUndVta(k) = LsUndVta
         AfPreUni(k) = LfPreUni
      ENDIF
   ENDFOR
   DO xRegenera
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
   * Verificamos si tiene atenciones *
   SELE RPED
   GO AiNumReg(i)
   IF CanDes>0
      GsMsgErr = [ Item tiene atenci¢n parcial ]
      DO lib_merr WITH 99
      Estado = .F.
      RETURN
   ENDIF
   GiTotDel = GiTotDel + 1
   AiRegDel(GiTotDel) = AiNumReg(i)
ENDIF
* borramos del arreglo
DO WHILE i <  GiTotItm
   AsCodMat(i) = AsCodMat(i+1)
   AnD1    (i) = AnD1(i+1)
   AnD2    (i) = AnD2(i+1)
   AnD3    (i) = AnD3(i+1)
   AdFchEnt(i) = AdFchEnt(i+1)
   AsDesMat(i) = AsDesMat(i+1)
   AsUndVta(i) = AsUndVta(i+1)
   AfFacEqu(i) = AfFacEqu(i+1)
   AfPreUni(i) = AfPreUni(i+1)
   AcFlgEst(i) = AcFlgEst(i+1)
   AfCanPed(i) = AfCanPed(i+1)
   AfImpLin(i) = AfImpLin(i+1)
   AiNumReg(i) = AiNumReg(i+1)
   i = i + 1
ENDDO
STORE SPACE(LEN(RPED->CodMat)) TO AsCodMat(i)
STORE 0 TO AnD1(i),AnD2(i),AnD3(i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(RPED->UndVta)) TO AsUndVta(i)
STORE {,,}                     TO AdFchEnt(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AfPreUni(i)
STORE [ ]                      TO AcFlgEst(i)
STORE 0                        TO AfCanPed(i)
STORE 0                        TO AfImpLin(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm - 1
Estado = .T.
DO xRegenera   && recalcula importe

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
   AsCodMat(i) = AsCodMat(i-1)
   AnD1(i)     = AnD1    (i-1)
   AnD2(i)     = AnD2    (i-1)
   AnD3(i)     = AnD3    (i-1)
   AdFchEnt(i) = AdFchEnt(i-1)
   AsDesMat(i) = AsDesMat(i-1)
   AsUndVta(i) = AsUndVta(i-1)
   AfFacEqu(i) = AfFacEqu(i-1)
   AfPreUni(i) = AfPreUni(i-1)
   AcFlgEst(i) = AcFlgEst(i-1)
   AfCanPed(i) = AfCanPed(i-1)
   AfImpLin(i) = AfImpLin(i-1)
   AiNumReg(i) = AiNumReg(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(RPED->CodMat)) TO AsCodMat(i)
STORE 0 TO AnD1(i),AnD2(i),AnD3(i)
STORE SPACE(LEN(MATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(RPED->UndVta)) TO AsUndVta(i)
STORE {,,}                     TO AdFchEnt(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AfPreUni(i)
STORE [ ]                      TO AcFlgEst(i)
STORE 0                        TO AfCanPed(i)
STORE 0                        TO AfImpLin(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm + 1
Estado = .T.

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
   AnD1(i)     = D1
   AnD2(i)     = D2
   AnD3(i)     = D3
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
DO xRegenera

RETURN
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab

SELE RPED
PRIVATE i
i = 1
IF GiTotDel > 0
   DO WHILE i<=GiTotDel
      GO AiRegDel(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      DELETE
      UNLOCK
      i = i + 1
   ENDDO
ENDIF
Attend = 0
Totale = 0
Pendie = 0
i = 1
DO WHILE i <= GiTotItm
   IF AiNumReg(i) > 0
      GO AiNumReg(i)
      IF ! RLOCK()
         LOOP
      ENDIF
   ELSE
      APPEND BLANK
      IF ! RLOCK()
         LOOP
      ENDIF
      REPLACE NroDoc WITH XsNroDoc
   ENDIF
   REPLACE CodMat WITH AsCodMat(i)
   REPLACE D1     WITH AnD1    (i)
   REPLACE D2     WITH AnD2    (i)
   REPLACE D3     WITH AnD3    (i)
   REPLACE DesMat WITH AsDesMat(i)
   REPLACE FchEnt WITH AdFchEnt(i)
   REPLACE UndVta WITH AsUndVta(i)
   REPLACE FacEqu WITH AfFacEqu(i)
   REPLACE PreUni WITH AfPreUni(i)
   REPLACE CanPed WITH AfCanPed(i)
   REPLACE ImpLin WITH AfImpLin(i)
   DO CASE
      CASE CanDes = 0
         REPLACE FlgEst WITH " "
         Pendie = Pendie + 1
      CASE CanDes < CanPed
         REPLACE FlgEst WITH "P"
         Attend = Attend + 1
      OTHER
         REPLACE FlgEst WITH "C"
         Totale = Totale + 1
   ENDCASE
   i = i + 1
ENDDO

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
@ 19,14 SAY XfImpBto PICT "99999,999.99" COLOR SCHEME 7
@ 19,41 SAY XfPorDto PICT "99999,999.99" COLOR SCHEME 7
@ 19,67 SAY XfImpDto PICT "99999,999.99" COLOR SCHEME 7
@ 20,14 SAY XfImpInt PICT "99999,999.99" COLOR SCHEME 7
@ 20,41 SAY XfImpAdm PICT "99999,999.99" COLOR SCHEME 7
@ 20,67 SAY XfImpVta PICT "99999,999.99" COLOR SCHEME 7
@ 21,14 SAY XfPorIgv PICT "99999,999.99" COLOR SCHEME 7
@ 21,41 SAY XfImpIgv PICT "99999,999.99" COLOR SCHEME 7
@ 21,67 SAY XfImpNet PICT "99999,999.99" COLOR SCHEME 7

RETURN
************************************************************************ FIN *
* Objeto : Veirifica si el codigo fue registrado
******************************************************************************
FUNCTION xRepite
PRIVATE k
FOR k = 1 TO GiTotItm
   IF AsCodMat(k)=LsCodMat .AND. k#NumEle
      LsUndVta = AsUndVta(k)
      LfPreUni = AfPreUni(k)
      LfFacEqu = AfFacEqu(k)
      RETURN .T.
   ENDIF
ENDFOR
RETURN .F.
************************************************************************ FIN *
* Objeto : Emisi¢n del documento
******************************************************************************
PROCEDURE xImprime
SAVE SCREEN TO XTemp
*** Configuraci¢n de las Impresiones ***
DO admprint
UltTecla = LASTKEY()
IF UltTecla = Escape
   RETURN
ENDIF
IniImp   = _Prn2
NumPag   = 0
Largo    = 33
*Ancho    = 80

   * ############# ############################## ######## ### 99,999.99  9,999.999 %d %d %d 999999.99
   *
   *          1         2         3         4         5         6         7         8         9
   *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
cE1=[C¢digo        Descripci¢n                    Fec.Ent.  Und   Cantidad   P.Unit. %Dct1 %Dct2     Total ]

SET DEVICE TO PRINTER
SET MARGIN TO 0
PRINTJOB
   NumPag   = 0
   LsLlave  = VPED->NroDoc
   DO MOVMembr
   SELECT RPED
   SEEK LsLlave
   IF VPED->FlgESt <> "A"
      DO WHILE  ! EOF() .AND. Nrodoc = LsLlave
         IF Prow() > (Largo - 4)
            DO MOVMembr
         ENDIF
         SELECT RPED
         NumLin = Prow() + 1
         @ NumLin,1  SAY CodMat
         =SEEK(CodMat,"MATG")
         @ NumLin,15 SAY MATG->DesMat PICT "@S30"
         @ NumLin,46 SAY DTOC(FchEnt)
         @ NumLin,56 SAY UndVta
         @ NumLin,61 SAY CanPed PICT "99,999.99"
         @ NumLin,71 SAY PreUni PICT "9,999.999"
         @ NumLin,81 SAY IIF( D1=0, [],IIF(D2>0,TRANS(D1,"99.99")+[+],TRAN(D1,"99.99")))
         @ NumLin,87 SAY IIF( D2=0, [], TRAN(D2,"99.99") )
         @ NumLin,93 SAY ImpLin PICT "999,999.99"
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
   IF Prow() > (Largo - 10)
      DO MOVMembr
   ENDIF
   DO MovIPie
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
SELECT VPED
RESTORE SCREEN FROM xTemp
RETURN
************************************************************************ FIN *
* Objeto : Membrete del documento
******************************************************************************
PROCEDURE MOVMembr

IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ELSE
   @ Largo-1,Ancho-10 SAY "../Continua"
ENDIF
@  0,0  SAY IniImp
@  1,1  SAY _Prn7a+GsNomCia+_Prn7b
@  1,0  SAY []
@  1,75 SAY "No. PEDIDO  :"+_Prn7a+VPED->NroDoc+_Prn7b
@  2,1  SAY GsDirCia
@  2,75 SAY "FECHA       :"+DTOC(VPED->FchDoc)
@  3,1  SAY GsRucCia
@  4,1  SAY "SOLICITUD      :"+VPED->FmaSol
@  4,75 SAY "O/C CLIENTE :"+VPED->NroO_C
@  5,1  SAY "FEC. DE LA O/C :"+DTOC(VPED->FchO_C)
LinAct = 6
=SEEK(GsClfAux+VPED->CodCli,"CLIE")
IF VPED->CODCLI # [99]
   @ LinAct , 0  SAY " CLIENTE        :"+ VPED->CodCli + " " + CLIE->NomAux
ELSE
   @ LinAct , 0  SAY " CLIENTE        :"+ VPED->CodCli + " " + VPED.NOMCLI
ENDIF
LinAct = LinAct + 1
@ LinAct , 0  SAY " DIRECCION      :"+ VPED->DIRCLI
LinAct = LinAct + 1
=SEEK("02"+VPED->CodCli,"TABL")
@ LinAct , 0  SAY " MONEDA         :"+IIF(VPED->CodMon#2, CFGNOMMON, "DOLAR AMERICANO ")
=SEEK("01"+TRANS(VPED->FmaPgo,"@L ##"),"TABL")
@ LinAct , 40 SAY " COND. PAGO :"+TRANS(VPED->CndPgo,'@S25')
LinAct = LinAct + 1
@ LinAct  , 1    SAY VPED->GloDoc SIZE 2,78
LinAct = LinAct + 2
@ LinAct  , 1    SAY REPLICATE("-",LEN(cE1))
LinAct = LinAct + 1
@ LinAct  , 1    SAY cE1
LinAct = LinAct + 1
@ LinAct  , 1    SAY REPLICATE("-",LEN(cE1))
NumPag = NumPag + 1
RETURN
**********************************************************************
PROCEDURE MovIPie

NumLin = Largo - 10
@ NumLin,0  SAY " Imp. Bruto :                            % Dscto.:                         Imp. Dscto :"
@ NumLin,14 SAY VPED->ImpBto PICT "99999,999.99"
@ NumLin,51 SAY VPED->PorDto PICT "99999,999.99"
@ NumLin,88 SAY VPED->ImpDto PICT "99999,999.99"
NumLin = PROW() + 1
                *          1         2         3         4         5         6         7
                *012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ NumLin,0  SAY " Intereses  :                         Gto. Admin.:                         Imp. Venta :"
@ NumLin,14 SAY VPED->ImpInt PICT "99999,999.99"
@ NumLin,51 SAY VPED->ImpAdm PICT "99999,999.99"
ZfImpVta = VPED->ImpBto-VPED->ImpDto+VPED->ImpInt+VPED->ImpAdm
@ NumLin,88 SAY ZfImpVta PICT "99999,999.99"
NumLin = PROW() + 1
@ NumLin,0  SAY "      % IGV :                           Imp. IGV :                         Imp.  Neto :"
@ NumLin,14 SAY VPED->PorIgv PICT "99999,999.99"
@ NumLin,51 SAY VPED->ImpIgv PICT "99999,999.99"
@ NumLin,88 SAY VPED->ImpNet PICT "99999,999.99"
Pn1 = "---------------                        ---------------                        --------------- "
Pn2 = "   PREPARADO                               REVISADO                                Vo Bo      "
Pn3 = "                                                                                              "
Pn4 = "                                                                                              "
Pn5 = "---------------                        ---------------                        --------------- "
NumLin = PROW() + 5
@  NumLin, 1 SAY Pn1
NumLin = PROW() + 1
@  NumLin, 1 SAY Pn2
EJECT PAGE

RETURN
