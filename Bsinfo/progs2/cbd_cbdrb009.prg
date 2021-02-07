#INCLUDE CONST.H
DIMENSION SAC(6,12)
dimension tac(2,12)
*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDMTABL','TABL','TABL01','')
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
goentorno.open_dbf1('ABRIR','CBDTPERN','TBAL','TPER01','')
goentorno.open_dbf1('ABRIR','CBDNPERN','NBAL','NPER01','')
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "PERDIDAS Y GANACIAS"
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1
XiMesIni = 1
XiMesFin = _Mes
XsCodBal = "01"

DO FORM cbd_cbdrb009
RETURN

******************
PROCEDURE Imprimir
******************
XsNomBal = ALLTRIM(TABL.Nombre)
DO F0PRINT
IF UltTecla = K_ESC
	RETURN
ENDIF

IF ! CARGA()
	RETURN
ENDIF

SELECT TBAL
UNLOCK ALL

Ancho = 255
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN

*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = 88 - 8
IniImp  = _PRN4+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
IF XiMesFin < 12
	LdFecha   = CTOD("01/"+STR(XiMesFin+1,2,0)+"/"+STR(_Ano,4,0)) - 1
ELSE
	LdFecha  = CTOD("31/12/"+STR(_Ano,4,0))
ENDIF
Titulo  = XsNomBal+" al "+STR(DAY(LdFecha),2)+" de "+Mes(XiMesFin,3)+" de "+str(_ano,4)
IF XiCodMon=1
	SubTitulo = "(EXPRESADO EN SOLES" &&+TRIM(VECOPC(XiCodMon))+")"
ELSE
	SubTitulo = "(EXPRESADO EN DOLARES" &&+TRIM(VECOPC(XiCodMon))+")"
ENDIF

En2 = "<HORA : "+TIME()
En1 = ""
En3 = ""
En4 = ""
En5 = ""
En6 = ""
En7 = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En8 = "     CUENTAS - CONCEPTOS                ENERO          FEBRERO             MARZO           ABRIL              MAYO            JUNIO           JULIO          AGOSTO         SETIEMBRE          OCTUBRE         NOVIEMBRE    "
En9 = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En7 =En7+"-----------------------------------"
En8 =En8+"   DICIEMBRE       ACUMULADO       "
En9 =En9+"-----------------------------------"

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dimension totpor(13)
ltotpor = .T.

Cancelar = .F.
SELECT TBAL
Pos1 = 50
Pos2 = 71
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
	SEEK XsCodBal
	Inicio = .T.
	NumPag  = 0
	STORE 0 TO SAC,tac
	DO WHILE ! EOF() .AND. Rubro = XsCodBal
		DO ResetPag
		NumLin = PROW() + 1
		DO LinImp
		SKIP
	ENDDO
	NumLin = PROW() + 1
	EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT
RETURN

****************
PROCEDURE LinImp
****************
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
SEEK XsCodBal
DO WHILE Rubro = XsCodBal .AND. ! EOF()
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
XsCodRef = TRIM(CodRef)
IF !EMPTY(CodRef)
	XsCodCta=TRIM(XsCodCta)
ENDIF
XcForma  = Forma
SELECT ACCT
FOR TnMes=XiMesIni  TO  XiMesFin
	xLLave = STR(TnMes,2,0)+XsCodCta
	SEEK xLlave
	XS=0
	XD=0
	DO WHILE (NroMes+CodCta = xLLave ) .AND. ! EOF()
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
	SOLES(TnMes + 1)  =SOLES(TnMes + 1)   + XS
	DOLARES(TnMes + 1)=DOLARES(TnMes + 1) + XD
ENDFOR
RETURN

***************
PROCEDURE GRABA
***************
SELECT TBAL
LNMES=0
LNMES=1
DO WHILE LNMES<=12
	Campo1="MesS"+TRANSF(LnMes,"@L ##")
	Campo2="MesD"+TRANSF(LnMes,"@L ##")
	REPLACE &Campo1 WITH 0
	REPLACE &Campo2 WITH 0
	LNMES=LNMES+1
ENDDO
FOR TnMes=XiMesIni TO  XiMesFin
	Campo1="MesS"+TRANSF(TnMes,"@L ##")
	Campo2="MesD"+TRANSF(TnMes,"@L ##")
	REPLACE &Campo1 WITH Soles(TnMes + 1)
	REPLACE &Campo2 WITH Dolares(TnMes + 1)
ENDFOR
RETURN
