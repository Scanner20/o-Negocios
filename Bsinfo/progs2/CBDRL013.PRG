********************************************************************************
* Programa      : CBDRB022.PRG                                                 *
* Objeto        : Listado Ajustado del Costo de Ventas                         *
* Autor         : M.B.                                                         *
* Creaci¢n      : 15/01/94                                                     *
* Actualizaci¢n : 28/02/95 VETT                                                *
* Observaci¢n   : Este reporte deber¡a salir como los estados de gesti¢n       *
*                 Configurados por falta de tiempo s¢lo queda parcharlo .      *
*
********************************************************************************
*** Abrimos Bases ****
DIMENSION vCLFGTO(06)
vCLFGTO(01) = "01-09           SUB-TOTAL MATERIAS PRIMAS "
vCLFGTO(02) = "11-19           SUB-TOTAL MANO DE OBRA    "
vCLFGTO(03) = "31-39           SUB-TOTAL MATERIALES      "
vCLFGTO(03) = "20-29           SUB-TOTAL                 "
vCLFGTO(05) = "41-89           SUB-TOTAL GASTOS FABRICAC."
vCLFGTO(06) = "90-99           SUB-TOTAL OTROS GASTOS    "
XnIndEne=0.000
DIMENSION AFactor(12),AFacto1(12)
STORE 0 TO aFactor,aFacto1,nfactor1
DIMENSION SAC(6,12),vTpoCmb(13),SAJ(6,12)

sele 8
use cbdtrfin order rfin01 alias rfin
if !used(8)
    close data
    return
endif

sele 7
use cbdrpart order rpar01 alias rpart
if !used(7)
    close data
    return
endif

sele 6
use cbdtmpmi order mpmi01 alias tmpmi
if !used(6)
    close data
    return
endif

sele 5
use cbdTcost order tcst02 alias cost
if !used(5)
    close data
    return
endif

sele 4
use cbdTAJUS order AJUS02 alias AJUS
if !used(4)
    close data
    return
endif

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


*** CARGANDO EN UN VECTOR LAS CUENTAS DE AJUSTES ***
DIMENSION vCtaAju(20)
SELECT AJUS
SET ORDER TO AJUS02
GOTO TOP
MaxEle = 0
DO WHILE ! EOF()
   LsCodCta = CtaAju
   DO WHILE LsCodCta = CtaAju .AND. ! EOF()
      SKIP
   ENDDO
   MaxEle = MaxEle + 1
   IF MaxEle > ALEN(vCtaAju)
      DIMENSION vCtaAju(MaxEle + 1)
   ENDIF
   vCtaAju(MaxEle) = LsCodCta
ENDDO
SET ORDER TO AJUS03
GOTO TOP
DO WHILE ! EOF()
   LsCodCta = CtrAju
   DO WHILE LsCodCta = CtrAju .AND. ! EOF()
      SKIP
   ENDDO
   MaxEle = MaxEle + 1
   IF MaxEle > ALEN(vCtaAju)
      DIMENSION vCtaAju(MaxEle + 1)
   ENDIF
   vCtaAju(MaxEle) = LsCodCta
ENDDO
IF MaxEle > 0
   DIMENSION vCtaAju(MaxEle)
   =ASORT(vCtaAju)
ENDIF

******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "AJUSTE DEL COSTO DE VENTAS"
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
XiTipo  =1

@ 10,24 SAY "MONEDA     : "
@ 11,24 SAY "DESDE MES  : "
@ 12,24 SAY "HASTA MES  : "
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

IF ! INDICES()
  RETURN
ENDIF
IF ! INDICE1()
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
SET RELA TO CODCTA INTO AJUS
SEEK "9"
SET TALK ON
SET TALK WINDOW
IF XiCodMon = 1
   COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=5 .AND. CodCta = "9" .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 .AND. AJUS->CtaAju#CodCta  WHILE CodCta="9"
ELSE
   COPY TO &ArcTmp FOR (LEN(TRIM(CodCta))=5 .AND. CodCta = "9" .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin)) .AND. (DBENAC-HBENAC)#0 .AND. AJUS->CtaAju#CodCta  WHILE CodCta="9"
ENDIF
SET TALK OFF
*--------*
DO IMP2D
*--------*
CLOSE DATA
DELETE FILE &ArcTmp..dbf
DELETE FILE &ArcTmp..idx

***************
PROCEDURE IMP2D
***************
SELECT 0
USE &ArcTmp  ALIAS TEMPO
INDEX ON CODREF+CODCTA TO  &ArcTmp
GOTO TOP
IF EOF()
   GsMsgErr = "No Existe Registros a Listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   RETURN
ENDIF

Ancho = 130
Cancelar = .F.
Largo   = 66
LinFin  = 66 - 8
IniImp  = _PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = "COSTO DE VENTAS AJUSTADO"
SubTitulo= ""
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 =  "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En3 = "<HORA : "+TIME()
En4 = ""
En5 = "-----------------------------------  ------------- ------------- -------- ------------- ------------- ------------- -------------"
En6 = " Elementos                               Valor      Val.Ajustado  Factor      Valor         R.E.I.        R.E.I.        Ajuste   "
En7 = "                                       Historico    A¤o Anterior             Ajustado                  Mes Anterior    del Mes   "
En8 = "-----------------------------------  ------------- ------------- -------- ------------- ------------- ------------- -------------"
En9 = ""

*-----------------------------------  ------------- ------------- -------- ------------- ------------- ------------- -------------"
* Elementos                               Valor      Val.Ajustado  Factor      Valor         R.E.I.        R.E.I.        Ajuste   "
*                                       Historico    A¤o Anterior             Ajustado                  Mes Anterior    del Mes   "
*-----------------------------------  ------------- ------------- -------- ------------- ------------- ------------- -------------"
*                                     99,999,999.99 99,999,999.99  999.99  99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99
*1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*         10        2         3         4         5         6         7         8         9         100       10        20        30

Import911 = 0
Import912 = 0
Import91x = 0
Import92  = 0
XTot0     = 0
XTot0A    = 0
XTot0Ar   = 0
XTot1     = 0
XTot1A    = 0
XTot1Ar   = 0
XTot2     = 0
XTot2A    = 0
XTot2Ar   = 0
XTot8     = 0
XTot8A    = 0
XTot8Ar   = 0
XTMes0    = 0
XTMes0A   = 0
XTMes0Ar  = 0
XTMes24   = 0
XTMes24A  = 0
XTMes24Ar = 0
XTMes28   = 0
XTMes28A  = 0
XTMes28Ar = 0
XTMes23   = 0
XTMes23A  = 0
XTMes23Ar = 0
XTMes21   = 0
XTMes21A  = 0
XTMes21Ar = 0
XTMes210  = 0
XTMes210A = 0
XTMes210Ar= 0
XTMes604  = 0
XTMes604A = 0
XTMes604Ar= 0
XT1       = 0
XT1A     = 0
XT1Ar    = 0
XT2      = 0
XT2A     = 0
XT2Ar    = 0
XT3      = 0
XT3Ar    = 0
XTV      = 0
XTVA     = 0
XTVAr    = 0
XADepre  = 0
XRDepre  = 0
XADeprer = 0
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   Inicio = .F.
   GOTO TOP
   NumPag   = 0
   DO WHILE ! EOF() .AND. ! Cancelar
      Import911= 0
      Import912= 0
      Import91x= 0
      Import92 = 0
      ImporA911= 0
      ImporA912= 0
      ImporA91x= 0
      ImporA92 = 0
      TotQui911= 0
      TotQui912= 0
      TotQui91x= 0
      TotQui92 = 0
      TotQuA911= 0
      TotQuA912= 0
      TotQuA91x= 0
      TotQuA92 = 0
      Quiebre  = LEFT(CodRef,1)
      SELE TEMPO
      DO WHILE ! EOF() .AND. Quiebre  = LEFT(CodRef,1) .AND. ! Cancelar
         DO CALCULO
         SKIP
         Cancelar = INKEY() = Escape
      ENDDO
      IF ! Cancelar
         DO TotImp1
      ENDIF
   ENDDO

   *--- Materias Primas ---*
   IF XiMesFin <> XiMesIni
      DO CBDACUMH WITH '24',0, 0
         XTMes0 = XvCalc(6)
         XfImpAju = 0
         DO AJUSTE WITH "24   ",0,0
         XTMes0AA = XTMes0 + XfImpAju
         XTmes0A  = ROUND(XtMes0AA*nFactor1,2)
   ELSE
      DO CBDACUMH WITH '24',0, XiMesIni-1
         XTMes0 = XvCalc(6)
         XfImpAju = 0
         DO AJUSTE WITH "24   ",0,XiMesIni - 1
         XTMes0AA = XTMes0 + XfImpAju
         XTmes0A  = ROUND(XtMes0AA*1       ,2)
   ENDIF
   DO CBDACUM1
      *XTMes604 - XTMes604A
   DO CBDACUMA WITH '24   ',0,_Mes
      XTMes24 = XvCalc(6)
   DO CBDACUMA WITH '24801',0,_Mes
      XTMes24A= XvCalc(6)
      XTMes24 = -1*(XTMes24-XTMes24A)
      XTMes24A= XTMes24-XTMes24A
   DO CBDACUMA WITH '28102',0,_Mes
      XTMes28 = XvCalc(6)
      SELECT RPART
      SET ORDER TO RPAR01
      SEEK '28102'
      DO WHILE !EOF() .AND. CodCta='28102'
         IF Val(NroMes) <= _Mes
            XTMes0A = XTMes0A + (Rpart.ValAjt)
            XTMes0  = XTMes0-XTMes0A
            XTMes0A = XTMes0+XTMes0A
         ENDIF
         SKIP
      ENDDO

      XrMesAnt = 0
      SELECT RPART
      SET ORDER TO RPAR01
      SEEK '33'
      DO WHILE !EOF() .AND. LEFT(CodCta,2)='33'
         IF LEFT(CodCta,3)='333' .or. LEFT(CodCta,3)='336'
            IF Val(NroMes) = _Mes
              *XADepre = XADepre + (Rpart.DpAjta)
               XrDepre = XrDepre + Rpart.DpAjta - RPART.Dphisa
            ENDIF
            *** Mes anterior ***
            IF Val(NroMes) = _Mes - 1
               XrMesAnt = XrMesAnt + Rpart.DpAjta - RPART.Dphisa
            ENDIF
         ENDIF
         SKIP
      ENDDO
      XrDepre = XrDepre - XrMesAnt
   *--- Costo de Producci¢n ---*
   DO CBDACUMA WITH '23   ',0,_Mes
      XTMes23 = XvCalc(6)
   DO CBDACUMA WITH '23801',0,_Mes
      XTMes23A= XvCalc(6)
      XTMes23 = -1*(XTMes23-XTMes23A)
      XTMes23A= XTMes23-XTMes23A

   *--- Costo de Productos Terminados ---*
   IF XiMesFin<>XiMesIni
      DO CBDACUMH WITH '21',0,0
         XTMes210 = XvCalc(6)
         XfimpAju = 0
         DO AJUSTE WITH "21   ",0,0
         XTMes210AA = XTMes210 + XfImpAju
         XTmes210A  = ROUND(XtMes210AA*nFactor1,2)
   ELSE
      DO CBDACUMH WITH '21',0,XiMesIni - 1
         XTMes210 = XvCalc(6)
         XfimpAju = 0
         DO AJUSTE WITH "21   ",0,XiMesIni - 1
         XTMes210AA = XTMes210 + XfImpAju
         XTmes210A  = ROUND(XtMes210AA*1       ,2)
   ENDIF
   DO CBDACUMA WITH '21   ',0,_Mes
      XTMes21 = XvCalc(6)
   DO CBDACUMA WITH '21801',0,_Mes
      XTMes21A= XvCalc(6)
      XTMes21 = -1*(XTMes21-XTMes21A)
      XTMes21A= XTMes21-XTMes21A
      *--------
      DO LinImp
      *--------
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
RETURN

*****************
PROCEDURE Calculo
*****************
IF XiCodMon = 1
   nImport = - HbeNac + DbeNac
ELSE
   nImport = - HbeExt + DbeExt
ENDIF
DO CASE
   CASE Codcta = "911"
      Import911 = Import911 + nImport
      ImporA911 = ImporA911 + AFactor[Val[NroMes]]*nImport
   CASE Codcta = "912"
      Import912 = Import912 + nImport
      ImporA912 = ImporA912 + AFactor[Val[NroMes]]*nImport
   CASE INLIST(Codcta,"913","914")
      Import91x = Import91x + nImport
      ImporA91x = ImporA91x + AFactor[Val[NroMes]]*nImport
   CASE Codcta = "92"
      Import92 = Import92 + nImport
      ImporA911 = ImporA911 + AFactor[Val[NroMes]]*nImport
ENDCASE
RETURN

*****************
PROCEDURE TotImp1
*****************
DO ResetPag
DO CASE
   CASE Quiebre='0'
       XTot0 = Import911+Import912+Import91x+Import92
       XTot0A= ImporA911+ImporA912+ImporA91x+ImporA92
   CASE Quiebre='1'
       XTot1 = Import911+Import912+Import91x+Import92
       XTot1A= ImporA911+ImporA912+ImporA91x+ImporA92
   CASE Quiebre='3'
       XTot2 = XTot2 +Import911+Import912+Import91x+Import92
       XTot2A= XTot2A+ImporA911+ImporA912+ImporA91x+ImporA92
   CASE Quiebre='4'
       XTot2 = XTot2 +Import911+Import912+Import91x+Import92
       XTot2A= XTot2A+ImporA911+ImporA912+ImporA91x+ImporA92
   CASE Quiebre='5'
       XTot2 = XTot2 +Import911+Import912+Import91x+Import92
       XTot2A= XTot2A+ImporA911+ImporA912+ImporA91x+ImporA92
   CASE Quiebre='6'
       XTot2 = XTot2 +Import911+Import912+Import91x+Import92
       XTot2A= XTot2A+ImporA911+ImporA912+ImporA91x+ImporA92
   CASE Quiebre='8'
       XTot8 = Import911+Import912+Import91x+Import92
       XTot8A= ImporA911+ImporA912+ImporA91x+ImporA92
ENDCASE
RETURN

******************
Procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. Inicio
   Inicio = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF

****************
PROCEDURE LinImp
****************
DO ResetPag
NumLin = PROW() + 1
@ 10,1   SAY 'MATERIAS PRIMAS :  '
@ 11,1   SAY '-----------------  '
@ 12,1   SAY 'Inventario Inicial '
@ 12,38  SAY PICNUM(XTMes0)
IF XiMesFin<>XiMesIni
   @ 12,52  SAY PICNUM(XTMes0AA)
   @ 12,66  SAY nFactor1        PICT "999.999"
ELSE
  *@ 12,66  SAY 1.000           PICT "999.999"
ENDIF
@ 12,75  SAY PICNUM(XTMes0A)
         XtMes0Ar = XTmes0A - XTmes0

@ 13,1   SAY 'Compras de Materia Prima'
@ 13,38  SAY PICNUM(XTMes604)
@ 13,75  SAY PICNUM(XTMes604A)
         XtMes604Ar = XTMes604A-XTMes604
IF XiMesFin<>XiMesIni
   DO ActAcmAjt WITH "VA005",ROUND(XtMes604Ar,2),XiMesFin
ENDIF
@ 14,1   SAY 'Inv. Final Materia Prima'
@ 14,38  SAY PICNUM(XTMes24)
@ 14,75  SAY PICNUM(XTMes24A)
         XTMes24Ar = XTMes24A-XTMes24

@ 15,1   SAY 'Existencias por Recibir'
@ 15,38  SAY PICNUM(XTMes28)
@ 15,75  SAY PICNUM(XTMes28A)
         XTMes28Ar = XTMes28A-XTMes28

XT1  = XTMes0 +XTMes604 +XTMes24 +XTMes28
XT1A = XTMes0A+XTMes604A+XTMes24A+XTMes28A
XT1Ar= XTMes0Ar+XTMes604Ar+XTMes24Ar+XTMes28Ar

@ 17,38  SAY '------------- -------------          ------------- '
@ 18,1   SAY 'Consumo de Materia Prima'
@ 18,38  SAY PICNUM(XT1)
         XT1A  = round(XT1A,2)
@ 18,75  SAY PICNUM(XT1A)
         XT1Ar = XT1A-XT1

@ 19,1   SAY 'Mano de Obra'
@ 19,38  SAY PICNUM(XTot1)
         XTot1A = round(XTot1A,2)
@ 19,75  SAY PICNUM(XTot1A)
         XTot1Ar = XTot1A-XTot1

@ 20,1   SAY 'Gasto de Fabricacion'
@ 20,38  SAY PICNUM(XTot2)
         XTot2A = round(XTot2A,2)
@ 20,75  SAY PICNUM(XTot2A)
         XTot2Ar = XTot2A-XTot2

@ 21,1   SAY 'Depreciacion'
@ 21,38  SAY PICNUM(XTot8)
         XADepre = round(XRDepre+xTot8,2)
@ 21,75  SAY PICNUM(XADepre)
         Xtot8r = XADepre-Xtot8

XT2  = XT1 +XTot1 +XTot2 +XTot8
XT2A = XT1A+XTot1A+XTot2A+XADepre
XT2Ar= XT2A-XT2

@ 22,38  SAY '------------- -------------          -------------'
@ 23,1   SAY 'Costo de Produccion'
@ 23,38  SAY PICNUM(XT2)
@ 23,75  SAY PICNUM(XT2A)
@ 24,1   SAY 'Inv.por Proceso'
@ 24,38  SAY PICNUM(XTMes23)
@ 24,75  SAY PICNUM(XTMes23A)
         XTMes23Ar = XTMes23A-XTMes23

XT3  = XT2 +XTMes23
XT3A = XT2A+XTMes23A
XT3Ar= XT2Ar+XTMes23Ar

@ 25,38  SAY '------------- -------------          ------------- ------------- ------------- -------------'
@ 26,1   SAY 'Costo de Productos Terminados'
@ 26,38  SAY PICNUM(XT3)
@ 26,75  SAY PICNUM(XT3A)
@ 26,89  SAY PICNUM(XT3Ar)
@ 27,38  SAY '============= =============          ============= ============= ============= ============='

@ 32,1   SAY 'COSTO DE VENTAS : '
@ 33,1   SAY '----------------- '
@ 34,1   SAY 'Inv.Inicial Productos Terminados'
@ 34,38  SAY PICNUM(XTMes210)
IF XiMesFin<>XiMesIni
   @ 34,52  SAY PICNUM(XTMes210AA)
   @ 34,66  SAY nFactor1        PICT "999.999"
ELSE
  *@ 34,66  SAY 1.000           PICT "999.999"
ENDIF
@ 34,75  SAY PICNUM(XTMes210A)
         XTMes210Ar = XTMes210A-XTMes210
IF XiMesFin<>XiMesIni
  DO ActAcmAjt WITH "VA210",round(XTMes210Ar,2),XiMesFin
ENDIF
@ 36,1   SAY 'Costo de Produccion'
@ 36,38  SAY PICNUM(XT2)
@ 36,75  SAY PICNUM(XT2A)
@ 37,1   SAY 'Inv.Final Productos Terminados'
@ 37,38  SAY PICNUM(XTMes21)
@ 37,75  SAY PICNUM(XTMes21A)
         XTMes21Ar= XTMes21A-XTMes21
IF XiMesFin<>XiMesIni
  DO ActAcmAjt WITH "VA003",round(XTMes21Ar,2),XiMesFin
ENDIF
XTV  = XTV  + XTMes210 + XT2 + XTMes21
XTVA = XTVA + XTMes210A+ XT2A+ XTMes21A
XTVAr= XTVA - XTV

@ 38,38  SAY '------------- -------------          ------------- ------------- ------------- -------------'
@ 39,1   SAY 'Costo de Ventas'
@ 39,38  SAY PICNUM(XTV)
@ 39,75  SAY PICNUM(XTVA)
@ 39,89  SAY PICNUM(XTVAr)
IF XiMesFin<>XiMesIni
  DO ActAcmAjt WITH "VA001",ROUND(XTVAr,2),XiMesFin
ENDIF
@ 40,38  SAY '============= =============          ============= ============= ============= ============='
RETURN
*--------------*
PROCEDURE PICNUM
*--------------*
PARAMETER Valor
Valor = ROUND(Valor,2)
IF Valor<0
   RETURN TRANSF(Valor,"@Z( 9,999,999.99")
ELSE
   RETURN TRANSF(Valor,"99,999,999.99")+' '
ENDIF
*--------------*
*--------------*
FUNCTION INDICES
*--------------*
IF _Mes = 0  .OR. _Mes = 13
   RETURN .F.
ENDIF
MesAct   = _Mes
AnoAct   = _Ano
SELECT TMPMI
SEEK STR(AnoAct,4,0)+Str(MesAct,2,0)
IF ! FOUND() .or. Indice <= 0
   GsMsgErr = "No Registrado el Indice de "+ Mes(MesAct,3)+" "+STR(_Ano,4,0)
   DO LIB_MERR WITH 99
   RETURN .F.
ENDIF
aFactor(MesAct) = 1
nIndRef1        = Indice
DO WHILE MesAct > 1
   MesAct = MesAct - 1
   SEEK STR(AnoAct,4,0)+Str(MesAct,2,0)
   IF ! FOUND()
      GsMsgErr = "No Registrado el Indice de "+ Mes(MesAct,3)+" "+STR(_Ano,4,0)
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
   aFactor(MesAct) = ROUND(nIndRef1/Indice,3)
ENDDO
*** Indice del a¤o anterior ***
MesAct   = 12
AnoAct   = _Ano - 1
SEEK STR(AnoAct,4,0)+Str(MesAct,2,0)
IF ! FOUND()
   GsMsgErr = "No Registrado el Indice de Diciembre "+STR(_Ano-1,4,0)
   DO LIB_MERR WITH 99
   RETURN
ENDIF
nFactor1 = ROUND(nIndRef1/Indice,3)
*---------------------------------*

*----------------*
PROCEDURE CBDACUMA
*----------------*
PARAMETERS XsCodCta , XnMesIni , XnMesFin
PRIVATE TnMes,xLLave,xSelect
xSelect = SELECT()
IF XnMesIni < 0  .OR. XnMesFin < 0
   XnMesIni = ABS( XnMesIni )
   XnMesFin = ABS( XnMesFin )
ENDIF
SELECT ACCT
SET ORDER TO ACCT01
STORE 0 TO XvCalc
TnMes = XnMesIni
DO WHILE TnMes <= XnMesFin
   xLLave = STR(TnMes,2,0)+XsCodCta
   SEEK xLlave
   DO WHILE (NroMes+CodCta+CodRef = xLLave ) .AND. ! EOF()
      XvCalc( 4) = XvCalc( 4) + DbeNac  && Debe  Acumulado Moneda Nacional
      XvCalc( 5) = XvCalc( 5) + HbeNac  && Haber Acumulado Moneda Nacional
      SKIP
   ENDDO
   TnMes = TnMes + 1
ENDDO
*** Saldos *************************
XvCalc( 6) = XvCalc( 4) - XvCalc( 5)  && Saldo Acumulado Moneda Nacional
SET ORDER TO ACCT02
SELECT (xSelect)
RETURN
*----------------*

*----------------*
PROCEDURE CBDACUM1
*----------------*
SELECT ACCT
SET ORDER TO ACCT02
SEEK '604'
DO WHILE ! EOF() .AND. CodCta = '604  '
   IF VAL(NroMes)<=XiMesFin AND  VAL(NroMes)>=XiMesIni
      nImport = (HbeNac - DbeNac)*(-1)
      XTMes604  = XTMes604  + nImport
      XTMes604A = XTMes604A + AFactor[Val[NroMes]]*nImport
   ENDIF
   SKIP
ENDDO
SET ORDER TO ACCT02
RETURN
*----*
*--------------*
FUNCTION INDICE1
*--------------* CARGANDO INDICES DE CORRECCI¢N MES PASADO **-------**
IF _Mes = 1
   STORE nFactor1 TO AFacto1
   RETURN .T.
ENDIF
MesAct   = _Mes-1
AnoAct   = _Ano
SELECT TMPMI
SEEK STR(AnoAct,4,0)+Str(MesAct,2,0)
IF ! FOUND() .or. Indice <= 0
   GsMsgErr = "No Registrado el Indice de "+ Mes(MesAct,3)+" "+STR(_Ano,4,0)
   DO LIB_MERR WITH 99
   RETURN .F.
ENDIF
aFacto1(MesAct) = 1
nIndRef1        = Indice
DO WHILE MesAct > 1
   MesAct = MesAct - 1
   SEEK STR(AnoAct,4,0)+Str(MesAct,2,0)
   IF ! FOUND()
      GsMsgErr = "No Registrado el Indice de "+ Mes(MesAct,3)+" "+STR(_Ano,4,0)
      DO LIB_MERR WITH 99
      RETURN
   ENDIF
   aFacto1(MesAct) = ROUND(nIndRef1/Indice,3)
ENDDO
*** Indice del a¤o anterior ***
MesAct   = 12
AnoAct   = _Ano - 1
SEEK STR(AnoAct,4,0)+Str(MesAct,2,0)
IF ! FOUND()
   GsMsgErr = "No Registrado el Indice de Diciembre "+STR(_Ano-1,4,0)
   DO LIB_MERR WITH 99
   RETURN
ENDIF
xFactor1 = ROUND(nIndRef1/Indice,3)
*---------------------------------*
*******************
PROCEDURE ActAcmAjt  && Solo actualiza el ajuste acumulado al mes fin
*******************
PARAMETER _Cta,_import,_NroMes
SELE RFIN
SEEK TRANS(_NroMes,"@L ##")+_Cta
IF !FOUND()
   APPEND BLANK
   =RLOCK()
   REPLACE NroMes WITH TRANS(_NroMes,"@L ##")
   REPLACE CodRat WITH _Cta
ELSE
   =RLOCK()
ENDIF
REPLACE TIPO WITH "X"
IF XiCodMon = 1
   REPLACE ImpNac WITH _Import
ELSE
   REPLACE ImpExt WITH _Import
ENDIF
UNLOCK
RETURN
****************
PROCEDURE AJUSTE
****************
PARAMETER _Cta,mes1,mes2
SELE ACCT
SET ORDER TO ACCT01
XfImpAju = 0
FOR I=1 TO MaxEle
    IF vCtaAju(i) = TRIM(_Cta)
       DO CBDACUMD WITH vCtaAju(i),mes1,mes2
       XfImpAju = XfImpAju + XvCalc(6+INC)
    ENDIF
NEXT
RETURN
