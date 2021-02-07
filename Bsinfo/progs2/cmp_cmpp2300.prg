*****************************************************************************
* Programa     : cmpp2300.prg
* Sistema      : Compras
* Autor		   : VETT
* Proposito    : Ingreso de Ordenes de Compra
* Creacion     : 06/09/94
* Parametros   :
* Actualizaci¢n: 28/10/96 integracion con Aplica
* Actualizaci¢n: 06/05/2006 integracion con o-Negocios
*****************************************************************************

** Pantalla de Datos **
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
DO fondo WITH 'COMPRAS',Goentorno.user.login,GsNomCia,GsFecha
*!*	IF FILE(GoCfgVta.oentorno.tspathcia+'VTACONFG.MEM')
*!*	   *RESTORE FROM VTACONFG ADDITIVE
*!*	   RESTORE FROM GoCfgVta.oentorno.tspathcia+'VTACONFG.MEM' ADDITIVE
*!*	ENDIF
IF FILE(GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM')
   *RESTORE FROM VTACONFG ADDITIVE
   RESTORE FROM GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM' ADDITIVE
ENDIF


XcTipo   = [N]
DO xPanta
** abrimos bases de datos **
*
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','PROV','AUXI01','')
*
*USE cmpvocom ORDER VORD01 ALIAS VORD
LoDatAdm.abrirtabla('ABRIR','cmpco_cg','vord','co_c01','')
*
*USE cmprocom ORDER RORD01  ALIAS RORD
LoDatAdm.abrirtabla('ABRIR','cmpdo_cg','rord','do_c01','')
*
LoDatAdm.AbrirTabla('ABRIR','almcatal','CATA','CATA02','')
*
LoDatAdm.AbrirTabla('ABRIR','almcatge','CATG','CATG01','')
*
LoDatAdm.AbrirTabla('ABRIR','cmptdocm','DOCM','DOCM01','')
*
LoDatAdm.AbrirTabla('ABRIR','ALMTGSIS','TABL','TABL01','')
*
*USE cmpvrequ ORDER VREQ06 ALIAS VREQ
LoDatAdm.AbrirTabla('ABRIR','cmpcrequ','vreq','creq06','') 
*
LoDatAdm.AbrirTabla('ABRIR','ALMEQUNI','EQUN','EQUN01','')
*
LoDatAdm.AbrirTabla('ABRIR','ALMTDIVF','DIVF','DIVF01','')   
*

*!*	USE cmpmtxpr IN 0 ORDER MTPR01 ALIAS MTPR
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	USE cmpsimpt IN 0 ORDER simp01  ALIAS SIMP
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	USE cmptflet IN 0 ORDER FLET01 ALIAS FLET
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
*!*	USE cmpvsoli IN 0 ORDER VSOL04 ALIAS VCOT
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
**USE CMPCATGE IN 0 ORDER PCAT01 ALIAS PCAT
**IF !USED()
**   CLOSE DATA
**   RETURN
**ENDIF
*
*!*	USE cmptabla IN 0 ORDER TABL01 ALIAS CTBL
*!*	IF !USED()
*!*	   CLOSE DATA
*!*	   RETURN
*!*	ENDIF
*
LoDatAdm.AbrirTabla('ABRIR','flcjtbfp','tbfp','fmapgo','') 

*
** relaciones a usar **
SELE RORD
SET RELA TO Usuario+NroReq INTO VREQ
**SET RELA TO CodMat INTO PCAT ADDI
SELE VORD
SET RELATION TO GsClfPro+CodAux INTO PROV ADDIT
SET MEMOWIDTH TO 55
** variables a usar **
*
Private XsFmaPgo, XsPagAde, XiTasa
*
PRIVATE XsNroOrd,XdFchOrd,XsCodAux,XsNroCot,XdFchO_C,XiFmaPgo,XiDiaEnt
PRIVATE XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfPorIgv,XfPorDto
PRIVATE XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpNet,XfImpOtr
PRIVATE XfPorDto1,XfPorDto2,XfPorDto3,XfImpDto1,XfImpDto2,XfImpDto3
PRIVATE XsGloDoc,XcFlgEst,LsFmaPgo,XsRucAux,XsNomAux,XsDirAux,XsTlfAux
PRIVATE XdFchEnt,XsMarcas,XcTpoCmp,XsCodCmp,CFGPasswD,XsLugEnt,XsPrueba
PRIVATE XsCodUas,XsNroReq,XcTipo,XsUsuario,XcTpoO_C,XsRefere,XsTmpent
private xctpobie
*
PRIVATE XcTpoFle,XfImpFle,XfImpSeg,XfImpAdv,XfImpPap,XfImpCif,XfImpOtr
PRIVATE XfImpHan,XfImpIns,XfImpAdm,XfImpFob,XfImpGen
PRIVATE XfImpAdu,XfImpMtt,XsNroOr2,XsCotImp,XsMaquina
*
XsFmapgo = space(04)
XsPagAde = [ ]
XiTasa   = 0
*
STORE [] TO XsNroOrd,XdFchOrd,XsCodAux,XsNroCot,XdFchO_C,XiFmaPgo,XiDiaEnt
STORE [] TO XsFmaSol,XsCndPgo,XsCodVen,XiCodMon,XfPorIgv,XfPorDto
STORE [] TO XfImpBto,XfImpDto,XfImpInt,XfImpAdm,XfImpIgv,XfImpNet,XfImpOtr
STORE [] TO XsGloDoc,XcFlgEst,LsFmaPgo,XsRucAux,XsNomAux,XsDirAux,XsTlfAux
STORE [] TO XdFchEnt,XsMarcas,XcTpoCmp,XsCodCmp,XsLugEnt,XsPrueba
STORE [] TO XfPorDto1,XfPorDto2,XfPorDto3,XfImpDto1,XfImpDto2,XfImpDto3
STORE [] TO XsCodUas,XsNroReq,XsCodRef,XsNroOr2,XsRefere,XsTmpent,XsCotImp,XsMaquina
CFGPasswD=spac(8)
IF VARTYPE(CFGADMIGV)='U'
	XfPorIgv = 19
ELSE
	XfPorIgv = CFGADMIGV
ENDIF
*
STORE 0  TO XfImpFle,XfImpSeg,XfImpAdv,XfImpPap,XfImpCif,XfImpOtr
STORE 0  TO XfImpHan,XfImpIns,XfImpAdm,XfImpFob,XfImpGen
STORE 0  TO XfImpAdu,XfImpMtt
*
STORE [N] TO XcTipo
STORE [C] TO XcTpoO_C
STORE [I] TO XcTpoBie
STORE [A] TO XcTipFle
XsUsuario = SPACE(LEN(VREQ.Usuario))
XsCodRef  = SPACE(LEN(VORD.CodRef))
XsNroOr2  = SPACE(LEN(VORD.NroOr2))
XsCotImp  = SPACE(LEN(VORD.CotImp))
XsMaquina = SPACE(LEN(VORD.Maquina))
Xslugent  = SPACE(LEN(VORD.LugEnt))
XsPrueba  = 2
XsPagAde = [N]
XdFchEnt  = DATE()
*STORE {,,} TO XDFchEmb,XdFchLle
STORE {  ,  ,    } TO XDFchEmb,XdFchLle
XnDprev = 0
XnFpgFlt = 1
** Variables del Browse **
PRIVATE AsNroReq,AcTpoReq
*
PRIVATE AcTpoBie
*
PRIVATE AsCodMat,AsUndCmp,AfFacEqu,AfPreUni,AfCanPed,AfImpLin,AiNumReg,GiTotItm
PRIVATE AfPreFob
PRIVATE AiRegDel,GiTotDel
CIMAXELE = 100
DIMENSION AsNroReq(CIMAXELE)
DIMENSION AcTpoReq(CIMAXELE)
*
DIMENSION AcTpoBie(CIMAXELE)
*
DIMENSION AsCodMat(CIMAXELE)
DIMENSION AsDesMat(CIMAXELE)
DIMENSION AsMarca (CIMAXELE)
DIMENSION AsUndCmp(CIMAXELE)
DIMENSION AfFacEqu(CIMAXELE)
DIMENSION AsPeso  (CIMAXELE)
DIMENSION AfPreUni(CIMAXELE)
DIMENSION AfPreFob(CIMAXELE)
DIMENSION AfPorDto(CIMAXELE)
DIMENSION AfCanPed(CIMAXELE)
DIMENSION AfImpLin(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)
DIMENSION AiRegDel(CIMAXELE)
GiTotItm = 0
GiTotDel = 0
** control correlativo multiusuario **
PRIVATE m.NroOrd,XsCodDoN,XsCodDoI,XsMesCon
m.NroOrd = []
XsCodDoN = [O/CN]
XsCodDoI = [O/CI]
XsMesCon = 'Mes'+SUBS(DTOC(GdFecha),4,2)
** Logica Principal **
SELE VORD
*DO LIB_MTEC WITH 3
UltTecla = 0
DO F1_EDIT WITH [xLlave],[xPoner],[xTomar],[xBorrar],[xImprime],;
              [],[],'CMAR',[]

CLEAR 
CLEAR MACROS
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
IF USED('CATG')
	USE IN CATG
ENDIF
IF USED('CATA')
	USE IN CATA
ENDIF
IF USED('DIVF')
	USE IN DIVF
ENDIF
IF USED('VORD')
	USE IN VORD
ENDIF
IF USED('RORD')
	USE IN RORD
ENDIF
IF USED('EQUN')
	USE IN EQUN
ENDIF
IF USED('CREQ')
	USE IN CREQ
ENDIF
IF USED('DOCM')
	USE IN DOCM
ENDIF
IF USED('TABL')
	USE IN TABL
ENDIF
SYS(2700,1)
RETURN
************************************************************************ EOP()
* Pantalla de Datos
******************************************************************************
PROCEDURE xPanta

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*0+------------------------------------------------------------------------------+
*1Ý    O/C No. : 123456                                    Fecha : 99/99/99      Ý
*2Ý Proveedor  : 12345                                       RUC : 12345678      Ý
*3Ý Nombre     : 12345678901234567890123456789012345678901234567890              Ý
*4Ý Direccion  : 12345678901234567890123456789012345678 Telefono : 123456789012  Ý
*5+------------------------------------------------------------------------------Ý
*6Ý     Cotizacion : 1234567890                   Dias de Vencto.: 123           Ý
*7Ý Forma de Pago  : 12345678901234567890                 Moneda : 123           Ý
*8Ý Fecha Entrega  : 12345678901234567890           No. Requisic.: 123-1234/001  Ý
*9Ý      Comprador : 123 12345678901234567890         Codigo U.A.: 1234567       Ý
*0+------------------------------------------------------------------------------Ý
*1Ý  Nro.   T                                        Precio              Importe Ý
*2ÝRequisic R  C¢digo de Material   Und  Cantidad   Unitario  % Descto    Total  Ý
*1Ý  Nro.   T                                        Precio    Precio    Importe Ý
*2ÝRequisic R  C¢digo de Material   Und  Cantidad     F.O.B.  Unitario    Total  Ý
*3+------------------------------------------------------------------------------Ý
*4Ý1234-567 1 123-45678901234567890 123 999,999.99 9999.9999 9999.9999 999,999.99Ý
*5Ý1234-567 1 123-45678901234567890 123 999,999.99 9999.9999 9999.9999 999,999.99Ý
*6Ý1234-567 1 123-45678901234567890 123 999,999.99 9999.9999 9999.9999 999,999.99Ý
*7+------------------------------------------------------------------------------Ý
*8Ý     Valor Venta Total : 99999,999.99   % Dto1: 99.99  Descto.1 : 99999,999.99Ý
*9Ý                                        % Dto2: 99.99  Descto.2 : 99999,999.99Ý
*0Ý                                        % Dto3: 99.99  Descto.3 : 99999,999.99Ý
*1Ý     % IGV : 99.99 IGV : 99999,999.99        Precio Venta Total : 99999,999.99Ý
*2+------------------------------------------------------------------------------+
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*           1         2         3         4         5         6         7        8
*7+------------------------------------------------------------------------------Ý
*8ÝValor F.O.B.:99999,999.99  INSPECCION:99999,999.99    GTOS.OPER.: 99999,999.99Ý
*9Ý      FLETE :99999,999.99  HANDLING  :99999,999.99   COMISION AA: 99999,999.99Ý
*0Ý     SEGURO :99999,999.99  ADVALOREN :99999,999.99         OTROS: 99999,999.99Ý
*1ÝValor C.I.F.:99999,999.99  ALM.MANTT.:99999,999.99 <Valor TOTAL>: 99999,999.99Ý
*2+------------------------------------------------------------------------------+


CLEAR
@  0,0  SAY "+---------------------------------------------------------------------------------+"
*!*	@  1,0  SAY "Ý    O/C No. :                    Tipo :                 Fecha :               Ý"
@  1,0  SAY "Ý    O/C No. :                                           Fecha :                  Ý"
@  2,0  SAY "Ý Tip.de Bien:                                             RUC :                  Ý"
*@  2,0  SAY "Ý Tip.de Bien:                                             RUC :               Ý"
@  3,0  SAY "Ý Proveedor  :                                                                    Ý"
@  4,0  SAY "Ý Direccion  :                                        Telefono :                  Ý"
@  5,0  SAY "+---------------------------------------------------------------------------------Ý"
@  6,0  SAY "Ý Sol.Cotizacion :             Refere.:                           Moneda :        Ý"
*!*	@  7,0  SAY "Ý Forma de Pago  :                                                % Int. :        Ý"
@  7,0  SAY "Ý Forma de Pago  :                                                                Ý"
*!*	@  8,0  SAY "Ý Dias de Vcto   :             L/A   :                                         Ý"
@  8,0  SAY "Ý Dias de Vcto   :                                                                Ý"
*!*	@  9,0  SAY "| Fecha Entrega  :             Lugar Entrega :                    Prueba :     Ý"
@  9,0  SAY "| Fecha Entrega  :             Lugar Entrega :                                    Ý"
@ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
@ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
@ 12,0  SAY "+---------------------------------------------------------------------------------Ý"
@ 13,0  SAY "Ý                                                                                 Ý"
@ 14,0  SAY "Ý                                                                                 Ý"
@ 15,0  SAY "Ý                                                                                 Ý"
@ 16,0  SAY "Ý                                                                                 Ý"
@ 17,0  SAY "+---------------------------------------------------------------------------------Ý"
@ 18,0  SAY "Ý                                                                                 Ý"
@ 19,0  SAY "Ý                                                                                 Ý"
@ 20,0  SAY "Ý                                                                                 Ý"
@ 21,0  SAY "Ý                                                                                 Ý"
@ 22,0  SAY "+---------------------------------------------------------------------------------+"

IF LEFT(XcTipo,1)#[N]
  *@  6,0  SAY "Ý Sol.Cotizacion :             No Cotizac.:             Moneda :               Ý"
  *@ 10,0  SAY "Ý  Nro.   T                                        Precio     Precio   Importe Ý"
  *@ 11,0  SAY "ÝRequisic R  C¢digo de Material   Und  Cantidad     FOB      Unitario   Total  Ý"
   *
   @  6,0  SAY "Ý Sol.Cotizacion :             No Cotizac.:                       Moneda :        Ý"
   @ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
   @ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
   *
   @ 18,0  SAY "ÝValor F.O.B.:              INSPECCION:                GTOS.OPER.:                Ý"
   @ 19,0  SAY "Ý    FLETE   :              HANDLING  :               COMISION AA:                Ý"
   @ 20,0  SAY "Ý     SEGURO :              ADVALOREN :                     OTROS:                Ý"
   @ 21,0  SAY "ÝValor C.I.F.:              ALM.MANTT.:             <Valor TOTAL>:                Ý"
ELSE
  *@ 10,0  SAY "Ý  Nro.   T                                        Precio              Importe Ý"
  *@ 11,0  SAY "ÝRequisic R  C¢digo de Material   Und  Cantidad   Unitario  % Descto    Total  Ý"
   *
   @ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
   @ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
   *
   @ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                   Ý"
   @ 20,0  SAY "Ý                                              I.G.V.       % :                   Ý"
   @ 21,0  SAY "Ý                                          Precio Venta Total :                   Ý"
ENDI
@ 11,1 FILL TO 11,81 COLOR SCHEME 7
*
Titulo = [ >>> ORDENES DE COMPRA <<< ]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7

RETURN
************************************************************************ FIN()
* Llave de Datos
******************************************************************************
PROCEDURE xLlave

****** Buscando Correlativo **********
IF !SEEK(XsCodDoN,"DOCM") AND RLOCK("DOCM") OR  !SEEK(XsCodDoI,"DOCM") AND RLOCK("DOCM")
   WAIT "No existe correlativo" NOWAIT WINDOW
   UltTecla = escape_
   RETURN
ENDIF
UNLOCK IN "DOCM"
*
i = 1
SELE VORD
UltTecla = 0
DO WHILE ! INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1
*!*	         DO LIB_MTEC WITH 16
*!*	         VecOpc(1)="Nacional   "
*!*	         VecOpc(2)="Importaci¢n"
*!*	         XcTipo   = Elige(XcTipo,1,15,2)
*!*	         XcTipo   = LEFT(XcTipo,1)
	
         @ 1,15 SAY space(15)
         @ 1,15 SAY XcTipo PICT "@R !-"
         SELE DOCM
         IF XcTipo = [N]   && Nacional
            =SEEK(XsCodDoN,"DOCM")
            XiNroDoc  = RIGH(XsMesCon,2)+PADL(DOCM->&XsMesCon.,4,'0')
         ELSE              && Importaci¢n
            =SEEK(XsCodDoI,"DOCM")
            XiNroDoc  = RIGH(XsMesCon,2)+PADL(DOCM->&XsMesCon.,4,'0')
         ENDIF
         XsNroOrd = XcTipo + TRANSF(XiNroDoc,"@L 999999")
         m.NroOrd = XsNroOrd
         XyNroOrd = XsNroOrd
         @ 1,15 SAY XsNroOrd PICT "@R !-999999"
      CASE i = 2
        *IF !m.crear
         SELE VORD
            IF XcTipo = "N"
               @ 1,17 GET XiNroDoc PICT "@L 999999"
            ELSE
               @ 1,15 GET XyNroOrd PICT "@R !-!!!!!!"
            ENDIF
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,escape_)
               LOOP
            ENDIF
            IF UltTecla = F8
               IF ! cmpbusca("OCMP")
                  UltTecla = 0
                  LOOP
               ENDIF
               XcTipo   = LEFT(VORD->NroOrd,1)
               XiNroDoc = VAL(SUBSTR(VORD->NroOrd,2))
               XsNroOrd = VORD->NroOrd
               XyNroOrd = VORD->NroOrd
               UltTecla = Enter
            ENDIF
            IF SUBS(XsNroOrd,2) # xinrodoc .AND. m.Crear
               GsMsgErr = [ Verifique Correlativo ]
               DO lib_merr WITH 99
              *UltTecla = escape_
            ENDIF
            IF XcTipo ="N"
               xsnroord = XcTipo + TRANsf(Xinrodoc,"@L 999999")
            ELSE
               xsnroord = XyNroord
            ENDIF
            IF EMPTY(XsNroOrd)
               UltTecla = 0
               LOOP
            ENDIF
        *ELSE
        *   SELE VORD
        *   SEEK XsCodDoc+XsNroOrd
        *   IF FOUND()
        *      GsMsgErr = "Error en el Registro de Correlativos"
        *      DO LIB_MERR WITH 99
        *      UltTecla = escape_
        *   ENDIF
        *   UltTecla = Enter
        *ENDIF
         @ 1,15 SAY XsNroOrd PICT "@R !-!!!!!!"

   ENDCASE
   IF UltTecla=Enter .AND. i = 2
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE VORD
SEEK XsNroOrd
*** muestra
IF LEFT(XsNroOrd,1)=[N]
   DO xPieNac
ELSE
   DO xPieImp
ENDIF
RETURN
************************************************************************ FIN()
* Pedir Informacion adicional
******************************************************************************
PROCEDURE xTomar

SELE VORD
m.Crear = .T.
IF &sEsRgV
   m.Crear = .F.
   *IF ! Clave(CFGPasswD)
   *   UltTecla = escape_
   *   RETURN
   *ENDIF
   IF FlgEst = 'A'
      GsMsgErr = [ Registro Anulado ]
      DO lib_merr WITH 99
      UltTecla = escape_
      RETURN
   ENDIF
   IF FlgEst = 'C'
      GsMsgErr = [ O/C Completa ]
      DO lib_merr WITH 99
      UltTecla = escape_
      RETURN
   ENDIF
 * IF !Modifica()
 *    GsMsgErr = [ O/C Parcialmente Atendida ]
 *    DO lib_merr WITH 99
 *    UltTecla = escape_
 *    RETURN
 * ENDIF
   IF ! REC_LOCK(5)
      UltTecla = escape_
      RETURN
   ENDIF
   DO xMover
   cTecla = [escape_,F10,CtrlW]
ELSE
   DO xInvar
   cTecla = [escape_]
ENDIF
DO XEDIT

*************************************************************** FIN
PROCEDURE XEDIT
***************

@  1,15 SAY XsNroOrd PICT "@R !-!!!!!!"
@  1,65 GET XdFchOrd PICT "RD DD/MM/AAAA"
*@  2,15 GET XsNroOr2
@  2,65 GET XsRucAux
@  3,15 GET XsCodAux PICT "@!"
@  4,15 GET XsDirAux PICT "@S38"
@  4,65 GET XsTlfAux PICT "@S12"
@  6,19 GET XsNroCot PICT "@!"
IF XsNroOrd='I'
	@  6,42 GET XsCotImp PICT "@(S13)"
ENDIF

*@ 7,19 GET XsCndPgo PICT "@S25"
*@ 7,65 GET XiDiaEnt PICT "999"
@  7,19 GET XsFmaPgo
@  7,24 GET XsCndPgo PICT "@S40"
*!*	@  7,74 get XiTasa   pict '99.99'
*
*!*	@  8,39 say iif(XsPagAde=[S],[S¡],[No])
*
@  8,19 GET XiDiaEnt PICT "999"
@  9,19 GET XdFchEnt PICT "RD DD/MM/AAAA"
*!*	@  9,46 SAY IIF(XsLugEnt=1,'San Isidro', IIF(XsLugEnt=2,'Vulcano   ','Ca¤ete    '))
*!*	@  9,75 SAY IIF(XsPrueba=1, 'S¡', 'No')
CLEAR GETS
UltTecla = 0
PRIVATE i
IF m.Crear
	i = 1
ELSE
	i = 5
ENDIF
DO WHILE ! INLIST(UltTecla,&cTecla.)
   GsMsgKey = "[Tab] Sig. Campo  [S-TAB] Ant. Campo  [Enter] Registra  [F10] Graba  [Esc] Cancela"
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1 AND EMPTY(XsCodRef)  && AND .F.  && cuando viene de logistica no ingresa
         DO LIB_MTEC WITH 16
         VecOpc(1) = "Compra  "
         VecOpc(2) = "Servicio"
         VecOpc(3) = "Kotización"
         XcTpoO_C  = Elige(XcTpoO_C,2,42,3)
         XcTpoO_C  = LEFT(XcTpoO_C,2)
         @ 2,42 SAY space(8)
*!*	         DO CASE
*!*		        CASE  XcTpoO_C = [C]
*!*		            @ 2,42 SAY [Compra  ] 
*!*		        CASE XcTpoO_C = [S]
*!*		            @ 2,42 SAY [Servicio]
*!*		        OTHERWISE
*!*			        @ 2,42 SAY [Cotización]
*!*	        ENDCASE  
		 =Elige(XcTpoO_C,2,42,3,.T.)
      CASE i = 1 AND !EMPTY(XsCodRef)  AND .F. && solo pinta
         IF XcTpoO_C = [C]
            @ 2,42 SAY [Compra  ]
         ELSE
            @ 2,42 SAY [Servicio]
         ENDIF
         UltTecla = Enter
      CASE i = 2
         @ 1,65 GET XdFchOrd PICT "RD DD/MM/AAAA"
         READ
         UltTecla = LASTKEY()
         @ 1,65 SAY XdFchOrd PICT "RD DD/MM/AAAA"
         IF m.Crear
            XsMesCon = 'Mes'+SUBS(DTOC(XdFchOrd),4,2)
            XiNroDoc  = RIGH(XsMesCon,2)+PADL(DOCM->&XsMesCon.,4,'0')
            XsNroOrd = XcTipo + TRANSF(XiNroDoc,"@L 999999")
            m.NroOrd = XsNroOrd
            XyNroOrd = XsNroOrd
            @ 1,15 SAY XsNroOrd PICT "@R !-!!!!!!"
         ELSE
            IF VAL(SUBS(XsNroOrd,2,2)) # MONTH(XdFchOrd)
               GsMsgErr = [Fecha no corresponde al N£mero de O/C modificada ]
               DO LIB_MERR WITH 99
               LOOP
            ENDI
         ENDI

      CASE i = 3 AND .F.
         * 2,15 GET XsNroOr2
         *READ
         *@ 2,15 SAY XsNroOr2
         *
         VecOpc(1) = "Insumos  "
         VecOpc(2) = "Repuestos"
         XcTpoBie  = Elige(XcTpoBie,2,15,2)
         XcTpoBie  = LEFT(XcTpoBie,1)
         @ 2,15 SAY space(9)
         IF XcTpoBie = [I]
            @ 2,15 SAY [Insumos  ]
*!*	            sele catg
*!*	            use
*!*	            sele 0
*!*	            USE LsPathDb2+'ALMCATGE' ORDER CATG01 ALIAS CATG
*!*	            IF !USED()
*!*	               CLOSE DATA
*!*	               RETURN
*!*	            ENDIF
*!*	            *
*!*	            sele cata
*!*	            use
*!*	            sele 0
*!*	            USE LsPathDb2+'ALMCATAL' ORDER CATA01 ALIAS CATA
*!*	            IF !USED()
*!*	               CLOSE DATA
*!*	               RETURN
*!*	            ENDIF
*!*	            *
*!*	            sele divf
*!*	            use
*!*	            sele 0
*!*	            use lspathdbf+'almtdivf' order divf01  alias divf
*!*	            if !used()
*!*	               close data
*!*	               return
*!*	            endif
*!*	            *
         ELSE
            @ 2,15 SAY [Repuestos]
*!*	              sele catg
*!*	              use
*!*	              sele 0
*!*	              USE LsPathDb3+'ALMCATGE' ORDER CATG01 ALIAS CATG
*!*	              IF !USED()
*!*	                 CLOSE DATA
*!*	                 RETURN
*!*	              ENDIF
*!*	              *
*!*	              SELE cata
*!*	              use
*!*	              sele 0
*!*	              USE LsPathDb3+'ALMCATAL' ORDER CATA01 ALIAS CATA
*!*	              IF !USED()
*!*	                 CLOSE DATA
*!*	                 RETURN
*!*	              ENDIF
*!*	              *
*!*	              sele divf
*!*	              use
*!*	              sele 0
*!*	              use lspathdb4+'almtdivf' order divf01  alias divf
*!*	              if !used()
*!*	                 close data
*!*	                 return
*!*	              endif
         ENDIF
         UltTecla = Enter
         *
      CASE i = 4
         GsMsgErr = "[Esc] Cancelar   [Enter] Aceptar   [F8] Consulta   [] Anterior"
         DO lib_mtec WITH 99
         SELE PROV
         @ 3,15 GET XsCodAux PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF EMPTY(XsCodAux) .OR. UltTecla = F8
            IF ! cmpbusca("PROV")
               LOOP
            ENDIF
            XsCodAux = PROV->CodAux
         ENDIF
         @ 3,15 SAY XsCodAux
         IF XsCodAux = [112699]    && Varios
            @ 2,65 GET XsRucAux PICT "@!"
            @ 3,28 GET XsNomAux PICT "@!"
            @ 4,15 GET XsDirAux PICT "@!S38"
            @ 4,65 GET XsTlfAux PICT "@!S12"
            READ
            UltTecla = LASTKEY()
         ELSE
            SEEK GsClfPro+XsCodAux
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            IF LEFT(XsNroOrd,1) # LEFT(PROV.TpoAux,1)
*!*	               GsMsgErr = [Proveedor no corresponde al indicador Nacional/Importaci¢n]
*!*	               DO lib_merr WITH 99
*!*	               LOOP
            ENDI
            XsRucAux = RucAux
            XsNomAux = NomAux
            XsDirAux = DirAux
            XsTlfAux = TlfAux
         ENDIF
         @ 2,65 SAY XsRucAux
         @ 3,15 SAY XsCodAux
         @ 3,28 SAY XsNomAux
         @ 4,15 SAY XsDirAux PICT "@S38"
         @ 4,65 SAY XsTlfAux PICT "@S12"
      CASE i = 5
         @ 4,15 GET XsDirAux PICT "@!S38"
         READ
         UltTecla = LASTKEY()
         @ 4,15 SAY XsDirAux PICT "@!S38"
      CASE i = 6
         @  6,19 GET XsNroCot PICT "@!"
         READ
         UltTecla = LASTKEY()
         @  6,19 SAY XsNroCot PICT "@!"
*!*	      CASE i = 7 AND LEFT(XsNroOrd,1)='I'
*!*	         @ 6,42 GET XsCotImp PICT "@(S13)"
*!*	         READ
*!*	         UltTecla = LASTKEY()
*!*	         @ 6,42 SAY XsCotImp PICT "@(S13)"
      CASE i = 7 && 
      	 SELECT tabl
      	 XsTabla='MQ'
         @ 6,42 GET XsMaquina PICT "@S2"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8 
         	XsTabla='MQ'
            IF ! cmpbusca("TABL")
               UltTecla = 0
               LOOP
            ENDIF
            XsMaquina = PADR(TABL->Codigo,LEN(VORD.Maquina))
         ENDIF
         IF SEEK(XsTabla+XsMaquina,'TABL')
	         @ 6,42 SAY XsMaquina +' '+LEFT(TABL.Nombre,20)         
	     ELSE
	         @ 6,42 SAY XsMaquina +' '+SPACE(20)
	     ENDIF    
	     
	     
      CASE i = 8
         DO LIB_MTEC WITH 16
         IF XcTipo = 'N'
            VecOpc(1)="S/."
            VecOpc(2)="US$"
           *XiCodMon= Elige(XiCodMon,6,65,2)
            XiCodMon= Elige(XiCodMon,6,75,2)
         ELSE
            VecOpc(1)="S/."    && NUEVOS SOLES
            VecOpc(2)="US$"		&& DOLAR AMERICANO
            VecOpc(3)="CAN$"	&& DOLAR CANADIENSE
            VecOpc(4)="DM"		&& MARCO ALEMAN
            VecOpc(5)=[FS]		&& FRANCO SUIZO
            VecOpc(6)=[LS]		&& LIBRA ESTERLINA
           *XiCodMon= Elige(XiCodMon,6,65,6)
            XiCodMon= Elige(XiCodMon,6,75,6)
         ENDIF
      CASE i = 9
         GsMsgErr = "[Esc] Cancelar   [Enter] Aceptar   [F8] Consulta   [] Anterior"
         DO lib_mtec WITH 99
        *SELE CTBL
        *XsTabla = "01"
        *@  7,19 GET XsCndPgo PICT "@!S25"
        *READ
        *UltTecla = LASTKEY()
        *IF UltTecla = F8
        *   IF !cmpbusca("TABL")
        *      UltTecla = 0
        *      LOOP
        *   ENDIF
        *   XsCndPgo = CTBL->Nombre
        *   XiDiaEnt = VAL(SUBSTR(CTBL->CODIGO,2,2))
        *ENDIF
        *@ 7,19 SAY XsCndPgo PICT "@S25"
        *
        SELE TBFP
        @ 07,19 get xsfmapgo PICT "9999" valid vTipDoc()
        READ
        XsCndPgo = tbfp.desfpag
        @ 07,24 say left(XsCndPgo,40)
        UltTecla = LASTKEY()
        XiDiaEnt = tbfp.nDVcto1 + tbfp.DifVcto
        @  8,19 SAY XiDiaEnt PICT "999"
        *
      case i = 10 AND .F.
         @  7,74 GET XiTasa   PICT "99.99"
         READ
         UltTecla = LASTKEY()
         @  7,74 say XiTasa   PICT "99.99"
        *
      CASE i = 11 AND .F.
        *@  7,65 GET XiDiaEnt PICT "999"
         @  8,19 GET XiDiaEnt PICT "999"
         READ
         UltTecla = LASTKEY()
        *@  7,65 SAY XiDiaEnt PICT "999"
         @  8,19 SAY XiDiaEnt PICT "999"
        *
      CASE i = 12 AND .f.
         DO LIB_MTEC WITH 16
         VecOpc(1)="No"
         VecOpc(2)="Si"
         XsPagAde = Elige(XsPagAde,8,39,2)
         XsPagAde = LEFT(XsPagAde,1)
         @ 08,39 SAY space(02)
         @ 08,39 say iif(XsPagAde=[S],[S¡],[No])
        *
      CASE i = 13
         @  9,19 GET XdFchEnt  PICT "RD DD/MM/AAAA"
         READ
         UltTecla = LASTKEY()
         @  9,19 SAY XdFchEnt  PICT "RD DD/MM/AAAA"
      CASE i = 14 AND LEFT(XsNroOrd,1)='N'
      	SELECT TABL
      	 XsTabla='LE'
         @ 9,46 GET XsLugEnt 
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8  && OR EMPTY(XsLugEnt)
         	XsTabla='LE'
            IF ! cmpbusca("TABL")
               UltTecla = 0
               LOOP
            ENDIF
            XsLugEnt = PADR(TABL->Codigo,LEN(VORD.LugEnt))
         ENDIF
         IF SEEK(XsTabla+XsLugEnt,'TABL')
	         @ 9,46 SAY XsLugEnt +' '+LEFT(TABL.Nombre,20)         
	     ELSE
             @ 9,46 SAY XsLugEnt +' '+SPACE(20)         
	     ENDIF    
	           
*!*	         Vecopc(1) = 'San Isidro'
*!*	         Vecopc(2) = 'Vulcano   '
*!*	         Vecopc(3) = 'Ca¤ete    '
*!*	         XsLugEnt = ELIGE(XsLugEnt,9,46,3)
*!*	         UltTecla = LASTKEY()
      CASE i = 15 AND LEFT(XsNroOrd,1)='N' AND .F.
         Vecopc(1) = 'S¡'
         Vecopc(2) = 'No'
         XsPrueba = ELIGE(XsPrueba,9,75,2)
         UltTecla = LASTKEY()
      CASE i = 16 && AND .f.
         SAVE SCREEN
         DO lib_mtec WITH 99
         @  7,10 TO 18,63 clear
         @  7,10 TO 18,63 DOUBLE
         IF LEFT(XsNroOrd,1)='N'
            @  8,15 SAY 'Referencia  : ' GET XsRefere PICT '@!'
            @  9,15 SAY 'Tmp.Entrega : ' GET XsTmpEnt PICT '@!'
            READ
            UltTecla = LAST()
            IF UltTecla # escape_
               @ 11,12 SAY "SEND TO : (3 PRIMERAS LINEAS SALEN IMPRESAS EN O/C)"
               @ 12,11 EDIT XsGloDoc SIZE 6,52 COLOR SCHEME 7
               READ
            ENDI
         ELSE
            @  8,11 SAY "SEND TO : (LAS 7 PRIMERAS LINEAS CORRESPONDEN A    "
            @  9,11 SAY "DESCRIPCIONES DE IMPORTACION LA 8va. A OBSERVACION)"  && la 7ma. a Marca
            @ 10,11 EDIT XsGloDoc SIZE 8,52 COLOR SCHEME 7
            READ
         ENDI
         UltTecla = LASTKEY()
         @  8,11 EDIT XsGloDoc SIZE 5,52 DISABLE
         RESTORE SCREEN
      CASE I = 17
        IF XcTipo = [I]
	    	do DatAdic
		ENDIF			
      CASE i = 18
         DO xBrowse

      CASE i = 19
         IF XcTipo = [N]
            DO xDatoNac
         ELSE
            DO xDatoImp
         ENDIF
         DO xRegenera
      CASE i = 20
         ***** CHEQUEOS ********
         SELE PROV
         IF XsCodAux = [9]    && Varios
         ELSE
            SEEK GsClfPro+XsCodAux
            IF ! FOUND()
               I = 2
               DO lib_merr WITH 6
               LOOP
            ENDIF
         ENDIF
         GsMsgErr1 = ""
         GsMsgErr2 = ""
         FOR IX = 1 TO GiTotItm
            IF AfPreUni(iX) <= 0
               GsMsgErr1 = IIF(GsMsgErr1=="","",",")+ALLTRIM(STR(IX,3,0))
            ENDIF
            IF AfCanPed(iX) <= 0
               GsMsgErr2 = IIF(GsMsgErr2=="","",",")+ALLTRIM(STR(IX,3,0))
            ENDIF
         NEXT
         IF ! EMPTY(GsMsgErr2)
            i = 12
            GsMsgErr = "Invalidas Cantidades en los Item "+GsMsgErr2
            DO LIB_MERR WITH 99
            *LOOP
         ENDIF
         IF ! EMPTY(GsMsgErr1)
            GsMsgErr = "Precio Unitario Errados en los Item "+GsMsgErr1
            DO LIB_MERR WITH 99
         ENDIF
         IF GiTotItm <= 0
            GsMsgErr = "O/C sin Items "
            DO LIB_MERR WITH 99
            UltTecla = escape_
            EXIT
         ENDIF
         cResp = [N]
         cResp = aviso(12,[Datos Correctos (S-N)?],[],[],3,[SN],0,.F.,.F.,.T.)
         IF cResp = [N]
            i = i - 2
            LOOP
         ENDIF
         UltTecla = Enter
         EXIT
   ENDCASE
   IF i = 20 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1 , 3,i)
   i = IIF(i>20,20,i)
ENDDO
IF UltTecla # escape_
   DO xGraba
ENDIF
SELE VORD
UNLOCK ALL
DO lib_mtec WITH 0

RETURN
************************************************************************ FIN()
* Pedir Informacion O/C Nacional
******************************************************************************
PROCEDURE xDatoNac

SAVE SCREEN TO LsPan02
DO xPieNac
DO xRegenera
UltTecla = 0
PRIVATE u
u = 1
GsMsgKey = " [] [] Seleccionar  [Enter] Aceptar [Esc] Anterior [F10] Aceptar Todo [F9] En Blanco"
DO LIB_MTEC WITH 99
DO WHILE ! INLIST(UltTecla,escape_,CtrlW)
   DO CASE
      CASE u = 1
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,15 GET XfImpFle     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,15 SAY XfImpFle     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 2
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,38 GET XfImpOtr     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,38 SAY XfImpOtr     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 3
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,54 GET XfPorIgv     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,54 SAY XfPorIgv     PICT "99999,999.99"
         POP KEY
         DO xRegenera
   ENDCASE
   IF u = 3  .AND. UltTecla = Enter
      EXIT
   ENDIF
   u = IIF(INLIST(UltTecla,Arriba,BackTab),u-1,u+1)
   u = IIF(u < 1, 1,u)
   u = IIF(u > 3, 3,u)
ENDDO
IF INLIST(UltTecla,Arriba,escape_,BackTab)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF

RETURN
************************************************************************ FIN()
* Pedir Informacion O/C Importaci¢n
******************************************************************************
PROCEDURE xDatoImp

SAVE SCREEN TO LsPan02
DO xPieImp
DO xRegenera
UltTecla = 0
PRIVATE u
u = 1
GsMsgKey = " [] [] Seleccionar  [Enter] Aceptar [Esc] Anterior [F10] Aceptar Todo [F9] En Blanco"
DO LIB_MTEC WITH 99
DO WHILE ! INLIST(UltTecla,escape_,CtrlW)
   DO CASE
      CASE u = 1
         VecOpc(1) = [A]
         VecOpc(2) = [M]
         XcTipFle = ELIGE(XcTipFle,19,11,2)
         UltTecla = LAST()
         @ 19,11 SAY XcTipfle
      CASE u = 2
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 19,14 GET XfImpFle     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 19,14 SAY XfImpFle     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 3
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,14 GET XfImpSeg     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,14 SAY XfImpSeg     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 4
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 18,39 GET XfImpIns     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 18,39 SAY XfImpIns     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 5
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 19,39 GET XfImpHan     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 19,39 SAY XfImpHan     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 6
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,39 GET XfImpAdv     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,39 SAY XfImpAdv     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 7
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 21,39 GET XfImpMtt     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 21,39 SAY XfImpMtt     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 8
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 18,67 GET XfImpAdm     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 18,67 SAY XfImpAdm     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 9
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 19,67 GET XfImpAdu     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 19,67 SAY XfImpAdu     PICT "99999,999.99"
         POP KEY
         DO xRegenera
      CASE u = 10
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ 20,67 GET XfImpOtr     PICT "99999,999.99"
         READ
         UltTecla = LASTKEY()
         @ 20,67 SAY XfImpOtr     PICT "99999,999.99"
         POP KEY
         DO xRegenera
   ENDCASE
   IF u = 10  .AND. UltTecla = Enter
      EXIT
   ENDIF
   u = IIF(INLIST(UltTecla,Arriba,BackTab),u-1,u+1)
   u = IIF(u < 1, 1,u)
   u = IIF(u >10,10,u)
ENDDO
IF INLIST(UltTecla,Arriba,escape_,BackTab)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
RETURN
************************************************************************ FIN()
* Cargar variables
******************************************************************************
PROCEDURE xMover

SELE VORD
XsNroOrd = NroOrd
XcTipo   = LEFT(NroOrd,1)
XdFchOrd = FchOrd
XsCodAux = CodAux
XsRucAux = RucAux
XsNomAux = NomAux
XsDirAux = DirAux
XsTlfAux = TlfAux
XsNroCot = NroCot
XiDiaEnt = DiaEnt
XsCndPgo = left(CndPgo,40)
*
XsFmaPgo = FmaPgo
XsPagAde = PagAde
XiTasa   = Tasa
*
XsNroCot = NroCot
XsNroOr2 = NroOr2
XsCotImp = CotImp
XsMaquina = Maquina
XsRefere = Refere
XsTmpEnt = TmpEnt

XsUsuario= Usuario
XsCodRef = CodRef
XcTpoO_C = TpoO_C
XcTpoBie = iif(TpoBie=[ ],[I],TpoBie)

XiCodMon = CodMon
XfPorIgv = PorIgv
XfPorDto = PorDto
XfImpBto = ImpBto
XfImpDto = ImpDto
XfImpInt = ImpInt
XfImpAdm = ImpAdm
XfImpIgv = ImpIgv
XfImpNet = ImpNet
XsGloDoc = GloDoc
XdFchEnt = FchEnt
XsLugEnt = LugEnt
XsPrueba = VAL(Prueba)
XsMarcas = Marcas
XcFlgEst = FlgEst
XcTpoCmp = TpoCmp
** para importaci¢n **
XfImpFob = ImpFob
XcTipFle = TipFle
XfImpFle = ImpFle
XfImpSeg = ImpSeg
XfImpCif = ImpCif
XfImpAdv = ImpAdv
XfImpAdm = ImpAdm
XfImpHan = ImpHan
XfImpPap = ImpPap
XfImpAdu = ImpAdu
XfImpMtt = ImpMtt
XfImpIns = ImpIns
XfImpOtr = ImpOtr
XnFpgFlt = FpgFlt
XdFchLle = FchLle
XdFchEmb = FchEmb
XnDPrev  = NDPrev
** cargamos arreglos **
DO xBmove
*
SELE VORD

RETURN
************************************************************************ FIN()
* Inicializamos Variables
******************************************************************************
PROCEDURE xInvar

SELE VORD

XdFchOrd = GdFecha
XsCodAux = SPACE(LEN(CodAux))
XsNomAux = SPACE(LEN(NomAux))
XsRucAux = SPACE(LEN(RucAux))
XsDirAux = SPACE(LEN(DirAux))
XsTlfAux = SPACE(LEN(TlfAux))
XsNroCot = SPACE(LEN(NroCot))
XsNroOr2 = SPACE(LEN(NroOr2))
XsCotImp = SPACE(LEN(CotImp))
XsMaquina = SPACE(LEN(Maquina))
XiDiaEnt = 0
*XsCndPgo = SPACE(LEN(CndPgo))
XsCndPgo = SPACE(40)
*
XsFmaPgo = space(len(FmaPgo))
XiTasa   = 0
*
XiCodMon = 1
IF VARTYPE(CFGADMIGV)='U'
	XfPorIgv = 19
ELSE
	XfPorIgv = CFGADMIGV
ENDIF

XfPorDto = 0
XfPorDto1= 0
XfPorDto2= 0
XfPorDto3= 0
XfImpBto = 0
XfImpDto = 0
XfImpDto1= 0
XfImpDto2= 0
XfImpDto3= 0
XfImpInt = 0
XfImpAdm = 0
XfImpIgv = 0
XfImpNet = 0
XsGloDoc = []
IF XcTipo=[I]
	XsGloDoc=[I]+RIGHT(STR(_ANO,4,0),2)+SUBSTR(XsNroOrd,2,2)+RIGHT(XsNroOrd,2)+[, AESA, ]+[CALLAO-PERU]
ENDIF 
XsFchEnt = []
XsLugEnt = SPACE(LEN(VORD.LugEnt))
XsPrueba = 2
XsMarcas = []
XsRefere = SPAC(LEN(VORD.Refere))
XsTmpEnt = SPAC(LEN(VORD.TmpEnt))
XcFlgEst = [E]    && Emitido, Cerrado, Anulado
XcTpoCmp = [N]    && NO inluido el igv
***
XsUsuario= SPACE(LEN(usuario))
XsCodRef = SPACE(LEN(CodRef))
XcTpoO_C = [C]    && Orden de Compra
XcTpoBie = [I]
STORE 0 TO XfImpFle,XfImpSeg,XfImpAdv,XfImpPap,XfImpOtr,XfImpCif
STORE 0 TO XfImpHan,XfImpIns,XfImpAdm,XfImpFob
STORE 0 TO XfImpAdu,XfImpMtt
STORE [A] TO XcTipFle

XnFpgFlt = 1
*XdFchLle = {,,}
*XdFchEmb = {,,}
store {} to xdfchlle, xdfchemb
XnDPrev  = 0
** Variables del Browse **
STORE SPACE(LEN(RORD->NroReq)) TO AsNroReq
STORE SPACE(LEN(RORD->TpoReq)) TO AcTpoReq
*
STORE SPACE(LEN(RORD->TpoBie)) TO AcTpoBie
*
STORE SPACE(LEN(RORD->CodMat)) TO AsCodMat
STORE SPACE(LEN(RORD->DesMat)) TO AsDesMat
STORE SPACE(LEN(CATG->Marca )) TO AsMarca
STORE SPACE(LEN(RORD->UndCmp)) TO AsUndCmp
STORE 1                        TO AfFacEqu
STORE 0                        TO AsPeso
STORE 0                        TO AfPreUni
STORE 0                        TO AfPreFob
STORE 0                        TO AfPorDto
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

SELE VORD
@  1,15 SAY NroOrd PICT "@R !-999999"
*@  2,42 SAY IIF(TpoO_C=[S],[Servicio],[Compra  ])
DO CASE
    CASE  TpoO_C = [C]
        @ 2,42 SAY [Compra    ] 
    CASE TpoO_C = [S]
        @ 2,42 SAY [Servicio  ]
    OTHERWISE
        @ 2,42 SAY [Cotización]
ENDCASE  
 VecOpc(1) = "Compra  "
 VecOpc(2) = "Servicio"
 VecOpc(3) = "Kotización"

=Elige(TpoO_C,2,42,3,.t.)

@  1,65 SAY FchOrd	PICT "RD DD/MM/AAAA"
@  2,15 SAY NroOr2
@  2,65 SAY RucAux
@  3,15 SAY CodAux PICT "@!"
@  3,28 SAY NomAux
@  4,15 SAY DirAux
@  4,67 SAY TlfAux PICT "@S12"
@  6,19 SAY NroCot PICT "@!"

IF LEFT(NroOrd,1)#[N]
  *@  6,0  SAY "Ý  No Cotizacion :             No Cot.Imp :             Moneda :               Ý"
   @  6,0  SAY "Ý  No.Cotizacion :             No Cot.Imp :                       Moneda :        Ý"
   @  6,42 SAY CotImp PICT '@(S13)'
ELSE
  *@  6,0  SAY "Ý  No Cotizacion :                                      Moneda :               Ý"
   @  6,0  SAY "Ý Sol.Cotizacion :             Refere.:                           Moneda :        Ý"
*   @  6,42 SAY SPAC(8)
ENDIF
@  6,42 SAY TRIM(Maquina)+' ' + IIF(SEEK('MQ'+Maquina,'TABL'),LEFT(TABL.NOMbre,20),SPACE(20))
*@  7,19 SAY CndPgo PICT "@!S25"
*@  6,65 SAY IIF(CodMon=1,'S/.','US$')
*@  7,65 SAY DiaEnt PICT "999"
@  6,75 SAY IIF(CodMon=1,'S/.','US$')
@  7,19 say Fmapgo
@  7,24 SAY CndPgo PICT "@!S40"
*!*	@  7,74 SAY tasa   PICT "99.99"
@  8,19 SAY DiaEnt PICT "999"
*!*	@  8,39 say iif(PagAde=[S],[S¡],[No])
@  9,19 SAY FchEnt PICT "RD DD/MM/AAAA"
*!*	@  9,46 SAY IIF(LugEnt='1','San Isidro', IIF(LugEnt='2','Vulcano   ','Ca¤ete    '))
@  9,46 SAY LugEnt+' ' + IIF(SEEK('LE'+LugEnt,'TABL'),LEFT(TABL.NOMbre,20),SPACE(20))
*!*	@  9,75 SAY IIF(Prueba='1', 'S¡', 'No')
IF LEFT(NroOrd,1)=[N]
   DO xPieNac
ELSE
   DO xPieImp
ENDIF
SELE RORD
SEEK VORD->NroOrd
NumLin = 13
@ 13,1 CLEAR TO 16,78
SCAN WHILE NroOrd=VORD->NroOrd .AND. NumLin <= 16
   @ NumLin,1  SAY NroReq PICT "@R 9999-999"
   @ NumLin,10 SAY TpoReq
   @ NumLin,12 SAY CodMat PICT "@!"
   @ NumLin,34 SAY UndCmp
   @ NumLin,38 SAY CanPed PICT "999,999.99"
   IF LEFT(NroOrd,1)=[N]
      @ NumLin,49 SAY PreUni PICT "999999.99999"
      @ NumLin,62 SAY PorDto PICT "999.99"
   ELSE
      @ NumLin,48 SAY PreFob PICT "99999.9999"
      @ NumLin,58 SAY PreUni PICT "99999.9999"
   ENDIF
   @ NumLin,69 SAY ImpLin PICT "9999999.99"
   NumLin = NumLin + 1
ENDSCAN
IF VORD->FlgEst=[A]
   NumLin = 13
   @ Numlin ,02 SAY []
   @ ROW()  ,02 SAY "          #      ##  #    #   #    #          #      #####     ######   "
   @ ROW()+1,02 SAY "        #####    # # #    #   #    #        #####    #    #    #    #   "
   @ ROW()+1,02 SAY "        #   #    #  ##    #####    ####     #   #    #####     ######   "
ENDIF
* *
SELE VORD
IF LEFT(NroOrd,1) = [N]  &&Nacional
   *@ 19,26 SAY ImpBto-ImpDto PICT "99999,999.99" COLOR SCHEME 7
   @ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                   Ý"
   @ 20,0  SAY "Ý Imp.Flete :             Otro Gast.:             IGV.      % :                   Ý"
   @ 21,0  SAY "Ý                                          Precio Venta Total :                   Ý"
   @ 19,15 SAY ImpBto  PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,38 SAY ImpDto  PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,65 SAY ImpBto-ImpDto PICT "99999,999.99" COLOR SCHEME 7
   @ 20,15 SAY ImpFle  PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,38 SAY ImpOtr  PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,54 SAY PorIgv  PICT "99.99"        COLOR SCHEME 7
   @ 20,65 SAY ImpIgv  PICT "99999,999.99" COLOR SCHEME 7
   @ 21,65 SAY ImpNet  PICT "99999,999.99" COLOR SCHEME 7
ELSE
   @ 18,14 say impfob        pict "99999,999.99" color scheme 7
   @ 19,11 say tipfle        pict "!" color scheme 7
   @ 19,14 say impfle        pict "99999,999.99" color scheme 7
   @ 20,14 say impseg        pict "99999,999.99" color scheme 7
   @ 21,14 say impcif        pict "99999,999.99" color scheme 7
   @ 18,39 say impins        pict "99999,999.99" color scheme 7
   @ 19,39 say imphan        pict "99999,999.99" color scheme 7
   @ 20,39 say impadv        pict "99999,999.99" color scheme 7
   @ 21,39 say impMtt        pict "99999,999.99" color scheme 7
   @ 18,67 say impadm        pict "99999,999.99" color scheme 7
   @ 19,67 say impadu        pict "99999,999.99" color scheme 7
   @ 20,67 say impotr        pict "99999,999.99" color scheme 7
   @ 21,67 SAY ImpNet        PICT "99999,999.99" COLOR SCHEME 7
ENDIF

RETURN
************************************************************************ FIN()
* Borrar Informacion
******************************************************************************
PROCEDURE xBorrar

SELE VORD
IF FlgEst = 'A'
	IF MESSAGEBOX("Desea Borrar el registro por completo ?",32+4,'**** ATENCION ****')=6
			IF !RLOCK()
				=MESSAGEBOX("Registro Bloqueado por otro usuario",0, 'AVISO!!!')
				RETURN
			ENDIF
			DELETE
	ENDIF
*!*	   GsMsgErr = [ Registro Anulado ]
*!*	   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = 'C'
   GsMsgErr = [ O/C Completo. Ingresado a Almacen]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF !Modifica()
   GsMsgErr = [ O/C Parcialmente Atendida ]
   DO lib_merr WITH 99
   RETURN
ENDIF
SELECT VORD
IF ! RLOCK()
   RETURN
ENDIF
** anulamos detalles **
SELE RORD
SEEK VORD->NroOrd
DO WHILE NroOrd=VORD->NroOrd .AND. ! EOF()
   IF ! RLOCK()
      LOOP
   ENDIF
   ** desactualiza Requerimiento **
   IF !EMPTY(RORD.NroReq)
	   SELE VREQ
	   SEEK LEFT(RORD->Usuario,LEN(VREQ.Usuario))+RORD->NroReq
	   IF !REC_LOCK(5)
	      SELE RORD
	      LOOP
	   ENDIF
	   REPLACE VREQ.CanPed WITH VREQ.CanPed - RORD->CanPed
	   IF CanPed <= 0
	      REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
	   ELSE
	      REPLACE VREQ->FlgEst WITH [R]    && Con O/Compra
	   ENDIF
	   REPL NroO_C WITH SPAC(LEN(XsNroOrd))
	   REPL FchO_C WITH {}
	   IF (CanPed+CanDes) >= CanReq
	      REPLACE FlgLog WITH [H]
	   ELSE
	      REPLACE FlgLog WITH IIF(VREQ.FlgEst=[O], [H], [R])
	      REPLACE FlgHis WITH [R]
	   ENDIF
	   UNLOCK
   ENDIF
   SELE RORD
   * Proceso que permite eliminar el precio grabado en el archivo hist¢rico
   ** DO Eli_precio && Fuera piojos 17/03/98
   SELE RORD
   DELETE
   UNLOCK
   SKIP
ENDDO
* * * *
*!*	SELE SIMP
*!*	SEEK VORD.NroOrd
*!*	IF FOUND() AND RLOCK()
*!*	   DELETE
*!*	   UNLOCK
*!*	ENDIF
*!*	IF !EMPTY(VORD.NroCot)
*!*	   IF SEEK (ALLT(VORD.NroCot), 'VCOT')
*!*	      REPL VCOT.FlgEst WITH [E]
*!*	   ENDI
*!*	ENDI
SELE VORD
REPLACE FlgEst WITH [A]
UNLOCK
SKIP

RETURN
************************************************************************ FIN()
* Browse de Datos
****************************************************************************
PROCEDURE xBrowse

**
EscLin   = "xBline"
IF EMPTY(XsCodRef)
   EdiLin   = "xBedit1"
   InsLin   = "xBinse1"
ELSE
   EdiLin   = "xBedit2"
   InsLin   = "xBinse2"
ENDIF
BrrLin   = "xBborr"
PrgFin   = []
*
Yo       = 12
Xo       = 0
Largo    = 6
Ancho    = 83
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
IF INLIST(UltTecla,escape_)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
DO lib_mtec WITH 0
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE xBline
PARAMETERS NumEle, NumLin

@ NumLin,1  SAY AsNroReq(NumEle) PICT "@R 9999999"
@ NumLin,10 SAY AcTpoReq(NumEle)
@ NumLin,12 SAY AsCodMat(NumEle) PICT "@!" 
@ NumLin,34 SAY AsUndCmp(NumEle)
@ NumLin,38 SAY AfCanPed(NumEle) PICT "999,999.99"
IF LEFT(XsNroOrd,1)=[N]
   @ NumLin,49 SAY AfPreUni(NumEle) PICT "999999.999"
   @ NumLin,62 SAY AfPorDto(NumEle) PICT "999.99"
ELSE
   @ NumLin,48 SAY AfPreFob(NumEle) PICT "9999999.99"
   @ NumLin,58 SAY AfPreUni(NumEle) PICT "9999999.99"
ENDIF
@ NumLin,70 SAY AfImpLin(NumEle) PICT "999999.99"
@ 18,3 say AsDesMat(NumEle) pict [@S55]
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE xBedit1
PARAMETERS NumEle, NumLin
SAVE SCREEN TO TMP
** NOTA >> solo se permite modificar mas no crear
IF AcTpoReq(NumEle) $ "R|N|A|S"  && Reposicion de Stock
   @ 18,01 CLEAR TO 21,78
  *@ 19,03 EDIT AsDesMat(NumEle) SIZE 1,45 DISABLE
  *@ 19,03 say AsDesMat(NumEle) pict [@S45]
   @ 18,03 say LEFT(AsDesMat(NumEle),45)
   @ 18,50 SAY AsMarca(NumEle)  PICT "@S15"
   IF AcTpoReq(NumEle) = [R]
      SELE CATA
      SET ORDER TO CATA02
      XfStkAct = 0
      XfVCtoMn = 0
      XfVCtoUs = 0
      XfPctoMn = 0
      XfPctoUS = 0
      SEEK AsCodMat(NumEle)
      SCAN WHILE CODMAT = AsCodMat(NumEle)
         XfStkAct = XfStkAct + StkAct
         *XfVCtoMn = XfVCtoMn + VCtoMn   && No se encuentra actualizado en linea
         *XfVCtoUs = XfVCtoUs + VCtoUs
      ENDSCAN
      IF XfStkAct <> 0
         *XfPctoMn =  XfVCtoMn / XfStkAct
         *XfPctoUS =  XfVCtoUS / XfStkAct
         XfPctoMn =  CATG->VCtoMn / XfStkAct
         XfPctoUS =  CATG->VCtoUS / XfStkAct
      ENDIF
      @ 20,3 SAY "Ultimo Precio de Compra : "
      @ 21,3 SAY "Precio Promedio Actual  : "
      IF XiCodMon = 1
         LfUltPre = ROUND(CATG->PULTMN * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoMn     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "S/."
         @ 21,29 SAY "S/."
      ELSE
         LfUltPre = ROUND(CATG->PULTUS * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoUS     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "US$"
         @ 21,29 SAY "US$"
      ENDIF
      @ 20,32 SAY LfUltPre PICT "@Z 999,999,999.99"
      @ 21,32 SAY LfPrcPmd PICT "999,999,999.99"
   ENDIF
ENDIF

PRIVATE i
i        = 1
UltTecla = 0
*
LsNroReq = AsNroReq(NumEle)
LcTpoReq = AcTpoReq(NumEle)
LsCodMat = AsCodMat(NumEle)
LsCodFam = LEFT(AsCodMat(NumEle),LEN(DIVF.CodFam))
LsCodMat1= RIGH(AsCodMat(NumEle),LEN(LsCodMat)-LEN(LsCodFam))
LsDesMat = left(AsDesMat(NumEle),60)
LsMarca  = AsMarca (NumEle)
LsUndCmp = AsUndCmp(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LsPeso   = AsPeso  (NumEle)
LfPreUni = AfPreUni(NumEle)
LfPreFob = AfPreFob(NumEle)
LfPorDto = AfPorDto(NumEle)
LfCanPed = AfCanPed(NumEle)
LfImpLin = AfImpLin(NumEle)
LiNumReg = AiNumReg(NumEle)
GsMsgKey = "[Izquierda] [Derecha] Mover   [Enter] Registra    [Esc] Cancela"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,escape_)
   GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela"
   DO lib_mtec WITH 99
   i = IIF(LsNroReq#SPAC(LEN(LsNroReq)).AND.i<3,3,i)
   DO CASE
      CASE i = 1 AND XcTpoO_C=[C]  && AND .f.
         DO lib_mtec WITH 18
         SAVE SCREEN
         @ NumLin-1,24 CLEAR TO NumLin+2,50
         @ NumLin-1,24 TO NumLin+2,50 DOUBLE
         @ NumLin,25 GET LcTpoReq PICT "@*RVT \<Reposicion de Stock;\<Activos"
         READ
         UltTecla = LASTKEY()
         RESTORE SCREEN
         IF INLIST(UltTecla,escape_,Arriba,Abajo)
            LOOP
         ENDIF
         LcTpoReq = LEFT(LcTpoReq,1)
         IF ! LcTpoReq $ "RA"
            LOOP
         ENDIF
         @ NumLin,10 SAY LcTpoReq

      CASE i = 1 AND !XcTpoO_C=[C]
         LcTpoReq = [S]
         @ NumLin,10 SAY LcTpoReq
         UltTecla = Enter
      CASE i = 2
         @ NumLin,1  SAY LsNroReq PICT "@R 9999999"
         @ NumLin,10 SAY LcTpoReq PICT "@!"
         GsMsgKey = "[] [] Mover   [Enter] Registra    [Esc] Cancela    [F8] Consulta"
         DO lib_mtec WITH 99
         SELE DIVF
         SET CONFIRM OFF
         @ NumLin,12 GET LsCodFam PICT "@!"
         READ
         UltTecla = LASTKEY()
         SET CONFIRM ON
         IF UltTecla = Arriba
            UltTecla = 0
            i = i - 1
         ENDIF
         IF UltTecla = escape_
            EXIT
         ENDIF
         IF UltTecla = F8 && .OR. EMPTY(LsCodFam)
            IF !cmpbusca("DIVF")
               UltTecla = 0
               LOOP
            ENDIF
            LsCodFam = CodFam
         ENDIF
         @ NumLin,12 SAY LsCodFam
         IF !EMPTY(LsCodFam)
			 SELECT DIVF
	         SEEK GAClfDiv(2)+LsCodFam
	         IF !FOUND()
	            DO lib_merr WITH 6
	            LOOP
	         ENDIF
	         IF DIVF.TipFam # 1
	            GsMsgErr = [ Familia no corresponde a Productos de Insumos ]
	            DO lib_merr WITH 99
	            LOOP
	         ENDIF
	         * pedimos segunda parte del codigo *
	         SELE CATG
	         @ NumLin,12+LEN(LsCodFam) GET LsCodMat1 PICT "@!"
	         READ
	         UltTecla = LASTKEY()
	         IF UltTecla = Arriba
	            UltTecla = 0
	            loop
	         ENDIF
	         IF UltTecla = escape_
	            EXIT
	         ENDIF

	         LsCodMat = LsCodFam+LsCodMat1
	         IF UltTecla = F8 .OR. EMPTY(LsCodMat1)
	            XsCodFam = LsCodFam
	            IF !cmpbusca("CATGF")
	               UltTecla = 0
	               LOOP
	            ENDIF
	            LsCodMat = CodMat
	            LsCodMat1= SUBST(LsCodMat,LEN(DIVF->CodFam)+1)
	         ENDIF

         ELSE
	         SELE CATG
	         SET FILTER TO 
	         @ NumLin,12 GET LsCodMat PICT "@!"
	         READ
	         UltTecla = LASTKEY()
	         IF UltTecla = Arriba
	            UltTecla = 0
	            loop
	         ENDIF
	         IF UltTecla = escape_
	            EXIT
	         ENDIF

	         *LsCodMat = LsCodFam+LsCodMat1
	         IF UltTecla = F8 .OR. EMPTY(LsCodMat)
	            XsCodFam = LsCodFam
	            IF !cmpbusca("MATEGE")
	               UltTecla = 0
	               LOOP
	            ENDIF
	            LsCodMat = CodMat
*!*		            LsCodMat1= SUBST(LsCodMat,LEN(DIVF->CodFam)+1)
*!*		            LsCodFam = LsCodMat1
				SET FILTER TO 
	         ENDIF
         
         ENDIF
         @ NumLin,12 SAY LsCodMat
         SEEK LsCodMat
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF
         IF LcTpoReq=[R]
            IF xRepite()
               GsMsgErr = [Dato ya Registrado]
               DO lib_merr WITH 99
               LOOP
            ENDIF
         ENDIF
         LsDesMat = CATG->DesMat      &&+[ ]+CATG->Descrip
         LsMarca  = CATG->Marca
         LsUndCmp = IIF(EMPTY(CATG->UndCmp), CATG->UndStk, CATG->UndCmp)
         LfFacEqu = IIF(EMPTY(CATG->UndCmp), 1, CATG->FacEqu)
         XsUndStk = CATG->UndStk
         **=SEEK(LsCodMat, 'PCAT')
         LsPeso   = CATG->Peso
         @ NumLin,34 SAY LsUndCmp PICT "@!"
      CASE i = 3 .AND. LcTpoReq # [R]   && Codigo Libre
        *@ 19,3 EDIT LsDesMat SIZE 1,60 COLOR SCHEME 7
         @ 18,3 get LsDesMat pict [@S55]
         READ
         UltTecla = LASTKEY()
         @ 18,3 say LsDesMat pict [@S55]

      CASE i = 3  AND  LcTpoReq =[R]
	      @ 18,3 say LsDesMat pict [@S55]
         UltTecla = Enter

      CASE i = 4 .AND. LcTpoReq $ "RAS"
         =SEEK(LsCodMat,"CATG")
         SELE TABL
         XsTabla = 'UD'
         XsUndStk = CATG->UndStk
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("TUND")
               UltTecla = 0
               LOOP
            ENDIF
            LsUndCmp = LEFT(TABL->Codigo,3)
            LfFacEqu = 1
         ENDIF
         @ NumLin,34 SAY LsUndCmp
         IF LsUndCmp # AsUndCmp(NumEle)
            IF CATG->UndCmp == LsUndCmp .AND. ! EMPTY(LsUndCmp)
               LfFacEqu = CATG->FACEQU
            ELSE
               IF CATG->UndStk == LsUndCmp
                  LfFacEqu = 1
               ELSE
                  LfFacEqu = 1
                  SELE EQUN
                  SEEK XsUndStk+LsUndCmp
                  IF FOUND()
                     LfFacEqu = FACEQU
                  ENDIF
               ENDIF
            ENDIF
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 4   .AND. !LcTpoReq $ "RAS"
         LsUndCmp = AsUndCmp(NumEle)  &&  xsundstk
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("EQUN")
               LOOP
            ENDIF
            LsUndCmp = UndVta
            LfFacEqu = FacEqu
         ENDIF
         @ NumLin,34 SAY LsUndCmp

         IF LsUndCmp # AsUndCmp(NumEle)
            SEEK XsUndStk+LsUndCmp
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            LfFacEqu = FACEQU
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 5
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ NumLin,38 GET LfCanPed PICT "999,999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,38 SAY LfCanPed PICT "999,999.99"
         POP KEY

      CASE i = 6
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 GET LfPreUni PICT "999999.99999" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
         ELSE
            @ NumLin,48 GET LfPreFob PICT "99999.9999" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         POP KEY

      CASE i = 7
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,62 GET LfPorDto PICT "999.99" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
            UltTecla = Enter
         ENDIF
      CASE i = 8
         IF LfCanPed > 0
            LfImport = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)
         ELSE
            LfImport = ROUND(LfPreUni,2)
         ENDIF
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ NumLin,69 GET LfImport PICT "9999999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,69 SAY LfImport PICT "9999999.99"
         POP KEY
         *IF LfCanPed > 0
         *   LfPreUni = LfImport/(LfCanPed*(1-LfPorDto/100))
         *ELSE
         *   LfPreUni = LfImport
         *ENDIF
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         @ NumLin,69 SAY LfImport PICT "9999999.99"
   ENDCASE
   IF i = 8 .AND. inlist(UltTecla ,Enter,aBAJO,Derecha)
      EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Arriba,BackTab,Izquierda),i-1,i+1)
   i = IIF(i<1,2,i)
   i = IIF(i>8,8,i)
ENDDO
RESTORE SCREEN FROM TMP
IF !INLIST(UltTecla,escape_,Arriba,Abajo)
   LfImpBto = ROUND(LfCanPed*LfPreUni,2)   && Sin descuento
   LfImpLin = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)   && Con descuento
   AsNroReq(NumEle) = LsNroReq
   AcTpoReq(NumEle) = LcTpoReq
   AsCodMat(NumEle) = LsCodMat
   AsDesMat(NumEle) = LsDesMat
   AsMarca (NumEle) = LsMarca
   AsUndCmp(NumEle) = LsUndCmp
   AfFacEqu(NumEle) = LfFacEqu
   AsPeso  (NumEle) = LsPeso
   AfPreUni(NumEle) = LfPreUni
   AfPreFob(NumEle) = LfPreFob
   AfPorDto(NumEle) = LfPorDto
   AfCanPed(NumEle) = LfCanPed
   AfImpLin(NumEle) = LfImpLin
   AiNumReg(NumEle) = LiNumReg
   DO xRegenera
ENDIF
* de Guia Remisi¢n el mensaje
GsMsgKey = "[PgUp] [PgDw]   [Del] Borra [Ins] Ins. [Enter] Ingreso [F10] Sigue [Esc] Salir"
DO lib_mtec WITH 99
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea cuando parte de REQU
******************************************************************************
PROCEDURE xBedit2
PARAMETERS NumEle, NumLin
=SEEK(XsNroOrd+XsUsuario+AsNroReq(NumEle),'RORD')
IF RORD.CanDes <> 0
   GsMsgErr = ' Item ya tiene ingreso al Almac‚n '
   DO lib_merr WITH 99
   UltTecla = Enter
   RETURN
ENDIF
SAVE SCREEN TO TMP
** NOTA >> solo se permite modificar mas no crear

IF AcTpoReq(NumEle) $ "R|A|S"  && Reposicion de Stock
   @ 19,01 CLEAR TO 21,78
  *@ 19,03 EDIT AsDesMat(NumEle) SIZE 1,45 DISABLE
   @ 18,03 SAY AsDesMat(NumEle) PICT [@S45]
   @ 18,50 SAY AsMarca(NumEle)  PICT "@S15"
   IF AcTpoReq(NumEle) = [R]
      SELE CATA
      SET ORDER TO CATA02
      XfStkAct = 0
      XfVCtoMn = 0
      XfVCtoUs = 0
      XfPctoMn = 0
      XfPctoUS = 0
      SEEK AsCodMat(NumEle)
      SCAN WHILE CODMAT = AsCodMat(NumEle)
         XfStkAct = XfStkAct + StkAct
         XfVCtoMn = XfVCtoMn + VCtoMn
         XfVCtoUs = XfVCtoUs + VCtoUs
      ENDSCAN
      IF XfStkAct <> 0
         XfPctoMn =  XfVCtoMn / XfStkAct
         XfPctoUS =  XfVCtoUS / XfStkAct
      ENDIF
      @ 20,3 SAY "Ultimo Precio de Compra : "
      @ 21,3 SAY "Precio Promedio Actual  : "
      IF XiCodMon = 1
         LfUltPre = ROUND(CATG->PULTMN * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoMn     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "S/."
         @ 21,29 SAY "S/."
      ELSE
         LfUltPre = ROUND(CATG->PULTUS * AfFacEqu(NumEle),3)
         LfPrcPmd = ROUND(XfPctoUS     * AfFacEqu(NumEle),3)
         @ 20,29 SAY "US$"
         @ 21,29 SAY "US$"
      ENDIF
      @ 20,32 SAY LfUltPre PICT "@Z 999,999,999.99"
      @ 21,32 SAY LfPrcPmd PICT "999,999,999.99"
   ENDIF
ENDIF
i        = 1
UltTecla = 0
*
LsNroReq = AsNroReq(NumEle)
LcTpoReq = AcTpoReq(NumEle)
LsCodMat = AsCodMat(NumEle)
LsDesMat = AsDesMat(NumEle)
LsMarca  = AsMarca (NumEle)
LsUndCmp = AsUndCmp(NumEle)
LfFacEqu = AfFacEqu(NumEle)
LsPeso   = AsPeso  (NumEle)
LfPreUni = AfPreUni(NumEle)
LfPreFob = AfPreFob(NumEle)
LfPorDto = AfPorDto(NumEle)
LfCanPed = AfCanPed(NumEle)
LfImpLin = AfImpLin(NumEle)
LiNumReg = AiNumReg(NumEle)
LlMod    = .T.
** Verificando si tiene atencion parcial ***
** no puede cambiar codigo               ***
SELE VREQ
SEEK LEFT(XsUsuario,LEN(VREQ.Usuario))+LsNroReq
IF (CanPed+CanDes)<>0 .AND. LfCanPed<>CanReq
   LlMod = .F.
ENDIF
** fin de chequeo
GsMsgKey = "[Izquierda] [Derecha] Mover   [Enter] Registra    [Esc] Cancela"
DO lib_mtec WITH 99
DO WHILE !INLIST(UltTecla,escape_)
   DO CASE
      CASE i = 1  AND (LcTpoReq$[ASR] AND LlMod)
         SELE CATG
         xCodMat = LsCodMat
         @ NumLin,12 GET LsCodMat PICT GsFmat
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Arriba)
            EXIT
         ENDIF
         IF UltTecla = F8 OR LsCodMat<>xCodMat
            LsCodMat = xCodMat
            SELE EQUN
            SEEK xCodMat
            IF !cmpbusca("EQUIV")
               UltTecla = 0
               LOOP
            ENDIF
            LsCodMat = EQUN.CodEqu
            SET RELA TO
            SELE CATG
         ENDIF
         @ NumLin,12 SAY LsCodMat PICT GsFmat
         SEEK LsCodMat
         IF !FOUND()
            DO lib_merr WITH 9
            LOOP
         ENDIF
         IF LcTpoReq=[R]
            IF xRepite()
               GsMsgErr = [Dato ya Registrado]
               DO lib_merr WITH 99
               LOOP
            ENDIF
            LsDesMat = CATG->DesMat+[ ]+CATG->Descrip
            LsMarca  = CATG->Marca
         ENDIF
            LsUndCmp = CATG->UndStk
            LfFacEqu = IIF(CATG->FacEqu<>0,CATG->FacEqu,1)
            XsUndStk = CATG->UndStk
            **=SEEK(LsCodMat, 'PCAT')
            LsPeso = CATG->Peso
            @ NumLin,34 SAY LsUndCmp PICT "@!"
      CASE i = 1 .AND. !(LcTpoReq $ "ASR" AND Llmod)
         UltTecla = Enter
      CASE i = 2  AND  LcTpoReq $ [N|A|S]  && En Caso que quieran modificar
        *@ 19,3 EDIT LsDesMat SIZE 1,60 COLOR SCHEME 7
         @ 18,3 GET  LsDesMat PICT [@S55]
         READ
         UltTecla = LASTKEY()
        *@ 19,3 EDIT LsDesMat SIZE 1,60 DISABLE
         @ 18,3 SAY LsDesMat PICT [@S55]
      CASE i = 2  AND  !(LcTpoReq $ [N|A|S])
         UltTecla = Enter
      CASE i = 3 .AND. LcTpoReq = "R"
         =SEEK(LsCodMat,"CATG")
         XsUndStk = CATG->UndStk
         SELE EQUN
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("EQUN")
               LOOP
            ENDIF
            LsUndCmp = UndVta
            LfFacEqu = FacEqu
         ENDIF
         @ NumLin,34 SAY LsUndCmp
         IF LsUndCmp # AsUndCmp(NumEle)
            IF CATG->UndCmp == LsUndCmp .AND. ! EMPTY(LsUndCmp)
               LfFacEqu = CATG->FACEQU
            ELSE
               IF CATG->UndStk == LsUndCmp
                  LfFacEqu = 1
               ELSE
                  SEEK XsUndStk+LsUndCmp
                  IF !FOUND()
                     DO lib_merr WITH 6
                     LOOP
                  ENDIF
                  LfFacEqu = FACEQU
               ENDIF
            ENDIF
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 3   .AND. LcTpoReq # "R"
         XsUndStk = AsUndCmp(NumEle)
         SELE EQUN
         @ NumLin,34 GET LsUndCmp PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,escape_,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(LsUndCmp)
            IF ! cmpbusca("EQUN")
               LOOP
            ENDIF
            LsUndCmp = UndVta
            LfFacEqu = FacEqu
         ENDIF
         @ NumLin,34 SAY LsUndCmp

         IF LsUndCmp # AsUndCmp(NumEle)
            SEEK XsUndStk+LsUndCmp
            IF !FOUND()
               DO lib_merr WITH 6
               LOOP
            ENDIF
            LfFacEqu = FACEQU
            ** la nueva cantidad ***
            LfCanPed = AfCanPed(NumEle)*AfFacEqu(NumEle)/LfFacEqu
         ENDIF

      CASE i = 4
         @ NumLin,38 GET LfCanPed PICT "999,999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,38 SAY LfCanPed PICT "999,999.99"
      CASE i = 5
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 GET LfPreUni PICT "999999.99999" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
         ELSE
            @ NumLin,48 GET LfPreFob PICT "99999.9999"
            READ
            UltTecla = LASTKEY()
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         POP KEY

      CASE i = 6
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,62 GET LfPorDto PICT "999.99" RANGE 0,
            READ
            UltTecla = LASTKEY()
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            LfPreUni = LfPreFob
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
            UltTecla = Enter
         ENDIF

      CASE i = 7
         IF LfCanPed > 0
            LfImport = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)
         ELSE
            LfImport = ROUND(LfPreUni,2)
         ENDIF
         PUSH KEY CLEAR
         ON KEY LABEL F7 DO CALCULO
         @ NumLin,69 GET LfImport PICT "9999999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ NumLin,69 SAY LfImport PICT "9999999.99"
         POP KEY
         IF LfCanPed > 0
            LfPreUni = LfImport/(LfCanPed*(1-LfPorDto/100))
         ELSE
            LfPreUni = LfImport
         ENDIF
         IF LEFT(XsNroOrd,1)=[N]
            @ NumLin,49 SAY LfPreUni PICT "999999.99999"
            @ NumLin,62 SAY LfPorDto PICT "999.99"
         ELSE
            @ NumLin,48 SAY LfPreFob PICT "99999.9999"
            @ NumLin,58 SAY LfPreUni PICT "99999.9999"
         ENDIF
         @ NumLin,69 SAY LfImport PICT "9999999.99"
      CASE i = 8
         *IF CATG->CodFle = SPAC(2) OR VAL(CATG->CodFle)=0
         *   SELE FLET
         *   IF !cmpbusca('FLET')
         *      UltTecla = 0
         *   ENDI
         *   XfCodFle = CodFle
         *   SELE CATG
         *   IF SEEK(LsCodMat,"CATG")
         *      IF RLOCK()
         *         REPL CodFle WITH XfCodFle
         *      ENDI
         *   ENDI
         *ENDI
         UltTecla = Enter
   ENDCASE
   IF i = 8 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>8,8,i)
ENDDO
RESTORE SCREEN FROM TMP
IF !INLIST(UltTecla,escape_,Arriba,Abajo)
   LfImpBto = ROUND(LfCanPed*LfPreUni,2)   && Sin descuento
   LfImpLin = ROUND(LfCanPed*LfPreUni*(1-LfPorDto/100),2)   && Con descuento
   AsNroReq(NumEle) = LsNroReq
   AcTpoReq(NumEle) = LcTpoReq
   AsCodMat(NumEle) = LsCodMat
   AsDesMat(NumEle) = LsDesMat
   AsMarca (NumEle) = LsMarca
   AsUndCmp(NumEle) = LsUndCmp
   AfFacEqu(NumEle) = LfFacEqu
   AsPeso  (NumEle) = LsPeso
   AfPreUni(NumEle) = LfPreUni
   AfPreFob(NumEle) = LfPreFob
   AfPorDto(NumEle) = LfPorDto
   AfCanPed(NumEle) = LfCanPed
   AfImpLin(NumEle) = LfImpLin
   AiNumReg(NumEle) = LiNumReg
   DO xRegenera
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Cargar arreglo con datos ya registrados
******************************************************************************
PROCEDURE xBmove

SELE RORD
*
PRIVATE  i
i = 1
SEEK XsNroOrd
SCAN WHILE NroOrd=XsNroOrd .AND. i<=CIMAXELE
   AsNroReq(i) = NroReq
   AcTpoReq(i) = TpoReq
   *
   AcTpoBie(i) = iif(TpoBie=[ ],[I],TpoBie)
   *
   AsCodMat(i) = CodMat
   AsDesMat(i) = DesMat    && << OJO <<
   AsMarca (i) = []     && << OJO <<
   AsUndCmp(i) = UndCmp
   AfFacEqu(i) = FacEqu
   AsPeso  (i) = Peso
   AfPreUni(i) = PreUni
   AfPreFob(i) = PreFob
   AfPorDto(i) = PorDto
   AfCanPed(i) = CanPed
   AfImpLin(i) = ImpLin
   AiNumReg(i) = RECNO()
   i = i + 1
ENDSCAN
GiTotItm = i - 1
DO xRegenera

RETURN
************************************************************************ FIN()
* Grabar Informacion
******************************************************************************
PROCEDURE xGraba

SELE VORD
IF m.Crear
   * control de correlativo *
   SELE DOCM
   IF XcTipo = [N]
      SEEK XsCodDoN
   ELSE
      SEEK XsCodDoI
   ENDI
   IF ! RLOCK()
      SELE VORD
      RETURN
   ENDIF
   IF XsNroOrd = m.NroOrd     && Acepta el correlativo automatico
      *IF XcTipo = [N]
      *   XsNroOrd = XcTipo+PADL(ALLTRIM(STR(DOCM->NroDoc)),LEN(VORD->NroOrd)-1,'0')
      *ELSE
      *   XsNroOrd = XcTipo+PADL(ALLTRIM(STR(DOCM->NroDo1)),LEN(VORD->NroOrd)-1,'0')
      *ENDIF
      XsNroOrd = XcTipo+RIGH(XsMesCon,2)+PADL(DOCM->&XsMesCon.,LEN(VORD->NroOrd)-3,'0')
   ELSE                       && Correlativo manual
      * veamos si ya fue registrado *
      SELE VORD
      SEEK XsNroOrd
      IF FOUND()
         GsMsgErr = [INVALIDA CONFIGURACION DEL NRO. CORRELATIVO DE O/C.]
         DO lib_merr WITH 99
         RETURN
      ENDIF
   ENDIF
   * actualizamos el correlativo *
   SELE DOCM
   *IF XcTipo = [N]
      IF DOCM->&XsMesCon. <= VAL(SUBS(XsNroOrd,LEN(VORD->NroOrd)-3))
         REPLACE DOCM->&XsMesCon. WITH VAL(SUBS(XsNroOrd,LEN(VORD->NroOrd)-3))+1
      ENDIF
   *ELSE
   *   IF DOCM->NroDo1 <= VAL(SUBS(XsNroOrd,2))
   *      REPLACE DOCM->NroDo1 WITH VAL(SUBS(XsNroOrd,2))+1
   *   ENDIF
   *ENDIF
   UNLOCK
   ***
   @ 1,15 SAY XsNroOrd  PICT "@R !-999999"
   SELE VORD
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
   REPLACE VORD->NroOrd WITH XsNroOrd
ELSE
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
REPLACE VORD->NroOr2  WITH XsNroOr2
REPLACE VORD->CotImp  WITH XsCotImp
REPLACE VORD->FchOrd  WITH XdFchOrd
REPLACE VORD->CodAux  WITH XsCodAux
REPLACE VORD->NomAux  WITH XsNomAux
REPLACE VORD->RucAux  WITH XsRucAux
REPLACE VORD->DirAux  WITH XsDirAux
REPLACE VORD->TlfAux  WITH XsTlfAux
REPLACE VORD->NroCot  WITH XsNroCot
REPLACE VORD->DiaEnt  WITH XiDiaEnt
REPLACE VORD->CndPgo  WITH XsCndPgo
REPLACE VORD->Maquina  WITH XsMaquina
*
REPLACE VORD->FmaPgo  WITH XsFmaPgo
REPLACE VORD->PagAde  WITH XsPagAde
REPLACE VORD->Tasa    WITH XiTasa
*
REPLACE VORD->CodMon  WITH XiCodMon
REPLACE VORD->PorIgv  WITH XfPorIgv
REPLACE VORD->PorDto  WITH XfPorDto
REPLACE VORD->ImpBto  WITH XfImpBto
REPLACE VORD->ImpDto  WITH XfImpDto
REPLACE VORD->ImpInt  WITH XfImpInt
REPLACE VORD->ImpAdm  WITH XfImpAdm
REPLACE VORD->ImpIgv  WITH XfImpIgv
REPLACE VORD->ImpNet  WITH XfImpNet
REPLACE VORD->GloDoc  WITH XsGloDoc
REPLACE VORD->FchEnt  WITH XdFchEnt
REPLACE VORD->LugEnt  WITH XsLugEnt
REPLACE VORD->FlgEst  WITH XcFlgEst
REPLACE VORD->Prueba  WITH STR(XsPrueba,1)
REPLACE VORD->Hora    WITH time()
REPLACE VORD->Refere  WITH XsRefere
REPLACE VORD->TmpEnt  WITH XsTmpEnt
* Cambiaron Tipo de generacion Ing.Federico
*REPLACE VORD->CodCmp  WITH XsCodCmp
REPLACE VORD->Usuario WITH XsUsuario
REPLACE VORD->CodRef  WITH XsCodRef
REPLACE VORD->TpoO_C  WITH XcTpoO_C
*
replace vord->tpobie  with xctpobie
*
* importaci¢n *    No se considera a£n los gastos de importaci¢n
REPLACE VORD->ImpFob  WITH XfImpFob
REPLACE VORD->ImpFle  WITH XfImpFle
REPLACE VORD->ImpSeg  WITH XfImpSeg
IF XcTipo = [I]
   REPLACE VORD->TipFle  WITH XcTipFle
   REPLACE VORD->ImpCif  WITH XfImpFob+XfImpFle+XfImpSeg
ENDI
REPLACE VORD->ImpAdv  WITH XfImpAdv
REPLACE VORD->ImpAdm  WITH XfImpAdm
REPLACE VORD->ImpIns  WITH XfImpIns
REPLACE VORD->ImpHan  WITH XfImpHan
REPLACE VORD->ImpPap  WITH XfImpPap
REPLACE VORD->ImpAdu  WITH XfImpAdu
REPLACE VORD->ImpMtt  WITH XfImpMtt
REPLACE VORD->ImpOtr  WITH XfImpOtr
REPLACE VORD->Status  WITH [1]
replace VORD.FchLLe   WITH XDFchLle
replace VORD.FchEmb   WITH XdFchEmb
REplace VORD.FpgFlt   WITH XnFpgFlt
REPLACE VORD.NdPrev   WITH XnDPRev
** Grabamos en Seguimiento de Importaci¢n **
IF LEFT(VORD.NroOrd,1)<>[N]
*!*	   SELE SIMP
*!*	   SEEK XsNroOrd
*!*	   IF !FOUND()
*!*	      APPEND BLANK
*!*	      IF ! RLOCK()
*!*	         RETURN
*!*	      ENDIF
*!*	      REPLACE SIMP->NroOrd WITH XsNroOrd
*!*	      REPLACE SIMP->Status  WITH [1]  && FIJARSE EN CMPMTABL EL ANCHO DEL CODIGO
*!*	      REPLACE SIMP->FchSeg  WITH DATE()
*!*	      REPLACE SIMP->TimSeg  WITH TIME()
*!*	      REPLACE SIMP->FchOrd  WITH XdFchOrd
*!*	      REPLACE SIMP->FchPgo  WITH XdFchEnt
*!*	      REPLACE SIMP->User    WITH GsUsuario
*!*	      UNLOCK
*!*	   ENDIF
ENDIF
** Fin de grabaci¢n Seg. Importaci¢n **
SELE VORD
** Grabamos Browse **
DO xBgrab
*********************

SELE VORD
DO XImprime
IF _Destino#2  && Pantalla es 2
   IF SEEK(XsNroOrd,"VORD") AND RLOCK("VORD")
      *REPLACE VORD.NroCop WITH VORD.NroCop+1
   ENDIF
   UNLOCK IN "VORD"
ENDIF
SELE RORD
SET RELA TO
SELE VORD

RETURN
************************************************************************ FIN *
* Objeto : Grabacion de Informacion
******************************************************************************
PROCEDURE xBgrab
SELE RORD
PRIVATE i
i = 1
IF GiTotDel > 0
   DO WHILE i<=GiTotDel
      SELE RORD
      GO AiRegDel(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      ** desactualiza Requerimiento **
      IF AsNroReq # SPAC(6)
         SELE VREQ
         SEEK LEFT(RORD->Usuario,LEN(VREQ.Usuario))+RORD->NroReq
         IF !REC_LOCK(5)
            LOOP
         ENDIF
         IF UNDCMP <> RORD->UNDCMP
            REPLACE VREQ->CanPed WITH CanPed - RORD->CanPed*RORD->FacEqu/FacEqu
         ELSE
            REPLACE VREQ->CanPed WITH CanPed - RORD->CanPed
         ENDIF
         IF CanPed <= 0
            REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
         ELSE
            REPLACE VREQ->FlgEst WITH [O]    && Con O/Compra
         ENDIF
         IF CanDes >= CanReq
            REPLACE VREQ->FlgLog WITH [H], VREQ->FlgHis WITH [H]
         ELSE
            REPLACE VREQ->FlgLog WITH IIF(VREQ->FlgEst=[O],[H],[R])
            REPLACE VREQ->FlgHis WITH [R]
         ENDIF
         REPLACE VREQ->NroO_C WITH SPAC(LEN(XsNroOrd))
         REPLACE VREQ->FchO_C WITH {}
         UNLOCK
      ENDI
      **
      SELE RORD
      * Proceso que permite eliminar el precio grabado en el archivo hist¢rico
      **DO Eli_precio
      SELE RORD
      DELETE
      UNLOCK
      i = i + 1
   ENDDO
ENDIF
i = 1
DO WHILE i <= GiTotItm
	IF !EMPTY(AsNroReq(i))
	   SELE VREQ
	   SEEK LEFT(XsUsuario,LEN(VREQ.Usuario))+AsNroReq(i)  && Caso Logistica NumEle
	   IF FOUND()
		   IF !REC_LOCK(5)
	    	  LOOP
		   ENDIF
	   ENDIF
   ENDIF
   SELE RORD
   IF AiNumReg(i)>0   && Registros ya existen
      GO AiNumReg(i)
      IF ! RLOCK()
         LOOP
      ENDIF
      ** OJO >> El sistema no permite modificar # de Requerimiento **
      ** desactualizamos Requerimiento **
      IF AsNroReq(i) # SPAC(6)
         SELE VREQ
         IF UNDCMP <> RORD->UNDCMP
            *  Se considera una orden de compra por requisicion
            REPLACE VREQ->CanPed WITH VREQ->CanPed - (RORD->CanPed*RORD->FacEqu/FacEqu)
         ELSE
            REPLACE VREQ->CanPed WITH VREQ->CanPed - RORD->CanPed
         ENDIF
         IF VREQ.CanPed <= 0
            REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
         ELSE
            REPLACE VREQ->FlgEst WITH [O]    && Solo Emitida
         ENDIF
         IF VREQ->CanPed >= VREQ->CanReq
            REPLACE VREQ->FlgLog WITH [H], VREQ->FlgHis WITH [H]
         ELSE
            REPLACE VREQ->FlgLog WITH IIF(VREQ->FlgEst=[O],[H],[R])
            REPLACE VREQ->FlgHis WITH [R]
         ENDIF
         REPLACE VREQ->NroO_C WITH XsNroOrd
         REPLACE VREQ->FchO_C WITH XdFchOrd
         UNLOCK
      ENDI
   ELSE
      SELECT RORD
      APPEND BLANK
      IF ! RLOCK()
         LOOP
      ENDIF
      REPLACE RORD->NroOrd WITH XsNroOrd
      UNLO
   ENDI
   **
   SELE RORD
   IF !REC_LOCK(5)
      LOOP
   ENDIF
   REPLACE RORD->Usuario WITH XsUsuario   &&AsUsuari(i)
   REPLACE RORD->NroReq  WITH AsNroReq(i)
   REPLACE RORD->TpoReq  WITH AcTpoReq(i)
   *
   REPLACE RORD->TpoBie  WITH AcTpoBie(i)
   *
   REPLACE RORD->CodMat  WITH AsCodMat(i)
   REPLACE RORD->DesMat  WITH AsDesMat(i)
   REPLACE RORD->UndCmp  WITH AsUndCmp(i)
   REPLACE RORD->FacEqu  WITH AfFacEqu(i)
   REPLACE RORD->Peso    WITH AsPeso  (i)
   REPLACE RORD->PreUni  WITH AfPreUni(i)
   REPLACE RORD->PreFob  WITH AfPreFob(i)
   REPLACE RORD->PorDto  WITH AfPorDto(i)
   REPLACE RORD->CanPed  WITH AfCanPed(i)
   REPLACE RORD->ImpLin  WITH AfImpLin(i)
   REPLACE RORD->FchOrd  WITH XdFchOrd
   x = RECNO()  &&  El puntero no ubica autom ticamente
   GO x
   REPLACE RORD->FchEnt  WITH VREQ->FCHENT
   ** Control de la Requisici¢n
   IF !EMPTY(AsNroReq(i))
      SELE VREQ
      IF UNDCMP <> RORD->UNDCMP
         *  Se considera una orden de compra por requisicion
         REPLACE VREQ->CanPed WITH VREQ->CanPed + (RORD->CanPed*RORD->FacEqu/FacEqu)
      ELSE
         REPLACE VREQ->CanPed WITH VREQ->CanPed + RORD->CanPed
      ENDIF

      IF VREQ.CanPed <= 0
         REPLACE VREQ->FlgEst WITH [P]    && Presupuestada
      ELSE
         REPLACE VREQ->FlgEst WITH [O]    && Con O/Compra
      ENDIF
      IF VREQ->CanPed >= VREQ->CanReq
         ** El Control de enviar a Historia se realiza
         ** por el ingreso a almacen
         REPLACE VREQ->FlgLog WITH [H], VREQ->FlgHis WITH [H]
      ELSE
         REPLACE VREQ->FlgLog WITH IIF(VREQ.FlgEst=[O],[H],[R])
         REPLACE VREQ->FlgHis WITH [R]
      ENDIF
      ** Se graban los datos del producto si coincide n£mero de Requisi¢n
      IF VREQ.CodMat <> RORD.CodMat AND VREQ.NroReq=RORD.NroReq
         REPLACE VREQ.CodMat WITH RORD.CodMat
         REPLACE VREQ.UndCmp WITH RORD.UndCmp
         REPLACE VREQ.DesReq WITH RORD.DesMat
      ENDIF
      IF VREQ.DesReq <> RORD.DesMat AND VREQ.NroReq=RORD.NroReq
         REPLACE VREQ.DesReq WITH RORD.DesMat
      ENDIF
      REPLACE VREQ->NroO_C WITH XsNroOrd
      REPLACE VREQ->FchO_C WITH XdFchOrd
      UNLOCK
   ENDI
   * Actualizamos el precio ingresado
   *** DO Gra_precio && Fuera piojos 17/03/98
   **
   STORE SPACE(LEN(RORD->NroReq))  TO AsNroReq(i)
   STORE SPACE(LEN(RORD->TpoReq))  TO AcTpoReq(i)
   *
   STORE SPACE(LEN(RORD->TpoBie))  TO AcTpoBie(i)
   *
   STORE SPACE(LEN(RORD->CodMat))  TO AsCodMat(i)
   STORE SPACE(LEN(CATG->DesMat))  TO AsDesMat(i)
   STORE SPACE(LEN(CATG->Marca ))  TO AsMarca (i)
   STORE SPACE(LEN(RORD->UndCmp))  TO AsUndCmp(i)
   STORE 1                         TO AfFacEqu(i)
   STORE 0                         TO AsPeso  (i)
   STORE 0                         TO AfPreUni(i)
   STORE 0                         TO AfPreFob(i)
   STORE 0                         TO AfPorDto(i)
   STORE 0                         TO AfCanPed(i)
   STORE 0                         TO AfImpLin(i)
   STORE 0                         TO AiNumReg(i)
   SELE RORD
   UNLOCK
   i = i + 1
ENDDO
STORE SPACE(LEN(RORD->NroReq)) TO AsNroReq
GiTotItm = 0
RETURN
******************************************************************************
* Objeto : Graba el precio unitario de la O/C en CMPCATGE.DBF
******************************************************************************
PROCEDURE Gra_precio
IF !SEEK (AsCodMat(i), 'PCAT')
   SELE PCAT
   APPEN BLANK
   REPL CodMat WITH AsCodMat(i)
ENDI
SELE PCAT
IF (XdFchOrd >= FCCMP5)  OR  (FCCMP5={})
   IF (XsNroOrd >= Orcmp5) OR (EMPTY(Orcmp5))
      IF RLOCK()
         DO CASE
            CASE XsNroOrd = Orcmp5
                REPL Prcmp5 WITH IIF(LEFT(XsNroOrd,1)='N',RORD.PreUni,RORD.PreFob)
                REPL Prove5 WITH XsCodAux
                REPL Fccmp5 WITH XdFchOrd
                REPL Orcmp5 WITH XsNroOrd
            OTHERWISE
                STORE 1 TO ix, iix
                X = 'ORCMP'
                FOR ix=1 to 5
                    X = 'ORCMP'+STR(ix,1)
                    IF EMPTY(&x)
                       iix = ix
                       ix = 5
                    ENDI
                ENDF
                IF iix < 5
                   FOR ix=iix TO 4
                      X = 'PRCMP'+STR(ix,1)
                      Y = 'PRCMP'+STR(ix+1,1)
                      REPL &X WITH &Y
                      X = 'PROVE'+STR(ix,1)
                      Y = 'PROVE'+STR(ix+1,1)
                      REPL &X WITH &Y
                      X = 'FCCMP'+STR(ix,1)
                      Y = 'FCCMP'+STR(ix+1,1)
                      REPL &X WITH &Y
                      X = 'ORCMP'+STR(ix,1)
                      Y = 'ORCMP'+STR(ix+1,1)
                      REPL &X WITH &Y
                   ENDF
                ENDI
                *
                REPL Prcmp5 WITH IIF(LEFT(XsNroOrd,1)='N',RORD.PreUni,RORD.PreFob)
                REPL Prove5 WITH XsCodAux
                REPL Fccmp5 WITH XdFchOrd
                REPL Orcmp5 WITH XsNroOrd
         ENDC
      ENDI
      UNLO
   ENDI
ENDI
SELE RORD
RETURN
************************************************************************ FIN *
* Objeto : Elimina el precio unitario de la O/C en CMPCATGE.DBF
******************************************************************************
PROCEDURE Eli_precio
IF !SEEK (RORD.CodMat, 'PCAT')
   GsMsgErr = [ Producto no existe en el archivo CMPCATGE.DBF ]
   DO LIB_MERR WITH 99
   RETURN
ENDI
SELE PCAT
DO CASE
   CASE (VORD.FchOrd = FCCMP5) AND (XsNroOrd = Orcmp5)
      IF RLOCK()
         REPL Prcmp5 WITH 0 , Prove5 WITH SPAC(LEN(Prove5))
         REPL Fccmp5 WITH {}, Orcmp5 WITH SPAC(LEN(Orcmp5))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP4) AND (XsNroOrd = Orcmp4)
      IF RLOCK()
         REPL Prcmp4 WITH 0 , Prove4 WITH SPAC(LEN(Prove4))
         REPL Fccmp4 WITH {}, Orcmp4 WITH SPAC(LEN(Orcmp4))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP3) AND (XsNroOrd = Orcmp3)
      IF RLOCK()
         REPL Prcmp3 WITH 0 , Prove3 WITH SPAC(LEN(Prove3))
         REPL Fccmp3 WITH {}, Orcmp3 WITH SPAC(LEN(Orcmp3))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP2) AND (XsNroOrd = Orcmp2)
      IF RLOCK()
         REPL Prcmp2 WITH 0 , Prove2 WITH SPAC(LEN(Prove2))
         REPL Fccmp2 WITH {}, Orcmp2 WITH SPAC(LEN(Orcmp2))
      ENDI
      UNLO
   CASE (VORD.FchOrd = FCCMP1) AND (XsNroOrd = Orcmp1)
      IF RLOCK()
         REPL Prcmp1 WITH 0 , Prove1 WITH SPAC(LEN(Prove1))
         REPL Fccmp1 WITH {}, Orcmp1 WITH SPAC(LEN(Orcmp1))
      ENDI
      UNLO
ENDC
SELE RORD
RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE XBinse1
PARAMETERS ElePrv, Estado

PRIVATE i
i = GiTotItm + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsNroReq(i) = AsNroReq(i-1)
   AcTpoReq(i) = AcTpoReq(i-1)
   *
   AcTpoBie(i) = AcTpoBie(i-1)
   *
   AsCodMat(i) = AsCodMat(i-1)
   AsDesMat(i) = AsDesMat(i-1)
   AsMarca (i) = AsMarca (i-1)
   AsUndCmp(i) = AsUndCmp(i-1)
   AfFacEqu(i) = AfFacEqu(i-1)
   AfPreUni(i) = AfPreUni(i-1)
   AsPeso  (i) = AsPeso  (i-1)
   AfPreFob(i) = AfPreFob(i-1)
   AfPorDto(i) = AfPorDto(i-1)
   AfCanPed(i) = AfCanPed(i-1)
   AfImpLin(i) = AfImpLin(i-1)
   AiNumReg(i) = AiNumReg(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(RORD->NroReq))  TO AsNroReq(i)
STORE 'R'  TO AcTpoReq(i)
*
STORE SPACE(LEN(RORD->TpoBie))  TO AcTpoBie(i)
*
STORE SPACE(LEN(RORD->CodMat))  TO AsCodMat(i)
STORE SPACE(LEN(CATG->DesMat))  TO AsDesMat(i)
STORE SPACE(LEN(CATG->Marca ))  TO AsMarca (i)
STORE SPACE(LEN(RORD->UndCmp))  TO AsUndCmp(i)
STORE 1                         TO AfFacEqu(i)
STORE 0                         TO AsPeso  (i)
STORE 0                         TO AfPreUni(i)
STORE 0                         TO AfPreFob(i)
STORE 0                         TO AfPorDto(i)
STORE 0                         TO AfCanPed(i)
STORE 0                         TO AfImpLin(i)
STORE 0                         TO AiNumReg(i)
GiTotItm = GiTotItm + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea cuando parte de REQU
******************************************************************************
PROCEDURE XBinse2
PARAMETERS ElePrv, Estado

Estado = .F.

RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE xBborr
PARAMETERS ElePrv, Estado
PRIVATE LnRsp
=SEEK(XsNroOrd+XsUsuario+AsNroReq(EleAct),'RORD')
IF RORD.CanDes <> 0
   GsMsgErr = ' Item ya tiene ingreso al Almac‚n '
   DO lib_merr WITH 99
   Estado = .F.
   UltTecla = Enter
   RETURN
ENDIF
*!*	LnRsp = MESSAGEBOX( "Despu‚s de eliminar un Item ya no se podr  a¤adir",0+4+48,"'*** I M P O R T A N T E ***")
*!*	IF LnRsp = 7
*!*	   Estado = .F.
*!*	   UltTecla = Enter
*!*	   RETURN
*!*	ENDIF
PRIVATE i
i = ElePrv + 1
IF AiNumReg(i) > 0
   GiTotDel = GiTotDel + 1
   AiRegDel(GiTotDel) = AiNumReg(i)
ENDIF
* borramos del arreglo
=ADEL(AsNroReq,i)
=ADEL(AcTpoReq,i)
=ADEL(AcTpoBie,i)
=ADEL(AsCodMat,i)
=ADEL(AsDesMat,i)
=ADEL(AsMarca ,i)
=ADEL(AsUndCmp,i)
=ADEL(AfFacEqu,i)
=ADEL(AfPreUni,i)
=ADEL(AsPeso  ,i)
=ADEL(AfPreFob,i)
=ADEL(AfPorDto,i)
=ADEL(AfCanPed,i)
=ADEL(AfImpLin,i)
=ADEL(AiNumReg,i)
i = GiTotItm
STORE SPACE(LEN(RORD->NroReq)) TO AsNroReq(i)
STORE SPACE(LEN(RORD->TpoReq)) TO AcTpoReq(i)
*
STORE SPACE(LEN(RORD->TpoBie)) TO AcTpoBie(i)
*
STORE SPACE(LEN(RORD->CodMat)) TO AsCodMat(i)
STORE SPACE(LEN(CATG->DesMat)) TO AsDesMat(i)
STORE SPACE(LEN(CATG->Marca )) TO AsMarca (i)
STORE SPACE(LEN(RORD->UndCmp)) TO AsUndCmp(i)
STORE 1                        TO AfFacEqu(i)
STORE 0                        TO AsPeso  (i)
STORE 0                        TO AfPreUni(i)
STORE 0                        TO AfPreFob(i)
STORE 0                        TO AfPorDto(i)
STORE 0                        TO AfCanPed(i)
STORE 0                        TO AfImpLin(i)
STORE 0                        TO AiNumReg(i)
GiTotItm = GiTotItm - 1
Estado = .T.
DO xRegenera

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos  NACIONAL
******************************************************************************
PROCEDURE xRegenera

PRIVATE j
j = 1
STORE 0 TO XfImpBto,XfImpDto,XfImpIgv,XfImpNet
STORE 0 TO XfImpFob,XfTotUnd
FOR j = 1 TO GiTotItm
   XfTotUnd = XfTotUnd + AfCanPed(j)
   XfImpFob = XfImpFob + ROUND(AfCanPed(j)*AfPreFob(j),2)
   XfImpBto = XfImpBto + ROUND(AfCanPed(j)*AfPreUni(j),2)
   XfImpDto = XfImpDto + (ROUND(AfCanPed(j)*AfPreUni(j),2)-AfImpLin(j))
ENDFOR
IF LEFT(XsNroOrd,1)=[N]
   *XfPorIgv = 18
   XfImpVta = XfImpBto - XfImpDto
   XfImpIgv = ROUND((XfImpVta+XfImpFle+XfImpOtr)*XfPorIgv/100,2)
   XfImpNet = XfImpVta +XfImpFle +XfImpOtr + XfImpIgv
   @ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                Ý"
   @ 20,0  SAY "Ý Imp.Flete :             Otro Gast.:             IGV.      % :                Ý"
   @ 21,0  SAY "Ý                                          Precio Venta Total :                Ý"
   @ 19,15 SAY XfImpBto PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,38 SAY XfImpDto PICT "9999,999.99"  COLOR SCHEME 7
   @ 19,65 SAY XfImpVta PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,15 SAY XfImpFle PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,38 SAY XfImpOtr PICT "9999,999.99"  COLOR SCHEME 7
   @ 20,54 SAY XfPorIgv PICT "99.99"         COLOR SCHEME 7
   @ 20,65 SAY XfImpIgv PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,65 SAY XfImpNet PICT "99999,999.99"  COLOR SCHEME 7
ELSE
   XfImpCif = XfImpFob+XfImpFle+XfImpSeg
   XfImpBto = XfImpCif+XfImpIns+XfImpHan+XfImpAdv+XfImpPap+XfImpAdu+XfImpMtt+XfImpAdm+XfImpOtr
   XfImpNet = XfImpBto
   *XfImpNet = XfImpFob
   j = 1
   FOR j = 1 TO GiTotItm
      AfPreUni(j) = AfPreFob(j) + ((XfImpNet-XfImpFob)/XfTotUnd)
      AfImpLin(j) = ROUND(AfPreUni(j) * AfCanPed(j),2)
   ENDFOR
   XfPorIgv = 0
   XfImpIgv = 0
   *@ 21,65 SAY XfImpNet PICT "99999,999.99"  COLOR SCHEME 7
   @ 18,14 SAY XfImpFob     PICT "99999,999.99"  COLOR SCHEME 7
   @ 19,11 SAY XcTipFle     PICT "!" COLOR SCHEME 7
   @ 19,14 SAY XfImpFle     PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,14 SAY XfImpSeg     PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,14 SAY XfImpCif     PICT "99999,999.99"  COLOR SCHEME 7
   @ 18,39 SAY XfImpIns     PICT "99999,999.99"  COLOR SCHEME 7
   @ 19,39 SAY XfImpHan     PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,39 SAY XfImpAdv     PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,39 SAY XfImpMtt     PICT "99999,999.99"  COLOR SCHEME 7
   @ 18,67 SAY XfImpAdm     PICT "99999,999.99"  COLOR SCHEME 7
   @ 19,67 SAY XfImpAdu     PICT "99999,999.99"  COLOR SCHEME 7
   @ 20,67 SAY XfImpOtr     PICT "99999,999.99"  COLOR SCHEME 7
   @ 21,67 SAY XfImpNet     PICT "99999,999.99"  COLOR SCHEME 7
ENDIF

RETURN
************************************************************************ FIN *
* Objeto : Emisi¢n del documento
******************************************************************************
PROCEDURE xImprime
PRIVATE LARGO

SAVE SCREEN TO XTemp
* Relaciones para impresion *

XsNroOrd = VORD.NroOrd
SELE RORD
SET RELA TO Usuario+NroReq INTO VREQ
SEEK XsNroOrd
xWHILE = "RORD->NroOrd=XsNroOrd"
**DO xImpPie
sNomRep = []
SELE RORD
SEEK XsNroOrd
xFOR   = []
IF LEFT(XsNroOrd,1)=[N]
*   DO xImpNac 
   Largo  = 66     && Largo de pagina
*!*	   sNomRep = "cmpigocn"
	sNomRep = "cmpn2300_"+GsSigCia
   IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
   DO F0print WITH "REPORTS"
   
ELSE
   Largo  = 66     && Largo de pagina
*!*	   sNomRep = "cmpigoci"
	sNomRep = "cmpi2300"   
   IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
   DO F0print WITH "REPORTS"
ENDIF
RESTORE SCREEN FROM xTemp

RETURN
************************************************************************ FIN *
* Objeto : Emisi¢n del documento
******************************************************************************
PROCEDURE xImpNac
DO F0PRINT
UltTecla = LastKey()
IF UltTecla = escape_
   RETURN
ENDIF
IniImp = _Prn2
Largo  = 66       && Largo de pagina
LinFin = 66 - 6
Ancho  = 95
Titulo = []
SubTitulo = []
STORE [] TO En1,En2,En3,En4,En5,En6,En7,En8,En9

SET DEVICE TO PRINTER
SET MARGIN TO 0
PRINTJOB
NumPag   = 0
LsLla_I  = VORD.NroOrd
NumLin = 0
DO Resetpag
SELE RORD
SEEK LsLla_I
SET MEMOW TO 26
IF VORD->FlgEst <> "A"
   STORE 0 TO Xsumpag,Xcanped,Xpeso
   SCAN WHILE  NroOrd=LsLla_i
      @ NumLin ,00  SAY RORD.CanPed PICT '9999,999.99'
      @ NumLin ,18  SAY RORD.UndCmp PICT '999'
      @ NumLin ,23  SAY RORD.CodMat PICT '@!'
      IF !EMPTY(VREQ.DesReq)
         @ NumLin, 32 SAY MLINE(VREQ.DesReq,1) PICT '@S26'   &&  +[ ]+VREQ.GloReq
      ELSE
        *@ NumLin, 32 SAY MLINE(RORD.DesMat,1) PICT '@S26'
         @ NumLin, 32 SAY RORD.DesMat PICT '@S26'
         IF LEN(TRIM(rord.Desmat))>26
               NumLin = NumLin + 1
               IF NumLin > 42
                  DO Resetpag
               ENDI
               @ NumLin, 32 SAY SUBSTR(RORD.Desmat,27) PICT '@S26'
         ENDIF
      ENDI
      @ NumLin ,59  SAY IIF(RORD.PorDto>0, TRANS(RORD.PorDto, '99')+'%', '')
      @ NumLin ,62  SAY RORD.PreUni PICT '99999.9999'
      @ NumLin ,73  SAY IIF(VORD.CodMon=1, 'S/.', 'US$')
      @ NumLin ,78  SAY TRAN(ROUND(RORD.CanPed*RORD.PreUni,2), '9999,999.99')
      Xsumpag = Xsumpag + RORD.ImpLin
      Xcanped = Xcanped + RORD.CanPed
      Xpeso   = Xpeso   + (RORD.CanPed*RORD.Peso)
      IF !EMPTY(VREQ.DesReq)
         FOR ii=2 TO 24
            IF !EMPTY(MLINE(VREQ.Desreq,ii))
               NumLin = NumLin + 1
               IF NumLin > 42
                  DO Resetpag
               ENDI
               @ NumLin, 32 SAY MLINE(VREQ.DesReq,ii) PICT '@S26'
            ELSE
               ii = 24
            ENDI
         ENDF
      ELSE
      *   FOR ii=2 TO 20
      *      IF !EMPTY(MLINE(RORD.DesMat,ii))
      *         NumLin = NumLin + 1
      *         IF NumLin > 42
      *            DO Resetpag
      *         ENDI
      *         @ NumLin, 32 SAY MLINE(RORD.DesMat,ii) PICT '@S26'
      *      ELSE
      *         ii = 20
      *      ENDI
      *   ENDF
      ENDI
      NumLin = NumLin + 1
      IF NumLin > 42
         DO Resetpag
      ENDI
      @ NumLin , 32 SAY 'F.Ent.: '+DTOC(VREQ.FchEnt)
      NumLin = PROW() + 1
      SELE RORD
   ENDS
   IF NumLin > 34
      DO Resetpag
   ENDI
   @ NumLin  , 78 SAY '------------'
   NumLin = NumLin+1
   @ NumLin  , 74  SAY IIF(VORD.CodMon=1, 'S/.', 'US$')
   @ NumLin  , 78 SAY VORD.ImpBto  PICT  '9999,999.99'
   @ NumLin+1, 46 SAY 'Descuento '
   @ NumLin+1, 78 SAY VORD.ImpDto  PICT  '9999,999.99'
   @ NumLin+2, 46 SAY 'Flete '
   @ NumLin+2, 78 SAY VORD.ImpFle  PICT  '9999,999.99'
   @ NumLin+3, 46 SAY 'Otros Gastos '
   @ NumLin+3, 78 SAY VORD.ImpOtr  PICT  '9999,999.99'
   @ NumLin+4, 46 SAY 'I.G.V. '
   @ NumLin+4, 78 SAY VORD.ImpIgv  PICT  '9999,999.99'
   @ NumLin+5, 78 SAY '------------'
   @ NumLin+6, 74 SAY IIF(VORD.CodMon=1, 'S/.', 'US$')
   @ NumLin+6, 78 SAY VORD.ImpNet  PICT  '9999,999.99'
   @ NumLin+7, 78 SAY '============'
   * Pie de paguina
   IF RORD.Peso >0
      @ 43,06  say 'Ref.de Peso : '+TRANS(xcanped, '999999,999')+' Und.equivalen a '+TRANS(xpeso, '9999,999.9999')
   ENDI
   @ 44,06  say cfggloO_C
   IF VORD.Prueba='1'
      @ 46,17  say [x]
   ELSE
      @ 46,28  say [x]
   ENDI
   *@ 47,17  say VORD.TmpEnt
   IF EMPTY(CFGDir1) AND EMPTY(CFGDir2) AND EMPTY(CFGDir3)
      DO CASE
         CASE VORD.LugEnt = '1'
            @ 50,23  say [x]
         CASE VORD.LugEnt = '2'
            @ 50,46  say [x]
         CASE VORD.LugEnt = '3'
            @ 50,67  say [x]
      ENDC
   ELSE
      DO CASE
         CASE VORD.LugEnt = '1'
            @ 50,21  say CFGDir1
         CASE VORD.LugEnt = '2'
            @ 50,21  say CFGDir2
         CASE VORD.LugEnt = '3'
            @ 50,21  say CFGDir3
      ENDC
   ENDI
   SET MEMOW TO 55
   @ 51,18  say VORD.CndPgo
   @ 53,17  say MLINE(VORD.GloDoc,1)
   @ 54,17  say MLINE(VORD.GloDoc,2)
   @ 55,17  say MLINE(VORD.GloDoc,3)
ELSE
   @ PROW()+1,11 SAY "     #    #     # #     # #          #    ######  #######  "
   @ PROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
   @ PROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
   @ PROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
   @ PROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
ENDIF
ENDPRINTJOB
SET MEMOW TO 55
EJECT PAGE
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN 
SELECT VORD

RETURN
******************
PROCEDURE Resetpag
******************
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ELSE
   @ Largo-1,Ancho-10 SAY "../Continua"
ENDIF
@ 0,0  SAY IniImp
@ 2,19 SAY [R.U.C: 25856228]
@ 3,29 SAY VORD.REFERE
@ 6, 7 SAY LEFT(DTOC(VORD.FchOrd),2)
@ 6,17 SAY MES(MONTH(VORD.FchOrd),3)
@ 6,37 SAY RIGH(DTOC(VORD.FchOrd),2)
@ 7,60 SAY 'Cod.Prov.'
@ 8,12 SAY VORD.NomAux
@ 8,61 SAY VORD.CodAux
@10,12 SAY VORD.DirAux
@13,12 SAY PROV.Nomc_V
@13,54 SAY VORD.TlfAux
@14,75 say left(vord.nroord,1)+right(alltrim(str(_ano)),2)+[-]+right(vord.nroord,6)
*@14,75 SAY VORD.NroOrd PICT '@R !-!!!!!!'
NumLin = 19
NumPag = NumPag + 1

RETURN
************************************************************************ FIN *
FUNCTION MEMOANCHO
******************
PARAMETER xAncho
SET MEMOWIDTH  TO xAncho
RETURN ""

************************************************************************ FIN *
FUNCTION Modifica
*****************
SELE RORD
SEEK VORD->NroOrd
SCAN WHILE NroOrd = VORD->NroOrd FOR TpoReq$[RN] .AND. !EMPTY(CodMat) ;
   .AND. CanDes>0
   RETURN .F.
ENDSCAN
RETURN .T.
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
************************************************************************** FIN
* procedimiento que graba el recnop para saber fin de o/c
******************************************************************************
PROCEDURE  xImpPie
*********************
PUBLIC nRet
PRIVATE RecAct, Zona
Zona   = SELECT()
IF EOF()
   RecAct = RECCO()
ELSE
   RecAct = RECNO()
ENDI
SEEK XsNroOrd
SCAN WHILE  &xWHILE
   nRet = RECNO()
ENDSCAN
SELECT (Zona)
GOTO (RecAct)
RETURN  (nRet)
******************************************************************************
* Pintar pie de O/Compra de Importaci¢n
******************************************************************************
PROCEDURE xPieImp

*@ 10,1  SAY "  Nro.   T                                        Precio     Precio   Importe " COLOR SCHEME 7
*@ 11,1  SAY "Requisic R  C¢digo de Material   Und  Cantidad     FOB      Unitario   Total  " COLOR SCHEME 7
@ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
@ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
@ 18,0  SAY "ÝValor F.O.B.:              INSPECCION:                GTOS.OPER.:                Ý"
@ 19,0  SAY "Ý    FLETE   :              HANDLING  :               COMISION AA:                Ý"
@ 20,0  SAY "Ý     SEGURO :              ADVALOREN :                     OTROS:                Ý"
@ 21,0  SAY "ÝValor C.I.F.:              ALM.MANTT.:             <Valor TOTAL>:                Ý"
RETU

******************************************************************************
* pintado pie de O/c Nacional
******************************************************************************
PROCEDURE xPieNac
*@ 10,1  SAY "  Nro.   T                                        Precio              Importe "  COLOR SCHEME 7
*@ 11,1  SAY "Requisic R  C¢digo de Material   Und  Cantidad   Unitario  % Descto    Total  "  COLOR SCHEME 7
@ 10,0  SAY "Ý---------------------------------------------------------------------------------|"
@ 11,0  SAY "ÝNro.Req. TR C¢digo de Material   Und  Cantidad   Pre.Uni.  % Descto   Imp.Tot    Ý"
@ 18,0  SAY "Ý                                                                                 Ý"
@ 19,0  SAY "Ý Imp.Bruto :             Imp.Decto.:             Valor Venta :                   Ý"
@ 20,0  SAY "Ý Imp.Flete :             Otro Gast.:             IGV.      % :                   Ý"
@ 21,0  SAY "Ý                                          Precio Venta Total :                   Ý"
RETU
******************************************************************************
****************
function _moneda
****************
parameter _mon
do case
	case _mon=1
	 return [NUEVOS SOLES]
	case _mon=2
	 return [DOLARES AMERICANOS]
	case _mon=3
	 return [DOLARES CANADIENSES]
	case _mon=4
	 return [MARCOS ALEMANES]
endcase
*
****************
FUNCTION vTipDoc
****************
ulttecla = lastkey()
if ulttecla = f8
   if !cmpbusca("TBFP")
      return .f.
   endif
   xsfmapgo = fmapgo
   ulttecla = enter
endif
SEEK XsFmaPgo
IF ! FOUND()
*!*	   GsMsgErr = [** Forma de Pago No Registrado **]
*!*	   DO LIB_Merr WITH 99
   UltTecla = 0
*!*	   return .f.
ENDIF
return .t.
*****************
PROCEDURE DATaDIC
*****************
DO CMPDIMPO.spr
return

