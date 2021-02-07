********************************************************************************
* Programa      : CBDRB020.PRG                                                 *
* Objeto        : RESUMENES GASTOS SEGUN PRESUPUESTO                           *
* Autor         : VETT                                                         *
* Creaci¢n      : 20/08/94                                                     *
* Actualizaci¢n : 10/10/2009 VETT = o-Negocios AplVfp                          *
********************************************************************************
#INCLUDE CONST.H
*** Abrimos Bases ****
DIMENSION SAC(6,5)
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
goentorno.open_dbf1('ABRIR','CBDTPRES','TBAL','TPER01','')
goentorno.open_dbf1('ABRIR','CBDNPRES','NBAL','NPER01','')
goentorno.open_dbf1('ABRIR','CBDMPRES','PRES','PRES01','')
goentorno.open_dbf1('ABRIR','CBDMPREM','PREM','PREM01','')
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV02','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDPPRES','PPRE','PPRE01','')
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "EEFF SEGUN PRESUPUESTOS"
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1

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
UltTecla = 0
XnTipPres = 3 && Tipo de presupuesto
XnTipoRep = 2 && 1. Formato EPG, 2. Por Meses

DO FORM CBD_CbdRb020
RETURN
******************
PROCEDURE Imprimir
******************
DO F0PRINT
IF LASTKEY() = K_ESC
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
** INICIALIZAR MESES ** VETT 2010-04-19
SELECT TBAL
SEEK XsCodPer
SCAN WHILE Rubro = XsCodPer
	FOR mm = 0 TO 13
		LsCmpMes='MESS'+TRANSFORM(mm,'@L 99')
		REPLACE	(LsCmpMes) WITH 0
		LsCmpMes='MESD'+TRANSFORM(mm,'@L 99')
		REPLACE	(LsCmpMes) WITH 0
		IF mm<13
			LsCmpMes='PRESOL'+TRANSFORM(mm,'@L 99')
			REPLACE	(LsCmpMes) WITH 0
			LsCmpMes='PREUSA'+TRANSFORM(mm,'@L 99')
			REPLACE	(LsCmpMes) WITH 0
		ENDIF
	ENDFOR
ENDSCAN
** 
IF !Carga()
    RETURN
ENDIF
m.CalcPorCen=.F.
IF ! CARGA()
   RETURN
ENDIF
SELECT TBAL
SEEK XsCodPer
IF ! REC_LOCK(5)
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
DO CASE
	CASE XnTipoRep = 1
		En6 = "==================================== ==================================================================================================================================== ======="
		En7 = "                                                           M E S    A C T U A L                                     A C U M U L A D O                         PRESUPUESTO        "
		En8 = "PCGR    PRESTACIONES DE                   REAL       %   PRESUPUESTO    %     DESVIACION    %          REAL     %    PRESUPUESTO   %      DESVIACION    %      PENDIENTE    %    "
		En9 = "==================================== =========================================================== =========================================================== ============ ======="
	
		DIMENSION SAC(6,5)
	CASE XnTipoRep = 2
		En6 = ""
		En7 = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		En8 = "     CUENTAS - CONCEPTOS                ENERO          FEBRERO             MARZO           ABRIL              MAYO            JUNIO           JULIO          AGOSTO         SETIEMBRE          OCTUBRE         NOVIEMBRE    "
		En9 = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		En7 =En7+"-----------------------------------"
		En8 =En8+"   DICIEMBRE       ACUMULADO       "
		En9 =En9+"-----------------------------------"
		Ancho = 255
	    DIMENSION SAC(6,12)
    	DIMENSION TAC(2,12)
		DIMENSION totpor(13)
		ltotpor = .T.

ENDCASE
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
*!*	@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
*!*	@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
*!*	@ 21,31 SAY "ESC" COLOR SCHEME 7
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
   STORE 0 TO SAC,TAC
   DO WHILE ! EOF() .AND. Rubro = XsCodPer
      DO ResetPag
      NumLin = PROW() + 1
      IF XnTipoRep = 1
          DO LinImp1
	  ELSE
	      XsCodBal = XsCodPer
		  DO LinImp2	
	  ENDIF    
      SKIP
   ENDDO
   NumLin = PROW() + 1
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT

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
    	IF nota = 'C03' && and m.CalcPorCen=.F.
*!*				SET STEP ON 
		ENDIF

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
****************
PROCEDURE PICNUM
****************
PARAMETER Valor
IF Valor<0
	RETURN PADL("("+ALLTRIM(TRANSF(-Valor,"@Z ##,###,###,###"))+")",15)
ELSE
	RETURN TRANSF( Valor,"@Z ##,###,###,###")+" "
ENDIF
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
   Inicio  = .F.
   DO F0MBPRN &&IN ADMPRINT
   IF UltTecla = K_Esc
         Cancelar = .T.
   ENDIF
ENDIF
RETURN

***************
PROCEDURE Carga
***************
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
	LlBuscaDetMov = .F.
	IF (VARTYPE(CodAux) = 'C' AND !EMPTY(CodAux) ) OR ( VARTYPE(CtaPre) = 'C' AND !EMPTY(CtaPre) )
		LlBuscaDetMov = .T.
	ENDIF
	IF nota = 'C03' and m.CalcPorCen=.F.
*!*			SET STEP ON 
	ENDIF

    IF LlBuscaDetMov
	   DO VALORIZAG
	ELSE
	   DO VALORIZA	
	ENDIF
   SELECT NBAL
   SKIP
ENDDO
IF !m.CalcPorcen
   DO GRABA
ELSE
   DO PorCen
ENDIF
RETURN
*******************
PROCEDURE VALORIZAG
*******************
XsCodCta = TRIM(CodCta)
XcSigno  = Signo
XcForma  = Forma
XsCodRef = TRIM(CodRef)
XsCodAux = IIF(VARTYPE(CodAux)='C',TRIM(CodAux),'')
XsCtaPre = IIF(VARTYPE(CtaPre)='C',TRIM(CtaPre),'')
LsFiltro1 = IIF(VARTYPE(CodAux)='C',[CodAux <> XsCodAux],'.F.')
LsFiltro2 = IIF(VARTYPE(CtaPre)='C',[CtaPre <> XsCtaPre],'.F.')
*
LsFiltro3 = IIF(VARTYPE(CtaPre)='C',"!(!(INLIST(CodCta,[9],[10],[79],[61])) AND INLIST(CodOpe,[001],[002],[009]))",[.F.])
*
TnMes    = 0
IF XcSigno$"43"
	RETURN
ENDIF
IF !EMPTY(CodRef)
	XsCodCta=TRIM(XsCodCta)
ENDIF
IF ! "X"$XsCodCta  .AND. ! XsCodCta="VA"  .AND. ! XsCodCta="VM"
	SELECT RMOV
	FOR TnMes = 0  TO XdMes2
		xLLave = trans(TnMes,"@L 99")+XsCodCta
		SEEK xLlave
		XS=0
		XD=0
		XsCond = IIF(EMPTY(XsCodCta),[NroMes = xLlave],[NroMes+CodCta = xLLave])
*!*			DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
		DO WHILE !EOF() AND &XsCond
			IF CodRef <> XsCodRef
				SKIP
				LOOP
			ENDIF
			IF EVALUATE(LsFiltro1)
				SKIP
				LOOP
			ENDIF
			IF EVALUATE(LsFiltro2)
				SKIP
				LOOP
			ENDIF
			IF EVALUATE(LsFiltro3)
				SKIP
				LOOP
			ENDIF
			*
            nDbeNac = IIF(TpoMov='D',1,0)*Import
            nHbeNac = IIF(TpoMov='H',1,0)*Import
            *
            nDbeExt = IIF(TpoMov='D',1,0)*ImpUsa
            nHbeExt = IIF(TpoMov='H',1,0)*ImpUsa
            *
			XS = XS + IIF(XcForma$'13',nDbeNac,0)- IIF(XcForma$'23',nHbenac,0)
			XD = XD + IIF(XcForma$'13',nDbeExt,0)- IIF(XcForma$'23',nHbeExt,0)
			*
			SKIP
		ENDDO
		IF XcSigno = '2'
			XS = - XS
			XD = - XD
		ENDIF
		SOLES(TnMes + 1  ) = SOLES(TnMes + 1)   + XS
		DOLARES(TnMes + 1) = DOLARES(TnMes + 1) + XD
	ENDFOR

	** Presupuesto **
	DO CASE 
		CASE XnTipPres = 1   && EMPTY(XsCodRef) && Presupuesto por cuenta contable
		   SELE PREM
		   zLlave = TRIM(XsCodCta)
		   sKey = [CodCta]
		CASE XnTipPres = 2   &&  !EMPTY(XsCodRef)	&& Presupuesto por CodCta + CodAux + CodRef
		   SELE PRES
		   zLlave = TRIM(XsCodCta)
		   sKey = [CodCta]
		CASE XnTipPres = 3   &&  Presupuesto por cuenta presupuestal CtaPre
		   SELE PPRE
		   zLlave = TRIM(XsCtaPre)
		   sKey = [CtaPre]   
		   TstImp = [.T.]	
	ENDCASE 
		
	SEEK zLlave
	DO WHILE !EOF() AND &sKey. = zLlave AND EVALUATE(TsTImp)
	   *
	   **XcSaldo = Saldo
*!*		   LfPor = IIF(Filtro=[N],1,XfPorCen/100) && No recuerdo para que esto???? VETT 2009-11-02
		LfPor = 1
		IF xsnota='C03'
*!*				SET STEP ON 
		ENDIF
			
	    FOR nMes = 1 TO 12
	    	IF nMes<=XdMes2
    	        Campo3="ImpS"+TRANSF(nMes,"@L ##")
    	        Campo4="ImpD"+TRANSF(nMes,"@L ##")
    	        PACS = PACS + &Campo3*LfPor  &&*IIF(XcSaldo=[+],1,-1)
    	        PACD = PACD + &Campo4*LfPor   &&*IIF(Xcsaldo=[+],1,-1)
   	        ENDIF
  	        *
  	        Campo3="ImpS"+TRANSF(nMes,"@L ##")
  	        Campo4="ImpD"+TRANSF(nMes,"@L ##")
  	        PTOTS = PTOTS + &Campo3*LfPor  &&*IIF(XcSaldo=[+],1,-1)
  	        PTOTD = PTOTD + &Campo4*LfPor  &&*IIF(XcSaldo=[+],1,-1)
   	        *
  		    Campo3="ImpS"+TRANSF(nMes,"@L ##")
  		    Campo4="ImpD"+TRANSF(nMes,"@L ##")
  		    PMESS = &Campo3*LfPor   &&*IIF(XcSaldo=[+],1,-1)
  		    PMESD = &Campo4*LfPor   &&*IIF(XcSaldo=[+],1,-1)
  		    *
  		    LnSigno = IIF(Signo=0,1,Signo)
*!*				IF XcSigno = '2'
*!*					PACS  = - PACS
*!*					PACD  = - PACD
*!*					PTOTS = - PTOTS
*!*					PTOTD = - PTOTD
*!*					PMESS = - PMESS
*!*					PMESD = - PMESD
*!*				ENDIF
    		PRESOL(nMes ) = PRESOL(nMes ) + PMESS*LnSigno
    		PREDOL(nMes ) = PREDOL(nMes ) + PMESD*LnSigno   
	    ENDFOR
	    SKIP
	ENDDO

	
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
FOR TnMes = 0  TO  12
   IF TnMes <= XdMes2	
	   Campo1="MesS"+TRANSF(TnMes,"@L ##")
	   Campo2="MesD"+TRANSF(TnMes,"@L ##")
	   REPLACE &Campo1 WITH Soles(TnMes + 1 )
	   REPLACE &Campo2 WITH Dolares(TnMes + 1 )
   ENDIF
   IF TnMes>=1 AND TnMes<=12
	    Campo3="PreSol"+TRANSF(TnMes,"@L ##")
	    Campo4="PreUsa"+TRANSF(TnMes,"@L ##")
	    REPLACE &Campo3 WITH IIF(XcSaldo=[-],-ABS(PreSol(TnMes)),ABS(PreSol(TnMes)))
	    REPLACE &Campo4 WITH IIF(XcSaldo=[-],-ABS(PreDol(TnMes)),ABS(PreDol(TnMes)))
   ENDIF
	IF TnMes + 1 > XdMes2 AND TnMes<12 && Remplazamos el presupuesto en los meses siguientes A XdMes2
	   Campo1="MesS"+TRANSF(TnMes + 1,"@L ##")
	   Campo2="MesD"+TRANSF(TnMes + 1,"@L ##")
	   REPLACE &Campo1 WITH PreSol(TnMes + 1 )
	   REPLACE &Campo2 WITH PreDol(TnMes + 1 )
	ENDIF
ENDFOR
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
*****************
PROCEDURE LinImp2
*****************
@ NumLin,0 SAY Glosa PICT "@S33"
DO CASE
	CASE NOTA = "R1"
		FOR I = 1 TO 12
			STORE 0 TO SAC(1,I)
		NEXT
	CASE NOTA = "R2"
		FOR I = 1 TO 12
			STORE 0 TO SAC(2,I)
		NEXT
	CASE NOTA = "R3"
		FOR I = 1 TO 12
			STORE 0 TO SAC(3,I)
		NEXT
	CASE NOTA = "R4"
		FOR I = 1 TO 12
			STORE 0 TO SAC(4,I)
		NEXT
	CASE NOTA = "R5"
		FOR I = 1 TO 12
			STORE 0 TO SAC(5,I)
		NEXT
	CASE NOTA = "RS"
		@ NumLin,33  SAY REPLICATE("-",Ancho - 33)
	CASE NOTA = "RD"
		@ NumLin,33  SAY REPLICATE("=",Ancho - 33)
	CASE NOTA = "L1"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(SAC[1,I])
			TOT      = TOT + SAC[1,I]
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF SAC[1,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(SAC[1,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			SAC[1,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "L2"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(SAC[2,I])
			TOT      = TOT + SAC[2,I]
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF SAC[2,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(SAC[2,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			SAC[2,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "L3"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(SAC[3,I])
			TOT      = TOT + SAC[3,I]
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF SAC[3,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(SAC[3,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			SAC[3,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "L4"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(SAC[4,I])
			TOT      = TOT + SAC[4,I]
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF SAC[4,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(SAC[4,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			SAC[4,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "L5"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(SAC[5,I])
			TOT      = TOT + SAC[5,I]
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF SAC[5,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(SAC[5,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			SAC[5,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "TG"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(SAC[6,I])
			TOT      = TOT + SAC[6,I]
			tac (1,i) = tac(1,i) + sac(6,i)
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF SAC[6,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(SAC[6,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			SAC[6,I] = 0
			SAC[1,I] = 0
			SAC[2,I] = 0
			SAC[3,I] = 0
			SAC[4,I] = 0
			SAC[5,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "XG"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(TAC[1,I])
			TOT      = TOT + TAC[1,I]
			tac (2,i) = tac(2,i) + Tac(1,i)
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF TAC[1,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(TAC[1,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			TAC[1,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE NOTA = "YG"
		TOT = 0
		FOR I = 1 TO 12
			@ NumLin,33-17+I*17   SAY PICNUM(TAC[2,I])
			TOT      = TOT + TAC[2,I]
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF TAC[2,I]#0 .AND. TOTPOR(I)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(TAC[2,I]/TOTPOR(I)*100,'@(Z 999.99')
			ENDIF
			TAC[2,I] = 0
		NEXT
		IF TOT#0 .AND. TOTPOR(13)#0
			@ NumLin,235+10 SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
	CASE ! EMPTY(Nota)
		TOT = 0
		FOR I = 1 TO 12
			IF XiCodMon = 1
				Campo = "MESS"+TRANSF(I,"@L 99")
			ELSE
				Campo = "MESD"+TRANSF(I,"@L 99")
			ENDIF
			Campo = EVALUATE(Campo)
			IF lTotPor
				totpor(i) = IIF(INLIST(XsCodBal,[01],[02]),Campo,0)
			ENDIF
			@ NumLin,33 - 17 + i*17   SAY PICNUM(Campo)
			TOT = TOT + Campo
			FOR Y = 1 TO 6
				SAC[Y,I] = SAC[Y,I] + Campo
			NEXT
		NEXT
		@ NumLin,238  SAY PICNUM(TOT)
		IF lTotPor
			TotPor(13) = IIF(INLIST(XsCodBal,[01],[02]),TOT,0)
			lTotPor = .F.
		ENDIF
		NumLin = NumLin + 1
		FOR I = 1 TO 12
			IF XiCodMon = 1
				Campo = "MESS"+TRANSF(I,"@L 99")
			ELSE
				Campo = "MESD"+TRANSF(I,"@L 99")
			ENDIF
			Campo = EVALUATE(Campo)
			IF Campo# 0 .AND. totpor(i)#0
				@ NumLin,30 - 17 + i*17 + 10 SAY TRANS(campo/totpor(I)*100,'@(Z 999.99')
			ENDIF
		NEXT
		IF tot# 0 .and. totpor(13)#0
			@ NumLin,235+10  SAY TRANS(TOT/totpor(13)*100,'@(Z 999.99')
		ENDIF
ENDCASE
RETURN