********************************************************************************
* Programa      : CBDRB020.PRG                                                 *
* Objeto        : RESUMENES GASTOS SEGUN PRESUPUESTO                           *
* Autor         : VETT                                                         *
* Creaci¢n      : 20/08/94                                                     *
* Actualizaci¢n : 27/03/95                                                     *
********************************************************************************
PARAMETER _ClfAux
*** Abrimos Bases ****
DIMENSION SAC(6,5)
sele 1
use cbdmtabl order tabl01 alias TABL
if !used(1)
    close data
    return
endif
sele 2
use cbdacmct order acct01 alias ACCT
if !used(2)
    close data
    return
endif
***
sele 4
use CBDTPRES ORDER TPER01 alias TBAL
if !used(4)
    close data
    return
endif
sele 5
use CBDNPRES order NPER01 alias NBAL
if !used(5)
    close data
    return
endif
**
sele 6
use cbdmprem order prem01 alias PREM
if !used(6)
    close data
    return
endif
**
SELE 7
USE CBDMPRES ORDER PRES01 ALIAS PRES
IF ! USED(7)
   CLOSE DATA
   RETURN
ENDIF
SELE 8
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF ! USED(8)
   CLOSE DATA
   RETURN
ENDIF
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "GASTOS,COSTOS, Y PRESUPUESTOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 17,68      COLOR W/N
@  8,11 CLEAR TO 16,69
@  8,11       TO 16,69

DO LIB_MTEC WITH 16
XdMes2=12
LNMES=1
llMes=0
llMed=0
llAcMD=0
llAcMS=0
XsCodPer = '01'
XiCodMon = 1
XiTipo   = 1
XfPorCen = 100
XsCodRef = SPACE(LEN(ACCT.CodRef))
XsCodRefH= SPACE(LEN(ACCT.CodRef))
@ 10,16 SAY "Moneda : "
@ 12,16 SAY "C¢digo : "
@ 13,14 SAY "C/Costo.D: "
@ 14,14 SAY "C/Costo.H: "
@ 15,12 SAY "Porcentaje:          %"
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,25,2)
      CASE i = 2
         SELECT TABL
         XsTabla = "32"
         @ 12,25 GET XsCodPer PICTURE "99"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsCodPer = LEFT(CODIGO,2)
         ENDIF
         SEEK Xstabla+XsCodPer
         XsNombre = TABL->NomBre
         IF ! FOUND()
            GsMsgErr = "** C¢digo no registrado **"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 12,25 SAY XsCodPer+" "+LEFT(TABL->NOMBRE,30)
         SELE TBAL
      CASE i = 3
         XsClfAux =_ClfAux
         SELE AUXI
         @ 13,25 GET XsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF CBDBUSCA("AUXI")
               XsCodRef=LEFT(AUXI->CodAux,LEN(ACCT->CodRef))
               UltTecla = Enter
            ELSE
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         SEEK XsClfAux+XsCodRef
         IF !FOUND() .AND. !EMPTY(XsCodRef)
            GsMsgErr = "C¢digo de Divisionaria Inv lido"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         XsNomAux1 = AUXI->NomAux
         @ 13,25 SAY XsCodRef+" "+LEFT(XsNomAux1,30)
      CASE i = 4
         XsClfAux =_ClfAux
         SELE AUXI
         @ 14,25 GET XsCodRefH PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF CBDBUSCA("AUXI")
               XsCodRefH=LEFT(AUXI->CodAux,LEN(ACCT->CodRef))
               UltTecla = Enter
            ELSE
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         SEEK XsClfAux+XsCodRefH
         IF !FOUND() .AND. !EMPTY(XsCodRefH)
            GsMsgErr = "C¢digo de Divisionaria Inv lido"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         XsNomAux2 = AUXI->NomAux
         @ 14,25 SAY XsCodRefH+" "+LEFT(XsNomAux2,30)
     *CASE  i = 5
     *   VecOpc(1)="Configuración de presupuestos"
     *   VecOpc(2)="Configuración de E.P.G."
     *   XiTipo= Elige(1,15,25,2)
     CASE   i = 5
         @ 15,25 GET XfPorCen RANGE 1,1000 PICT "9999.999"
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 5)
      CASE UltTecla = Abajo
         i = IIF( i< 1 , i + 1, 5 )
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
   RETURN
ENDIF
*** Pantalla de datos  ***
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
DO CASE
   CASE XiTipo=1
      DO SegunCPRE
   CASE XiTipo=2
      DO SegunEPG
ENDCASE
*******************
PROCEDURE SegunCPRE && Según configuración de presupuestos.
*******************
STORE 0 TO XfPreRefM,XfCbdRefM,XfPreRefA,XfCbdREfA,XfPreRefP
XsCodRefH = TRIM(XsCodRefH)+CHR(255)
IF EMPTY(XsCodRef)
   TstImp = [.T.]
ELSE
   TstImp = [CodRef<=XsCodRefH]
ENDIF
m.CalcPorCen=.T.
IF !Carga()
    CLOSE DATA
    RETURN
ENDIF
m.CalcPorCen=.F.
IF ! CARGA()
   CLOSE DATA
   RETURN
ENDIF
SELECT TBAL
SEEK XsCodPer
IF ! REC_LOCK(5)
   CLOSE DATA
   RETURN
ENDIF
UNLOCK ALL
**
Ancho = 177
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN4+_prn8a
Tit_SIZQ = _Prn6a+_Prn7a+TRIM(GsNomCia)+_prn7b+_Prn6b
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = TIME()
Titulo   = []
SubTitulo= ""

En1 = TRIM(XsNomBre)
En2 = "REPORTE EN " +IIF(XiCodMon=1,[NUEVOS SOLES],[DOLARES AMERICANOS])
En3 = "Al "+TRAN(XfPorCen,[999.999])+[ %]
En4 = "AL "+STR(DAY(GdFecha),2)+" de "+Mes(_MES,3)+" de "+str(_ano,4)
En5 =[]
IF XsCodRef = XsCodRefH
   En5 = IIF(!EMPTY(XsCodRef),"C/COSTO      :"+XsCodRef+" "+LEFT(AUXI->NomAux,25),"")
ELSE
   IF !EMPTY(XsCodRef)
     En5 = "DESDE C/COSTO  :"+XsCodRef+" "+LEFT(XsNomAux1,25)+"  HASTA C/COSTO  :"+XsCodRefH+" "+LEFT(XsNomAux2,25)
   ENDIF
ENDIF
En6 = "==================================== ==================================================================================================================================== ======="
En7 = "                                                           M E S    A C T U A L                                     A C U M U L A D O                         PRESUPUESTO        "
En8 = "PCGR    PRESTACIONES DE                   REAL       %   PRESUPUESTO    %     DESVIACION    %          REAL     %    PRESUPUESTO   %      DESVIACION    %      PENDIENTE    %    "
En9 = "==================================== =========================================================== =========================================================== ============ ======="
*==================================== ==================================================================================================================================== ======="
*                                                           M E S    A C T U A L                                     A C U M U L A D O                         PRESUPUESTO        "
*PCGR    PRESTACIONES DE                   REAL       %   PRESUPUESTO    %     DESVIACION    %          REAL     %    PRESUPUESTO   %      DESVIACION    %      PENDIENTE    %    "
*==================================== =========================================================== =========================================================== ============ ======="
*XXXXXXXXX0XXXXXXXXX0XXXXXXXXX0XXXXXX 999,999,999 999.99- 999,999,999 999.99- 999,999,999 999.99  999,999,999 999.99- 999,999,999 999.99- 999,999,999 999.99-  999,999,999 999.99
*0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789-123456789-1234567890
*0         1         2         3         4         5         6         7         8         9         100       1         2         3         4         5         6         7

Texto1 = PADL("A "+Mes(_Mes,3),20)
Texto2 = PADL("A "+Mes(iif(_Mes>0,_mes-1,0),3),20)
Cancelar = .F.
SELECT TBAL
Pos1 = 50
Pos2 = 71
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   SEEK XsCodPer
   Inicio = .T.
   NumPag  = 0
   STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD,TO1M1,TO4M1,TGACS ,LFMESS
   STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD,TO1M2,TO4M2,XSMESS,LFMACS
   STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD,TO2M1,TO5M2,XSMACS,LFMESD
   STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD,TO2M2,TGME1,XSMESD
   STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD,TO3M1,TGME2,XSMACD
   STORE 0 TO TGME1,TGMES,TGME2,SGACD,TO3M2,TGACD,LFMACD
   STORE 0 TO SAC
   DO WHILE ! EOF() .AND. Rubro = XsCodPer
      DO ResetPag
      NumLin = PROW() + 1
      DO LinImp1
      SKIP
   ENDDO
   NumLin = PROW() + 1
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN

*****************
PROCEDURE LinImp1
*****************
Separa = 0
DO LinImp
RETURN

****************
PROCEDURE LinImp
****************
@ NumLin,Separa SAY LEFT(Glosa,35)
DO CASE
   CASE NOTA = "R1"
      STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD
      FOR I = 1 TO 5
        STORE 0 TO SAC(1,I)
      NEXT
   CASE NOTA = "R2"
      STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD
      FOR I = 1 TO 5
        STORE 0 TO SAC(2,I)
      NEXT
   CASE NOTA = "R3"
      STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD
      FOR I = 1 TO 5
        STORE 0 TO SAC(3,I)
      NEXT
   CASE NOTA = "R4"
      STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD
      FOR I = 1 TO 5
        STORE 0 TO SAC(4,I)
      NEXT
   CASE NOTA = "R5"
      STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD
      FOR I = 1 TO 5
        STORE 0 TO SAC(5,I)
      NEXT
   CASE NOTA = "RS"
      @ NumLin,37  SAY "-----------"
      @ NumLin,49  SAY "-------"
      @ NumLin,57  SAY "-----------"
      @ NumLin,69  SAY "-------"
      @ NumLin,77  SAY "-----------"
    * @ NUmlin,89  SAY "-------"
      @ NumLin,97  SAY "-----------"
      @ NumLin,109 SAY "-------"
      @ NumLin,117 SAY "-----------"
      @ NumLin,129 SAY "-------"
      @ NumLin,137 SAY "-----------"
      @ NumLin,149 SAY "-------"
      @ NumLin,158 SAY "-----------"
      @ NumLin,170 SAY "-------"
   CASE NOTA = "RD"
      @ NumLin,37  SAY "==========="
      @ NumLin,49  SAY "======="
      @ NumLin,57  SAY "==========="
      @ NumLin,69  SAY "======="
      @ NumLin,77  SAY "==========="
    * @ NUmlin,89  SAY "======="
      @ NumLin,97  SAY "==========="
      @ NumLin,109 SAY "======="
      @ NumLin,117 SAY "==========="
      @ NumLin,129 SAY "======="
      @ NumLin,137 SAY "==========="
      @ NumLin,149 SAY "======="
      @ NumLin,158 SAY "==========="
      @ NumLin,170 SAY "======="

   CASE NOTA = "L1" .AND. Separa = 0
      LfIMport = 0
      TOT = 0
      FOR I = 1 TO 5
        DO CASE
           CASE I = 1
              LfImport = SAC[1,I]
              LfImpTot = IIF(XiCodMon=1,TO1M1,TO1M2)
              @ Numlin,37 SAY PICNUM1(LfImpTot)
              @ NumLin,49 SAY IIF(XfCbdRefM#0,PICPORC(LfImpTot/XfCbdRefM*100),0)
              @ NumLin,57 SAY PICNUM1(LfImport)
              @ NumLin,69 SAY IIF(XfPreRefM#0,PICPORC(LfImport/XfPreRefM*100),0)
           CASE I= 2
              LfImport = SAC[1,I]
              LfImpTot = IIF(XiCodMon=1,S1ACS,S1ACD)
              @ NumLin,77  SAY PICNUM1(LfImport)
              @ Numlin,97  SAY picnum1(LfImpTot)
              @ NumLin,109 SAY IIF(XfCbdRefA#0,picporc(LfImpTot/XfCbdRefA*100),0)
           CASE I = 3
              LfImport = SAC[1,I]
              @ NumLin,117 SAY PICNUM1(LfImport)
              @ NumLin,129 SAY IIF(XfPreRefA#0,PicPorc(LfIMport/XfPreRefA*100),0)
           CASE I= 4
              LfImport = SAC[1,I]
              @ NumLin,137 SAY PICNUM1(LfImport)
           CASE I = 5
              LfImport = SAC[1,I]
              @ NumLin,158 SAY PICNUM1(LfImport)
              @ NumLin,170 SAY PICPorc(LfImport/XfPreRefP*100)
        ENDCASE
        TOT      = TOT + SAC[1,I]
        SAC[1,I] = 0
      NEXT
      STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD
   CASE NOTA = "L2" .AND. Separa = 0
      LfIMport = 0
      TOT = 0
      FOR I = 1 TO 5
        DO CASE
           CASE I = 1
              LfImport = SAC[2,I]
              LfImpTot = IIF(XiCodMon=1,TO2M1,TO2M2)
              @ Numlin,37 SAY picnum1(LfImpTot)
              @ NumLin,49 SAY IIF(XfCbdRefM#0,PICPORC(LfImpTot/XfCbdRefM*100),0)
              @ NumLin,57 SAY PICNUM1(LfImport)
              @ NumLin,69 SAY IIF(XfPreRefM#0,PICPORC(LfImport/XfPreRefM*100),0)
           CASE I= 2
              LfImport = SAC[2,I]
              LfImpTot = IIF(XiCodMon=1,S2ACS,S2ACD)
              @ NumLin,77  SAY PICNUM1(LfImport)
              @ Numlin,97  SAY picnum1(LfImpTot)
              @ NumLin,109 SAY IIF(XfCbdRefA#0,picporc(LfImpTot/XfCbdRefA*100),0)
           CASE I = 3
              LfImport = SAC[2,I]
              @ NumLin,117 SAY PICNUM1(LfImport)
              @ NumLin,129 SAY IIF(XfPreRefA#0,PicPorc(LfIMport/XfPreRefA*100),0)
           CASE I = 4
              LfImport = SAC[2,I]
              @ NumLin,137 SAY PICNUM1(LfImport)
           CASE I = 5
              LfImport = SAC[2,I]
              @ NumLin,158 SAY PICNUM1(LfImport)
              @ NumLin,170 SAY PICPorc(LfImport/XfPreRefP*100)
        ENDCASE
        TOT      = TOT + SAC[2,I]
        SAC[2,I] = 0
      NEXT
      STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD
   CASE NOTA = "L3" .AND. Separa = 0
      LfIMport = 0
      TOT = 0
      FOR I = 1 TO 5
        DO CASE
           CASE I = 1
              LfImport = SAC[3,I]
              LfImpTot = IIF(XiCodMon=1,TO3M1,TO3M2)
              @ Numlin,37 SAY picnum1(LfImpTot)
              @ NumLin,49 SAY IIF(XfCbdRefM#0,PICPORC(LfImpTot/XfCbdRefM*100),0)
              @ NumLin,57 SAY PICNUM1(LfImport)
              @ NumLin,69 SAY IIF(XfPreRefM#0,PICPORC(LfImport/XfPreRefM*100),0)
           CASE I = 2
              LfImport = SAC[3,I]
              LfImpTot = IIF(XiCodMon=1,S3ACS,S3ACD)
              @ NumLin,77  SAY PICNUM1(LfImport)
              @ Numlin,97  SAY PICNUM1(LfImpTot)
              @ NumLin,109 SAY IIF(XfCbdRefA#0,picporc(LfImpTot/XfCbdRefA*100),0)
           CASE I = 3
              LfImport = SAC[3,I]
              @ NumLin,117 SAY PICNUM1(LfImport)
              @ NumLin,129 SAY IIF(XfPreRefA#0,PicPorc(LfIMport/XfPreRefA*100),0)

           CASE I = 4
              LfImport = SAC[3,I]
              @ NumLin,137 SAY PICNUM1(LfImport)
           CASE I = 5
              LfImport = SAC[3,I]
              @ NumLin,158 SAY PICNUM1(LfImport)
              @ NumLin,170 SAY PICPorc(LfImport/XfPreRefP*100)
        ENDCASE
        TOT      = TOT + SAC[3,I]
        SAC[3,I] = 0
      NEXT
      STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD
   CASE NOTA = "L4" .AND. Separa = 0
      LfIMport = 0
      TOT = 0
      FOR I = 1 TO 5
        DO CASE
           CASE I = 1
              LfImport = SAC[4,I]
              LfImpTot = IIF(XiCodMon=1,TO4M1,TO4M2)
              @ Numlin,37 SAY PICNUM1(LfImpTot)
              @ NumLin,49 SAY IIF(XfCbdRefM#0,PICPORC(LfImpTot/XfCbdRefM*100),0)
              @ NumLin,57 SAY PICNUM1(LfImport)
              @ NumLin,69 SAY IIF(XfPreRefM#0,PICPORC(LfImport/XfPreRefM*100),0)
           CASE I = 2
              LfImport = SAC[4,I]
              LfImpTot = IIF(XiCodMon=1,S4ACS,S4ACD)
              @ NumLin,77  SAY PICNUM1(LfImport)
              @ Numlin,97  SAY PICNUM1(LfImpTot)
              @ NumLin,109 SAY IIF(XfCbdRefA#0,picporc(LfImpTot/XfCbdRefA*100),0)
           CASE I = 3
              LfImport = SAC[4,I]
              @ NumLin,117 SAY PICNUM1(LfImport)
              @ NumLin,129 SAY IIF(XfPreRefA#0,PicPorc(LfIMport/XfPreRefA*100),0)
           CASE I = 4
              LfImport = SAC[4,I]
              @ NumLin,137 SAY PICNUM1(LfImport)
           CASE I = 5
              LfImport = SAC[4,I]
              @ NumLin,158 SAY PICNUM1(LfImport)
              @ NumLin,170 SAY PICPorc(LfImport/XfPreRefP*100)
        ENDCASE
        TOT      = TOT + SAC[4,I]
        SAC[4,I] = 0
      NEXT
      STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD
   CASE NOTA = "L5" .AND. Separa = 0
      LfIMport = 0
      TOT = 0
      FOR I = 1 TO 3
        DO CASE
           CASE I = 1
              LfImport = SAC[5,I]
              LfImpTot = IIF(XiCodMon=1,TO5M1,TO5M2)
              @ Numlin,37 SAY PICNUM1(LfImpTot)
              @ NumLin,49 SAY IIF(XfCbdRefM#0,PICPORC(LfImpTot/XfCbdRefM*100),0)
              @ NumLin,57 SAY PICNUM1(LfImport)
              @ NumLin,69 SAY IIF(XfPreRefM#0,PICPORC(LfImport/XfPreRefM*100),0)
           CASE I = 2
              LfImport = SAC[5,I]
              LfImpTot = IIF(XiCodMon=1,S5ACS,S5ACD)
              @ NumLin,77  SAY PICNUM1(LfImport)
              @ Numlin,97  SAY PICNUM1(LfImpTot)
              @ NumLin,109 SAY IIF(XfCbdRefA#0,picporc(LfImpTot/XfCbdRefA*100),0)
           CASE I = 3
              LfImport = SAC[5,I]
              @ NumLin,117 SAY PICNUM1(LfImport)
              @ NumLin,129 SAY IIF(XfPreRefA#0,PicPorc(LfIMport/XfPreRefA*100),0)
           CASE I = 4
              LfImport = SAC[5,I]
              @ NumLin,137 SAY PICNUM1(LfImport)
           CASE I = 5
              LfImport = SAC[5,I]
              @ NumLin,158 SAY PICNUM1(LfImport)
              @ NumLin,170 SAY PICPorc(LfImport/XfPreRefP*100)
        ENDCASE
        TOT      = TOT + SAC[5,I]
        SAC[5,I] = 0
      NEXT
      STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD
   CASE NOTA = "TG" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
            @ NumLin,37  SAY PICNUM1(TGME1)
            @ NumLin,49  SAY PICPORC(IIF(XfCbdRefM#0,TGME1/XfCbdRefM*100,0))
            @ Numlin,57  SAY PICNUM1(SAC[6,1])
            @ NumLin,69  SAY PICPORC(IIF(XfPreRefM#0,SAC[6,1]/XfPreRefM*100,0))
            @ NumLin,77  SAY PICNUM1(SAC[6,2])
            @ NumLin,89  SAY PICPORC(SAC[6,2]/SAC[6,1]*100)
            @ NumLin,97  SAY PICNUM1(TGACS)
            @ NumLin,109 SAY PICPorC(IIF(XfCbdRefA#0,TGACS/XfCbdRefA*100,0))
            @ Numlin,117 SAY PICNUM1(SAC[6,3])
            @ NumLin,129 SAY PICPORC(IIF(XfPreRefA#0,SAC[6,3]/XfPreRefA*100,0))
            @ Numlin,137 SAY PICNUM1(SAC[6,4])
            @ NumLin,149 SAY PICPORC(SAC[6,4]/SAC[6,3]*100)
            @ NumLin,158 SAY PICNUM1(SAC[6,5])
            @ NumLin,170 SAY PICPorc(SAC[6,5]/XfPreRefP*100)
         CASE XiCodMon=2
            @ NumLin,37  SAY PICNUM1(TGME2)
            @ NumLin,49  SAY PICPORC(IIF(XfCbdRefM#0,TGME2/XfCbdRefM*100,0))
            @ Numlin,57  SAY PICNUM1(SAC[6,1])
            @ NumLin,69  SAY PICPORC(IIF(XfPreRefM#0,SAC[6,1]/XfPreRefM*100,0))
            @ NumLin,77  SAY PICNUM1(SAC[6,2])
            @ NumLin,89  SAY PICPORC(SAC[6,2]/SAC[6,1]*100)
            @ NumLin,97  SAY PICNUM1(TGACD)
            @ NumLin,109 SAY PICPorC(IIF(XfCbdRefA#0,TGACD/XfCbdRefA*100,0))
            @ Numlin,117 SAY PICNUM1(SAC[6,3])
            @ NumLin,129 SAY PICPORC(IIF(XfPreRefA#0,SAC[6,3]/XfPreRefA*100,0))
            @ Numlin,137 SAY PICNUM1(SAC[6,4])
            @ NumLin,149 SAY PICPORC(SAC[6,4]/SAC[6,3]*100)
            @ NumLin,158 SAY PICNUM1(SAC[6,5])
            @ NumLin,170 SAY PICPorc(SAC[6,5]/XfPreRefP*100)
      ENDCASE
      STORE 0 TO TGME1,SGMES,TGME2,SGACD

      TOT = 0
      FOR I = 1 TO 5
       *@ NumLin,33-17+I*17   SAY PICNUM(SAC[6,I])
        TOT      = TOT + SAC[6,I]
        SAC[6,I] = 0
      NEXT
   CASE ! EMPTY(Nota) .AND. Separa = 0
     DO CALCULO
     I=0    && 1
     J=_MES
     STORE 0 TO XSMACS,XSMACD
     DO WHILE I<=J    && Acumulado a la fecha
        VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
        VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
        ************
        S1ACS=S1ACS+&VAR1
        S2ACS=S2ACS+&VAR1
        S3ACS=S3ACS+&VAR1
        S4ACS=S4ACS+&VAR1
        S5ACS=S5ACS+&VAR1
        TGACS=TGACS+&VAR1
        ************
        S1ACD=S1ACD+&VAR2
        S2ACD=S2ACD+&VAR2
        S3ACD=S3ACD+&VAR2
        S4ACD=S4ACD+&VAR2
        S5ACD=S5ACD+&VAR2
        TGACD=TGACD+&VAR2
        **
        XSMACS = XSMACS + &VAR1
        XSMACD = XSMACD + &VAR2
        I=I+1
     ENDDO
     **
     XSMESS=("MESS"+TRANSF(_Mes,"@L ##") )
     XSMESS=&XSMESS
     XSMESD=("MESD"+TRANSF(_Mes,"@L ##") )
     XSMESD=&XSMESD

     ** Presupuesto **

     STORE 0 TO XfPreMes,XfPreAcm,XfPreTot
     TOT = 0
     Campo3 = "PRESOL"+TRANS(_MES,"@L ##")
     Campo4 = "PREUSA"+TRANS(_MES,"@L ##")
     XfPreMes = IIF(XiCodMon=1,EVALUATE(Campo3),EVALUATE(Campo4))
     XfPreAcm = PreAcu
     XfPreTot = IIF(XiCodMon=1,PreSol,PreDol)
     LnF = IIF(TBAL.Saldo=[-],-1,1)
     XfPrePen = (ABS(ABS(XfPreTot) - ABS(IIF(XiCodMon=1,XSMACS,XSMACD))))*Lnf
     XfImpMes = IIF(XiCOdMon=1,XsMesS,XsMesD)
     XfDifMes = (XfIMpMes-XfPreMes)
     XfImpAcm = IIF(XiCodMon=1,XsMacS,XsMacD)
     XfDifAcm = (XfImpAcm - XfPreAcm)
     FOR I = 1 TO 5
        DO CASE
           CASE I = 1
               Campo = XfPreMes
           CASE I = 2
               Campo = XfDifMes
           CASE I = 3
               Campo = XfPreAcm
           CASE I = 4
               Campo = XfDifAcm
           CASE I = 5
               Campo = XfPrePen
        ENDCASE
        FOR Y = 1 TO 6
           SAC[Y,I] = SAC[Y,I] + Campo
        NEXT
     ENDFOR
     ********************
     DO CASE
        CASE XiCodMon=1
           @ NumLin,37  SAY PICNUM1(XSMESS)
           @ NumLin,49  SAY PICPORC(IIF(XfCbdRefM#0,XsMesS/XfCbdRefM*100,0))
           @ Numlin,57  SAY PICNUM1(XfPreMes)
           @ NumLin,69  SAY PICPORC(IIF(XfPreRefM#0,XFPreMes/XfPreRefM*100,0))
           @ NumLin,77  SAY PICNUM1(ABS(XsMesS) - ABS(XfPremes))
           @ NumLin,89  SAY PICPORC((ABS(XsMesS) - ABS(XfPremes))/XfPreMes*100)
           @ NumLin,97  SAY PICNUM1(XSMACS)
           @ NumLin,109 SAY PICPorC(IIF(XfCbdRefA#0,XsMacS/XfCbdRefA*100,0))
           @ Numlin,117 SAY PICNUM1(XfPreAcm)
           @ NumLin,129 SAY PICPORC(IIF(XfPreRefA#0,XfPreAcm/XfPreRefA*100,0))
           @ Numlin,137 SAY PICNUM1(ABS(XsMacS) - ABS(XfPreAcm))
           @ NumLin,149 SAY PICPORC((ABS(XsMacS) - ABS(XfPreAcm))/XfPreAcm*100)
           @ NumLin,158 SAY PICNUM1(XfPrePen)
           @ NumLin,170 SAY PICPorc(XfPrePen/XfPreRefP*100)
        CASE XiCodMon=2
           @ NumLin,37  SAY PICNUM1(XSMESD)
           @ NumLin,49  SAY PICPORC(IIF(XfCbdRefM#0,XsMesD/XfCbdRefM*100,0))
           @ Numlin,57  SAY PICNUM1(XfPreMes)
           @ NumLin,69  SAY PICPORC(IIF(XfPreRefM#0,XFPreMes/XfPreRefM*100,0))
           @ NumLin,77  SAy PICNUM1(ABS(XsMesD) - ABS(XfPremes))
           @ NumLin,89  SAY PICPORC((ABS(XsMesD) - ABS(XfPremes))/XfPreMes*100)
           @ NumLin,97  SAY PICNUM1(XSMACD)
           @ NumLin,109 SAY PICPorC(IIF(XfCbdRefA#0,XsMacD/XfCbdRefA*100,0))
           @ Numlin,117 SAY PICNUM1(XfPreAcm)
           @ NumLin,129 SAY PICPORC(IIF(XfPreRefA#0,XfPreAcm/XfPreRefA*100,0))
           @ Numlin,137 SAY PICNUM1(ABS(XsMacD) - ABS(XfPreAcm))
           @ NumLin,149 SAY PICPORC((ABS(XsMacD) - ABS(XfPreAcm))/XfPreAcm*100)
           @ NumLin,158 SAY PICNUM1(XfPrePen)
           @ NumLin,170 SAY PICPorc(XfPrePen/XfPreRefP*100)
     ENDCASE
     LM=TRANSF(_Mes,"@L ##")
     L1="MESS"+LM
     L2="MESD"+LM

     TO1M1=TO1M1+&L1
     TO1M2=TO1M2+&L2
     TO2M1=TO2M1+&L1
     TO2M2=TO2M2+&L2
     TO3M1=TO3M1+&L1
     TO3M2=TO3M2+&L2
     TO4M1=TO4M1+&L1
     TO4M2=TO4M2+&L2
     TO5M1=TO5M1+&L1
     TO5M2=TO5M2+&L2
     TGME1=TGME1+&L1
     TGME2=TGME2+&L2
ENDCASE
RETURN
*****************
PROCEDURE CALCULO
*****************
VS1 = 0
VS2 = 0
VD1 = 0
VD2 = 0

Campo1 = "MESS"+TRANSF(_Mes,"@L ##")
Campo2 = "MESD"+TRANSF(_Mes,"@L ##")
VS1 = EVALUATE(Campo1)
VD1 = EVALUATE(Campo2)

V1 = VS1
V2 = VS2
RETURN

*****************
PROCEDURE PICNUM1
*****************
PARAMETER Valor1
IF Valor1<0
   RETURN TRANSF(-Valor1,"@Z ######,###-")
ELSE
   RETURN TRANSF( Valor1,"@Z ######,###")
ENDIF
PROCEDURE PICPorc
*****************
PARAMETER Valor1
IF Valor1<0
   RETURN TRANSF(-Valor1,"@Z ###.##-")
ELSE
   RETURN TRANSF( Valor1,"@Z ###.##")
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
DIMENSION SOLES(14),DOLARES(14)
DIMENSION PRESOL(14),PREDOL(14)
DIMENSION XPRESOL(14),XPREDOL(14)
DIMENSION XSOLES(14),XDOLARES(14)
SELECT TBAL
IF m.CalcPorCen
   IF ! FIL_LOCK(5)
      RETURN .F.
   ENDIF
ENDIF
SEEK XsCodPer
DO WHILE Rubro = XsCodPer .AND. ! EOF()
   IF m.CalCPorCen AND XfPreRefM#0
      EXIT
   ENDIF
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
STORE 0 TO PRESOL,PREDOL,xPRESOL,xPREDOL
STORE 0 TO PACS,PACD,PTOTS,PTOTD,PMESS,PMESD
XcRubro = Rubro
XsNota  = Nota
XcSaldo = Saldo
SELECT NBAL
Llave = XcRubro+XsNota
SEEK Llave
DO WHILE ! EOF() .AND. Rubro+Nota = Llave
   DO VALORIZA
   SELECT NBAL
   SKIP
ENDDO
IF !m.CalcPorcen
   DO GRABA
ELSE
   DO PorCen
ENDIF
RETURN
******************
PROCEDURE VALORIZA
******************
XsCodCta = CodCta
XcSigno  = Signo
XcForma  = Forma
TnMes    = 0
SELECT ACCT
FOR TnMes = 0  TO _Mes
   IF EMPTY(XsCodRef)
      xLLave = STR(TnMes,2,0)+XsCodCta
   ELSE
      xLLave = STR(TnMes,2,0)+XsCodCta+TRIM(XsCodRef)
   ENDIF
   SEEK xLlave
   XS=0
   XD=0
  * IF NBAL.NoTa=[04] and nbal.codcta=[
  * set step on
  * ENDIF
   LfFac9=1
   IF TBAL.Rubro=[02] AND TBAL.NoTa=[04] and NBAL.codcta=[9]
      LfFac9 = -1
   ENDIF
   DO WHILE (NroMes+CodCta = STR(TnMes,2,0)+XsCodCta ) .AND. ! EOF() .AND. EVALUATE(TstImp)
      XS = XS + (DbeNac - Hbenac)
      XD = XD + (DbeExt - HbeExt)
      SKIP
   ENDDO
   IF XcSigno = '2' &&  AND LfFac9<>-1
      XS = - XS
      XD = - XD
   ENDIF
   SOLES(TnMes + 1 )   = SOLES(TnMes + 1 )   + XS
   DOLARES(TnMes + 1 ) = DOLARES(TnMes + 1 ) + XD
ENDFOR
** Presupuesto **
IF EMPTY(XsCodRef)
   SELE PREM
   zLlave = TRIM(XsCodCta)
   sKey = [CodCta]
ELSE
   SELE PRES
   zLlave = TRIM(XsCodCta)
   sKey = [CodCta]
ENDIF
SEEK zLlave
DO WHILE !EOF() AND &sKey. = zLlave AND EVALUATE(TsTImp)
   *
   **XcSaldo = Saldo
   LfPor = IIF(Filtro=[N],1,XfPorCen/100)
   FOR nMes = 1 TO _Mes
       Campo3="ImpS"+TRANSF(nMes,"@L ##")
       Campo4="ImpD"+TRANSF(nMes,"@L ##")
       PACS = PACS + &Campo3*LfPor  &&*IIF(XcSaldo=[+],1,-1)
       PACD = PACD + &Campo4*LfPor   &&*IIF(Xcsaldo=[+],1,-1)
   ENDFOR
   *
   FOR nMes = 1 TO 12
       Campo3="ImpS"+TRANSF(nMes,"@L ##")
       Campo4="ImpD"+TRANSF(nMes,"@L ##")
       PTOTS = PTOTS + &Campo3*LfPor  &&*IIF(XcSaldo=[+],1,-1)
       PTOTD = PTOTD + &Campo4*LfPor  &&*IIF(XcSaldo=[+],1,-1)
   ENDFOR
   *
   Campo3="ImpS"+TRANSF(_Mes,"@L ##")
   Campo4="ImpD"+TRANSF(_Mes,"@L ##")
   PMESS = PMESS + &Campo3*LfPor   &&*IIF(XcSaldo=[+],1,-1)
   PMESD = PMESD + &Campo4*LfPor   &&*IIF(XcSaldo=[+],1,-1)
   *
   SKIP
ENDDO
IF XcSigno = '2'
   PACS  = - PACS
   PACD  = - PACD
   PTOTS = -PTOTS
   PTOTD = -PTOTD
   PMESS = -PMESS
   PMESD = -PMESD
ENDIF
SELE ACCT
RETURN
***************
PROCEDURE GRABA
***************
SELECT TBAL
LNMES=0
TnMes=0
FOR TnMes = 0  TO  XDMES2
   Campo1="MesS"+TRANSF(TnMes,"@L ##")
   Campo2="MesD"+TRANSF(TnMes,"@L ##")
   REPLACE &Campo1 WITH Soles(TnMes + 1 )
   REPLACE &Campo2 WITH Dolares(TnMes + 1 )
ENDFOR
Campo3="PreSol"+TRANSF(_Mes,"@L ##")
Campo4="PreUsa"+TRANSF(_Mes,"@L ##")
REPLACE &Campo3 WITH IIF(XcSaldo=[-],-ABS(PMESS),ABS(PMESS))
REPLACE &Campo4 WITH IIF(XcSaldo=[-],-ABS(PMESD),ABS(PMESD))
REPLACE PreSol  WITH IIF(XcSaldo=[-],-ABS(PTOTS),ABS(PTOTS))
REPLACE PreDol  WITH IIF(XcSaldo=[-],-ABS(PTOTD),ABS(PTOTD))
REPLACE PreAcu  WITH IIF(XiCodMon=1,IIF(XcSaldo=[-],-ABS(PACS),ABS(PACS)),IIF(XcSaldo=[-],-ABS(PACD),ABS(PACD)))
RETURN
****************
PROCEDURE PorCen
****************
STORE 0 TO XfPreRefM,XfCbdRefM,XfPreRefA,XfCbdREfA,XfPreRefP
PRIVATE P
IF TBAL.GLoCta=[REF]
   IF XiCodMon=1
      XfPreRefM =IIF(XcSaldo=[-],-ABS(PMESS),ABS(PMESS))
      XfCbdRefM =Soles(_Mes + 1)
      XfPreRefP =IIF(XcSaldo=[-],-ABS(PTOTS),ABS(PTOTS))
   ELSE
      XfPreRefM =IIF(XcSaldo=[-],-ABS(PMESD),ABS(PMESD))
      XfCbdRefM =Dolares(_Mes+ 1)
      XfPreRefP =IIF(XcSaldo=[-],-ABS(PTOTD),ABS(PTOTD))
   ENDIF
   XfPreRefA =IIF(XiCodMon=1,IIF(XcSaldo=[-],-ABS(PACS),ABS(PACS)),IIF(XcSaldo=[-],-ABS(PACD),ABS(PACD)))
   FOR P = 0 TO _Mes
       IF XiCOdMon=1
          XFCbdRefA = XfCbdRefA + Soles(P+1)
       ELSE
          XFCbdRefA = XfCbdRefA + Dolares(P+1)
       ENDIF
   ENDfOR
   XfPreRefP = XfPreRefP - XfCbdRefA
ENDIF
