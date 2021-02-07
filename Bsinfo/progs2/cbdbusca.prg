**************************************************************************
*  Consultas en general
**************************************************************************
PARAMETER XLookUp
PRIVATE Titulo, TstLin, xoRDER, Sorteo
PRIVATE Xo, Yo, Largo, Ancho, LinReg, Key1, Key2

GsMsgKey = "[Teclas de Cursor] Buscar   [Enter] Aceptar   [Esc] Cancelar"
PUSH KEY CLEAR

STORE "" TO Desde,Hasta,LsNombre
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

   CASE XLookUp = [DIVF]
      Titulo    = [CODIGO      FAMILIA    ]
      LinReg    = [CodFam+' '+DesFam]
      Ancho     = LEN( &LinReg ) + 2
      KEY1      = [02]
      KEY2      = [02]

   CASE XLookUp = "AUXI"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Cont. Busca"
      KEY1      = XsClfAux
      KEY2      = XsClfAux
      LnNomAux= 60
      Titulo    = PADR("Nombre/Razon Social",LnNomAux)+" C¢digo"
      LinReg    = [LEFT(NomAux,LnNomAux)+" "+CodAux]
      Ancho     = LEN( &LinReg ) + 2
      ON KEY LABEL F5 DO XAUXF5
      SET ORDER TO AUXI02

   CASE XLookUp = "OPER"
      Titulo    = "OPERACION   DESCRIPCION"
      LinReg    = [CodOpe+" "+NomOpe]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "FINA"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar"
      KEY1      = XsClfAux
      KEY2      = XsClfAux
      Titulo    = "COD      DESCRIPCION      "
      LinReg    = [CODAUX+"  "+SUBSTR(NOMAUX,1,20)]
      Ancho     = LEN( &LinReg ) + 2
      SET ORDER TO AUXI02

   CASE XLookUp = "CTAS"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [AFTMOV="S"]
      ON KEY LABEL F5 DO XCTAF5
   CASE XLookUp == "CTA10"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = []
      ON KEY LABEL F5 DO XCTAF5

   CASE XLookUp = "CTA2"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [(AFTMOV="S")]
      Key1      = "104"
      Key2      = "108"
      
      ON KEY LABEL F5 DO XCTAF5
   CASE XLookUp = "CTA10X"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar "
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [CodCta='10' AND NivCta=2]
      
   CASE XLookUp = "CTAXXX"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar "
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [NivCta=2]   
      
   CASE XLookUp = "DPRO"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "Nro.   Fecha   Auxiliar                        F.Recep.  "
      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+CodAux+" "+NomAux+" "+FchRec]
      Ancho     = LEN( &LinReg ) + 2
      Key1      = XsNroMes+XsCodOpe
      Key2      = XsNroMes+XsCodOpe
      ON KEY LABEL F5 DO XDPROF5

   CASE XLookUp = "CTA9"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+SPACE(LEN(trim(CodCta))*2)+" "+NomCta]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [LEN(TRIM(CodCta))>2]
      Key1      = "91"
      Key2      = "93"

   CASE XLookUp = "PROV"
      Titulo    = "DOC.      DESCRIPCION                       OPER"
      LinReg    = [TpoDoc+" "+NotAst+" "+CodOpe]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "FNZA"
      Titulo    = "DOCM        DESCRIPCION            "
      LinReg    = [TpoDoc+"  "+SUBSTR(NotAst,1,30)]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "MCTA"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      ON KEY LABEL F5 DO XCTAF5

   CASE XLookUp = "CTAX"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [AFTMOV="S"]
      Key1      = cCodCta
      Key2      = cCodCta

   CASE XLookUp = "TABL"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Cont. Busca"
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
	  SET ORDER TO TABL02
   CASE XLookUp = "MDLO"
      LinReg   = "CodMod+' '+NotAst"
      Ancho    = LEN( &LinReg ) + 2
      Titulo   = "MODELOS DE ASIENTOS"
  CASE XLookUp = "PPRE"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar "
      Titulo    = "CODIGO    NOMBRE"
      LinReg    = [CtaPRE+" "+LEFT(Nombre,40)]
      Ancho     = LEN( &LinReg ) + 2
*!*		  SET ORDER TO PPRE02
      SET ORDER TO PPRE01   && CTAPRE
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
PROCEDURE XCTAF5
****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(NomCta))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
Localizar = .f.
STORE SPACE(LEN(CodCta)) TO Desde,Hasta
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
READ
Ciclo = .F.
Key1   = TRIM(Desde)
Key2   = TRIM(Hasta)
POP KEY
RESTORE SCREEN
RETURN

****************
PROCEDURE XAUXF5
****************
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,1,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,2 TO 20,34 DOUBLE
STORE SPACE(LEN(NomAux)) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
IF ! EMPTY(LsNombre)
   SEEK XsClfAux+TRIM(LsNomBre)
   dB_Top = .F.
   LeeReg = FOUND()
   Listar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN


*************
PROCEDURE XF4
*************
IF ! Localizar
   RETURN
ENDIF
CONTINUE
IF FOUND()
   Listar = .t.
ELSE
  ?? CHR(7)
ENDIF

*****************
PROCEDURE XTABL5
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
****************
PROCEDURE XDPROF5
****************
SAVE SCREEN
PUSH KEY CLEAR
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
Localizar = .f.
STORE SPACE(LEN(NroDoc)) TO xDesde,xHasta
@ 17,4  SAY "Desde : " GET xDesde  PICT "@!S10"
@ 18,4  SAY "Hasta : " GET xHasta  PICT "@!S10"
READ
Ciclo = .F.
Key1   = XsNroMes+XsCodOpe+TRIM(xDesde)
Key2   = XsNroMes+XsCodOpe+TRIM(xHasta)
POP KEY
RESTORE SCREEN
RETURN
