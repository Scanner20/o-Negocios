********************************************************************************
* Programa      : CBDRESTG.PRG                                                 *
* Objeto        : ESTADOS DE GESTION GENERAL                                   *
* Autor         : J.M.                                                         *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n : 02/09/94   VETT                             - ATECO          *
********************************************************************************
*** Abrimos Bases ****
sele 2
use cbdacmct order acct01 alias ACCT
if !used(2)
    close data
    return
endif
***
sele 4
use CBDTPERN ORDER TPER01 alias TBAL
if !used(4)
    close data
    return
endif
sele 5
use cbdNPERN order NPER01 alias NBAL
if !used(5)
    close data
    return
endif

sele 6
use cbdmtabl order tabl01 alias TABL
if !used(6)
    close data
    return
endif

*SELE 7
*USE CBDMVARS ORDER VARS02 ALIAS VARS
*IF ! USED(7)
*   CLOSE DATA
*   RETURN
*ENDIF
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ESTADO DE GESTION GENERAL"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

@  9,10 FILL  TO 15,68      COLOR W/N
@  8,11 CLEAR TO 14,69
@  8,11       TO 14,69

DO LIB_MTEC WITH 16
XdMes2=_mes
LNMES=1
llMes=0
llMed=0
llAcMD=0
llAcMS=0
XsPunt=0
XfImpMes=0  && Movimiento del Mes
XfImpAcm=0  && Acumulado al mes
XfImpAma=0  && Acumulado al mes Anterior
STORE 0 TO XfRefMes,XfRefAcm,XfRefAma
XfImpTot=0
XtPorTot=0
XsCodPer = '01'
XiCodMon = 1
XiTipo   = 1
sw       = 1
@ 10,26 SAY "Moneda : "
@ 12,16 SAY "C¢digo : "
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         VecOpc(1)="NUEVOS SOLES      "
         VecOpc(2)="DOLARES AMERICANOS"
         XiCodMon= Elige(1,10,36,2)
      CASE i = 2
         SELECT TABL
         XsTabla = "31"
         @ 12,36 GET XsCodPer PICTURE "99"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            IF ! CBDBUSCA("TABL")
               LOOP
            ENDIF
            XsCodPer = LEFT(CODIGO,2)
         ENDIF
         SEEK Xstabla+XsCodPer
         @ 13,16 SAY NOMBRE
         XsNomBre = TABL->NomBre
         IF ! FOUND()
            GsMsgErr = "** C¢digo no registrado **"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)
      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 2 )
      CASE UltTecla = Enter
         IF  i < 2
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

IF ! CARGA()
   CLOSE DATA
   RETURN
ENDIF
*DO PORCEN

SELECT TBAL
SEEK XsCodPer
IF ! REC_LOCK(5)
   CLOSE DATA
   RETURN
ENDIF
UNLOCK ALL

Ancho = 103
Cancelar = .F.
Largo   = 85       && Largo de pagina
LinFin  = Largo - 6
IniImp  = _PRN4+_prn8a
Tit_SIZQ = _Prn6a+_Prn7a+TRIM(GsNomCia)+_prn7b+_Prn6b
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = TIME()
Titulo   = []
SubTitulo= ""

En1 = []
En2 = XsNombre
En3 = " "
IF XiCodMon=1
   En4 = "EN NUEVOS SOLES AL "+STR(DAY(GdFecha),2)+" de "+Mes(_MES,3)+" de "+str(_ano,4)
ELSE
   En4 = "EN DOLARES AL "+STR(DAY(GdFecha),2)+" de "+Mes(_MES,3)+" de "+str(_ano,4)
ENDIF
En5 = "======================================================================================================="
En6 = "                                                      ACUMULADO         MOVIMIENTO        ACUMULADO    "
En7 = "       DESCRIPCION                                   MES ANTERIOR       MES ACTUAL       PRESENTE MES  "
En8 = "================================================   ================  ================  ================"
En9 = " "
      *012345678901234567890123456789012345678901234567    999,999,999.99    999,999,999.99    999,999,999.99
      *0         1         2         3         4123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
      *0         1         2         3         4         5         6         7         8         9         100       1         2         3         4
Texto1 = PADL("A "+Mes(_Mes,3),20)
Texto2 = PADL("A "+Mes(iif(_Mes>0,_mes-1,0),3),20)
Cancelar = .F.
SELECT TBAL
Pos1 = 51
Pos2 = 69
Pos3 = 87
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   SEEK XsCodPer
   Inicio = .T.
   NumPag  = 0
   STORE 0 TO TGAP2,T5AP2,T4AP2,T3AP2,T2AP2,T1AP2
   STORE 0 TO TGAP1,T5AP1,T4AP1,T3AP1,T2AP1,T1AP1
   STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD,TO1M1,TO4M1,TGACS ,LFMESS
   STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD,TO1M2,TO4M2,XSMESS,LFMACS
   STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD,TO2M1,TO5M2,XSMACS,LFMESD
   STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD,TO2M2,TGME1,XSMESD
   STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD,TO3M1,TGME2,XSMACD
   STORE 0 TO TGME1,TGMES,TGME2,SGACD,TO3M2,TGACD,LFMACD
   STORE 0 TO S1AAS,S2AAS,S3AAS,S4AAS,S5AAS,TGAAS,XSMAAS  && Al mes Anterior
   STORE 0 TO S1AAD,S2AAD,S3AAD,S4AAD,S5AAD,TGAAD,XSMAAD  && Al mes Anterior
   STORE 0 TO S1AAS1,S1ACS2,S1AAD1,S1ACD2

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
@ NumLin,Separa SAY Glosa+" "+IIF(INLIST(TRIM(GloCta),"UTI","REF"),"",GloCta)
DO CASE
   CASE NOTA = "R1"
      STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD,S1AAS,S1AAD,T1AP2,T1AP1
   CASE NOTA = "R2"
      STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD,S2AAS,S2AAD,T2AP2,T2AP1
   CASE NOTA = "R3"
      STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD,S3AAS,S3AAD,T3AP2,T3AP1
   CASE NOTA = "R4"
      STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD,S4AAS,S4AAD,T4AP2,T4AP1
   CASE NOTA = "R5"
      STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD,S5AAS,S5AAD,T4AP2,T4AP1
   CASE NOTA = "RS"
      @ NumLin,Pos1  SAY REPLICATE("-",16)
      @ NumLin,Pos2  SAY REPLICATE("-",16)
      @ NumLin,Pos3  SAY REPLICATE("-",16)
   CASE NOTA = "RD"
      @ NumLin,Pos1  SAY REPLICATE("=",16)
      @ NumLin,Pos2  SAY REPLICATE("=",16)
      @ NumLin,Pos3  SAY REPLICATE("=",16)
   CASE NOTA = "L1" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
           *@ NumLin,51   SAY PICNUM1(T1AP1)
            @ NumLin,Pos1 SAY PICNUM1(S1AAS)     && Soles y Acumulado del mes anterior
           *@ NumLin,95   SAY PorAma  PICT "999.99"
            @ NumLin,Pos2 SAY PICNUM1(TO1M1)     && Soles y Movimiento Mensual
           *@ NumLin,121  SAY PorMes  PICT "999.99"
            @ NumLin,Pos3 SAY PICNUM1(S1ACS)     && Soles y Acumulado al Mes
           *@ NumLin,147  SAY PorAcm  PICT "999.99"
         CASE XiCodMon=2
           *@ NumLin,51   SAY PICNUM1(T1AP2)
            @ NumLin,Pos1 SAY PICNUM1(S1AAD)
           *@ NumLin,95   SAY PorAma  PICT "999.99"
            @ NumLin,Pos2 SAY PICNUM1(TO1M2)
           *@ NumLin,121  SAY PorMes  PICT "999.99"
            @ NumLin,Pos3 SAY PICNUM1(S1ACD)
           *@ NumLin,147  SAY PorAcm  PICT "999.99"
      ENDCASE
      STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD,S1AAS,S1AAD,T1AP1,T1AP2

   CASE NOTA = "L2" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
           *@ NumLin,51   SAY PICNUM1(T2AP1)
            @ NumLin,Pos1 SAY PICNUM1(S2AAS)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S2AAS/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO2M1)     && soles y mensual
           *@ NumLin,121  SAY PICNUM2(TO2M1/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S2ACS)     && Soles y Acumulado
           *@ NumLin,147  SAY PICNUM2(S2ACS/XfRefAcm*100)
         CASE XiCodMon=2
           *@ NumLin,51   SAY PICNUM1(T2AP2)
            @ NumLin,Pos1 SAY PICNUM1(S2AAD)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S2AAD/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO2M2)     && Dolares y mensual
           *@ NumLin,121  SAY PICNUM2(TO2M2/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S2ACD)     && Dolares y acumulado
           *@ NumLin,147  SAY PICNUM2(S2ACD/XfRefAcm*100)
      ENDCASE
      STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD,S2AAS,S2AAD,T2AP1,T2AP2

   CASE NOTA = "L3" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
           *@ NumLin,51   SAY PICNUM1(T3AP1)
            @ NumLin,Pos1 SAY PICNUM1(S3AAS)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S3AAS/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO3M1)     && soles y mensual
           *@ NumLin,121  SAY PICNUM2(TO3M1/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S3ACS)     && Soles y Acumulado
           *@ NumLin,147  SAY PICNUM2(S3ACS/XfRefAcm*100)
         CASE XiCodMon=2
           *@ NumLin,51   SAY PICNUM1(T3AP2)
            @ NumLin,Pos1 SAY PICNUM1(S3AAD)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S3AAD/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO3M2)     && Dolares y mensual
           *@ NumLin,121  SAY PICNUM2(TO3M2/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S3ACD)     && Dolares y acumulado
           *@ NumLin,147  SAY PICNUM2(S3ACD/XfRefAcm*100)
      ENDCASE
      STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD,S3AAS,S3AAD,T3AP1,T3AP2

   CASE NOTA = "L4" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
           *@ NumLin,51   SAY PICNUM1(T4AP1)
            @ NumLin,Pos1 SAY PICNUM1(S4AAS)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S4AAS/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO4M1)     && soles y mensual
           *@ NumLin,121  SAY PICNUM2(TO4M1/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S4ACS)     && Soles y Acumulado
           *@ NumLin,147  SAY PICNUM2(S4ACS/XfRefAcm*100)
         CASE XiCodMon=2
           *@ NumLin,51   SAY PICNUM1(T4AP2)
            @ NumLin,Pos1 SAY PICNUM1(S4AAD)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S4AAD/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO4M2)     && Dolares y mensual
           *@ NumLin,121  SAY PICNUM2(TO4M2/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S4ACD)     && Dolares y acumulado
           *@ NumLin,147  SAY PICNUM2(S4ACD/XfRefAcm*100)
      ENDCASE
      STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD,S4AAS,S4AAD,T4AP1,T4AP2
   CASE NOTA = "L5" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
           *@ NumLin,51   SAY PICNUM1(T5AP1)
            @ NumLin,Pos1 SAY PICNUM1(S5AAS)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S5AAS/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO5M1)     && soles y mensual
           *@ NumLin,121  SAY PICNUM2(TO5M1/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S5ACS)     && Soles y Acumulado
           *@ NumLin,147  SAY PICNUM2(S5ACS/XfRefAcm*100)
         CASE XiCodMon=2
           *@ NumLin,51   SAY PICNUM1(T5AP2)
            @ NumLin,Pos1 SAY PICNUM1(S5AAD)     && Soles y Acumulado
           *@ NumLin,95   SAY PICNUM2(S5AAD/XfRefAma*100)
            @ NumLin,Pos2 SAY PICNUM1(TO5M2)     && Dolares y mensual
           *@ NumLin,121  SAY PICNUM2(TO5M2/XfRefMes*100)
            @ NumLin,Pos3 SAY PICNUM1(S5ACD)     && Dolares y acumulado
           *@ NumLin,147  SAY PICNUM2(S5ACD/XfRefAcm*100)
      ENDCASE
      STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD,S5AAS,S5AAD,T5AP1,T5AP2
   CASE NOTA = "TG" .AND. Separa = 0
      DO CASE
         CASE XiCodMon=1
           *@ NumLin,51   SAY PICNUM1(TGAP1)
            @ NumLin,Pos1 SAY PICNUM1(TGAAS)
           *@ NumLin,95   SAY PorAma  PICT '@Z 999.99'
            @ NumLin,Pos2 SAY PICNUM1(TGME1)     && soles y mensual
           *@ NumLin,121  SAY PorMes  PICT '@Z 999.99'
            @ NumLin,Pos3 SAY PICNUM1(TGACS)     && Soles y Acumulado
           *@ NumLin,147  SAY PorAcm  PICT '@Z 999.99'
         CASE XiCodMon=2
           *@ NumLin,51   SAY PICNUM1(TGAP2)
            @ NumLin,Pos1 SAY PICNUM1(TGAAD)
           *@ NumLin,95   SAY PorAma  PICT '@Z 999.99'
            @ NumLin,Pos2 SAY PICNUM1(TGME2)     && Dolares y mensual
           *@ NumLin,121  SAY PorMes  PICT '@Z 999.99'
            @ NumLin,Pos3 SAY PICNUM1(TGACD)     && Dolares y acumulado
           *@ NumLin,147  SAY PorAcm  PICT '@Z 999.99'
      ENDCASE
      STORE 0 TO TGME1,SGMES,TGME2,SGACD,TGAAS,TGAAD,TGAP1,TGAP2

   CASE ! EMPTY(Nota) .AND. Separa = 0
     DO CALCULO
     I=0    && 1
     J=_MES
     STORE 0 TO S1APS1,S1APD1      && Apertura
     S1APS1 = MESS00
     S1APD1 = MESD00
     STORE 0 TO S1AAS1,S1AAD1
     DO WHILE I<=J-1    && Acumulado al mes Anterior
        VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
        VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
        S1AAS=S1AAS+&VAR1
        S2AAS=S2AAS+&VAR1
        S3AAS=S3AAS+&VAR1
        S4AAS=S4AAS+&VAR1
        S5AAS=S5AAS+&VAR1
        TGAAS=TGAAS+&VAR1
        ************
        S1AAD=S1AAD+&VAR2
        S2AAD=S2AAD+&VAR2
        S3AAD=S3AAD+&VAR2
        S4AAD=S4AAD+&VAR2
        S5AAD=S5AAD+&VAR2
        TGAAD=TGAAD+&VAR2
        ***
        S1AAS1=S1AAS1+&VAR1
        S1AAD1=S1AAD1+&VAR2
        I=I+1
     ENDDO
     ********************
     STORE 0 TO S1ACS2,S1ACD2,I
     DO WHILE I<=J    && Acumulado a la Fecha
        VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
        VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
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
        ***
        S1ACS2=S1ACS2+&VAR1
        S1ACD2=S1ACD2+&VAR2
        I=I+1
     ENDDO
     ********************

     XSMESS=("MESS"+TRANSF(_Mes,"@L ##") )
     XSMESS=&XSMESS                         && del Mes en Soles
     XSMACS=S1ACS                           && Acumulado a la fecha
     XSMAAS=S1AAS                           && Al mes Anterior
     XSMESD=("MESD"+TRANSF(_Mes,"@L ##") )
     XSMESD=&XSMESD
     XSMACD=S1ACD
     XSMAAD=S1AAD                           && Al mes Anterior

     DO CASE
        CASE XiCodMon=1
          *@ NumLin,51   SAY PICNUM1(S1APS1)
           @ NumLin,Pos1 SAY PICNUM1(S1AAS1)
          *@ NumLin,95   SAY PorAma     PICT '@Z 999.99'
           @ NumLin,Pos2 SAY PICNUM1(XSMESS)
          *@ NumLin,121  SAY PorMes     PICT '@Z 999.99'
           @ NumLin,Pos3 SAY PICNUM1(S1ACS2)
          *@ NumLin,147  SAY PorAcm     PICT '@Z 999.99'
        CASE XiCodMon=2
          *@ NumLin,51   SAY PICNUM1(S1APD1)
           @ NumLin,Pos1 SAY PICNUM1(S1AAD1)
          *@ NumLin,95   SAY PorAma     PICT '@Z 999.99'
           @ NumLin,Pos2 SAY PICNUM1(XSMESD)
          *@ NumLin,121  SAY PorMes     PICT '@Z 999.99'
           @ NumLin,Pos3 SAY PICNUM1(S1ACD2)
          *@ NumLin,147  SAY PorAcm     PICT '@Z 999.99'
     ENDCASE

     ************
     LM=TRANSF(_Mes,"@L ##")
     L1="MESS"+LM
     L2="MESD"+LM
     ** Totales de Apertura **
     T1AP1=T1AP1+MESS00
     T1AP2=T1AP2+MESD00
     T2AP1=T2AP1+MESS00
     T2AP2=T2AP2+MESD00
     T3AP1=T3AP1+MESS00
     T3AP2=T3AP2+MESD00
     T4AP1=T4AP1+MESS00
     T4APB=T4AP2+MESD00
     T5AP1=T5AP1+MESS00
     T5AP2=T5AP2+MESD00
     TGAP1=TGAP1+MESS00
     TGAP2=TGAP2+MESD00
     **
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
  *RETURN TRANSF(-Valor1,"@Z( ###,###,###.##")
   RETURN TRANSF(-Valor1,"@Z( ##,###,###,###")
ELSE
  *RETURN TRANSF( Valor1,"@Z ###,###,###.##")
   RETURN TRANSF( Valor1,"@Z ##,###,###,###")
ENDIF
PROCEDURE PICNUM2
*****************
PARAMETER Valor1
RETURN TRANS(Valor1,"@Z 999.99")
******************
PROCEDURE RESETPAG
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
DIMENSION XSOLES(14),XDOLARES(14)
SELECT TBAL
IF ! FIL_LOCK(5)
   RETURN .F.
ENDIF
SEEK XsCodPer
DO WHILE Rubro = XsCodPer .AND. ! EOF()
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
XsCodCta = CodCta
XcSigno  = Signo
XcForma  = Forma
TnMes    = 0
IF ! "X"$XsCodCta  .AND. ! XsCodCta="VA"  .AND. ! XsCodCta="VM"
    SELECT ACCT
    FOR TnMes = 0  TO XdMes2
       xLLave = STR(TnMes,2,0)+XsCodCta
       SEEK xLlave
       XS=0
       XD=0
       DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
          XS = XS + DbeNac - Hbenac
          XD = XD + DbeExt - HbeExt
          SKIP
       ENDDO
       IF XcSigno = '2'
          XS = - XS
          XD = - XD
       ENDIF
       SOLES(TnMes + 1  ) = SOLES(TnMes + 1)   + XS
       DOLARES(TnMes + 1) = DOLARES(TnMes + 1) + XD
    ENDFOR
ELSE
  *FOR TnMes=0  TO  XdMes2
  **   XS=0
  **   XD=0
  **   xLLave = TRANS(TnMes,"@L ##")+SUBSTR(XsCodCta,3,3)
  **   SELE VARS
  **   SEEK xLlave
  **   IF FOUND()
  **      XS = Import
  **      XD = Impusa
  **   ENDIF
  **   IF XcSigno = '2'
  **      XS = - XS
  **      XD = - XD
  **   ENDIF
  **   SOLES(TnMes + 1)  = SOLES(TnMes + 1)   + XS
  **   DOLARES(TnMes + 1)= DOLARES(TnMes + 1) + XD
  *ENDFOR
ENDIF
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
   REPLACE &Campo1 WITH Soles(TnMes   + 1)
   REPLACE &Campo2 WITH Dolares(TnMes + 1)
ENDFOR
RETURN
****************
PROCEDURE PORCEN
****************
@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11
DIMENSION SOLES(14),DOLARES(14)
DIMENSION XSOLES(14),XDOLARES(14)
lRef = .F.
SELECT TBAL
IF ! FIL_LOCK(5)
   RETURN .F.
ENDIF
SEEK XsCodPer
DO WHILE Rubro = XsCodPer .AND. ! EOF()
   DO CASE
      CASE NOTA = "RS"
      CASE NOTA = "RD"
      CASE NOTA = "L1"
         XsPunt = Recno()
         IF lRef
            XfImpAcm = XfRefAcm
            XfImpMes = XfRefMes
            XfImpAma = XfRefAma
         ENDIF
         store 0 TO zPorAcm,zPorMes,zPorAma
         SEEK XsCodPer+Str(XsNroItm,3,0)
         DO WHILE Rubro = XsCodPer .AND. ! EOF()
            IF Nota$ ['RS','RD','L1','L2','L3','L4','TG']
               EXIT
            ENDIF
            **
            I=0
            STORE 0 TO Campo1,Campo2
            DO WHILE I<=_Mes && Acumulado a la Fecha
               VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
               VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
               Campo1 = Campo1 + &Var1
               Campo2 = Campo2 + &Var2
               I=I+1
            ENDDO
            IF XiCodMon=1
               REPLACE PorAcm WITH ROUND(Campo1/XfImpAcm*100,2)
            ELSE
               REPLACE PorAcm WITH ROUND(Campo2/XfImpAcm*100,2)
            ENDIF
            zPorAcm = zPorAcm + PorAcm
            **
            I=0
            STORE 0 TO Campo1,Campo2
            DO WHILE I<=_Mes-1  && Acumulado al Mes Anterior
               VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
               VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
               Campo1 = Campo1 + &Var1
               Campo2 = Campo2 + &Var2
               I=I+1
            ENDDO
            IF XiCodMon=1
               REPLACE PorAma WITH ROUND(Campo1/XfImpAma*100,2)
            ELSE
               REPLACE PorAma WITH ROUND(Campo2/XfImpAma*100,2)
            ENDIF
            zPorAma = zPorAma + PorAma
            **
            VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
            VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
            IF XiCodMon=1
               REPLACE PorMes WITH ROUND(&Var1/XfImpMes*100,2)
            ELSE
               REPLACE PorMes WITH ROUND(&Var2/XfImpMes*100,2)
            ENDIF
            zPorMes = zPorMes + PorMes
            SKIP
         ENDDO
         Go XsPunt
         IF TRIM(GloCta) = "REF"
            XfRefAcm = XfImpAcm
            XfRefMes = XfImpMes
            XfRefAma = XfImpAma
            lRef = .T.
            REPLACE PorAcm WITH 100
            REPLACE PorMes WITH 100
            REPLACE PorAma WITH 100
         ELSE
            REPLACE PorAcm WITH zPorAcm
            REPLACE PorMes WITH zPorMes
            REPLACE PorAma WITH zPorAma
         ENDIF
         STORE 0 TO XfImpAcm,XfImpAma,XfImpMes
         Sw = 1
      CASE NOTA = "L2"
      CASE NOTA = "L3"
      CASE NOTA = "L4"
      CASE NOTA = "TG"
         lreg = RECNO()
         XfImpTot = 0
         Store 0 TO nImpAma,nImpAcm,nImpMes
         SEEK XsCodPer
         DO WHILE Rubro = XsCodPer .AND. ! EOF()
            I=0
            STORE 0 TO Campo1,Campo2
            DO WHILE I<=_Mes && Acumulado a la Fecha
               VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
               VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
               Campo1 = Campo1 + &Var1
               Campo2 = Campo2 + &Var2
               I=I+1
            ENDDO
            IF XiCodMon=1
               nImpAcm = nImpAcm + Campo1
            ELSE
               nImpAcm = nImpAcm + Campo2
            ENDIF
            *
            I=0
            STORE 0 TO Campo1,Campo2
            DO WHILE I <= _Mes-1 && Acumulado al mes anterior
               VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
               VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
               Campo1 = Campo1 + &Var1
               Campo2 = Campo2 + &Var2
               I=I+1
            ENDDO
            IF XiCodMon=1
               nImpAma = nImpAma + Campo1
            ELSE
               nImpAma = nImpAma + Campo2
            ENDIF
            * Importe mensual
            VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
            VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
            Campo1 = &Var1
            Campo2 = &Var2
            IF XiCodMon=1
               nImpMes = nImpMes + Campo1
            ELSE
               nImpMes = nImpMes + Campo2
            ENDIF
            SKIP
         ENDDO
         GO lReg
         REPLACE PorAcm WITH ROUND(nImpAcm/XfRefAcm*100,2)
         REPLACE PorAma WITH ROUND(nImpAma/XfRefAma*100,2)
         REPLACE PorMes WITH ROUND(nImpMes/XfRefMes*100,2)

      CASE ! EMPTY(Nota)
         IF Sw=1
            XsNroItm = NroItm
            Sw=0
         ENDIF
         I=0
         STORE 0 TO Campo1,Campo2
         DO WHILE I<=_Mes && Acumulado a la Fecha
            VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
            VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
            Campo1 = Campo1 + &Var1
            Campo2 = Campo2 + &Var2
            I=I+1
         ENDDO
         IF XiCodMon=1
            XfImpAcm  = XfImpAcm + Campo1
         ELSE
            XfImpAcm  = XfImpAcm + Campo2
         ENDIF
         **
         I=0
         STORE 0 TO Campo1,Campo2
         DO WHILE I<=_Mes - 1                 && Acumulado mes Anterior
            VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
            VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
            Campo1 = Campo1 + &Var1
            Campo2 = Campo2 + &Var2
            I=I+1
         ENDDO
         IF XiCodMon=1
            XfImpAma  = XfImpAma + Campo1
         ELSE
            XfImpAma  = XfImpAma + Campo2
         ENDIF
         **
         VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
         VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
         IF XiCodMon=1
            XfImpMes  = XfImpMes + &Var1
         ELSE
            XfImpMes  = XfImpMes + &Var2
         ENDIF
         XsPunt = Recno()
   ENDCASE
   SELECT TBAL
   SKIP
ENDDO
RETURN .T.
***************
