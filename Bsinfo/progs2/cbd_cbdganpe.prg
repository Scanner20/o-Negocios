*!* Aperturamos tablas a usar
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV02','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','AUXI','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')
goentorno.open_dbf1('ABRIR','CBDORDEN','ORDN','ORDN01','')
goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','')
goentorno.open_dbf1('ABRIR','ADMTCNFG','CNFG','CNFG01','')

XiCodMon = 1
XiTipo   = 1
XnNivCta = 1
XiMesIni = 1
XiMesFin = _Mes
XsCodCco = " "

DO FORM cbd_cbdganpe
RETURN

*****************
PROCEDURE xGenera
*****************
SELECT ordn
GO TOP
STORE 0 TO XnRbo01,XnRbo02,XnRbo03,XnRbo04,XnRbo05,XnRbo06,XnRbo07,XnRbo08,XnRbo09,XnRbo10,XnRbo11,XnRbo12
STORE 0 TO XnRoo01,XnRoo02,XnRoo03,XnRoo04,XnRoo05,XnRoo06,XnRoo07,XnRoo08,XnRoo09,XnRoo10,XnRoo11,XnRoo12
STORE 0 TO XnRo01,XnRo02,XnRo03,XnRo04,XnRo05,XnRo06,XnRo07,XnRo08,XnRo09,XnRo10,XnRo11,XnRo12
SCAN WHILE !EOF()
	XsCodCta1 = CtaPri
	XsCuentas = Cuentas
	XsQuiebre = Quiebre
	n = 1
	DO CASE
		CASE XsCodCta1 = "LN"
			STORE 0 TO XnMes01,XnMes02,XnMes03,XnMes04,XnMes05,XnMes06,;
					   XnMes07,XnMes08,XnMes09,XnMes10,XnMes11,XnMes12
			MsCodCta = CtaPri
			MsNomCta = " "
			DO xGrabar_Cab
		CASE XsCodCta1 = "RB"
			MsCodCta = CtaPri
			MsNomCta = ORDN.Cuentas
			DO xGrabar_Cab
		CASE XsCodCta1 = "RP"
			MsCodCta = CtaPri
			MsNomCta = ORDN.Cuentas
			DO xGrabar_Cab
		CASE XsCodCta1 = "RO"
			MsCodCta = CtaPri
			MsNomCta = ORDN.Cuentas
			DO xGrabar_Cab
		OTHERWISE 
			SELECT Ctas
			SET FILTER TO NivCta <= VAL(XnNivCta)
			SEEK XsCodCta1
			XsNroMes = XiMesIni
			SCAN WHILE XsCodCta1 = TRIM(CodCta)
				MsCodCta = CodCta
				MsNomcta = NomCta
				DO WHILE XsNroMes <= XiMesFin
					SELECT rmov
					sKey = XsNroMes+TRIM(MsCodCta)
					WAIT WINDOW "Procesando Asiento # " + SUBSTR(NroAst,3,2) + "-" + RIGHT(NroAst,4) NOWAIT
					SEEK sKey
					*!* Para cabeceras
					STORE 0 TO XnMes01,XnMes02,XnMes03,XnMes04,XnMes05,XnMes06,;
							   XnMes07,XnMes08,XnMes09,XnMes10,XnMes11,XnMes12
					SCAN WHILE NroMes <= XiMesFin AND CodCta = TRIM(MsCodCta)
						IF !EMPTY(XsCodCco) && añadidura
							xFor1 = "CodCco=XsCodCco"
						ELSE
							xFor1 = ".T."
						ENDIF
						IF !EVALUATE(xFor1)
							SELECT Rmov
							LOOP
						ENDIF && termino
						IF TpoMov = "H"
							DO CASE
								CASE NroMes = "01"
									XnMes01 = XnMes01 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "02"
									XnMes02 = XnMes02 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "03"
									XnMes03 = XnMes03 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "04"
									XnMes04 = XnMes04 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "05"
									XnMes05 = XnMes05 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "06"
									XnMes06 = XnMes06 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "07"
									XnMes07 = XnMes07 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "08"
									XnMes08 = XnMes08 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "09"
									XnMes09 = XnMes09 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "10"
									XnMes10 = XnMes10 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "11"
									XnMes11 = XnMes11 + IIF(XiCodMon=1,Import,ImpUsa)
								CASE NroMes = "12"
									XnMes12 = XnMes12 + IIF(XiCodMon=1,Import,ImpUsa)
							ENDCASE
						ELSE
							DO CASE
								CASE NroMes = "01"
									XnMes01 = XnMes01 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "02"
									XnMes02 = XnMes02 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "03"
									XnMes03 = XnMes03 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "04"
									XnMes04 = XnMes04 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "05"
									XnMes05 = XnMes05 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "06"
									XnMes06 = XnMes06 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "07"
									XnMes07 = XnMes07 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "08"
									XnMes08 = XnMes08 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "09"
									XnMes09 = XnMes09 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "10"
									XnMes10 = XnMes10 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "11"
									XnMes11 = XnMes11 + IIF(XiCodMon=1,-Import,-ImpUsa)
								CASE NroMes = "12"
									XnMes12 = XnMes12 + IIF(XiCodMon=1,-Import,-ImpUsa)
							ENDCASE
						ENDIF
					ENDSCAN
					DO xGrabar_Cab && Grabamos la cabecera
					XsNroMes = TRANSFORM(VAL(XsNroMes)+1,"@l ##")
				ENDDO
			ENDSCAN
	ENDCASE
ENDSCAN
*!* Ahora vemos el detalle por niveles
DO Veri_deta

*********************
PROCEDURE xGrabar_Cab
*********************
SELECT temporal
xLlave = XsQuiebre + TRANSFORM(n,"@l #####")
SEEK xLlave
IF !FOUND()
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	REPLACE quiebre WITH XsQuiebre
	REPLACE orden   WITH TRANSFORM(n,"@l #####")
	REPLACE CodCta1 WITH MsCodCta
	REPLACE NomCta1 WITH MsNomCta
	REPLACE Mes01   WITH XnMes01
	REPLACE Mes02   WITH XnMes02
	REPLACE Mes03   WITH XnMes03
	REPLACE Mes04   WITH XnMes04
	REPLACE Mes05   WITH XnMes05
	REPLACE Mes06   WITH XnMes06
	REPLACE Mes07   WITH XnMes07
	REPLACE Mes08   WITH XnMes08
	REPLACE Mes09   WITH XnMes09
	REPLACE Mes10   WITH XnMes10
	REPLACE Mes11   WITH XnMes11
	REPLACE Mes12   WITH XnMes12
ELSE
	DO WHILE !RLOCK()
	ENDDO
	REPLACE Mes01   WITH Mes01+XnMes01
	REPLACE Mes02   WITH Mes02+XnMes02
	REPLACE Mes03   WITH Mes03+XnMes03
	REPLACE Mes04   WITH Mes04+XnMes04
	REPLACE Mes05   WITH Mes05+XnMes05
	REPLACE Mes06   WITH Mes06+XnMes06
	REPLACE Mes07   WITH Mes07+XnMes07
	REPLACE Mes08   WITH Mes08+XnMes08
	REPLACE Mes09   WITH Mes09+XnMes09
	REPLACE Mes10   WITH Mes10+XnMes10
	REPLACE Mes11   WITH Mes11+XnMes11
	REPLACE Mes12   WITH Mes12+XnMes12
ENDIF
XnRbo01 = XnRbo01+XnMes01
XnRbo02 = XnRbo02+XnMes02
XnRbo03 = XnRbo03+XnMes03
XnRbo04 = XnRbo04+XnMes04
XnRbo05 = XnRbo05+XnMes05
XnRbo06 = XnRbo06+XnMes06
XnRbo07 = XnRbo07+XnMes07
XnRbo08 = XnRbo08+XnMes08
XnRbo09 = XnRbo09+XnMes09
XnRbo10 = XnRbo10+XnMes10
XnRbo11 = XnRbo11+XnMes11
XnRbo12 = XnRbo12+XnMes12
*!*
XnRoo01 = XnRoo01+XnMes01
XnRoo02 = XnRoo02+XnMes02
XnRoo03 = XnRoo03+XnMes03
XnRoo04 = XnRoo04+XnMes04
XnRoo05 = XnRoo05+XnMes05
XnRoo06 = XnRoo06+XnMes06
XnRoo07 = XnRoo07+XnMes07
XnRoo08 = XnRoo08+XnMes08
XnRoo09 = XnRoo09+XnMes09
XnRoo10 = XnRoo10+XnMes10
XnRoo11 = XnRoo11+XnMes11
XnRoo12 = XnRoo12+XnMes12
*!*
XnRo01 = XnRo01+XnMes01
XnRo02 = XnRo02+XnMes02
XnRo03 = XnRo03+XnMes03
XnRo04 = XnRo04+XnMes04
XnRo05 = XnRo05+XnMes05
XnRo06 = XnRo06+XnMes06
XnRo07 = XnRo07+XnMes07
XnRo08 = XnRo08+XnMes08
XnRo09 = XnRo09+XnMes09
XnRo10 = XnRo10+XnMes10
XnRo11 = XnRo11+XnMes11
XnRo12 = XnRo12+XnMes12
DO CASE
	CASE CodCta1 = "RB"
		REPLACE Mes01 WITH XnRbo01
		REPLACE Mes02 WITH XnRbo02
		REPLACE Mes03 WITH XnRbo03
		REPLACE Mes04 WITH XnRbo04
		REPLACE Mes05 WITH XnRbo05
		REPLACE Mes06 WITH XnRbo06
		REPLACE Mes07 WITH XnRbo07
		REPLACE Mes08 WITH XnRbo08
		REPLACE Mes09 WITH XnRbo09
		REPLACE Mes10 WITH XnRbo10
		REPLACE Mes11 WITH XnRbo11
		REPLACE Mes12 WITH XnRbo12
	CASE CodCta1 = "RP"
		REPLACE Mes01 WITH XnRoo01
		REPLACE Mes02 WITH XnRoo02
		REPLACE Mes03 WITH XnRoo03
		REPLACE Mes04 WITH XnRoo04
		REPLACE Mes05 WITH XnRoo05
		REPLACE Mes06 WITH XnRoo06
		REPLACE Mes07 WITH XnRoo07
		REPLACE Mes08 WITH XnRoo08
		REPLACE Mes09 WITH XnRoo09
		REPLACE Mes10 WITH XnRoo10
		REPLACE Mes11 WITH XnRoo11
		REPLACE Mes12 WITH XnRoo12
	CASE CodCta1 = "RO"
		REPLACE Mes01 WITH XnRo01
		REPLACE Mes02 WITH XnRo02
		REPLACE Mes03 WITH XnRo03
		REPLACE Mes04 WITH XnRo04
		REPLACE Mes05 WITH XnRo05
		REPLACE Mes06 WITH XnRo06
		REPLACE Mes07 WITH XnRo07
		REPLACE Mes08 WITH XnRo08
		REPLACE Mes09 WITH XnRo09
		REPLACE Mes10 WITH XnRo10
		REPLACE Mes11 WITH XnRo11
		REPLACE Mes12 WITH XnRo12
ENDCASE
UNLOCK ALL

*******************
PROCEDURE Veri_deta
*******************
SELECT ORDN
GO TOP
n = 1
SCAN WHILE !EOF()
	DIMENSION xxCodCta(4)
	NumCta = 0
	LsQuiebre  = Quiebre
	LsxxCodCta = ALLTRIM(ORDN.Cuentas)
	DO WHILE .T.
		IF EMPTY(LsxxCodCta)
			EXIT
		ENDIF
		NumCta = NumCta + 1
		IF NumCta > ALEN(xxCodCta)
			DIMENSION xxCodCta(NumCta+5)
		ENDIF
		Z = AT(",",LsxxCodCta)
		IF Z = 0
			Z = LEN(LsxxCodCta) + 1
		ENDIF
		xxCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
		IF Z > LEN(LsxxCodCta)
			EXIT
		ENDIF
		LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
	ENDDO
	XlControl = .F.
	FOR Z = 1 TO NumCta
		XsNroMes1 = XiMesIni
		LsCodCta = xxCodCta(Z)
		LsCodCta = SUBSTR(LsCodCta,2,2)
		IF ORDN.Control ="S"
			XlControl = .T.
		ENDIF
		CsCodCta = ORDN.CtaPri
		SELECT ctas
		SEEK LsCodCta
		SCAN WHILE LEFT(CodCta,2) = LEFT(LsCodCta,2)
			STORE 0 TO XnMes01D,XnMes02D,XnMes03D,XnMes04D,XnMes05D,XnMes06D,;
					   XnMes07D,XnMes08D,XnMes09D,XnMes10D,XnMes11D,XnMes12D
			LsCodCta = TRIM(CTAS.CodCta)
			IF NumCta >= 1
				n = n+1
			ENDIF
			DO WHILE XsNroMes1 <= XiMesFin
				LsNomCta = Ctas.NomCta
				SELECT rmov
				XsLlave = XsNroMes1 + LsCodCta
				SEEK XsLlave
				SCAN WHILE INLIST(CodCta,LsCodCta)
					WAIT WINDOW "Procesando Asiento # " + SUBSTR(RMOV.NroAst,3,2) + "-" + RIGHT(RMOV.NroAst,4) NOWAIT
					IF XlControl
						IF CsCodCta <> LEFT(CodAux,2)
							LOOP
						ENDIF
					ENDIF
					IF !EMPTY(XsCodCco) && añadidura
						xFor1 = "CodCco=XsCodCco"
					ELSE
						xFor1 = ".T."
					ENDIF
					IF !EVALUATE(xFor1)
						SELECT Rmov
						LOOP
					ENDIF && termino
					IF TpoMov = "H"
						DO CASE
							CASE NroMes = "01"
								XnMes01D = XnMes01D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "02"
								XnMes02D = XnMes02D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "03"
								XnMes03D = XnMes03D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "04"
								XnMes04D = XnMes04D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "05"
								XnMes05D = XnMes05D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "06"
								XnMes06D = XnMes06D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "07"
								XnMes07D = XnMes07D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "08"
								XnMes08D = XnMes08D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "09"
								XnMes09D = XnMes09D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "10"
								XnMes10D = XnMes10D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "11"
								XnMes11D = XnMes11D + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "12"
								XnMes12D = XnMes12D + IIF(XiCodMon=1,Import,ImpUsa)
						ENDCASE
					ELSE
						DO CASE
							CASE NroMes = "01"
								XnMes01D = XnMes01D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "02"
								XnMes02D = XnMes02D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "03"
								XnMes03D = XnMes03D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "04"
								XnMes04D = XnMes04D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "05"
								XnMes05D = XnMes05D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "06"
								XnMes06D = XnMes06D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "07"
								XnMes07D = XnMes07D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "08"
								XnMes08D = XnMes08D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "09"
								XnMes09D = XnMes09D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "10"
								XnMes10D = XnMes10D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "11"
								XnMes11D = XnMes11D + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "12"
								XnMes12D = XnMes12D + IIF(XiCodMon=1,-Import,-ImpUsa)
						ENDCASE
					ENDIF
				ENDSCAN
				DO xGrabar_Det
				IF CTAS.NivCta = 4 AND XiTipo = 2 && MAAV para ver el maximo nivel super detalle
					DO xGraba_Documento
				ENDIF
				XsNroMes1 = TRANSFORM(VAL(XsNroMes1)+1,"@l ##")
			ENDDO
			SELECT ctas
			XsNroMes1 = XiMesIni
		ENDSCAN
	ENDFOR
ENDSCAN

*********************
PROCEDURE xGrabar_Det
*********************
SELECT temporal
xLlave = LsQuiebre + TRANSFORM(n,"@l #####")
SEEK xLlave
IF !FOUND()
	APPEND BLANK
	DO WHILE !RLOCK()
	ENDDO
	REPLACE quiebre WITH LsQuiebre
	REPLACE orden   WITH TRANSFORM(n,"@l #####")
	REPLACE CodCta2 WITH LsCodCta
	REPLACE NomCta2 WITH LsNomCta
	REPLACE Mes01D  WITH XnMes01D
	REPLACE Mes02D  WITH XnMes02D
	REPLACE Mes03D  WITH XnMes03D
	REPLACE Mes04D  WITH XnMes04D
	REPLACE Mes05D  WITH XnMes05D
	REPLACE Mes06D  WITH XnMes06D
	REPLACE Mes07D  WITH XnMes07D
	REPLACE Mes08D  WITH XnMes08D
	REPLACE Mes09D  WITH XnMes09D
	REPLACE Mes10D  WITH XnMes10D
	REPLACE Mes11D  WITH XnMes11D
	REPLACE Mes12D  WITH XnMes12D
ELSE
	DO WHILE !RLOCK()
	ENDDO
	REPLACE Mes01D  WITH Mes01+XnMes01D
	REPLACE Mes02D  WITH Mes02+XnMes02D
	REPLACE Mes03D  WITH Mes03+XnMes03D
	REPLACE Mes04D  WITH Mes04+XnMes04D
	REPLACE Mes05D  WITH Mes05+XnMes05D
	REPLACE Mes06D  WITH Mes06+XnMes06D
	REPLACE Mes07D  WITH Mes07+XnMes07D
	REPLACE Mes08D  WITH Mes08+XnMes08D
	REPLACE Mes09D  WITH Mes09+XnMes09D
	REPLACE Mes10D  WITH Mes10+XnMes10D
	REPLACE Mes11D  WITH Mes11+XnMes11D
	REPLACE Mes12D  WITH Mes12+XnMes12D
ENDIF
UNLOCK ALL

*******************
PROCEDURE xGenera_d
*******************
SELECT ordn
GO TOP
STORE 0 TO XnRbo01,XnRbo02,XnRbo03,XnRbo04,XnRbo05,XnRbo06,XnRbo07,XnRbo08,XnRbo09,XnRbo10,XnRbo11,XnRbo12
STORE 0 TO XnRoo01,XnRoo02,XnRoo03,XnRoo04,XnRoo05,XnRoo06,XnRoo07,XnRoo08,XnRoo09,XnRoo10,XnRoo11,XnRoo12
STORE 0 TO XnRo01,XnRo02,XnRo03,XnRo04,XnRo05,XnRo06,XnRo07,XnRo08,XnRo09,XnRo10,XnRo11,XnRo12
SCAN WHILE !EOF()
	XsCodCta1 = CtaPri
	XsCuentas = Cuentas
	XsQuiebre = Quiebre
	n = 1
	DO CASE
		CASE XsCodCta1 = "LN"
			STORE 0 TO XnMes01,XnMes02,XnMes03,XnMes04,XnMes05,XnMes06,;
					   XnMes07,XnMes08,XnMes09,XnMes10,XnMes11,XnMes12
			MsCodCta = CtaPri
			MsNomCta = " "
			DO xGrabar_Cab
		CASE XsCodCta1 = "RB"
			MsCodCta = CtaPri
			MsNomCta = ORDN.Cuentas
			DO xGrabar_Cab
		CASE XsCodCta1 = "RP"
			MsCodCta = CtaPri
			MsNomCta = ORDN.Cuentas
			DO xGrabar_Cab
		CASE XsCodCta1 = "RO"
			MsCodCta = CtaPri
			MsNomCta = ORDN.Cuentas
			DO xGrabar_Cab
		OTHERWISE 
			SELECT Ctas
			SET FILTER TO NivCta <= VAL(XnNivCta)
			SEEK XsCodCta1
			XsNroMes = XiMesIni
			SCAN WHILE XsCodCta1 = TRIM(CodCta)
				MsCodCta = CodCta
				MsNomcta = NomCta
				SELECT rmov
				sKey = XsNroMes+TRIM(MsCodCta)
				WAIT WINDOW "Procesando Asiento # " + SUBSTR(NroAst,3,2) + "-" + RIGHT(NroAst,4) NOWAIT
				SEEK sKey
				*!* Para cabeceras
				STORE 0 TO XnMes01,XnMes02,XnMes03,XnMes04,XnMes05,XnMes06,;
						   XnMes07,XnMes08,XnMes09,XnMes10,XnMes11,XnMes12
				SCAN WHILE NroMes <= XiMesIni AND CodCta = TRIM(MsCodCta)
					IF !EMPTY(XsCodCco) && añadidura
						xFor1 = "CodCco=XsCodCco"
					ELSE
						xFor1 = ".T."
					ENDIF
					IF !EVALUATE(xFor1)
						SELECT Rmov
						LOOP
					ENDIF && termino
					IF TpoMov = "H"
						DO CASE
							CASE NroMes = "01"
								XnMes01 = XnMes01 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "02"
								XnMes02 = XnMes02 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "03"
								XnMes03 = XnMes03 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "04"
								XnMes04 = XnMes04 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "05"
								XnMes05 = XnMes05 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "06"
								XnMes06 = XnMes06 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "07"
								XnMes07 = XnMes07 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "08"
								XnMes08 = XnMes08 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "09"
								XnMes09 = XnMes09 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "10"
								XnMes10 = XnMes10 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "11"
								XnMes11 = XnMes11 + IIF(XiCodMon=1,Import,ImpUsa)
							CASE NroMes = "12"
								XnMes12 = XnMes12 + IIF(XiCodMon=1,Import,ImpUsa)
						ENDCASE
					ELSE
						DO CASE
							CASE NroMes = "01"
								XnMes01 = XnMes01 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "02"
								XnMes02 = XnMes02 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "03"
								XnMes03 = XnMes03 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "04"
								XnMes04 = XnMes04 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "05"
								XnMes05 = XnMes05 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "06"
								XnMes06 = XnMes06 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "07"
								XnMes07 = XnMes07 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "08"
								XnMes08 = XnMes08 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "09"
								XnMes09 = XnMes09 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "10"
								XnMes10 = XnMes10 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "11"
								XnMes11 = XnMes11 + IIF(XiCodMon=1,-Import,-ImpUsa)
							CASE NroMes = "12"
								XnMes12 = XnMes12 + IIF(XiCodMon=1,-Import,-ImpUsa)
						ENDCASE
					ENDIF
				ENDSCAN
				DO xGrabar_Cab && Grabamos la cabecera
				XsNroMes = TRANSFORM(VAL(XsNroMes)+1,"@l ##")
			ENDSCAN
	ENDCASE
ENDSCAN
*!* Ahora vemos el detalle por niveles
DO Veri_deta

**************************
PROCEDURE xGraba_Documento
**************************
SELECT RMOV
XsLlave_Mov = TRIM(XsNroMes1) + LsCodCta
SEEK XsLlave_Mov
SCAN WHILE NroMes + CodCta = XsLlave_Mov
	LsNroAst = NroAst
	LsCodOpe = CodOpe
	XnRegAct = RECNO()
	XlLlave = TRIM(XsNroMes1) + "121"
	DsQuiebre = Temporal.Quiebre
	DnOrden   = VAL(temporal.orden)
	SEEK XlLlave
	SCAN WHILE NroMes + CodCta = XlLlave
		IF LsNroAst = NroAst AND LsCodOpe = CodOpe
			SELECT temporal
			WAIT WINDOW "Grabando Detalle asiento Nro. "+SUBSTR(LsNroAst,3,2)+"-"+RIGHT(LsNroAst,4) NOWAIT
			APPEND BLANK
			replace Quiebre WITH DsQuiebre
			replace Orden  WITH TRANSFORM(DnOrden+1,"@l #####")
			replace FchDoc WITH rmov.FchDoc
			replace NroAst WITH rmov.NroAst
			replace NroDoc WITH rmov.NroDoc
			replace GloDoc WITH rmov.GloDoc
			n = n + 1
		ENDIF
	ENDSCAN
	SELECT rmov
	GO XnRegAct
ENDSCAN