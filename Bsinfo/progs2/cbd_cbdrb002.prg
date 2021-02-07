#INCLUDE CONST.H
*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','') 
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ESTADO FINANCIERO - BALANCE GENERAL"
UltTecla = 0
INC = 0   && SOLES
XiCodMon=1
EXTERNAL ARRAY XvCalc

DO FORM cbd_cbdrb002
RETURN

******************
PROCEDURE Imprimir
******************
SELE CTAS
DO F0PRINT
IF UltTecla = 27
	RETURN
ENDIF
IF XiCodMon = 2
	INC = 6
ENDIF
Ancho   = 162
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
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(GdFecha)
Tit_IDER = "HORA :"+TIME() 
Tit_IIZQ2 = "RUC:"+GsRucCia
Titulo    = "ESTADO FINANCIERO - BALANCE GENERAL"
SubTitulo = "AL MES "+MES(_MES,1)+" "+TRANS(_ANO,"9999")
IF XiCodmon=1
	En1 = "SOLES"
	**En1 = TRIM(VECOPC(XiCodMon))
ELSE
	En1 = "DOLARES"
	**En1 = TRIM(VECOPC(XiCodMon))
ENDIF
En2 = " "
En3 = ""
En4 = ""
En5 = ""
En6 = "****************************************** ***************************** ***************************** ***************************** *****************************"
En7 = "CUENTA                                              S U M A S                  SALDOS SUB-CTAS                SALDO 3 DIGITOS               SALDO DE CUENTAS      "
En8 = "  SUBCTA     N O M B R E                        DEBE          HABER          DEUDOR        ACREEDOR        DEUDOR        ACREEDOR         DEUDOR        ACREEDOR  "
En9 = "****************************************** ************** ************** ************** ************** ************** ************** ************** **************"
       *************************************** 41************ 56************ 71************ 86************ 101*********** 116*********** 131*********** 146***********
***
NumCol = 4
DIMENSION vU[NumCol],vV[NumCol],vW[NumCol],vX[NumCol],vY[NumCol],vZ[NumCol]
Cancelar = .F.
SET DEVICE TO PRINT
SET MARGIN TO 0
XfDebe  = 0
XfHaber = 0
PRINTJOB
	Inicio = .T.
	STORE 0 TO vU,vV,vW,vX,vY,vZ
	SEEK "10"
	NumPag  = 0
	QUIEBRE = 0
	Titn1   = ""
	FOR X = 1 TO 5
		=QUIEBRE()
		Inicio = .T.
		TiTULO1 = Titn1
		DO ResetPag
		NumLin= PROW() + 1
		@ NumLin,9 say _Prn7a
		@ NumLin,9 say TITULO1
		NumLin= PROW() + 1
		@ NumLin,9 say _Prn7b
		STORE 0 TO vW
		DO WHILE ! EOF() .AND. QUIEBRE() = X
			DO LINIMP
			SELECT CTAS
		ENDDO
		DO ResetPag
		NumLin = PROW() + 1
		FOR i = 1 to 4
			Col = 43 + (i-1)*15
			IF I > 2
				Col = Col + 4*15
			ENDIF
			@ Numlin,Col SAY REPLICATE("-",14)
		NEXT
		NumLin = PROW() + 1
		@ Numlin,0   SAY _prn6a
		@ Numlin,0   SAY "TOTAL "+TITULO1    PICT "@S42"
		FOR i = 1 to 4
			Col = 43 + (i-1)*15
			IF I > 2
				Col = Col + 4*15
			ENDIF
			@ Numlin,Col SAY PICNUM(vW(i))
			vV(I) = vV(I) + vW(I)
		NEXT
		NumLin = PROW() + 1
		FOR i = 1 to 4
			Col = 43 + (i-1)*15
			IF I > 2
				Col = Col + 4*15
			ENDIF
			@ Numlin,Col SAY REPLICATE("*",14)
		NEXT
		@ Numlin,00 SAY _prn6b
		IF X = 3 .OR. X = 5
			DO ResetPag
			NumLin = PROW() + 1
			@ Numlin,0   SAY _prn6a
			IF X = 3
				@ Numlin,0   SAY "* TOTAL ACTIVO *"  PICT "@S42"
			ELSE
				@ Numlin,0   SAY "* TOTAL PASIVO *"  PICT "@S42"
			ENDIF
			FOR i = 1 to 4
				Col = 43 + (i-1)*15
				IF I > 2
					Col = Col + 4*15
				ENDIF
				@ Numlin,Col SAY PICNUM(vV(i))
				vU(I) = vU(I) + vV(I)
			NEXT
			NumLin = PROW() + 1
			FOR i = 1 to 4
				Col = 43 + (i-1)*15
				IF I > 2
					Col = Col + 4*15
				ENDIF
				@ Numlin,Col SAY REPLICATE("*",14)
			NEXT
			NumLin = PROW() + 1
			@ Numlin,0   SAY _prn6b
			STORE 0 TO vV
		ENDIF
	ENDFOR
	NumLin = PROW() + 1
	@ Numlin,0   SAY _prn6a
	@ Numlin,0   SAY "*** UTILIDAD DEL EJERCICIO ***" PICT "@S42"
	SALDO = vU(4) - vU(3)
	IF SALDO < 0
		Col = 43 + (7-1)*15
		@ Numlin,Col SAY PICNUM(-SALDO)
	ELSE
		Col = 43 + (8-1)*15
		@ Numlin,129 SAY PICNUM( SALDO)
	ENDIF
	NumLin = PROW() + 1
	@ Numlin,0   SAY _prn6b
	EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT
RETURN
****************
PROCEDURE LinImp
****************
CodCta1 = LEFT(CodCta,2)
STORE 0 TO vZ,vY,vX
NOMCta1 = ""
NroItm1 = 0
DO WHILE CodCta = CodCta1 .and. ! EOF() .AND. ! Cancelar
   CodCta2 = LEFT(CodCta,3)
   NomCta2 = ""
   NroItm2 = 0
   STORE 0 TO vY
   DO WHILE CodCta = CodCta2 .and. ! EOF() .AND. ! Cancelar
      IF CODCTA = PADR(CodCta1,LEN(CODCTA))
         NomCta1 = NomCta
      ENDIF
      IF CODCTA = PADR(CodCta2,LEN(CODCTA))
         NomCta2 = NomCta
      ENDIF
      IF AftMov # "S"
         SKIP
         LOOP
      ENDIF
      GoSvrCbd.CBDACUMD(CodCta,0, _Mes)
      SELECT CTAS
      vX(1) = Xvcalc(4+INC)
      vX(2) = Xvcalc(5+INC)
      IF Xvcalc(6+INC) >= 0
         vX(3) =  Xvcalc(6+INC)
         vX(4) =  0
      ELSE
         vX(3) = 0
         vX(4) = -Xvcalc(6+INC)
      ENDIF
      IF vX(1) = 0 .AND. vX(2) = 0
         SKIP
         LOOP
      ENDIF
      DO ResetPag
      NroItm2 = NroItm2 + 1
      NumLin = PROW() + 1
      @ Numlin,01 SAY CodCta
      @ Numlin,10 SAY Nomcta               PICT "@S32"
      FOR i = 1 to 4
          Col = 43 + (i-1)*15
          @ Numlin,Col SAY PICNUM(vX(i))
          vY(I) = vY(I) + vX(I)
      NEXT
      SKIP
   ENDDO
   IF NroItm2 > 0
      DO ResetPag
      NumLin = PROW() + 2
      NroItm1 = NroItm1 + 1
      @ Numlin,00  SAY _PRN6a
      @ Numlin,00  SAY CodCta2
      @ Numlin,08  SAY Nomcta2             PICT "@S32"
      FOR i = 1 to 4
          Col = 43 + (i-1)*15
          IF I > 2
             Col = Col + 2*15
          ENDIF
          @ Numlin,Col SAY PICNUM(vY(i))
          vZ(I) = vZ(I) + vY(I)
      NEXT
      NumLin = PROW() + 1
      @ Numlin,00 SAY _prn6b
   ENDIF
ENDDO
IF NroItm1 > 0
   DO ResetPag
   NumLin = PROW() + 2
   @ Numlin,00  SAY _PRN6a
   @ Numlin,00  SAY CodCta1
   @ Numlin,08  SAY Nomcta1             PICT "@S32"
   FOR i = 1 to 4
       Col = 43 + (i-1)*15
       IF I > 2
          Col = Col + 4*15
       ENDIF
       @ Numlin,Col SAY PICNUM(vZ(i))
       vW(I) = vW(I) + vZ(I)
   NEXT
   NumLin = PROW() + 1
   Col = 43 + (8-1)*15
   Saldo = (vZ(3)-vZ(4))
   IF Saldo > 0
      Col = 43 + (7-1)*15
      @ Numlin,Col SAY PICNUM(Saldo)
    ELSE
      Col = 43 + (8-1)*15
      @ Numlin,Col SAY PICNUM(-Saldo)
	ENDIF



   NumLin = PROW() + 1
   @ Numlin,00 SAY _PRN6b
ENDIF
Cancelar = (Inkey()=27)
RETURN
*****************
PROCEDURE QUIEBRE
*****************
DO CASE
	CASE left(CodCta,2) >= '10' .and. left(Codcta,2) < '20'
		TiTn1 = "ACTIVOS CORRIENTES"
		QUIEBRE = 1
	CASE left(Codcta,2) >= '20' .and. left(Codcta,2) < '30'
		TiTn1 = "ACTIVO CTA. EXISTENCIAS"
		QUIEBRE = 2
	CASE left(Codcta,2) >= '31' .and. left(Codcta,2) <= '39'
		TiTn1 = "ACTIVOS NO CORRIENTE"
		QUIEBRE = 3
	CASE left(Codcta,2) >= '40' .and. left(Codcta,2) <= '49'
		TiTn1 = "PASIVO CORRIENTE"
		QUIEBRE = 4
	CASE left(Codcta,2) >= '50' .and. left(Codcta,2) <= '59'
		TiTn1 = "PASIVO NO CORRIENTE Y PATRIMONIO"
		QUIEBRE = 5
	OTHER
		QUIEBRE = 0
ENDCASE
RETURN QUIEBRE
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
	Inicio  = .F.
	DO F0MBPRN &&IN ADMPRINT
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
****************
PROCEDURE PICNUM
****************
PARAMETER Valor
RETURN TRANSF( Valor,"@Z 999,999,999.99")
IF Valor<0
	RETURN TRANSF(-Valor,"@Z 99,999,999.99")+"-"
ELSE
	RETURN TRANSF( Valor,"@Z 99,999,999.99")+" "
ENDIF