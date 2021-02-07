********************************************************************************
* Programa      : CBDRB09b.PRG                                                 *
* Objeto        : ESTADOS DE GESTION x Referencia <CodRef>                     *
* Autor         : VETT                                                         *
* Creaci¢n      : 27/02/95                                                     *
* Actualizaci¢n : 05/MAY/2000                                                  *
********************************************************************************
PARAMETER _ClfAux

*** Abrimos Bases ****
DIMENSION SAC(6,20)
DIMENSION vCodRef(20)

sele 1
use cbdmtabl order tabl01 alias TABL   && TABLAS
if !used(1)
    close data
    return
endif
***
sele 2
use cbdacmct order acct01 alias ACCT   && ACUMULADO CONTABLE
if !used(2)
    close data
    return
endif
***
sele 4
use CBDTPERN ORDER TPER01 alias TBAL   && DETALLE DE REPORTE A LISTAR
if !used(4)
    close data
    return
endif
***
sele 5
use cbdNPERN order NPER01 alias NBAL   && CUENTAS QUE COMPONE EL REPORTE
if !used(5)
    close data
    return
endif
***
sele 6
use cbdmauxi order auxi01 alias AUXI  && MAESTRO DE AUXILIARES/JALAR EL NOMBRE DE LA DIVISIONARIA
if !used(6)
    close data
    return
endif
***
sele 7
use cbdtajus order AJUS01 alias AJUS
if !used(7)
    close data
    return
endif
***
SELE 0
use cbdmctas order ctas01 alias ctas
if !used()
    close data
    return
endif

** Solo saldo Hist¢rico **
ArcTmp = SYS(3)
SELE AJUS
SET ORDER TO AJUS02
SELE ACCT
SET RELA TO CODCTA INTO AJUS
SET RELA TO CODCTA INTO CTAS ADDITIVE
COPY TO &ArcTmp FOR CTAS.AFTMOV="S" .AND. !CodCta==AJUS->CtaAju WITH CDX
**COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=LEN(ACCT.CodCta) .AND. CodCta#AJUS->CtaAju WITH CDX
SET RELA TO
SELE AJUS
SET ORDER TO AJUS01
SELE 2
USE &ArcTmp ORDER ACCT01 ALIAS ACCT
IF !USED()
   CLOSE DATA
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
   RETURN
ENDIF



******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ESTADOS DE GESTION POR C/COSTOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES

@  9,10 FILL  TO 18,68      COLOR W/N
@  8,11 CLEAR TO 17,69
@  8,11       TO 17,69

DO LIB_MTEC WITH 16

STORE SPACE(LEN(ACCT.CodRef)) TO vCodRef
XiCodMon = 1
XiMesIni = 1
XiMesFin = _Mes
XsCodBal = "01"
XsClfAux  = _ClfAux
XsCodAux = SPACE(LEN(ACCT.CodRef))
XsNomAux = ""
LsCodRef = SPACE(LEN(ACCT.CodRef))
LsCodRefH= SPACE(LEN(ACCT.CodRef))
XiTipo = 2
@ 10,25 SAY "MONEDA     : "
@ 11,25 SAY "DESDE MES  : "
@ 12,25 SAY "HASTA MES  : "
@ 13,25 SAY "ESTADO     : "
@ 15,25 SAY "CONDICION  : "



LiTotItm = 0
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,38,2)
      CASE i = 2
         @ 11,38 GET XiMesIni   PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 12,38 GET XiMesFin   PICTURE "99"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         SELECT TABL
         XsTabla = "31"
         @ 13,38 GET XsCodBal PICTURE "99"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsCodBal = LEFT(CODIGO,2)
         ENDIF
         SEEK Xstabla+XsCodbal
         @ 14,16 SAY NOMBRE

         IF ! FOUND()
            GsMsgErr = "** C¢digo no registrado **"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
      CASE I = 5
         SELE AUXI
         VecOpc(1) = "Rangos    "
         VecOpc(2) = "Selectivo "
         XiTipo    = ELIGE(XiTipo,15,38,2)
         IF XiTipo = 1
            LiTotItm = 0
            DO CapDivis
         ELSE
            LiTotItm = 0
            DO SelDivis
         ENDIF
         IF LastKey() = Escape
            UltTecla  = Arriba
         ENDIF
         IF Lastkey() <> Escape
            UltTecla = Enter
         ENDIF
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 5 , i + 1, 5 )

      CASE UltTecla = Enter
         IF  i < 5
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
   RETURN
ENDIF
IF LiTotItm <= 0
   GsMsgErr = "No hay Centros de costo seleccionadas"
   DO LIB_MERR WITH 99
   CLOSE DATA
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
   RETURN
ENDIF
XsCodAux = TRIM(XsCodAux)

SELE TABL
XsNomBal = ALLTRIM(Nombre)
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
   RETURN
ENDIF

STORE 0 TO ZfTotSol,ZfTotDol,zFactor
IF ! CARGA()
   CLOSE DATA
   DELE FILE &ArcTmp..DBF
   DELE FILE &ArcTmp..CDX
   RETURN
ENDIF

VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
SELECT TBAL
UNLOCK ALL

Ancho = 188
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN4+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
IF XiMesFin < 12
   LdFecha   = CTOD("01/"+STR(XiMesFin+1,2,0)+"/"+STR(_Ano,4,0)) - 1
ELSE
   LdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
ENDIF
Titulo  = XsNomBal+" al "+STR(DAY(LdFecha),2)+" de "+Mes(XiMesFin,3)+" de "+str(_ano,4)
SubTitulo = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En1 = ""
En2=""
En3 = "<HORA : "+TIME()
En4 = ""
En5 = ""
STORE "" TO xEn6,xEn7,xEn8,xEn9,yEn6,yEn7,yEn8,yEn9,zEn6,zEn7,zEn8,zEn9
STORE 0 TO xAncho,yAncho,zAncho
En6 = "------------------------------------------"
En7 = "                                          "
En8 = "CUENTA  DESCRIPCION                       "
En9 = "------------------------------------------"
*En6 = "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
*En7 = "                                                   1                 2            3                4              5               6                7               8             9              10                11              12        "
*En8 = "CUENTA  DESCRIPCION                                12               13           14                                                                                                                               22          T O T A L     "
*En8 = "CUENTA  DESCRIPCION                                23               24           25                                                                                                                               33          T O T A L     "
*En9 = "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
     *  0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456
     *            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4
     *                                             123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345 123456789-12345
Cancelar = .F.
nCol     = 12
DIMENSION vDivis(LitotItm)
STORE 0 TO vDivis
SELECT TBAL
Pos1 = 43
Esp  = 16
DO Cabecera
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   SEEK XsCodBal
   Inicio = .T.
   NumPag  = 0

   STORE 0 TO SAC

   DO WHILE ! EOF() .AND. Rubro = XsCodBal .AND. ! Cancelar
      DO ResetPag
      NumLin = PROW() + 1
      DO LinImp
      Cancelar = (INKEY() = ESCAPE)
      SKIP
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
DELE FILE &ArcTmp..DBF
DELE FILE &ArcTmp..CDX
RETURN

****************
PROCEDURE LinImp
****************
@ NumLin,0 SAY Glosa PICT "@S33"
DO CASE
   CASE NOTA = "R1"
      FOR I = 1 TO LiTotItm
        STORE 0 TO SAC(1,I)
      NEXT
   CASE NOTA = "R2"
      FOR I = 1 TO LiTotItm
        STORE 0 TO SAC(2,I)
      NEXT
   CASE NOTA = "R3"
      FOR I = 1 TO LiTotItm
        STORE 0 TO SAC(3,I)
      NEXT
   CASE NOTA = "R4"
      FOR I = 1 TO LiTotItm
        STORE 0 TO SAC(4,I)
      NEXT
   CASE NOTA = "R5"
      FOR I = 1 TO LiTotItm
        STORE 0 TO SAC(5,I)
      NEXT
   CASE NOTA = "RS"
      @ NumLin,Pos1 SAY REPLICATE("-",Ancho - Pos1)
   CASE NOTA = "RD"
      @ NumLin,Pos1 SAY REPLICATE("=",Ancho - Pos1)
   CASE NOTA = "L1"
      TOT = 0
      FOR I = 1 TO LiTotItm
        @ NumLin,Pos1+(i-1)*Esp  SAY PICNUM(SAC[1,I])
        TOT      = TOT + SAC[1,I]
        SAC[1,I] = 0
      NEXT
      @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)

   CASE NOTA = "L2"
      TOT = 0
      FOR I = 1 TO LiTotItm
        @ NumLin,Pos1+(i-1)*Esp   SAY PICNUM(SAC[2,I])
        TOT      = TOT + SAC[2,I]
        SAC[2,I] = 0
      NEXT
      @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)

   CASE NOTA = "L3"
      TOT = 0
      FOR I = 1 TO LiTotItm
        @ NumLin,Pos1+(i-1)*Esp   SAY PICNUM(SAC[3,I])
        TOT      = TOT + SAC[3,I]
        SAC[3,I] = 0
      NEXT
      @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)

   CASE NOTA = "L4"
        TOT = 0
        FOR I = 1 TO LiTotItm
          @ NumLin,Pos1+(i-1)*Esp   SAY PICNUM(SAC[4,I])
          IF GloCta ="UTI"
             vDivis(I) = SAC[4,I]
          ENDIF
          TOT      = TOT + SAC[4,I]
          SAC[4,I] = 0
        NEXT
        @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)
   CASE NOTA = "L5"
      TOT = 0
      FOR I = 1 TO LiTotItm
        @ NumLin,Pos1+(i-1)*Esp            SAY PICNUM(SAC[5,I])
        TOT      = TOT + SAC[5,I]
        SAC[5,I] = 0
      NEXT
      @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)

   CASE NOTA = "TG"
      TOT = 0
      FOR I = 1 TO LiTotItm
        @ NumLin,Pos1+(i-1)*Esp      SAY PICNUM(SAC[6,I])
        TOT      = TOT + SAC[6,I]
        SAC[6,I] = 0
      NEXT
      @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)
   CASE ! EMPTY(Nota)
      TOT = 0
      =SEEK(Rubro+Nota,"NBAL")
      IF !INLIST(NBAL->CodCta,"VA","VM")
         FOR I = 1 TO LiTotItm
             IF XiCodMon = 1
                Campo = "DivS"+TRANSF(I,"@L 99")
             ELSE
                Campo = "DivD"+TRANSF(I,"@L 99")
             ENDIF
             Campo = EVALUATE(Campo)
             @ NumLin,Pos1+(i-1)*Esp   SAY PICNUM(Campo)
             TOT = TOT + Campo
             FOR Y = 1 TO 6
                SAC[Y,I] = SAC[Y,I] + Campo
             NEXT
         NEXT
      ELSE
         FOR I = 1 TO LiTotItm
             IF XiCodMon = 1
                Campo = "DivS"+TRANSF(I,"@L 99")
             ELSE
                Campo = "DivD"+TRANSF(I,"@L 99")
             ENDIF
             Factor = EVALUATE(Campo)
             Campo1 = vDivis(I)*Factor*IIF(NBAL->Signo="2",-1,1)
             @ NumLin,Pos1+(i-1)*Esp   SAY PICNUM(Campo1)
             TOT = TOT + Campo1
             FOR Y = 1 TO 6
                SAC[Y,I] = SAC[Y,I] + Campo1
             NEXT
         NEXT
      ENDIF
      @ NumLin,Pos1+(LiTotItm)*Esp  SAY PICNUM(TOT)
      **
ENDCASE
RETURN
****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
   RETURN TRANSF(-Valor,"@Z #######,###.##")+"-"
ELSE
   RETURN TRANSF( Valor,"@Z #######,###.##")+" "
ENDIF
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio  = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
***************
PROCEDURE Carga
***************
@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
DIMENSION SOLES(14),DOLARES(14),vDivis(14)
DIMENSION XSOLES(14),XDOLARES(14)
STORE 0 TO vDivis
SELECT TBAL
IF ! FIL_LOCK(5)
   RETURN .F.
ENDIF
SEEK XsCodBal
DO WHILE Rubro = XsCodBal .AND. ! EOF()
   DO CASE
      CASE NOTA = "RS"
      CASE NOTA = "RD"
      CASE NOTA = "L1"
      CASE NOTA = "L2"
      CASE NOTA = "L3"
      CASE NOTA = "L4"
      CASE NOTA = "TG"
      CASE ! EMPTY(Nota)
         DO CAPTURA
   ENDCASE
   SELECT TBAL
   SKIP
ENDDO
RETURN .T.
*****************
PROCEDURE CAPTURA
*****************
STORE 0 TO SOLES,DOLARES
XcRubro = Rubro
XsNota  = Nota
SELECT NBAL
Llave = XcRubro+XsNota
SEEK Llave
DO WHILE ! EOF() .AND. Rubro+Nota = Llave
   DO VALORIZA
   SELECT NBAL
   SKIP
ENDDO
DO GRABA
RETURN
******************
PROCEDURE VALORIZA
******************
XsCodCta = TRIM(CodCta)

XcSigno  = Signo
XsCodRef = TRIM(CodRef)
XsCodRefH= TRIM(CodRefH)
IF XcSigno$"34"
   RETURN
ENDIF
IF "X"$CodCta
   XsCodCta = LEFT(CodCta,AT("X",CodCta)-1)
   LEN= LEN(TRIM(CODCTA))
ELSE
   XsCodCta = TRIM(CodCta)
   LEN=0
ENDIF
IF  ! XsCodCta="VA"  .AND. ! XsCodCta="VM"
    SELECT ACCT
    FOR TnMes=XiMesIni  TO  XiMesFin
       xLLave = STR(TnMes,2,0)+XsCodCta
       SEEK xLlave
       XS=0
       XD=0
       DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
          IF CodRef <> XsCodRef
             SKIP
             LOOP
          ENDIF
          IF LEN = LEN(TRIM(CODCTA)) .OR. LEN=0
             XS =  DbeNac - Hbenac
             XD =  DbeExt - HbeExt
             IF XcSigno = '2'
                XS = - XS
                XD = - XD
             ENDIF
             DO CASE
                CASE EMPTY(XsCodRef) .AND. EMPTY(XsCodRefH)
                  TstLin = [.T.]
                CASE !EMPTY(XsCodRef) .AND. !EMPTY(XsCodRefH)
                  TstLin = [CodRef>=XsCodRef .AND. CodRef<=XsCodRefH]
                CASE !EMPTY(XsCodRef) .AND. EMPTY(XsCodRefH)
                  TstLin = [CodRef>=XsCodRef]
                CASE EMPTY(XsCodRef) .AND. !EMPTY(XsCodRefH)
                  TstLin = [CodRef<=XsCodRefH]
             ENDCASE
             IF  EVALUATE(TstLin)
                 FOR k = 1 TO LiTotItm
                     IF CodRef = LEFT(vCodRef(k),LEN(ACCT.CodREf))
                        SOLES(k)   = SOLES(k)   + XS
                        DOLARES(k) = DOLARES(k) + XD
                     ENDIF
                 ENDFOR
             ENDIF
          ENDIF
          SKIP
       ENDDO
    ENDFOR
ELSE
   STORE 0 TO ZfTotSol,ZfTotDol
   FOR TnMes=XiMesIni  TO  XiMesFin
       XS=0
       XD=0
       xLLave = TRANS(TnMes,"@L ##")+SUBSTR(XsCodCta,3,3)
       SELE VARS
       SEEK xLlave
       IF FOUND()
          XS = Import
          XD = Impusa
       ENDIF
      *IF XcSigno = '2'
      *   XS = - XS
      *   XD = - XD
      *ENDIF
       ZfTotSol = ZfTotSol + XS
       ZfTotDol = ZfTotDol + XD
   ENDFOR
   **
   =SEEK(TRANS(XiMesFin,"@L ##"),"RBAL")
   IF XiCodMon = 1
      ZfTotUti =  IIF(RBAL->UtiAcmS=0,1,RBAL->UtiAcmS)
      ZfTotVar =  ZfTotSol
   ELSE
      ZfTotUti =  IIF(RBAL->UtiAcmD=0,1,RBAL->UtiAcmD)
      ZfTotVar =  ZfTotDol
   ENDIF
   zFactor = ABS(ZfTotUti/ZfTotVar)
   FOR k = 1 TO LiTotItm
      *SELE VARS
      *xLLave = TRANS(XiMesFin,"@L ##")+SUBSTR(XsCodCta,3,3)
      *IF FOUND()
      *   XS = Import
      *   XD = Impusa
      *ENDIF
      *IF XcSigno = '2'
      *   XS = - XS
      *   XD = - XD
      *ENDIF
       SOLES(k)   = SOLES(k)   + zFactor
       DOLARES(k) = DOLARES(k) + zFactor
   ENDFOR
ENDIF
RETURN
***************
PROCEDURE GRABA
***************
SELECT TBAL

LNMES=0

LNDIV=1
DO WHILE LNDIV<=12
   Campo1="DivS"+TRANSF(LnDIV,"@L ##")
   Campo2="DivD"+TRANSF(LnDIV,"@L ##")
   REPLACE &Campo1 WITH 0
   REPLACE &Campo2 WITH 0
   LNDIV=LNDIV+1
ENDDO

FOR TnDiv=1 TO  LiTotItm
   Campo1="DivS"+TRANSF(TnDiv,"@L ##")
   Campo2="DivD"+TRANSF(TnDiv,"@L ##")
   REPLACE &Campo1 WITH Soles(TnDIV)
   REPLACE &Campo2 WITH Dolares(TnDIV)
ENDFOR

RETURN
******************
PROCEDURE CapDivis
******************
SELE AUXI
SEEK XsClfAux+TRIM(LsCodRef)
DO WHILE !EOF() AND ClfAux=XsClfAux AND LEFT(CodAux,LEN(ACCT.CodRef))<=LsCodRefH
   LiTotItm = LiTotItm + 1
   IF LiTotItm >40
      GsMsgErr = "Nro. de divisionarias demasiado grande"
      DO LIB_MERR WITH 99
      GsMsgErr = "Ampliar campos en el archivo"
      DO LIB_MERR WITH 99
      EXIT
   ENDIF
   IF ALEN(vCodRef) < LiTotItm
      DIMENSION vCodPrd(LiTotItm+10)
      DIMENSION SAC(6,LiTotItm+10)
   ENDIF
   vCodRef(LiTotItm) = LEFT(AUXI->CodAux,LEN(ACCT->CodRef))
   SKIP
ENDDO
RETURN
****************************************
*  Seleccionamos divisionarias         *
****************************************
PROCEDURE SelDivis
UltTecla = 0
EscLin   = "CAPbline"
EdiLin   = "CAPbedit"
BrrLin   = "CAPbborr"
InsLin   = "CAPbinse"
*
yo       = 6
xo       = 2
Largo    = 14
Ancho    = 30
TBorde   = Simple
Titulo   = ""

En1 = " Cod.Div.     NomBre        "
En2 = ""
En3 = ""

CiMaxEle = 20
MaxEle   = LiTotItm
TotEle   = 20
Static = .F.
*
DO aBrowse
IF Lastkey() <> Escape
   UltTecla = F10
ENDIF
*
LiTotItm = MaxEle
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE CAPbline
PARAMETERS NumEle, NumLin
*
=SEEK(_ClfAux+TRIM(vCodRef(NumEle)),"AUXI")
@ NumLin,Xo+2 SAY vCodRef(NumEle)
@ Numlin,Xo+8 SAY LEFT(AUXI->NomAux,15)
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE CAPbedit
PARAMETERS NumEle, NumLin ,LiUtecla
PRIVATE i,LsSalBrow
i = 1
LsCodRef = vCodref(NumEle)
DO WHILE !INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1
          XsClfAux = _ClfAux
          SELE AUXI
          @ NumLin,Xo+2 GET LsCodRef PICT "@!"
          READ
          UltTecla = LASTKEY()
          IF UltTecla = F8
             SEEK XsClfAux+TRIM(LsCodRef)
             IF CbdBusca("AUXI")
                LsCodRef = LEFT(AUXi->CodAux,LEN(ACCT.CodREf))
                UltTecla = Enter
             ELSE
                UltTecla = 0
                LOOP
             ENDIF
          ENDIF
          IF UltTecla = Escape
             EXIT
          ENDIF
          SEEK XsClfAux+LsCodRef
          IF !FOUND()
             GsMsgErr = "Divisionaria inv lida"
             Do LIB_MERR WITH 99
             UltTecla  = 0
             LOOP
          ENDIF
          @ Numlin,Xo+8 SAY LEFT(AUXI->NomAux,15)

      CASE I = 2
         IF UltTecla = Enter .OR. UltTecla = Escape
            EXIT
         ENDIF
         IF INLIST(UltTecla,F10,CTRLw)
            UltTecla = CtrlW
            EXIT
         ENDIF
         i = 1
   ENDCASE
   I = IIF(UltTecla = Arriba,I-1,I+1)
   I = IIF(I>2,2,I)
   I = IIF(I<1,1,I)
ENDDO
IF UltTecla <> Escape
   vCodRef(NumEle) = LsCodRef
ENDIF
LiUtecla = UltTecla
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE CAPbborr
PARAMETERS ElePrv, Estado
i = ElePrv + 1
DO WHILE i <  MaxEle
   vCodRef(i) = vCodRef(i+1)
   i = i + 1
ENDDO
STORE SPACE(LEN(ACCT->CodRef)) TO vCodRef(i)
Estado = .T.
RETURN
******************
PROCEDURE CAPbinse
******************
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
DO WHILE i > ElePrv + 1
   vCodRef(i) = vCodRef(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
STORE SPACE(LEN(ACCT->CodRef)) TO vCodRef(i)
Estado = .T.
RETURN
*********************
PROCEDURE CABECERA
*********************
PRIVATE k
FOR k = 1 TO LiTotItm
    IF SEEK(XsClfAux+TRIM(vCodRef(k)),"AUXI")
       DO CASE
          CASE k<=12
             IF k < 12
                LsNombre1 = PADC(SUBSTR(AUXI->NomAux,1,Esp-2),Esp)
                LsNombre2 = PADC(SUBSTR(AUXI->NomAux,Esp+1,Esp-2),Esp)
                EN6 = EN6 + REPLICATE("-",Esp)
                EN7 = EN7 + " "+LEFT(LsNomBre1,Esp-2)+" "
                EN8 = EN8 + " "+LEFT(LsNomBre2,Esp-2)+" "
                EN9 = EN9 + REPLICATE("-",Esp)
             ENDIF
          CASE k >= 12 .AND. K<= 22
                LsNombre1 = PADC(SUBSTR(AUXI->NomAux,1,Esp-2),Esp)
                LsNombre2 = PADC(SUBSTR(AUXI->NomAux,Esp+1,Esp-2),Esp)
               xEN6 =xEN6 + REPLICATE("-",Esp)
               xEN7 =xEN7 + " "+LEFT(LsNomBre1,Esp-2)+" "
               xEN8 =xEN8 + " "+LEFT(LsNomBre2,Esp-2)+" "
               xEN9 =xEN9 + REPLICATE("-",Esp)
          CASE k >= 23 .AND. K<= 33
                LsNombre1 = PADC(SUBSTR(AUXI->NomAux,1,Esp-2),Esp)
                LsNombre2 = PADC(SUBSTR(AUXI->NomAux,Esp+1,Esp-2),Esp)
               yEN6 =yEN6 + REPLICATE("-",Esp)
               yEN7 =yEN7 + " "+LEFT(LsNomBre1,Esp-2)+" "
               yEN8 =yEN8 + " "+LEFT(LsNomBre2,Esp-2)+" "
               yEN9 =yEN9 + REPLICATE("-",Esp)
          CASE k >= 34 .AND. K<= 40
                LsNombre1 = PADC(SUBSTR(AUXI->NomAux,1,Esp-2),Esp)
                LsNombre2 = PADC(SUBSTR(AUXI->NomAux,Esp+1,Esp-2),Esp)
               zEN6 =zEN6 + REPLICATE("-",Esp)
               zEN7 =zEN7 + " "+LEFT(LsNomBre1,Esp-2)+" "
               zEN8 =zEN8 + " "+LEFT(LsNomBre2,Esp-2)+" "
               zEN9 =zEN9 + REPLICATE("-",Esp)
       ENDCASE
    ENDIF
ENDFOR
EN6 = EN6 + REPLICATE("-",Esp)
EN7 = EN7 +"                 "
EN8 = EN8 +"   T O T A L     "
EN9 = EN9 + REPLICATE("-",Esp)
IF K>11
  xEN6 =LEFT(EN6,Pos1-1)+ xEN6 +REPLICATE("-",Esp)
  xEN7 =LEFT(EN7,Pos1-1)+ xEN7 +"                 "
  xEN8 =LEFT(EN8,Pos1-1)+ xEN8 +"   T O T A L     "
  xEN9 =LEFT(EN9,Pos1-1)+ xEN9 +REPLICATE("-",Esp)
  xAncho = LEN(xEN6)
ENDIF
IF K>22
  yEN6 =LEFT(EN6,Pos1-1)+ yEN6 + REPLICATE("-",Esp)
  yEN7 =LEFT(EN7,Pos1-1)+ yEN7 +"                 "
  yEN8 =LEFT(EN8,Pos1-1)+ yEN8 +"   T O T A L     "
  yEN9 =LEFT(EN9,Pos1-1)+ yEN9 + REPLICATE("-",Esp)
  yAncho = LEN(yEN6)
ENDIF
IF K>33
  zEN6 =LEFT(EN6,Pos1-1)+ zEN6 + REPLICATE("-",Esp)
  zEN7 =LEFT(EN7,Pos1-1)+ zEN7 +"                 "
  zEN8 =LEFT(EN8,Pos1-1)+ zEN8 +"   T O T A L     "
  zEN9 =LEFT(EN9,Pos1-1)+ zEN9 + REPLICATE("-",Esp)
  zAncho = LEN(zEN6)
ENDIF
Ancho = LEN(EN6)
RETURN
