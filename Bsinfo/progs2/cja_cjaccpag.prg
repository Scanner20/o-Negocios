**************************************************************************
*  Nombre       : CjaCCPag.PRG
*  Autor        : VETT
*  Objeto       : Consultas de Cuentas por Pagar
*  Par metros   : Ninguno
*  Creaciขn     : 17/12/2003
*  Actualizaciขn:   /  /
**************************************************************************
DO def_teclas IN fxgen_2

SET DISPLAY TO VGA50
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV06','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
RELEASE LoDatAdm
DO Gen_Consulta

CLEAR MACROS
CLEAR 
DO close_file 
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
RETURN
**********************
PROCEDURE Gen_Consulta
**********************
XfTpoCmb = 0
XdFchAst = DATE()
IF ! SEEK(DTOC(XdFchAst,1),"TCMB")
   SELECT TCMB
   GOTO BOTTOM
ENDIF
IF ! EMPTY(TCMB->OFICMP)
   XfTpoCmb = TCMB->OFICMP
ENDIF

IF  XfTpoCmb = 0
  XfTpoCmb = 3.5
ENDIF
DIMENSION vCodCta(10,4)
XsClfAux = "PRO"
DO WHILE .T.
   cTit4 = GsNomCia
   cTit2 = []
   cTit3 = "Usuario : "+TRIM(GsUsuario)
   cTit1 = "CONSULTA CUENTAS POR PAGAR"
   Do Fondo WITH cTit1,cTit2,cTit3,cTit4
   @  09,19 FILL  TO 17,59 COLOR W/N
   @  08,20 CLEAR TO 16,60
   @  08,20       TO 16,60
   @  10,24 prompt "\<Proveedores                       "
   @  11,24 prompt "\<Adelantos Entregados a Proveedores"
   @  12,24 prompt "\<Movimiento por Proveedor          "
   @  13,24 prompt "\<Otras Cuentas por Pagar           "
   @  14,24 prompt "\<Deudas Pendientes                 "
   MENU TO OPC
   XdFchVto = {}
   XiForma  = 0
   DO CASE
      CASE OPC = 0
         RETURN
      CASE OPC = 1
         DO PROVEEDOR
      CASE OPC = 2
         DO OTRAS WITH "ADELANTOS ENTREGADOS AL ","422001","     "
      CASE OPC = 3
         @ 21,14 FILL  TO 23,65 COLOR W/N
         @ 20,15 CLEAR TO 22,66
         @ 20,15 TO 22,66
         LsNombre = SPACE(30)
         @ 21,17 SAY "PROVEEDOR : " GET LsNombre PICT "@!"
         READ
         IF LASTKEY() = Escape_
            LOOP
         ENDIF
         SELECT AUXI
         SET ORDER TO AUXI02
         GsMsgKey  = "[T.Cursor] Seleccionar    [Enter] Aceptar    [Esc] Cancelar"
         XsClfAux = "PRO"

         KEY1      = XsClfAux+TRIM(LsNombre)
         KEY2      = XsClfAux+CHR(255)
         Titulo    = "Cขdigo      Nombre/Razขn Social"
         LinReg    = [CodAux+" "+NomAux]
         Ancho     = LEN( &LinReg ) + 2
         Xo       = 80-Ancho
         Yo       = 6
         Largo    = 16
         DO Lib_MTEC  WITH 99
         SEEK Key1
         DO Busca WITH "",Key1,Key2,LinReg,Titulo,Yo,Xo,Largo,Ancho,""
         SELECT AUXI
         SET ORDER TO AUXI01
         IF LASTKEY() = Escape_
            LOOP
         ENDIF
         DO xCstMov2
      CASE OPC = 4
         DO OTRAS WITH "PAGARES AL ","46101","46102"
      CASE OPC = 5
         @ 21,14 FILL  TO 23,65 COLOR W/N
         @ 20,15 CLEAR TO 22,66
         @ 20,15 TO 22,66
         LiDias  = 30
         @ 21,24 SAY "DENTRO DE  LOS PROXIMOS 30 DIAS"
         @ 21,48 GET LiDias PICT "##" RANGE 0,99
         READ
         IF LASTKEY() = Escape_
            LOOP
         ENDIF
         DO DEUDAS
   ENDCASE
ENDDO
RETURN

*******************PRIMERA PANTALLA DE PRESENTACION***************************
*******************
PROCEDURE PROVEEDOR
*******************
SELE AUXI
** Vector de Acumulaciขn de Cuentas ***********
CLEAR
IF GdFecha < DATE()
   Fch = DTOC(GdFecha)
ELSE
   Fch = DTOC(DATE())
ENDIF
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออป"
@  1,0  SAY "บ                                               บ         S A L D O S          บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออออออหอออออออออออออออน"
@  3,0  SAY "บ Cขdigo    Nombre / Razขn Social               บ      S/.     บ      US$      บ"
@  4,0  SAY "ศอออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออสอออออออออออออออผ"

@  1,1  SAY "    DOCUMENTOS POR PAGAR  AL "+Fch+"          " COLOR SCHEME 7
@  3,1  SAY " Cขdigo    Nombre / Razon Sขcial               " COLOR SCHEME 7
@  1,49 SAY "         S A L D O S          " COLOR SCHEME 7
@  3,49 SAY "      S/.     "  COLOR SCHEME 7
@  3,64 SAY "      US$      " COLOR SCHEME 7
***** CARGANDO LOS PROVEDORES QUE TIENEN DEUDAS *****
DIMENSION vDatos(20),vCdCta(20)
LfSalAct1 = 0
LfSalAct2 = 0
NumEle    = 0
NumCta    = 0
DO CARGA0
IF NumEle = 0
   GsMsgErr = "No Existe Deudas pendientes"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
DO PIDE1
RETURN

*******************
PROCEDURE OTRAS
*******************
PARAMETER LsGlosa,CodCta1,CodCta2
CLEAR
IF GdFecha < DATE()
   Fch = DTOC(GdFecha)
ELSE
   Fch = DTOC(DATE())
ENDIF
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออป"
@  1,0  SAY "บ                                               บ         S A L D O S          บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออออออหอออออออออออออออน"
@  3,0  SAY "บ Cขdigo    Nombre / Razon Sขcial               บ      S/.     บ      US$      บ"
@  4,0  SAY "ศอออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออสอออออออออออออออผ"

@  1,1  SAY PADC(LsGlosa+Fch,47)          COLOR SCHEME 7
@  3,1  SAY " Cขdigo    Nombre / Razขn Social               " COLOR SCHEME 7
@  1,49 SAY "         S A L D O S          " COLOR SCHEME 7
@  3,49 SAY "      S/.     "  COLOR SCHEME 7
@  3,64 SAY "      US$      " COLOR SCHEME 7
DIMENSION vDatos(20),vCdCta(20)
NumEle    = 0
LfSalAct1 = 0
LfSalAct2 = 0
LsCodCta  = CodCta1
DO CARGA1
LsCodCta  = CodCta2
DO CARGA1
IF NumEle = 0
   GsMsgErr = "No Existe Deudas pendientes"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
DO PIDE1

****************
PROCEDURE DEUDAS
****************
SELE AUXI
** Vector de Acumulaciขn de Cuentas ***********
CLEAR
IF GdFecha < DATE()
   Fch = DTOC(GdFecha)
ELSE
   Fch = DTOC(DATE())
ENDIF
XdFchVto = CTOD(Fch)+LiDias
XiForma  = 1
FCH = DTOC(XdFchVto)
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออออออออออออออป"
@  1,0  SAY "บ                                               บ                              บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออหอออออออออออออออน"
@  3,0  SAY "บ                                                              บ SALDO X PAGAR บ"
@  4,0  SAY "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออออออออออออผ"
*              ##/##/##  ########## 123456789-123456789-123456789-12345678 s/.
@  1,1  SAY "    DOCUMENTOS POR PAGAR  HASTA EL "+Fch+"    " COLOR SCHEME 7
@  3,1  SAY "   Vcto.  Documento   Razขn Social/Concepto                   " COLOR SCHEME 7
@  1,49 SAY "                              " COLOR SCHEME 7
@  3,64 SAY " SALDO X PAGAR " COLOR SCHEME 7
DIMENSION vDatos(20),vCdCta(20,2)
NumCta    = 0
NumEle    = 0
LfSalAct1 = 0
LfSalAct2 = 0
DO CARGA0
**** OTRAS DEUDAS PENDIENTES  ****
LsCodCta = "461001"
DO CARGA1
IF NumEle = 0
   GsMsgErr = "No Existe Deudas pendientes"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
DIMENSION vDatos(NumEle*3),vCdCta(NumEle,2)
**** Ordenando ***
=ASORT(vDatos,1,NumEle)
x = ALEN(vDatos)
FOR I= 1 TO X
    IF MOD(I,3)=1
       xFchVto   = SUBSTR(vDatos(i),7,2)+"/"+SUBSTR(vDatos(i),5,2)+"/"+SUBSTR(vDatos(i),3,2)
       xSegLin   = SUBSTR(vDatos(i),78)
       vDatos(i) = xFchVto+SUBSTR(vDatos(i),9,70)
       =AINS(vDatos,i+1)
       vDatos(i+1) = xSegLin
       =AINS(vDatos,i+2)
       vDatos(i+2) = SPACE(78)
    ENDIF
NEXT

GsMsgKey = " [] [] Selecciona [Enter] Analiza [Esc] Cancela [F5] Buscar [F4] Continua Buscando"
DO LIB_MTEC WITH 99

@ 21,54 SAY "TOTAL S/."
IF LfSalAct1 >= 0
   @ 21,66 SAY TRANSF(LfSalAct1,"@Z 9,999,999.99  ")
ELSE
   @ 21,66 SAY TRANSF(-LfSalAct1,"@Z 9,999,999.99- ")
ENDIF
@ 22,54 SAY "TOTAL US$"
IF LfSalAct2 >= 0
   @ 22,66 SAY TRANSF(LfSalAct2,"@Z 9,999,999.99  ")
ELSE
   @ 22,66 SAY TRANSF(-LfSalAct2,"@Z 9,999,999.99- ")
ENDIF
TotGen = ROUND(LfSalAct1/XfTpoCmb,2)+LfSalAct2
@ 22,02 SAY "TOTAL GENERAL US$"
IF TotGen    >= 0
   @ 22,20 SAY TRANSF(TotGen   ,"@Z 9,999,999.99  ")
ELSE
   @ 22,20 SAY TRANSF(-TotGen   ,"@Z 9,999,999.99- ")
ENDIF

SAVE SCREEN TO LsPanCon
LsNombre = SPACE(30)
LiDesde  = 0
UltTecla= 0
PV = 1
DO WHILE .T.
   RESTORE SCREEN FROM LsPanCon
   @ 5,0 GET PV FROM vDatos SIZE 16,80 VALID dato1()
   READ
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter .AND. MOD(PV,2) = 1
      XsCodCta = vCdCta((PV+1)/2)
      XsCodAux = vCdCta((PV+1)/2)
      XsNroDoc = SUBSTR(vDatos(PV),10,10)
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->CLFAUX
      SELECT AUXI
      SEEK XsClfAux+XsCodAux
   ENDIF
   IF UltTecla = F5
      @ 21,14 FILL  TO 23,65 COLOR W/N
      @ 20,15 CLEAR TO 22,66
      @ 20,15 TO 22,66
      @ 21,17 SAY "DATO  : " GET LsNombre PICT "@!"
      READ
      IF LASTKEY() = Escape_
         LOOP
      ENDIF
      LiDesde = 0
      FOR I=1 TO ALEN(vDatos)
          IF ALLTRIM(LsNombre)$UPPER(vDatos(i))
             LiDesde = i
             EXIT
          ENDIF
      NEXT
      IF LiDesde = 0
         ?? CHR(7)
         WAIT "DATO NO SELECCIONADO" NOWAIT WINDOW
      ELSE
         PV = LiDesde
      ENDIF
   ENDIF
   IF UltTecla = F4 .AND. LiDesde > 0
      z = LiDesde
      LiDesde = 0
      FOR I=z+1  TO ALEN(vDatos)
          IF ALLTRIM(LsNombre)$vDatos(i)
             LiDesde = i
             EXIT
          ENDIF
      NEXT
      IF LiDesde = 0
         ?? CHR(7)
         WAIT "NO EXISTEN OTROS DATOS" NOWAIT WINDOW
         PV = z
         LiDesde = z
      ELSE
         PV = LiDesde
      ENDIF
   ENDIF
ENDDO
RETURN

***************
PROCEDURE PIDE1
***************
DIMENSION vDatos(NumEle),vCdCta(NumEle)
GsMsgKey = " [] [] Selecciona [Enter] Analiza [Esc] Cancela [F5] Buscar [F4] Continua Buscando"
DO LIB_MTEC WITH 99

@ 22,50 SAY "TOTAL S/."
IF LfSalAct1 >= 0
   @ 22,62 SAY TRANSF(LfSalAct1,"@Z 9,999,999.99  ")
ELSE
   @ 22,62 SAY TRANSF(-LfSalAct1,"@Z 9,999,999.99- ")
ENDIF
@ 23,50 SAY "TOTAL US$"
IF LfSalAct2 >= 0
   @ 23,62 SAY TRANSF(LfSalAct2,"@Z 9,999,999.99  ")
ELSE
   @ 23,62 SAY TRANSF(-LfSalAct2,"@Z 9,999,999.99- ")
ENDIF

SAVE SCREEN TO LsPanCon
LsNombre = SPACE(30)
LiDesde  = 0
PV = 1
UltTecla = 0
DO WHILE .T.
   RESTORE SCREEN FROM LsPanCon
   @ 5,0 GET PV FROM vDatos SIZE 16,80 VALID Dato1()
   READ 
   UltTecla = LASTKEY()
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter
      LsCodCta = vCdCta(PV)
      IF LsCodCta = "PROV"
         XsClfAux = "PRO"
         XsCodAux = PADR(LEFT(vDatos(PV),LEN(RMOV->CodAux)),LEN(RMOV->CodAux))
         SELECT AUXI
         SEEK XsClfAux+XsCodAux
         DO xCstMov
      ELSE
         =SEEK(LsCodCta,"CTAS")
         XsClfAux = CTAS->CLFAUX
         XsCodAux = PADR(LEFT(vDatos(PV),LEN(RMOV->CodAux)),LEN(RMOV->CodAux))
         SELECT AUXI
         SEEK XsClfAux+XsCodAux
         DO xCstMov1
      ENDIF
   ENDIF
   IF UltTecla = F5

      @ 21,14 FILL  TO 23,65 COLOR W/N
      @ 20,15 CLEAR TO 22,66
      @ 20,15 TO 22,66
      @ 21,17 SAY "NOMBRE : " GET LsNombre PICT "@!"
      READ
      IF LASTKEY() = Escape_
         LOOP
      ENDIF
      LiDesde = 0
      FOR I=1 TO ALEN(vDatos)
          IF ALLTRIM(LsNombre)$UPPER(vDatos(i))
             LiDesde = i
             EXIT
          ENDIF
      NEXT
      IF LiDesde = 0
         ?? CHR(7)
         WAIT "DATO NO SELECCIONADO" NOWAIT WINDOW
      ELSE
         PV = LiDesde
      ENDIF
   ENDIF
   IF UltTecla = F4 .AND. LiDesde > 0
      z = LiDesde
      LiDesde = 0
      FOR I=z+1  TO ALEN(vDatos)
          IF ALLTRIM(LsNombre)$vDatos(i)
             LiDesde = i
             EXIT
          ENDIF
      NEXT
      IF LiDesde = 0
         ?? CHR(7)
         WAIT "NO EXISTEN OTROS DATOS" NOWAIT WINDOW
         PV = z
         LiDesde = z
      ELSE
         PV = LiDesde
      ENDIF
   ENDIF
   UltTecla = 0
ENDDO
RETURN
**************** SEGUNDA PANTALLA DE PRESENTACION **************************
*****************
PROCEDURE xCstMov  && PROVEDORES
*****************
*** Buscando los Documentos Pendientes de un Proveedor ***
CLEAR
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออป"
@  1,0  SAY "บ                                                           บ     S A L D O S  บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออน"
@  3,0  SAY "บ Tpo  Nง.Docto.  Nง Refer.   Vto.     Concepto             บ         S/.  US$ บ"
@  4,0  SAY "ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออผ"
@  1,1 SAY  PADC(ALLTRIM(NomAux),59) COLOR SCHEME 7
@  3,1  SAY " Tpo  Nง.Docto.  Nง Refer.   Vto.     Concepto             " COLOR SCHEME 7
@  1,61 SAY "     S A L D O S  " COLOR SCHEME 7
@  3,61 SAY "        S/.   US$ " COLOR SCHEME 7
ZfSalAct1 = 0
ZfSalAct2 = 0
DIMENSION vDocum(20)
NumEle = 0
FOR Item = 1 TO NumCta
   LsCodCta = vCodCta(Item,1)
   SELECT RMOV
   SEEK LsCodCta+XsCodAux
   DO WHILE CodCta+CodAux = LsCodCta+XsCodAux .AND. ! EOF()
      SalAct1  = 0
      SalAct2  = 0
      LsNroDoc = NroDoc
      LsNroRef = NroRef
      LdFchVto = FchVto
      LiCodMon = CodMon
      LsGloDoc = GloDoc
      LdFchVto = RMOV->FchVto
      IF EMPTY(LsGloDoc)
         =SEEK(NROMES+CODOPE+NROAST,"VMOV")
         LsGloDoc = VMOV->NotAst
      ENDIF
      DO WHILE CodCta+CodAux+NroDoc = LsCodCta+XsCodAux+LsNroDoc .AND. ! EOF()
         @ 24,0 say NroDoc
         IF CodOpe == vCodCta(Item,3)
            LiCodMon = CodMon
            LdFchVto = FchVto
            LsNroRef = NroRef
            LsGloDoc = GloDoc
            LdFchVto = RMOV->FchVto
            IF EMPTY(LsGloDoc)
               =SEEK(NROMES+CODOPE+NROAST,"VMOV")
               LsGloDoc = VMOV->NotAst
            ENDIF
         ENDIF
         IF TpoMov = "H"
            SalAct1 = SalAct1 + IMPORT
            SalAct2 = SalAct2 + IMPUSA
         ELSE
            SalAct1 = SalAct1 - IMPORT
            SalAct2 = SalAct2 - IMPUSA
         ENDIF
         SKIP
      ENDDO
      Ok = 0
      IF LiCodMon = 1 .AND. SalAct1 # 0
         Ok = 1
         SalAct2 = 0
      ENDIF
      IF LiCodMon = 2 .AND. SalAct2 # 0
         Ok = 2
         SalAct1 = 0
      ENDIF
      IF Ok # 0
         IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
            NumEle = NumEle + 1
            IF NumEle < ALEN(vDOCUM)
               DIMENSION vDOCUM(NumEle+10)
            ENDIF
            vDOCUM(NumEle) = PADR(LsCodCta+" "+LsNroDoc+" "+LsNroRef+" "+DTOC(LdFchVto)+" "+LsGloDoc+" ",58)
            IF LiCodmON = 1
               IF SalAct1 >= 0
                  vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct1,"@Z 9,999,999.99  ")
               ELSE
                  vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct1,"@Z 9,999,999.99- ")
               ENDIF
               vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
               IF SalAct2 >= 0
                  vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct2,"@Z 9,999,999.99  ")
               ELSE
                  vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct2,"@Z 9,999,999.99- ")
               ENDIF
            ENDIF
            ZfSalAct1 = ZfSalAct1 + SalAct1
            ZfSalAct2 = ZfSalAct2 + SalAct2
         ENDIF
      ENDIF
   ENDDO
NEXT
IF NumEle = 0
   RETURN
ENDIF
DIMENSION vDocum(NumEle)
ND = 1
UltTecla = 0
GsMsgKey = " [] [] Selecciona   [Enter] Analiza   [Esc] Cancela"
DO LIB_MTEC WITH 99
SAVE SCREEN TO LsPanMov
DO WHILE .T.
   RESTORE SCREEN FROM LsPanMov
   @ 5,0 GET ND FROM vDocum SIZE 18,80 VALID Dato1()
   READ
	UltTecla = LASTKEY()	
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter
      DO xCstDoc
   ENDIF
	UltTecla = 0   
ENDDO
RETURN

******************
PROCEDURE xCstMov1
******************
*** Buscando los Documentos Pendientes de un Proveedor ***
CLEAR
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออป"
@  1,0  SAY "บ                                                           บ     S A L D O S  บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออน"
@  3,0  SAY "บ Tpo    Nง.Docto.  Nง Refer.   Vto.     Concepto           บ         S/.  US$ บ"
@  4,0  SAY "ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออผ"
@  1,1 SAY  PADC(ALLTRIM(NomAux),59) COLOR SCHEME 7
@  3,1  SAY " Tpo  Nง.Docto.  Nง Refer.   Vto.     Concepto             " COLOR SCHEME 7
@  1,61 SAY "     S A L D O S  " COLOR SCHEME 7
@  3,61 SAY "        S/.   US$ " COLOR SCHEME 7
ZfSalAct1 = 0
ZfSalAct2 = 0
DIMENSION vDocum(20)
NumEle = 0
SELECT RMOV
SEEK LsCodCta+XsCodAux
DO WHILE CodCta+CodAux = LsCodCta+XsCodAux .AND. ! EOF()
   SalAct1  = 0
   SalAct2  = 0
   LsNroDoc = NroDoc
   LsNroRef = NroRef
   LdFchVto = FchVto
   LiCodMon = CodMon
   LsGloDoc = GloDoc
   LdFchVto = RMOV->FchVto
   IF EMPTY(LsGloDoc)
      =SEEK(NROMES+CODOPE+NROAST,"VMOV")
      LsGloDoc = VMOV->NotAst
   ENDIF
   DO WHILE CodCta+CodAux+NroDoc = LsCodCta+XsCodAux+LsNroDoc .AND. ! EOF()
      @ 24,0 say NroDoc
      IF TpoMov = "H"
         SalAct1 = SalAct1 + IMPORT
         SalAct2 = SalAct2 + IMPUSA
      ELSE
         SalAct1 = SalAct1 - IMPORT
         SalAct2 = SalAct2 - IMPUSA
      ENDIF
      SKIP
   ENDDO
   Ok = 0
   IF LiCodMon = 1 .AND. SalAct1 # 0
      Ok = 1
      SalAct2 = 0
   ENDIF
   IF LiCodMon = 2 .AND. SalAct2 # 0
      Ok = 2
      SalAct1 = 0
   ENDIF
   IF Ok # 0
      IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
         NumEle = NumEle + 1
         IF NumEle < ALEN(vDOCUM)
            DIMENSION vDOCUM(NumEle+10)
         ENDIF
         vDOCUM(NumEle) = PADR(LsCodCta+" "+LsNroDoc+" "+LsNroRef+" "+DTOC(LdFchVto)+" "+LsGloDoc+" ",58)
         IF LiCodmON = 1
            IF SalAct1 >= 0
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct1,"@Z 9,999,999.99  ")
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct1,"@Z 9,999,999.99- ")
            ENDIF
            vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
         ELSE
            vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
            IF SalAct2 >= 0
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct2,"@Z 9,999,999.99  ")
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct2,"@Z 9,999,999.99- ")
            ENDIF
         ENDIF
         ZfSalAct1 = ZfSalAct1 + SalAct1
         ZfSalAct2 = ZfSalAct2 + SalAct2
      ENDIF
   ENDIF
ENDDO
IF NumEle = 0
   RETURN
ENDIF
DIMENSION vDocum(NumEle)
ND = 1
UltTecla = 0
GsMsgKey = " [] [] Selecciona   [Enter] Analiza   [Esc] Cancela"
DO LIB_MTEC WITH 99
SAVE SCREEN TO LsPanMov
DO WHILE .T.
   RESTORE SCREEN FROM LsPanMov
   @ 5,0 GET ND FROM vDocum SIZE 18,80 VALID Dato1()
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter
      DO xCstDoc
   ENDIF
   UltTecla = 0
ENDDO
RETURN

******************
PROCEDURE xCstMov2
******************
XsCodAUX = CodAux
*** Buscando los Documentos Pendientes de un Proveedor ***
CLEAR
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออป"
@  1,0  SAY "บ                                                           บ     S A L D O S  บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออน"
@  3,0  SAY "บ Tpo  Nง.Docto.  Nง Refer.   Vto.     Concepto             บ         S/.  US$ บ"
@  4,0  SAY "ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออผ"
@  1,1 SAY  PADC(ALLTRIM(NomAux),59) COLOR SCHEME 7
@  3,1  SAY " Tpo  Nง.Docto.  Nง Refer.   Vto.     Concepto             " COLOR SCHEME 7
@  1,61 SAY "     S A L D O S  " COLOR SCHEME 7
@  3,61 SAY "        S/.   US$ " COLOR SCHEME 7

NumCta = 0
MaxEle = 10
DIMENSION vCodCta(MaxEle,4)
SELE CTAS
SEEK [42]
DO WHILE CodCta=[42] .AND. ! EOF()
   IF AFTMOV='S' AND PIDAUX='S'   &&LEN(TRIM(CodCta)) = 6
*      IF ! INLIST(CODCTA,"421","423") && No incluye adelantos
         NumCta = NumCta + 1
         IF NumCta = MaxEle
            MaxEle = MaxEle + 10
            DIMENSION vCodCta(MaxEle,4)
         ENDIF
         vCodCta(NumCta,1) = CodCta
         vCodCta(NumCta,2) = NomCta
         vCodCta(NumCta,3) = ""
         vCodCta(NumCta,4) = SUBSTR(CodCta,3)
     * ENDIF
      SELECT PROV
      GOTO TOP
      DO WHILE ! EOF()
         IF CTAS->CODCTA$CODCTA
            vCodCta(NumCta,3) = CODOPE
            vCodCta(NumCta,4) = TpoDoc
         ENDIF
         SKIP
      ENDDO
 	ENDIF
    SELECT CTAS
*   ENDIF
   SKIP
ENDDO

IF NumCta = 0
   GsMsgErr = "Cuentas de provedores no registradas"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
DIMENSION vCodCta(NumCta,4)


ZfSalAct1 = 0
ZfSalAct2 = 0
DIMENSION vDocum(20)
NumEle = 0
FOR Item = 1 TO NumCta
   LsCodCta = vCodCta(Item,1)
   SELECT RMOV
   SEEK LsCodCta+XsCodAux
   DO WHILE CodCta+CodAux = LsCodCta+XsCodAux .AND. ! EOF()
      SalAct1  = 0
      SalAct2  = 0
      LsNroDoc = NroDoc
      LsNroRef = NroRef
      LdFchVto = FchVto
      LiCodMon = CodMon
      LsGloDoc = GloDoc
      IF EMPTY(LsGloDoc)
         =SEEK(NROMES+CODOPE+NROAST,"VMOV")
         LsGloDoc = VMOV->NotAst
      ENDIF
      DO WHILE CodCta+CodAux+NroDoc = LsCodCta+XsCodAux+LsNroDoc .AND. ! EOF()
         @ 24,0 say NroDoc
         IF CodOpe == vCodCta(Item,3)
            LiCodMon = CodMon
            LdFchVto = FchVto
            LsNroRef = NroRef
            LsGloDoc = GloDoc
            IF EMPTY(LsGloDoc)
               =SEEK(NROMES+CODOPE+NROAST,"VMOV")
               LsGloDoc = VMOV->NotAst
            ENDIF
         ENDIF
         IF TpoMov = "H"
            SalAct1 = SalAct1 + IMPORT
            SalAct2 = SalAct2 + IMPUSA
         ELSE
            SalAct1 = SalAct1 - IMPORT
            SalAct2 = SalAct2 - IMPUSA
         ENDIF
         SKIP
      ENDDO
      Ok = 0
      IF LiCodMon = 1  && .AND. SalAct1 # 0
         Ok = 1
         SalAct2 = 0
      ENDIF
      IF LiCodMon = 2  && .AND. SalAct2 # 0
         Ok = 2
         SalAct1 = 0
      ENDIF
      IF Ok # 0
         NumEle = NumEle + 1
         IF NumEle < ALEN(vDOCUM)
            DIMENSION vDOCUM(NumEle+10)
         ENDIF
         vDOCUM(NumEle) = PADR(LsCodCta+" "+LsNroDoc+" "+LsNroRef+" "+DTOC(LdFchVto)+" "+LsGloDoc+" ",58)
         IF LiCodmON = 1
            IF SalAct1 >= 0
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct1,"9,999,999.99  ")
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct1,"9,999,999.99- ")
            ENDIF
            vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
         ELSE
            vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
            IF SalAct2 >= 0
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct2,"9,999,999.99  ")
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct2,"9,999,999.99- ")
            ENDIF
         ENDIF
      ENDIF
      ZfSalAct1 = ZfSalAct1 + SalAct1
      ZfSalAct2 = ZfSalAct2 + SalAct2
   ENDDO
NEXT
IF NumEle = 0
   RETURN
ENDIF
DIMENSION vDocum(NumEle)
ND = 1
UltTecla = 0
GsMsgKey = " [] [] Selecciona   [Enter] Analiza   [Esc] Cancela"
DO LIB_MTEC WITH 99
SAVE SCREEN TO LsPanMov
DO WHILE .T.
   RESTORE SCREEN FROM LsPanMov
   @ 5,0 GET ND FROM vDocum SIZE 18,80 VALID dato2()
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter
      DO xCstDoc
   ENDIF
   UltTecla = 0
ENDDO
RETURN

********************* TERCERA PANTALLA DE PRESENTACION *********************
*****************
PROCEDURE xCstDoc
*****************
*** Revisando todos los Movimientos de un Documento ***
CLEAR
LsCodCta = LEFT(vDocum(ND),LEN(rmov.codcta))
LsNroDoc = SUBSTR(vDocum(ND),LEN(rmov.codcta)+2,LEN(rmov.NroDoc))
LiCodMon = IIF(EMPTY(RIGHT(vDocum(ND),6)),1,2)
IF LiCodMon = 1
   @ 1,28 SAY "EXPRESADO EN NUEVOS SOLES"
ELSE
   @ 1,25 SAY "EXPRESADO EN DOLARES AMERICANOS"
ENDIF
xKey1   = LsCodCta+XsCodAux+LsNroDoc
xKey2   = LsCodCta+XsCodAux+LsNroDoc
xLinReg = [xLinReg()]
xTITULO = " COMPROBANTE     FECHA    CONCEPTO                              ABONOS CARGOS"
xTstLin = [xFiltro()]
SEEK xKey1
DO BUSCA WITH "",xKEY1,xKEY2,xLINREG,xTITULO,02,0,22,80,xTSTLIN
RETURN
*****************
PROCEDURE xFiltro
*****************
IF LiCodMon = 1
   return IMPORT#0
ELSE
   return IMPUSA#0
ENDIF


*****************
PROCEDURE xLinReg
*****************
xLinReg = " "+NroMes+"-"+CODOPE+"-"+NROAST+" "+DTOC(Fchdoc)+" "
=SEEK(NROMES+CODOPE+NROAST,"VMOV")
LsGloDoc = PADR(VMOV->NotAst,34)+" "
IF EMPTY(LsGloDoc)
   LsGloDoc = PADR(RMOV->GloDoc,34)+" "
ENDIF
xLinReg = xLinReg + LsGloDoc
IF LiCodMon = 1
   LsImport =IIF(TPOMOV#"D",SPACE(6)+TRANS(IMPORT,"99999,999.99"),TRANS(IMPORT,"99999,999.99")+SPACE(6))
ELSE
   LsImport =IIF(TPOMOV#"D",SPACE(6)+TRANS(IMPUSA,"99999,999.99"),TRANS(IMPUSA,"99999,999.99")+SPACE(6))
ENDIF
xLinReg = xLinReg + LsImport
RETURN xLinReg
*************************************************************************** FIN
PROCEDURE CARGA0 && PROVEDORES ->TODAS LAS CUENTAS 42 ------
****************
NumCta = 0
MaxEle = 10
DIMENSION vCodCta(MaxEle,4)
SELE CTAS
SEEK [42]
DO WHILE CodCta=[42] .AND. ! EOF()
   IF  AFTMOV='S' AND PIDAUX='S'  &&LEN(TRIM(CodCta)) = 6
      *IF ! INLIST(CODCTA,"421","422","423") && Ahora Si incluye adelantos
         NumCta = NumCta + 1
         IF NumCta = MaxEle
            MaxEle = MaxEle + 10
            DIMENSION vCodCta(MaxEle,4)
         ENDIF
         vCodCta(NumCta,1) = CodCta
         vCodCta(NumCta,2) = NomCta
         vCodCta(NumCta,3) = ""
         vCodCta(NumCta,4) = SUBSTR(CodCta,3)
      *ENDIF
      SELECT PROV
      GOTO TOP
      DO WHILE ! EOF()
         IF CTAS->CODCTA$CODCTA
            vCodCta(NumCta,3) = CODOPE
            vCodCta(NumCta,4) = TpoDoc
         ENDIF
         SKIP
      ENDDO
      SELECT CTAS
   ENDIF
   SKIP
ENDDO
IF NumCta = 0
   RETURN
ENDIF
DIMENSION vCodCta(NumCta,4)
XsClfAux = "PRO"
SELECT AUXI
SEEK XsClfAux
LfSalAct1 = 0
LfSalAct2 = 0
DO WHILE ClfAux = XsClfAux .AND. ! Eof()
   @ 24,0 SAY PADC(TRIM(CodAux)+" "+TRIM(NomAux),80)
   LsCodAux = CodAux
   LsNomAux = NomAux
   ZfSalAct1  = 0
   ZfSalAct2  = 0
   LiNroItm = 0
   FOR Item = 1 TO NumCta
      LsCodCta = vCodCta(Item,1)
      SELECT RMOV
      SEEK LsCodCta+LsCodAux

      DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! EOF()
         SalAct1  = 0
         SalAct2  = 0
         =SEEK(NROMES+CODOPE+NROAST,"VMOV")
         LsNroDoc = NroDoc
         LiCodMon = CodMon
         LdFchVto = FchVto
         LsNroRef = NroRef
         LsGloDoc = GloDoc
         LsNotAst = VMOV->NotAst
         DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
            IF CodOpe == vCodCta(Item,3)
               =SEEK(NROMES+CODOPE+NROAST,"VMOV")
               LiCodMon = CodMon
               LdFchVto = FchVto
               LsNroRef = NroRef
               LsGloDoc = GloDoc
               LsNotAst = VMOV->NotAst
            ENDIF
            IF TpoMov = "H"
               SalAct1 = SalAct1 + IMPORT
               SalAct2 = SalAct2 + IMPUSA
            ELSE
               SalAct1 = SalAct1 - IMPORT
               SalAct2 = SalAct2 - IMPUSA
            ENDIF
            SKIP
         ENDDO
         IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
            IF LiCodMon = 1
               ZfSalAct1 = ZfSalAct1 + SalAct1
               TfSalAct  = SalAct1
            ELSE
               ZfSalAct2 = ZfSalAct2 + SalAct2
               TfSalAct  = SalAct2
            ENDIF
            IF XiForma = 1 .AND. TfSalAct <> 0
               NumEle = NumEle + 1
               IF NumEle < ALEN(vDatos)
                  DIMENSION vDatos(NumEle+10)
                  DIMENSION vCdCta(NumEle+10,2)
               ENDIF
               vCdCta(NumEle,1) = LsCodCta
               vCdCta(NumEle,2) = LsCodAux
               IF LsCodAux = "99"
                  vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsGloDoc+" ",60)
               ELSE
                  vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsNomAux+" ",60)
               ENDIF
               IF LiCodMon = 1
                  IF SalAct1 >= 0
                     vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(SalAct1,"@Z 9,999,999.99 ")
                  ELSE
                     vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(-SalAct1,"@Z 9,999,999.99-")
                  ENDIF
               ELSE
                  IF SalAct2 >= 0
                     vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(SalAct2,"@Z 9,999,999.99 ")
                  ELSE
                     vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(-SalAct2,"@Z 9,999,999.99-")
                  ENDIF
               ENDIF
               vDatos(NumEle) = vDatos(NumEle) + PADR(SPACE(9)+LSNROREF + " "+ LSNOTAST,60)
            ENDIF
         ENDIF
      ENDDO
   NEXT
   IF ZfSalAct1#0 .OR. ZfSalAct2#0
      LfSalAct1 = LfSalAct1 + ZfSalAct1
      LfSalAct2 = LfSalAct2 + ZfSalAct2
      IF XiForma = 0
         NumEle = NumEle + 1
         IF NumEle < ALEN(vDatos)
            DIMENSION vDatos(NumEle+10)
            DIMENSION vCdCta(NumEle+10)
         ENDIF
         vCdCta(NumEle) = "PROV"
         vDatos(NumEle) = PADR(PADR(LsCodAux,LEN(rmov.CodAux))+" "+LsNomAux+" ",49)
         IF ZfSalAct1 >= 0
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(ZfSalAct1,"@Z 9,999,999.99  ")
         ELSE
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(-ZfSalAct1,"@Z 9,999,999.99- ")
         ENDIF
         IF ZfSalAct2 >= 0
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(ZfSalAct2,"@Z 9,999,999.99  ")
         ELSE
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(-ZfSalAct2,"@Z 9,999,999.99- ")
         ENDIF
      ENDIF
   ENDIF
   SELECT AUXI
   SKIP
ENDDO
RETURN
**************************************************************************** FIN
PROCEDURE CARGA1   && SEGUN LA CUENTAS [LsCodCta]
****************
=SEEK(LsCodCta,"CTAS")
XsClfAux = CTAS->CLFAUX
SELECT RMOV
SEEK LsCodCta
DO WHILE CodCta = LsCodCta .AND. ! EOF()
   LsCodAux = CodAux
   =SEEK(XsClfAux+LsCodAux,"AUXI")
   LsNomAux = AUXI->NomAux
   @ 24,0 SAY PADC(TRIM(LsCodAux)+" "+TRIM(LsNomAux),80)
   ZfSalAct1 = 0
   ZfSalAct2 = 0
   DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! EOF()
      SalAct1  = 0
      SalAct2  = 0
      =SEEK(NROMES+CODOPE+NROAST,"VMOV")
      LsNroDoc = NroDoc
      LiCodMon = CodMon
      LdFchVto = FchVto
      LsNroRef = NroRef
      LsGloDoc = GloDoc
      LsNotAst = VMOV->NotAst
      DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
         IF TpoMov = "H"
            SalAct1 = SalAct1 + IMPORT
            SalAct2 = SalAct2 + IMPUSA
         ELSE
            SalAct1 = SalAct1 - IMPORT
            SalAct2 = SalAct2 - IMPUSA
         ENDIF
         SKIP
      ENDDO
      IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
         IF LiCodMon = 1
            ZfSalAct1 = ZfSalAct1 + SalAct1
            TfSalAct  = SalAct1
         ELSE
            ZfSalAct2 = ZfSalAct2 + SalAct2
            TfSalAct  = SalAct2
         ENDIF
         IF XiForma = 1 .AND. TfSalAct <> 0
            NumEle = NumEle + 1
            IF NumEle < ALEN(vDatos)
               DIMENSION vDatos(NumEle+10)
               DIMENSION vCdCta(NumEle+10,2)
            ENDIF
            vCdCta(NumEle,1) = LsCodCta
            vCdCta(NumEle,2) = LsCodAux
            IF LsCodAux = "99"
               vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsGloDoc+" ",60)
            ELSE
               vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsNomAux+" ",60)
            ENDIF
            IF LiCodMon = 1
               IF SalAct1 >= 0
                  vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(SalAct1,"@Z 9,999,999.99 ")
               ELSE
                  vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(-SalAct1,"@Z 9,999,999.99-")
               ENDIF
            ELSE
               IF SalAct2 >= 0
                  vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(SalAct2,"@Z 9,999,999.99 ")
               ELSE
                  vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(-SalAct2,"@Z 9,999,999.99-")
               ENDIF
            ENDIF
            vDatos(NumEle) = vDatos(NumEle) + PADR(SPACE(9)+LSNROREF +" "+ LSNOTAST,60)
         ENDIF
      ENDIF
   ENDDO
   IF ZfSalAct1#0 .OR. ZfSalAct2#0
      LfSalAct1 = LfSalAct1 + ZfSalAct1
      LfSalAct2 = LfSalAct2 + ZfSalAct2
      IF XiForma = 0
         NumEle = NumEle + 1
         IF NumEle < ALEN(vDatos)
            DIMENSION vDatos(NumEle+10),vCdCta(NumEle+10)
         ENDIF
         vCdCta(NumEle) = LsCodCta
         vDatos(NumEle) = PADR(PADR(LsCodAux,LEN(rmov.CodAux))+" "+LsNomAux+" ",49)
         IF ZfSalAct1 >= 0
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(ZfSalAct1,"@Z 9,999,999.99  ")
         ELSE
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(-ZfSalAct1,"@Z 9,999,999.99- ")
         ENDIF
         IF ZfSalAct2 >= 0
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(ZfSalAct2,"@Z 9,999,999.99  ")
         ELSE
            vDatos(NumEle) = vDatos(NumEle) + TRANSF(-ZfSalAct2,"@Z 9,999,999.99- ")
         ENDIF
      ENDIF
   ENDIF
ENDDO
RETURN
********************
PROCEDURE Close_FILE
********************
IF USED('CTAS')
	USE IN CTAS
ENDIF
IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('VMOV')
	USE IN VMOV
ENDIF
IF USED('RMOV')
	USE IN RMOV
ENDIF
IF USED('TCMB')
	USE IN TCMB
ENDIF
IF USED('TABL')
	USE IN TABL
ENDIF
IF USED('PROV')
	USE IN PROV
ENDIF
FUNCTION v1
UltTecla = LASTKEY()
WAIT WINDOW STR(UltTecla) nowait

***************
FUNCTION dato1
***************
UltTecla = Lastkey()
*IF LastKey() = Enter
   OK = 1
*   KEYB CHR(23)
   CLEAR read 
*ENDIF
RETURN .T.
***************
FUNCTION dato2
***************
UltTecla = Lastkey()
*IF LastKey() = Enter
   OK = 1
*   KEYB CHR(23)
   CLEAR read 
*ENDIF
RETURN .T.
