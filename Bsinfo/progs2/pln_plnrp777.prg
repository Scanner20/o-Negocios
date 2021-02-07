DO def_teclas IN fxgen_2
SET DISPLAY TO VGA50
PUBLIC LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoContab = CREATEOBJECT('Dosvr.Contabilidad')
PRIVATE Escape,XsCodPln,XsNroPer
escape = 27
XsCodPln = TRIM(GsCodPln)
XsNroPer = IIF(XsCodPln="1",XsNroMes,XsNroSem)

DO xPlnrp777

*******************
PROCEDURE xPlnrp777
*******************
Dimension AsCodigo(20)
XlPosSem=""
XsTitAux = SPACE(30)
cTit1 = GsNomCia
cTit2 = MES(VAL(XsNroMes),3)
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "RESUMEN GENERAL POR SEDES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
SET PROCEDURE TO Pln_PlnFxGen ADDITIVE && No seas monze VETT 07/07/2005
*********apertura de archivos************
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','PLNMTSEM','TSEM','SEMA01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG1','BPGO','BPGO01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG2','BPGO','BPGO01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNBLPG3','BPGO','BPGO01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNMTABL','TABL','TABL01','')
DO CASE
	CASE XsCodPln = "1"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV1','TMOV','TMOV01','')
	CASE XsCodPln = "2"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV2','TMOV','TMOV01','')
	CASE XsCodPln = "3"
		LoDatAdm.abrirtabla('ABRIR','PLNTMOV3','TMOV','TMOV01','')
ENDCASE
LoDatAdm.abrirtabla('ABRIR','PLNDMOVT','DMOV','DMOV01','')
LoDatAdm.abrirtabla('ABRIR','PLNTTCMB','TCMB','','')
locate for VAL(nromes)=PlnNroMes
XfTpoCmb=OfiVta
XnMonPln=1
**-----------------------------------**
m.COntrol = 1
OpcionR  = IIF(XsCodPln=[2],1,2)
**IF XsCodPln = "2"
**   UltTecla = 0
**   OpcionR  = 1
**   @ 9,10 CLEAR TO 18,67
**   @ 9,10       TO 18,67
**   @ 12,23 SAY "Elegir : "
**   DO WHILE !INLIST(UltTecla,Escape)
**      GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
**      DO LIB_Mtec with 99
**      @ 12,33 GET OpcionR FUNCTION '^ Semanal;Mensual;Gratificaci¢n'
**      READ
**      UltTecla  = LastKey()
**      IF INLIST(UltTecla,Escape,Enter)
**        EXIT
**      ENDIF
**   ENDDO
**   IF UltTecla==Escape
**      CLOSE DATA
**      RETURN
**   ENDIF
**ENDIF
*******
UltTecla = 0
Opcion   = 1
**@ 9,10 CLEAR TO 18,67
**@ 9,10       TO 18,67
**@ 12,23 SAY "Elegir : "
**DO WHILE !INLIST(UltTecla,Escape)
**   GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
**   DO LIB_Mtec with 99
**   @ 12,33 GET Opcion FUNCTION '^ Ingresos ;Descuentos;Ingresos y Descuentos;Resumen General '
**   READ
**   UltTecla  = LastKey()
**   IF INLIST(UltTecla,Escape,Enter)
**     EXIT
**   ENDIF
**ENDDO
**IF UltTecla==Escape
**   CLOSE DATA
**   RETURN
**ENDIF
*******
**UltTecla = 0
Opcion1  = 1
**@ 9,10 CLEAR TO 18,67
**@ 9,10       TO 18,67
**@ 12,23 SAY "Elegir : "
**DO WHILE !INLIST(UltTecla,Escape)
**   GsMsgKey = "[] [] Posiciona   [Enter] Registrar  [Esc] Salir"
**   DO LIB_Mtec with 99
**   @ 12,33 GET Opcion1 FUNCTION '^ Por Orden de Sueldo ;Por Orden Alfab‚tico '
**   READ
**   UltTecla  = LastKey()
***   IF INLIST(UltTecla,Escape,Enter)
**     EXIT
**   ENDIF
**ENDDO

**---------**
*!*	do plnrp777.spr
**---------**
IF LASTKEY()=27 or m.Control=2
	RETURN
ENDIF
DO CASE
	CASE Opcion1 = 2
		LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS14','')
	OTHERWISE
		LoDatAdm.abrirtabla('ABRIR','PLNMPERS','PERS','PERS12','')
ENDCASE
GO TOP
IF XsCodPln = "2" .AND. inli(OpcionR,2,3)
	DO LLENATEMP
ENDIF
IF XsCodPln = "2"
	XsTitAux = IIF(INLI(OpcionR,2,3),"Semanas : "+NroSema(1)+","+NroSema(2)+","+;
            NroSema(3)+","+NroSema(4)+","+NroSema(5),"Semana : "+XsNroPer)
ENDIF
XSCODMOV="RZ01"
SELECT PERS
GO TOP
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4+_PRN8B]
xWhile = []
IF XsCodPln='2' .AND. inli(OpcionR,2,3)
	XFor   = [VALCAL(XSCODMOV)<>0 ]
ELSE
	XFor   = [VALCAL("@SIT")<5 .AND. VALCAL(XSCODMOV)<>0 ]
ENDIF
DO CASE 
	CASE GsMnuNv01=[PLNMNU01]
		DO CASE
			CASE XSCODPLN="1"
				DO CASE
					CASE OPCION=1
						sNomREP = "pln_plnrV77A"
					CASE OPCION=2
						sNomREP = "pln_plnrV77B"
					CASE OPCION=3
						sNomREP = "pln_plnrV777"
					CASE OPCION=4
						sNomREP = "pln_plnrV77C"
				ENDCASE
			CASE XSCODPLN="2"
				DO CASE
					CASE OPCION=1
						sNomREP = "pln_plnrVO01"
					CASE OPCION=2
						IF OPCIONR = 3
							sNomREP = "pln_plnrVO2G"
						ELSE
							sNomREP = "pln_plnrVO02"
						ENDIF
					CASE OPCION=3
						IF OPCIONR = 3
							sNomREP = "pln_plnrVO3G"
						ELSE
							sNomREP = "pln_plnrVO03"
						ENDIF
					CASE OPCION=4
						IF OPCIONR = 3
							sNomREP = "pln_plnrVO4G"
						ELSE
							sNomREP = "pln_plnrVO04"
						ENDIF
				ENDCASE
		ENDCASE
	OTHER
		DO CASE
			CASE XSCODPLN="1"
				DO CASE
					CASE OPCION=1
						sNomREP = "plnrp77A"
					CASE OPCION=2
						sNomREP = "plnrp77B"
					CASE OPCION=3
						sNomREP = "plnrp777"
					CASE OPCION=4
						sNomREP = "plnrp77C"
				ENDCASE
			CASE XSCODPLN="2"
				DO CASE
					CASE OPCION=1
						sNomREP = "plnrpO01"
					CASE OPCION=2
						IF OPCIONR = 3
							sNomREP = "plnrpO2G"
						ELSE
							sNomREP = "plnrpO02"
						ENDIF
					CASE OPCION=3
						IF OPCIONR = 3
							sNomREP = "plnrpO3G"
						ELSE
							sNomREP = "plnrpO03"
						ENDIF
					CASE OPCION=4
						IF OPCIONR = 3
							sNomREP = "plnrpO4G"
						ELSE
							sNomREP = "plnrpO04"
						ENDIF
				ENDCASE
		ENDCASE
ENDCASE
DO F0MPRINT WITH "REPORTS"
RETURN

***************
FUNCTION SEMVAL
***************
PRIVATE wSemanas
wSemanas=""
SELE TSEM
LOCATE FOR MES=XsNroMes
DO WHILE MES=XsNroMes
	wSemanas=wSemanas+TSEM->SEMA+","
	SKIP
ENDDO
wSemanas=SUBSTR(wSemanas,1,LEN(wSemanas)-1)
SELE DMOV
RETURN wSemanas

*******************
PROCEDURE LLENATEMP
*******************
SELE DMOV
XlPosSem=SemVal()
SET FILTER TO NROPER $ XlPosSem AND XsCodPln=DMOV->CODPLN
GO BOTT
GO TOP
ArcTmp = PathUser+sys(3)+".dbf"
COPY TO (ArcTmp) FOR NROPER $ XlPosSem AND XsCodPln=DMOV->CODPLN
SELE 0
USE (ArcTmp) ALIAS TEMPO EXCL
SELE TEMPO
REPLA ALL NROPER WITH XsNroPer
INDEX ON CODPLN+CODPER+CODMOV+NROPER TAG DMOV04
ArcTmp2 = PathUser+sys(3)+".dbf"
COPY STRUC TO (ArcTmp2)
SELE 0
USE (ArcTmp2) ALIAS TEMPO2 EXCL
SELE PERS
DO WHILE !EOF()
	XsCodPer=PERS->CodPer
	SELE TEMPO
	SEEK XsCodPln+XsCodPer
	IF EOF()
		SELE PERS
		SKIP
		LOOP
	ENDIF
	DO WHILE XsCodPln=TEMPO->CODPLN AND XsCodPer=TEMPO->CODPER AND !EOF()
		SCATTER MEMVAR
		m.ValCal=0
		DO WHILE m.CodMov=TEMPO->CODMOV AND XsCodPer=TEMPO->CODPER AND !EOF()
			m.ValCal = m.ValCal + TEMPO->VALCAL
			SKIP
		ENDDO
		SELE TEMPO2
		APPEN BLANK
		GATHER MEMVAR
		SELE TEMPO
	ENDDO
	SELE PERS
	SKIP
ENDDO
SELE TEMPO2
ArcTmp3 = PathUser+sys(3)+".dbf"
COPY TO (ArcTmp3)
SELE DMOV
USE (ArcTmp3) ALIAS DMOV
IF !USED()
	RETURN
ENDIF
INDEX ON CODPLN+NROPER+CODPER+CODMOV+STR(VALREF,6,0) TAG DMOV01
INDEX ON CODPLN+NROPER+CODMOV+CODPER TAG DMOV02
INDEX ON CODPLN+CODPER TAG DMOV03
SET ORDER TO DMOV01
RETURN

****************
FUNCTION NROSEMA
****************
PARAMETER wNro
PRIVATE wSem
wSem = SUBSTR(XlPosSem+"    ",wNro*2-1,2)
RETURN wSem
