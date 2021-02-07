#INCLUDE CONST.H
*** Abrimos Bases ****
goentorno.open_dbf1('ABRIR','CBDACMCT','ACCT','ACCT01','')
goentorno.open_dbf1('ABRIR','CBDMCTAS','CTAS','CTAS01','')
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO MAYOR"
UltTecla = 0
INC = 0   && SOLES

XiCodMon = 1
XnNivCta = 2
XsSolMov = 'S'
XsCtaDes = SPACE(LEN(CTAS->CodCta))
XsCtaHas = SPACE(LEN(CTAS->CodCta))
XnMes	= _MES
XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv

DO FORM cbd_cbdrl005
RETURN

******************
PROCEDURE Imprimir
******************
SELE CTAS
IF XnNivCta = 1
	SET ORDER TO CTAS02
	SEEK '1'+TRIM(XsCtaDes)
ELSE
	SET ORDER TO CTAS01
	SEEK TRIM(XsCtaDes)
ENDIF
XsCtaHas = LEFT(TRIM(XsCtaHas)+"zzzzzzzzzz",LEN(CODCTA))

*** Pantalla de datos  ***

DO F0PRINT
IF UltTecla = k_esc
	RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ENDIF
Ancho = 145
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = Largo - 6
IniImp  = _PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = ""
IF XiCodMon=1
	En1 = "(EXPRESADO EN SOLES)" &&+TRIM(VECOPC(XiCodMon))+")"
ELSE
	En1 = "(EXPRESADO EN DOLARES)" &&+TRIM(VECOPC(XiCodMon))+")"
ENDIF
SubTitulo= "LIBRO MAYOR ANALITICO AL MES DE "+MES(XnMES,1)+" "+TRANS(_ANO,"9999")
En2 = " "
IF XnCodDiv>0
	En2 = vDivision(XnCodDiv)
ENDIF
En3 = ""
En4 = ""
En5 = ""
En6 = "*********** ************************************* ******************************* ******************************* *******************************"
En7 = "  CODIGO                                          --------  SALDO ANTERIOR ------ ----- MOVIMIENTO DEL MES ------ --------  SALDO ACTUAL --------"
En8 = "  CUENTA       DESCRIPCION                                DEBITO          CREDITO            DEBE           HABER         DEBITO         CREDITO "
En9 = "*********** ************************************* *************** *************** *************** *************** *************** ***************"

NumCol = 8
DIMENSION X(NumCol),Y(NumCol),Z(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
   xNivel  = 1
   NumPag  = 0
   xCodCta = LEFT(CodCta,2)
   STORE 0 TO X,Y,Z
   DO WHILE CodCta<=XsCtaHas .AND. ! EOF() .AND. ! Cancelar
	   	** VETT  01/05/2018 11:57 PM : Validar la divisionaria en el plan de cuentas - IDUPD: _56W00FFP5
		IF !GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**' && No utiliza divisionaria
		ELSE
			IF CodCta_B=XsCodDiv
			ELSE
				SELECT CTAS
				SKIP
				LOOP	
			ENDIF
		ENDIF
		** VETT  02/05/2018 12:12 AM :  - IDUPD: _56W00FFP5 
      IF NivCta<=XnNivCta
         DO LinImp
      ENDIF
      SELECT CTAS
      SKIP
      IF XnNivCta = 1 .AND. NivCta > 1
         EXIT
      ENDIF
      Cancelar = Cancelar .OR. (INKEY() = k_esc)
   ENDDO
   IF ! CANCELAR
      DO TotImp
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN &&IN ADMPRINT
RETURN

****************
PROCEDURE LinImp
****************
PRIVATE NumLin
IF NivCta=1
   Tb = 0
ELSE
   TB = 1
ENDIF

Store 0 TO X
GoSvrCbd.CBDAcumd(Ctas->CodCta , 0 , XnMes)
SELEC CTAS

IF XsCodDiv=[**]  && Consolidado
	SalAnt =  XvCalc(6+INC) - XvCalc(3+INC)
	IF SalAnt > 0
	   X(1) = SalAnt
	ELSE
	   X(2) = -SalAnt
	ENDIF
	X(3)   = XvCalc(1+INC)
	X(4)   = XvCalc(2+INC)
	SalAct = XvCalc(6+INC)
	X(7)   = XvCalc(4+INC)
	X(8)   = XvCalc(5+INC)
ELSE
	SalAnt =  XvCalc_D(XnCodDiv,6+INC) - XvCalc_D(XnCodDiv,3+INC)
	IF SalAnt > 0
	   X(1) = SalAnt
	ELSE
	   X(2) = -SalAnt
	ENDIF
	X(3)   = XvCalc_D(XnCodDiv,1+INC)
	X(4)   = XvCalc_D(XnCodDiv,2+INC)
	SalAct = XvCalc_D(XnCodDiv,6+INC)
	X(7)   = XvCalc_D(XnCodDiv,4+INC)
	X(8)   = XvCalc_D(XnCodDiv,5+INC)
ENDIF

IF SalAct > 0
   X(5) = SalAct
ELSE
   X(6) = -SalAct
ENDIF

IF (X(7)  = 0  .AND. X(8)  = 0) .AND. XsSolMov = 'S'
   RETURN
ENDIF
DO ResetPag
IF xNivel <> NivCta
   NumLin = PROW()+1                           && Linea Actual
   @ NumLin,0 SAY ""
   xNivel = NivCta
ENDIF
IF CodCta = xCodCta
   NumLin = PROW()+1                           && Linea Actual
ELSE
   NumLin = PROW()+2                           && Linea Actual
ENDIF
IF NivCta = 1 .AND. XnNivCta > 1
   @ NumLin,TB SAY _Prn6a
ENDIF
xCodCta = LEFT(CodCta,2)
@ NumLin,Tb    SAY CodCta
@ NumLin,12    SAY NomCta   PICT "@S35"
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY X(i)   PICT "@Z 9999,999,999.99"
    IF NivCta = 1
       Y(I) = Y(I) + X(I)
    ENDIF
ENDFOR
IF NivCta = 1 .AND. XnNivCta > 1
   @ NumLin,Ancho-1 SAY _Prn6b
ENDIF
RETURN

**********************************************************************
PROCEDURE TotImp
****************
PRIVATE NumLin
NumLin = PROW() + 1
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY "---------------"
ENDFOR
NumLin = PROW()+1                           && Linea Actual
@ Numlin,25  SAY "TOTAL GENERAL"
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY Y(i)   PICT "@Z 9999,999,999.99"
ENDFOR
NumLin = PROW() + 1
FOR I=1 TO 6
    Col = (i-1)*16 + 50
    @ Numlin,Col SAY "==============="
ENDFOR
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0
	DO F0MBPRN &&IN ADMPRINT
	IF UltTecla = k_esc
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
