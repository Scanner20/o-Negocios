**************************************************************************
*  Nombre    : CBDCstxp.PRG                                              *
*  Autor     : VETT                                                      *
*  Objeto    : Obtener costo de venta de un producto                     *
*  Par metros:            : Ninguno                                      *
*  Creaci¢n     : 12/11/94                                               *
*  Actualizaci¢n:                                                        *
**************************************************************************
*--------- Rubros de Gastos por producci¢n ---------*
GsSubAlm="001"
DIMENSION vTpoGto(10,10),vCosto(6),vCostoU(2),vDesGto(10),vCodMat(3),vCantid(3)
STORE 0 TO vRubro,vCosto,vCostoU,vCantid
STORE [  ] TO vTpoGto
vDesGto(1) = [Materias Primas]
vTpoGto(1,1)  = "01"
vTpoGto(1,2)  = "02"
vTpoGto(1,3)  = "03"
vTpoGto(1,4)  = "06"
vTpoGto(1,5)  = "09"

vDesGto(2) = [Mano de obra]
vTpoGto(2,1)  = "11"
vTpoGto(2,2)  = "12"
vTpoGto(2,3)  = "19"
vTpoGto(2,4)  = "06"
vTpoGto(2,5)  = "09"


vDesGto(3) = [Combustible]
vTpoGto(3,1)  = "31"
vTpoGto(3,2)  = "33"

vDesGto(4) = [Materiales Indirectos]
vTpoGto(4,1)  = "34"
vTpoGto(4,2)  = "37"
vTpoGto(4,3)  = "39"

vDesGto(5) = [Agua]
vTpoGto(5,1)  = "41"

vDesGto(6) = [Fuerza el‚ctrica]
vTpoGto(6,1)  = "42"

vDesGto(7) = [Seguros]
vTpoGto(7,1)  = "43"

vDesGto(8) = [Reparaci¢n y Mantenimiento]
vTpoGto(8,1)  = "46"

vDesGto(9) = [Otros Servicios de Terceros]
vTpoGto(9,1)  = "44"
vTpoGto(9,2)  = "48"
vTpoGto(9,3)  = "49"
vTpoGto(9,4)  = "15"
vTpoGto(9,5)  = "16"

vDesGto(10) = [Gastos Generales]
vTpoGto(10,1) = "50"
vTpoGto(10,2) = "61"
vTpoGto(10,3) = "62"
vTpoGto(10,4) = "65"
vTpoGto(10,5) = "69"
vTpoGto(10,6) = "90"
**
*--------------------------*
cTit1 = GsNomCia
cTit2 = ""
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "COSTO DE PRODUCCION POR PRODUCTO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SELE 1
USE ALMMMATG ORDER MATG01 ALIAS MATG
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
****
SELE 2
USE ALMRMOVM ORDER RMOV02 ALIAS ARMOV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 3
USE ALMTFAMI ORDER FAMI01 ALIAS FAMI
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
sele 4
use cbdmctas order CTAS01 alias CTAS
if !used()
    close data
    return
endif

sele 5
use cbdacmct order acct02 alias ACCT
if !used()
    close data
    return
endif

sele 6
use cbdmauxi order AUXI01 alias AUXI
if !used()
    close data
    return
endif

SELE 7
USE CSTTDIST order DIST01 ALIAS DIST
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF

***
DIMENSION vCLFGTO(06)
vCLFGTO(01) = "01-09           SUB-TOTAL MATERIAS PRIMAS "
vCLFGTO(02) = "11-19           SUB-TOTAL MANO DE OBRA    "
vCLFGTO(03) = "31-39           SUB-TOTAL MATERIALES      "
vCLFGTO(03) = "20-29           SUB-TOTAL                 "
vCLFGTO(05) = "41-89           SUB-TOTAL GASTOS FABRICAC."
vCLFGTO(06) = "90-99           SUB-TOTAL OTROS GASTOS    "

UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
XiMesIni = 1
XiMesFin = _Mes
XiNroDig = 1

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE MES  : "
@ 12,24 SAY "HASTA MES  : "
*@ 13,24 SAY "DIGITOS    : "
DO LIB_MTEC WITH 16
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
     *CASE i = 4
     *   VecOpc(1)="2"
     *   VecOpc(2)="3"
     *   VecOpc(3)="5"
     *   VecOpc(4)="5 (S¢lo Totales)"
     *   XiNroDig= Elige(1,13,38,4)
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 3 , i + 1, 3 )

      CASE UltTecla = Enter
         IF  i < 3
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF

@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
ArcTmp = PathUser+SYS(3)
SELECT ACCT
SEEK "9"
SET TALK ON
SET TALK WINDOW
IF XiCodMon = 1
   COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=5 .AND. CodCta = "9" .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 WHILE CodCta="9"
ELSE
   COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=5 .AND. CodCta = "9" .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBEEXT-HBEEXT)#0 WHILE CodCta="9"
ENDIF
**
LdFchDocD = CTOD("01/"+STR(_MES,2,0)+"/"+STR(_ANO,4,0))
IF _Mes < 12
   LdFchDocH = CTOD("01/"+STR(_MES+1,2,0)+"/"+STR(_Ano,4,0)) - 1
ELSE
   LdFchDocH = CTOD("31/12/"+STR(_ANO,4,0))
ENDIF
**
SET TALK OFF
DO CASE
   CASE XiNroDig = 1
      DO IMP2D
   OTHER
      DO IMP5D
ENDCASE
CLOSE DATA
DELETE FILE &ArcTmp..dbf
DELETE FILE &ArcTmp..idx
***************
PROCEDURE IMP2D
***************
SELECT 0
USE &ArcTmp ALIAS TEMPO EXCL
INDEX ON CODREF+CODCTA TO  &ArcTmp
SET INDEX TO &ArcTmp
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF


Ancho = 160
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 66 - 8
IniImp  = _PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "COSTO DE PRODUCCION POR PRODUCTO"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = "----------------------------------- ----------------------------------------------------- ----------------- ----------------- ----------------- -----------------"
En7 = "                                         Fusi¢n           Disoluci¢n      Otros Costos     Gasto Administ     Gasto Ventas      Gasto Finac.                     "
En8 = "     D e s c r i p c i ¢ n                                                                                                                           T o t a l   "
En9 = "----------------------------------- ----------------- ----------------- ----------------- ----------------- ----------------- ----------------- -----------------"
      *0123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-0123456789-123456789-123456789-
*n8 = "Gast D e s c r i p c i ¢ n                 911               912             91/92                93               95                97              T o t a l    "
Import911= 0
Import912= 0
Import91 = 0
Import92 = 0
Import93 = 0
Import95 = 0
Import97 = 0
LsDescri = []
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   Inicio = .F.
   GOTO TOP
   TotImp911= 0
   TotImp912= 0
   TotImp91 = 0
   TotImp92 = 0
   TotImp93 = 0
   TotImp95 = 0
   TotImp97 = 0
   NumPag   = 0
  *DO WHILE ! EOF() .AND. ! Cancelar
      TotQui911= 0
      TotQui912= 0
      TotQui91 = 0
      TotQui92 = 0
      TotQui93 = 0
      TotQui95 = 0
      TotQui97 = 0
      Quiebre  = LEFT(CodRef,1)
      FOR ii= 1 TO 10
          Import911= 0
          Import912= 0
          Import91 = 0
          Import92 = 0
          Import93 = 0
          Import95 = 0
          Import97 = 0
          FOR jj= 1 TO 10
              IF !EMPTY(vTpoGto(ii,jJ))
                 Quiebre  = vTpoGto(ii,jJ)
                 SEEK Quiebre
                 DO WHILE ! EOF() .AND. CodRef = Quiebre .AND. ! Cancelar
                    LsCodRef = CodRef
                    DO Calculo
                    Cancelar = INKEY() = Escape
                 ENDDO
              ENDIF
          ENDFOR
          LsDesCri = vDesGto(iI)
          DO LinImp
      ENDFOR
      IF ! Cancelar
         DO Costeo    && que fintero
         DO TotImp1
      ENDIF
  *ENDDO
  *IF ! Cancelar
  *   DO TotImp2
  *ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
RETURN
*****************
PROCEDURE Calculo
*****************
DO WHILE ! EOF() .AND. CodRef = LsCodRef
   IF XiCodMon = 1
      nImport = - HbeNac + DbeNac
   ELSE
      nImport = - HbeExt + DbeExt
   ENDIF
   DO CASE
      CASE Codcta = "911"
         Import911 = Import911 + nImport
      CASE Codcta = "912"
         IF !INLIST(CodRef,"06")
            Import912 = Import912 + nImport
         ENDIF
      CASE Codcta = "91"
         Import92 = Import92 + nImport
      CASE Codcta = "92"
         Import92 = Import92 + nImport
      CASE Codcta = "93"
         Import93 = Import93 + nImport
      CASE Codcta = "95"
         Import95 = Import95 + nImport
      CASE Codcta = "97"
         Import97 = Import97 + nImport
   ENDCASE
   SKIP
ENDDO
RETURN
****************
PROCEDURE LinImp
****************
DO ResetPag
NumLin = PROW() + 1
Total1 = Import911+Import912+Import91 +  Import92
Total  = Total1 + Import93 +  Import95 + Import97

@ NumLin,1   SAY LsDescri PICT "@S30"
@ NumLin,36  SAY PICNUM(Import911)
@ NumLin,54  SAY PICNUM(Import912)
@ NumLin,72  SAY PICNUM(Import92)
@ NumLin,90  SAY PICNUM(Import93)
@ NumLin,108 SAY PICNUM(Import95)
@ NumLin,126 SAY PICNUM(Import97)
@ NumLin,144 SAY PICNUM(Total)

TotImp911= TotImp911+ Import911
TotImp912= TotImp912+ Import912
TotImp91 = TotImp91 + Import91
TotImp91 = TotImp91 + Import91
TotImp92 = TotImp92 + Import92
TotImp93 = TotImp93 + Import93
TotImp95 = TotImp95 + Import95
TotImp97 = TotImp97 + Import97


TotQui911= TotQui911+ Import911
TotQui912= TotQui912+ Import912
TotQui91 = TotQui91 + Import91
TotQui92 = TotQui92 + Import92
TotQui93 = TotQui93 + Import93
TotQui95 = TotQui95 + Import95
TotQui97 = TotQui97 + Import97
RETURN

*****************
PROCEDURE TotImp1
*****************
DO ResetPag
Total1 = TotQui91 +  TotQui92 + TotQui911 +TotQui912
Total  = Total1 + TotQui93 +  TotQui95 + TotQui97

NumLin = PROW() + 1
@ NumLin,36  SAY "-----------------"
@ NumLin,54  SAY "-----------------"
@ NumLin,72  SAY "-----------------"
@ NumLin,90  SAY "-----------------"
@ NumLin,108 SAY "-----------------"
@ NumLin,126 SAY "-----------------"
@ NumLin,144 SAY "-----------------"
NumLin = PROW() + 1
*@ NumLin,16  SAY "* Total "+Quiebre+" ......"
@ NumLin,36  SAY PICNUM(TotQui911)
@ NumLin,54  SAY PICNUM(TotQui912)
@ NumLin,72  SAY PICNUM(TotQui92)
@ NumLin,90  SAY PICNUM(TotQui93)
@ NumLin,108 SAY PICNUM(TotQui95)
@ NumLin,126 SAY PICNUM(TotQui97)
@ NumLin,144 SAY PICNUM(Total)
NumLin = PROW() + 1
@ NumLin,05  SAY ""
NumLin = PROW() + 1
@ NumLin,05  SAY " GASTO DIRECTO  :"
@ NumLin,36  SAY PICNUM(vCosto(1))
@ NumLin,54  SAY PICNUM(vCosto(4))

NumLin = PROW() + 1
@ Numlin,05  SAY " GASTO INDIRECTO:"
@ NumLin,36  SAY PICNUM(vCosto(2))
@ NumLin,54  SAY PICNUM(vCosto(5))
NumLin = PROW() + 1
@ NumLin,05  SAY " COSTO TOTAL    :"
@ NumLin,36  SAY PICNUM(vCosto(3))
@ NumLin,54  SAY PICNUM(vCosto(6))
NumLin = PROW() + 1
@ Numlin,05  SAY " TOTAL PRODUCTO INTERMEDIO:"
=SEEK(vCodMat(1),"MATG")
NumLin = PROW() + 1
@ Numlin,05  SAY LEFT(MATG->DESMAT,3)+" EN "+MATG->UndStk
@ NumLin,36  SAY PICNUM(vCantid(1))
@ NumLin,54  SAY PICNUM(vCantid(2))
@ Numlin,05  SAY " TOTAL PRODUCTO TERMINADO :"
=SEEK(vCodMat(3),"MATG")
NumLin = PROW() + 1
@ Numlin,05  SAY LEFT(MATG->DESMAT,3)+" EN "+MATG->UndStk
@ NumLin,54  SAY PICNUM(vCantid(3))
NumLin = PROW() + 1
@ NumLin,05  SAY " COSTO UNITARIO :"
@ NumLin,36  SAY PICNUM2(vCostoU(1))
@ NumLin,54  SAY PICNUM2(vCostoU(2))
RETURN
*****************
PROCEDURE COSTEO
*****************
** materiales a costear **
STORE SPACE(LEN(MATG->CodMat)) TO vCodMat
vCodmat(1) = "002001  " && Intermedio
vCodMat(2) = "002001  " && Intermedio
vCodMat(3) = "004001  " && Terminado
sCodFam = LEFT(vCodMat(1),LEN(FAMI->CodFam))
=SEEK("01"+sCodFam,"DIST")
LfPorCen1= DIST->Distri
sCodFam = LEFT(vCodMat(3),LEN(FAMI->CodFam))
=SEEK("02"+sCodFam,"DIST")
LfPorCen2= DIST->Distri
** Parche ... estoy apurado
LfPorcen3= 70
LfPorcen4= 30
** FUSION     **
vCosto(1)   = TotQui911*LfPorCen1/100
vCosto(2)   = (TotQui92 + TotQui93 + TotQui95 + TotQui97)*LfPorCen3/100
vCosto(3) =  vCosto(1) + vCosto(2)
** DISOLUCION **
vCosto(4)   = TotQui912*LfPorCen2/100
vCosto(5)   = (TotQui92 + TotQui93 + TotQui95 + TotQui97)*LfPorCen4/100
vCosto(6)   = vCosto(4) + vCosto(5)
** CANTIDADES PRODUCIDAS POR PRODUCCION - COSTO UNITARIO **
LsCodMov ="100"
LcTipMov ="I"
FOR K = 1 TO 3
    LsCodMat = vCodMat(K)
    LfCanPrd = 0
    SEEK LsCodMat
    SELECT ARMOV
    SEEK GsSubAlm+LsCodMat+DTOC(LdFchDocD,1)
    IF ! FOUND()
       IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
          GOTO RECNO(0)
       ENDIF
    ENDIF
    NumEle = 0
    DO CASE
       CASE (LsCodMat="002" AND k = 1) .OR. LsCodmat="004"
            LcTipMov = "I"
       OTHER
            LcTipMov = "S"
    ENDCASE
    DO WHILE (SubAlm+CodMat = GsSubAlm+LsCodMat) ;
           .AND.  (FchDoc <= LdFchDocH) .AND. ! EOF()
       IF CodMov = LsCodMov
          Ingresos = ARMOV->TipMov $ "RID"
          LfCanDes = ARMOV->CanDes
          NumEle   = NumEle   + 1
          IF ARMOV->Factor > 1
             LfCanDes = ARMOV->CanDes * ARMOV->Factor
          ENDIF
          IF TipMov = LcTipMov
             LfCanPrd = LfCanPrd + LfCandes
          ENDIF
       ENDIF
       SKIP
    ENDDO
    vCantid(k) = LfCanPrd
ENDFOR
vCosToU(1) = vCosto(3)/vCantid(1)
vCostoU(2) = (vCosto(6) + vCantid(2)*vCostoU(1))/vCantid(3)
RETURN
*****************
PROCEDURE TotImp2
*****************
DO ResetPag
NumLin = PROW() + 2
Total1 = TotImp91 +  TotImp92 + TotImp911+  TotImp912
Total  = Total1 + TotImp93 +  TotImp95 + TotImp97

@ NumLin,16  SAY "* Total General.."
@ NumLin,36  SAY PICNUM(TotImp911)
@ NumLin,54  SAY PICNUM(TotImp912)
@ NumLin,72  SAY PICNUM(TotImp92)
@ NumLin,90  SAY PICNUM(TotImp93)
@ NumLin,108 SAY PICNUM(TotImp95)
@ NumLin,126 SAY PICNUM(TotImp97)
@ NumLin,144 SAY PICNUM(Total)
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. Inicio
   Inicio = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
   RETURN TRANSF(-Valor,"99,999,999,999.99")+"-"
ELSE
   RETURN TRANSF( Valor,"99,999,999,999.99")+" "
ENDIF
****************
PROCEDURE PICNUM2
****************
PARAMETER Valor
IF Valor<0
   RETURN TRANSF(-Valor,"999,999,999.9999")+"-"
ELSE
   RETURN TRANSF( Valor,"999,999,999.9999")+" "
ENDIF
