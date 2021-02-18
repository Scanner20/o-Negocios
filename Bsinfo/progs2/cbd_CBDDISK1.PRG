*<<<<<<< HEAD
** VETT:Este programa lo hice en 1993 y lo utilicé en 1995 en Tele2000 y despues en 2009 en TopSport 2021/02/12 15:11:56 ** 
*=======
******************************************************************************+++++++++++++++++++**
* Programa      : CBD_CBDDISK1.PRG                                                                *
* Objeto        : Generar asiento automatico en base a modelo                                     *
* Creación      : 16 mayo 1994  VETT		                                                      *
* Actualización : 																				  *
* Actualización :                                                                                 *
***************************************************************************************************
** VETT:Este programa lo cree en 1994 y lo utilice en Tele2000 en 1995 y TopSport en 2009 2021/02/12 15:58:34 ** 
*>>>>>>> dev1

PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')

=F1_BASE(GsNomCia,PADR(MES(_Mes,1),10)+TRAN(_Ano,"9999"),"Usuario:"+GsUsuario,GsFecha)
ArcTmp   = PATHUSER+SYS(3)
UltTecla = 0

IF MESSAGEBOX( [Este proceso tiene por finalidad procesar información ] +;
             			[proveniente de otros sistemas que trabajan fuera del ]+;
             			[entorno de la red de contabilidad. Esta información puede]+;
             			[corresponder a los registros de ventas, ingresos de caja,]+;
             			[almacen,etc., la cual es proporcionada a traves de archivos ]+;
             			[de interface para su integración al sistema contable.],32+1+256,'INTERFACE') = 2
            UltTecla = K_ESC 			
             
ENDIF
IF UltTecla = K_ESC
   RETURN
ENDIF
PRIVATE nX0,nY0,nX1,nY1,sModulo
PRIVATE m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
STORE [] TO m.bTitulo,m.bDeta,m.bclave1,m.bClave2,m.bCampos,m.bfiltro,m.bBdorde
m.Estoy = [MOSTRANDO]

** Abrimos areas a usar **
***  bases auxiliares  ****
goentorno.open_dbf1('ABRIR','CBDVMDLO','VMDL','VMDL01')


*** PANTALLA DE ENTRADA DE DATOS ***





*****  Variables de Entrada *****
PathTras = ADDBS(goentorno.tspathadm)+'Traslado\'

XcDrive  = "A"
NroDec   = 2
XsNroMes = TRANSF(_MES,"@L ##")
XnMes    = _MES
XsNomArc   = SPACE(8)
XsCodMod = SPACE(LEN(VMDL.CodMod))
XfTpoCmb = 0
XdFchAst = GdFecha
lTexto   = .F.
Solo_Uno = .F.
XiSolo_Uno = 1
GsRutaAux  = "\BASE\CIA001\C"+tran(_ano,[9999])+[\]
TsCodDiv1  = [01]
**GsRutaAux  = ""
store [] to XsCodFin,XsIniAux,XsNivAdi,XcTipoC,XsTipDoc
do FORM CBD_cbddisk1
****************
PROCEDURE Procesar
****************
=F1qh([Abriendo archivos...])

IF XiSolo_uno=1
   SOLO_UNO = .T.
ELSE
   SOLO_UNO = .F.
ENDIF
IF !LoContab.MOVApert()
	RELEASE LoContab 
	RETURN
ENDIF
XdFchAst = GdFecha
*** Abriendo archivos y transfiriendo informacion de archivo Interface
Interface = PATHTRAS+XsNomArc
XsNroMes  = TRANS(XnMes,"@L ##")
ArcStru = PathTras+[MAYOR]

IF lTexto
    SELE 0
    USE &ArcStru
    IF !USED()
       RETURN
    ENDIF
    COPY STRU TO &INTERFACE..DBF
    USE &INTERFACE ALIAS INTERFACE
    IF !USED()
       RETURN
    ENDIF
    APPEND FROM &INTERFACE..ITX SDF
ELSE
    SELE 0
    USE &INTERFACE..IBD ALIAS INTERFACE
    IF !USED()
       RETURN
    ENDIF
ENDIF
*
goentorno.open_dbf1('ABRIR','CBDRMDLO','RMDL','RMDL01')
*
goentorno.open_dbf1('ABRIR','CBDVMDLO','VMDL','VMDL01')
*
SELECT VMDL
SEEK XsCodMod
DO WHILE !RLOCK()
ENDDO
** Asegurarse de blanquear este campo siempre al inicio del proceso
REPLACE NroAst WITH []
UNLOCK
****
* Creamos archivo auxiliar para resumen *
SELE RMOV
ArcTmp2 = PATHUSER+SYS(3)
COPY STRU TO &ArcTmp2
SELE 0
USE &ArcTmp2 ALIAS xRMOV EXCL
IF !USED()
   RETURN
ENDIF
**INDEX ON NroMes+CodRef+CodCta+STR(CodMon,1,0)+TpoMov TAG RMOV01
INDEX ON NroMes+CodCta+CodRef+ClfAux+CodAux+STR(CodMon,1,0)+TpoMov  TAG RMOV01
***

Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
Store 0 TO LinAct,LinIni
TsNroAst = []
Cancelar = .F.

*!*	DO F1_CAJA WITH 20, 79, "DIARIOGEN",11,[DIARIO GENERAL]
*!*	ACTIVATE  WINDOW DIARIOGEN


*=F1QH("Grabando detalle del asiento")

IsCodMOd = XsCodMOd
SELE INTERFACE
GO TOP
IF UPPER(XsNomArc)=[ALM]
   IF !EMPTY(XsCodMod)
      SET FILTER TO CODMOV=XsCodMod
      GO TOP
   ENDIF
ENDIF
DO WHILE !EOF() and !Cancelar
   LdFchDoc = FchDoc
  *LdFchDoc = CTOD(SUBSTR(FchDoc,2,2)+"/"+SUBS(FchDoc,3,2)+"/"+SUBS(FCHDOC,5,2))
   LdFchVto = LdFchDoc
   LsCodAux = CodAux
   LsCodDoc = CodDoc
   LsCodDo1 = LsCodDoc
   LsNomAux = NomAux
   LsNroDoc = NroDoc
   LsNroRef = LsNroDoc
   LdFchAst = XdFcHAst
   LiCodMon = CodMon
   XfTpoCmb = TpoCmb
   LfImpBrt = ImpBrt
   LfImpIgv = ImpIgv
   LfImpTot = ImpTot
   LfImport = Import
   **  Campos adicionales **
   LsCmpAd1 = CodMat
   LsCmpAd2 = CodMov
   LsCmpAd3 = CodAux
   IF EMPTY(IsCodMod) AND UPPER(XsNomArc)=[ALM]
      XsCodMod = LsCmpAd2
      lHayModelo=SEEK(XsCodMod,[VMDL])
      IF lHayModelo
         IF VMDL.CodMon= 1
            LfIMport = Interface.Import
         ELSE
            LfIMport = Interface.ImpUsa
         ENDIF
      ELSE
         SELE INTERFACE
         SKIP
         LOOP
      ENDIF
   ENDIF
   **** Variables externas que necesita la rutina ***
   lPinta    = .T.  && Muestra informaci¢n en pantalla mientras esta grabando
   Yo        = 6
   Xo        = 0
   IF EMPTY(LfImport)
      DO xGen_Ast  WITH XsCodMod,Solo_Uno,LfImpIgv,LfImpBrt,LfImpTot,0
   ELSE
      DO xGen_Ast  WITH XsCodMod,Solo_Uno,LfImport,0,0,0
   ENDIF
   ****
   SELE INTERFACE
   SKIP
   IF EOF()
      DO xGrbResu
   ENDIF
   Cancelar = (INKEY()=K_ESC OR Cancelar)
ENDDO
=F1QH("")
IF lTexto
   DELE FILE &Interface..DBF
ENDIF
*!*	DEACTIVATE WINDOW DIARIOGEN
RETURN
******************
PROCEDURE xGen_Ast
******************
PARAMETERS Modelo,Cabecera,L1,L2,L3,L4
IF PARAMETER()<=1
   DO F1MsgErr WITH "Error en env¡o de parametros"
   RETURN
ENDIF
****  Inicio de conversi¢n de datos ****
NroDec   = 4
Crear    = .T.
OK = .T.
ScrMov   = ""
XsNroMes = TRANSF(_MES,"@L ##")
lDesBal = .T.
lTpoCorr = 1
Modificar= .T.
DO CASE
   CASE Cabecera AND EMPTY(TsNroAst)
        LinIni    = Yo
        LinAct    = LinIni + 1
   CASE !Cabecera
        LinIni    = Yo
        LinAct    = LinIni + 1
ENDCASE
STORE "" TO XsNroAst,XsNotAst,XiCodMon,XsNroVou,XsCodOpe
STORE "" TO nImpNac,nImpUsa,Ngl,XsCodMod
DIMENSION vNroAst(10),vCodCta(10),vCodAux(10),vNroDoc(10),vFchVto(10),vTotCta(10)
DIMENSION vCodMon(10),vCodDoc(10),vImport(10),vNroRef(10),vNroItm(10),vFchDoc(10)
DIMENSION vTpoMov(10),vCodRef(10),vGloDoc(10),vClfAux(10),sImport(10),vCodDo1(10)
DIMENSION vImp(4)
STORE [] TO V1,V2,V3,V4
*STORE 0 TO L1,L2,L3,L4
STORE [] TO vNroAst,vCodCta,vCodAux,vNroDoc,vFchVto,vNroCaj
STORE [] TO vCodMon,vCodDoc,vImport,vNroRef,vNroItm,vFchDoc
STORE [] TO vTpoMov,vCodRef,vGloDoc,vClfAux,sImport,vcoddo1
sFmt = "9,999,999.99"
MaxEle1 = 0

STORE 0 TO vImp
iDigitos=0
**********************
** Rutina Principal **
**********************
XsCodMod = Modelo
UltTecla = 0
DO WHILE UltTecla <> K_Esc
   SELE VMDL
   SEEK XsCodMod
   IF !FOUND()
       DO F1MsgErr WITH [Modelo no definido]
       UltTecla = 0
       EXIT
   ENDIF
   IF lPinta
      DO CASE
         CASE Cabecera AND EMPTY(TsNroAst)
*!*	              DO cbdprmov.spr
         CASE !Cabecera
*!*	              DO cbdprmov.spr
      ENDCASE
   ENDIF
   Tot_Imp = 0
   DO MOVEImpG       && Pide importe de seg£n # de glosas del modelo
   IF UltTecla = K_Esc
      EXIT
   ENDIF
   DO MOVSlMov    && Pide el c¢digo de operaci¢n a ingresar
   **** Correlativo Mensual ****
   SELECT RMOV
   SET ORDER TO RMOV01
   SELECT VMOV
   SET ORDER TO VMOV01
   DO MOVNoDoc
   SELECT VMOV
   IF CREAR         && TOMAMOS DATOS DEL MODELO
      DO MovInvar
   ELSE
      DO MovMover
   ENDIF
   DO Movedita
   ** Tomamos datos de modelo
   DO MovGeRmov             && GENERAMOS DETALLE DEL ASIENTO SEG£N MODELO
   DO MovBrowM
   DO MovGrabM
   SELE VMOV
   UNLOCK ALL
   EXIT
ENDDO
RETURN
******************
PROCEDURE MOVSlMov
******************
** Pide Operaci¢n **
SELECT OPER
SEEK VMDL->CodOpe
IF !FOUND()
   DO F1MsgErr WITH "Operaci¢n mal configurada en asiento modelo"
   UltTecla = K_ESC
   RETURN
ENDIF
XsCodOpe = OPER->CodOpe
RETURN
************************************************************************** FIN
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE MOVNoDoc
XsNroAst = NROAST()
Crear = .t.
** Posicionamos en el ultimo registro + 1 **
SELECT VMOV
IF OPER->TPOCOR = 1
   SEEK (XsNroMes+XsCodOpe+Chr(255))
ELSE
   SEEK (XsCodOpe+Chr(255))
ENDIF
IF RECNO(0) > 0 .AND. RECNO(0) <= RECCOUNT()
   GOTO RECNO(0)
ELSE
   GOTO BOTTOM
   IF ! EOF()
      SKIP
   ENDIF
ENDIF
IF Cabecera AND !EMPTY(TsNroAst)
   XsNroAst = TsNroAst
ENDIF
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF (XsNroMes + XsCodOpe) <> (NroMes + CodOpe ) .OR. EOF()
   XsNroAst = NROAST()
   Crear = .t.
   IF Cabecera
      TsNroAst = XsNroAst
      SELE VMOV
   ENDIF
ELSE
   XsNroAst = VMOV->NroAst
  *DO MovPinta
   IF !Cabecera
      DO MovBorra
   ENDIF
   Crear = .f.
ENDIF
SELECT VMOV
RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar
XsNroVou = SPACE(LEN(VMOV->NROVOU))
XiCodMon = VMDL->CodMon
XsNotAst = VMDL->NotAst
XsDigita = GsUsuario
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
*******************
DO MovMover
DO Cbdprmov.spr
RETURN
************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE MOVMover
XdFchAst = VMOV->FchAst
XsNroVou = VMOV->NroVou
XiCodMon = VMOV->CodMon
XfTpoCmb = VMOV->TpoCmb
XsNotAst = VMOV->NOTAST
XsDigita = GsUsuario
RETURN
************************************************************************** FIN
* Procedimiento de edita las variables de cabecera
******************************************************************************
PROCEDURE MOVEdita
******************
UltTecla = 0
IF ! Crear
   IF !F1_RLock(5)
      DO F1MsgErr WITH "Asiento usado por otro usuario"
      UltTecla = k_Esc
      RETURN              && No pudo bloquear registro
   ENDIF
ENDIF
SELECT TCMB
SEEK DTOC(XdFChAst,1)
IF ! FOUND()
   OK = .F.
   ?? chr(7)
   WAIT "T/Cambio no registrado" NOWAIT WINDOW
   GOTO BOTTOM
ENDIF
IF Crear
   XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
ENDIF
IF ! OK
   APPEND BLANK
   REPLACE FCHCMB WITH XdFchast
ENDIF
IF OPER->TpoCmb=1
   IF OFICMP = 0
      REPLACE OFICMP WITH XfTpoCmb
   ENDIF
ELSE
   IF OFIVTA = 0
      REPLACE OFIVTA WITH XfTpoCmb
   ENDIF
ENDIF
SELECT VMOV
RETURN
************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
IF !F1_RLock(5)
   do f1MsgErr with "Asiento usado por otro usuario"
   UltTecla = K_Esc
   RETURN              && No pudo bloquear registro
ENDIF
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. ;
   Llave = (NroMes + CodOpe + NroAst )
   IF Rlock()
      SELECT RMOV
      IF ! XsCodOpe = "9"
         DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa ,CodDiv
      ELSE
         DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa  
      ENDIF
      DELETE
      UNLOCK
   ELSE
      ok = .f.
   ENDIF
   SKIP
ENDDO
SELECT VMOV
IF Ok
   REPLACE FlgEst WITH " "
ENDIF
RETURN
************************************************************************** FIN
* Procedimiento de Grabar las variables de cabecera
******************************************************************************
PROCEDURE MOVGraba
IF UltTecla = k_Esc
   RETURN
ENDIF
UltTecla = 0
IF Crear                  && Creando
   SELE OPER
   IF ! F1_RLock(5)
      UltTecla = k_Esc
      RETURN              && No pudo bloquear registro
   ENDIF
   SELECT VMOV
   SEEK (XsNroMes + XsCodOpe + XsNroAst)
   IF FOUND()
      XsNroAst = NROAST()
      SEEK (XsNroMes + XsCodOpe + XsNroAst)
      IF FOUND()
         DO F1MSGERR WITH [Registro creado por otro usuario]
         UltTecla = K_Esc
         RETURN
      ENDIF
   ENDIF
   APPEND BLANK
   IF ! F1_RLock(5)
      UltTecla = k_Esc
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE VMOV->NROMES WITH XsNroMes
   REPLACE VMOV->CodOpe WITH XsCodOpe
   REPLACE VMOV->NroAst WITH XsNroAst
   IF Crear
     REPLACE VMOV->FLGEST  WITH "R"   && Asiento Tipo ??
   ELSE
     REPLACE VMOV->FLGEST  WITH "R"
   ENDIF
   replace vmov.fchdig with date()
   replace vmov.hordig with time()
   SELECT OPER
   =NROAST(XsNroAst)
   SELECT VMOV
ELSE
   *** ACTUALIZA CAMBIOS DE LA CABECERA EN EL CUERPO ***
   IF VMOV->FchAst <> XdFchAst .OR. VMOV->NroVou <> XsNroVou
      SELECT RMOV
      Llave = (XsNroMes + XsCodOpe + XsNroAst )
      SEEK Llave
      DO WHILE ! EOF() .AND. Llave = (NroMes + CodOpe + NroAst )
         IF Rlock()
            REPLACE RMOV->FchAst  WITH XdFchAst
            REPLACE RMOV->NroVou  WITH XsNroVou
            UNLOCK
         ENDIF
         SKIP
      ENDDO
   ENDIF
   SELECT VMOV
ENDIF
REPLACE VMOV->FchAst  WITH XdFchAst
REPLACE VMOV->NroVou  WITH XsNroVou
REPLACE VMOV->CodMon  WITH XiCodMon
REPLACE VMOV->TpoCmb  WITH XfTpoCmb
REPLACE VMOV->NotAst  WITH XsNotAst
REPLACE VMOV->Digita  WITH GsUsuario
IF Tot_Imp = 0 AND !Cabecera
   REPLACE VMOV->NotAst  WITH " A N U L A D O "
   REPLACE FLGEST WITH "R"
   REPLACE VMOV->DbeNac  WITH 0
   REPLACE VMOV->DbeUsa  WITH 0
   REPLACE VMOV->HbeNac  WITH 0
   REPLACE VMOV->HbeUsa  WITH 0
ENDIF
RETURN
************************************************************************ FIN *
PROCEDURE BORRLIN
*****************
IF ! f1_RLOCK(5)
   UltTecla = k_Esc
ENDIF
DELETE
UNLOCK
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa ,CodDiv
ELSE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , -Import , -ImpUsa
ENDIF
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
DO CalImp
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac-nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa-nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac-nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa-nImpUsa
ENDIF
SELECT RMOV
RETURN
************************************************************************ FIN *
* Renumerar los items
******************************************************************************
PROCEDURE RenumItms
PARAMETERS T_Itms
DO WHILE &RegVal .AND. ! EOF()
   IF RLOCK()
      REPLACE NroItm   WITH T_Itms
   ENDIF
   UNLOCK
   SKIP
   T_Itms = T_Itms + 1
ENDDO
RETURN
*****************
PROCEDURE CalImp
*****************
nImpNac = Import
nImpUsa = ImpUsa
RETURN
**********************************************************************
* Pinta Importe Totales
**********************************************************************
**********************************************************************
* Regenerar Acumulados ===============================================
**********************************************************************
PROCEDURE MovF3
*******************
sNomBre= [CONSULTA]
nLargo = 4
nAncho = 32
sTitulo= []
nColor = 2
DO F1_CAJA WITH nLargo,nAncho,sNombre,nColor,sTitulo

ACTIVATE WINDOW (sNomBre) NOSHOW

@ 01,00 SAY PADC("R E C A L C U L A N D O",nAncho - 2)
@ 02,00 SAY PADC("Espere un momento por favor",nAncho-2)


T_DbeNac =0
T_HbeNac =0
T_DbeUsa =0
T_HbeUsa =0
T_Ctas =0
**** Recalculando Importes *************************
T_Itms =0
Chqado =0
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
   T_Itms = T_Itms + 1
   IF T_Itms <> NroItm
      Chqado =Chqado +1
   ENDIF
   IF RLOCK()
      REPLACE ChkItm   WITH T_Itms
   ENDIF
   UNLOCK
   DO CalImp
   IF TpoMov  ="D"
      T_DbeNac = T_DbeNac + nImpNac
      T_DbeUsa = T_DbeUsa + nImpUsa
   ELSE
      T_HbeNac = T_HbeNac + nImpNac
      T_HbeUsa = T_HbeUsa + nImpUsa
   ENDIF
   T_Ctas = T_Ctas + VAL(LTRIM(TRIM(CodCta)))
   SELECT RMOV
   SKIP
ENDDO
*---------------------------------------------------*save
SELE VMOV
IF F1_RLOCK(5)
   REPLACE VMOV->ChkCta  WITH T_Ctas
   REPLACE VMOV->DbeNac  WITH T_DbeNac
   REPLACE VMOV->DbeUsa  WITH T_DbeUsa
   REPLACE VMOV->HbeNac  WITH T_HbeNac
   REPLACE VMOV->HbeUsa  WITH T_HbeUsa
   REPLACE VMOV->NroItm  WITH T_Itms
ENDIF
SELE RMOV
**** Chequeo del Nro de Items **********************
IF Chqado > 0
   TnItms = 0
   DO WHILE TnItms < T_Itms
      TnItms =0
      SEEK VCLAVE
      DO WHILE EVALUATE(RegVal) .AND. ! EOF()
         IF NroItm <> ChkItm
            IF RLOCK()
               REPLACE NroItm   WITH ChkItm
            ENDIF
            UNLOCK
         ELSE
            TnItms = TnItms + 1
         ENDIF
         SKIP
      ENDDO
   ENDDO
ENDIF
RELEASE WINDOW (sNombre)
DO MovPImp
Fin  = .T.
RETURN
******************
PROCEDURE MOVEimpG
******************
PRIVATE i
Ngl = 0
STORE 0 TO V1,V2,V3,V4
FOR kk = 1 TO 4
    LsGlosa = "GIMPO"+TRANS(kk,"9")
    IF !EMPTY(&LsGlosa)
       Ngl = Ngl + 1
    ENDIF
ENDFOR
LinImp = 3
IF !EMPTY(VMDL->GImpo1)
   LinImp = LinImp + 1
ENDIF
IF !EMPTY(VMDL->GImpo2)
   LinImp = LinImp + 1
ENDIF
IF !EMPTY(VMDL->GImpo3)
   LinImp = LinImp + 1
ENDIF
IF !EMPTY(VMDL->GImpo4)
   LinImp = LinImp + 1
ENDIF
IF LinIMp<4
   GsMsgErr = "Asiento tipo/modelo no esta bien definido"
   DO F1MSGERR WITH GSMSGERR
   UltTecla = K_Esc
   RETURN
ENDIF
ColImp = LEN(Gimpo1) + 1
FOR kk = 1 TO 4
    Campo = "L"+TRANS(kk,"9")
    Campo2= "V"+TRANS(kk,"9")
   *IF &Campo<>0
       &Campo2 = TRANS(&Campo ,"9999999.99")
   *ENDIF
    Tot_Imp = Tot_Imp + &Campo
ENDFOR
RETURN
******************
PROCEDURE MovBrowM
******************
IF UltTecla = K_Esc
   RETURN
ENDIF
LnNeto = 0
DO CalNeto
RETURN
******************
PROCEDURE MOVPimpM
******************
PRIVATE j
Store 0 TO ZfImpNac,ZfImpUsa
IF !Cabecera
   Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
ENDIF
FOR j = 1 TO MaxEle1
    IF vCodMon(j) = 1
       ZfImpNac = vImport(j)
       IF XfTpoCmb = 0
         ZfImpUsa = 0
       ELSE
         ZfImpUsa = round(vImport(j)/XfTpoCmb,2)
       ENDIF
    ELSE
       ZfImpNac =  round(vImport(j)*XfTpoCmb,2)
       ZfImpUsa =  vImport(j)
    ENDIF
    IF vTpoMov(j)='D'
       TfDbeNac = TfDbeNac + ZfImpNac
       TfDbeUsa = TfDbeUsa + ZfImpUsa
    ELSE
       TfHbeNac = TfHbeNac + ZfImpNac
       TfHbeUsa = TfHbeUsa + ZfImpUsa
    ENDIF
    IF TRIM(sImport(j))="NETO"
       LnNeto = J
    ENDIF
ENDFOR
IF lPinta
   IF XiCodMon = 1
    * @  20,40    SAY "S/."                                   COLOR SCHEME 7
      @  15,48    SAY TfDbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7
      @  15,63    SAY TfHbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7

    * @  23,40    SAY "US$"                                   COLOR SCHEME 7
    * @  23,47    SAY TfDbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7
    * @  23,64    SAY TfHbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7
   ELSE
    * @  20,40    SAY "US$"                                   COLOR SCHEME 7
      @  15,48    SAY TfDbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7
      @  15,63    SAY TfHbeUsa      PICTURE "999,999,999.99"  COLOR SCHEME 7

    * @  23,40    SAY "S/."                                   COLOR SCHEME 7
    * @  23,47    SAY TfDbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7
    * @  23,64    SAY TfHbeNac      PICTURE "999,999,999.99"  COLOR SCHEME 7
   ENDIF
ENDIF
RETURN
**********************************************************************
* CALCULO DE IMPORTES================================================
**********************************************************************
PROCEDURE CalNeto
*****************
IF !Cabecera
   Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
ENDIF
DO MovPimpM
IF LnNeto > 0
   IF vCodMon(LnNeto) = 1
       vImport(LnNeto) = TfHbeNac - TfDbeNac
       IF TfHbeNac<TfDbeNac
          vImport(LnNeto) = ABS(TfHbeNac - TfDbeNac)
          vTpoMov(LnNeto) = "H"
       ELSE
          IF TfHbeNac>TfDbeNac
             vCodCta(LnNeto) = "97601"
             vTpoMov(LnNeto) = "D"
             vImport(LnNeto) = ABS(TfHbeNac - TfDbeNac)
          ENDIF
       ENDIF
   ELSE
       vImport(LnNeto) = TfHbeUsa - TfDbeUsa
       IF TfHbeUsa<TfDbeUsa
          vImport(LnNeto) = ABS(TfHbeUsa - TfDbeUsa)
          vTpoMov(LnNeto) = "H"
       ELSE
          IF TfHbeUsa>TfDbeUsa
             vCodCta(LnNeto) = "97601"
             vTpoMov(LnNeto) = "D"
             vImport(LnNeto) = ABS(TfHbeUsa - TfDbeUsa)
          ENDIF
       ENDIF
   ENDIF
   DO MovPimpM
ENDIF
RETURN
*******************
PROCEDURE ChkDesBal
*******************
Store 0 TO TfDbeNac,TfDbeUsa,TfHbeNac,TfHbeUsa
DO MovPimpM
lDesBal = ( ABS(TFHbeUsa-TfDbeUsa) >.05 ) .OR. ;
          ( ABS(TfHbeNac-TfDbeNac) >.01 )
IF lDesBal
   DO F1MSGERR WITH "Asiento Desbalanceado"
ENDIF
RETURN
*******************
PROCEDURE MOVGeRmov
*******************
IF UltTecla = K_Esc
   UltTecla = 0
   RETURN
ENDIF
PRIVATE nEle
MaxEle1 = 0
nEle    = 0
SELE RMDL
SEEK XsCodMod
DO WHILE !EOF() .AND. CodMod=XsCodMod
   nEle = nEle + 1
   LsCodAux = []
   vNroAst(nEle) = XsNroAst
   vCodRef(nEle) = RMDL->CodRef
   vTotCta(nEle) = RMDL->TotCta
   vCodCta(nEle) = _COdCta(RMDL.PrgCta)
   vClfAux(nEle) = RMDL->ClfAux
   vCodAux(nEle) = RMDL->CodAux
   vNroDoc(nEle) = RMDL->NroDoc
   vFchVto(nEle) = RMDL->FchVto
   vFchDoc(nEle) = RMDL->FchDoc
   vGloDoc(nEle) = RMDL->GloDoc
   IF XsNomArc = [ALM]
      vGloDoc(nEle) = TRIM(RMDL->GloDoc) +[:]+LsCmpAd1
   ENDIF
   vTpoMov(nEle) = RMDL->TpoMov
   vCodMon(nEle) = VMDL->CodMon
   vImport(nEle) = _Import(RMDL->Import)
   sImport(nEle) = RMDL->Import
   vCodDoc(nEle) = RMDL->CodDoc
   vCodDo1(nEle) = RMDL->CodDo1
   vNroRef(nEle) = RMDL->NroRef
   vNroItm(nEle) = RMDL->NroItm
   ** Reclasificamos datos **
   =SEEK(vCodCta(nEle),"CTAS")
   IF CTAS->PidAux="S"
      IF EMPTY(vClfAux(nEle))
         vClfAux(nEle) = CTAS->ClfAux
      ENDIF
      IF EMPTY(vCodAux(nEle))
         vCodAux(nEle) = LsCodAux
      ENDIF
   ENDIF
   IF CTAS->PidDoc = "S"
      IF EMPTY(vCodDo1(nEle))
         vCodDo1(nEle) = LsCodDo1
      ENDIF
      IF EMPTY(vNroRef(nEle))
         vNroRef(nEle) = LsNroRef
      ENDIF
      IF EMPTY(vFchDoc(nEle))
         vFchDoc(nEle) = LdFchDoc
      ENDIF
   ENDIF
   IF CTAS->PidGlo = "S"
      IF EMPTY(vCodDoc(nEle))
         vCodDoc(nEle) = LsCodDoc
      ENDIF
      IF EMPTY(vNroDoc(nEle))
         vNroDoc(nEle) = LsNroDoc
      ENDIF
      IF EMPTY(vFchVto(nEle))
         vFchVto(nEle) = LdFchVto
      ENDIF
      IF Tot_imp = 0
         vGloDoc(nEle) = "A N U L A D O"
      ENDIF
   ENDIF
   IF CTAS->PidAux="S"
      IF EMPTY(vClfAux(nEle))
         vClfAux(nEle) = LsClfAux
      ENDIF
      IF EMPTY(vCodAux(nEle))
         vCodAux(nEle) = LsCodAux
      ENDIF
   ENDIF
   **
   SELE RMDL
   SKIP
ENDDO
MaxEle1 = nEle
RETURN
******************
PROCEDURE MOVGrabM
******************
PRIVATE ii
IF UltTecla = K_Esc &&.OR. lDesbal
   RETURN
ENDIF
Do MovGraba
IF lPinta
   DO MovPinta
ENDIF
** Tan facil que era poner esto **
NClave   = [NroMes+CodOpe+NroAst]
VClave   = XsNroMes+XsCodOpe+XsNroAst
IF (LEN(TRIM(VClave)) <> 0)
   RegVal   = "&NClave = VClave"
ELSE
   * - Todos los registros son v lidos.
   RegVal = ".T."
ENDIF
**
ii = 1
FOR  ii = 1 TO MaxEle1
     Crear = .T.
     XiNroItm = VMOV->NroItm + 1
     XcEliItm = " "
     XsNroVou = XsNroVou
     XfImpFob = 0
     XdFchDoc = vFchDoc(ii)
     XiCodMon = vCodMon(ii)
     XsCodCta = vCodCta(ii)
     XsCodRef = vCodRef(ii)
     XsClfAux = vClfAux(ii)
     XsCodAux = vCodAux(ii)
     XcTpoMov = vTpoMov(ii)
     XfImport = vImport(ii)
     XsGloDoc = vGloDoc(ii)
     XsCodDoc = vCodDoc(ii)
     XsCodDo1 = vCodDo1(ii)
     XsNroDoc = vNroDoc(ii)
     XsNroRef = vNroRef(ii)
     XdFchVto = vFchVto(ii)
     XsNroRuc = []
     XsGloDoc2 = []
     XcTipo   = []
     XsCodDiv = TsCodDiv1
     IF XfImport#0
        IF XiCodMon = 1
           XfImpNac = XfImport
           IF XfTpoCmb = 0
              XfImpUsa = 0
           ELSE
              XfImpUsa = round(XfImport/XfTpoCmb,2)
           ENDIF
        ELSE
           XfImpNac = round(XfImport*XfTpoCmb,2)
           XfImpUsa = XfImport
        ENDIF
        **** Grabando la linea activa ****
        XcEliItm = " "
        IF vTotCta(ii)="S"
           DO MOVbgra1
        ELSE
           DO MOVbGrab  IN CBDprmov
           DO Pintalin
        ENDIF
        RegAct = RECNO()
        *** Requiere crear cuentas automaticas ***
        =SEEK(XsCodCta,"CTAS")
        IF CTAS->PidAux="S"
           SELE AUXI
           SEEK XsClfAux+TRIM(XsCodAux)
           IF !FOUND()
              APPEND BLANK
              IF RLOCK()
                 REPLACE ClfAux WITH XsClfAux
                 REPLACE CodAux WITH XsCodAux
                 REPLACE NomAux WITH LsNomAux
                 UNLOCK
              ENDIF
           ENDIF
        ENDIF
        IF CTAS->GenAut ="S"
           **** Actualizando Cuentas Autom ticas ****
           XcEliItm = [*]
           TsClfAux = SPACE(LEN(RMOV->CLFAUX))
           TsCodAux = SPACE(LEN(RMOV->CODAUX))
           TsAn1Cta = CTAS->An1Cta
           TsCC1Cta = CTAS->CC1Cta
           IF EMPTY(TsAn1Cta) AND EMPTY(TsCC1Cta)
              TsClfAux = "04 "
              TsCodAux = CTAS->TpoGto
              TsAn1Cta = XsCodAux      && RMOV->CodAux
              TsCC1Cta = CTAS->CC1Cta
              TsCc1Cta = "79"+SUBSTR(TsAn1Cta,2,6)
              ** Verificamos su existencia **
              IF ! SEEK("05 "+TsAn1Cta,"AUXI")
                 sErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
                 DO F1MsgErr WITH sErr
                 RETURN
              ENDIF
           ELSE
              IF XSCODCTA >= "6000" AND XSCODCTA <= "6069"
                 IF INLIST(TsAn1Cta,"20","24","25","26")
                    TsClfAux = XSCLFAUX
                    TsCodAux = XSCODAUX
                 ENDIF
              ENDIF
              IF ! SEEK(TsAn1Cta,"CTAS")
                 sErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
                 DO F1MsgErr WITH sErr
                 RETURN
              ENDIF
           ENDIF
           IF ! SEEK(TsCC1Cta,"CTAS")
              GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
              DO F1MsgErr WITH GsMsgErr
              RETURN
           ENDIF
           *****
           SKIP
           Crear = .T.
           ** Grabando la primera cuenta autom tica **
           XiNroItm = XiNroItm + 1
           XsCodCta = TsAn1Cta
           XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
           XsClfAux = TsClfAux
           XsCodAux = PADR(TsCodAux,LEN(RMOV.CodAux))
           IF vTotCta(ii)="S"
              DO MOVbgra1
           ELSE
              DO MOVbGrab  IN CBDprmov
              DO Pintalin
           ENDIF
           SKIP
           Crear = .T.
           ** Grabando la segunda cuenta autom tica **
           XiNroItm = XiNroItm + 1
           XsCodCta = TsCC1Cta
           XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
           XsClfAux = SPACE(LEN(RMOV->CLFAUX))
           XsCodAux = SPACE(LEN(RMOV->CODAUX))
           IF vTotCta(ii)="S"
              DO MOVbgra1
           ELSE
              DO MOVbGrab IN CBDprmov
              DO Pintalin
           ENDIF
        ENDIF
     ENDIF
ENDFOR
RETURN
********************
FUNCTION _CodCta
********************
PARAMETER  m.Prog
IF !INLIST(TRIM(UPPER(RMDL.CodCta)),[CTA])
     RETURN RMDL.CodCta
ELSE
     cCodCta = []
     RETURN  &Prog.()
ENDIF
****************
FUNCTION _Import
****************
Parameter sImport
Private i
IF Parameter() = 0 .OR. TRIM(sImport) = "?" .OR. TRIM(sImport)="NETO"
   RETURN 0
ENDIF
sImport = TRIM(sImport)
i = 1
LsEval=["]
DO WHILE i <= LEN(sImport)
   DO CASE
      CASE Substr(sImport,i,1) = "("
           LsEval = LsEval + "("
      CASE Substr(sImport,i,1) = "V"
           LsEval = LsEval +"&V"+ SUBSTR(sImport,i+1,1)+"."
           i = i + 1
      CASE Substr(sImport,i,1) $ "/-+*"
           LsEval = LsEval + SUBSTR(sImport,i,1)
      CASE Substr(sImport,i,1) $ "1234567890."
          *IF SubStr(sImport,i,1)="."
              LsEval = LsEval + "("+ SUBSTR(sImport,i,1)
              i = i + 1
              Paso = .F.
              DO WHILE SUBSTR(sImport,i,1)$"1234567890."
                 LsEval = LsEval + SUBSTR(sImport,i,1)
                 i = i + 1
                 Paso = .T.
              ENDDO
              IF Paso
                 i = i - 1
              ENDIF
              LsEval = LsEval + ")"
          *ELSE
          *   LsEval = LsEval + SUBSTR(sImport,i,1)
          *ENDIF
      CASE Substr(sImport,i,1) = ")"
           LsEval = LsEval + ")"
   ENDCASE
   i = i + 1
ENDDO
LsEval = LsEval + ["]
_TotImp = EVALUATE(&LsEval)
RETURN _TotImp
****************
******************
PROCEDURE PINTALIN
******************
IF !lPinta
   RETURN
ENDIF
IF LinAct > 13
   LinAct = 13
   SCROLL LinIni+1,Xo+1,LinAct,76,1
ENDIF
sCmp = EliItm+[ ]+CodCta+[ ]+CodAux+[ ]+NroDoc+[ ]+LEFT(GloDoc,30)
sCmp = sCmp + [ ]+TpoMov+[ ]
sCmp = sCmp + TRAN(IIF(VMOV.CodMon=1,Import,Impusa),"9,999,999.99")
@ LinAct,1 SAY sCmp COLOR (C_Linea)
LinAct = LinAct + 1
@ 14,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
RETURN
******************
PROCEDURE MovBGra1
******************
XsCodRef = SPACE(LEN(RMOV.CODREF))
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
   ENDIF
ENDIF
SELE xRMOV
SET ORDER TO RMOV01
SEEK XsNroMes+XsCodCta+XsCodRef+XsClfAux+XsCodAux+STR(XiCodMon,1,0)+XcTpoMov
IF !FOUND()
    APPEND BLANK
    REPLACE xRMOV->NroMes WITH XsNroMes
    REPLACE xRMOV->CodOpe WITH XsCodOpe
    REPLACE xRMOV->NroAst WITH XsNroAst
    REPLACE xRMOV->CodCta WITH XsCodCta
    REPLACE xRMOV->CodRef WITH XsCodRef
    REPLACE xRMOV->TpoMov WITH XcTpoMov
    REPLACE xRMOV->CodMon WITH XiCodMon
    REPLACE xRMOV->TpoCmb WITH XfTpoCmb
    REPLACE xRMOV->ClfAux WITH XsClfAux
    REPLACE xRMOV->CodAux WITH XsCodAux
    REPLACE xRMOV->EliItm WITH XcEliItm
    REPLACE xRMOV->CodDiv WITH TsCodDiv1
ENDIF
IF CodMon = 1
   REPLACE xRMOV->Import WITH xRMOV->Import + XfImport
   IF TpoCmb = 0
      REPLACE xRMOV->ImpUsa WITH xRMOV->ImpUsa + 0
    ELSE
      REPLACE xRMOV->ImpUsa WITH xRMOV->ImpUsa + round(XfImport/TpoCmb,2)
   ENDIF
ELSE
   REPLACE xRMOV->Import WITH xRMOV->Import + round(XfImport*TpoCmb,2)
   REPLACE xRMOV->ImpUsa WITH xRMOV->ImpUsa + XfImport
ENDIF
SELE RMOV
RETURN
***********************
PROCEDURE xGrbResu
***********************
xAlias=ALIAS()
SELE xRMOV
GO TOP
DO WHILE !EOF()
   SCATTER MEMVAR
   SELE RMOV
   APPEND BLANK
   GATHER MEMVAR
   replace rmov.fchdig with date()
   replace rmov.hordig with time()
   IF ! CodOpe = "9"
      DO CBDACTCT WITH  CodCta , CodRef , VAL(NroMES) , TpoMov , Import , ImpUsa ,CodDiv
   ELSE  && EXTRA CONTABLE
      DO CBDACTEC WITH  CodCta , CodRef , VAL(NroMES) , TpoMov , Import , ImpUsa
   ENDIF
   STORE 0 TO nImpNac,nImpUsa
   DO CALIMP
   IF RMOV->TpoMov = 'D'
      REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+RMOV->Import
      REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+RMOV->ImpUsa
   ELSE
      REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+RMOV->Import
      REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+RMOV->ImpUsa
   ENDIF
   REPLACE VMOV->ChkCta WITH VMOV->ChkCta-VAL(TRIM(RMOV->CodCta))
   REPLACE VMOV->NroItm WITH VMOV->NroItm + 1
   REPLACE RMOV->NroItm WITH VMOV->NroItm
   DO PINTALIN
   SELE xRMOV
   SKIP
ENDDO
SELE &xAlias
RETURN
**********************
FUNCTION _CTAALM
**********************
PRIVATE xAlias,xOrder,LsCodCta,LsCmpCta
xAlias   = ALIAS()
xOrder   = ORDER()
LsCodCta =  []
LsCmpCta =  RMDL.CodCta
LsCmpAux = [EQMAT1]
DO CASE
   CASE TRIM(UPPER(LsCmpCta))=[CTAC61C]
        LsCmpAux = [EQMAT9]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC2X]
        LsCmpAux = [EQMAT1]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC60]
        LsCmpAux = [EQMAT2]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC61]
        LsCmpAux = [EQMAT3]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC33]
        LsCmpAux = [EQMAT4]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC69]
        LsCmpAux = [EQMAT5]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC16]
        LsCmpAux = [EQMAT6]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC70]
        LsCmpAux = [EQMAT7]
   CASE TRIM(UPPER(LsCmpCta))=[CTAC71]
        LsCmpAux = [EQMAT8]
ENDCASE
LsCmpEva =  []
*** Primero tratamos  de tomar  la  cuenta del catalogo general.  ***
IF !USED([CATG])
   SELE 0
   USE ALMCATGE ORDER CATG01 ALIAS CATG
   IF !USED()
      DO F1msgerr WITH [Imposible accesar a catalogo general de materiales]
      RETURN
   ENDIF
ENDIF
IF !USED([DIVF])
   SELE 0
   USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
   IF !USED()
      DO F1msgerr WITH [Imposible accesar a maestro de divisi¢n y familias]
      RETURN
   ENDIF
ENDIF
SELE CATG
SEEK LsCmpAd1
IF FOUND()
     LsCodcta = &LsCmpCta.
     LsCodAux = &LsCmpAux.
ENDIF
*** Si no es posible tomamos la cuenta del maestro de divisiones y familias ***
IF EMPTY(LsCodCta)
     SELE DIVF
     SEEK [02]+LEFT(LsCmpAd1,LEN(CodFam))
     IF FOUND()
        LsCodCta = &LsCmpCta.
        LsCodAux = &LsCmpAux.
        vTotCta(nEle) = [S]
     ENDIF
ENDIF
SELE (xAlias)
SET ORDER TO (xOrder)
RETURN LsCodCta
