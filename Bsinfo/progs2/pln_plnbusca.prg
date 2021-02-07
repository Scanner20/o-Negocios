**************************************************************************
*  Consultas en general
**************************************************************************
PARAMETER XLookUp
PRIVATE Titulo, TstLin, xoRDER, Sorteo
PRIVATE Xo, Yo, Largo, Ancho, LinReg, Key1, Key2

GsMsgKey = "[Teclas de Cursor] Buscar   [Enter] Aceptar   [Esc] Cancelar"
PUSH KEY CLEAR

xoRDER   = ORDER()
Key1     = ""
Key2     = ""
Sorteo   = 1
Yo       = 8
Largo    = 14
LinReg   = ""
Ancho    = 2
Titulo   = ""
TstLin   = ""
Localizar = .F.

DO CASE
	CASE XLookUp == "TMOV"
		Titulo    = "C¢d.      Concepto"
		LinReg    = [CodMov+" "+DesMov]
		TstLin    = [CODMOV>"A" .AND. RIGHT(CODMOV,2)#"00"]
		Ancho     = LEN( &LinReg ) + 2
	CASE XLookUp == "TMOV1"
		Key1      = XcTpoMov
		Key2      = XcTpoMov
		Titulo    = "C¢d.    --Concepto"
		LinReg    = [CodMov+" "+DesMov]
		Ancho     = LEN( &LinReg ) + 2
	CASE XLookUp = "BPGO"
		Titulo    = "C¢d.      Concepto"
		LinReg    = [TRANSF(NROITM,"@L ###")+" "+CodMov+" "+TMOV->DesMov]
		Ancho     = LEN( &LinReg ) + 2
	CASE XLookUp = "PERS"
		GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
		Titulo    = "C¢digo      Nombre"
		LinReg    = [CodPer+" "+NomBRE()]
		Ancho     = LEN( &LinReg ) + 2
		ON KEY LABEL F5 DO XPERF5
		ON KEY LABEL F4  DO XF4
	CASE XLookUp = "TABL"
		GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
		SEEK "00"+XsTabla
		nDigitos = IIF(Digitos>0,Digitos,LEN(Codigo))
		STORE SPACE(nDigitos) TO Desde,Hasta,LsNombre
		Key1     = XsTabla
		Key2     = XsTabla
		LinReg   = "LEFT(Codigo,nDigitos)+' '+LEFT(Nombre,30)"
		Ancho    = LEN( &LinReg ) + 2
		Titulo   = PADC(TRIM(Nombre),Ancho-2)
		ON KEY LABEL F5 DO XTABL5
		ON KEY LABEL F4  DO XF4
	CASE XLookUp = "TAB"
		GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
		SEEK XsTabla
		Key1      = XsTabla
		Key2      = XsTabla
		Titulo    = "C¢digo    -*-  Descripcion "
		LinReg    = [CodIgo  +" "+NomBre]
		Ancho     = LEN( &LinReg ) + 2
		ON KEY LABEL F5 DO XTABL5
		ON KEY LABEL F4  DO XF4
	OTHER
		RETURN .F.
ENDCASE
SAVE SCREEN TO SLookUp
Xo       = 80-Ancho
DO Lib_MTEC  WITH 99
DO Busca WITH "",Key1,Key2,LinReg,Titulo,Yo,Xo,Largo,Ancho,TstLin
RESTORE SCREEN FROM SLookUp
POP KEY
SET ORDER TO (xoRDER)
RETURN LASTKEY() <> 27

****************
PROCEDURE XPERF5
****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(NomPer))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
	SET ORDER TO PERS01
	STORE SPACE(LEN(CodPer)) TO Desde,Hasta
ELSE
	SET ORDER TO PERS02
	STORE SPACE(LEN(NomPer)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
Key1   =  TRIM(Desde)
Key2   =  TRIM(Hasta)
IF ! EMPTY(LsNombre)
	SEEK Key1
	IF Sorteo = 1
		LOCATE WHILE CODPER<=Key2 FOR TRIM(LsNombre)$UPPER(NomPer)
	ELSE
		LOCATE WHILE NOMPER<=Key2 FOR TRIM(LsNombre)$UPPER(NomPer)
	ENDIF
	LeeReg = FOUND()
ENDIF
POP KEY
RESTORE SCREEN
RETURN

*************
PROCEDURE XF4
*************
IF ! Localiza
	RETURN
ENDIF
CONTINUE
IF FOUND()
	Listar = .t.
ELSE
	?? CHR(7)
ENDIF

*****************
PROCEDURE XTABLF5
*****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(Nombre))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
	SET ORDER TO TABL01
	STORE SPACE(nDigitos) TO Desde,Hasta
ELSE
	SET ORDER TO TABL02
	STORE SPACE(LEN(Nombre)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
Key1   = XsTabla + TRIM(Desde)
Key2   = XsTabla + TRIM(Hasta)
SET STEP ON
IF ! EMPTY(LsNombre)
	SEEK Key1
	Localizar = .t.
	IF Sorteo = 1
		LOCATE WHILE TABLA+CODIGO<=Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
	ELSE
		LOCATE WHILE TABLA+NOMBRE<=Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
	ENDIF
	LeeReg = FOUND()
ENDIF
POP KEY
RESTORE SCREEN
RETURN
