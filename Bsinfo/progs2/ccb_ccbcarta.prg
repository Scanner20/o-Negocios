*****************************************************************************
*  Nombre       : Ccbcarta.PRG												*
*  Proposito    : Cartas de Ctas x Cobrar (VINSA)							*
*  Creaci¢n     : 21/09/93													*
*  Actualizaci¢n: Carta modelo para envio a bancos y clientes 18/09/95		*
*  Autor        : VETT														*
*				  VETT 02/09/2003 Adaptacion para VFP 7					 	*
*****************************************************************************
** Abrimos areas a usar **
DO def_teclas IN fxgen_2
SYS(2700,0)
SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','MCTA','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC05','')
LoDatAdm.abrirtabla('ABRIR','CCBSALDO','SLDO','SLDO01','')
LoDatAdm.abrirtabla('ABRIR','CCBTBDOC','TDOC','BDOC01','')
LoDatAdm.abrirtabla('ABRIR','CJATCART','TCAR','TCAR01','')
LoDatAdm.abrirtabla('ABRIR','CJATCAR2','CART','CART01','')
LoDatAdm.abrirtabla('ABRIR','CCBNTASG','TASG','TASG01','')
LoDatAdm.abrirtabla('ABRIR','CCBNRASG','RASG','RASG01','')
RELEASE LoDatAdm
DO fondo WITH 'Cartas',Goentorno.user.login,GsNomCia,GsFecha
**

SELE CART
GO TOP
**
XiModelo =1                         && Modelo de Carta
XdFchDoc =DATE()                    &&
XsTpoCar =SPACE(LEN(CART->TpoCar))
XsNroCar =SPACE(LEN(CART->NroCar))  && Nro. Transacci¢n
XsRefer  =SPACE(LEN(CART->Glosa1))  &&
XsAtte   =SPACE(LEN(CART->Glosa2))
XsCodCli =SPACE(LEN(CART->CodCli))
XsNomCli =SPACE(LEN(CART->NomCli))
XsDirCli =SPACE(LEN(CART->DirCli))
XsCiudad =SPACE(LEN(CART->CiuDad))
XfTasa   =00.00
XsNroPro =SPACE(LEN(CART->NroPro))
ZsCodDoc = [CANJ]
ZsNroDoc = []
XnMonto = 0.00
XiCodMon= 1
NumDoc  = 0
lGenero = .F.
DIMENSION vDocum(10),vMonto(10)
Set MemoWidth to 76
***
*cTit1 = GsNomCia
*cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
*cTit3 = "Usuario : "+TRIM(GsUsuario)
*cTit4 = "DOCUMENTOS DE TRANSACCION - REDACCION"
*Do Fondo WITH cTit1,cTit2,cTit3,cTit4
Do Pantalla
** Rutina principal *****
**********************************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
DO F1_EDIT WITH 'Llave','Muestra','Editar','Elimina','Imprime','','','CMAR'

CLEAR MACROS
CLEAR
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
******************
Procedure Pantalla
******************
*          012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                    1         2         3         4         5         6         7
CLEAR
@ 0,0        TO 21,79
@ 1,1 SAY PADC("ENVIO DE CARTAS A CLIENTES",78) COLOR SCHEME 7
@ 2,1        TO 2,78
@ 03,02 say "Modelo :                       # Carta:               Fecha :" COLOR SCHEME 11
@ 04,02 SAY "Se¤ores:"                                                     COLOR SCHEME 11
@ 05,02 SAY "                                 Aten.:"                      COLOR SCHEME 11
@ 06,02 SAY "Ciudad :"                                                     COLOR SCHEME 11
@ 07,02 SAY "Abono  :"                                                     COLOR SCHEME 11
@ 08,02 say "Refer. :                                        # Proforma:"  COLOR SCHEME 11
@ 09,01 To 09,78
RETURN
*********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE Llave
****************
GsMsgKey = "[Esc] Cancela  [->] [<-] Escoger   [Enter] [F10] Acepta    [F8] Consulta "
DO LIB_MTEC WITH 99
XsTpoCar = TpoCar
XsNroCar = NroCar
UltTecla = 0
i        = 1
DO WHILE ! INLIST(UltTecla,escape_,F10,CtrlW)
   DO CASE
      CASE i = 1
         VecOpc(1) = "Recordatoria de pago"
         VecOpc(2) = "Env. documentos Prof."
         VecOpc(3) = "Cargos al banco"
         VecOpc(4) = "Transferencia"
         XiModelo=Elige(XiModelo,03,10,2)
         DO CASE
            CASE XiModelo = 1
                 XsTpoCar = "R/PAGO"
            CASE XiModelo = 2
                 XsTpoCar = "ENVIOD"
            CASE XiModelo = 3
                 XsTpoCar = "BANC_C"
            CASE XiModelo = 4
                 XsTpoCar = "TRANSF"
         ENDCASE
         IF ChrVal = 'C'
            SELE TCAR
            SEEK XsTpoCar
            IF !FOUND()
                GsMsgErr = "Modelo No Registrado"
                DO LIB_MERR WITH 99
                LOOP
            ENDIF
            XsNroCar = RIGHT("00000"+LTRIM(STR(TCAR->NroCar)),5)
            SELE CART
         ENDIF
      CASE i = 2
        @ 03,41  GET XsNroCar PICT "99999"
        READ
        UltTecla = LASTKEY()
        IF ChrVal = "C"
           SEEK XsTpoCar+XsNroCar
           IF FOUND()
               GsMsgErr = "Documento Creado Por Otro Usuario"
               DO LIB_MERR WITH 99
               Loop
           ENDIF
        ENDIF
        @ 03,41  SAY XsNroCar PICT "99999"
        IF UltTecla = Enter
           UltTecla = CtrlW
        ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2, 2, i)
   i = IIF(i<1, 1, i)
ENDDO
SEEK XsTpoCar+XsNroCar
IF UltTecla = escape_
   GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
   DO LIB_MTEC WITH 99
ENDIF
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE Muestra
*****************
@ 03,10  SAY TpoCar
@ 03,41  SAY NroCar
@ 03,63  SAY FchCar
=SEEK(GsClfCli+CodCli,[AUXI])
@ 04,10  SAY CodCli+[ ]+LEFT(NomCli,30)
@ 05,02  SAY DirCli PICT "@S30"
@ 06,10  SAY Ciudad PICT "@S20"
@ 05,41  SAY Atte  SIZE 2,30
@ 08,10  SAY Refer SIZE 1,30
@ 08,63  SAY NroPro PICT "@!"
@ 10,02  SAY Carta SIZE 12,76 COLOR SCHEME 7
RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE EDITAR
****************
GsMsgKey = "[] [] [Enter] Registra [F10] Graba [Esc] Cancela [TAB] Siguiente [S-TAB] Anterior"
DO LIB_MTEC WITH 99
IF EOF()
   lGenero  = .F.
   XdFchcar = DATE()
   XsGlosa1 = SPACE(LEN(CART->Glosa1))
   XsCarta  = TCAR->Carta
   XsCargo  = SPACE(LEN(CART->Cargo ))
   XsAbono  = SPACE(LEN(CART->Abono ))
   XsAtte   = [GERENCIA FINANCIERA]
   XsRefer  = SPACE(LEN(CART->Refer ))
   XsCodCli = SPACE(LEN(CART->CodCli))
   XsDirCli = SPACE(LEN(CART->DirCli))
   XsNomCli = SPACE(LEN(CART->NomCli))
   XsCiudad = SPACE(LEN(CART->Ciudad))
   XiCodMon = 1
   XsNroPro = SPACE(LEN(CART->NroPro))
ELSE
   XsTpoCar = TpoCar
   XsNroCar = NroCar
   XdFchCar = FchCar
   XsGlosa1 = CART->Glosa1
   XsCarta  = CART->Carta
   XsCargo  = CART->Cargo
   XsAbono  = CART->Abono
   XiCodMon = CART->CodMon
   XsAtte   = CART->Atte
   XsRefer  = CART->Refer
   XsCodCli = CART->CodCli
   XsDirCli = CART->DirCli
   XsNomCli = CART->NomCli
   XsCiudad = CART->Ciudad
   XsNroPro = CART->NroPro
ENDIF
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,CTRLW,escape_,F10)
   DO CASE
      CASE i = 1
         @ 03,63 get XdFchCar
         READ
         UltTecla = Lastkey()
         IF UltTecla = escape_
            EXIT
         ENDIF
      CASE I = 2
         DO CASE
            CASE  XsTpoCar=[R/PAGO]
                  XsClfAux = GsClfCli
                  SELE AUXI
                  @ 04,10 GET XsCodCli PICT "@!"
                  READ
                  UltTecla = Lastkey()
                  IF UltTecla = F8
                     SEEK XsClfAux+TRIM(XsCodCli)
                     IF !CCBbusca("CLIE")
                        UltTecla = 0
                        LOOP
                     ENDIF
                     UltTecla = Enter
                     XsCodcli = AUXI->CodAux
                  ENDIF
                  SEEK XsClfAux+TRIM(XsCodCli)
                  IF !FOUND() AND !EMPTY(XsCodCli)
                     GsMsgErr = "No existe codigo de cliente"
                     DO LIB_MERR WITH 99
                     UltTecla = 0
                     LOOP
                  ENDIF
                  @ 04,10 SAY XsCodCli PICT "@!"
                  XsDirCli = AUXI->DirAux
                  XsNomCli = AUXI->NomAux
                  IF UltTecla = escape_
                     EXIT
                  ENDIF
                  @ 04,16 GET XsNomCli PICT "@S30"
                  @ 05,02 GET XsDirCli PICT "@S30"
                  @ 06,10 GET XsCiuDad PICT "@S20"
                  READ
                  UltTecla = LASTKEY()
            CASE  XsTpoCar=[ENVIOD]
                  XsClfAux = GsClfCli
                  SELE AUXI
                  @ 04,10 GET XsCodCli PICT "@!"
                  READ
                  UltTecla = Lastkey()
                  IF UltTecla = F8
                     SEEK XsClfAux+TRIM(XsCodCli)
                     IF !CCBBusca("CLIE")
                        UltTecla = 0
                        LOOP
                     ENDIF
                     UltTecla = Enter
                     XsCodcli = AUXI->CodAux
                  ENDIF
                  SEEK XsClfAux+TRIM(XsCodCli)
                  IF !FOUND() AND !EMPTY(XsCodCli)
                     GsMsgErr = "No existe codigo de cliente"
                     DO LIB_MERR WITH 99
                     UltTecla = 0
                     LOOP
                  ENDIF
                  @ 04,10 SAY XsCodCli PICT "@!"
                  XsDirCli = AUXI->DirAux
                  XsNomCli = AUXI->NomAux
                  IF UltTecla = escape_
                     EXIT
                  ENDIF
                  @ 04,16 GET XsNomCli PICT "@S30"
                  @ 05,02 GET XsDirCli PICT "@S30"
                  @ 06,10 GET XsCiuDad PICT "@S20"
                  READ
                  UltTecla = LASTKEY()
         ENDCASE
         IF UltTecla = escape_
            EXIT
         ENDIF
      CASE i = 3
         GsMsgKey = "[T.Cursor] Editar [F10] Graba [Esc] Cancela [TAB] Siguiente [S-TAB] Anterior"
         DO LIB_MTEC WITH 99
         @ 05,41 EDIT XsAtte  SIZE 2,30  COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
      CASE I = 4
         DO CASE
            CASE XsTpoCar="R/PAGO"
                 SELE MCTA
                 @ 07,10 GET  XsAbono PICT "@!"
                 READ
                 UltTecla = Lastkey()
                 IF UltTecla = F8
                    SET FILTER TO CODCTA="104" .or. CodCta = "106"
                    IF ! CBDBUSCA("MCTA")
                       SET FILTER TO
                       LOOP
                    ENDIF
                    SET FILTER TO
                    XsAbono  = CodCta
                    UltTecla = Enter
                 ENDIF
                 IF UltTecla = escape_
                    EXIT
                 ENDIF
                 IF UltTecla = Arriba
                    UltTecla = 0
                    I = I - 1
                    LOOP
                 ENDIF
                 SEEK XsAbono
                 IF !FOUND()
                    GsMsgErr = [Cuenta bancaria no registrada]
                    DO LIB_MERR WITH 99
                    UltTecla = 0
                    LOOP
                 ENDIF
                 =SEEK("04"+MCTA.CodBco,[TABL])
                 @ 07,10 say XsAbono PICT "@!"
                 @ 07,17 SAY LEFT(TABL->NomBre,20)+"Nro. Cta:"+MCTA.NroCta+IIF(MCTA.CodMon=1,"S/.","US$")
                  IF ChrVal=[C] AND UltTecla = Enter
                     DO xDocIniv
                     IF UltTecla = escape_
                        UltTecla = 0
                        LOOP
                     ENDIF
                  ENDIF
            CASE XsTpoCar = "R/PAGO"
         ENDCASE
      CASE I = 5
         DO CASE
            CASE XsTpoCar="BANC"
                 SELE MCTA
                 @ 08,39 GET XsCargo PICT "@!"
                 READ
                 UltTecla = Lastkey()
                 IF UltTecla = F8
                    SET FILTER TO CODCTA="104" .or. CodCta = "106"
                    IF ! CBDBUSCA("MCTA")
                       SET FILTER TO
                       LOOP
                    ENDIF
                    SET FILTER TO
                    XsCargo  = CodCta
                    UltTecla = Enter
                 ENDIF

                 @ 07,18 say XsCargo PICT "@!"
                 IF UltTecla = escape_
                    EXIT
                 ENDIF
            CASE XsTpoCar = "R/PAGO"
         ENDCASE
      CASE i = 7
         GsMsgKey = "[T.Cursor] Editar [F10] Graba [Esc] Cancela [TAB] Siguiente [S-TAB] Anterior"
         DO LIB_MTEC WITH 99
         @ 08,10 EDIT XsRefer SIZE 1,30 COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
      CASE i = 8
         DO CASE
            CASE XsTpoCar = "BANC"
                 @ 08,57 get XnMonto PICT "999,999.99"
                 READ
                 UltTecla = Lastkey()
                 IF UltTecla = escape_
                    EXIT
                 ENDIF
            CASE XsTpoCar = "R/PAGO"
         ENDCASE
      CASE i = 9
         DO CASE
            CASE XsTpoCar = "BANC"
                 VecOpc(1) = "S/."
                 VecOpc(2) = "US$"
                 XiCodMon=Elige(XiCodMon,08,76,2)
            CASE XsTpoCar = "ENVIOD"
                 SELE TASG
                 SET ORDER TO TASG02
                 XsCodDoc = [PROF]
                 @ 08,63 GET XsNroPro PICT "@!"
                 READ
                 UltTecla = LASTKEY()
                 IF UltTecla = F8
                    SEEK XsCodCli+XsCodDoc+TRIM(XsNroPro)
                    IF ! ccbbusca("0016")
                       UltTecla = 0
                       LOOP
                    ENDIF
                    XsNroPro = TASG->NroDoc
                    UltTecla = Enter
                 ENDIF
                 IF UltTecla = escape_
                    EXIT
                 ENDIF

                 SEEK XsCodCli+XsCodDoc+XsNroPro
                 IF !FOUND() AND !EMPTY(XsNroPro)
                    GsMsgErr = [Nro Proforma no existe]
                    DO LIB_MERR WITH 99
                    UltTecla = 0
                    LOOP
                 ENDIF
                 @ 08,63 SAY XsNroPro PICT "@!"
                 IF !EMPTY(XsNroPro)  AND ChrVal=[C]
                    vRegAct = RECNO()
                    eof1= eof()
                    ZsNroDoc = []
                    LsGloLet = []
                    SET ORDER TO TASG05
                    SEEK XsCodDoc+XsNroPro
                    SCAN WHILE CodRef+NroRef = XsCodDoc+XsNroPro
                         IF CodDoc = "CANJ" AND FlgEst#"A"
                            ZsNroDoc = NroDoc
                            EXIT
                         ENDIF
                    ENDSCAN
                    SET ORDER TO TASG01
                    IF Eof1
                       GO BOTTOM
                    ELSE
                       GO vRegAct
                    ENDIF
                    IF EMPTY(ZsNroDoc)
                       GsMsgErr = [ Proforma NO ha generado canje ]
                       DO lib_merr WITH 99
                       UltTecla = 0
                       LOOP
                    ENDIF
                 ENDIF
                 SELE CART
         ENDCASE
      CASE i = 10
         GsMsgKey = "[Teclas cursor] Posicionar [F10] Graba [Esc] Cancela"
         IF ChrVal = "C"
            DO GENERA
            XsCarta = CART->Carta
         ENDIF
         @ 10,02 EDIT XsCarta SIZE 12,76  COLOR SCHEME 7
         READ
         UltTecla = Lastkey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>10,10, i)
   i = IIF(i<1 , 1, i)
ENDDO
SELECT CART
IF UltTecla <> escape_
   DO GRABA
   DO Imprime
ENDIF
IF UltTecla = escape_ .and. ChrVal = "C" AND lGenero
   IF RLOCK()
      DELETE
      UNLOCK
      skip
   ENDIF
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
RETURN
**********************************************************************
* ELIMINA REGISTRO                                                   *
**********************************************************************
PROCEDURE ELIMINA
*****************
IF RLock()
   DELETE
   UNLOCK
   SKIP
ENDIF
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabacion
******************************************************************************
PROCEDURE GRABA
***************
IF ChrVal = "C"
   SELE TCAR
   IF !RLOCK()
      UNLOCK ALL
      RETURN
   ENDIF
   IF Val(XsNroCar)>= TCAR->NroCar
      REPLACE TCAR->NroCar WITH TCAR->NroCar + 1
   ENDIF
   SELE CART
ELSE
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
REPLACE CART->FchCar  WITH XdFchCar
REPLACE CART->TpoCar  WITH XsTpoCar
REPLACE CART->NroCar  WITH XsNroCar
REPLACE CART->Glosa1  WITH XsGlosa1
REPLACE CART->Cargo   WITH XsCargo
REPLACE CART->Abono   WITH XsAbono
REPLACE CART->Carta   WITH XsCarta
REPLACE CART->Monto   WITH XnMonto
REPLACE CART->CodMon  WITH XiCodMon
REPLACE CART->CodCli  WITH XsCodCli
REPLACE CART->DirCli  WITH XsDirCli
REPLACE CART->NomCli  WITH XsNomCli
REPLACE CART->CiuDad  WITH XsCiuDad
REPLACE CART->Refer   WITH XsRefer
REPLACE CART->Atte    WITH XsAtte
UNLOCK ALL
RETURN
*****************
PROCEDURE Imprime
*****************
DO ADMPRINT
IF LASTKEY() = escape_
   RETURN
ENDIF
SET DEVICE TO SCREEN
Tit_SIZQ = ""
Tit_IIZQ = ""
Tit_SDER = ""
Tit_IDER = ""
TITULO   = ""
SUBTITULO= ""
En1 = ""
En2 = ""
En3 = ""
En4 = ""
En5 = ""
En6 = ""
En7 = ""
En8 = ""
En9 = ""
Ancho = 80
Largo = 66
Cancelar = .F.
IniImp = _PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1
SAVE SCREEN TO XTemp
SET DEVICE TO PRINT
PRINTJOB
   @00,00 say IniImp
   @01,08 say Carta  size 65,76
   IF Cancelar
      EXIT
   ENDIF
   EJECT PAGE
ENDPRINTJOB
DO ADMPRFIN IN ADMPRINT
SET DEVICE TO SCREEN
REST SCREEN FROM XTemp
RETURN
******************
PROCEDURE xDocIniv
******************
** Documentos **
DIMENSION vDocum(10),vMonto(10)
STORE [] TO vDocum,XsNroRef,XsCodRef
b = 0
SELE GDOC
SET ORDER TO GDOC04
zllave = XsCodCli+"P"+"Cargo"+"FACT"
SEEK zllave
SCAN WHILE CodCli+FlgEst+TpoDoc+CodDoc=zllave ;
     FOR XsCodRef=TRIM(XsCodRef) AND NroRef=TRIM(XsNroRef) AND CodMon=MCTA.CodMon
     b = b + 1
     IF ALEN(vDocum)< b
        DIMENSION vDocum(b+5),vMonto(b+5)
     ENDIF
     vDocum(b) = [  ]+CodDoc+[ ]+NroDoc+[ ]+DTOC(FchVto)+[ ]+TRAN(XdFchCar-FchDoc,"999")+[ ]
     vDocum(b) = vDocum(b) + IIF(CodMon=1,"S/.","US$")
     vDocum(b) = vDocum(b) + TRANS(SdoDoc,"99,999,999.99")+[ ]
     vMonto(b) = SdoDoc
** û FACT 1234567890 99/99/99 999 US$99,999,999.99
** 12345678901234567890123456789012345678901234567
ENDSCAN
SELE CART
NumDoc = b
IF NumDoc<=0
   GsMsgErr = [No tiene documentos pendientes]
   DO LIB_MERR WITH 99
   UltTecla = escape_
   RETURN
ENDIF
DIMENSION vDocum(NumDoc),vMonto(NumDoc)
SAVE SCREEN TO Belu
GsMsgKey = " [Esc] Cancela  [Enter] Marca   [F10] Procesa "
DO LIB_MTEC WITH 99
zi = 1
Marcas = 0
UltTecla = 0
@ 08,26 SAY PADC("----DOCUMENTO-----VCMTO.--DIAS-----IMPORTE----",52) COLOR SCHEME 7
DO WHILE ! INLIST(UltTecla,F10,escape_)
   @ 09,26 GET zi FROM vDocum SIZE 14,52
   READ
   IF LASTKEY() = escape_ .OR. zi=0
      UltTecla = escape_
   ENDIF
   IF LASTKEY() = F10
      UltTecla = F10
   ENDIF
   IF LASTKEY() = ENTER
      DO MARCA
   ENDIF
ENDDO
IF UltTecla = F10
   UltTecla = Enter
ENDIF
IF Marcas  = 0
   GsMsgErr = " No Registro Marcas "
   DO LIB_MERR WITH 99
   UltTecla = escape_
ENDIF
REST SCREEN FROM Belu
RETURN
***************
PROCEDURE MARCA
***************
IF vDocum(zi) = "û"
   vDocum(zi) = " "+SUBSTR(vDocum(zi),2)
   Marcas = Marcas - 1
ELSE
   IF MARCAS >=20
      GsMsgErr = [Solo se pueden marcar 20 documentos]
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
   vDocum(zi) = "û"+SUBSTR(vDocum(zi),2)
   Marcas = Marcas + 1
ENDIF
RETURN
**************
FUNCTION VLOOK
**************
PARAMETER Variable,AREA
PRIVATE CURAREA
CURAREA=ALIAS()
SELECT &AREA
IF LASTKEY() = F8
   IF XLOOKUP("CLIE")
      Variable=CODCLI
   ENDIF
ENDIF
SEEK VARIABLE
@ 06,36 SAY LEFT(CLIE->NOMBRE,40)
IF !FOUND()
   SELECT &CURAREA
   RETURN .F.
ENDIF
SELECT &CURAREA
RETURN .T.
****************
PROCEDURE GENERA
****************
Largo  = 66
IniPrn = _PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1
SET DEVICE TO PRINT
SET PRINTER TO &XsNroCar
DO CASE
   CASE LEFT(XsCargo,3) = "104"
        LsDesCtaC = "Cuenta Corriente"
   CASE LEFT(XsCargo,3) = "106"
        LsDesCtaC = "Cuenta de Ahorro"
ENDCASE
DO CASE
   CASE LEFT(XsAbono,3) = "104"
        sCtaAbn = "Cta. Cte."
   CASE LEFT(XsAbono,3) = "106"
        sCtaAbn = "Cuenta de Ahorro"
ENDCASE
LsNomCtaC = IIF(SEEK(TRIM(XsCargo),"MCTA"),MCTA.NroCta,[])
LsCodBcoC = MCTA.CodBco
LsNroCtaC = MCTA.NroCta
LsNomCtaA = IIF(SEEK(TRIM(XsAbono),"MCTA"),MCTA.NroCta,[])
LsCodBcoA = MCTA.CodBco
LsNroCta = MCTA.NroCta
LsNomBco = IIF(SEEK("04"+MCTA.CodBco,[TABL]),LEFT(TABL.Nombre,20),[])





DO CASE
   CASE XsTpoCar = "R/PAGO"
         XnMonto = 0
         FOR bch  = 1 TO NumDoc
             IF vDocum(bch)=[û]
                XnMonto = XnMonto + vMonto(bch)
             ENDIF
         NEXT
         @01,0 SAY [ ]
         @02,0 SAY [ ]
         @03,0 SAY [ ]
         @04,0 SAY [ ]
         @05,0 SAY [ ]
         @06,0 SAY [ ]
         @07,0 SAY [ ]
         @08,0 SAY [Bellavista,]+TRANS(day(XdFchCar),"99")+" de "+MES(month(XdFchCar),3)+" de "+TRANS(YEAR(XdFchCar),"9,999")
         @09,0 SAY [DF-]
         @10,0 SAY [ ]
         @11,0 SAY [ ]
         @12,0 SAY [Se¤ores]
         @13,0 SAY XsNomCli
         @14,0 SAY XsDirCli
         @15,0 SAY XsCiuDad
         @16,0 SAY [ ]
         @17,0 SAY [At.:]+MLINE(XsAtte,1)
         @18,0 SAY [    ]+MLINE(XsAtte,2)
         @19,0 SAY [ ]
         @20,0 SAY [Ref.:]+MLINE(XsRefer,1)
         @21,0 SAY [ ]
         @22,0 SAY [Estimados se¤ores:]
         @23,0 SAY [ ]
         @24,0 SAY [Por el presente, recordamos a Uds. que las facturas que se detallan]
         @25,0 SAY [a  continuaci¢n se encuentran  vencidas a la fecha,  por lo que les]
         @26,0 SAY [agradeceremos  se sirvan  efectuar el abono por ]+IIF(MCTA.CodMon=1,"S/.","US$")+TRAN(XnMonto,"999,999,999.99")
         @27,0 SAY [en nuestra ]+sCtaAbn+[ Nro.]+LsNroCta+[ que mantenemos en el BANCO ]
         @28,0 SAY LsNomBco+[ o en su defecto remitirnos el cheque correspondiente.]
   @PROW()+2,0 SAY [         DOCUMENTO    EMISION  DIAS         IMPORTE]
   @PROW()+1,0 SAY [         ---------    -------  ----         -------]
         ***            F./  xxxxxxxxxx   99/99/99 999  /. 999,999,999.99
         FOR bch  = 1 TO NumDoc
             IF vDocum(bch)=[û]
                @ PROW() + 1,0 SAY SPACE(5)+SUBSTR(vDocum(bch),2)
             ENDIF
         NEXT
   @PROW()+1,0 SAY [                                      --------------]
   @PROW()+1,0 SAY [                                  ]+IIF(MCTA.CodMon=1,"S/.","US$")+TRAN(XnMonto,"999,999,999.99")
   @PROW()+2,0 SAY [En espera de sus noticias, quedamos de Uds.,]
   @PROW()+1,0 SAY [ ]
   @PROW()+1,0 SAY [Atentamente,]
   @PROW()+5,0 SAY [GD/jr.]
   @PROW()+1,0 SAY [ ]
   @PROW()+1,0 SAY [cc: File]

   CASE XsTpoCar = "ENVIOD"
         @01,0 SAY [ ]
         @02,0 SAY [ ]
         @03,0 SAY [ ]
         @04,0 SAY [ ]
         @05,0 SAY [ ]
         @06,0 SAY [ ]
         @07,0 SAY [ ]
         @08,0 SAY [Bellavista,]+TRANS(day(XdFchCar),"99")+" de "+MES(month(XdFchCar),3)+" de "+TRANS(YEAR(XdFchCar),"9,999")
         @09,0 SAY [DF-]
         @10,0 SAY [ ]
         @11,0 SAY [ ]
         @12,0 SAY [Se¤ores]
         @13,0 SAY XsNomCli
         @14,0 SAY XsDirCli
         @15,0 SAY XsCiuDad
         @16,0 SAY [ ]
         @17,0 SAY [At.:]+MLINE(XsAtte,1)
         @18,0 SAY [    ]+MLINE(XsAtte,2)
         @19,0 SAY [ ]
         @20,0 SAY [Estimados se¤ores:]
         @21,0 SAY [ ]
         @22,0 SAY [Adjunto   a  la  presente  sirvanse   encontrar   la    siguiente]
         @23,0 SAY [documentaci¢n :]
         @24,0 SAY [ ]
         @25,0 SAY [         DOCUMENTO               IMPORTE]
         @26,0 SAY [         ---------               -------]
         ***            FACT xxxxxxxxxx       S/. 999,999,999.99

         SELE RASG
         SEEK XsCodDoc+XsNroPro
         SCAN WHILE CodDoc+NroDoc=XsCodDoc+XsNroPro FOR CodRef#[LETR]
              @PROW() + 1,0 SAY SPACE(4)+CodRef+[ ]+NroRef+SPACE(7)+;
                                IIF(CodMon=1,"S/.","US$")+TRANS(ImpTot,"99,999,999.99")
         ENDSCAN

   @PROW()+2,0 SAY [De acuerdo a la proforma # ]+LEFT(XsNroPro,8)+[ que acompa¤amos a la presente]
   @PROW()+1,0 SAY [los documentos arriba detallados, han sido canjeados con las sgte(s).]
   @PROW()+1,0 SAY [letra(s):]
   @PROW()+1,0 SAY [ ]
         ***                 xxxxxxxxxx       S/. 999,999,999.99   99/99/99
   SELE GDOC
   SET ORDER TO GDOC03
   SEEK "Canje"+ZsCodDoc+ZsNroDoc+"Cargo"+"LETR"
   SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc="Canje"+ZsCodDoc+ZsNroDoc+"Cargo"+"LETR"
        @PROW() + 1,0 SAY SPACE(9)+NroDoc+SPACE(7)+;
                          IIF(CodMon=1,"S/.","US$")+TRANS(ImpTot,"999,999,999.99")+;
                          [   ]+DTOC(FchVto)
   ENDSCAN
   @PROW()+1,0 SAY [ ]
   @PROW()+1,0 SAY [Agradeceremos se sirvan remitirnos a la brevedad dicha(s) Letra(s)]
   @PROW()+1,0 SAY [debidamente aceptada(s) por sus representantes legales.]
   @PROW()+1,0 SAY [ ]
   @PROW()+1,0 SAY [Sin otro particular, quedamos de Uds.,]
   @PROW()+1,0 SAY [ ]
   @PROW()+1,0 SAY [Muy atentamente,]
   @PROW()+1,0 SAY [  ]
   @PROW()+2,0 SAY [GD/jr.]
   @PROW()+1,0 SAY [ ]
   @PROW()+1,0 SAY [cc: File]
   CASE XsTpoCar = "BANC_A"
         @00,0 SAY [ ]
         @01,0 SAY [ ]
         @02,0 SAY [ ]
         @03,0 SAY [ ]
         @04,0 SAY [ ]
         @05,0 SAY [ ]
         @06,0 SAY [ ]
         @07,0 SAY [ ]
         @08,0 SAY [Bellavista,]+TRANS(day(XdFchCar),"99")+" de "+MES(month(XdFchCar),3)+" de "+TRANS(_ANO,"9,999")
         @09,0 SAY [DF-]
         @10,0 SAY [ ]
         @11,0 SAY [ ]
         @12,0 SAY [ ]
         @13,0 SAY [Se¤ores]
         @14,0 SAY XsNomBco
         @15,0 SAY [Presente.-]
         @16,0 SAY [ ]
         @17,0 SAY [At.:]+XsAtte
         @18,0 SAY [ ]
         @19,0 SAY [Ref.]+XsRefer
         @20,0 SAY [ ]
         @21,0 SAY [Estimados se¤ores:]
         @22,0 SAY [ ]
         @23,0 SAY [Adjunto a la presente sirvanse encontrar las planillas de descuentos]
         @24,0 SAY [de letras que se detalla en la referencia,  para  que  se  sirvan   ]
         @25,0 SAY [descontar a una tasa de  ]+TRANSFORM(XfTasa,"99.99")+[% mensual y el producto de dicho]
         @26,0 SAY [descuento, depositarlo en la Cuenta Corriente M.N.No ]+XsNroCta+[que]
         @27,0 SAY [mantenemos en vuestra instituci¢n.]
         @27,0 SAY [ ]
         @28,0 SAY [Sin otro particular , quedamos de ustedes.]
         @29,0 SAY [ ]
         @30,0 SAY [Atentamente,]
         @31,0 SAY [ ]
         @32,0 SAY [ ]
         @33,0 SAY [ ]
         @34,0 SAY [ ]
         @35,0 SAY [ ]
         @36,0 SAY [GD/jr]
         @37,0 SAY [ ]
         @38,0 SAY [cc: Contra./File]
   CASE XsTpoCar = "T/VENTA"
         @ 0,0 SAY "T."+XsNroCar+'/'+XsGlosa1
         @01,0 SAY "Cargo :"+LsNomCtaC
         @02,0 SAY "Abono :"+LsNomCtaA
         @03,0 SAY " "
         @04,0 SAY " "
         @05,0 SAY "Lima, "+TRANS(day(XdFchCar),"99")+" de "+MES(month(XdFchCar),3)+" de "+TRANS(_ANO,"9,999")
         @06,0 SAY " "
         @07,0 SAY " "
         @08,0 SAY "Se¤ores "
         @09,0 SAY IIF(SEEK('04'+LsCodBcoC,"TABL"),TABL->NomBre,[])
         @10,0 SAY "Presente.-"
         @11,0 SAY " "
         @12,0 SAY "At.:"
         @13,0 SAY " "
         @14,0 SAY "De nuestra consideraci¢n :"
         @15,0 SAY []
         @16,0 SAY "Sirvanse vender de nuestra "+LsDesCtaC+ " Nro. "+LsNroCtaC
         @17,0 SAY "         , a nuestra "+LsDesCtaA+" Nro. "+LsNroCtaA
         @18,0 SAY "         , la cantidad de "
         @19,0 SAY []
         @20,0 SAY "Atentamente ,"
         @21,0 SAY []
         @22,0 SAY []
         @23,0 SAY []
         @24,0 SAY "Ref.: "
         @25,0 SAY []
         @26,0 SAY "c.c.: Tesoreria    "
         @27,0 SAY "      Contabilidad "
         @28,0 SAY []
         @29,0 SAY "xx."
         @30,0 SAY []

   CASE XsTpoCar = "T/TELEF"
         @ 0,0 SAY "T."+XsNroCar+'/'+XsGlosa1
         @01,0 SAY "Cargo :"+LsNomCtaC
         @02,0 SAY "Abono :"+LsNomCtaA
         @03,0 SAY " "
         @04,0 SAY " "
         @05,0 SAY "Lima, "+TRANS(day(XdFchCar),"99")+" de "+MES(Month(XdFchCar),3)+" de "+TRANS(_ANO,"9,999")
         @06,0 SAY " "
         @07,0 SAY " "
         @08,0 SAY "Se¤ores "
         @09,0 SAY IIF(SEEK('04'+LsCodBcoC,"TABL"),TABL->NomBre,[])
         @10,0 SAY "Presente.-"
         @11,0 SAY " "
         @12,0 SAY "At.:"
         @13,0 SAY " "
         @14,0 SAY "De nuestra consideraci¢n :"
         @15,0 SAY []
         @16,0 SAY "Sirvanse resalizar una transferencia telef¢nica a la ciudad "
         @17,0 SAY "de            , a la orden de "
         @18,0 SAY "         , por la cantidad de  "
         @19,0 SAY "El costo total de esta operaci¢n deber  cargarse a nuestra "
         @20,0 SAY LsDesCtaA+" Nro. "+LsNroCtaA
         @21,0 SAY "Atentamente ,"
         @22,0 SAY []
         @23,0 SAY []
         @24,0 SAY []
         @25,0 SAY "Ref.: "
         @26,0 SAY []
         @27,0 SAY "c.c.: Tesoreria    "
         @28,0 SAY "      Contabilidad "
         @29,0 SAY []
         @30,0 SAY "xx."
         @31,0 SAY []

ENDCASE
SET PRINTER TO
SET DEVICE TO SCREEN
SELE CART
SEEK XsTpoCar+XsNroCar
IF FOUND() .and. ChrVal = "C"
   GsMsgErr = "Documento Creado por Otro Usuario"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
IF !FOUND()
   APPEND BLANK
   IF !RLOCK()
      DELETE
      RETURN
   ENDIF
ENDIF
SELE CART
IF ChrVal = "C"
   APPEND MEMO Carta from &XsNroCar
ELSE
   APPEND MEMO Carta from &XsNroCar OVERWRITE
ENDIF
lGenero = .T.
RETURN
