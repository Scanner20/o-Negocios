**************************************************************************
*  Consultas en general
**************************************************************************
PARAMETER XLookUp

PRIVATE Titulo, TstLin, xoRDER, Sorteo
PRIVATE Xo, Yo, Largo, Ancho, LinReg, Key1, Key2
PRIVATE xOrder1,xOrder2

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
LsNombre  = ''
DO CASE
   CASE XLookUp = "TUND"
        ** Tabla de Movimiento **
        Titulo = " COD.  DESCRIPCION                    "
        LinReg = [Codigo+"  "+NomBre]
        KEY1 = XsTabla
        KEY2 = XsTabla

   CASE XLookUp = "TBFP"
        ** Tabla de Forma de Pago **
        Titulo = "COD. MON           DESCRIPCION                    "
        LinReg = [fmapgo + " " + iif(codmon=1,"S/.","US$") + " " + left(desfpag,67)]

   CASE XLookUp = "0002"
      ** O/C **
      KEY1 = XcTipo
      KEY2 = XcTipo
      Titulo = "NUMERO   FECHA       PROVEEDOR                          "
               *123456 99/99/99 1234567890123456789012345678901234567890
      LinReg = [NroOrd+' '+DTOC(FchOrd)+' '+NomAux]
   CASE XLookUp == "CATG"
      ** MATERIALES GENERALES  **
      GsMsgKey    = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo      = " CODIGO    DESCRIPCION                   UND"
      LinReg      = [CodMat+"  "+DesMat+" "+UndStk]
      Ancho       = LEN( &LinReg ) + 2
      xORDER1     = "MATG01"
      xORDER2     = "MATG02"
      TsTlin      = [!Inactivo]
      Init_Codigo = SPACE(LEN(CATG->CodMat))
      Init_Nombre = SPACE(LEN(CATG->DesMat))
      LsNombre    = SPACE(LEN(CATG->DesMat))
      xFOR        =  [TRIM(LsNombre)$DesMat]
      xWHILE1     = "CodMat"
      xWHILE2     = "DesMat"
      ON KEY LABEL F5 DO XMATGF5
   CASE XLookUp == "CATGF"
        ** MATERIALES GENERALES CLASIFICADOS POR FAMILIAS **
        GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Continuar"
        KEY1    = XsCodFam
        KEY2    = XsCodFam
        TsTlin  = [!Inactivo]
       *SET ORDE TO CATG04
        set orde to catg03
        Titulo  = " DESCRIPCION                             UND CODIGO "
        LinReg  = [DesMat+" "+UndStk+" "+CodMat]
        ON KEY LABEL F5 DO xMATGF
        ON KEY LABEL F4  DO xf4b
   CASE XLookUp = "PCATF"
        ** MATERIALES DE INSUMOS CLASIFICADOS POR FAMILIAS **
        GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
        KEY1    = XsCodFam
        KEY2    = XsCodFam
        xORDER1 = "PCAT01"
        xORDER2 = "PCAT02"
        Init_Codigo = SPACE(LEN(PCAT->CodMat))
        Init_Nombre = SPACE(LEN(PCAT->DesMat))
        Titulo = " DESCRIPCION                             UND CODIGO "
        LinReg = [DesMat+" "+CATG.UndStk+" "+CodMat]
        ON KEY LABEL F5 DO xPCATF
   CASE XLookUp = "MATEGE"
        ** MATERIALES GENERALES CLASIFICADOS POR FAMILIAS **
        GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
        KEY1    = ''
        KEY2    = ''
        SET ORDE TO CATG02
        Titulo = " DESCRIPCION                             UND CODIGO "
        LinReg = [DesMat+" "+UndStk+" "+CodMat]
        ON KEY LABEL F5 DO xMATGG
   CASE XLookUp = "SITUAC"
        ** MATERIALES GENERALES CLASIFICADOS POR FAMILIAS **
        GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
        KEY1    = ''
        KEY2    = ''
        Titulo = " DESCRIPCION   CODIGO "
        LinReg = [Descri+" "+FlgSit+"  "]
      * ON KEY LABEL F5 DO xMATGF
   CASE XLookUp = "CCOSTOS"
      ** CENTROS DE COSTO **
      KEY1 = [9]
      KEY2 = [9]
      TstLin = [AFTMOV="S"]
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "EQUN"
      Key1     = XsUndStk
      Key2     = XsUndStk
      Titulo   = "         UNIDAD DE VENTA = UNIDADES STOCK "
                 * 1 TM  (123456789012345) = 999999.9999 123
      LinReg   = "' 1 '+UndVta+' ('+LEFT(DesVta,15)+') = '+TRANS(FacEqu,'999999.9999')+' '+XsUndStk"
      Ancho    = LEN( &LinReg ) + 2
   CASE XLookUp = "PROV"
      KEY1 = GsClfPro
      KEY2 = GsClfPro
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      SET ORDER TO AUXI02
      Titulo    = "PROVEEDOR        NOMBRE / RAZON SOCIAL            "
                  **1234567  1234567890123456789012345678901234567890
      LinReg    = [CodAux+" "+NomAux]
      ON KEY LABEL F5 DO XPROF5
      ON KEY LABEL F4  DO xf4b
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
      ON KEY LABEL F4  DO xf4b
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
   CASE XLookUp = "DIVF"
      ** Familias **
      KEY1 = '02'
      KEY2 = '02'
      TsTlin = [TipFam=1]
      SET ORDER TO DIVF02
      Titulo = " FAMILIAS                      Cod "
      LinReg = [DesFam+" "+CodFam]
      ON KEY LABEL F5 DO XGENF5
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
   CASE XLookUp = "VORD"
      ** Orden de Compra **
     *SET ORDER TO VORD01
      set order to co_c01
      Titulo = "   O/C          Proveedor         "
      LinReg = [NroOrd+" "+CodAux+" "+LEFT(NomAux,15)]
   CASE XLookUp = "VORI"
      ** Orden de Compra **
     *SET ORDER TO VORD01
      set order to co_c01
      Key1 = [I]
      Key2 = [I]
      Titulo = "   O/C          Proveedor         "
      LinReg = [NroOrd+" "+CodAux+" "+LEFT(NomAux,15)]
   CASE XLookUp = "FLET"
      ** Orden de Compra **
      Titulo = " Codigo         Descripci¢n        Pies  "
      LinReg = [CodFle+" "+DesFle+" "+STR(PieFle,10,2)]
   CASE XLookUp = "VMOV"
        ** Documentos registrados por almacen **
        KEY1 = GsSubAlm+XcTipMov+XsCodMov
        KEY2 = GsSubAlm+XcTipMov+XsCodMov
        SEEK GsSubAlm+XcTipMov+XsCodMov
        LeeReg = FOUND()
        Titulo = " No.Doc.   Fecha  Observaciones           "
        LinReg = [NroOdt+"  "+iif( FlgEst <> 'A',NroDoc+' '+DTOC(FchDoc)+" "+NroRf1,"***  A N U L A D O  ***")]
        Ancho  = LEN(&LinReg) + 4
        NClave = [SubAlm+TipMov+CodMov]
        VClave = GsSubAlm+XcTipMov+XsCodMov
ENDCASE
Ancho = LEN(&LinReg)+2
SAVE SCREEN TO SLookUp
Xo       = 80 - Ancho
DO Lib_MTEC  WITH 99
DO Busca WITH "",Key1,Key2,LinReg,Titulo,Yo,Xo,Largo,Ancho,TstLin
RESTORE SCREEN FROM SLookUp
POP KEY
SET ORDER TO (xoRDER)
RETURN LASTKEY() <> 27
*********************************************************************** EOP() *
PROCEDURE xMATGF
*****************
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,0,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,1 TO 20,34 DOUBLE
STORE SPACE(LEN(DesMat)) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
IF ! EMPTY(LsNombre)
	Localizar = .t.
*!*	   SEEK XsCodFam+TRIM(LsNombre)
*!*	   IF ! FOUND()
*!*	      WAIT  "DATO NO REGISTRADO" NOWAIT WINDOW
*!*	   ENDIF
	SEEK KEY1
    LOCATE WHILE LEFT(CodMat,LEN(XsCodFam))<=Key2 FOR TRIM(LsNombre)$UPPER(DesMat)

   LeeReg = FOUND()
   Listar = LeeReg
   db_Top = .F.
ENDIF
POP KEY
RESTORE SCREEN
RETURN
*********************************************************************** EOP() *
PROCEDURE xMATGG
*****************
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,0,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,1 TO 20,34 DOUBLE
STORE SPACE(LEN(DesMat)) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
IF ! EMPTY(LsNombre)
	SET FILTER TO UPPER(TRIM(LsNombre))$UPPER(DESMAT)
	LOCATE 
*!*	   SEEK TRIM(LsNombre)
*!*	   IF ! FOUND()
*!*	      WAIT  "DATO NO REGISTRADO" NOWAIT WINDOW
*!*	   ENDIF
   LeeReg = FOUND()
   Listar = LeeReg
   db_Top = .F.
ELSE
	SET FILTER TO    
ENDIF
POP KEY
RESTORE SCREEN
RETURN
*****************
PROCEDURE XMATGF5
*****************
SAVE SCREEN
PUSH KEY CLEAR
@ 13,1 CLEAR TO 22,34
@ 14,0,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO &xORDER1
   STORE SPACE(LEN(Init_Codigo)) TO Desde,Hasta
ELSE
   SET ORDER TO &xORDER2
   STORE SPACE(LEN(Init_Nombre)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
Key1   = TRIM(Desde)
Key2   = TRIM(Hasta)
db_Top = .F.
IF ! EMPTY(LsNombre)
   SEEK Key1
   Localizar = .t.
   IF Sorteo = 1
      LOCATE WHILE &xWHILE1.<=Key2 FOR &xFOR
   ELSE
      LOCATE WHILE &xWHILE2.<=Key2 FOR &xFOR.
   ENDIF
   LeeReg = FOUND()
ENDIF
POP KEY
RESTORE SCREEN
RETURN
****************
PROCEDURE XPROF5
****************
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,0,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,2 TO 20,34 DOUBLE
STORE SPACE(LEN(NomAux)) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
IF ! EMPTY(LsNombre)
*   SEEK GsClfPro+TRIM(LsNomBre)
	Localizar = .t.
	SEEK KEY1
    LOCATE WHILE ClfAux<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   dB_Top = .F.
   LeeReg = FOUND()
   Listar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN
****************
PROCEDURE XGENF5
****************
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,0,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,2 TO 20,34 DOUBLE
STORE SPACE(30) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
IF ! EMPTY(LsNombre)
   SEEK KEY1+TRIM(LsNomBre)
   dB_Top = .F.
   LeeReg = FOUND()
   Listar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN
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
db_Top = .F.
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

*************
PROCEDURE xf4b
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
PROCEDURE XPCATF
*****************
SAVE SCREEN
PUSH KEY CLEAR
@ 13,1 CLEAR TO 22,34
@ 14,0,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO &xORDER1
   STORE SPACE(LEN(Init_Codigo)) TO LsNombre
ELSE
   SET ORDER TO &xORDER2
   STORE SPACE(LEN(Init_Nombre)) TO LsNombre
ENDIF
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@S15"
READ
Ciclo = .F.
Key1   = TRIM(LsNombre)
db_Top = .F.
IF !EMPTY(LsNombre)
   SEEK Key1
   Localizar = .t.
   LeeReg = FOUND()
   Listar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN
