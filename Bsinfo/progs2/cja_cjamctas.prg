SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')

RELEASE LoDatAdm
DO def_teclas IN FxGen_2

SELECT CTAS

SET FILTER TO AFTMOV="S"
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
*** Pintamos pantalla *************
cTit3 = GsNomCia
cTit4 = []
cTit2 = "Usuario : "+TRIM(GsUsuario)
cTit1 = "CUENTAS DE CAJA Y BANCOS"
Do FONDO WITH cTit1,cTit2,cTit3,cTit4

@ 7,4 FILL  TO 20,74      COLOR W/N
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
@ 18,5 SAY "³  Cuenta de Descuento..........:                                     ³" COLOR SCHEME 11
@ 19,5 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 11
VECOPC(1) = " ***** CUENTAS DE CREDITO ******** "
VECOPC(2) = " ***** CUENTAS DE AHORRO  ******** "
VECOPC(3) = " ***** CUENTAS EN EFECTIVO ******* "
xElige = Elige(1,7,17,3)
IF LASTKEY() = escape_
	CLEAR
	CLEAR MACROS
	IF WEXIST('__WFONDO')
		RELEASE WINDOWS __WFONDO
	ENDIF
	DO close_file IN CCB_CCBAsign
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
CLEAR
CLEAR MACROS
*RESTORE SCREEN  FROM LsPant_Act
IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
DO close_file IN CCB_CCBAsign
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
DO WHILE ! INLIST(UltTecla,escape_)
	zCodCta = SUBSTR(XsCodCta,4)
	@ 08,17 SAY cCodCta
	@ 08,20 GET zCodCta PICTURE REPLICATE("9",LEN(XsCodCta)-3)
	READ
	UltTecla = LASTKEY()
	IF UltTecla = escape_
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
	IF INLIST(UltTecla,Enter,escape_,F10,CtrlW)
		EXIT
	ENDIF
ENDDO
IF UltTecla = escape_
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
@ 18,40  SAY CtaDes

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
DO WHILE ! INLIST(UltTecla,CTRLW,escape_,F10,PgUp,PgDn)
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
			IF LastKey() = escape_
				EXIT
			ENDIF
			IF LastKey() = k_F8
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
			@ 18,40 GET XsCtaDes PICT "@!"
			READ
			UltTecla = LASTKEY()
*			IF UltTecla = F8
*				IF !CBDBUSCA("CTAX")
*					LOOP
*				ENDIF
*				XsCtaDes = CodCta
*				UltTecla = Enter
*			ENDIF
			@ 18,40 SAY  XsCtaDes
		CASE i = 9
			IF UltTecla = Enter
				UltTecla = CtrlW
			ENDIF
			i = 0
	ENDCASE
	i = IIF(UltTecla = k_F_Arr, i-1, i+1)
	i = IIF(i>09,09, i)
	i = IIF(i<1 , 1, i)
ENDDO
SELECT CTAS
IF UltTecla <> escape_
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
REPLACE CtaDes WITH XsCtaDes
SELE CTAS
UNLOCK ALL
RETURN
