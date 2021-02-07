******************************************************************************
*  NOMBRE        : Vtar5030.prg
*  Sistema       : Ventas                                                     *
*  Proposito     : Ventas anuales en U.M. cliente/articulo                    *
*  Creacion      : 29/03/95                                                   *
*  Actualizacion : EMI                                                        *
*******************************************************************************
CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REPORTE DE VENTAS POR CLIENTE/ARTICULO ANUAL <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 15,70
@ 8,10 TO 15,70 DOUBLE
@ 09,20 SAY " Reporte      :                  "
@ 10,20 SAY " Del Cliente  :               al "
@ 11,20 SAY " Del C¢digo   :               al "
@ 12,20 SAY " A¤o          :                  "
@ 13,20 SAY " Moneda       :                  "
@ 14,20 SAY " IGV          :                  "
*
CLOSE DATA
DO xListar

CLOSE DATA
RETURN
*********************************************************************** EOP() *
PROCEDURE xListar
*****************
* Aperturando bases
DO lib_msgs WITH 11
USE admmtcmb IN 0 ORDER tcmb01 ALIAS TCMB
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE vtavguia IN 0 ORDER VGUI06 ALIAS GUIA
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE almrmovm IN 0 ORDER RMOV06 ALIAS RMOV
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE vtavpedi IN 0 ORDER VPED01 ALIAS VPED
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE vtarpedi IN 0 ORDER RPED02 ALIAS RPED
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE ccbrgdoc IN 0 ORDER GDOC01 ALIAS GDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE vtaritem IN 0 ORDER ITEM01 ALIAS ITEM
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
USE almmmatg IN 0 ORDER MATG01 ALIAS MATG
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
* Archivo Temporal de Trabajo
SELE 0
ARCH = PATHUSER+SYS(3)
CREATE TABLE &ARCH. ( CODCLI C(5),   CODMAT C(13),  DESMAT C(40),  NOMCLI C(50), TPOCMB N(10,4),  MES01 N(12,2),;
                      MES02 N(12,2), MES03 N(12,2), MES04 N(12,2), MES05 N(12,2), MES06 N(12,2),;
                      MES07 N(12,2), MES08 N(12,2), MES09 N(12,2), MES10 N(12,2),;
                      MES11 N(12,2), MES12 N(12,2), UNDSTK C(3) )
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
	RETURN .F.
ENDIF
SELE GUIA
* Variables a usar *
PRIVATE XdFchDoc1,XdFchDoc2,XsCodMat1,XsCodMat2
STORE [] TO XsCodMat1,XsCodMat2
XICODMON=1
XFIMPORT=0
XiCodIgv=1
XiTipRep = 1
* Pedimos datos
PRIVATE i
SAVE SCREEN TO XXX
DO WHILE .T.
	RESTORE SCREEN FROM XXX
	XsAno    = LEFT(DTOS(DATE()),4)
	XsCodCli1= SPACE(LEN(GUIA->CodCli))
	XsCodCli2= SPACE(LEN(GUIA->CodCli))
	XsCodMat1= SPACE(LEN(MATG->CodMat))
	XsCodMat2= SPACE(LEN(MATG->CodMat))
	i = 1
	UltTecla = 0
	DO lib_mtec WITH 8
	DO WHILE UltTecla # Escape
		DO CASE
			CASE i = 1
				VecOpc(1) = "Detallado"
				VecOpc(2) = "Resumido "
				XiTipRep=Elige(XiTipRep,9,36,2)
				IF UltTecla = Escape
					RETURN
				ENDIF
			CASE i = 2
				GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
				DO lib_mtec WITH 99
				SELE CLIE
				@ 10,36 GET XsCodCli1 PICT "@!"
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape
					EXIT
				ENDIF
				IF UltTecla = F8  &&.OR. EMPTY(XsCodCli1)
					IF !vtabusca("CLIE")
						LOOP
					ENDIF
					XsCodCli1= CodAux
				ENDIF
				@ 10,36 SAY XsCodCli1
			CASE i = 3
				GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
				DO lib_mtec WITH 99
				SELE CLIE
				@ 10,54 GET XsCodCli2 PICT "@!"
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape
					EXIT
				ENDIF
				IF UltTecla = F8   &&.OR. EMPTY(XsCodCli2)
					IF !vtabusca("CLIE")
						LOOP
					ENDIF
					XsCodCli2= CodAux
				ENDIF
				@ 10,54 SAY XsCodCli2
			CASE i = 4
				GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
				DO lib_mtec WITH 99
				SELE MATG
				@ 11,36 GET XsCodMat1 PICT "@!"
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape
					EXIT
				ENDIF
				IF UltTecla = F8 &&.OR. EMPTY(XsCodMat1)
					IF !vtabusca("MATG")
						LOOP
					ENDIF
					XsCodMat1= CodMat
				ENDIF
				@ 11,36 SAY XsCodMat1
			CASE i = 5
				GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
				DO lib_mtec WITH 99
				SELE MATG
				@ 11,54 GET XsCodMat2 PICT "@!"
				READ
				UltTecla = LASTKEY()
				IF UltTecla = Escape
					EXIT
				ENDIF
				IF UltTecla = F8 &&.OR. EMPTY(XsCodMat2)
					IF !vtabusca("MATG")
						LOOP
					ENDIF
					XsCodMat2= CodMat
				ENDIF
				@ 11,54 SAY XsCodMat2
			CASE i = 6
				@ 12,36 GET XsAno    PICT "@ 9999"
				READ
				IF LASTKEY() = 27
					EXIT
				ENDIF
			CASE i = 7
				VecOpc(1) = "S¢lo Soles  "
				VecOpc(2) = "S¢lo Dolares"
				XiCodMon=Elige(XiCodMon,13,36,2)
				IF UltTecla = Escape
					RETURN
				ENDIF
			CASE i = 8
				VecOpc(1) = "Con IGV"
				VecOpc(2) = "Sin IGV"
				XiCodIgv=Elige(XiCodIgv,14,36,2)
				IF UltTecla = Escape
					RETURN
				ENDIF
		ENDCASE
		IF i = 8 .AND. UltTecla = Enter
			EXIT
		ENDIF
		i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
		i = IIF(i<1,1,i)
		i = IIF(i>8,8,i)
	ENDDO
	IF UltTecla = Escape
		EXIT
	ENDIF
	** Generamos Registro Final **
	DO xGENERA
	SELE TEMPO
	GO TOP
	IF EOF()
		GsMsgErr = [Fin de Archivo]
		DO lib_merr WITH 99
		LOOP
	ENDIF
	DO xImpre
ENDDO
RETURN
****************
PROCEDURE xImpre
****************
SELE TEMPO
GO TOP
IF XITIPREP = 1
	sNomRep = "VTAR5030"
ELSE
	SNOMREP = "VTAR503A"
ENDIF
Largo   = 66       && Largo de pagina
IniPrn  = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
DO admprint WITH "REPORTS"
RETURN

*****************
PROCEDURE xGENERA
*****************
SELE TEMPO
ZAP
INDEX ON CODCLI+CODMAT TO &Arch.
SET INDEX TO &Arch.
* Barremos Guias
xTCmb = 1
XsCodCli1 = TRIM(XsCodCli1)
XsCodCli2 = TRIM(XsCodCli2)+CHR(255)
xFor = "XsCodCli1<=CodCli.AND.XsCodCli2>=CodCli"
xFor = xFor
XsCodMat1 = TRIM(XsCodMat1)
XsCodMat2 = TRIM(XsCodMat2)+CHR(255)
xFor1 = "XsCodMat1<=CodMat.AND.XsCodMat2>=CodMat"
SELE GDOC
SET FILTER TO YEAR(FCHDOC)=VAL(XSANO)
LLAVE = [Cargo]+[FACT]
SEEK LLAVE
SCAN WHILE TpoDoc=[Cargo] AND CodDoc=[FACT] FOR &xFor
	WAIT "Procesando Documento "+GDOC.CodDoc+[ ]+GDOC.NroDoc WINDOW NOWAIT
	LsCodDoc = GDOC.CodDoc
	LsNroDoc = GDOC.NroDoc
	SELE ITEM
	SEEK LsCodDoc+LsNroDoc
	IF !FOUND()
		DO xGrabR
	ELSE
		SCAN WHILE CodDoc+NroDoc = LsCodDoc+LsNroDoc FOR &xFor1
			DO xGrabR
			SELE TEMPO
			REPLACE CodMat WITH ITEM.CodMat
			REPLACE DesMat WITH ITEM.DesMat
			DO CASE
				CASE MONTH(GDOC.FCHDOC)=1
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES01 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES01 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES01 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES01 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES01 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES01 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=2
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES02 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES02 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES02 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES02 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES02 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES02 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=3
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES03 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES03 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES03 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES03 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES03 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES03 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=4
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES04 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES04 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES04 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES04 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES04 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES04 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=5
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES05 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES05 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES05 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES05 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES05 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES05 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=6
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES06 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES06 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES06 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES06 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES06 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES06 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=7
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES07 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES07 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES07 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES07 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES07 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES07 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=8
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES08 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES08 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES08 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES08 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES08 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES08 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=9
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES09 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES09 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES09 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES09 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES09 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES09 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=10
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES10 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES10 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES10 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES10 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES10 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES10 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=11
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES11 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES11 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES11 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES11 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES11 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES11 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
				CASE MONTH(GDOC.FCHDOC)=12
					IF GDOC.CODMON=XICODMON
						IF XICODIGV=1
							REPLACE MES12 WITH ITEM.ImpLin*1.18
						ELSE
							REPLACE MES12 WITH ITEM.ImpLin
						ENDIF
					ELSE
						IF GDOC.CODMON = 2
							IF XICODIGV = 1
								REPLACE MES12 WITH (ITEM.ImpLin*1.18)*TPOCMB
							ELSE
								REPLACE MES12 WITH (ITEM.ImpLin)*TPOCMB
							ENDIF
						ELSE
							IF XICODIGV=1
								REPLACE MES12 WITH (ITEM.ImpLin*1.18)/TPOCMB
							ELSE
								REPLACE MES12 WITH (ITEM.ImpLin)/TPOCMB
							ENDIF
						ENDIF
					ENDIF
			ENDCASE
			REPLACE UNDSTK WITH ITEM.UNDVTA
			SELE ITEM
		ENDSCAN
	ENDIF
	SELE GDOC
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT
RETURN

*********************************************************************** FIN() *
*Graba resumen cuando es resumen
*********************************************************************** FIN() *
PROCEDURE xGrabR
SELE TEMPO
APPEND BLANK
REPLACE CodCli WITH GDOC->CodCli
REPLACE NomCli WITH GDOC->NomCli
SELE TCMB
SEEK DTOS(GDOC->FchDoc)
IF FOUND()
	xTCmb = IIF(OfiVta>0,OfiVta,GDOC->TpoCmb)
ELSE
	xTCmb = IIF(GDOC->TpoCmb>0,GDOC->TpoCmb,1)
ENDIF
xTCmb = IIF(xTCmb >0,xTCmb ,1)
SELE TEMPO
REPLACE TpoCmb WITH xTCmb
SELE GDOC
RETURN
*********************************************************************** FIN() *

