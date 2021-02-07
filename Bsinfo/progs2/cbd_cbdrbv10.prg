#INCLUDE CONST.H
*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
goentorno.open_dbf1('ABRIR','CBDTPERN','TBAL','TPER01','')
goentorno.open_dbf1('ABRIR','CBDNPERN','NBAL','NPER01','')
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV02','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDACMCT','OLDS','ACCT01','','',GsCodCia,LTRIM(STR(_ANO-1)))

cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ESTADO DE GESTION GENERAL + "
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1
XdMes2=_mes
LNMES=1
llMes=0
llMed=0
llAcMD=0
llAcMS=0
XsPunt=0
XfImpMes=0    && Movimiento del Mes
XfImpAcm=0    && Acumulado al mes
XfImpAma=0    && Acumulado al mes Anterior
XfImpAno_1=0  && Acumulado al A¤o Anterior
STORE 0 TO XfRefMes,XfRefAcm,XfRefAma,XfRefAno_1
XfImpTot=0
XtPorTot=0
XsCodPer = '01'
XiCodMon = 1
XiTipo   = 1
sw       = 1
XsNomBre = ''
XsTipRep  = .F.
XnNumCol  = 3  && Numero de columnas, cuando se imprimen los anexos
LlNewReport = .F.

DO FORM cbd_cbdrbv10


RETURN

******************
PROCEDURE Imprimir
******************
DO F0PRINT
IF LASTKEY() = 27
	RETURN
ENDIF
IF ! CARGA()
	RETURN
ENDIF
DO PORCEN

SELECT TBAL
SEEK XsCodPer
IF ! RLOCK()
	RETURN
ENDIF
UNLOCK ALL

Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 6
IniImp  = _PRN4+_prn8a
Tit_SIZQ = _Prn6a+_Prn7a+TRIM(GsNomCia)+_prn7b+_Prn6b
Tit_IIZQ = ""
Tit_SDER = ""
Titulo   = ""
SubTitulo= ""
En1 = " "
En2 = "@"+ALLTRIM(XsNomBre)
En3 = " "
En4 = " "
*
IF !XsTipRep   &&& COMPARATIVO
Ancho = 145
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = TIME()


AnoAnt = RIGHT(TRANS(_Ano-1,"9999"),2)
dAnt   = "31/12/"+AnoAnt



IF XiCodMon=1
	En4 = "EN NUEVOS SOLES AL "+STR(DAY(GdFecha),2)+" de "+Mes(XdMes2,3)+" de "+STR(_ano,4)
ELSE
	En4 = "EN DOLARES AL "+STR(DAY(GdFecha),2)+" de "+Mes(XdMes2,3)+" de "+STR(_ano,4)
ENDIF
En5 = "========================================================================================================================================================="
En6 = "                                                       ACUMULADO                ACUMULADO                 MOVIMIENTO                ACUMULADO            "
En7 = "       DESCRIPCION                                   AL  "+dAnt+"      %       MES ANTERIOR      %        MES ACTUAL       %       PRESENTE MES       %  "
En8 = "================================================   ================  ======  ================  ======  ================  ======  ================  ======"
En9 = " "
      *012345678901234567890123456789012345678901234567    999,999,999.99   999.99   999,999,999.99   999.99   999,999,999.99   999.99   999,999,999.99   999.99
      *0         1         2         3         4123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
      *0         1         2         3         4         5         6         7         8         9         100       1         2         3         4


ELSE
SinNumPag = .T.
En3  = [@]+UPPER(Mes(XdMes2,3))+"-"+STR(_ano,4)
sMon = IIF(xiCodMon=1,[S/.],[US$])
En5 = "==================================================================="
En6 = "                                                                   "
En7 = "        CONCEPTO                                     IMPORTE "+sMon
En8 = "==================================================================="
En9 = " "
      *012345678901234567890123456789012345678901234567    999,999,999.99   999.99
      *0         1         2         3         41234567890123456789012345678901234
      *0         1         2         3         4         5         6         7    
Ancho = LEN(En8)      
ENDIF      
*
TEXTo1 = PADL("A "+Mes(XdMes2,3),20)
TEXTo2 = PADL("A "+Mes(IIF(XdMes2>0,XdMes2-1,0),3),20)
Cancelar = .F.
SELECT TBAL
Pos1 = 50
Pos2 = 71
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
	STORE 0 TO XGME1,XGACS,XGME2,XGACD,XGAAS,XGAAD,XGAP1,XGAP2
	STORE 0 TO yGME1,yGACS,yGME2,yGACD,yGAAS,yGAAD,yGAP1,yGAP2
	LnActCol = 0  && Para controlar el numero de columnas en los anexos
	LsUltCol = 'XXXX'
	LnColAnx = 0
	LnRecnoIni = 0
	DO WHILE ! EOF() .AND. Rubro = XsCodPer
		DO ResetPag
		NumLin = PROW() + 1
		LnColAnx=IIF(TRIM(GloCta)<>LsUltCol,IIF(LnColAnx + 1>XnNumCol,1,LnColAnx + 1),LnColAnx)
		DO LinImp1
		LsUltCol = TRIM(GloCta)
		SKIP
		IF GloCta='ANX02'
			SET STEP ON 
		ENDIF
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
@ NumLin,Separa SAY Glosa+" "+IIF(INLIST(TRIM(GloCta),"UTI","REF"),"",GloCta) pict [@S49]

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
	    IF !XsTipRep
		@ NumLin,51  SAY "----------------  ------  ----------------  ------  ----------------  ------  ----------------  ------"
		ELSE
		@ NumLin,51  SAY "----------------"
		ENDIF
	CASE NOTA = "RD"
	    IF !XsTipRep 
		@ NumLin,51  SAY "================  ======  ================  ======  ================  ======  ================  ======"
		ELSE
		@ NumLin,51  SAY "================"
		ENDIF
	CASE NOTA = "L1" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 
				@ NumLin,51   SAY PICNUM1(T1AP1)
				@ NumLin,69   SAY xPorcen(T1AP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S1AAS)     && Soles y Acumulado del mes anterior
				@ NumLin,95   SAY xPorcen(S1AAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO1M1)     && Soles y Movimiento Mensual
				@ NumLin,121  SAY xPorcen(TO1M1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S1ACS)     && Soles y Acumulado al Mes
				@ NumLin,147  SAY xPorcen(S1ACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S1ACS)     && Soles y Acumulado al Mes
				ENDIF
			CASE XiCodMon=2
			    IF !XsTipRep 
				@ NumLin,51   SAY PICNUM1(T1AP2)
				@ NumLin,69   SAY xPorcen(T1AP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S1AAD)
				@ NumLin,95   SAY xPorcen(S1AAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO1M2)
				@ NumLin,121  SAY xPorcen(TO1M1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S1ACD)
				@ NumLin,147  SAY xPorcen(S1ACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S1ACD)     && Soles y Acumulado al Mes
				ENDIF
		ENDCASE
		STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD,S1AAS,S1AAD,T1AP1,T1AP2
	CASE NOTA = "L2" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 
				@ NumLin,51   SAY PICNUM1(T2AP1)
				@ NumLin,69   SAY xPorCen(T2AP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S2AAS)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S2AAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO2M1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(TO2M1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S2ACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(S2ACS,XfRefAcm)
				ELSE
				@ NumLin,51   SAY PICNUM1(S2ACS)     && Soles y Acumulado
				ENDIF
			CASE XiCodMon=2
			    IF !XsTipRep 
				@ NumLin,51   SAY PICNUM1(T2AP2)
				@ NumLin,69   SAY xPorCen(T2AP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S2AAD)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S2AAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO2M2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(TO2M2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S2ACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(S2ACD,XfRefAcm)
				ELSE
				@ NumLin,51   SAY PICNUM1(S2ACD)     && Dolares y acumulado
				ENDIF
		ENDCASE
		STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD,S2AAS,S2AAD,T2AP1,T2AP2
	CASE NOTA = "L3" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(T3AP1)
				@ NumLin,69   SAY xPorCen(T3AP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S3AAS)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S3AAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO3M1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(TO3M1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S3ACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(S3ACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S3ACS)     && Soles y Acumulado
				ENDIF
				
			CASE XiCodMon=2
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(T3AP2)
				@ NumLin,69   SAY xPorCen(T3AP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S3AAD)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S3AAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO3M2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(TO3M2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S3ACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(S3ACD,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S3ACD)     && Dolares y acumulado
				ENDIF
				
		ENDCASE
		STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD,S3AAS,S3AAD,T3AP1,T3AP2
	CASE NOTA = "L4" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(T4AP1)
				@ NumLin,69   SAY xPorCen(T4AP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S4AAS)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S4AAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO4M1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(TO4M1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S4ACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(S4ACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S4ACS)     && Soles y Acumulado
				ENDIF
				
			CASE XiCodMon=2
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(T4AP2)
				@ NumLin,69   SAY xPorCen(T4AP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S4AAD)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S4AAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO4M2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(TO4M2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S4ACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(S4ACD,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S4ACD)     && Dolares y acumulado
				ENDIF
				
		ENDCASE
		STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD,S4AAS,S4AAD,T4AP1,T4AP2
	CASE NOTA = "L5" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(T5AP1)
				@ NumLin,69   SAY xPorCen(T5AP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S5AAS)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S5AAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO5M1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(TO5M1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S5ACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(S5ACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S5ACS)     && Soles y Acumulado
				ENDIF
				
			CASE XiCodMon=2
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(T5AP2)
				@ NumLin,69   SAY xPorCen(T5AP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(S5AAD)     && Soles y Acumulado
				@ NumLin,95   SAY xPorCen(S5AAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TO5M2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(TO5M2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(S5ACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(S5ACD,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S5ACD)     && Dolares y acumulado
				ENDIF
				
		ENDCASE
		STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD,S5AAS,S5AAD,T5AP1,T5AP2
	CASE NOTA = "TG" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(TGAP1)
				@ NumLin,69   SAY xPorCen(TGAP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(TGAAS)
				@ NumLin,95   SAY xPorCen(TGAAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TGME1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(TGME1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(TGACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(TGACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(TGACS)     && Soles y Acumulado
				ENDIF
				
			CASE XiCodMon=2
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(TGAP2)
				@ NumLin,69   SAY xPorCen(TGAP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(TGAAD)
				@ NumLin,95   SAY xPorCen(TGAAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(TGME2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(TGME2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(TGACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(TGACD,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(TGACD)     && Dolares y acumulado
				ENDIF
				
		ENDCASE
		XGME1 = XGME1 + TGME1
		XGME2 = XGME2 + TGME2
		XGACS = XGACS + TGACS
		XGACD = XGACD + TGACD
		XGAAS = XGAAS + TGAAS
		XGAAD = XGAAD + TGAAD
		XGAP1 = XGAP1 + TGAP1
		XGAP2 = XGAP2 + TGAP2
		STORE 0 TO TGME1,TGACS,TGME2,TGACD,TGAAS,TGAAD,TGAP1,TGAP2
		STORE 0 TO TO1M1,S1ACS,TO1M2,S1ACD,S1AAS,S1AAD,T1AP1,T1AP2
		STORE 0 TO TO2M1,S2ACS,TO2M2,S2ACD,S2AAS,S2AAD,T2AP1,T2AP2
		STORE 0 TO TO3M1,S3ACS,TO3M2,S3ACD,S3AAS,S3AAD,T3AP1,T3AP2
		STORE 0 TO TO4M1,S4ACS,TO4M2,S4ACD,S4AAS,S4AAD,T4AP1,T4AP2
		STORE 0 TO TO5M1,S5ACS,TO5M2,S5ACD,S5AAS,S5AAD,T5AP1,T5AP2
	CASE NOTA = "XG" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(XGAP1)
				@ NumLin,69   SAY xPorCen(XGAP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(XGAAS)
				@ NumLin,95   SAY xPorCen(XGAAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(XGME1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(XGME1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(XGACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(XGACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(XGACS)     && Soles y Acumulado
				ENDIF
				
			CASE XiCodMon=2
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(XGAP2)
				@ NumLin,69   SAY xPorCen(XGAP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(XGAAD)
				@ NumLin,95   SAY xPorCen(XGAAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(XGME2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(XGME2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(XGACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(XGACD,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(XGACD)     && Dolares y acumulado
				ENDIF
				
		ENDCASE
		YGME1 = YGME1 + XGME1
		YGME2 = YGME2 + XGME2
		YGACS = YGACS + XGACS
		YGACD = YGACD + XGACD
		YGAAS = YGAAS + XGAAS
		YGAAD = YGAAD + XGAAD
		YGAP1 = YGAP1 + XGAP1
		YGAP2 = YGAP2 + XGAP2
		STORE 0 TO XGME1,XGACS,XGME2,XGACD,XGAAS,XGAAD,XGAP1,XGAP2
	CASE NOTA = "YG" .AND. Separa = 0
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(YGAP1)
				@ NumLin,69   SAY xPorCen(YGAP1,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(YGAAS)
				@ NumLin,95   SAY xPorCen(YGAAS,XfRefAma)
				@ NumLin,104  SAY PICNUM1(YGME1)     && soles y mensual
				@ NumLin,121  SAY xPorCen(YGME1,XfRefMes)
				@ NumLin,130  SAY PICNUM1(YGACS)     && Soles y Acumulado
				@ NumLin,147  SAY xPorCen(YGACS,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(YGACS)     && Soles y Acumulado
				ENDIF
				
			CASE XiCodMon=2
			    IF !XsTipRep 			
				@ NumLin,51   SAY PICNUM1(YGAP2)
				@ NumLin,69   SAY xPorCen(YGAP2,XfRefAno_1)
				@ NumLin,78   SAY PICNUM1(YGAAD)
				@ NumLin,95   SAY xPorCen(YGAAD,XfRefAma)
				@ NumLin,104  SAY PICNUM1(YGME2)     && Dolares y mensual
				@ NumLin,121  SAY xPorCen(YGME2,XfRefMes)
				@ NumLin,130  SAY PICNUM1(YGACD)     && Dolares y acumulado
				@ NumLin,147  SAY xPorCen(YGACD,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(YGACD)     && Dolares y acumulado
				ENDIF
				
		ENDCASE
		STORE 0 TO YGME1,YGACS,YGME2,YGACD,YGAAS,YGAAD,YGAP1,YGAP2
	CASE ! EMPTY(Nota) .AND. Separa = 0
		DO CALCULO
		I=0    && 1
		J=XdMes2
		STORE 0 TO Ano_1S,Ano_1D      && A¤o Anterior
		Ano_1S = PreSol
		Ano_1D = PreDol
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
		XSMESS=("MESS"+TRANSF(XdMes2,"@L ##") )
		XSMESS=&XSMESS                         && del Mes en Soles
		XSMACS=S1ACS                           && Acumulado a la fecha
		XSMAAS=S1AAS                           && Al mes Anterior
		XSMESD=("MESD"+TRANSF(XdMes2,"@L ##") )
		XSMESD=&XSMESD
		XSMACD=S1ACD
		XSMAAD=S1AAD                           && Al mes Anterior
		DO CASE
			CASE XiCodMon=1
			    IF !XsTipRep 						
				@ NumLin,51  SAY PICNUM1(Ano_1S)
				@ NumLin,69  SAY xPorCen(Ano_1S,XfRefAno_1)
				@ NumLin,78  SAY PICNUM1(S1AAS1)
				@ NumLin,95  SAY xPorCen(S1AAS1,XfRefAma)
				@ NumLin,104 SAY PICNUM1(XSMESS)
				@ NumLin,121 SAY xPorCen(XSMESS,XfRefMes)
				@ NumLin,130 SAY PICNUM1(S1ACS2)
				@ NumLin,147 SAY xPorCen(S1ACS2,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S1ACS2)
				ENDIF
			CASE XiCodMon=2
				IF !XsTipRep 
				@ NumLin,51  SAY PICNUM1(Ano_1D)
				@ NumLin,69  SAY xPorCen(Ano_1D,XfRefAno_1)
				@ NumLin,78  SAY PICNUM1(S1AAD1)
				@ NumLin,95  SAY xPorCen(S1AAD1,XfRefAma)
				@ NumLin,104 SAY PICNUM1(XSMESD)
				@ NumLin,121 SAY xPorCen(XSMESD,XfRefMes)
				@ NumLin,130 SAY PICNUM1(S1ACD2)
				@ NumLin,147 SAY xPorCen(S1ACD2,XfRefAcm)
				ELSE
				@ NumLin,51  SAY PICNUM1(S1ACD2)
				ENDIF
		ENDCASE
		LM=TRANSF(XdMes2,"@L ##")
		L1="MESS"+LM
		L2="MESD"+LM
		** Totales de A¤o Anterior **
		T1AP1=T1AP1+Ano_1S
		T1AP2=T1AP2+Ano_1D
		T2AP1=T2AP1+Ano_1S
		T2AP2=T2AP2+Ano_1D
		T3AP1=T3AP1+Ano_1S
		T3AP2=T3AP2+Ano_1D
		T4AP1=T4AP1+Ano_1S
		T4APB=T4AP2+Ano_1D
		T5AP1=T5AP1+Ano_1S
		T5AP2=T5AP2+Ano_1D
		TGAP1=TGAP1+Ano_1S
		TGAP2=TGAP2+Ano_1D
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
		
		** VETT
		=GrabaTemp(LnColAnx,IIF(XiCodMon=1,S1ACS2,S1ACD2),XnNumCol)
ENDCASE
RETURN
*****************
PROCEDURE CALCULO
*****************
VS1 = 0
VS2 = 0
VD1 = 0
VD2 = 0

Campo1 = "MESS"+TRANSF(XdMes2,"@L ##")
Campo2 = "MESD"+TRANSF(XdMes2,"@L ##")
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
	RETURN PADL("("+ALLTRIM(TRANSF(-Valor1,"@Z ##,###,###,###"))+")",15)
ELSE
	RETURN TRANSF( Valor1,"@Z ##,###,###,###")
ENDIF
*****************
PROCEDURE PICNUM2
*****************
PARAMETER Valor1
RETURN TRANS(Valor1,"@Z 999.99")
*****************
PROCEDURE xPorCen
*****************
PARAMETER vv,tt
IF tt=0
	Valor1 = 0
ELSE
	Valor1 = vv/tt*100
ENDIF
RETURN TRANS(Valor1,"@Z( 999")

******************
PROCEDURE RESETPAG
******************
IF LinFin <= PROW() .OR. Inicio
	Inicio  = .F.
	DO F0MBPRN
	IF UltTecla = K_ESC
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
***************
PROCEDURE Carga
***************
DIMENSION SOLES(14),DOLARES(14)
DIMENSION XSOLES(14),XDOLARES(14)
SELECT TBAL
IF ! FLOCK()
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
STORE 0 TO SOLES,DOLARES,xSoles,xDolares
XcRubro = Rubro
XsNota  = Nota
SELECT NBAL
Llave = XcRubro+XsNota
SEEK Llave
DO WHILE ! EOF() .AND. Rubro+Nota = Llave
	LlBuscaDetMov = .F.
	IF VARTYPE(CodAux) = 'C' AND !EMPTY(CodAux)
		LlBuscaDetMov = .T.
	ENDIF
    IF LlBuscaDetMov
	   DO VALORIZAG
	ELSE
	   DO VALORIZA	
	ENDIF
	SELECT NBAL
	SKIP
ENDDO
DO GRABA
RETURN

*******************
PROCEDURE VALORIZAG
*******************
XsCodCta = TRIM(CodCta)
XcSigno  = Signo
XcForma  = Forma
XsCodRef = TRIM(CodRef)
XsCodAux = TRIM(CodAux)
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
		DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
			IF CodRef <> XsCodRef
				SKIP
				LOOP
			ENDIF
			IF CodAux <> XsCodAux
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
ENDIF
RETURN
******************
PROCEDURE VALORIZA
******************
XsCodCta = CodCta
XcSigno  = Signo
XcForma  = Forma
XsCodRef = TRIM(CodRef)
TnMes    = 0
IF XcSigno$"43"
	RETURN
ENDIF
IF !EMPTY(CodRef)
	XsCodCta=TRIM(XsCodCta)
ENDIF
IF xscodcta='9'

ENDIF

IF ! "X"$XsCodCta  .AND. ! XsCodCta="VA"  .AND. ! XsCodCta="VM"
	SELECT ACCT
	FOR TnMes = 0  TO XdMes2
		xLLave = STR(TnMes,2,0)+XsCodCta
		SEEK xLlave
		XS=0
		XD=0
		DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
*!*				XS = XS + DbeNac - Hbenac
*!*				XD = XD + DbeExt - HbeExt
			IF CodRef <> XsCodRef
				SKIP
				LOOP
			ENDIF

			XS = XS + IIF(XcForma$'13',DbeNac,0)- IIF(XcForma$'23',Hbenac,0)
			XD = XD + IIF(XcForma$'13',DbeExt,0)- IIF(XcForma$'23',HbeExt,0)

			SKIP
		ENDDO
		IF XcSigno = '2'
			XS = - XS
			XD = - XD
		ENDIF
		SOLES(TnMes + 1  ) = SOLES(TnMes + 1)   + XS
		DOLARES(TnMes + 1) = DOLARES(TnMes + 1) + XD
	ENDFOR
ENDIF
IF !USED("OLDS")
	RETURN
ENDIF
** Acumulados del a¤o anterior **
SELE OLDS
IF ! "X"$XsCodCta  .AND. ! XsCodCta="VA"  .AND. ! XsCodCta="VM"
	SELECT OLDS
	FOR TnMes = 0  TO 12
		xLLave = STR(TnMes,2,0)+XsCodCta
		SEEK xLlave
		XS=0
		XD=0
		DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
*!*				XS = XS + DbeNac - Hbenac
*!*				XD = XD + DbeExt - HbeExt
			IF CodRef <> XsCodRef
				SKIP
				LOOP
			ENDIF
			XS = XS + IIF(XcForma$'13',DbeNac,0)- IIF(XcForma$'23',Hbenac,0)
			XD = XD + IIF(XcForma$'13',DbeExt,0)- IIF(XcForma$'23',HbeExt,0)
			SKIP
		ENDDO
		IF XcSigno = '2'
			XS = - XS
			XD = - XD
		ENDIF
		xSOLES(TnMes + 1  ) =xSOLES(TnMes + 1)   + XS
		xDOLARES(TnMes + 1) =xDOLARES(TnMes + 1) + XD
	ENDFOR
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
* Acumulado del A¤o Anterior *
STORE 0 TO TSoles,TDolar
FOR TnMes = 0  TO  12
	TSoles = TSoles + xSoles(TnMes   + 1)
	TDolar = TDolar + xDolares(TnMes + 1)
ENDFOR
REPLACE PreSol WITH  TSoles
REPLACE PreDol WITH  TDolar
RETURN
****************
PROCEDURE PORCEN
****************
DIMENSION SOLES(14),DOLARES(14)
DIMENSION XSOLES(14),XDOLARES(14)
STORE 0 TO TFRefAno_1,TfRefAcm,TfRefAma,TfRefMes
STORE 0 TO  xImpAcm, xImpAma,xImpMes
Toma_otro = .F.
lRef = .F.
SELECT TBAL
IF ! FLOCK()
	RETURN .F.
ENDIF
SEEK XsCodPer
DO WHILE Rubro = XsCodPer .AND. ! EOF()
	IF Nota$ ['RS','RD','R1','R2']
		SKIP
		LOOP
	ENDIF
	IF TRIM(GloCta) = "REF"
		I=0
		STORE 0 TO Campo1,Campo2
		DO WHILE I<=XdMes2 && Acumulado a la Fecha
			VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
			VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
			Campo1 = Campo1 + &Var1
			Campo2 = Campo2 + &Var2
			I=I+1
		ENDDO
		XfImpAcm = IIF(XiCodMon=1,Campo1,Campo2)
		I=0
		STORE 0 TO Campo1,Campo2
		DO WHILE I<=XdMes2-1  && Acumulado al Mes Anterior
			VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
			VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
			Campo1 = Campo1 + &Var1
			Campo2 = Campo2 + &Var2
			I=I+1
		ENDDO
		XfImpAma = IIF(XiCodMon=1,Campo1,Campo2)
		VAR1="MESS"+TRANSF(I,"@L ##")     && Importe Soles Mensual
		VAR2="MESD"+TRANSF(I,"@L ##")     && Importe D¢lares Mensual
		XfImpMes = IIF(XiCodMon=1,&VAR1,&VAR2)
		** A¤o anterior
		XfImpAno_1 = IIF(XiCodMon=1,PreSol,PreDol)
		XfRefAcm = XfImpAcm
		XfRefMes = XfImpMes
		XfRefAma = XfImpAma
		XfRefAno_1 = XfImpAno_1
		REPLACE PorAcm WITH 100
		REPLACE PorMes WITH 100
		REPLACE PorAma WITH 100
		REPLACE PorTip WITH 100
		IF INLIST(NOTA,'L1','L2','L3','L4','L5','TG')
			Toma_Otro = .T.
		ENDIF
		EXIT
	ELSE
		STORE 0 TO  xImpAcm, xImpAma,xImpMes
		TFRefAno_1 = TfRefAno_1 + IIF(XiCodMon=1,Presol,Predol)
		FOR K = 0 TO XdMes2
			IF k < XdMes2
				VAR1="MESS"+TRANSF(K,"@L ##")     && Importe Soles Mensual
				VAR2="MESD"+TRANSF(K,"@L ##")     && Importe D¢lares Mensual
				xImpAma = xImpAma + IIF(XiCodMon=1,&var1,&var2)
			ENDIF
			IF k <=XdMes2
				xVAR1="MESS"+TRANSF(K,"@L ##")     && Importe Soles Mensual
				xVAR2="MESD"+TRANSF(K,"@L ##")     && Importe D¢lares Mensual
				xImpAcm = xImpAcm + IIF(XiCodMon=1,&xVar1,&xVar2)
			ENDIF
			IF k = XdMes2
				mVAR1="MESS"+TRANSF(K,"@L ##")     && Importe Soles Mensual
				mVAR2="MESD"+TRANSF(K,"@L ##")     && Importe D¢lares Mensual
				xImpMes = xImpMes + IIF(XiCodMon=1,&mVAR1,&mVAR2)
			ENDIF
		ENDFOR
		TFRefAcm = TfRefAcm +  xImpAcm
		TFRefAma = TfRefAma +  xImpAma
		TFRefMes = TfRefMes +  xImpMes
		TFRefAno_1 = TfRefAno_1 + IIF(XiCodMon=1,Presol,Predol)
	ENDIF
	SKIP
ENDDO
*** Aguanta loco
IF Toma_Otro
	XfRefAcm   = TfRefAcm
	XfRefAma   = TfRefAma
	XfRefMes   = TfRefMes
	XfRefAno_1 = TfRefAno_1
ENDIF
RETURN .T.

*******************
PROCEDURE GrabaTemp
*******************
PARAMETERS _nColumna,_nImporte,_nNumCol
IF !USED('Tmp_EEFF')
	=CreaTemp('Tmp_EEFF')
*!*	ELSE	
*!*		SELECT 	Tmp_EEFF
*!*		ZAP
	LlNewReport= EOF('Tmp_EEFF')
ENDIF
_sColumna= TRANSFORM(_nColumna,"@L 99")
LsRubro 	=	'Rubro'		+	_sColumna
LsNota  	=	'Nota'		+	_sColumna
LsNroItm	=	'NroItm'	+	_sColumna
LsGlosa		=	'Glosa'		+	_sColumna
LsGloCta	=	'GloCta'	+	_sColumna
LsImp		=	'Imp'		+	_sColumna

SELECT Tmp_EEFF
IF LlNewReport 
	LnRecnoIni = 1
	LlNewReport = .F.
ENDIF
IF LnActCol<=_nNumCol
	LlGuardarRecno= .F.	
	IF _nNumCol= 1
		LlGuardaRecno = .T.
	ENDIF
ENDIF 
IF !EOF()
	GO BOTTOM 
	IF &LsGloCta. = TBAL.GloCta
		APPEND BLANK 
	ELSE
		GOTO LnRecnoIni		
		LnActCol = LnActCol + 1
		IF LnActCol> _nNumCol
			LnActCol = 0
			APPEND BLANK 
			LnRecnoIni = RECNO()	
			LnActCol = LnActCol + 1
		ENDIF
	ENDIF
ELSE
	APPEND BLANK 
	LnRecnoIni = RECNO()	
	LnActCol = LnActCol + 1
ENDIF

REPLACE &LsRubro.	WITH TBAL.Rubro
REPLACE &LsNota.	WITH TBAL.Nota
REPLACE &LsNroItm.	WITH TBAL.NroItm
REPLACE &LsGloCta.  WITH TBAL.GloCta
REPLACE &LsGlosa.	WITH TBAL.Glosa
REPLACE &LsImp.		WITH _nImporte
SELECT TBAL
******************
PROCEDURE CreaTemp
******************
PARAMETERS LsAliasTemp
IF PARAMETERS()=0
	LsAliasTemp = 'Temporal'
ENDIF
IF VARTYPE(LsAliasTemp)<>'C'
	LsAliasTemp = 'Temporal'
ENDIF
IF USED(LsAliasTemp)
	USE IN (LsAliasTemp)
ENDIF
LcArcTmp=GoEntorno.TmpPath+Sys(3)

SELE 0
CREATE TABLE (LcArcTmp) FREE (Rubro01 C(2),;
							  Nota01 C(2), ;
							  NroItm01 N(3) ,;
							  GloCta01 c(15),;
 							  Glosa01 C(50) ,;
							  Imp01 N(14,2) ,;
							  Rubro02 C(2),;
							  Nota02 C(2), ;
							  NroItm02 N(3) ,;
							  GloCta02 c(15),;
 							  Glosa02 C(50) ,;
							  Imp02 N(14,2) ,;
							  Rubro03 C(2),;
							  Nota03 C(2), ;
							  NroItm03 N(3) ,;
							  GloCta03 c(15),;
 							  Glosa03 C(50) ,;
							  Imp03 N(14,2) ,;
							  Rubro04 C(2),;
							  Nota04 C(2), ;
							  NroItm04 N(3) ,;
							  GloCta04 c(15),;
 							  Glosa04 C(50) ,;
							  Imp04 N(14,2)  )

USE (LcArcTmp) EXCL ALIAS (LsAliasTemp)
IF !USED()
	RETURN ''
ENDIF
RETURN ALIAS()


***************
PROCEDURE XXX
***************
PARAMETERS _nNumCol
SELECT rubro,glocta, COUNT(*) as totLin FROM TBAL WHERE Rubro=XsCodPer GROUP BY rubro,glocta 
LnTotReg = _Tally
IF _nNumCol<=0
	LnTotGru = 1
ELSE
	LnTotGru = INT(_Tally/_nNumCol) + IIF(MOD(_Tally,_nNumCol)>=1,1,0)
ENDIF
LnRec = 0
LnMax = 0
SCAN 
	LnRec = LnRec + 1
	LnMax = MAX(LnMax,TotLin)
	IF LnRec = _nNumCol
		LnRec = 0	
		LnMax = 0
	ENDIF

ENDSCAN
