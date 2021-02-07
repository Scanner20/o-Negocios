SELE 0
USE CBDMAUXI order auxi01 ALIAS AUXI
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE CBDMTABL order TABL01 ALIAS TABL
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE CBDMCTAS order CTAS01 ALIAS CTAS
IF ! USED()
	CLOSE DATA
	RETURN
ENDIF
SET FILTER TO AFTMOV="S"
ARCTMP=PATHUSER+SYS(3)
COPY REST TO (ARCTMP) WITH CDX
**** Variables *****
XiCodMon=CodMon
XsCodRef=CodRef
XsCodBco=CodBco
XsNroCta=NroCta
XcFlgBco=FlgBco
XsSecBco=SecBco
XsRefBco=RefBco
XsNroChq=NroChq
XsCtaCob=CtaCob
XsCtaDes=CtaDes
XsCtaDe1=CtaDe1
XsCtaGas=CtaGas
XsCtaInt=CtaInt
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = []
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS DE CAJA Y BANCOS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

@  7,4 FILL  TO 22,74      COLOR W/N
@  6,5 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 11
@  7,5 SAY "³                                                                     ³" COLOR SCHEME 11
@  8,5 SAY "³  C¢digo :                                                           ³" COLOR SCHEME 11
@  9,5 SAY "³  Nombre :                                                           ³" COLOR SCHEME 11
@ 10,5 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" COLOR SCHEME 11
@ 11,5 SAY "³  Nro. de Cheque Vigente.......:                                     ³" COLOR SCHEME 11
@ 12,5 SAY "³  Banco........................:                                     ³" COLOR SCHEME 11
@ 13,5 SAY "³  Nro de Cuenta................:                                     ³" COLOR SCHEME 11
@ 14,5 SAY "³  Moneda de la Cuenta .........:                                     ³" COLOR SCHEME 11
@ 15,5 SAY "³  Sectorista...................:                                     ³" COLOR SCHEME 11
@ 16,5 SAY "³  Acotaci¢n....................:                                     ³" COLOR SCHEME 11
@ 17,5 SAY "³  Cuenta de Cobranza...........:                                     ³" COLOR SCHEME 11
@ 18,5 SAY "³  Cuenta de Gastos Cobranza....:                                     ³" COLOR SCHEME 11
@ 19,5 SAY "³  Cuenta de Intereses Cobranza.:                                     ³" COLOR SCHEME 11
@ 20,5 SAY "³  Cuenta de Descuento..........:                                     ³" COLOR SCHEME 11
@ 21,5 SAY "³  Cuenta de Orden Descuento....:                                     ³" COLOR SCHEME 11
@ 22,5 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 11
VECOPC(1) = " ***** CUENTAS DE CREDITO ******** "
VECOPC(2) = " ***** CUENTAS DE AHORRO  ******** "
VECOPC(3) = " ***** CUENTAS EN EFECTIVO ******* "
xElige = Elige(1,7,17,3)
IF LASTKEY() = Escape
	CLOSE DATA
	RETURN
ENDIF
DO CASE
CASE xElige = 1
	LsCodCta = "104"
CASE xElige = 2
	LsCodCta = "108"
CASE xElige = 3
	LsCodCta = "101"
ENDCASE

**********************************************************************
** Rutina principal *****
**********************************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
DO EDITA WITH 'Llave','Muestra','Editar','Elimina','','CodCta',LsCodCta,'M'
CLOSE DATA
CLEAR
RETURN
*********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE Llave
****************
GsMsgKey = "[Esc] Cancela         [Enter] [F10] Acepta         [F8] Consulta "
DO LIB_MTEC WITH 99
cCodCta = zClave
XsCodCta = PADR(cCodCta,LEN(CodCta))
UltTecla = 0
i        = 1
DO WHILE ! INLIST(UltTecla,Escape)
	zCodCta = SUBSTR(XsCodCta,4)
	@ 08,17 SAY cCodCta
	@ 08,20 GET zCodCta PICTURE REPLICATE("9",LEN(XsCodCta)-3)
	READ
	UltTecla = LASTKEY()
	IF UltTecla = Escape
		EXIT
	ENDIF
	XsCodCta = cCodCta+zCodCta
	IF UltTecla = F8
		IF ! CBDBUSCA("CTAX")
			LOOP
		ENDIF
		XsCodCta = CodCta
		UltTecla = Enter
	ENDIF
	SEEK XsCodCta
	IF ! FOUND()
		GsMsgErr = "Cuenta no Registrada"
		DO LIB_MERR WITH 99
		UltTecla = 0
		LOOP
	ENDIF
	IF AFTMOV="N"
		GsMsgErr = "Cuenta no Afecta a Movimiento"
		DO LIB_MERR WITH 99
		UltTecla = 0
		LOOP
	ENDIF
	@ 08,17 SAY XsCodCta
	@ 09,17 SAY NomCta
	IF INLIST(UltTecla,Enter,Escape,F10,CtrlW)
		EXIT
	ENDIF
ENDDO
IF UltTecla = Escape
	GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
	DO LIB_MTEC WITH 99
ENDIF
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE Muestra
*****************
@  8,17  SAY CodCta
@  9,17  SAY NomCta
IF xElige = 1
	@ 11,40 SAY NroChq
ENDIF
=SEEK("04"+CodBco,"TABL")
@ 12,40  SAY CodBco+" "+TABL->Nombre SIZE 1,33
@ 13,40  SAY NroCta
@ 14,40  SAY IIF(CodMon=1    ,"Nuevos Soles       ","Dolares Americanos")
@ 15,40  SAY SecBco
@ 16,40  SAY RefBco
@ 17,40  SAY CtaCob
@ 18,40  SAY CtaGas
@ 19,40  SAY CtaInt
@ 20,40  SAY CtaDes
@ 21,40  SAY CtaDe1
RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE EDITAR
****************
GsMsgKey = "[] [] [Enter] Registra [F10] Graba [Esc] Cancela"
DO LIB_MTEC WITH 99
DO TOMA
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,CTRLW,ESCAPE,F10,PgUp,PgDn)
	DO CASE
		CASE i = 1
			IF xElige = 1
				@ 11,40 GET  XsNroChq     PICTURE "@!"
				READ
				UltTecla = LASTKEY()
			ELSE
				UltTecla = Enter
			ENDIF
			@ 11,40 SAY  XsNroChq
		CASE i = 2
			XsTabla = "04"
			@ 12,40 GET  XsCodbco     PICTURE "@!"
			READ
			UltTecla = LastKey()
			IF LastKey() = Escape
				EXIT
			ENDIF
			IF LastKey() = F8
				SELECT TABL
				IF ! CBDBUSCA("TABL")
					LOOP
				ENDIF
				SELECT CTAS
				XsCODBCO = LEFT(TABL->CODIGO,LEN(XsCODBCO))
			ENDIF
			IF ! SEEK(XsTabla+XsCodbco,"TABL")
				GsMsgErr = "Banco no registrado"
				DO LIB_MERR WITH 99
				LOOP
			ENDIF
			@ 12,40 SAY XsCodBco+" "+TABL->Nombre SIZE 1,33
		CASE i = 3
			@ 13,40 GET  XsNroCta     PICTURE "@!"
			READ
			UltTecla = LASTKEY()
			@ 13,40 SAY  XsNroCta     PICTURE "@!"
		CASE i = 4
			VecOpc(1) = "Nuevos Soles      "
			VecOpc(2) = "Dolares Americanos"
			XiCodMon=Elige(XiCodMon,14,40,2)
		CASE i = 5
			@ 15,40 GET  XsSecbco
			READ
			UltTecla = LASTKEY()
			@ 15,40 SAY  XsSecBco
		CASE i = 6
			@ 16,40 GET  XsRefbco PICT "@!"
			READ
			UltTecla = LASTKEY()
			@ 16,40 SAY  XsRefBco
		CASE i = 7
			@ 17,40 GET XsCtaCob PICT "@!"
			READ
			UltTecla = LASTKEY()
*			IF UltTecla = F8
*				IF !CBDBUSCA("CTAX")
*					LOOP
*				ENDIF
*				XsCtaCob = CodCta
*				UltTecla = Enter
*			ENDIF
			@ 17,40 SAY  XsCtaCob
		CASE i = 8
			@ 18,40 GET XsCtaGas PICT "@!"
			READ
			UltTecla = LASTKEY()
*			IF UltTecla = F8
*				IF !CBDBUSCA("CTAX")
*					LOOP
*				ENDIF
*				XsCtaGas = CodCta
*				UltTecla = Enter
*			ENDIF
			@ 18,40 SAY  XsCtaGas
		CASE i = 9
			@ 19,40 GET XsCtaInt PICT "@!"
			READ
			UltTecla = LASTKEY()
*			IF UltTecla = F8
*				IF !CBDBUSCA("CTAX")
*					LOOP
*				ENDIF
*				XsCtaInt = CodCta
*				UltTecla = Enter
*			ENDIF
			@ 19,40 SAY  XsCtaInt
		CASE i = 10
			@ 20,40 GET XsCtaDes PICT "@!"
			READ
			UltTecla = LASTKEY()
*			IF UltTecla = F8
*				IF !CBDBUSCA("CTAX")
*					LOOP
*				ENDIF
*				XsCtaDes = CodCta
*				UltTecla = Enter
*			ENDIF
			@ 20,40 SAY  XsCtaDes
		CASE i = 11
			@ 21,40 GET XsCtaDe1 PICT "@!"
			READ
			UltTecla = LASTKEY()
*			IF UltTecla = F8
*				IF !CBDBUSCA("CTAX")
*					LOOP
*				ENDIF
*				XsCtaDe1 = CodCta
*				UltTecla = Enter
*			ENDIF
			@ 21,40 SAY  XsCtaDe1
		CASE i = 12
			IF UltTecla = Enter
				UltTecla = CtrlW
			ENDIF
			i = 0
	ENDCASE
	i = IIF(UltTecla = Arriba, i-1, i+1)
	i = IIF(i>12,12, i)
	i = IIF(i<1 , 1, i)
ENDDO
SELECT CTAS
IF UltTecla <> Escape
   DO GRABA
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
RETURN

*************************************************************************** FIN
* Procedimiento de CARGA A VARIABLES
******************************************************************************
PROCEDURE TOMA
**************
XiCodMon=CodMon
XsCodRef=CodRef
XsCodBco=CodBco
XsNroCta=NroCta
XcFlgBco=FlgBco
XsSecBco=SecBco
XsRefBco=RefBco
XsNroChq=NroChq
XsCtaCob=CtaCob
XsCtaDes=CtaDes
XsCtaDe1=CtaDe1
XsCtaGas=CtaGas
XsCtaInt=CtaInt
RETURN

*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE GRABA
***************
IF ! RLOCK()
	RETURN
ENDIF
REPLACE CodMon WITH XiCodMon
REPLACE CodRef WITH XsCodRef
REPLACE CodBco WITH XsCodBco
REPLACE NroCta WITH XsNroCta
REPLACE FlgBco WITH XcFlgBco
REPLACE NroChq WITH XsNroChq
REPLACE SecBco WITH XsSecBco
REPLACE RefBco WITH XsRefBco
REPLACE CtaCob WITH XsCtaCob
REPLACE CtaGas WITH XsCtaGas
REPLACE CtaInt WITH XsCtaInt
REPLACE CtaDes WITH XsCtaDes
REPLACE CtaDe1 WITH XsCtaDe1
SELE CTAS
UNLOCK ALL
RETURN
