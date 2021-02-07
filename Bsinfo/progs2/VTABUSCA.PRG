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
DO CASE
   CASE XLookUp = "0001"
      ** Compa¤ias **
      Titulo = " CODIGO   COMPA¥IAS                      "
      LinReg = [RIGHT("000"+LTRIM(STR(RECNO(),3,0)),3)+"     "+NomCia]
   CASE XLookUp = "0002"
      ** PEDIDOS PENDIENTES **
      KEY1 = [E]
      KEY2 = [E]
      Titulo = "NUMERO   FECHA       CLIENTE                            "
               *123456 99/99/99 1234567890123456789012345678901234567890
      SET ORDER TO VPED03
      SET RELA TO GsClfAux+CodCli INTO CLIE
      LinReg = [NroDoc+' '+DTOC(FchDoc)+' '+NomCli]
   CASE XLookUp = "0003"
      ** TABLA DE UNIDADES **
      KEY1 = XsTabla
      KEY2 = XsTabla
      Titulo = "CODIGO      DESCRIPCION         "
               * 123   1234567890123456789012345
      LinReg = [' '+Codigo+'   '+Nombre]

   CASE XLookUp = "CP"
      ** CODIGO POSTAL **
      KEY1 = XsTabla
      KEY2 = XsTabla
      Titulo = "CODIGO      DESCRIPCION         "
               * 123   1234567890123456789012345
      LinReg = [' '+Codigo+'   '+Nombre]

      ON KEY LABEL F5 DO XTABF5
   CASE XLookUp = "0004"
      ** PUNTOS DE VENTA**
      KEY1 = XsCodDoc
      KEY2 = XsCodDoc
      Titulo = "PTOVTA CORREL."
               * 123   1234567
      LinReg = [' '+PtoVta+'   '+TRANS(NroDoc,'9999999')]
   CASE XLookUp = "0005"
      ** CORRELATIVOS POR PUNTOS DE VENTA **
      KEY1 = XsCodDoc+XsPtoVta
      KEY2 = XsCodDoc+XsPtoVta
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+DTOC(FchDoc)+' '+CLIE->NomAux]
   CASE XLookUp = "0006"
      ** SUB-ALMACENES **
      Titulo = " ALMACEN     DESCRIPCION               "
               *   123   123456789012345678901234567890
      LinReg = ['   '+SubAlm+'   '+DesSub]
   CASE XLookUp = "0007"
      ** MATERIALES POR PEDIDO **
      KEY1 = XsNroPed
      KEY2 = XsNroPed
      Titulo = " CODIGO       DESCRIPCION                            SALDO   UND"
               *12345678 1234567890123456789012345678901234567890 999,999.99 123
      LinReg = [CodMat+' '+LEFT(MATG->DesMat,40)+' '+TRANS(CanPed-CanDes,'999,999.99')+' '+UndVta]
   CASE XLookUp = "0008"
      ** CORRELATIVOS FACTURAS/BOLETAS POR PUNTOS DE VENTA **
      KEY1 = XsTpoDoc+XsCodDoc+XsPtoVta
      KEY2 = XsTpoDoc+XsCodDoc+XsPtoVta
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+DTOC(FchDoc)+' '+CLIE->NomAux]
   CASE XLookUp = "0009"
      ** CORRELATIVOS DE GUIAS **
      KEY1 = XsCodDoc
      KEY2 = XsCodDoc
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+DTOC(FchDoc)+' '+CLIE->NomAux]
   CASE XLookUp = "0010"
      ** PEDIDOS PENDIENTES POR CLIENTE **
      SET ORDER TO VPED02
      KEY1 = XsCodCli+[E]
      KEY2 = XsCodCli+[E]
      Titulo = "NUMERO   FECHA "
               *123456 99/99/99
      LinReg = [NroDoc+' '+DTOC(FchDoc)]
   CASE XLookUp = "0011"
      ** # de Lotes ACTIVOS **
      Key1     = [E]+XsCodMat
      Key2     = [E]+XsCodMat
      Titulo = "  LOTE  STATUS"
               **123456   1
      LinReg = [TRANS(Lote,'999999')+'   '+FlgEst+'   ']
   CASE XLookUp = "0012"
      ** PEDIDOS POR CLIENTE **
      KEY1 = XsCodCli
      KEY2 = XsCodCli
      Titulo = "NUMERO   FECHA "
               *123456 99/99/99
      LinReg = [NroDoc+' '+DTOC(FchDoc)]
   CASE XLookUp = "0013"
      ** CORRELATIVOS FACTURAS/BOLETAS POR PUNTOS DE VENTA **
      KEY1 = XsTpoDoc+XsCodDoc+XsPtoVta
      KEY2 = XsTpoDoc+XsCodDoc+XsPtoVta
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+DTOC(FchDoc)+' '+CLIE->NomAux]
   CASE XLookUp = "0014"
      ** G/R PENDIENTES DE FACTURAR **
      SET ORDER TO VGUI05
      KEY1 = XsCodRef+[E]
      KEY2 = XsCodRef+[E]
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+DTOC(FchDoc)+' '+NomCli]
   CASE XLookUp = "0015"
      ** PEDIDOS **
      Titulo = "NUMERO   FECHA       CLIENTE                            "
               *123456 99/99/99 1234567890123456789012345678901234567890
      LinReg = [NroDoc+' '+DTOC(FchDoc)+' '+NomCli]
      TsTlin = [FLGFAC#"F"]
   CASE XLookUp = "CLIE"
      KEY1 = GsClfAux
      KEY2 = GsClfAux
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = " CLIENTE         NOMBRE / RAZON SOCIAL            "
                  **1234567  1234567890123456789012345678901234567890
      LinReg    = [CodAux+" "+NomAux]
      ON KEY LABEL F5 DO XCLIF5
      ON KEY LABEL F4 DO XTABL5
   CASE XLookUp = "MATGF"
      ** MATERIALES GENERALES CLASIFICADOS POR FAMILIAS **
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      KEY1    = XsCodFam
      KEY2    = XsCodFam
      xORDER1 = "MATG01"
      xORDER2 = "MATG02"
      Init_Codigo = SPACE(LEN(MATG->CodMat))
      Init_Nombre = SPACE(LEN(MATG->DesMat))
      LsNombre    = SPACE(LEN(MATG->DesMat))
      xFOR        =  [TRIM(LsNombre)$DesMat]
      xWHILE1     = "CodMat"
      xWHILE2     = "DesMat"
      Titulo = " CODIGO    DESCRIPCION                STOCK    UND"
      LinReg = [CodMat+"  "+DesMat+" "+TRASN(StkAct,"999,999")+" "+UndStk]
      ON KEY LABEL F5 DO xMATGF
   CASE XLookUp = "MATG"
      ** MATERIALES GENERALES  **
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      KEY1    = []
      KEY2    = []
      xORDER1 = "MATG01"
      xORDER2 = "MATG02"
      Init_Codigo = SPACE(LEN(MATG->CodMat))
      Init_Nombre = SPACE(LEN(MATG->DesMat))
      LsNombre    = SPACE(LEN(MATG->DesMat))
      xFOR        =  [TRIM(LsNombre)$DesMat]
      xWHILE1     = "CodMat"
      xWHILE2     = "DesMat"
      Titulo = " CODIGO    DESCRIPCION             STOCK      UND"
      LinReg = [CodMat+"  "+DesMat+" "+TRANS(StkAct,"999,999")+" "+UndStk]
      ON KEY LABEL F5 DO xMATGF
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
   CASE XLookUp = "UVTA"
      Key1     = XsUndStk
      Key2     = XsUndStk
      Titulo   = "         UNIDAD DE VENTA = UNIDADES STOCK "
                 * 1 TM  (123456789012345) = 999999.9999 123
      LinReg   = "' 1 '+UndVta+' ('+LEFT(DesVta,15)+') = '+TRANS(FacEqu,'999999.9999')+' '+XsUndStk"
      Ancho    = LEN( &LinReg ) + 2
   CASE XLookUp = "TUND"
      ** Tabla de Movimiento **
      Titulo = " COD.  DESCRIPCION                    "
      LinReg = [Codigo+"  "+NomBre]
      KEY1 = XsTabla
      KEY2 = XsTabla
   CASE XLookUp = "SER1"
      ** Tabla de Series     **
      Titulo = " CODIGO ART.    No. SERIE    "
      LinReg = [CodMat+"  "+Codele ]
      KEY1 = 'D'+XsCodMat
      KEY2 = 'D'+XsCodMat
   CASE XLookUp = "GUI2"
      ** CORRELATIVOS DE GUIAS **
      SET ORDER TO VGUI04
      KEY1 = XsCodCli+[E]+[G/R ]
      KEY2 = XsCodCli+[E]+[G/R ]
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+TpoGui+' '+DTOC(FchDoc)+' '+LEFT(NomCli,30)]
   CASE XLookUp = "FAC2"
      ** CORRELATIVOS DE GUIAS **
      KEY1 = [Cargo]+[FACT]
      KEY2 = [Cargo]+[FACT]
      Titulo = "  NUMERO      FECHA         CLIENTE                          "
               *123-4567890 99/99/99 1234567890123456789012345678901234567890
      LinReg = [TRANS(NroDoc,'@R 999-9999999')+' '+FlgEst+' '+DTOC(FchDoc)+' '+NomCli]
ENDCASE
Ancho = LEN(&LinReg.)+2
Titulo = LEFT(Titulo+SPACE(8),LEN(&LinReg.))
SAVE SCREEN TO SLookUp
Xo       = 80 - Ancho
DO Lib_MTEC  WITH 99
DO Busca WITH "",Key1,Key2,LinReg,Titulo,Yo,Xo,Largo,Ancho,TstLin
RESTORE SCREEN FROM SLookUp
POP KEY
SET ORDER TO (xoRDER)
RETURN LASTKEY() <> 27
RETURN
*********************************************************************** EOP() *


PROCEDURE XTABF5
SET ORDER TO TABL02
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,0,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,2 TO 20,34 DOUBLE
STORE SPACE(LEN(NomBRE)) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@S15"
READ
Ciclo = .F.
IF ! EMPTY(LsNombre)
   LOCATE FOR UPPER(ALLTRIM(LsNomBre))$UPPER(TABL->NOMBRE)
   dB_Top = .F.
   LeeReg = FOUND()
   Listar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN

PROCEDURE XCLIF5
****************
SET ORDER TO AUXI02
SAVE SCREEN
PUSH KEY CLEAR
@ 18,1 CLEAR TO 20,34
@ 19,0,21,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 18,2 TO 20,34 DOUBLE
STORE SPACE(LEN(NomAux)) TO LsNombre
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@S15"
READ
Ciclo = .F.
IF ! EMPTY(LsNombre)
  SEEK GsClfAux+UPPER(TRIM(LsNomBre))
  *LOCATE FOR UPPER(ALLTRIM(LsNombre))$UPPER(NOMAUX)
   dB_Top = .F.
   LeeReg = FOUND()
   Listar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN
*****************
PROCEDURE xMATGF
*****************
SAVE SCREEN
PUSH KEY CLEAR
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
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
@ 17,4  SAY "Desde : " GET Desde  PICT "@S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@S15"
READ
Ciclo = .F.
Key1   = TRIM(Desde)
Key2   = TRIM(Hasta)
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
@ 17,4  SAY "Desde : " GET Desde  PICT "@S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@S15"
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
