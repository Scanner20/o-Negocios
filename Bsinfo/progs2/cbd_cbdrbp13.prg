********************************************************************************
* Progrma       : CBDRBp13.PRG                                                 *
* Objeto        : Analisis Clase 9 Por Tipo Gasto VS Presupuesto               *
* Creaci¢n      : 12/05/97 VETT                                                *
* Actualizaci¢n : 10/10/2009 VETT = o-Negocios AplVfp                          *
********************************************************************************
*** Abrimos Bases ****
DIMENSION vCLFGTO(10)
vCLFGTO(01) = "000-099  ESTABLO - ALIMENTO GANADO Y OTROS"
vCLFGTO(02) = "100-199  PLANTA  - INSUMOS                "
vCLFGTO(03) = "200-299  PLANTA  - ENVASES                "
vCLFGTO(04) = "300-399  GASTOS DE PERSONAL               "
vCLFGTO(05) = "400-429  GASTOS DE PROMOCION Y PROPAGANDA "
vCLFGTO(06) = "430-499  GASTOS GENERALES                 "
vCLFGTO(07) = "                                          "
vCLFGTO(08) = "                                          "
vCLFGTO(09) = "                                          "
vCLFGTO(10) = "                                          "


sele 3
use cbdmctas order CTAS01 alias CTAS
if !used(3)
    close data
    return
endif

sele 2
use cbdacmct order acct02 alias ACCT
if !used(2)
    close data
    return
endif
sele 1
use cbdmauxi order AUXI01 alias AUXI
if !used(1)
    close data
    return
endif
SELE 0
USE CBDMPRES ORDER PRES03 ALIAS PRES
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

SELE 0
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANALISIS CLASE 9 POR TIPO DE GASTO VS PRESUPUESTO"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
XiMesIni=1
XiMesFin=_Mes
XiNroDig=1
XiNroDec=2
XfPorCen=100

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE MES  : "
@ 12,24 SAY "HASTA MES  : "
@ 13,24 SAY "PORCENTAJE : "
**@ 14,24 SAY "DECIMALES  : "
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
      CASE i = 4
         @ 13,38 GET XfPorCen PICT "999.99" RANGE 1,999
         READ
         UltTecla = LASTKEY()
**       VecOpc(2)="4"
**       VecOpc(3)="8"
**       VecOpc(4)="8 (S¢lo Totales)"
**       XiNroDig= Elige(1,13,38,4)
**    CASE i = 5
**       @ 14,38 GET XiNroDec   PICTURE "9" RANGE 0,2
**       READ
**       UltTecla = LASTKEY()
**       @ 14,38 SAY XiNroDec   PICTURE "9"
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 4 , i + 1, 4 )

      CASE UltTecla = Enter
         IF  i < 4
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
ArcTmp  = PathUser+SYS(3)
VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"
@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11

ArcTmp2 = PATHUSER+SYS(3)
SELE 0
CREATE TABLE (ArcTmp2) (CodCta c(LEN(ACCT.COdCta)),CodREf c(LEN(ACCT.CodRef)),;
                       V01 n(14,4),V02 n(14,4),v03 n(14,4),v04 n(14,4),;
                       v05 n(14,4),v06 n(14,4),v07 n(14,4),v08 n(14,4),;
                       v09 n(14,4),v10 n(14,4),Nivel C(3) )
USE (ArcTmp2) ALIAS TEMPO EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
INDEX ON CODCTA+CODREF TAG TEMP01
INDEX ON CODCTA+NIVEL+CODREF TAG TEMP02
SET ORDER TO TEMP01
**
SELECT ACCT
XFOR1  =[(LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0]
Xwhile1=[CodCta="9"]
SEEK "9"
IF XiCodMon = 1
   COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 WHILE CodCta="9"
ELSE
   COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=8 .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 WHILE CodCta="9"
ENDIF


*DO CASE
*   CASE XiNroDig = 1
*      DO IMP2D
*   OTHER
       DO IMP5D
*ENDCASE
CLOSE DATA
***************
PROCEDURE IMP2D
***************

SELECT 0
USE &ArcTmp
INDEX ON CODREF+CODCTA TO  &ArcTmp
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

Ancho = 162
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 66 - 8
IniImp  = _PRN3
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "An lisis Clase 9 Por Tipo Gasto"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
En4 = ""
En5 = ""
En6 = "---- ------------------------------ ----------------------------------------------------- ----------------- ----------------- ----------------- -----------------"
En7 = "TIPO                                    AGRICOLA           ESTABLO           PLANTA         ADMINISTRACION       VENTAS          FINANCIEROS         T O T A L   "
En8 = "GAST  D E S C R I P C I O N                91                92                93                 94               95                97                          "
En9 = "---- ------------------------------ ----------------- ----------------- ----------------- ----------------- ----------------- ----------------- -----------------"

Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
Import97 = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   Inicio = .F.
   GOTO TOP
   TotImp91 = 0
   TotImp92 = 0
   TotImp93 = 0
   TotImp94 = 0
   TotImp95 = 0
   TotImp97 = 0
   NumPag   = 0
   DO WHILE ! EOF() .AND. ! Cancelar
      TotQui91 = 0
      TotQui92 = 0
      TotQui93 = 0
      TotQui94 = 0
      TotQui95 = 0
      TotQui96 = 0
      TotQui97 = 0
      Quiebre  = LEFT(CodRef,1)
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodRef,1) .AND. ! Cancelar
         LsCodRef = CodRef
         DO CaLCULO
         DO LinImp
         Cancelar = INKEY() = Escape
      ENDDO
      IF ! Cancelar
         DO TotImp1
      ENDIF
   ENDDO
   IF ! Cancelar
      DO TotImp2
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
RETURN


*****************
PROCEDURE Calculo
*****************
Import91 = 0
Import92 = 0
Import93 = 0
Import94 = 0
Import95 = 0
Import96 = 0
Import97 = 0
DO WHILE ! EOF() .AND. CodRef = LsCodRef
   IF XiCodMon = 1
      nImport = - HbeNac + DbeNac
   ELSE
      nImport = - HbeExt + DbeExt
   ENDIF

   DO CASE
      CASE Codcta = "91"
         Import91 = Import91 + nImport
      CASE Codcta = "92"
         Import92 = Import92 + nImport
      CASE Codcta = "93"
         Import93 = Import93 + nImport
      CASE Codcta = "94"
         Import94 = Import94 + nImport
      CASE Codcta = "95"
         Import95 = Import95 + nImport
      CASE Codcta = "96"
         Import96 = Import96 + nImport
      CASE Codcta = "97"
         Import97 = Import97 + nImport
   ENDCASE

   SKIP
ENDDO

TotImp91 = TotImp91 + Import91
TotImp92 = TotImp92 + Import92
TotImp93 = TotImp93 + Import93
TotImp94 = TotImp94 + Import94
TotImp95 = TotImp95 + Import95
TotImp97 = TotImp97 + Import97


TotQui91 = TotQui91 + Import91
TotQui92 = TotQui92 + Import92
TotQui93 = TotQui93 + Import93
TotQui94 = TotQui94 + Import94
TotQui95 = TotQui95 + Import95
TotQui97 = TotQui97 + Import97

RETURN

****************
PROCEDURE LinImp
****************
=SEEK("04 "+LsCodRef,"AUXI")
DO ResetPag
NumLin = PROW() + 1
Total = Import91 +Import92 +Import93 +  Import94 + Import95 + Import97

@ NumLin,1  SAY LsCodRef      PICT "@S3"
@ NumLin,6  SAY AUXI->NomAux  PICT "@S30"
@ NumLin,36  SAY PICNUM(Import91)
@ NumLin,54  SAY PICNUM(Import92)
@ NumLin,72  SAY PICNUM(Import93)
@ NumLin,90  SAY PICNUM(Import94)
@ NumLin,108 SAY PICNUM(Import95)
@ NumLin,126 SAY PICNUM(Import97)
@ NumLin,144 SAY PICNUM(Total)
RETURN

*****************
PROCEDURE TotImp1
*****************
DO ResetPag
Total  = TotQui91 +  TotQui92 + TotQui93 +TotQui94 +  TotQui95 + TotQui97

NumLin = PROW() + 1
@ NumLin,36  SAY "-----------------"
@ NumLin,54  SAY "-----------------"
@ NumLin,72  SAY "-----------------"
@ NumLin,90  SAY "-----------------"
@ NumLin,108 SAY "-----------------"
@ NumLin,126 SAY "-----------------"
@ NumLin,144 SAY "-----------------"
NumLin = PROW() + 1
@ NumLin,16  SAY "* Total "+Quiebre+" ......"
@ NumLin,36  SAY PICNUM(TotQui91)
@ NumLin,54  SAY PICNUM(TotQui92)
@ NumLin,72  SAY PICNUM(TotQui93)
@ NumLin,90  SAY PICNUM(TotQui94)
@ NumLin,108 SAY PICNUM(TotQui95)
@ NumLin,126 SAY PICNUM(TotQui97)
@ NumLin,144 SAY PICNUM(Total)
NumLin = PROW() + 1
@ NumLin,16  SAY ""
RETURN

*****************
PROCEDURE TotImp2
*****************
DO ResetPag
NumLin = PROW() + 2
Total  = TotImp91 +  TotImp92 + TotImp93 + TotImp94 +  TotImp95 + TotImp97

@ NumLin,16  SAY "* Total General.."
@ NumLin,36  SAY PICNUM(TotImp91)
@ NumLin,54  SAY PICNUM(TotImp92)
@ NumLin,72  SAY PICNUM(TotImp93)
@ NumLin,90  SAY PICNUM(TotImp94)
@ NumLin,108 SAY PICNUM(TotImp95)
@ NumLin,126 SAY PICNUM(TotImp97)
@ NumLin,144 SAY PICNUM(Total)
RETURN


******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. Inicio
   Inicio = .F.
   DO ADMMBPRN &&IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF

****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF XiNroDec>0
   sFmt = "99,999,999,999."+REPLI("9",XiNroDec)
ELSE
   sFmt = "99,999,999,999"
ENDIF
IF Valor<0
   RETURN TRANSF(-Valor,sFmt)+"-"
ELSE
   RETURN TRANSF( Valor,sFmt)+" "
ENDIF
***************
PROCEDURE IMP5D
***************
SELECT 0
USE &ArcTmp ALIAS TEMPO1
INDEX ON CODCTA+CODREF TO  &ArcTmp
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
DO Calculo1


SELE TEMPO
SET ORDER TO TEMP02
GO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF
SET RELA TO CodCta INTO CTAS,[04 ]+CodRef INTO AUXI


*** Pantalla de datos  ***

Ancho = 154
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN4+_PRN8A
xFOR   = []
xWHILE = []
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN4+_PRN8A]
sNomRep = [cbdrbp13]
DO ADMprint WITH "REPORTS"
RETURN
******************
PROCEDURE Calculo1
******************
PRIVATE K
SELE PRES
SEEK [9]
DO WHILE !EOF() AND CodCta=[9]
	ImportMM = 0
	ImportAA = 0
	XAlias = ALIAS()
	LsCodCta = CodCta
	LsCodRef = PADR(CodRef,LEN(TEMPO1.CodRef))
	CmpMes = IIF(XiCodMon=1,[IMPS],[IMPD])+TRAN(_MES,[@L ##])
	PresTot = 0
	PresAcm = 0
    LfPor = IIF(Filtro=[N],1,XfPorCen/100)
	FOR K = XiMesIni TO 12
	    Cmp1 = IIF(XiCodMon=1,[IMPS],[IMPD])+TRAN(K,[@L ##])
	    PresTot = PresTot + &Cmp1.*LfPor
	    IF K<=XiMesFin
	       PresAcm = PresAcm + &Cmp1.*LfPor
	    ENDIF
	ENDFOR
	SELE TEMPO1
	SEEK LsCodCta+LsCodRef
	IF !FOUND() AND RECNO(0)>0
	    GO RECNO(0)
	ENDIF
	DO WHILE ! EOF() .AND. CodRef = LsCodRef .AND. CodCta = LsCodCta
	   IF XiCodMon = 1
	      nImport = - HbeNac + DbeNac
	   ELSE
	      nImport = - HbeExt + DbeExt
	   ENDIF
	   ImportAA = ImportAA + nImport
	   IF  VAL(NroMes) = XiMesFin
	      ImportMM = ImportMM + nImport
	   ENDIF
	   SKIP
	ENDDO
	SELE TEMPO
	SEEK LsCodCta+LsCodRef
	IF !FOUND()
	   APPEND BLANK
	   REPLACE CodCta WITH LsCOdCta
	   REPLACE Codref WITH LsCodRef
	   REPLACE Nivel  WITH LEFT(CodRef,1)
	   IF CodCta=[93]        && Planta
	      IF CodRef<=[2]
	         REPLACE Nivel WITH [0-2]
	      ELSE
	         REPLACE Nivel WITH [3-7]
	      ENDIF
	   ENDIF
	ENDIF
	REPLACE V01 WITH V01 + ROUND(ImportMM,0)                   && Real Mes
	REPLACE V02 WITH V02 + ROUND(PRES.&CmpMes,0)*LfPor         && Presup. Mes
	REPLACE V03 WITH V03 + ABS(V01) - ABS(V02)   && Desviacion del mes
	IF V02>0
	   REPLACE V04 WITH V04 + (ABS(V01) - ABS(V02))/V02*100  && % Desviacion
	ENDIF
	REPLACE V05 WITH V05 + ROUND(ImportAA,0)     && Real Acumulado a la fecha
	REPLACE V06 WITH V06 + ROUND(PresAcm,0)      && Presup. acumulado a la fecha
	REPLACE V07 WITH V07 + ABS(V05) - ABS(V06)   && Desviacion acumulada
	IF V06>0
 	   REPLACE V08 WITH V08 + (ABS(V05) - ABS(V06))/V06*100  && % Desviac. acumulada
	ENDIF
	REPLACE V09 WITH V09 + ABS(ROUND(PresTot,0)) - ABS(V05)  && Presupuesto pendiente
    SELE PRES
    SKIP
ENDDO
*** Chequeamos los que estan en el real y no en el presupuesto ***
SELE TEMPO1
GO TOP
DO WHILE !EOF()
	ImportMM = 0
	ImportAA = 0
	XAlias = ALIAS()
	LsCodCta = CodCta
	LsCodRef = PADR(CodRef,LEN(TEMPO1.CodRef))
	LFound=SEEK(LsCodCta+LsCodRef,[TEMPO])
	
	SCAN WHILE CodCta=LsCodcta AND COdRef=LsCodRef AND !lFound
	   IF XiCodMon = 1
	      nImport = - HbeNac + DbeNac
	   ELSE
	      nImport = - HbeExt + DbeExt
	   ENDIF
	   ImportAA = ImportAA + nImport
	   IF  VAL(NroMes) = XiMesFin
	      ImportMM = ImportMM + nImport
	   ENDIF
	ENDSCAN
	IF lFound
	   SKIP
	   LOOP
	ENDIF
	SELE TEMPO
	SEEK LsCodCta+LsCodRef
	IF !FOUND()
	   APPEND BLANK
	   REPLACE CodCta WITH LsCOdCta
	   REPLACE Codref WITH LsCodRef
	   REPLACE Nivel  WITH LEFT(LsCodRef,1)
	   IF CodCta=[93]     && Planta
	      IF CodRef<=[2]
	         REPLACE Nivel WITH [0-2]
	      ELSE
	         REPLACE Nivel WITH [3-7]
	      ENDIF
	   ENDIF
	ENDIF
	REPLACE V01 WITH V01 + ROUND(ImportMM,0)     && Real Mes
	REPLACE V02 WITH 0                           && Presup. Mes
	REPLACE V03 WITH V03 + ABS(V01) - ABS(V02)   && Desviacion del mes
	IF V02>0
	   REPLACE V04 WITH V04 + (ABS(V01) - ABS(V02))/V02*100  && % Desviacion
	ENDIF
	REPLACE V05 WITH V05 + ROUND(ImportAA,0)     && Real Acumulado a la fecha
	REPLACE V06 WITH V06 + 0                     && Presup. acumulado a la fecha
	REPLACE V07 WITH V07 + ABS(V05) - ABS(V06)   && Desviacion acumulada
	IF V06>0
 	   REPLACE V08 WITH V08 + (ABS(V05) - ABS(V06))/V06*100  && % Desviac. acumulada
	ENDIF
	REPLACE V09 WITH V09 + ABS(0      ) - ABS(V05)  && Presupuesto pendiente
	SELE TEMPO1
ENDDO

SELE (XAlias)
RETURN
